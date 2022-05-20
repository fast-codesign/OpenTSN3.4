#include "../include/comp_api.h"


u8 TSNLIGHT_MAC[6] = {0};

void cnc_pkt_print(u8 *pkt,int len)
{
	int i=0;

	printf("-----------------------***CNC PACKET***-----------------------\n");
	printf("Packet Addr:%p\n",pkt);
	for(i=0;i<16;i++)
	{
		if(i % 16 == 0)
			printf("      ");
		printf(" %X ",i);
		if(i % 16 == 15)
			printf("\n");
	}
	
	for(i=0;i<len;i++)
	{
		if(i % 16 == 0)
			printf("%04X: ",i);
		printf("%02X ",*((u8 *)pkt+i));
		if(i % 16 == 15)
			printf("\n");
	}
	if(len % 16 !=0)
		printf("\n");
	printf("-----------------------***CNC PACKET***-----------------------\n\n");
}


void get_hcp_mac_from_mid(u8 *mac,u16 mid)
{
	mac[0] = 0x66;
	mac[1] = 0x26;
	mac[2] = 0x62;
	mac[3] =(mid>>4)&0xff;
	mac[4] = (mid&0xf)<<4;
	mac[5] = 0x00;
}

void get_tsnlight_mac_from_mid(u8 *mac,u16 mid)
{
	mac[0] = 0x66;
	mac[1] = 0x26;
	mac[2] = 0x62;
	mac[3] =(mid>>4)&0xff;
	mac[4] = (mid&0xf)<<4;
	mac[5] = 0x01;
}


int set_tsnlight_mac(u16 tsnlight_mid)
{
	TSNLIGHT_MAC[0] = 0x66;
	TSNLIGHT_MAC[1] = 0x26;
	TSNLIGHT_MAC[2] = 0x62;
	TSNLIGHT_MAC[3] =(tsnlight_mid>>4)&0xff;
	TSNLIGHT_MAC[4] = (tsnlight_mid&0xf)<<4;
	TSNLIGHT_MAC[5] = 0x01;
}


u64 htonll(u64 value)
{
	return (((u64)htonl(value)) << 32) + htonl(value >> 32);
}


u64 ntohll(u64 value)
{
	return (((u64)ntohl(value)) << 32) + ntohl(value >> 32);
}



//主机序到网络序转换
void host_to_net_switch(u32 *data,u8 num)
{
	u8 data_idx = 0;

	for(data_idx=0;data_idx<num;data_idx++)
	{
		data[data_idx] = htonl(data[data_idx]);				
	}
}

int cfg_hw_state(u8 *local_mac,u32 state,u8 *pkt)
{

	u32 *data = NULL;
	int ret = 0;

	data = (u32 *)(pkt + sizeof(tsmp_header) + sizeof(tsmp_set_req_or_get_res_pkt_data));
	data[0] = htonl(state);
	tsmp_set_req(local_mac,1,htonl(HW_STATE_ADDR),pkt);

	 //配置验证
    ret = cfg_varify(local_mac,1,htonl(HW_STATE_ADDR),pkt);

    //配置验证失败，程序退出
	if(ret == -1)
	{
		printf("cfg_hw_state cfg_varify error!\n");
		return -1;
	}
	

	printf("cfg_hw_state end!\n");
	return 0;
}


int tsmp_cfg_hcp_tsnlight_mid(u8 *mac,u16 hcp_mid,u16 tsnlight_mid,u8 *pkt)
{
	u16 pkt_len = 0;
	u32 *data =NULL;
	
	//获取报文长度,如果长度小于60，则设置默认值60字节
	pkt_len = sizeof(tsmp_header)+4;
	if(pkt_len<60)
		pkt_len = 60;

	tsmp_header *tsmp_header_info = (tsmp_header *)pkt;//对TSMP头进行赋值
	
	memcpy(tsmp_header_info->dmac,mac,6);
	memcpy(tsmp_header_info->smac,TSNLIGHT_MAC,6);
	tsmp_header_info->eth_type = htons(0xff01);
	tsmp_header_info->type = MID_DISTRI;
	tsmp_header_info->sub_type = MID_DISTRI;

	data = (u32 *)(pkt + sizeof(tsmp_header));
	data[0] = (tsnlight_mid<<12)|hcp_mid;
	printf("data[0] = %x \n",data[0]);
	
	data[0] = htonl(data[0]);
	

	data_pkt_send_handle(pkt,pkt_len);

	//清空pkt
	bzero(pkt,2048);
	
	return 0;

}


