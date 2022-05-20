#ifndef TIMERLIST_H
#define TIMERLIST_H
#include "pcf_general.h"



void timeout_handle(u32 device_id, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void sm_timeout_handle(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void cm_timeout_handle(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

/**********************************SM timeout handle function in different state*************************************/
void to_handle_sm_integrate(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void to_handle_sm_unsync(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void to_handle_sm_flood(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void to_handle_sm_wait4cs_cs(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void to_handle_sm_tentative_sync(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void to_handle_sm_sync(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void to_handle_sm_stable(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);
/**********************************SM timeout handle function in different state*************************************/

/**********************************CM timeout handle function in different state*************************************/
void to_handle_cm_integrate(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void to_handle_cm_unsync(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void to_handle_cm_enable(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void to_handle_cm_wait4_in(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void to_handle_cm_sync(tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);
/**********************************CM timeout handle function in different state*************************************/

void set_timer_invalid(timer_list_node* timer);

void set_timer_valid(timer_list_node* timer, unsigned long timer_length,unsigned long timer_start, char start_update_flag);



#endif