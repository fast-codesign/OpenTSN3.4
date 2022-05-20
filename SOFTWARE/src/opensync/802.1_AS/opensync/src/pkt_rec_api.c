#include "../include/opensync.h"



//pcap_t* pcap_handle;

/*
	功能：完成数据报文接收资源的初始化。包括libpcap句柄的初始化、打开网络设备、设置过滤规则等。
	输入参数：过滤规则字符串指针，示例：u8* rule= "ether[3:1]=0x01 and ether[12:2]=0xff01";
	返回结果：成功返回0，失败返回-1
*/
pcap_t* os_pkt_receive_init(u8* net_interface, u8* filter_rule)
{
#ifndef SIM
	/*错误信息*/
	char error_content[128];

	/*获取网络接口名字*/
	if (NULL == net_interface)
	{
		perror("pcap_lookupdev");
	}

	/*打开网络接口*/
	pcap_t* pcap_handle = pcap_open_live(net_interface, 128, 1, -1, error_content);

	/*配置过滤器*/
	struct bpf_program filter;
	pcap_compile(pcap_handle, &filter, filter_rule, 1, 0);
	pcap_setfilter(pcap_handle, &filter);

	/*设置抓包方向*/
	 if (pcap_setdirection(pcap_handle, PCAP_D_IN) != 0)
	 {
	 	perror("error");
	 }

	/*设置非阻塞*/
	pcap_setnonblock(pcap_handle, 1, error_content);
	printf("LIBPCAP INIT SUCCESS.\n");
	return pcap_handle;
#endif
#if SIM
	data_pkt_receive_init(net_interface,2);
#endif

}

/*
	功能：非阻塞接收报文
	输入参数：报文长度的指针
	返回结果：成功返回报文首地址，否则返回空
*/
u8* os_pkt_receive(u16* pkt_len, pcap_t* pcap_handle)
{
#ifndef SIM
	struct pcap_pkthdr packet;
	//const u8 *pkt = pcap_next(pcap_handle,&packet);

	u8* pkt = NULL;
	pkt = (u8*)pcap_next(pcap_handle, &packet);

	if (pkt == NULL)//捕获数据包
	{
		return NULL;
	}
	else
	{
		//printf("pcap recv pkt\n");
		*pkt_len = packet.len;
		
		//os_pkt_print(pkt, *pkt_len);
		//printf("pkt_len %d\n",*pkt_len);
		
		return pkt;
	}
#endif
#if SIM
	u8* pkt = data_pkt_receive_dispatch_1(pkt_len);
	if(pkt != NULL)
	{
		//printf("recv pkt\n");
		//os_pkt_print(pkt, *pkt_len);

	}

	return pkt;
#endif
}


/*
	功能：完成数据报文接收资源的销毁
	输入参数：无
	返回结果：成功返回0，失败返回-1
*/
int os_pkt_receive_destroy(pcap_t* pcap_handle)
{
#ifndef SIM
	pcap_close(pcap_handle);
	return 0;
#endif
#if SIM
	data_pkt_receive_destroy();
#endif
}
