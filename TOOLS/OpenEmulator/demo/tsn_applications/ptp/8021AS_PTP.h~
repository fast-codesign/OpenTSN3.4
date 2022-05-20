#ifndef _801AS_PTP_H__
#define _801AS_PTP_H__


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
#include <sys/socket.h>
//#include <linux/in.h>/*struct sockaddr_in*/
#include <linux/if_ether.h>/*struct ethhdr*/
#include <linux/ip.h>/*struct iphdr*/
#include <sys/ioctl.h>
#include <net/if.h>
#include <netpacket/packet.h>

#include "./opensync/include/opensync.h"  

#ifndef SIM
	#include <libnet.h>
	#include <pcap.h>
#endif
/*
#include <libxml/xmlmemory.h>  
#include <libxml/parser.h>  
*/
#include <libxml/xmlmemory.h>  
#include <libxml/parser.h>  

#define DEBUG_BUFFER_MAX 4096

#define write_debug_msg(format,...){char buffer[DEBUG_BUFFER_MAX+1]={0};snprintf(buffer,DEBUG_BUFFER_MAX,format,##__VA_ARGS__);FILE*fp = fopen("debug_error.txt","a+");if(fp!=NULL){fwrite(buffer,strlen(buffer),1,fp);};fclose(fp);}


//#include "./opensync/include/sim.h"  


#if 0
typedef char s8;				/**< 有符号的8位（1字节）数据定义*/
typedef unsigned char u8;		/**< 无符号的8位（1字节）数据定义*/
typedef short s16;				/**< 有符号的16位（2字节）数据定义*/
typedef unsigned short u16;	/**< 无符号的16位（2字节）数据定义*/
typedef int s32;				/**< 有符号的32位（4字节）数据定义*/
typedef unsigned int u32;		/**< 无符号的32位（4字节）数据定义*/
typedef long long s64;				/**< 有符号的64位（8字节）数据定义*/
typedef unsigned long long u64;		/**< 无符号的64位（8字节）数据定义*/
#endif


#define SEND_IO_PATH "../../data/data110.txt"
#define SEND_STATE_PATH "../../data/data210.txt"


#define RECV_IO_PATH "../../data/data010.txt"


#define MAX_OFFSET_STAND 200	

//定义数组最大值为10
#define MAX_TIMER_NUM 10	
//定义ptp的超时时间存储在数组的第0个元素
#define PTP_TIMEOUT_IDX 0	
#define REPORT_TIMEOUT_IDX 1

u64 g_timer_array[MAX_TIMER_NUM];

#define TSN_OR_TTE_MODE_REG_ADDR 0xC3D00006	//模式寄存器的地址
#define SYNC_STATE_REG_ADDR		 0x83D00000	//状态寄存器的地址
#define SYNC_STATE_READY 		 4			//硬件状态寄存器	
#define TSN_MODE 		 		 1			//TSN模式	

#define SYNC_CID_REG_ADDR 	0x00080001  /*集中式时间同步应用MAC地址的低位*/


//设备类型枚举
enum device_type
{
	PTP_CTL = 0,
	PTP_GM = 0,
	PTP_BC = 0,
	PTP_SLAVE = 0,	
};


//设备信息
typedef struct
{
	u16 mid;	//设备的mac地址
	enum device_type dev_type;//设备类型
}device_info;



//下一级节点信息
typedef struct next_class_node
{
	u16 mid;	//设备的mac地址
	struct next_class_node *next;//链表
}next_class_info;


//gm节点信息
typedef struct gm_node
{
	u16 mid;	//设备的mac地址
	u64 sync_period;//同步周期
	
	next_class_info *next_class_link;//下一等级的同步链路信息
	struct gm_node	*next_gm;	//可能存在多个gm的下一个gm
}ptp_gm_info;

//bc节点信息
typedef struct bc_node
{
	u16 mid;	//设备的mac地址	
	next_class_info *next_class_link;//下一等级的同步链路信息
	u64 link_delay;		//链路延迟信息
	u64 offset;			//同步偏差
	u64 frequency;		//频率偏差	
	struct bc_node	*next_bc;	//使用链表把BC节点串起来
}ptp_bc_info;

//slave节点信息
typedef struct slave_node
{
	u16 mid;	//设备的mac地址	
	u64 link_delay;		//链路延迟信息
	u64 offset;			//同步偏差
	u64 frequency;		//频率偏差	
	struct slave_node	*next_slave;	//使用链表把slave节点串起来
}ptp_slave_info;

