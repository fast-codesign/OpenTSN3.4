#ifndef PKT_PROCESS_H
#define PKT_PROCESS_H

#include "pcf_general.h"


unsigned int get_device_id(u8* pkt, tte_sync_context* context_table[], u32 table_size);

void pkt_process(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void sm_pkt_proc(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void cm_pkt_proc(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);


/**********************************CM packet process function in different state*************************************/
void pkt_proc_cm_integrate(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void pkt_proc_cm_unsync(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void pkt_proc_cm_enable(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void pkt_proc_cm_wait4_in(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void pkt_proc_cm_sync(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);


/*使用报文携带的内容更新本地的同步信息（同步成员、集成周期）*/
int update_sync_info(pkt_info* in_info, local_sync_info* cm_sync_info);

/*解析报文，将报文携带的信息存储到报文信息结构体中（包含固化操作）*/
void cm_pkt_parse(u8* pkt, pkt_info* pcf_info, u32 static_delay);

/*本地集成周期数  同步成员数目清零*/
void set_sync_info_zero(local_sync_info* cm_sync_info);

/*压缩函数，计算本地时钟相位校正值*/
u64 compress_func(pkt_info* in_queue, u16 queue_size, int* offset);

/*容错均值计算*/
u64 ft_averege_cacul(u64* input, u16 size);

/*根据固化时刻为报文摘要排序*/
void sort_pcf(pkt_info* pcf_queue, u16 size);

/*回复未压缩CS帧*/
int send_uncompressed_cs(pkt_info* cs_info, tte_sync_context* context, libnet_t* libnet_handle);

/*回复压缩CA帧*/
int send_compressed_ca(pkt_info* ca_info, tte_sync_context* context, libnet_t* libnet_handle);

/*回复压缩IN帧*/
int send_compressed_in(pkt_info* in_info, tte_sync_context* context, libnet_t* libnet_handle);

/**********************************CM packet process function in different state*************************************/



/**********************************SM packet process function in different state*************************************/
void pkt_proc_sm_integrate(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void pkt_proc_sm_unsync(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void pkt_proc_sm_flood(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void pkt_proc_sm_wait4cs_cs(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void pkt_proc_sm_sync(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void pkt_proc_sm_stable(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

void pkt_proc_sm_tentative_sync(u8* pkt, tte_sync_context* context, timer_list_node* timer, libnet_t* libnet_handle);

/*解析报文，将报文携带的信息存储到报文信息结构体中（包含固化操作）*/
void sm_pkt_parse(u8* pkt, struct pkt_info* pcf_info, u32 static_delay);

/*判断CA帧是否在窗口内*/
bool ca_in_acc_win(struct pkt_info* pkt_info, tte_sync_context* context);

/*判断IN帧是否在窗口内*/
bool in_schedule(struct pkt_info* pkt_info, tte_sync_context* context);

/*将SM设备跳转到指定状态*/
int sm_state_command(u32 ic_new, u32 membership_new, enum sm_state next_state, tte_sync_context* context);

/*构造发送opensync报文*/
int sm_tsmp_send(u8 pcf_type, libnet_t* libnet_handle,  tte_sync_context* context);

u64 get_clock_corr(u64 recv_pit, u64 transparent_clock, u32 membership, tte_sync_context* context);

unsigned long offset_convert(long offset);

unsigned char get_pcf_type(u8* pkt);

int membership_to_int(u32 membership_new);

u8* gen_pcf_pkt(const u8* dst_mac, const u8* src_mac, struct pcf_payload* payload);

int offset_calcu(u64 receive_pit, u64 transparent_clk);

pcf_payload* gen_pcf_payload(u32 integration_cycle, u32 membership_new, u8 type);
/**********************************SM packet process function in different state*************************************/



#endif