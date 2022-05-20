
#ifndef TSMP_TYPE_H
#define TSMP_TYPE_H


typedef char s8;				/**< 有符号的8位（1字节）数据定义*/
typedef unsigned char u8;		/**< 无符号的8位（1字节）数据定义*/
typedef short s16;				/**< 有符号的16位（2字节）数据定义*/
typedef unsigned short u16;	/**< 无符号的16位（2字节）数据定义*/
typedef int s32;				/**< 有符号的32位（4字节）数据定义*/
typedef unsigned int u32;		/**< 无符号的32位（4字节）数据定义*/
typedef long long s64;				/**< 有符号的64位（8字节）数据定义*/
typedef unsigned long long u64;		/**< 无符号的64位（8字节）数据定义*/


//以太网报文字段长度
#define TSMP_PROTOCOL 0xff01
#define MAX_NODE_NUM 15


/*tsmp报文头部*/
typedef struct
{
	u8  dmac[6];	//dmac
	u8  smac[6];	//源mac
	u16 eth_type; 	/* 以太网类型，TSMP以太网类型为0xff01   */
	u8  type;		/* TSMP协议类型   */
	u8  sub_type;	/* TSMP协议子类型   */
}__attribute__((packed))tsmp_header;

typedef enum 
{
    MID_DISTRI = 0x01,   	//地址分配
    NET_MANAGE = 0x02,      //网络管理
    NET_TETEMETRY = 0x03,   //网络遥测
    TUNNEL_ENCAPSULATION = 0x04,   //隧道封装
    TIME_ANNUNCIATE = 0x05,   //时间通告
    OPENSYNC = 0x06,   //OpenSync时间同步
}TSMP_TYPE;




//网络管理子类型
typedef enum 
{
    GET_REQ = 0x01, //读请求
    SET_REQ = 0x02,     //写请求
	GET_RES = 0x03,   //读响应
	TRAP = 0x04,   //trap上报
}NET_MANAGE_SUB_TYPE;

//get_req子类型报文数据域
typedef struct 
{
    u16  num;//数目
    u32  base_addr;//基地址
}__attribute__((packed))tsmp_get_req_pkt_data;

//set_req和get_res子类型报文数据域
typedef struct 
{
    u16  num;//数目
	u32  base_addr;//基地址
	u32  data[0];//数值
}__attribute__((packed))tsmp_set_req_or_get_res_pkt_data;


//OpenSync子类型
typedef enum 
{
    OPENSYNC_REQ = 0x01, //来自控制器的请求报文
    OPENSYNC_RES = 0x02,       //发送给控制器的响应报文
}OPENSYNC_SUB_TYPE;

//opensync_req和opensync_res子类型报文数据域
typedef struct 
{
    u64  send_or_recv_pit;//发送或接收时刻
	u64  local_time;//接收或发送时间戳
	u8  data[0];
}__attribute__((packed))tsmp_opensync_req_or_opensync_res_pkt_data;



//LED灯状态枚举
typedef enum 
{
	INIT_STATE = 0,		//初始状态，硬件上电默认为0
	BASIC_CFG_FINISH_STATE,	//基础配置完成状态
	LOCAL_PLAN_CFG_FINISH_STATE,		//本地规划配置完成状态
	SYNC_FINISH_STATE,		//同步完成状态
}HW_LED_STATE;

//硬件状态枚举
typedef enum 
{
	INIT = 0,		//初始状态，硬件上电默认为0
	FINISH_BASIC_CFG,	//基础配置完成
	FINISH_TIME_SYNC,		//时间同步完成
}HW_STATE;



#endif