int tsmp_set_req(u8 *local_mac,u16 data_num,u32 addr,u8 *pkt)
{

	u16 pkt_len = 0;

	if(pkt == NULL)
	{
		printf("tsmp_set_req,pkt = NULL! \n");
		return -1;
	}

	if(data_num == 0)
	{
		printf("tsmp_set_req,data_num = 0! \n");
		return -1;
	}
	
	//获取报文长度,如果长度小于60，则设置默认值60字节
	pkt_len = sizeof(tsmp_header)+sizeof(tsmp_set_req_or_get_res_pkt_data) + data_num*4;
	if(pkt_len<60)
		pkt_len = 60;

	
	//对TSMP进行赋值
	tsmp_header *tsmp_header_info = (tsmp_header *)pkt;//对TSMP头进行赋值
	memcpy(tsmp_header_info->dmac,local_mac,6);
	//get_mac_from_mid(tsmp_header_info->smac, tsnlight_mid)
	memcpy(tsmp_header_info->smac,TSNLIGHT_MAC,6);
	tsmp_header_info->eth_type = htons(0xff01);
	tsmp_header_info->type = NET_MANAGE;//网络管理
	tsmp_header_info->sub_type = SET_REQ;//写请求

	tsmp_set_req_or_get_res_pkt_data *set_req = (tsmp_set_req_or_get_res_pkt_data *)(pkt + sizeof(tsmp_header));
	set_req->base_addr = addr;
	set_req->num = htons(data_num);

	//为避免再次开辟空间，data[0]中要配置的内容，在调用tsmp_set_req函数之前，已赋值给pkt变量
	//cnc_pkt_print(pkt, pkt_len);
	data_pkt_send_handle(pkt,pkt_len);

	//一般tsmp_set_req操作之后，都会需要调用tsmp_get_req和tsmp_get_res，以进行配置校验。由于pkt中有配置的内容，所以此处配置完之后，pkt不执行清0操作。
	return 0;
}


int tsmp_get_req(u8 *local_mac,u16 data_num,u32 addr,u8 *pkt)
{
	u16 pkt_len = 0;

	if(pkt == NULL)
	{
		printf("tsmp_get_req,pkt = NULL! \n");
		return -1;
	}

	if(data_num == 0)
	{
		printf("tsmp_get_req,data_num = 0! \n");
		return -1;
	}
	
	//获取报文长度,如果长度小于60，则设置默认值60字节
	pkt_len = sizeof(tsmp_header)+sizeof(tsmp_get_req_pkt_data);
	if(pkt_len<60)
		pkt_len = 60;


	//对TSMP进行赋值
	tsmp_header *tsmp_header_info = (tsmp_header *)pkt;//对TSMP头进行赋值
	memcpy(tsmp_header_info->dmac,local_mac,6);
	memcpy(tsmp_header_info->smac,TSNLIGHT_MAC,6);
	tsmp_header_info->eth_type =htons(0xff01);
	tsmp_header_info->type = NET_MANAGE;//网络管理
	tsmp_header_info->sub_type = GET_REQ;//写请求

	tsmp_get_req_pkt_data *get_req =(tsmp_get_req_pkt_data *)(pkt + sizeof(tsmp_header));
	get_req->base_addr = addr;
	get_req->num = htons(data_num);

	data_pkt_send_handle(pkt,pkt_len);

	//一般tsmp_set_req操作之后，都会需要调用tsmp_get_req和tsmp_get_res，以进行配置校验。由于pkt中有配置的内容，所以此处配置完之后，pkt不执行清0操作。
	return 0;
}

/*
该函数只能在主函数还未开启循环接收报文时使用
因为在该函数中有while(1)循环接收报文，
可能造成不是该函数接收的报文被丢弃
*/
u32 *tsmp_get_res(u8 *local_mac,u16 data_num,u32 addr)
{

	u16 pkt_len = 0;
	u8  *pkt = NULL;
	tsmp_header *get_tsmp = NULL;
	tsmp_set_req_or_get_res_pkt_data   *get_res = NULL;
	//构建和发送读寄存器报文，读取的数量，以及读取的基地址
	while(1)
	{
		//每次获取一个报文
		pkt = data_pkt_receive_dispatch_1(&pkt_len);
		
		if(pkt != NULL)
		{			
			get_tsmp = (tsmp_header *)pkt;
			get_res  = (tsmp_set_req_or_get_res_pkt_data *)(pkt + sizeof(tsmp_header));
#if 1

			//cnc_pkt_print(pkt,pkt_len);

			//判断是否接收到正确的读报文
			if( memcmp(local_mac,(u8 *)pkt+6,6) == 0)
				printf("1\n");
			if( 0xff01 == ntohs(get_tsmp->eth_type))
				printf("2\n");
			if( GET_RES == get_tsmp->sub_type)
				printf("3\n");
			if( get_res->base_addr == addr)
				printf("4\n");
			if( ntohs(get_res->num) == data_num)
				printf("5\n");
#endif			
			if( memcmp(local_mac,(u8 *)pkt+6,6) == 0 && 
				0xff01 == ntohs(get_tsmp->eth_type) && 
				GET_RES == get_tsmp->sub_type &&
				get_res->base_addr == addr	  &&
				ntohs(get_res->num) == data_num)
			{
				printf("6\n");
				//cnc_pkt_print((u8*)(get_res->data),pkt_len-sizeof(tsmp_header)-6);
				return get_res->data;//
			}
			else
			{
				printf("get_res pkt type error\n");
				continue;
			}

		}
	
	}
	
	return NULL;

}


