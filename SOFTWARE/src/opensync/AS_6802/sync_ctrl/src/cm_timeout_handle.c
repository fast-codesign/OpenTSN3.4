#include"../include/timerlist.h"
#include"../include/pkt_process.h"
#include"../include/basic_fun.h"

extern global_param_set gp_param;
extern sm_param_set sm_param;
extern cm_param_set cm_param;


pkt_info pkt_info_queue[MAX_DEVICE_NUM];

void to_handle_cm_integrate(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    cm_debug("CM INTEGRATE TO HANDLE\n");

    if (context->cm_info->cur_sinfo->local_sync_membership_cnt >= cm_param.cm_integerate_to_sync_thrld)
    {
        printf("local_sync_membership cnt = %d thrld = %d\n",context->cm_info->cur_sinfo->local_sync_membership_cnt,cm_param.cm_integerate_to_sync_thrld);
        // set_local_clock(context, CM_SCHEDULED_RECEIVED_PIT, pcf_in_info.receive_pit, cm_libnet_handle);
        os_cfg_local_clock(context->dev_info->dmac, CM_SCHEDULED_RECEIVED_PIT, context->last_pcf_pkt->receive_pit,libnet_handle);
        send_compressed_in(context->last_pcf_pkt, context, libnet_handle);
        context->cm_info->cur_state = CM_SYNC;
        printf("===========================================================================\n");
        //TODO CMSYNC timer set
    }
    else
    {
        set_sync_info_zero(context->cm_info->cur_sinfo);
        pkt_info temp;
        temp.membership_new = 0;
        temp.integration_cycle = 0;
        context->pkt_info_num = 0;
        send_compressed_in(&temp, context, libnet_handle);
        context->cm_info->cur_state = CM_UNSYNC;
        set_timer_invalid(timer);
    }
}

void to_handle_cm_unsync(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    //NULL
}

void to_handle_cm_enable(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    cm_debug("CM ENABLE TO HANDLE\n");

    if (timer->timer_length == cm_param.cm_ca_listen_timeout)
    {
        printf("cm enable timeout1\n");
        if (context->pkt_info_num >= 1)
        {
            usleep(500);
            send_compressed_ca(&(context->last_pcf_pkt[0]), context, libnet_handle); //TODO CA压缩的原理
            context->pkt_info_num = 0;
            set_sync_info_zero(context->cm_info->cur_sinfo);
            timer->timer_length = cm_param.cm_ca_enable_timeout;
        }
        else
        {
            timer->timer_start = get_cur_nano_sec();
            return;
        }
    }
    else if(timer->timer_length == cm_param.cm_ca_enable_timeout)
    {
        printf("cm enable timeout2\n");
        set_sync_info_zero(context->cm_info->cur_sinfo);
        os_cfg_local_clock(context->dev_info->dmac,0, 0, libnet_handle);
        context->cm_info->cur_state = CM_WAIT_4_IN;

        timer->timer_start = get_cur_nano_sec();
        timer->timer_length = cm_param.cm_wait4in_listen_timeout;
    }
}

void to_handle_cm_wait4_in(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    cm_debug("CM WAIT4 IN TO HANDLE\n");

    if (timer->timer_length == cm_param.cm_wait4in_listen_timeout)
    {
        if (context->pkt_info_num >= 1)
        {
            usleep(100);
            context->cm_info->cur_sinfo->local_integration_cycle = 1;
            send_compressed_in(&(context->last_pcf_pkt[0]), context, libnet_handle);
            context->cm_info->cur_sinfo->local_integration_cycle = (context->cm_info->cur_sinfo->local_integration_cycle + 1) % gp_param.max_integration_cycle;
            if (context->cm_info->cur_sinfo->local_sync_membership_cnt >= 1)
            {               
                timer->timer_length = gp_param.integrate_cycle_duration + gp_param.max_transmission_delay + 1000000 - context->last_pcf_pkt[0].transparent_clock;
                timer->timer_start = timer->cycle_correction;
                context->cm_info->cur_sinfo->local_integration_cycle = 2;
                context->cm_info->cur_state = CM_SYNC;
            }
            context->pkt_info_num = 0;
        }
        else
        {
            timer->timer_length = cm_param.cm_wait_4_in_timeout;
            return;
        }
    }
    else if(timer->timer_length == cm_param.cm_wait_4_in_timeout)
    {
        printf("=============wait4in to unsync\n");
        set_sync_info_zero(context->cm_info->cur_sinfo);
        os_cfg_local_clock(context->dev_info->dmac, 0, 0,libnet_handle);
        context->cm_info->cur_state = CM_UNSYNC;
        timer->valid = 0;
    }
}

void to_handle_cm_sync(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    cm_debug("CM SYNC TO HANDLE\n");

    int offset = 0;

    if (context->pkt_info_num == 0)
    {
        timer->cycle_correction = 0;
        timer->timer_start = get_cur_nano_sec();
        printf("====++++++++++++++++++++++++++++++++++++++++++++++++++++++++=cm sync no pkt\n");
        // exit(-1);
        context->cm_info->cur_state = CM_INTEGRATE;
        timer->timer_length = cm_param.cm_listen_timeout;
        timer->timer_start = get_cur_nano_sec();
        set_sync_info_zero(context->cm_info->cur_sinfo);
        // pkt_info temp;
        // temp.membership_new = 0;
        // temp.integration_cycle = 0;
        
        // send_compressed_in(&temp, context, libnet_handle);
        context->cm_info->cur_sinfo->local_integration_cycle = (context->cm_info->cur_sinfo->local_integration_cycle + 1) % gp_param.max_integration_cycle;    
        return;
    }
    else
    {
        u64 compress_func_delay = compress_func(context->last_pcf_pkt, context->pkt_info_num, &offset);
        cm_debug("offset = ");printf("%d\n", offset);

        // os_cfg_phase_offset(context->dev_info->dmac,offset,libnet_handle); 
        // usleep(500);
        send_compressed_in(&(context->last_pcf_pkt[0]), context, libnet_handle);
        // context->cm_info->cur_sinfo->local_integration_cycle = (context->cm_info->cur_sinfo->local_integration_cycle + 1) % MAX_INTEGRATION_CYCLE;
        timer->timer_start = timer->cycle_correction;
        timer->timer_length = gp_param.integrate_cycle_duration + gp_param.max_transmission_delay + 1000000 +  - context->last_pcf_pkt[0].receive_pit;
        context->pkt_info_num = 0;
    }
    context->cm_info->cur_sinfo->local_integration_cycle = (context->cm_info->cur_sinfo->local_integration_cycle + 1) % gp_param.max_integration_cycle;
}
