/** *************************************************************************
 *  @file       TSNInsight.c
 *  @brief	    P2P应用与TSNInsight应用通信的接口
 *  @date		2022/03/29 
 *  @author		junshuai.li
 *  @version	0.0.1 
编写人：李军帅
version0.0.1
1、初始版本			  
****************************************************************************/

#include "../include/comp_api.h"



int client_fd;
struct sockaddr_in ser_addr;


 void tsninsight_pkt_print(u8* pkt, int len)
 {
	 int i = 0;
 
	 printf("-----------------------***PACKET***-----------------------\n");
	 printf("Packet Addr:%p\n", pkt);
	 for (i = 0;i < 16;i++)
	 {
		 if (i % 16 == 0)
			 printf("	   ");
		 printf(" %X ", i);
		 if (i % 16 == 15)
			 printf("\n");
	 }
 
	 for (i = 0;i < len;i++)
	 {
		 if (i % 16 == 0)
			 printf("%04X: ", i);
		 printf("%02X ", *((u8*)pkt + i));
		 if (i % 16 == 15)
			 printf("\n");
	 }
	 if (len % 16 != 0)
		 printf("\n");
	 printf("-----------------------***PACKET***-----------------------\n\n");
 }


 void tsninsight_msg_sender(u8 *pkt,u16 pkt_len)
 {
 	u16 count = 0;
    socklen_t len;
	len = sizeof(ser_addr);
    //len = sizeof(*dst);
   
   count =  sendto(client_fd, pkt, pkt_len, 0, (struct sockaddr*)&ser_addr, len);     
	tsninsight_pkt_print(pkt,pkt_len);
	printf("send count %d\n",count);
 }


//发送hello报文函数
int tsninsight_send_hello_pkt(u16 mid,u8 role)
{
	tsninsight_hello_pkt *hello_pkt = (tsninsight_hello_pkt *)malloc(sizeof(tsninsight_hello_pkt));
	hello_pkt->header.version = TSNINSIGHT_VERSION;
	hello_pkt->header.type 	  = TSNINSIGHT_HELLO;
	hello_pkt->header.length  = htons(sizeof(tsninsight_hello_pkt));

	hello_pkt->mid  = htons(mid);
	hello_pkt->role  = role;

	tsninsight_msg_sender((u8 *)hello_pkt,sizeof(tsninsight_hello_pkt));
	free(hello_pkt);
}

 //发送网络状态trap报文函数
 int tsninsight_send_netstate_or_syncstate_trap_pkt(u8 type,u8 state)
 {
	 tsninsight_netstate_or_syncstate_trap_pkt *trap_pkt = (tsninsight_netstate_or_syncstate_trap_pkt *)malloc(sizeof(tsninsight_netstate_or_syncstate_trap_pkt));
	 trap_pkt->header.version = TSNINSIGHT_VERSION;
	 trap_pkt->header.type    = TSNINSIGHT_TRAP;
	 trap_pkt->header.length  = htons(sizeof(tsninsight_netstate_or_syncstate_trap_pkt));
 
	 trap_pkt->trap_type  = type;
	 trap_pkt->state  = state;
 
	 tsninsight_msg_sender((u8 *)trap_pkt,sizeof(tsninsight_netstate_or_syncstate_trap_pkt));
	 free(trap_pkt);
 }


  //发送版本信息trap报文函数
 int tsninsight_send_version_trap_pkt(u8 num,node_version* ver)
 {
 	u16 len = 0;
	 tsninsight_version_trap_pkt *trap_pkt = NULL;
	 len = sizeof(tsninsight_version_trap_pkt) + num*sizeof(node_version);
	 
	 trap_pkt = (tsninsight_version_trap_pkt *)malloc(len);
	 trap_pkt->header.version = TSNINSIGHT_VERSION;
	 trap_pkt->header.type    = TSNINSIGHT_TRAP;
	 trap_pkt->header.length  = htons(len);
 
	 trap_pkt->trap_type  = DEVICE_VESION;
	 trap_pkt->num  = num;

	 memcpy(trap_pkt->data,ver,num*sizeof(node_version));
 
	 tsninsight_msg_sender((u8 *)trap_pkt,len);
	 free(trap_pkt);
 }

 //set_res发送响应函数
 /*
pkt 接收到的报文
type 表示接收到的类型
*/
 int tsninsight_send_set_res_pkt(u8 *pkt,u8 type)
 {

 	tsninsight_pkt *get_pkt = (tsninsight_pkt *)pkt;
	get_pkt->header.version = TSNINSIGHT_VERSION;
	get_pkt->header.type    = TSNINSIGHT_SET_RES;
	tsninsight_msg_sender((u8 *)get_pkt,ntohs(get_pkt->header.length));

 }



 //TSNInsight初始化函数
int tsninsight_init()
{

	 client_fd = socket(AF_INET, SOCK_DGRAM, 0);
	 if(client_fd < 0)
	 {
		 printf("create socket fail!\n");
		 return -1;
	 }
	 
	 memset(&ser_addr, 0, sizeof(ser_addr));
	 //ser_addr.sin_family = AF_INET;
	 ser_addr.sin_family = SOCK_DGRAM;
	 ser_addr.sin_addr.s_addr = inet_addr(SERVER_IP);
	 ser_addr.sin_port = htons(8080);
	 //ser_addr.sin_addr.s_addr = htonl(INADDR_ANY);  //注意网络序转换
	 
	 printf("ser_addr.sin_addr.s_addr is %0x.\n",ntohl(ser_addr.sin_addr.s_addr));
	 ser_addr.sin_port = htons(SERVER_PORT);  //注意网络序转换
	 
	 //udp_msg_sender(client_fd, (struct sockaddr*)&ser_addr);	 
	 //close(client_fd);
	 return 0;
}