//同步状态信息
typedef struct
{
	u64 max_offset;
	u64 min_offset;
}ptp_staticstic;

//ptp同步节点信息
typedef struct
{
	device_info *dev_info;	//设备信息
	ptp_gm_info  *gm;		//主时钟数据结构
	ptp_bc_info  *bc;		//边界时钟数据结构	
	ptp_slave_info  *slave;		//从数据结构	
	ptp_staticstic  *sta;		//同步状态
	
}ptp_sync_context;



typedef struct
{
    u8  message_type:4,           
        majorSdoID:4;
    u8  versionPTP:4,
		minorVesionPTP:4;
    u16 messageLength;                
    u8 domainNumber;
    u8 minorSdoId;
	u16 flags;
    u64  corrField;           
    u32 messageTypeSpecific;
    u8 sourcePortIdentity[10];
    u16 sequenceId;
    u8 controlField;
    u8 logMessageInterval;                    
    u8 originTimestamp[10];                
}__attribute__((packed))ptp_pkt;


/*tsmp报文头部*/
typedef struct
{
	u8  dmac[6];	//dmac
	u8  smac[6];	//源mac
	u16 eth_type; 	/* 以太网类型，TSMP以太网类型为0xff01   */
	u8  type;		/* TSMP协议类型   */
	u8  sub_type;	/* TSMP协议子类型   */
}__attribute__((packed))tsmp_header;
#if 0
/*opensync_header报文头部*/
typedef struct
{
	u8  timestamp1[8];	//send_or_recv_pit，发送或接收时刻
	u8  timestamp2[8];	//local_time，接收或发送时间戳
}__attribute__((packed))opensync_header;
#endif
/*opensync_header报文头部*/
typedef struct
{
	u8  dmac[6];	//dmac
	u8  smac[6];	//源mac
	u16 eth_type; 	/* 以太网类型，TSMP以太网类型,ptp报文为0x88f7*/
}__attribute__((packed))ether_header;


typedef struct
{
	tsmp_header tsmp_head;
	opensync_header opensync_head;
	ether_header ether_head;
	ptp_pkt ptp_pkt_info;
}__attribute__((packed))tsmp_ptp;

//get_req子类型报文数据域
typedef struct 
{
    u16  num;//数目
    u32  base_addr;//基地址
}__attribute__((packed))tsmp_get_req_pkt_data;


typedef struct
{
	tsmp_header tsmp_head;
	tsmp_get_req_pkt_data get_req_head;
	u32 data[0];
}__attribute__((packed))tsmp_get_req;


typedef enum 
{
    ADDR_DISTRI = 0x01,   	//地址分配
    NET_MANAGE = 0x02,      //网络管理
    NET_TETEMETRY = 0x03,   //网络遥测
    TUNNEL_ENCAPSULATION = 0x04,   //隧道封装
    TIME_ANNUNCIATE = 0x05,   //时间通告
    OPENSYNC = 0x06,   //OpenSync时间同步
}TSMP_TYPE;


//OpenSync子类型
typedef enum 
{
    OPENSYNC_REQ = 0x01, //来自控制器的请求报文
    OPENSYNC_RES = 0x02,       //发送给控制器的响应报文
}OPENSYNC_SUB_TYPE;

//网络管理子类型
typedef enum 
{
    GET_REQ = 0x01, //读请求
    SET_REQ = 0x02,     //写请求
	GET_RES = 0x03,   //读响应
	TRAP = 0x04,   //trap上报
}NET_MANAGE_SUB_TYPE;



int sync_init(u8 *net_interface,libnet_t **send_t,pcap_t **receive_t,ptp_sync_context *ptp_sync);
int timer_func(u64 cur_time_count_ns,ptp_sync_context *ptp_sync,libnet_t *send_t);
int sync_pkt_process(u8 *pkt,u16 pkt_len,ptp_sync_context *ptp_sync,libnet_t *send_t);

u8 *os_pkt_receive(u16 *pkt_len,pcap_t *receive_t);

void ptp_init_cfg(ptp_sync_context *ptp_sync,libnet_t *send_t);

int send_next_class_sync_pkt(u16 dev_mid,u8 cur_node_mid,next_class_info *next_class_link,libnet_t *send_t);

#endif