int tsmp_opensync_req(u8 *local_mac,u64 send_or_recv_pit,u64 local_pit,u16 sync_len,u8 *pkt)
{
	u16 pkt_len = 0;
	tsmp_header *tsmp_header_info = NULL;
	tsmp_opensync_req_or_opensync_res_pkt_data *opensync_req=NULL;
	//获取报文长度,如果长度小于60，则设置默认值60字节
	pkt_len = sizeof(tsmp_header)+sizeof(tsmp_opensync_req_or_opensync_res_pkt_data)+sync_len;
	if(pkt_len<60)
		pkt_len = 60;


	//对TSMP进行赋值
	tsmp_header_info = (tsmp_header *)pkt;//对TSMP头进行赋值
	memcpy(tsmp_header_info->dmac,local_mac,6);
	memcpy(tsmp_header_info->smac,TSNLIGHT_MAC,6);
	tsmp_header_info->eth_type = htons(0xff01);
	tsmp_header_info->type = OPENSYNC;//网络管理
	tsmp_header_info->sub_type = OPENSYNC_REQ;//写请求

	opensync_req = (tsmp_opensync_req_or_opensync_res_pkt_data *)(pkt + sizeof(tsmp_header));
	opensync_req->send_or_recv_pit = send_or_recv_pit;
	opensync_req->local_time = local_pit;

	data_pkt_send_handle(pkt,pkt_len);
	return 0;

}

u8 *tsmp_opensync_res(u8 *pkt,u64 *receive_pit,u64 *local_time)
{
	u16 pkt_len = 0;
	//u8  *pkt = NULL;
	tsmp_header *get_tsmp = NULL;
	tsmp_opensync_req_or_opensync_res_pkt_data   *opensync_res = NULL;

	get_tsmp = (tsmp_header *)pkt;
	opensync_res = (tsmp_opensync_req_or_opensync_res_pkt_data *)(pkt + sizeof(tsmp_header));
	
	//判断是否接收到正确的读报文
	if(0xff01 == ntohs(get_tsmp->type) && OPENSYNC_RES == get_tsmp->sub_type && OPENSYNC == get_tsmp->type )
	{
		*receive_pit = ntohll(opensync_res->send_or_recv_pit);
		*local_time  = ntohll(opensync_res->local_time);
		return opensync_res->data;//
	}
	else
		return NULL;
	
}


int cfg_varify(u8 *local_mac,u16 data_num,u32 addr,u8 *pkt)
{

#if 1
	u32 *read_data = NULL;
	u32 *cfg_data = NULL;

	//配置的数据
	cfg_data = (u32 *)(pkt + sizeof(tsmp_header) + sizeof(tsmp_set_req_or_get_res_pkt_data));
	
	//先进行读请求操作，再进行写请求操作，然后对配置的内容和返回响应的内容进行比较验证
	tsmp_get_req(local_mac,data_num,addr,pkt);//读请求
	
	read_data = tsmp_get_res(local_mac,data_num,addr);//读响应
	//进行配置验证

	printf("7\n");
	if(read_data == NULL)
	{
		printf("cfg_varify fail!read_data == NULL\n");
	}
	
	if(memcmp((u8 *)cfg_data,(u8 *)read_data, data_num*sizeof(u32)) != 0)
	{
		printf("addr:%x,cfg_data:%x,read_data:%x\n",addr,cfg_data[0],read_data[0]);
		printf("cfg_varify fail\n");

		return -1;
	}

	printf("8\n");
	
	//清空pkt
	bzero(pkt,2048);

	printf("9\n");
#endif
	return 0;

}




