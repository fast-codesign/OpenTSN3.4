#include "../include/pkt_process.h"
#include"../include/timerlist.h"
#include"../include/basic_fun.h"

extern global_param_set gp_param;
extern sm_param_set sm_param;
extern cm_param_set cm_param;

void pkt_proc_sm_integrate(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    sm_debug("SM INTEGRATE PKT PROC\n",context->device_id);
    struct pkt_info recv_pkt_info;
    u8 pkt_type = get_pcf_type(pkt);
    sm_pkt_parse(pkt, &recv_pkt_info, context->sm_info->static_delay);

    if (pkt_type == IN_TYPE) {
        //TO SYNC
        if (membership_to_int(recv_pkt_info.membership_new) >= sm_param.sm_integrate_to_sync_thrld) {
            timer->cycle_correction = recv_pkt_info.transparent_clock + CM_DISPATCH_PIT;
            timer->timer_start = get_cur_nano_sec();
            timer->timer_length = gp_param.integrate_cycle_duration - timer->cycle_correction;
            
            os_cfg_local_clock(context->dev_info->dmac, recv_pkt_info.transparent_clock + CM_DISPATCH_PIT, recv_pkt_info.receive_pit, libnet_handle);
            sm_state_command(recv_pkt_info.integration_cycle, recv_pkt_info.membership_new, SM_SYNC, context);
        }
    }
    //TO W4_CS_CS
    else if (pkt_type == CA_TYPE) {
        os_cfg_local_clock(context->dev_info->dmac, 0, 0, libnet_handle);
        sm_state_command(0, 1 << (context->device_id), SM_WAIT_4_CS_CS, context);
    }
}

void pkt_proc_sm_unsync(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    sm_debug("SM UNSYNC PKT PROC\n",context->device_id);
    struct pkt_info recv_pkt_info;
    sm_pkt_parse(pkt, &recv_pkt_info, context->sm_info->static_delay);
    u8 pkt_type = get_pcf_type(pkt);
    if (pkt_type == IN_TYPE) {
        int num_1_of_membership = membership_to_int(recv_pkt_info.membership_new);
        //TO SYNC
        if (num_1_of_membership >= sm_param.sm_unsync_to_sync_thrld) {
            timer->cycle_correction = recv_pkt_info.transparent_clock + CM_DISPATCH_PIT;
            timer->timer_start = get_cur_nano_sec();
            timer->timer_length = gp_param.integrate_cycle_duration - timer->cycle_correction;
            os_cfg_local_clock(context->dev_info->dmac, recv_pkt_info.transparent_clock + CM_DISPATCH_PIT, recv_pkt_info.receive_pit, libnet_handle);
            sm_state_command(recv_pkt_info.integration_cycle, recv_pkt_info.membership_new, SM_SYNC, context);
        }
        //TO TENTASIVE
        else if (num_1_of_membership >= sm_param.sm_unsync_to_tentative_thrld && num_1_of_membership < sm_param.sm_unsync_to_sync_thrld) {
            timer->cycle_correction = recv_pkt_info.transparent_clock + CM_DISPATCH_PIT;
            timer->timer_start = get_cur_nano_sec();
            timer->timer_length = gp_param.integrate_cycle_duration - timer->cycle_correction;

            os_cfg_local_clock(context->dev_info->dmac, recv_pkt_info.transparent_clock + CM_DISPATCH_PIT, recv_pkt_info.receive_pit, libnet_handle);
            sm_state_command(recv_pkt_info.integration_cycle, recv_pkt_info.membership_new, SM_TENTATIVE_SYNC, context);
        }

    }
    // RX CS ,跳转到FLOOD状态
    else if (pkt_type == CS_TYPE) {
        timer->timer_start = get_cur_nano_sec();
        timer->timer_length = sm_param.cs_offset + gp_param.max_transmission_delay -  recv_pkt_info.transparent_clock;
        
        
        u64 new_value = gp_param.integrate_cycle_duration - sm_param.cs_offset - (gp_param.max_transmission_delay - recv_pkt_info.transparent_clock);        // printf("=============%ld\n", new_value);
        os_cfg_local_clock(context->dev_info->dmac, new_value, recv_pkt_info.receive_pit, libnet_handle);
        sm_state_command(0, 0, SM_FLOOD, context);
    }
    // RX CA,跳转到W4_CS_CS状态
    else if (pkt_type == CA_TYPE) {
        os_cfg_local_clock(context->dev_info->dmac, 0, 0, libnet_handle);    
        sm_state_command(0, 1 << (context->device_id), SM_WAIT_4_CS_CS, context);
    }
}

