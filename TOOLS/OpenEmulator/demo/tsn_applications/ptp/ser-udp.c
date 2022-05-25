
#include <stdio.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
#include <string.h>

 #define SERVER_PORT 8080
#define BUFF_LEN 1024

 typedef unsigned char	 u8;
typedef unsigned short  u16;


#define TSNINSIGHT_VERSION 	0x01
#define TSNINSIGHT_SET_RES  0x05 	 //设置请求响应
#define TSNINSIGHT_SET_REQ  0x03


 //网络状态的取值定义
 typedef enum 
 {
	 START_SYNC  = 0x05,	//开始同步状态
	 FININSH_SYNC  = 0x06,	  //进入同步状态
 }TSNINSIGHT_NETWORK_STATE;


 //set_req和set_res类型的取值定义
 typedef enum 
 {
	 NETWORK_STATE	= 0x03, 		 //网络状态
	 OFFSET_REPORT_CYCLE = 0x04,	//时间同步精度上报周期
 }TSNINSIGHT_SET_TYPE;


 /*与TSNInsight通信的通用报文头部*/
 typedef struct
 {
	 u8 version;		 /* 版本号，目前值为0x01 */
	 u8 type;			 /* 报文类型，hello、set_req、set_res和Trap*/
	 u16 length;		 /* 通用报文长度，不包含以太网头、IP头和UDP头*/
 }__attribute__((packed))tsninsight_header;

 /*设置网络状态报文数据结构定义*/
 typedef struct
 {
	 tsninsight_header header;		/* 通用报文头部 */
	 u8 set_type;			 /* 设置类型 */
	 u8 net_state;			  /* 网络状态，取值为0x1 */
	 u16 pad;			 /* 保留 */
 }__attribute__((packed))tsninsight_set_net_state_pkt;

 /*设置时间同步精度上报周期报文数据结构定义*/
 typedef struct
 {
	 tsninsight_header header;		/* 通用报文头部 */
	 u8 set_type;			 /* 设置类型 */
	 u16 offset_report_cycle;			 /* 上报周期，单位ms */
	 u8 pad;			/* 保留 */
 }__attribute__((packed))tsninsight_set_offset_report_cycle_pkt;


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



 int upd_send_set_net_state_req_pkt(u8 *pkt)
 {
	
 	tsninsight_set_net_state_pkt *get_pkt = (tsninsight_set_net_state_pkt *)pkt;
	get_pkt->header.version = TSNINSIGHT_VERSION;
	get_pkt->header.type    = TSNINSIGHT_SET_REQ;
	get_pkt->header.length    = htons(sizeof(tsninsight_set_net_state_pkt));

	get_pkt->set_type    = NETWORK_STATE;
	get_pkt->net_state    = START_SYNC;
	get_pkt->pad	    = 0;
	
 }

 int upd_send_set_report_period_req_pkt(u8 *pkt)
 {
	
 	tsninsight_set_offset_report_cycle_pkt *get_pkt = (tsninsight_set_offset_report_cycle_pkt *)pkt;
	get_pkt->header.version = TSNINSIGHT_VERSION;
	get_pkt->header.type    = TSNINSIGHT_SET_REQ;
	get_pkt->header.length    = htons(sizeof(tsninsight_set_net_state_pkt));

	get_pkt->set_type    = OFFSET_REPORT_CYCLE;
	get_pkt->offset_report_cycle    = htons(5000);
	get_pkt->pad	    = 0;
	
 }


 void handle_udp_msg(int fd)
 {
    char buf[BUFF_LEN];  //接收缓冲区，1024字节
     socklen_t len;
     int count;
    struct sockaddr_in clent_addr;  //clent_addr用于记录发送方的地址信息
    	char tmp_buf[16] = {0};
		int i = 0;
		int tmp_len;
     //while(1)
    // {
        memset(buf, 0, BUFF_LEN);
        len = sizeof(clent_addr);
		printf("111111\n");
        count = recvfrom(fd, buf, BUFF_LEN, 0, (struct sockaddr*)&clent_addr, &len);  //recvfrom是拥塞函数，没有数据就一直拥塞
		if(count == -1)
		{
			printf("recv fail\n");
		}
		printf("count %d\n",count);
		printf("port num %d\n",ntohs(clent_addr.sin_port));
		
#if 0		
		printf("2222222\n");
		printf("clent_addr.sin_addr.s_addr %0x",clent_addr.sin_addr.s_addr);
		memcpy(tmp_buf,inet_ntoa(clent_addr.sin_addr),16);
		printf("333333\n");
		printf("11111clent_addr is %s,len is %d. \n",tmp_buf,strlen(tmp_buf));
		tmp_len = strlen(tmp_buf);
		for(i =0;i<tmp_len;i++)
		{
		printf("%c \n",tmp_buf[i]);
		}
#endif
		 if(count == -1)
        {
             printf("recieve data fail!\n");
             return;
         }
		 tsninsight_pkt_print(buf,count);
       // printf("client:%s\n",buf);  //打印client发过来的信息
         memset(buf, 0, BUFF_LEN);
         sprintf(buf, "I have recieved %d bytes data!\n", count);  //回复client
         
         //printf("server:%s\n",buf);  //打印自己发送的信息给
         sleep(5);
		 printf("send set_net_state pkt\n");
		 
         upd_send_set_net_state_req_pkt(buf);
		 tsninsight_pkt_print(buf,sizeof(tsninsight_set_net_state_pkt));
         sendto(fd, buf, sizeof(tsninsight_set_net_state_pkt), 0, (struct sockaddr*)&clent_addr, len);  //发送信息给client，注意使用了clent_addr结构体指针

		sleep(5);
		printf("send set_report_period pkt\n");
		upd_send_set_report_period_req_pkt(buf);
		tsninsight_pkt_print(buf,sizeof(tsninsight_set_offset_report_cycle_pkt));
		sendto(fd, buf, sizeof(tsninsight_set_offset_report_cycle_pkt), 0, (struct sockaddr*)&clent_addr, len);  //发送信息给client，注意使用了clent_addr结构体指针

		
		while(1)
 		{
			count = recvfrom(fd, buf, BUFF_LEN, 0, (struct sockaddr*)&clent_addr, &len);  //recvfrom是拥塞函数，没有数据就一直拥塞
			tsninsight_pkt_print(buf,count);

		}
     //}
 }


 /*
     server:
             socket-->bind-->recvfrom-->sendto-->close
 */
 
 int main(int argc, char* argv[])
 {
     int server_fd, ret;
     struct sockaddr_in ser_addr; 

     server_fd = socket(AF_INET, SOCK_DGRAM, 0); //AF_INET:IPV4;SOCK_DGRAM:UDP
     if(server_fd < 0)
     {
        printf("create socket fail!\n");
         return -1;
     }
 
     memset(&ser_addr, 0, sizeof(ser_addr));
     ser_addr.sin_family = AF_INET;
     ser_addr.sin_addr.s_addr = htonl(INADDR_ANY); //IP地址，需要进行网络序转换，INADDR_ANY：本地地址
    ser_addr.sin_port = htons(SERVER_PORT);  //端口号，需要网络序转换

    ret = bind(server_fd, (struct sockaddr*)&ser_addr, sizeof(ser_addr));
     if(ret < 0)
    {
        printf("socket bind fail!!!!\n");
         return -1;
     }

     handle_udp_msg(server_fd);   //处理接收到的数据
 
     close(server_fd);
    return 0;
 }



