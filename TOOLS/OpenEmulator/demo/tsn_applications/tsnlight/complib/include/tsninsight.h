#ifndef _TSNINSIGHT_H__
#define _TSNINSIGHT_H__


#define SERVER_PORT 8080
#define SERVER_IP 	"127.0.0.1"

#define UDP_HEAD_LEN 	42
#define TSNINSIGHT_VERSION 	0x01


/*与TSNInsight通信的通用报文头部*/
typedef struct
{
	u8 version; 		/* 版本号，目前值为0x01 */
	u8 type; 			/* 报文类型，hello、set_req、set_res和Trap*/
	u16 length; 		/* 通用报文长度，不包含以太网头、IP头和UDP头*/
}__attribute__((packed))tsninsight_header;

/*报文结构*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	u8 data[0];            /* 报文数据 */
}__attribute__((packed))tsninsight_pkt;



/*hello报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	u16 mid;            /* Opensync软件的mid */
	u8 role;            /* 角色*/
	u8 pad;            /* 保留位 */
}__attribute__((packed))tsninsight_hello_pkt;


/*get_req报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	u16 mid;            /* 查询设备mid */
    u16 num;            /* 数目 */
	u32 base_addr;            /* 基地址 */
}__attribute__((packed))tsninsight_get_req_pkt;

/*设置设备参数类型的set_req报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	u8 set_type;            /* 设置类型 */
	u8 pad[3];            /* 保留 */
	u16 mid;            /* 查询设备mid */
    u16 num;            /* 数目 */
	u32 base_addr;            /* 基地址 */
	u32 value[0];       /* 请求设置寄存器的值 */
}__attribute__((packed))tsninsight_set_device_req_pkt;


/*设置扫描参数类型的set_req报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	u8 set_type;            /* 设置类型 */
	u8 operation_type;            /* start或stop*/
	u16 sweep_cycle;        /* 扫描周期单位ms，仅操作类型为start有效*/
}__attribute__((packed))tsninsight_set_sweep_req_pkt;


/*get_res报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	u16 mid;            /* 查询设备mid */
    u16 num;            /* 数目 */
	u32 base_addr;            /* 基地址 */
	u32 value[0];       /* 查询响应数值 */
}__attribute__((packed))tsninsight_get_res_pkt;


/*设置设备参数类型的set_res报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	u8 set_type;            /* 设置类型 */
	u8 pad[3];            /* 保留 */
	u16 mid;            /* 查询设备mid */
    u16 num;            /* 数目 */
	u32 base_addr;            /* 基地址 */
}__attribute__((packed))tsninsight_set_device_res_pkt;



/*节点版本号信息数据结构定义*/
typedef struct
{
	u16 mid;            /* 节点mid */
	u32 version;            /* 版本号 */
}__attribute__((packed))node_version;


/*版本号子类型的trap报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	u8 trap_type;            /* trap类型 */
	u8 num;            /* 节点数目 */
	node_version data[0];            /* 节点版本信息 */
}__attribute__((packed))tsninsight_version_trap_pkt;


/*节点离线错误子类型的trap报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	u8 trap_type;            /* trap类型 */
	u8 sweep_error_type;            /* 错误类型 */
	u16 mid;            /* 设备节点离线的mid */
}__attribute__((packed))tsninsight_sweep_trap_pkt;




/*设置网络状态报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	u8 set_type;            /* 设置类型 */
	u8 sync_state;            /* 网络同步状态，取值为0x1 */
	u16 pad;            /* 保留 */
}__attribute__((packed))tsninsight_set_sync_state_pkt;


/*设置时间同步精度上报周期报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	u8 set_type;            /* 设置类型 */
	u16 offset_report_cycle;            /* 上报周期，单位ms */
	u8 pad;            /* 保留 */
}__attribute__((packed))tsninsight_set_offset_report_cycle_pkt;



/*网络或同步状态子类型的trap报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	u8 trap_type;            /* trap类型 */
	u8 state;            /* 网络或同步状态 */
	u16 pad;            /* 保留 */
}__attribute__((packed))tsninsight_netstate_or_syncstate_trap_pkt;


/*节点时间同步精度数据结构定义*/
typedef struct
{
	u16 mid;            /* 节点mid */
	u32 offset;            /* 同步精度offset值 */
}__attribute__((packed))node_sync_offset;

/*时间同步精度子类型的trap报文数据结构定义*/
typedef struct
{
	tsninsight_header header;      /* 通用报文头部 */
	u8 trap_type;            /* trap类型 */
	u8 num;            /* 上报的节点数目 */
	node_sync_offset data[0];            /* 节点时间同步精度信息 */
}__attribute__((packed))tsninsight_sync_offset_trap_pkt;


typedef enum 
{
	TSNINSIGHT_HELLO	= 0x01,    //握手请求
	TSNINSIGHT_GET_REQ = 0x02,    //查询请求
	TSNINSIGHT_SET_REQ = 0x03, 	 //设置请求
	TSNINSIGHT_GET_RES = 0x04,   //查询响应
	TSNINSIGHT_SET_RES = 0x05,   //设置响应
	TSNINSIGHT_TRAP = 0x06,   //主动上报
}TSNINSIGHT_TYPE;


//角色定义
typedef enum 
{
	TSNLIGHT = 0x01,      //TSNLight软件
    GM = 0x02,      //包含有GM（主时钟）节点的OpenSYNC软件
    OTHER = 0x03,   //其他的OpenSYNC软件
}TSNINSIGHT_ROLE_TYPE;

//set_req和set_res类型的取值定义
typedef enum 
{	
	DEVICE_PARA  = 0x01,	//设备参数
	SWEEP_PARA = 0x02,	  //扫描参数
	NETWORK_SYNC_STATE  = 0x03,    		//网络状态
    OFFSET_REPORT_CYCLE = 0x04,    //时间同步精度上报周期
}TSNINSIGHT_SET_TYPE;

//网络状态的取值定义
typedef enum 
{
	BASE_CFG_FINISH  = 0x01,	//基础配置完成状态
	LOCAL_PLAN_CFG_FINISH = 0x02,	 //本地规划配置完成状态
	NET_RUN = 0x03,    //网络运行状态
}TSNINSIGHT_NETWORK_STATE;


//网络同步状态的取值定义
typedef enum 
{
	START_SYNC  = 0x01,    //开始同步状态
	FININSH_SYNC  = 0x02,    //进入同步状态
}TSNINSIGHT_NETWORK_SYNC_STATE;

typedef enum 
{
	NETWORK_STATE	= 0x01,    //网络状态
	SYNC_STATE	= 0x02,    //同步状态
	DEVICE_VESION = 0x03,	 //设备版本号
	SWEEP_STATE = 0x04,    //扫描状态
    SYNC_OFFSET = 0x05,    //同步精度
}TSNINSIGHT_TRAP_TYPE;

typedef enum 
{
 	DEVICE_OFFLINE  = 0x01,    //设备离线
}TSNINSIGHT_SWEEP_ERROR_TYPE;


#endif