void pkt_proc_sm_flood(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    sm_debug("SM FLOOD PKT PROC\n",context->device_id);

    struct pkt_info recv_pkt_info;
    u8 pkt_type;
    bool ca_receive = context->sm_info->ca_receive;
    sm_pkt_parse(pkt, &recv_pkt_info, context->sm_info->static_delay);
    
    pkt_type = get_pcf_type(pkt);
    context->last_pcf_pkt[0] = recv_pkt_info;
    //RX CA
    if (pkt_type == CA_TYPE) {
        bool ca_in_win = ca_in_acc_win(&recv_pkt_info, context);
        //RX CA IN ACC_WINDOW，TO WAIT_4_CS_CS
        if (ca_in_win && ca_receive == true) {
            timer->timer_start = get_cur_nano_sec();
            timer->timer_length = sm_param.ca_offset + gp_param.max_transmission_delay - recv_pkt_info.transparent_clock;
            // set_local_clock(sm_info->dmac, 0, 0, sm_libnet_handle);
            u64 new_value = gp_param.integrate_cycle_duration - sm_param.ca_offset - (gp_param.max_transmission_delay - recv_pkt_info.transparent_clock);
            // printf("=============ca :%ld\n", new_value);
            os_cfg_local_clock(context->dev_info->dmac, new_value, recv_pkt_info.receive_pit, libnet_handle);
            sm_state_command(0, 0, SM_WAIT_4_CS_CS, context);
            context->sm_info->ca_receive = false;
        }
    }
    //RX CS,TO UNSYNC,REJECT CA
    else if (pkt_type == CS_TYPE) {
        context->sm_info->ca_receive = false;
        timer->timer_start = get_cur_nano_sec();
        timer->timer_length = sm_param.cs_offset + gp_param.max_transmission_delay -  recv_pkt_info.transparent_clock;
        
        u64 new_value = gp_param.integrate_cycle_duration - sm_param.cs_offset - (gp_param.max_transmission_delay - recv_pkt_info.transparent_clock);
        os_cfg_local_clock(context->dev_info->dmac, new_value, recv_pkt_info.receive_pit, libnet_handle);
        sm_state_command(0, 0, SM_FLOOD, context);
    }
}

