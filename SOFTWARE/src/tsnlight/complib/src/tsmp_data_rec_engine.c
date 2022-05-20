
#include "../include/comp_api.h"




//libpcap句柄变量定义
pcap_t * pcap_handle;





/*
	定义：int data_pkt_receive_init(u8* rule);
	功能：完成数据报文接收资源的初始化。包括libpcap句柄的初始化、打开网络设备、设置过滤规则等。
	输入参数：过滤规则字符串指针，示例：u8* rule= "ether[3:1]=0x01 and ether[12:2]=0xff01";
	返回结果：成功返回0，失败返回-1
*/

int data_pkt_receive_init(u8* rule,u8* net_interface)
{
	 char error_content[128];    //出错信息
	
	//获取网络接口名字
	CNCAPI_DBG("net_interface:%s\n",net_interface);
	if(NULL == net_interface)
	{
	    perror("pcap_lookupdev");
	    return -1;	
	}

	//打开网络接口
	pcap_handle = pcap_open_live(net_interface,65535,1,-1,error_content);

	/*配置过滤器*/
#if 1
	struct bpf_program filter;
	//CNCAPI_DBG("rule:%s\n",rule);
	pcap_compile(pcap_handle, &filter, rule, 1, 0);
	pcap_setfilter(pcap_handle, &filter);
#endif

	/*设置抓包方向*/
	if(pcap_setdirection(pcap_handle,PCAP_D_IN)!=0)
	{
		//CNCAPI_DBG("88888\n");
		perror("error");
		 return -1;

	}
	/*设置非阻塞*/
	pcap_setnonblock(pcap_handle, 1, error_content);
	return 0;	
}


/*
	定义：int data_pkt_receive_loop(pcap_handler callback);
	功能：循环接收数据报文，并且将数据报文送给callback函数进行处理。
	输入参数：数据报文处理函数callback
	返回结果：成功返回0，失败返回-1
*/

int data_pkt_receive_loop(pcap_handler callback)
{
	if(pcap_loop(pcap_handle,-1,callback,NULL) < 0)//捕获数据包
	{
	    perror("pcap_loop");
		return -1;
	}
	
	return 0;
}


/*
	定义：int data_pkt_receive_dispatch (pcap_handler callback);
	功能：循环接收数据报文，并且将数据报文送给callback函数进行处理。
	输入参数：数据报文处理函数callback
	返回结果：成功返回0，失败返回-1
*/

int data_pkt_receive_dispatch(pcap_handler callback)
{
	if(pcap_dispatch(pcap_handle,1,callback,NULL) < 0)//捕获数据包
	{
	    perror("pcap_dispatch");
		return -1;
	}
	
	return 0;
}


u8 *data_pkt_receive_dispatch_1(u16 *len)
{
	int i=0;

	
#if 1	
	struct pcap_pkthdr packet;
	//const u8 *pkt = pcap_next(pcap_handle,&packet);

	u8 *pkt = NULL;

	pkt = (u8 *)pcap_next(pcap_handle,&packet);
	
	
	
	
	
	if(pkt == NULL)//捕获数据包
	{
	    //perror("pcap_dispatch");
		return NULL;
	}
	else
	{
		printf("get pkt\n");
		cnc_pkt_print(pkt,packet.len);
		if(pkt[0] == 0x60)
		{
			//cnc_pkt_print(pkt,packet.len);

		}
		*len = packet.len;		
		return pkt;
	}
#endif	
}


/*
	定义：int data_pkt_receive_destroy ( );
	功能：完成数据报文接收资源的销毁
	输入参数：无
	返回结果：成功返回0，失败返回-1
*/

int data_pkt_receive_destroy()
{
	pcap_close(pcap_handle);
	return 0;
}








