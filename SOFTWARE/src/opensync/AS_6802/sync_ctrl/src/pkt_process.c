#include "../include/pkt_process.h"
#include "../include/basic_fun.h"
extern global_param_set gp_param;
extern sm_param_set sm_param;
extern cm_param_set cm_param;
unsigned int get_device_id(u8* pkt, tte_sync_context* context_table[], u32 table_size)
{
    for (int i = 0; i < table_size; i++)
    {
        //print_mac(pkt+6);
        //print_mac(context_table[i]->dev_info->dmac);
        if(maccmp(pkt + 6, context_table[i]->dev_info->dmac) == 0)
        {
            return context_table[i]->device_id; 
        }
    }
    return -1;
}


void pkt_process(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    if (context->dev_info->sync_clock_role == ROLE_CM)
    {
        cm_pkt_proc(pkt, context, timer, libnet_handle);           
    }
    else if (context->dev_info->sync_clock_role == ROLE_SM)
    {
        sm_pkt_proc(pkt, context, timer, libnet_handle);
    }
}


void sm_pkt_proc(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    switch (context->sm_info->cur_state)
    {
    case SM_INTEGRATE:
        pkt_proc_sm_integrate(pkt, context, timer, libnet_handle);
        break;
    case SM_SYNC:
        pkt_proc_sm_sync(pkt, context, timer, libnet_handle);
        break;
    case SM_FLOOD:
        pkt_proc_sm_flood(pkt, context, timer, libnet_handle);
        break;
    case SM_UNSYNC:
        pkt_proc_sm_unsync(pkt, context, timer, libnet_handle);
        break;
    case SM_STABLE:
        pkt_proc_sm_stable(pkt, context, timer, libnet_handle);
        break;
    case SM_TENTATIVE_SYNC:
        pkt_proc_sm_tentative_sync(pkt, context, timer, libnet_handle);
        break;
    case SM_WAIT_4_CS_CS:
        pkt_proc_sm_wait4cs_cs(pkt, context, timer, libnet_handle);
        break;
    default:
        break;
    }
}

void cm_pkt_proc(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    switch (context->cm_info->cur_state)
    {
    case CM_INTEGRATE:
        pkt_proc_cm_integrate(pkt, context, timer, libnet_handle);
        break;
    case CM_SYNC:
        pkt_proc_cm_sync(pkt, context, timer, libnet_handle);
        break;
    case CM_UNSYNC:
        pkt_proc_cm_unsync(pkt, context, timer, libnet_handle);
        break;
    case CM_WAIT_4_IN:
        pkt_proc_cm_wait4_in(pkt, context, timer, libnet_handle);
        break;
    case CM_ENABLE:
        pkt_proc_cm_enable(pkt, context, timer, libnet_handle);
        
        break;
    default:
        break;
    }
}

void cm_pkt_parse(u8* pkt, pkt_info* pcf_info, u32 static_delay)
{
    u8* dmac = (pkt + 22);
    u8* smac = (pkt + 16);
    pcf_info->receive_pit = os_get_receive_pit(pkt + 16);//TODO:OpenSync timestamp
    pkt += 32;
    pcf_pkt* t_pkt = (pcf_pkt*)pkt;

    pcf_info->integration_cycle = ntohl(t_pkt->integration_cycle);
    pcf_info->membership_new = ntohl(t_pkt->membership_new);
    //pcf_info->pcf_type = t_pkt->type;
    pcf_info->pcf_type = pkt[61];
    
    // pcf_info->receive_pit_1 = smac_to_receive_pit(smac);

    pcf_info->transparent_clock = ntohll(t_pkt->transparent_clock);
    pcf_info->transparent_clock >>= 16;
    pcf_info->transparent_clock += static_delay;

    pcf_info->permanance_pit = pcf_info->receive_pit + (gp_param.max_transmission_delay - pcf_info->transparent_clock);

    pcf_info->sync_domain = t_pkt->sync_domain;
    pcf_info->sync_priority = t_pkt->sync_priority;
    // pkt_info_print(pcf_info);
}

