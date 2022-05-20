#include "../include/pkt_process.h"
#include "../include/timerlist.h"
#include"../include/basic_fun.h"

extern global_param_set gp_param;
extern sm_param_set sm_param;
extern cm_param_set cm_param;

pkt_info pkt_info_queue[MAX_DEVICE_NUM];

void pkt_proc_cm_integrate(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    cm_debug("CM INTEGRATE PKT PROC\n");
    u8 pcf_type = get_pcf_type(pkt);
    pkt_info pcf_in_info;

    if (pcf_type == IN_TYPE)
    {
        cm_pkt_parse(pkt, &pcf_in_info,context->cm_info->static_delay);
        // update_sync_info(&pcf_in_info, context->cm_info->cur_sinfo);
        context->last_pcf_pkt[0] = pcf_in_info;
    }
}

void pkt_proc_cm_unsync(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    cm_debug("CM UNSYNC PKT PROC\n");

    pkt_info pcf_ca_info;
    pkt_info pcf_in_info;
    pkt_info pcf_cs_info;


    u8 pcf_type = get_pcf_type(pkt);
    if (pcf_type == IN_TYPE) //TODO CM_UNSYNC IN handle
    {
        cm_pkt_parse(pkt, &pcf_in_info,context->cm_info->static_delay);
        update_sync_info(&pcf_in_info, context->cm_info->cur_sinfo);
        if (context->cm_info->cur_sinfo->local_sync_membership_cnt >= cm_param.cm_unsync_to_sync_thrld)
        {
            os_cfg_local_clock(context->dev_info->dmac,pcf_in_info.transparent_clock, pcf_in_info.receive_pit, libnet_handle);
            send_compressed_in(&pcf_in_info, context, libnet_handle);
            context->cm_info->cur_state = CM_SYNC;
        }
    }
    else if (pcf_type == CS_TYPE) //CS
    {
        cm_pkt_parse(pkt, &pcf_cs_info,context->cm_info->static_delay);
        set_sync_info_zero(context->cm_info->cur_sinfo);
        os_cfg_local_clock(context->dev_info->dmac, 0, 0, libnet_handle);
        update_sync_info(&pcf_cs_info, context->cm_info->cur_sinfo);
        send_uncompressed_cs(&pcf_cs_info, context, libnet_handle);

        context->cm_info->cur_state = CM_ENABLE; 
        timer->valid = 1;
        timer->timer_start = get_cur_nano_sec();
        timer->timer_length = cm_param.cm_ca_listen_timeout;
        // printf("cm_ca_listen_timeout = %d\n",cm_param.cm_ca_listen_timeout);
    }
    else if (pcf_type == CA_TYPE) //TODO CM_UNSYNC CA handle
    {
        cm_pkt_parse(pkt, &pcf_ca_info,context->cm_info->static_delay);
        update_sync_info(&pcf_ca_info, context->cm_info->cur_sinfo);
        if (context->cm_info->cur_sinfo->local_sync_membership_cnt >= cm_param.cm_sync_threshold_sync)
        {
            set_sync_info_zero(context->cm_info->cur_sinfo);
            os_cfg_local_clock(context->dev_info->dmac, 0, 0, libnet_handle);
            usleep(8);
            send_compressed_ca(&pcf_ca_info, context, libnet_handle);
            // cm_info->to_start = get_cur_nano_sec();
            context->cm_info->cur_state = CM_ENABLE;
            timer->valid = 1;
            timer->timer_start = get_cur_nano_sec();
            timer->timer_length = cm_param.cm_ca_listen_timeout;
            printf("====!\n");
        }
    }
}

void pkt_proc_cm_enable(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    cm_debug("CM ENABLE PKT PROC\n");

    pkt_info pcf_ca_info;

    u8 pcf_type = get_pcf_type(pkt);
    if (pcf_type == CA_TYPE)
    {
        u16 index = context->pkt_info_num;
        printf("index = %d\n",index);
        cm_pkt_parse(pkt, &pcf_ca_info,context->cm_info->static_delay);
        update_sync_info(&pcf_ca_info, context->cm_info->cur_sinfo);

        context->last_pcf_pkt[index] = pcf_ca_info; 
        
        pkt_info_print(&pcf_ca_info);
        context->pkt_info_num ++;
        if (context->pkt_info_num == 1)
        {
            os_cfg_local_clock(context->dev_info->dmac, pcf_ca_info.transparent_clock, pcf_ca_info.receive_pit, libnet_handle);
        }
    }
}

void pkt_proc_cm_wait4_in(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    cm_debug("CM WAIT4 IN PKT PROC\n");

    pkt_info pcf_in_info;

    u8 pcf_type = get_pcf_type(pkt);
    if (pcf_type == IN_TYPE)
    {
        u16 index = context->pkt_info_num;
        cm_pkt_parse(pkt, &pcf_in_info,context->cm_info->static_delay);
        update_sync_info(&pcf_in_info, context->cm_info->cur_sinfo);

        context->last_pcf_pkt[index] = pcf_in_info;

        context->pkt_info_num ++;
        if (context->pkt_info_num == 1)
        {
            os_cfg_local_clock(context->dev_info->dmac, pcf_in_info.transparent_clock, pcf_in_info.receive_pit, libnet_handle);
            timer->cycle_correction = get_cur_nano_sec();
            // timer->timer_start = get_cur_nano_sec();
        }
    }

}

void pkt_proc_cm_sync(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    cm_debug("CM SYNC PKT PROC\n");

    u8 pcf_type = get_pcf_type(pkt);
    pkt_info pcf_in_info;
    if (pcf_type == IN_TYPE)
    {
        u16 index = context->pkt_info_num;
        cm_pkt_parse(pkt, &pcf_in_info,context->cm_info->static_delay);
        update_sync_info(&pcf_in_info, context->cm_info->cur_sinfo);
        printf("index = %d\n",index);
     
        /*判断IN帧的集成周期是否是CM需要要处理的集成周期*/
        if (pcf_in_info.integration_cycle !=  context->cm_info->cur_sinfo->local_integration_cycle)
        {
            printf("ic error!%d   %d\n",pcf_in_info.integration_cycle,context->cm_info->cur_sinfo->local_integration_cycle);
            pkt_print(pkt,120);
            // exit(-1);
            return;
        }
        context->last_pcf_pkt[index] = pcf_in_info;
        pkt_info_queue[index] = pcf_in_info;
        context->pkt_info_num ++;
        if (context->pkt_info_num == 1)
        {
            timer->cycle_correction = get_cur_nano_sec();
        }
    }
}