void pkt_proc_sm_wait4cs_cs(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    sm_debug("SM WAIT4CS CS PKT PROC\n",context->device_id);

    struct pkt_info recv_pkt_info;
    u8 pkt_type;
    sm_pkt_parse(pkt, &recv_pkt_info, context->sm_info->static_delay);
    pkt_type = get_pcf_type(pkt);
    //RX CS TO FLOOD
    if (pkt_type == CS_TYPE) {
        timer->timer_start = get_cur_nano_sec();
        os_cfg_local_clock(context->dev_info->dmac, 0, 0, libnet_handle);
        sm_state_command(0, 0, SM_FLOOD, context);
    }
    //RX CA,TO W4_CS_CS
    else if (pkt_type == CA_TYPE) {
        timer->timer_start = get_cur_nano_sec();
        u64 new_value = gp_param.integrate_cycle_duration - sm_param.ca_offset - (gp_param.max_transmission_delay - recv_pkt_info.transparent_clock);
        // printf("=============ca :%ld\n", new_value);
        os_cfg_local_clock(context->dev_info->dmac, new_value, recv_pkt_info.receive_pit, libnet_handle);
        //set_local_clock(sm_info->dmac, 0, 0, sm_libnet_handle);
        sm_state_command(0, 1 << (context->device_id), SM_WAIT_4_CS_CS, context);
    }
}
void pkt_proc_sm_tentative_sync(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    sm_debug("SM TENTATIVE SYNC PKT PROC\n",context->device_id);

    struct pkt_info recv_pkt_info;
    u64  cur_time;
    u8   pkt_type;
    pkt_type = get_pcf_type(pkt);
    sm_pkt_parse(pkt,&recv_pkt_info, context->sm_info->static_delay);
    if (pkt_type == IN_TYPE) 
    {
        bool is_in_schedule = in_schedule(&recv_pkt_info, context);
        timer->cycle_correction = recv_pkt_info.receive_pit;
        //同步IN帧
        if (is_in_schedule)
        {
            context->sm_info->cur_sinfo->local_sync_membership = recv_pkt_info.membership_new;
            sm_debug("IN_PCF RECVED IN WINDOW!\n", context->device_id);

            long clock_corr = get_clock_corr(recv_pkt_info.receive_pit, recv_pkt_info.transparent_clock, context->device_id, context);
            os_cfg_phase_offset(context->dev_info->dmac,clock_corr,libnet_handle); 
            // long offset = offset_calcu(recv_pkt_info.receive_pit, recv_pkt_info.transparent_clock + CM_DISPATCH_PIT);
            // u32 corr = cycle_corr_calcu(offset);
            // set_cycle_corr(sm_info->dmac, corr, sm_libnet_handle);
            timer->valid = 1;
            timer->cycle_correction = recv_pkt_info.receive_pit;
            timer->timer_start = get_cur_nano_sec();
            timer->timer_length = gp_param.integrate_cycle_duration - timer->cycle_correction;

            int num_1_of_membership = membership_to_int(context->sm_info->cur_sinfo->local_sync_membership);
            //TO UNSYNC
            if (num_1_of_membership < sm_param.sm_tentative_sync_thrld_sync)
            {
                os_cfg_local_clock(context->dev_info->dmac, 0, 0, libnet_handle);
                sm_state_command(0, 0, SM_UNSYNC, context);
            }
            //STAY IN TENTASIVE_SYNC,APPLY OFFSET
            else if (num_1_of_membership >= sm_param.sm_tentative_sync_thrld_sync && num_1_of_membership < sm_param.sm_tentative_to_sync_thrld)
            {
                context->sm_info->cur_state = SM_TENTATIVE_SYNC;
            }
            //TO SYNC
            else if (num_1_of_membership >= sm_param.sm_tentative_to_sync_thrld)
            {
                context->sm_info->cur_state = SM_SYNC;
            }
        }
        //TODO:OUT OF SCHEDULE
        else {
            //更新local_async_membership
            sm_state_command(0, 0, SM_INTEGRATE, context);
            timer->timer_start = get_cur_nano_sec();
            timer->timer_length = sm_param.sm_listen_timeout;
        }
    }
    //RX CA TO W4_CS_CS
    else if (pkt_type == CA_TYPE)
    {
        os_cfg_local_clock(context->dev_info->dmac, 0, 0, libnet_handle);
        sm_state_command(0, 1 << (context->device_id), SM_WAIT_4_CS_CS, context);
    }
}

