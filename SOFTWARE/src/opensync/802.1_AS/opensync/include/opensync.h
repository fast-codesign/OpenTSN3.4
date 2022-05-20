#ifndef OPENSYNC_H
#define OPENSYNC_H

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>/*memcpy*/
#include <strings.h>/*bzero*/
#include <unistd.h>
#include <errno.h>
#include <arpa/inet.h>/*htons,ntohs*/
#include <endian.h>/*htobeXX,beXXtoh,htoleXX,leXXtoh*/
#include <sys/types.h>
#include <sys/ioctl.h>


#include <time.h>
#include "sim.h"

#if 0
typedef unsigned long long  u64;
typedef unsigned int    u32;
typedef unsigned short  u16;
typedef unsigned char   u8;
typedef long            s64;
typedef int             s32;
typedef short           s16;
typedef char            s8;

#endif
typedef unsigned long   os_time_value; //高 32 bit 是秒，低32 bit 是纳秒

#define TSMP_ETH_TYPE     0xff01
#define TSMP_CFG_ETH_TYPE 0x1662
#define OPENSYNC_ETH_TYPE 0x1023

#define CLOCK_PATH "/home/wmw/data/opentsn3.41/data/time.txt" //TODO 时间文本
extern u8 CTRL_MAC[6];

//#define SIM 1

#ifndef SIM
#include <libnet.h>
#include <pcap.h>
#endif

#ifdef SIM
typedef unsigned long long pcap_t;
typedef unsigned long long libnet_t;
#endif

#define OS_CSET0_REG     0x00080002


/* Opensync header 16 Bytes Used*/
typedef struct opensync_header {
    u8  timestamp1[8];
    u8  timestamp2[8];
} __attribute__((packed))opensync_header;

/*TSMP header 16 Bytes Used */
typedef struct
{
    u8  dmac[6];
    u8  smac[6];
    u16 eth_type; 		/* 以太网类型  */
    u8  type;	/* TSMP协议子类型   */
    u8  sub_type;		
}__attribute__((packed))os_tsmp_header;

typedef struct shadow_clock
{
    u64 local_clock_tv;
    u32 local_counter_tv;
    u64 sys_time;
}shadow_clock;

typedef struct tsmp_cfg_pkt
{
    os_tsmp_header     ts_header;
    u16 reg_num;
    u32 base_addr;
    u32 reg1;
    u32 reg2;
    u32 reg3;
    u32 reg4;
}__attribute__((packed))tsmp_cfg_pkt;




/**********************************************报文接收 API****************************************************/

/*初始化libpcap接收句柄并返回
当使用仿真平台时，net_interface 参数输入 文件路径即可*/
pcap_t* os_pkt_receive_init(u8* net_interface, u8* filter_rule);

/*以非阻塞的方式接收报文*/
u8* os_pkt_receive(u16* pkt_len, pcap_t* pcap_handle);

/*回收libpcap接收报文的句柄*/
int os_pkt_receive_destroy(pcap_t* pcap_handle);

/**********************************************报文发送 API***************************************************/
/*初始化libnet发送句柄并返回*/
// libnet_t* os_pkt_send_init(u8* net_interface);
/*当使用仿真平台时，net_interface 参数输入 文件路径, sim_write_satet 输出写状态文件路径*/
libnet_t* os_pkt_send_init(u8* net_interface, u8* sim_write_state);


/*发送报文*/
int os_pkt_send(u8* pkt, u16 len, libnet_t* libnet_handle);

/*回收libnet发送报文的句柄*/
int os_pkt_send_destroy(libnet_t* libnet_handle);

/**********************************************Shawdow Clock*************************************************/
void init_shadow_clock(shadow_clock* sc);

void update_shadow_clock(u64 local_clock, u32 local_counter, shadow_clock* sc);

unsigned int get_local_counter_tv(shadow_clock* sc);

unsigned long get_local_clock_tv(shadow_clock* sc);

/**********************************************配置本地定时电路***********************************************/
int os_cfg_local_clock_cycle (u8* dmac, os_time_value cycle_duration, libnet_t* libnet_handle);

//int os_cfg_local_clock(u8* dmac, os_time_value clock_value, os_time_value reference_pit, libnet_t* libnet_handle);
int os_cfg_local_clock(u8* dmac,u8 *dev_mac, os_time_value clock_value, os_time_value reference_pit, libnet_t* libnet_handle);

int os_cfg_phase_offset(u8* dmac, u32 flag ,os_time_value offset, libnet_t* libnet_handle);

int os_cfg_freq_offset(u8* dmac, u8 flag ,u32 offset, libnet_t* libnet_handle);

int os_cfg_freq_corr_cycleduration(u8* dmac, u32 frequency_corr, u32 frequency_corr_cycle, libnet_t* libnet_handle);

int os_cfg_sync_mode(u8* dmac, u32 flag, libnet_t* libnet_handle);

/**********************************************报文解析***********************************************/
/*opensync header中只有 接收时刻时间戳 有意义 所以直接调用下一个接口即可
int os_pkt_parse(u8 *pkt, opensync_header *os_header);*/

/*将opensync header 的首字节地址传入本函数，返回64位时间戳 （32 bit 秒 + 32 bit 纳秒）*/
os_time_value os_get_receive_pit(u8* pkt);

/**********************************************报文构造***********************************************/
/*opensync header 生成*/
int os_header_generate(os_time_value dispatch_pit , opensync_header* os_header);

/*Opensync header 添加到标准的同步报文前
int os_header_add (u8* sync_pkt, opensync_header *os_header);*/

/*tsmp 配置报文头 生成*/
int os_tsmp_header_generate(os_tsmp_header* ts_header, u8* dmac, u8* smac, u16 type, u8 subtype, u8 inport);

/*tsmp cfg subutype */
int os_cfg_tsmp_header_generate(os_tsmp_header* ts_header, u8* dmac, u8* smac, u16 type, u8 subtype, u8 rw_type);

/**********************************************工具函数******************************************************/
/*获取当前系统时间，以微秒为单位*/
u64 get_cur_nano_sec();

/*计算系统时间差值，以微秒为单位*/
u64 get_diff(u64 cur_time, u64 start_time);

/*64bit的数据 网络序转换为主机序*/
unsigned long long ntohll(unsigned long long val);

/*64bit的数据 主机序转换为网络序*/
unsigned long long htonll(unsigned long long val);

void os_pkt_print(u8* pkt, int len);








#endif
