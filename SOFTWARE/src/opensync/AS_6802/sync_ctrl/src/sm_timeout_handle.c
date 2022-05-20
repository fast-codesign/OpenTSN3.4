#include"../include/timerlist.h"
#include"../include/pkt_process.h"
#include"../include/basic_fun.h"

extern global_param_set gp_param;
extern sm_param_set sm_param;
extern cm_param_set cm_param;

void to_handle_sm_integrate(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    sm_debug("SM INTEGRATE TO HANDLE\n",context->device_id);

    timer->timer_start = get_cur_nano_sec();
    timer->timer_length = sm_param.sm_coldstart_timeout;
    os_cfg_local_clock(context->dev_info->dmac, 0, 0, libnet_handle); 
    sm_tsmp_send(CS_TYPE, libnet_handle, context);
    sm_state_command(0, 0, SM_UNSYNC, context);
}

void to_handle_sm_unsync(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    sm_debug("SM UNSYNC TO HANDLE\n",context->device_id);

    timer->timer_start = get_cur_nano_sec();
    timer->timer_length = sm_param.sm_coldstart_timeout;
    os_cfg_local_clock(context->dev_info->dmac, 0, 0, libnet_handle); 
    sm_tsmp_send(CS_TYPE, libnet_handle, context);
    sm_state_command(0, 0, SM_UNSYNC, context);
}

void to_handle_sm_flood(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    sm_debug("SM FLOOD TO HANDLE\n",context->device_id);

    //WAIT FOR CA
    if (context->sm_info->ca_receive == false) {
        context->sm_info->ca_receive = true;
        timer->timer_length = sm_param.ca_receive_timeout;
        timer->timer_start = get_cur_nano_sec();
        sm_tsmp_send(CA_TYPE, libnet_handle, context);
        sm_state_command(0, 0, SM_FLOOD, context);
        
    }
    //TO UNSYNC
    else if (context->sm_info->ca_receive == true) {
        timer->timer_start = get_cur_nano_sec();
        timer->timer_length = sm_param.sm_coldstart_timeout;
        sm_debug("TIMEOUT,TO UNSYNC\n", context->device_id);
        os_cfg_local_clock(context->dev_info->dmac, 0, context->last_pcf_pkt[0].receive_pit, libnet_handle);
        sm_state_command(0, 0, SM_UNSYNC, context);
    }
}

void to_handle_sm_wait4cs_cs(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    sm_debug("SM WAIT4CS CS TO HANDLE\n",context->device_id);

    timer->timer_start = get_cur_nano_sec();
    timer->timer_length = gp_param.integrate_cycle_duration;

    sm_state_command(INIT_INTEGRATION_CYCLE, 1 << (context->device_id), SM_TENTATIVE_SYNC, context);
    // timer->valid = 0;
    sm_tsmp_send(IN_TYPE, libnet_handle, context);
    // printf("222222222 %d\n",context->sm_info->cur_sinfo->local_integration_cycle);
}

void to_handle_sm_tentative_sync(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    sm_debug("SM TENTATIVE SYNC TO HANDLE\n",context->device_id);

    sm_tsmp_send(IN_TYPE, libnet_handle, context);
    timer->timer_start = get_cur_nano_sec();
    timer->timer_length = gp_param.integrate_cycle_duration -timer -> cycle_correction;
    
}

void to_handle_sm_sync(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    sm_debug("SM SYNC TO HANDLE\n",context->device_id);

    sm_tsmp_send(IN_TYPE, libnet_handle, context);
    timer->timer_start = get_cur_nano_sec();
    timer->timer_length = gp_param.integrate_cycle_duration -timer -> cycle_correction;
}

void to_handle_sm_stable(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    sm_debug("SM STABLE SYNC TO HANDLE\n",context->device_id);

    sm_tsmp_send(IN_TYPE, libnet_handle, context);
    timer->timer_start = get_cur_nano_sec();
    timer->timer_length = gp_param.integrate_cycle_duration -timer -> cycle_correction;
}