int update_sync_info(pkt_info* in_info, local_sync_info* cm_sync_info)
{
    cm_sync_info->local_sync_membership_cnt += membership_to_int(in_info->membership_new);
    cm_sync_info->local_sync_membership |= (in_info->membership_new);
    
}

void set_sync_info_zero(local_sync_info* cm_sync_info)
{
    cm_sync_info->local_integration_cycle = 0;
    cm_sync_info->local_sync_membership = 0;
    cm_sync_info->local_sync_membership_cnt = 0;
}

u64 compress_func(pkt_info* in_queue, u16 queue_size, int* offset)
{
    if (queue_size == 0)
    {
        cm_debug("NO PKT IN ACCEPTANCE WINDOW!\n");
        return 0;
    }
    else if (queue_size == 1)
    {
        int clock_corr;
        clock_corr = offset_calcu(in_queue[0].receive_pit, in_queue[0].transparent_clock);
        *offset = clock_corr;
        return (FT + 1) * cm_param.observe_window + cm_param.cm_caculation_overhead;
    }
    else
    {
        *offset = offset_calcu(in_queue[2].receive_pit, in_queue[2].transparent_clock);

        sort_pcf(in_queue, queue_size);

        int i, j;
        pkt_info temp;
        u16 input_cnt = 0;
        u64 input[queue_size];
        //TODO观测窗口判断
        u64 diff;
        for (i = 1; i < queue_size; i++)
        {
            diff = in_queue[i].permanance_pit - in_queue[0].permanance_pit;
            if (diff <= cm_param.observe_window)
            {
                input[input_cnt] = diff;
                input_cnt++;
            }
        }
        u64 cm_corr = 0;
        cm_corr = ft_averege_cacul(input, input_cnt);
        return cm_corr;
    }
}

void sort_pcf(pkt_info* pcf_queue, u16 size)
{
    int i, j;
    pkt_info temp;
    for (i = 0; i < size - 1; i++)
    {
        for (j = 0; j < size - 1 - i; j++)
        {
            if (pcf_queue[i].permanance_pit >= pcf_queue[j].permanance_pit)
            {
                temp = pcf_queue[i];
                pcf_queue[i] = pcf_queue[j];
                pcf_queue[j] = temp;
            }
        }
    }
}

int offset_calcu(u64 receive_pit, u64 transparent_clk)
{
    int re = 0;
    re = transparent_clk - receive_pit;


    // if (re < -INTEGRATION_CYCLE_DURATION / 2)
    // {
    //     re += INTEGRATION_CYCLE_DURATION;
    // }

    return re;
}

u64 ft_averege_cacul(u64* input, u16 size)
{
    if (size == 0)
    {
        return 0;
    }
    else if (size == 1)
    {
        return input[0];
    }
    else if (size == 2)
    {
        return (input[0] + input[1]) / 2;
    }
    else if (size == 3)
    {
        return input[1];
    }
    else if (size == 4)
    {
        return (input[1] + input[2]) / 2;
    }
    else if (size >= 5)
    {
        return (input[1] + input[3]) / 2;
    }
}

unsigned long offset_convert(long offset)
{
    unsigned long re = 0;
    if (offset >= 0)
    {
        re = 0xffffffffffff;
        return re & offset;
    }
    else
    {
        offset = 0 - offset;
        re = 0x1000000000000;
        return re | offset;
    }
}

