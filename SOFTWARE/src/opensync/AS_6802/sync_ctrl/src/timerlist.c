#include "../include/timerlist.h"

void timeout_handle(u32 device_id, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    if (context->dev_info->sync_clock_role == ROLE_CM)
    {
        cm_timeout_handle(context, timer, libnet_handle);
    }
    else if (context->dev_info->sync_clock_role == ROLE_SM)
    {
        sm_timeout_handle(context, timer, libnet_handle);
    }
}


void sm_timeout_handle(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    switch (context->sm_info->cur_state)
    {
    case SM_INTEGRATE:
        to_handle_sm_integrate(context, timer, libnet_handle);
        break;
    case SM_SYNC:
        to_handle_sm_sync(context, timer, libnet_handle);
        break;
    case SM_FLOOD:
        to_handle_sm_flood(context, timer, libnet_handle);
        break;
    case SM_UNSYNC:
        to_handle_sm_unsync(context, timer, libnet_handle);
        break;
    case SM_STABLE:
        to_handle_sm_stable(context, timer, libnet_handle);
        break;
    case SM_TENTATIVE_SYNC:
        to_handle_sm_tentative_sync(context, timer, libnet_handle);
        break;
    case SM_WAIT_4_CS_CS:
        to_handle_sm_wait4cs_cs(context, timer, libnet_handle);
        break;
    default:
        break;
    }
}

void cm_timeout_handle(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle)
{
    switch (context->cm_info->cur_state)
    {
    case CM_INTEGRATE:
        to_handle_cm_integrate(context, timer, libnet_handle);
        break;
    case CM_SYNC:
        to_handle_cm_sync(context, timer, libnet_handle);
        break;
    case CM_UNSYNC:
        to_handle_cm_unsync(context, timer, libnet_handle);
        break;
    case CM_WAIT_4_IN:
        to_handle_cm_wait4_in(context, timer, libnet_handle);
        break;
    case CM_ENABLE:
        to_handle_cm_enable(context, timer, libnet_handle);
        break;
    default:
        break;
    }
}


void set_timer_invalid(timer_list_node* timer)
{
    timer->valid = 0;
}

void set_timer_valid(timer_list_node* timer, unsigned long timer_length,unsigned long timer_start, char start_update_flag)
{
    timer->valid = 1;
    timer->timer_length = timer_length;
    if (start_update_flag == 1)
    {
        timer->timer_start = get_cur_nano_sec();
    }
    else if(start_update_flag == 0)
    {
        timer->timer_start = timer_start;
    }
}
