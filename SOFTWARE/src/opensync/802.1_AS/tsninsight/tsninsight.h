#ifndef _TSNINSIGHT_H__
#define _TSNINSIGHT_H__


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

//#include <./opensync/include/sim.h>


#ifndef SIM
	//#include <libnet.h>
	//#include <pcap.h>
#endif
/*
#include <libxml/xmlmemory.h>  
#include <libxml/parser.h>  
*/
#include <libxml/xmlmemory.h>  
#include <libxml/parser.h>  



#define SERVER_PORT 8080
#define SERVER_IP 	"192.168.1.121"



#define UDP_HEAD_LEN 	42
#define TSNINSIGHT_VERSION 	0x01




/*与TSNInsight通信的通用报文头部*/
typedef struct
{
	unsigned char version; 		/* 版本号，目前值为0x01 */
	unsigned char type; 			/* 报文类型，hello、set_req、set_res和Trap*/
	unsigned short length; 		/* 通用报文长度，不包含以太网头、IP头和UDP头*/
}__attribute__((packed))tsninsight_header;

/*报文结构*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	unsigned char data[0];            /* 报文数据 */
}__attribute__((packed))tsninsight_pkt;

typedef enum 
{
	TSNINSIGHT_HELLO  = 0x01,    //握手请求
	TSNINSIGHT_SET_REQ = 0x03,      //设置请求
	TSNINSIGHT_SET_RES = 0x05,      //设置请求响应
    TSNINSIGHT_TRAP = 0x06,   //主动上报
}TSNINSIGHT_TYPE;

/*hello报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	unsigned short mid;            /* Opensync软件的mid */
	unsigned char role;            /* 角色*/
	unsigned char pad;            /* 保留位 */
}__attribute__((packed))tsninsight_hello_pkt;

//时钟角色定义
typedef enum 
{
    GM = 0x02,      //包含有GM（主时钟）节点的OpenSYNC软件
    OTHER = 0x03,   //其他的OpenSYNC软件
}TSNINSIGHT_ROLE_TYPE;

//set_req和set_res类型的取值定义
typedef enum 
{
	NETWORK_STATE  = 0x03,    		//网络状态
    OFFSET_REPORT_CYCLE = 0x04,    //时间同步精度上报周期
}TSNINSIGHT_SET_TYPE;

//网络状态的取值定义
typedef enum 
{
	START_SYNC  = 0x01,    //开始同步状态
	FININSH_SYNC  = 0x02,    //进入同步状态
}TSNINSIGHT_NETWORK_STATE;

/*设置网络状态报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	unsigned char set_type;            /* 设置类型 */
	unsigned char net_state;            /* 网络状态，取值为0x1 */
	unsigned short pad;            /* 保留 */
}__attribute__((packed))tsninsight_set_net_state_pkt;


/*设置时间同步精度上报周期报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	unsigned char set_type;            /* 设置类型 */
	unsigned short offset_report_cycle;            /* 上报周期，单位ms */
	unsigned char pad;            /* 保留 */
}__attribute__((packed))tsninsight_set_offset_report_cycle_pkt;

typedef enum 
{
 	TRAP_NETWORK_STATE  = 0x01,    //网络状态
    SYNC_OFFSET = 0x04,    //同步精度
}TSNINSIGHT_TRAP_TYPE;


/*网络状态子类型的trap报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	unsigned char trap_type;            /* trap类型 */
	unsigned char net_state;            /* 网络状态 */
	unsigned short pad;            /* 保留 */
}__attribute__((packed))tsninsight_netstate_trap_pkt;


/*节点时间同步精度数据结构定义*/
typedef struct
{
	unsigned short mid;            /* 节点mid */
	unsigned int offset;            /* 同步精度offset值 */
}__attribute__((packed))node_sync_offset;

/*时间同步精度子类型的trap报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	unsigned char trap_type;            /* trap类型 */
	unsigned char num;            /* 上报的节点数目 */
	node_sync_offset data[0];            /* 节点时间同步精度信息 */
}__attribute__((packed))tsninsight_sync_offset_trap_pkt;





void tsninsight_pkt_print(unsigned char* pkt, int len);
int tsninsight_send_hello_pkt(unsigned short mid,unsigned char role);
int tsninsight_send_netstate_trap_pkt(unsigned char net_netstate);
int tsninsight_send_set_res_pkt(unsigned char *pkt,unsigned char type);
int tsninsight_init(unsigned short port);
void tsninsight_msg_sender(unsigned char *pkt,unsigned short pkt_len);



#endif


