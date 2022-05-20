
#ifndef REG_CFG_H
#define REG_CFG_H


#define MAX_PKT_LEN		2048	/*最大报文长度*/


//HCP硬件寄存器地址
#define HCP_ID_REG     0x00000000  /*厂商ID和设备ID*/

#define HCP_VER_REG 		0x00000001  /*HCP硬件逻辑的版本号*/

#define HCP_MID_REG 		0x00000002  /*硬件控制点的管理标识（MID）*/
#define TSS_VER_REG 		0x00000003  /*TSS逻辑的版本号*/
#define HCP_CFG_REG 		0x00000004  /*配置状态寄存器*/



#define MID_TABLE 					0x00180000  /*MID转发表，0x00100000h-0x00100fffh*/



//TSS硬件寄存器地址
#define HW_STATE_ADDR 			0x43D00000   /*配置状态寄存器地址*/
#define RC_THRESHOLD_ADDR       0x63D00000   /*RC阈值*/
#define H_BE_THRESHOLD_ADDR 			0x63D00001   /*高优先级BE阈值*/
#define L_BE_THRESHOLD_ADDR 			0x63D00002   /*低优先级BE阈值*/
#define SCHEDULE_MODEL 		0x63D00003   /*调度模式，0表示qbv，1表示qch*/
#define SCHEDULE_PERIOD 		0x63D00004   /*调度周期*/
#define TIME_SLOT_LEN 		0x63D00005   /*时间槽长度*/


#define FLOWID_FLT_BASE_ADDR 				0x63C04000 /*FLOWID转发基地址，0x63C04000-0x63C0403f*/

#define QGC0_BASE_ADDR 			0x6060  /*端口0的门控基地址，支持1024条*/
#define QGC1_BASE_ADDR 			0xC0980000  /*端口1的门控基地址，支持1024条*/
#define QGC2_BASE_ADDR 			0xC0D80000  /*端口2的门控基地址，支持1024条*/
#define QGC3_BASE_ADDR 			0xC1180000  /*端口3的门控基地址，支持1024条*/
#define QGC4_BASE_ADDR 			0xC1580000  /*端口4的门控基地址，支持1024条*/
#define QGC5_BASE_ADDR 			0xC1980000  /*端口5的门控基地址，支持1024条*/
#define CHIP_QGC6_BASE_ADDR 			0xC1D80000  /*端口6的门控基地址，支持1024条*/
#define CHIP_QGC7_BASE_ADDR 			0xC3380000  /*端口7的门控基地址，支持1024条*/



#endif


