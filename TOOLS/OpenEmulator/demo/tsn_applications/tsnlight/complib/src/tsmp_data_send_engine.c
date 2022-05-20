
#include "../include/comp_api.h"


//raw socket句柄变量定义
int sock_raw_fd;
struct sockaddr_ll sll;	


//raw socket lo 回环句柄变量定义
int sock_raw_fd_lo;
struct sockaddr_ll sll_lo;	


/*
	定义：int data_pkt_send_init();
	功能：完成数据报文发送资源的初始化。包括raw scoket句柄的初始化、指定网卡名称、原始套接字地址结构赋值等	
	输入参数：无
	返回结果：成功返回0，失败返回-1
*/

int data_pkt_send_init(u8* net_interface)
{
	//原始套接字初始化
	sock_raw_fd = socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
	
	//原始套接字地址结构
	struct ifreq req;

	CNCAPI_DBG("net_interface = %s \n",net_interface);
	if(NULL == net_interface)
	{
	    CNCAPI_ERR("net_interface is NULL!\n");
	    return -1;	
	}

	//指定网卡名称
	strncpy(req.ifr_name,net_interface, IFNAMSIZ);			
	
	if(-1 == ioctl(sock_raw_fd, SIOCGIFINDEX, &req))
	{
		CNCAPI_ERR("ioctl error!\n");
		close(sock_raw_fd);
		return -1;
	}
	
	/*将网络接口赋值给原始套接字地址结构*/
	bzero(&sll, sizeof(sll));
	sll.sll_ifindex = req.ifr_ifindex;
	

	return 0;
}

/*
	定义：int lo_data_pkt_send_init();
	功能：初始化本地回环网卡。包括raw scoket句柄的初始化、指定网卡名称、原始套接字地址结构赋值等	
	输入参数：无
	返回结果：成功返回0，失败返回-1
*/

int lo_data_pkt_send_init()
{
	//原始套接字初始化
	sock_raw_fd_lo = socket(PF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
	
	//原始套接字地址结构
	struct ifreq req;



	//指定网卡名称
	strncpy(req.ifr_name,"lo", IFNAMSIZ);			
	
	if(-1 == ioctl(sock_raw_fd_lo, SIOCGIFINDEX, &req))
	{
		CNCAPI_ERR("ioctl error!\n");
		close(sock_raw_fd_lo);
		return -1;
	}
	
	/*将网络接口赋值给原始套接字地址结构*/
	bzero(&sll_lo, sizeof(sll_lo));
	sll_lo.sll_ifindex = req.ifr_ifindex;
	

	return 0;
}

/*
	定义：int lo_data_pkt_send_handle(u8* pkt,u16 len);
	功能：完成回环网卡的数据报文的发送处理
	输入参数：数据报文指针、数据报文长度
	返回结果：成功返回0，失败返回-1
*/
int lo_data_pkt_send_handle(u8* pkt,u16 len)
{
	
	int strlen;
	//printf("len = %d,sizeof(tsninsight_udp_header) = %d",len,sizeof(tsninsight_udp_header));

	//pkt = pkt-sizeof(tsninsight_udp_header);
	//len = len+sizeof(tsninsight_udp_header);
	//printf("send pkt\n");
	//cnc_pkt_print(pkt,len);

	strlen = sendto(sock_raw_fd_lo, pkt, len, 0 , (struct sockaddr *)&sll_lo, sizeof(sll_lo));
	if(len == -1)
	{
	   CNCAPI_ERR("sendto fail\n");
	   return -1;
	}
	free(pkt);
	
	return 0;
}


/*
	定义：int data_pkt_send_handle(u8* pkt,u16 len);
	功能：完成数据报文的发送处理
	输入参数：数据报文指针、数据报文长度
	返回结果：成功返回0，失败返回-1
*/
int remote_data_pkt_send_handle(u8* pkt,u16 len)
{
	int strlen;
	//CNCAPI_DBG("send pkt\n");

	cnc_pkt_print(pkt,len);
	
	strlen = sendto(sock_raw_fd, pkt, len, 0 , (struct sockaddr *)&sll, sizeof(sll));
	if(len == -1)
	{
	   CNCAPI_ERR("sendto fail\n");
	   return -1;
	}

	return 0;
}

/*
	定义：int data_pkt_send_handle(u8* pkt,u16 len);
	功能：完成数据报文的发送处理
	输入参数：数据报文指针、数据报文长度
	返回结果：成功返回0，失败返回-1
*/

int data_pkt_send_handle(u8* pkt,u16 len)
{

	int strlen;

	printf("send pkt\n");
	cnc_pkt_print(pkt,len);

	strlen = sendto(sock_raw_fd, pkt, len, 0 , (struct sockaddr *)&sll, sizeof(sll));
	if(len == -1)
	{
	   CNCAPI_ERR("sendto fail\n");
	   return -1;
	}
	
	return 0;
}


/*
	定义：int data_pkt_send_destroy();
	功能：完成数据报文发送相关资源的销毁
	输入参数：无
	返回结果：成功返回0，失败返回-1
*/

int data_pkt_send_destroy()
{
	close(sock_raw_fd);
	return 0;
}

int lo_data_pkt_send_destroy()
{
	close(sock_raw_fd_lo);
	return 0;
}






