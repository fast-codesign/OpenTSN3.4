#ifndef TSMP_API_H
#define TSMP_API_H


#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>/*memcpy*/
#include <strings.h>/*bzero*/
#include <pcap.h>

#include <unistd.h>

#include <errno.h>

#include <arpa/inet.h>/*htons,ntohs*/

#include <endian.h>/*htobeXX,beXXtoh,htoleXX,leXXtoh*/
#include <sys/types.h>
#include <sys/socket.h>
#include <linux/in.h>/*struct sockaddr_in*/
#include <linux/if_ether.h>/*struct ethhdr*/
#include <linux/ip.h>/*struct iphdr*/
#include <sys/ioctl.h>
#include <net/if.h>
#include <netpacket/packet.h>


#include <sys/file.h>
#include <sys/time.h>



#include "tsmp_type.h"
#include "tsmp_addr.h"
#include "tsninsight.h"


#define CNCAPI_DEBUG 1
//#undef CNCAPI_DEBUG

#if CNCAPI_DEBUG
	#define CNCAPI_DBG(args...) do{printf("CNCAPI-INFO: ");printf(args);}while(0)
	#define CNCAPI_ERR(args...) do{printf("CNCAPI-ERROR: ");printf(args);exit(0);}while(0)
#else
	#define CNCAPI_DBG(args...)
	#define CNCAPI_ERR(args...)
#endif


#define TSNLIGHT_MID 	2048


//#define write_debug_msg(format,...){printf(format,##__VA_ARGS__);FILE*fp = fopen("debug_error.txt","a+");if(fp!=NULL){fwrite(format,sizeof(char),strlen(format),fp);fclose(fp);}}

#define DEBUG_BUFFER_MAX 4096

#define write_debug_msg(format,...){char buffer[DEBUG_BUFFER_MAX+1]={0};snprintf(buffer,DEBUG_BUFFER_MAX,format,##__VA_ARGS__);FILE*fp = fopen("debug_error.txt","a+");if(fp!=NULL){fwrite(buffer,strlen(buffer),1,fp);};fclose(fp);}

#define SIM_DEBUG_BUFFER_MAX 4096
#define sim_write_debug_msg(format,...){char buffer[SIM_DEBUG_BUFFER_MAX+1]={0};snprintf(buffer,SIM_DEBUG_BUFFER_MAX,format,##__VA_ARGS__);FILE*fp = fopen("sim_debug_error.txt","a+");if(fp!=NULL){fwrite(buffer,strlen(buffer),1,fp);};fclose(fp);}

/**************数据接收相关API**************/
//数据报文接收初始化函数
int data_pkt_receive_init(u8* rule,u8* net_interface);


//数据报文接收处理函数（每次只抓一个包）返回接收的报文的指针
u8 *data_pkt_receive_dispatch_1(u16 *len);
//u8 *data_pkt_receive_dispatch_1();



//数据报文接收销毁函数
int data_pkt_receive_destroy();


/**************数据发送相关API**************/
//数据报文发送初始化函数
int data_pkt_send_init(u8* net_interface);

//数据报文发送处理函数
int data_pkt_send_handle(u8* pkt,u16 len);


//数据报文发送销毁函数
int data_pkt_send_destroy();


/**************调试工具相关API**************/
//报文打印
void cnc_pkt_print(u8 *pkt,int len);

int cfg_varify(u8 *local_mac,u16 data_num,u32 addr,u8 *pkt);




//64bit主机序转网络序
u64 htonll(u64 value);



/**************上报相关API**************/
int set_tsnlight_mac(u16 tsnlight_mid);


void hx_data_send_init();

void get_hcp_mac_from_mid(u8 *mac,u16 mid);
void get_tsnlight_mac_from_mid(u8 *mac,u16 mid);


int cfg_hw_state(u8 *local_mac,u32 state,u8 *pkt);

int tsmp_cfg_hcp_tsnlight_mid(u8 *mac,u16 hcp_mid,u16 tsnlight_mid,u8 *pkt);

int tsmp_set_req(u8 *local_mac,u16 data_num,u32 addr,u8 *pkt);
int tsmp_get_req(u8 *local_mac,u16 data_num,u32 addr,u8 *pkt);
u32 *tsmp_get_res(u8 *local_mac,u16 data_num,u32 addr);
int cfg_varify(u8 *local_mac,u16 data_num,u32 addr,u8 *pkt);
int cfg_hw_state(u8 *local_mac,u32 state,u8 *pkt);


 //TSNInsight初始化函数
int tsninsight_init();

//发送hello报文函数
int tsninsight_send_hello_pkt(u16 mid,u8 role);


 //发送网络或同步状态trap报文函数
 int tsninsight_send_netstate_or_syncstate_trap_pkt(u8 type,u8 state);

int tsninsight_send_set_res_pkt(u8 *pkt,u8 type);

 //发送版本信息trap报文函数
int tsninsight_send_version_trap_pkt(u8 num,node_version* ver);

int tsninsight_pkt_process(u8 *pkt,u16 pkt_len);

#endif

