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

#include "tsninsight.h"


int client_fd;
struct sockaddr_in ser_addr;
struct sockaddr_in ptp_addr;


 void tsninsight_pkt_print(unsigned char *pkt, int len)
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
		 printf("%02X ", *((unsigned char*)pkt + i));
		 if (i % 16 == 15)
			 printf("\n");
	 }
	 if (len % 16 != 0)
		 printf("\n");
	 printf("-----------------------***PACKET***-----------------------\n\n");
 }


 void tsninsight_msg_sender(unsigned char *pkt,unsigned short pkt_len)
 {
 	unsigned short count = 0;
    socklen_t len;
	len = sizeof(ser_addr);
    //len = sizeof(*dst);
   
   count =  sendto(client_fd, pkt, pkt_len, 0, (struct sockaddr*)&ser_addr, len);     
	tsninsight_pkt_print(pkt,pkt_len);
	printf("send count %d\n",count);
 }


//发送hello报文函数
int tsninsight_send_hello_pkt(unsigned short mid,unsigned char role)
{
	tsninsight_hello_pkt *hello_pkt = (tsninsight_hello_pkt *)malloc(sizeof(tsninsight_hello_pkt));
	hello_pkt->header.version = TSNINSIGHT_VERSION;
	hello_pkt->header.type 	  = TSNINSIGHT_HELLO;
	hello_pkt->header.length  = htons(sizeof(tsninsight_hello_pkt));

	hello_pkt->mid  = htons(mid);
	hello_pkt->role  = role;

	tsninsight_msg_sender((unsigned char *)hello_pkt,sizeof(tsninsight_hello_pkt));
	free(hello_pkt);
}

 //发送网络状态trap报文函数
 int tsninsight_send_netstate_trap_pkt(unsigned char net_netstate)
 {
	 tsninsight_netstate_trap_pkt *trap_pkt = (tsninsight_netstate_trap_pkt *)malloc(sizeof(tsninsight_netstate_trap_pkt));
	 trap_pkt->header.version = TSNINSIGHT_VERSION;
	 trap_pkt->header.type    = TSNINSIGHT_TRAP;
	 trap_pkt->header.length  = htons(sizeof(tsninsight_netstate_trap_pkt));
 
	 trap_pkt->trap_type  = TRAP_NETWORK_STATE;
	 trap_pkt->net_state  = net_netstate;
 
	 tsninsight_msg_sender((unsigned char *)trap_pkt,sizeof(tsninsight_hello_pkt));
	 free(trap_pkt);
 }

 //set_res发送响应函数
 /*
pkt 接收到的报文
type 目前保留，表示接收到的类型，在PTP应用中表示NETWORK_STATE、OFFSET_REPORT_CYCLE
*/
 int tsninsight_send_set_res_pkt(unsigned char *pkt,unsigned char type)
 {

 	tsninsight_pkt *get_pkt = (tsninsight_pkt *)pkt;
	get_pkt->header.version = TSNINSIGHT_VERSION;
	get_pkt->header.type    = TSNINSIGHT_SET_RES;
	tsninsight_msg_sender((unsigned char *)get_pkt,ntohs(get_pkt->header.length));

 }



 //TSNInsight初始化函数
int tsninsight_init(unsigned short port)
{
	int ret = 0;
	 client_fd = socket(AF_INET, SOCK_DGRAM, 0);
	 if(client_fd < 0)
	 {
		 printf("create socket fail!\n");
		 return -1;
	 }

	  memset(&ptp_addr, 0, sizeof(ptp_addr));
	  ptp_addr.sin_family = AF_INET;
	  ptp_addr.sin_addr.s_addr = htonl(INADDR_ANY); //IP地址，需要进行网络序转换，INADDR_ANY：本地地址
	 ptp_addr.sin_port = htons(port);  //端口号，需要网络序转换

	 ret = bind(client_fd, (struct sockaddr*)&ptp_addr, sizeof(ptp_addr));
     if(ret < 0)
    {
        printf("socket bind fail!\n");
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



