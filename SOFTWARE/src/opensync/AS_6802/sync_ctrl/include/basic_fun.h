#ifndef BASIC_FUNC_H
#define BASIC_FUNC_H
#include "pcf_general.h"
#include <libxml/xmlmemory.h>
#include <libxml/parser.h>

void tte_sync_init(tte_sync_context* context_table[], timer_list_node* timer_list[], u8* cfg_filename, int device_num);

void init_node_info(xmlNodePtr cur, tte_sync_context* context_table[], timer_list_node* timer_list[],u8* ctrl_mac,u8* multimac);

void param_cfg(u8* param_filename);

void init_global_param(xmlNodePtr cur);

void init_sm_param(xmlNodePtr cur);

void init_cm_param(xmlNodePtr cur);

void init_cfg(char *docname, int *devicenum, unsigned char **net_interface);

int maccmp(unsigned char* mac1, unsigned char* mac2);

/*打印报文详细内容*/
void pkt_print(u8* pkt, int len);

void print_mac(u8* mac);

void cm_debug(u8* content);

void sm_debug(const u8* content, u32 sm_id);

u64 time_trans_s2h(u64 time);

void my_sleep(u64 nanotimer_length);

u64 time_trans_h2s(u64 time);

void pkt_info_print(struct pkt_info* pinfo);

unsigned char atoc(unsigned char in_c);

int str2mac(unsigned char *mac_str, unsigned char *mac);

void get_hcp_mac_from_mid(u8 *mac,u16 mid);

void get_opensync_mac_from_mid(u8 *mac,u16 mid);

u16 get_mid_from_mac(u8 *mac);

void print_param_cfg();
#endif