void pkt_proc_sm_sync(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    sm_debug("SM SYNC PKT PROC\n",context->device_id);

    struct pkt_info recv_pkt_info;
    u64  cur_time;
    u8 pkt_type = get_pcf_type(pkt);
    sm_pkt_parse(pkt, &recv_pkt_info, context->sm_info->static_delay);
    

    if (pkt_type == IN_TYPE) {
        bool is_in_schedule = in_schedule(&recv_pkt_info, context);
        timer->cycle_correction = recv_pkt_info.receive_pit;

        if (is_in_schedule) {
            context->sm_info->cur_sinfo->local_sync_membership = recv_pkt_info.membership_new;
            sm_debug("IN_PCF RECVED IN WINDOW!\n", context->device_id);

            long clock_corr = get_clock_corr(recv_pkt_info.receive_pit, recv_pkt_info.transparent_clock, context->device_id, context);
            os_cfg_phase_offset(context->dev_info->dmac,clock_corr,libnet_handle); 

            // long offset = offset_calcu(recv_pkt_info.receive_pit, recv_pkt_info.transparent_clock + CM_DISPATCH_PIT);
            // u32 corr = cycle_corr_calcu(offset);
            // set_cycle_corr(sm_info->dmac, corr, sm_libnet_handle);

            timer->cycle_correction = recv_pkt_info.transparent_clock + CM_DISPATCH_PIT;
            timer->timer_start = get_cur_nano_sec();
            timer->timer_length = gp_param.integrate_cycle_duration - timer->cycle_correction;

            int num_1_of_membership = membership_to_int(context->sm_info->cur_sinfo->local_sync_membership);
            //SYNC CLIQUE DETECTION
            if (num_1_of_membership >= sm_param.sm_sync_threshold_sync) 
            {
                //STAY IN SYNC,APPLY OFFSET
                if (context->sm_info->stable_cycle_count < sm_param.num_stable_cycles) {
                    context->sm_info->stable_cycle_count++;
                }
                //TO STABLE
                else {
                    context->sm_info->cur_state = SM_STABLE;                }
            }
            else {
                os_cfg_local_clock(context->dev_info->dmac, 0, 0, libnet_handle);
                //TO INTEGRATE
                if (num_1_of_membership == 0) {
                    sm_state_command(0, 0, SM_INTEGRATE, context);
                }
                //TO UNSYNC
                else {
                    sm_state_command(0, 0, SM_UNSYNC, context);
                }
            }
        }
        //TODO:OUT OF SCHEDULE
        else
        {
            //u64 clock_corr = get_clock_corr(recv_pkt_info.receive_pit, recv_pkt_info.transparent_clock, context->device_id, context);
        	sm_state_command(0, 0, SM_INTEGRATE, context);
            timer->timer_start = get_cur_nano_sec();
            timer->timer_length = sm_param.sm_listen_timeout;
        }

    }
    //RX CA ,TO W4_CS_CS
    else if (pkt_type == CA_TYPE) {
        os_cfg_local_clock(context->dev_info->dmac, 0, 0, libnet_handle);
        sm_state_command(0, 1 << (context->device_id), SM_WAIT_4_CS_CS, context);
    }

}

void pkt_proc_sm_stable(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    sm_debug("SM STABLE PKT PROC\n",context->device_id);

    struct pkt_info recv_pkt_info;
    u64  cur_time;
    sm_pkt_parse(pkt, &recv_pkt_info, context->sm_info->static_delay);
    u8 pkt_type = get_pcf_type(pkt);


    bool is_in_schedule = in_schedule(&recv_pkt_info, context);
    timer->cycle_correction = recv_pkt_info.receive_pit;
    //IN_SCHEDULE
    if (is_in_schedule) {
        context->sm_info->cur_sinfo->local_sync_membership = recv_pkt_info.membership_new;
        sm_debug("IN_PCF RECVED IN WINDOW!\n", context->device_id);


        timer->cycle_correction = recv_pkt_info.transparent_clock + CM_DISPATCH_PIT;
        timer->timer_start = get_cur_nano_sec();
        timer->timer_length = gp_param.integrate_cycle_duration - timer->cycle_correction;

        int num_1_of_membership = membership_to_int(context->sm_info->cur_sinfo->local_sync_membership);
        long clock_corr = get_clock_corr(recv_pkt_info.receive_pit, recv_pkt_info.transparent_clock, context->device_id, context);
        os_cfg_phase_offset(context->dev_info->dmac,clock_corr,libnet_handle); 
        // long offset = offset_calcu(recv_pkt_info.receive_pit, recv_pkt_info.transparent_clock + CM_DISPATCH_PIT);
        // u32 corr = cycle_corr_calcu(offset);
        // set_cycle_corr(sm_info->dmac, corr, sm_libnet_handle);
        //SYNC CLIQUE DECTION
        if (num_1_of_membership < sm_param.sm_stable_threshold_sync) 
        {
            os_cfg_local_clock(context->dev_info->dmac, 0, 0, libnet_handle);
            sm_state_command(0, 0, SM_INTEGRATE, context);
            timer->timer_start = get_cur_nano_sec();
            timer->timer_length = sm_param.sm_listen_timeout;
        }
    }
    //TODO:OUT OF SCHEDULE
    else
    {
        // u64 clock_corr = get_clock_corr(recv_pkt_info.receive_pit, recv_pkt_info.transparent_clock, context->device_id, context);
        sm_state_command(0, 0, SM_INTEGRATE, context);
        timer->timer_start = get_cur_nano_sec();
        timer->timer_length = sm_param.sm_listen_timeout;
    }
}