void sm_pkt_parse(u8* pkt, struct pkt_info* pcf_info, u32 static_delay)
{
    u8* dmac = (pkt + 22);
    u8* smac = (pkt + 16);
    pcf_info->receive_pit = os_get_receive_pit(pkt + 16);//TODO:OpenSync timestamp
    pkt += 32;
    pcf_pkt* t_pkt = (pcf_pkt*)pkt;

    pcf_info->integration_cycle = ntohl(t_pkt->integration_cycle);
    pcf_info->membership_new = ntohl(t_pkt->membership_new);
    //pcf_info->pcf_type = t_pkt->type;
    pcf_info->pcf_type = pkt[61];

    pcf_info->transparent_clock = ntohll(t_pkt->transparent_clock);
    pcf_info->transparent_clock >>= 16;
    pcf_info->transparent_clock += static_delay;

    pcf_info->permanance_pit = pcf_info->receive_pit + (gp_param.max_transmission_delay - pcf_info->transparent_clock);

    pcf_info->sync_domain = t_pkt->sync_domain;
    pcf_info->sync_priority = t_pkt->sync_priority;
    // pkt_info_print(pcf_info);
}

//TODO: ca in acc_win
bool ca_in_acc_win(struct pkt_info* pkt_info, tte_sync_context* context)
{
    u64 acc_win_start = pkt_info->transparent_clock + CM_DISPATCH_PIT - sm_param.ca_accpetance_window;
    u64 acc_win_end = pkt_info->transparent_clock + CM_DISPATCH_PIT + sm_param.ca_accpetance_window;
    if (pkt_info->receive_pit >= acc_win_start && pkt_info->receive_pit <= acc_win_end)
    {
        printf("CA RECVD IN ACC_WIN!\n");
        return true;
    }
    else
    {
        printf("CA RECVD OUT-OF ACC_WIN!\n");
        return false;
    }
}

//TODO:in_schedule
bool in_schedule(struct pkt_info* pkt_info, tte_sync_context* context) {

    /* IC判断*/
    if (pkt_info->integration_cycle != context->sm_info->cur_sinfo->local_integration_cycle) {
        sm_debug("", context->device_id);
        printf("IC OF IN DONT MATCH %d    %d\n",pkt_info->integration_cycle,context->sm_info->cur_sinfo->local_integration_cycle);
        // exit(-1);
        return false;
    }

    /* 接收窗口判断 */
    u64 acc_win_start = pkt_info->transparent_clock + CM_DISPATCH_PIT - gp_param.accuarcy;
    u64 acc_win_end = pkt_info->transparent_clock + CM_DISPATCH_PIT + gp_param.accuarcy;
    // printf("recv_pit:%ld\n", pkt_info->receive_pit);
    if (pkt_info->receive_pit < acc_win_start || pkt_info->receive_pit > acc_win_end)
    {
        sm_debug("", context->device_id);
        printf("IN NOT IN ACC_WIN\n");
        return false;
    }
    else
        return true;

}

int sm_state_command(u32 ic_new, u32 membership_new, enum sm_state next_state, tte_sync_context* context)
{
    sm_debug("state change ",context->device_id);printf("ic_new = %d membership new = %d  next state = %d \n",ic_new,membership_new,next_state);
    context->sm_info->cur_sinfo->local_integration_cycle = ic_new;
    context->sm_info->cur_sinfo->local_sync_membership = membership_new;
    context->sm_info->cur_state = next_state;
    return 0;
}



u64 get_clock_corr(u64 recv_pit, u64 transparent_clock, u32 membership, tte_sync_context* context)
{
    long raw_offset = transparent_clock + CM_DISPATCH_PIT - recv_pit;
    // long raw_offset = offset_calcu(recv_pit, transparent_clock + CM_DISPATCH_PIT);

    // if (raw_offset > (gp_param.integrate_cycle_duration / 2)) {
    //     raw_offset = raw_offset - gp_param.integrate_cycle_duration;
    // }

    u64 clock_corr = offset_convert(raw_offset);
    sm_debug("", context->device_id);
    printf("RAW_OFFSET:%ld \n", raw_offset);
    return raw_offset;
}

unsigned char get_pcf_type(u8* pkt)
{
    u8 type = *(pkt + 60);
    return type;
}




int membership_to_int(u32 membership_new)
{
    int count = 0;
    while (membership_new != 0)
    {
        membership_new = (membership_new - 1) & membership_new;
        count++;
    }
    return count;
}
