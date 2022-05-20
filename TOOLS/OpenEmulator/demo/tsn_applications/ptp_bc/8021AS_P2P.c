/** *************************************************************************
 *  @file       8021AS_PTP.c
 *  @brief	    802.1AS P2P同步函数
 *  @date		2022/02/28 
 *  @author		junshuai.li
 *  @version	0.0.1 
编写人：李军帅
version0.0.1
1、初始版本			  
****************************************************************************/

#include "8021AS_PTP.h"
#include "./tsninsight/tsninsight.h"
#include "ptp_tsninsight.h"

u64 sync_seq = 0;//同步序列号，每同步一次加1
u8 first_sync_flag = 0;//第一次同步标志位

u16 bc_node_num = 0;//边界时钟节点的数量
u16 slave_node_num = 0;//从时钟节点的数量

u16 get_node_num = 0;//每轮同步接收到节点的数量


 void get_hcp_mac_from_mid(u8 *mac,u16 mid)
 {
	 mac[0] = 0x66;
	 mac[1] = 0x26;
	 mac[2] = 0x62;
	 mac[3] =(mid>>4)&0xff;
	 mac[4] = (mid&0xf)<<4;
	 mac[5] = 0x00;
 }

 void get_opensync_mac_from_mid(u8 *mac,u16 mid)
 {
	 mac[0] = 0x66;
	 mac[1] = 0x26;
	 mac[2] = 0x62;
	 mac[3] =(mid>>4)&0xff;
	 mac[4] = (mid&0xf)<<4;
	 mac[5] = 0x02;
 }
 u16 get_mid_from_mac(u8 *mac)
 {
	 u16 mid = 0;
	 mid = mac[3]<<4;
	 mid = mid + (mac[4]&0xf0)>>4; 
	 return mid;
 
 }


 //验证链路信息文本格式是否正确
 int verify_link_info_file(xmlDocPtr *doc,char *docname,xmlNodePtr *cur)
 {
			  
	 /* 进行解析，如果没成功，显示一个错误并停止 */  
	 *doc = xmlParseFile(docname);	
	 if(*doc == NULL){	
	  fprintf(stderr, "Document not parse successfully. \n");  
	  return -1;  
	 }	 
	 /* 获取文档根节点，若无内容则释放文档树并返回 */	 
	 *cur = xmlDocGetRootElement(*doc);  
	 if(*cur == NULL){	
	  fprintf(stderr, "empty document\n");	
	  xmlFreeDoc(*doc);  
	  return -1;  
	 }	 
 
	 /* 确定根节点名是否为nodes，不是则返回 */  
	 if(xmlStrcmp((*cur)->name, (const xmlChar *)"sync_info")){  
	  fprintf(stderr, "document of the wrong type, root node != links"); 
	  xmlFreeDoc(*doc);  
	  return -1;  
	 }	 
 
	 return 0;
 
 
 }

 //循环解析下一级节点的mac地址
 int parse_next_class_mac(xmlNodePtr cur,next_class_info  **next_class_link)
 {
	 int ret = 0; 
	 xmlNodePtr entry;
	 xmlChar* value;
	 //next_class_link = NULL;//节点信息
	 next_class_info *node = NULL;
	 next_class_info *temp_node = NULL;

	 //循环解析下一级mac地址
	 for(entry=cur->children;entry;entry=entry->next)
	 {	
		 if(xmlStrcasecmp(entry->name,(const xmlChar *)"mid")==0)
		 {
		 	next_class_info *node = malloc(sizeof(next_class_info));
			//根据解析的xml内容，对链表中节点元素赋值，只有头指针，没有头节点，差用尾插法
			value=xmlNodeGetContent(entry);
			node->mid = atoi(value);
		 
			node->next = NULL;
			if(*next_class_link == NULL)
				*next_class_link = node;
			else
				temp_node->next = node;
			temp_node = node;	
		 }
		 
	 }
	 /*
	 temp_node = *next_class_link;
	 while(temp_node != NULL)
	 {
		 temp_node = temp_node->next;
	 }
 	 */
	 return 0;

}

 int parse_slave_info(xmlNodePtr cur,ptp_sync_context *ptp_sync)
  {
	  int ret = 0;
	  xmlChar* value; 
	  cur=cur->xmlChildrenNode;

	  ptp_slave_info *cur_slave_node = NULL;
	  ptp_slave_info *temp_slave_node = (ptp_slave_info *)malloc(sizeof(ptp_slave_info));
	  memset((u8 *)temp_slave_node,0,sizeof(ptp_slave_info));
	  temp_slave_node->next_slave = NULL;
	  while(cur != NULL)
	  {  
  
		  if(!xmlStrcmp(cur->name, (const xmlChar *)"mid"))
		  {  
			  value=xmlNodeGetContent(cur);
			  temp_slave_node->mid = atoi(value);		  
		  } 				  
		  else if(!xmlStrcmp(cur->name, (const xmlChar *)"link_delay"))
		  {
			value=xmlNodeGetContent(cur);
			temp_slave_node->link_delay = atoi(value);

		  }
		  
		  cur = cur->next;					  
	  }
	  
  	 //首先判断是否为slave首节点
	  if(ptp_sync->slave == NULL)
	  {
		 ptp_sync->slave = temp_slave_node;
	  }
	  else
	  {
	  	 cur_slave_node = ptp_sync->slave;
		 while(cur_slave_node->next_slave != NULL)
		 {
			cur_slave_node = cur_slave_node->next_slave;
		 }
		 cur_slave_node->next_slave = temp_slave_node;
	  }
	  return 0;   
  }


 int parse_bc_info(xmlNodePtr cur,ptp_sync_context *ptp_sync)
 {
	 int ret = 0;
	 xmlChar* value;
 
	 cur=cur->xmlChildrenNode;
	 ptp_bc_info *cur_bc_node = NULL;
	 ptp_bc_info *temp_bc_node = (ptp_bc_info *)malloc(sizeof(ptp_bc_info));
	 temp_bc_node->next_bc = NULL;
	 temp_bc_node->next_class_link = NULL;

	 while(cur != NULL)
	 {	
 
		 if(!xmlStrcmp(cur->name, (const xmlChar *)"mid"))
		 {	
			 value=xmlNodeGetContent(cur);
			 temp_bc_node->mid = atoi(value);			 
		 }					 
		 else if(!xmlStrcmp(cur->name, (const xmlChar *)"next_class_info_table"))
			 parse_next_class_mac(cur,&(temp_bc_node->next_class_link));
		 else if(!xmlStrcmp(cur->name, (const xmlChar *)"link_delay"))
		 {
			 value=xmlNodeGetContent(cur);
			temp_bc_node->link_delay = atoi(value);

		 }
		 cur = cur->next;					 
	 }

	 //首先判断bc是否为首节点
	  if(ptp_sync->bc == NULL)
	  {
		 ptp_sync->bc = temp_bc_node;
	  }
	  else
	  {
	  	 cur_bc_node = ptp_sync->bc;
		 while(cur_bc_node->next_bc != NULL)
		 {
			cur_bc_node = cur_bc_node->next_bc;
		 }
		 cur_bc_node->next_bc = temp_bc_node;
	  }

	 
	 return 0;	 
 }



int parse_gm_info(xmlNodePtr cur,ptp_sync_context *ptp_sync)
{
	int ret = 0;
	xmlChar* value;
	cur=cur->xmlChildrenNode;
	
	ptp_gm_info *cur_gm_node = NULL;
	ptp_gm_info *temp_gm_node = (ptp_gm_info *)malloc(sizeof(ptp_gm_info));
	temp_gm_node->next_class_link = NULL;
	temp_gm_node->next_gm = NULL;
	
	while(cur != NULL)
	{  

		if(!xmlStrcmp(cur->name, (const xmlChar *)"mid"))
		{  
			value=xmlNodeGetContent(cur);
			temp_gm_node->mid = atoi(value);				
		}
		else if(!xmlStrcmp(cur->name, (const xmlChar *)"sync_period"))
		{  
			value=xmlNodeGetContent(cur);
			temp_gm_node->sync_period = strtol(value,NULL,0);
		}					 		
		else if(!xmlStrcmp(cur->name, (const xmlChar *)"next_class_info_table"))
		{
			parse_next_class_mac(cur,&(temp_gm_node->next_class_link));
		}
		
		cur = cur->next;			 		
	}

	//首先判断gm是否为首节点
	 if(ptp_sync->gm == NULL)
	 {
		ptp_sync->gm = temp_gm_node;
		
	 }
	 else
	 {	 
		cur_gm_node = ptp_sync->gm;
		while(cur_gm_node->next_gm != NULL)
		{
		   cur_gm_node = cur_gm_node->next_gm;
		}
		cur_gm_node->next_gm = temp_gm_node;
	 }
	

	return 0;  	
}


 int parse_device_info(xmlNodePtr cur,ptp_sync_context *ptp_sync)
 {
	int ret = 0;
	xmlChar* value;

	cur=cur->xmlChildrenNode;
	ptp_sync->dev_info = (device_info *)malloc(sizeof(device_info));
	while(cur != NULL)
	{  
        /* 首先解析设备类型，并使用字符串进行比较 */  
        if(!xmlStrcmp(cur->name, (const xmlChar *)"device_type"))
		{  
			value=xmlNodeGetContent(cur);
			if(strcmp("CTL",value) == 0)
			{
				ptp_sync->dev_info->dev_type = PTP_CTL;				
			}
			else if(strcmp("GM",value) == 0)
			{
				ptp_sync->dev_info->dev_type = PTP_GM;
			}		
			else if(strcmp("BC",value) == 0)
			{
				ptp_sync->dev_info->dev_type = PTP_BC;
			}
			else if(strcmp("SLAVE",value) == 0)
			{
				ptp_sync->dev_info->dev_type = PTP_SLAVE;
			}					
        }
        else if(!xmlStrcmp(cur->name, (const xmlChar *)"mid"))
		{  
			value=xmlNodeGetContent(cur);
			ptp_sync->dev_info->mid = atoi(value);			
        }
        cur = cur->next; /* 下一个子节点 */  		
	}

    return 0;  	
 }

 
 //初始化同步链路信息，解析link_info的xml文本
 int ptp_link_init(ptp_sync_context *ptp_sync)
 {
	 int ret = 0;
	 /* 定义文档和节点指针 */	
	 xmlDocPtr doc;  
	 xmlNodePtr cur;  
 
	 //验证链路信息文本格式是否正确
	 ret = verify_link_info_file(&doc,"link_info.xml",&cur);
	 if(ret == -1)
	 {
		 return -1;
	 }	 
	 cur = cur->xmlChildrenNode;
  
	 //循环解析下一级节点
	 while(cur != NULL)
	 {	
	 
		 if(!xmlStrcmp(cur->name, (const xmlChar *)"device_info"))
		 {	 
			 ret = parse_device_info(cur,ptp_sync); /* 解析device_info子节点 */ 
			 if(ret == -1)
			 {
				 return -1;
			 }	 
		 }
		 else if(!xmlStrcmp(cur->name, (const xmlChar *)"GrandMaster"))
		 {	 
			 ret = parse_gm_info(cur,ptp_sync); /* 解析GrandMaster子节点 */ 
			 if(ret == -1)
			 {
				 return -1;
			 }	 
		 }
		 else if(!xmlStrcmp(cur->name, (const xmlChar *)"BC"))
		 {	 		 
			 ret = parse_bc_info(cur,ptp_sync); /* 解析BC子节点 */ 
			 if(ret == -1)
			 {
				 return -1;
			 }
			 bc_node_num++;
		 }
		 else if(!xmlStrcmp(cur->name, (const xmlChar *)"slave"))
		 {	 
			 ret = parse_slave_info(cur,ptp_sync); /* 解析slave子节点 */ 
			 if(ret == -1)
			 {
				 return -1;
			 }	 			 
			 slave_node_num++;
		 }
		 
		 cur = cur->next; /* 下一个子节点 */	
	 }
	 
	 xmlFreeDoc(doc); /* 释放文档树 */  
	 return 0; 
	 
	 
 }

void printf_link_info(ptp_sync_context *ptp_sync)
{
	ptp_gm_info *gm = NULL;
	ptp_bc_info *bc = NULL;
	ptp_slave_info *slave = NULL;
	next_class_info *temp_next_class_link = NULL;


	printf("**************************device_info***************\n");
	printf("dev_type %d\n",ptp_sync->dev_info->dev_type);
	printf("dev mid %d\n",ptp_sync->dev_info->mid);

	
	
	gm = ptp_sync->gm;
	while(gm != NULL)
	{
		printf("******************************gm_info***************\n");
		printf("gm mid %d\n",gm->mid);
		printf("sync_period %lld\n",gm->sync_period);
		temp_next_class_link = gm->next_class_link;
		while(temp_next_class_link != NULL)
		{
			printf("next_class_link mid %d\n",temp_next_class_link->mid); 	
			temp_next_class_link = temp_next_class_link->next;			
		}
		gm = gm->next_gm;		
	}

	
	bc = ptp_sync->bc;
	while(bc != NULL)
	{
		printf("********************************bc_info*************\n");
		printf("bc mid %d\n",bc->mid);
		
		printf("link_delay %lld\n",bc->link_delay);
		temp_next_class_link = bc->next_class_link;
		while(temp_next_class_link != NULL)
		{
			printf("next_class_link mid %d\n",temp_next_class_link->mid); 	
			temp_next_class_link = temp_next_class_link->next;			
		}
		bc = bc->next_bc;		
	}

	slave = ptp_sync->slave;
	while(slave != NULL)
	{
		printf("*****************************slave_info*************\n");
		printf("slave mid %d\n",slave->mid);
		printf("link_delay %lld\n",slave->link_delay);
		
		slave = slave->next_slave;
	}	
	
}




//系统初始化函数
int sync_init(u8 *net_interface,libnet_t **send_t,pcap_t **receive_t,ptp_sync_context *ptp_sync)
{


	//链路初始化
	ptp_link_init(ptp_sync);
	//初始化网络状态数据结构
	ptp_sync->sta = (ptp_staticstic *)malloc(sizeof(ptp_staticstic));
	ptp_sync->sta->max_offset = 0xffffffffffffffff;//初始化最大offset
	
	printf_link_info(ptp_sync);
	
	//报文发送和接收初始化
	
#ifndef SIM
	*send_t = os_pkt_send_init(net_interface,NULL);//报文发送初始化
	//*receive_t = os_pkt_receive_init(net_interface,"ether[12:2]=0xff01");//报文接收初始化
	*receive_t = os_pkt_receive_init(net_interface,"ether[12:2]=0xff01 || ether[34]=0x1f");//报文接收初始化

#endif

#if SIM
	*send_t = os_pkt_send_init(SEND_IO_PATH,SEND_STATE_PATH);//报文发送初始化
	*receive_t = os_pkt_receive_init(RECV_IO_PATH,NULL);//报文接收初始化
#endif
	//构建超时数组
	//在802.1AS_PTP.h中声明一个全局数组


	return 0;
}


int parse_pkt_get_cur_hw_state(u8 *pkt,u8 *cur_node_mac)
{

	tsmp_get_req *get_req_pkt = (tsmp_get_req *)pkt;//
	if(memcmp(get_req_pkt->tsmp_head.smac,cur_node_mac,6)==0 &&
				ntohs(get_req_pkt->tsmp_head.eth_type) == 0xff01 &&
				get_req_pkt->tsmp_head.type == NET_MANAGE &&
				get_req_pkt->tsmp_head.sub_type == GET_RES &&
				ntohl(get_req_pkt->get_req_head.base_addr) == SYNC_STATE_REG_ADDR )
	{
		return ntohl(get_req_pkt->data[0]);
	}
	
}

int send_read_sync_state_req_pkt(u8 *dev_mac, u8 *cur_node_mac, u16 num,u32 base_addr, libnet_t * send_t)
{

	//开辟报文空间
	tsmp_get_req *get_req_pkt = (tsmp_get_req *)malloc(60);

	//对TSMP头进行赋值
	//对目的mac赋值，目的mac传递过来的mac地址
	memcpy(get_req_pkt->tsmp_head.dmac,cur_node_mac,6);
	//对源mac赋值，源mac为运行设备的mac地址
	memcpy(get_req_pkt->tsmp_head.smac,dev_mac,6);
	get_req_pkt->tsmp_head.eth_type = htons(0xff01);
	get_req_pkt->tsmp_head.type = NET_MANAGE;
	get_req_pkt->tsmp_head.sub_type = GET_REQ;

	get_req_pkt->get_req_head.num = htons(num);
	get_req_pkt->get_req_head.base_addr = htonl(base_addr);

	os_pkt_send((u8 *)get_req_pkt,sizeof(tsmp_ptp),send_t);
	free((u8 *)get_req_pkt);

	return 0;
}

int send_net_manage_set_req_pkt(u8 *dev_mac, u8 *cur_node_mac, u16 num,u32 base_addr,u32 *data, libnet_t * send_t)
{
	u8 i = 0;
	//开辟报文空间
	tsmp_get_req *get_req_pkt = (tsmp_get_req *)malloc(60);

	//对TSMP头进行赋值
	//对目的mac赋值，目的mac传递过来的mac地址
	memcpy(get_req_pkt->tsmp_head.dmac,cur_node_mac,6);
	//对源mac赋值，源mac为运行设备的mac地址
	memcpy(get_req_pkt->tsmp_head.smac,dev_mac,6);
	get_req_pkt->tsmp_head.eth_type = htons(0xff01);
	get_req_pkt->tsmp_head.type = NET_MANAGE;
	get_req_pkt->tsmp_head.sub_type = SET_REQ;

	get_req_pkt->get_req_head.num = htons(num);
	get_req_pkt->get_req_head.base_addr = htonl(base_addr);

	for(i=0;i<num;i++)
		get_req_pkt->data[i] = data[i];//data不需要主机序转网络序，因为传过来的数据已经转换

	os_pkt_send((u8 *)get_req_pkt,sizeof(tsmp_ptp),send_t);
	free((u8 *)get_req_pkt);


}

void ptp_init_cfg(ptp_sync_context *ptp_sync,libnet_t *send_t)
{
	u8 temp_mac1[6] = {0};
	u8 temp_mac2[6] = {0};
	ptp_gm_info *gm = NULL;
	ptp_bc_info *bc = NULL;
	ptp_slave_info *slave = NULL;
	next_class_info *temp_next_class_link = NULL;
	u32 data[10] = {0};//用于存储配置内容
	
	gm = ptp_sync->gm;
	while(gm != NULL)
	{
		get_opensync_mac_from_mid(temp_mac1, ptp_sync->dev_info->mid);
		get_hcp_mac_from_mid(temp_mac2, gm->mid);
		//memcpy((u8 *)data + 2,temp_mac1,6);
		data[0] = htonl(ptp_sync->dev_info->mid);

		printf("dev mac %d\n",ptp_sync->dev_info->mid);
		send_net_manage_set_req_pkt(temp_mac1,temp_mac2,1,SYNC_CID_REG_ADDR,data,send_t);	
		data[0] = TSN_MODE;
		data[0] = htonl(data[0]);//主机序转网络序
		
		//send_net_manage_set_req_pkt(temp_mac1,temp_mac2,1,TSN_OR_TTE_MODE_REG_ADDR,data,send_t);
		gm = gm->next_gm;		
	}

	bc = ptp_sync->bc;
	while(bc != NULL)
	{
		get_opensync_mac_from_mid(temp_mac1, ptp_sync->dev_info->mid);
		get_hcp_mac_from_mid(temp_mac2, bc->mid);
		
		//memcpy((u8 *)data + 2,temp_mac1,6);
		data[0] = htonl(ptp_sync->dev_info->mid);
		send_net_manage_set_req_pkt(temp_mac1,temp_mac2,1,SYNC_CID_REG_ADDR,data,send_t);
		//send_net_manage_set_req_pkt(temp_mac1,temp_mac2,2,SYNC_MAC_L_ADDR,data,send_t);	
		data[0] = TSN_MODE;
		data[0] = htonl(data[0]);//主机序转网络序		
		//send_net_manage_set_req_pkt(temp_mac1,temp_mac2,1,TSN_OR_TTE_MODE_REG_ADDR,data,send_t);
		bc = bc->next_bc;		
	}

	slave = ptp_sync->slave;
	while(slave != NULL)
	{
		get_opensync_mac_from_mid(temp_mac1, ptp_sync->dev_info->mid);
		get_hcp_mac_from_mid(temp_mac2, slave->mid);
		
		//memcpy((u8 *)data + 2,temp_mac1,6);
		data[0] = htonl(ptp_sync->dev_info->mid);
		send_net_manage_set_req_pkt(temp_mac1,temp_mac2,1,SYNC_CID_REG_ADDR,data,send_t);
		//send_net_manage_set_req_pkt(temp_mac1,temp_mac2,2,SYNC_MAC_L_ADDR,data,send_t);	
		data[0] = TSN_MODE;
		data[0] = htonl(data[0]);//主机序转网络序		
		//send_net_manage_set_req_pkt(temp_mac1,temp_mac2,1,TSN_OR_TTE_MODE_REG_ADDR,data,send_t);
		slave = slave->next_slave;
	}	
	
}





int send_next_class_sync_pkt(u16 dev_mid,u8 cur_node_mid,next_class_info *next_class_link,libnet_t *send_t)
{
	u8 temp_mac[8] 	   = {0};
	//u8 cur_node_mac[6] = {0};
	next_class_info *temp_next_class_link = NULL;
	//printf("1111111111111111\n");
	//开辟报文空间
	tsmp_ptp *tsmp_ptp_pkt = (tsmp_ptp *)malloc(sizeof(tsmp_ptp));
	memset((u8 *)tsmp_ptp_pkt,0,sizeof(tsmp_ptp));
	//对TSMP头进行赋值
	//对目的mac赋值，目的mac为传递过来的mid经过转换后的地址
	get_hcp_mac_from_mid(temp_mac,cur_node_mid);
	memcpy(tsmp_ptp_pkt->tsmp_head.dmac,temp_mac,6);
	//对源mac赋值，源mac为运行设备的mac地址
	get_opensync_mac_from_mid(temp_mac,dev_mid);
	memcpy(tsmp_ptp_pkt->tsmp_head.smac,temp_mac,6);
	tsmp_ptp_pkt->tsmp_head.eth_type = ntohs(0xff01);
	tsmp_ptp_pkt->tsmp_head.type = OPENSYNC;
	tsmp_ptp_pkt->tsmp_head.sub_type = OPENSYNC_REQ;


	//对opensync头进行赋值,调用opensync库
	os_header_generate(0,&(tsmp_ptp_pkt->opensync_head));

	//对PTP报文内容赋值,都赋值为0
	memset(&(tsmp_ptp_pkt->ptp_pkt_info),0,sizeof(ptp_pkt));
	tsmp_ptp_pkt->ptp_pkt_info.majorSdoID = 0x1;
	tsmp_ptp_pkt->ptp_pkt_info.minorSdoId = 0x0;
	tsmp_ptp_pkt->ptp_pkt_info.message_type = 0x0;//0表示事件类型，1表示通用类型
	tsmp_ptp_pkt->ptp_pkt_info.minorVesionPTP = 0x1;//发送是1，接收被忽略
	//tsmp_ptp_pkt->ptp_pkt_info. = 0x2;//发送是2，接收如果不是2被忽略
	tsmp_ptp_pkt->ptp_pkt_info.messageLength = htons(44);//PTP头为34字节，时间戳为10字节
	tsmp_ptp_pkt->ptp_pkt_info.domainNumber = 0;//域号的范围为0-127
	tsmp_ptp_pkt->ptp_pkt_info.flags = 0;//一步模式设置为全0
	tsmp_ptp_pkt->ptp_pkt_info.sequenceId = ntohs(sync_seq);//对序列号进行赋值

	//对以太网头赋值,目的mac为下一级节点的mac地址，源mac为函数传递来的mac地址
	temp_next_class_link = next_class_link;
	while(temp_next_class_link != NULL)
	{
	
		get_hcp_mac_from_mid(temp_mac,temp_next_class_link->mid);
		memcpy(tsmp_ptp_pkt->ether_head.dmac,temp_mac,6);
		get_hcp_mac_from_mid(temp_mac,cur_node_mid);
		memcpy(tsmp_ptp_pkt->ether_head.smac,temp_mac,6);	//源mac为函数传递来的mac地址
		tsmp_ptp_pkt->ether_head.eth_type = ntohs(0x88f7);
		
		os_pkt_send((u8 *)tsmp_ptp_pkt,sizeof(tsmp_ptp),send_t);

		temp_next_class_link = temp_next_class_link->next;
	}
 
	free((u8 *)tsmp_ptp_pkt);

	//对ptp报文赋值

}

u8 test_flag = 0;

//构建sync报文，然后发送
//更新时间
int gm_timeout_fun(u64 cur_time_count_ns,ptp_sync_context *ptp_sync,libnet_t *send_t)
{

	printf("sync timer out !\n");
	g_timer_array[PTP_TIMEOUT_IDX] = cur_time_count_ns;
	//printf("cur_time_count_ns %lld\n",cur_time_count_ns);
	
	sync_seq++;
	//判断当前最大的offset是否小于标准值，以及上报节点的数量是否等于需要同步节点的数量
	if(ptp_sync->sta->max_offset <= MAX_OFFSET_STAND && (bc_node_num + slave_node_num) == get_node_num)
	{
		//判断是否为第一次同步
		if(first_sync_flag == 0)
		{
			printf("send trap setnetstate finish sync\n");
			tsninsight_send_netstate_trap_pkt(FININSH_SYNC);
			//修改网络状态为完成同步状态
			G_NET_STATE = FININSH_SYNC;
			first_sync_flag = 1;
		}
		//在下一轮开始同步时，max_offset的offset赋值为0
		//ptp_sync->sta->max_offset = 0;
		//get_node_num = 0;
	}

	if(ptp_sync->sta->max_offset > MAX_OFFSET_STAND)
	{
		printf("error:cur sync max_offset %llu,seq = %llu\n",ptp_sync->sta->max_offset,sync_seq);
		write_debug_msg("error:cur sync max_offset %llu,seq = %llu\n",ptp_sync->sta->max_offset,sync_seq);

	}
	if((bc_node_num + slave_node_num) != get_node_num)
	{
		printf("error:get sync node num is %d,need sync node num is %d\n",get_node_num,bc_node_num+slave_node_num);
		write_debug_msg("error:get sync node num is %d,need sync node num is %d\n",get_node_num,bc_node_num+slave_node_num);

	}

	if(sync_seq>20)
	{
		printf("sync_seq %lld\n",sync_seq);
		if(ptp_sync->sta->max_offset > MAX_OFFSET_STAND || (bc_node_num + slave_node_num) != get_node_num)
		{
			printf("error:cur sync max_offset %llu\n",ptp_sync->sta->max_offset);
			printf("error:get sync node num is %d,need sync node num is %d\n",get_node_num,bc_node_num+slave_node_num);			
			write_debug_msg("error:get sync node num is %d,need sync node num is %d,seq = %llu\n",get_node_num,bc_node_num+slave_node_num,sync_seq);		
			write_debug_msg("error:cur sync max_offset %llu,seq = %llu\n",ptp_sync->sta->max_offset,sync_seq);
/*
			if(test_flag == 0)
				return 0;
			else
			{
				test_flag = 1;
				return 0;
			}
*/
		}
	}

	ptp_sync->sta->max_offset = 0;
	get_node_num = 0;


	
	//向gm节点的下一级发送sync报文
	send_next_class_sync_pkt(ptp_sync->dev_info->mid,ptp_sync->gm->mid,ptp_sync->gm->next_class_link,send_t);

	return 0;
}


//超时处理函数
int timer_func(u64 cur_time_count_ns,ptp_sync_context *ptp_sync,libnet_t *send_t)
{
	int ret = 0;
	int i = 0;
	for(i=0;i<MAX_TIMER_NUM;i++)
	{
	
		//如果主节点不存在，则跳出本次超时
		if(ptp_sync->gm == NULL && i ==PTP_TIMEOUT_IDX)
		{
			continue;
		}
		//每个数组对应不同的处理函数，因此使用case语句，ptp只有一个超时处理函数，
		switch(i)
		{
			case PTP_TIMEOUT_IDX:	if(get_diff(cur_time_count_ns,g_timer_array[i]) >= ptp_sync->gm->sync_period) ret = gm_timeout_fun(cur_time_count_ns,ptp_sync,send_t);break;
			case REPORT_TIMEOUT_IDX:if(get_diff(cur_time_count_ns,g_timer_array[i]) >= report_period*1000000) report_timeout_fun(cur_time_count_ns,ptp_sync);break;
			default:break;
		}
		
	}

	if(ret == -1)
		return -1;
}
#if 0
u64 htonll(u64 value)
{
	return (((u64)htonl(value)) << 32) + htonl(value >> 32);
}
#endif

u64 get_time_ns_from_timestamp(u8 *data)
{
	u64 temp = 0;
	u64 return_data = 0;
	//低32bit为ns，高48bit为s，目前由于时钟只有64bit，因此s单位只去低32bit
	temp = data[0];
	return_data = return_data + temp;
	
	temp = data[1];
	temp = temp<<8;
	return_data = return_data + temp;

	temp = data[2];
	temp = temp<<16;
	return_data = return_data + temp;

	temp = data[3];
	temp = temp<<24;
	return_data = return_data + temp;

	//高48bit中只用到32bit
	temp = data[4];
	return_data = return_data + temp;	

	temp = data[5];
	temp = (temp<<8) * 1000000000;
	return_data = return_data + temp;	

	temp = data[6];
	temp = (temp<<16) * 1000000000;
	return_data = return_data + temp;		

	temp = data[7];
	temp = (temp<<24) * 1000000000;
	return_data = return_data + temp;	

	return return_data;
}



int slave_process(u8 *pkt,ptp_slave_info *slave_node,u8 *dev_mac,libnet_t *send_t)
{
	u8 temp_mac[6] = {0};
	//声明需要配置到硬件中寄存器的变量
	u64 reference_pit = 0;
	u64 syn_clk_cor = 0;

	tsmp_ptp *tsmp_ptp_pkt = (tsmp_ptp *)pkt;
	//调用opensync库函数，获取当前接收时间戳
	u64 receive_pit = os_get_receive_pit(pkt);
	u64 correctionfield = htonll(tsmp_ptp_pkt->ptp_pkt_info.corrField);
	correctionfield = correctionfield>>16;

	//根据公式计算出
	reference_pit = receive_pit;
	syn_clk_cor = correctionfield + slave_node->link_delay + get_time_ns_from_timestamp(tsmp_ptp_pkt->ptp_pkt_info.originTimestamp);

	//计算主从时间偏差offset
	if(syn_clk_cor > reference_pit)
		slave_node->offset = syn_clk_cor - reference_pit;
	else
		slave_node->offset = reference_pit - syn_clk_cor;
		
	printf("mid:%d,offset=%lld\n",slave_node->mid,slave_node->offset);
	printf("reference_pit = 0x%llx,syn_clk_cor = 0x%llx\n",reference_pit,syn_clk_cor);
	//调用opensync库，构建配置报文发送到硬件
	//os_cfg_clock_value(slave_node->mac,reference_pit,syn_clk_cor);
	get_hcp_mac_from_mid(temp_mac, slave_node->mid);
	os_cfg_local_clock(temp_mac,dev_mac,syn_clk_cor,reference_pit,send_t);


	return 0;
}




int bc_process(u8 *pkt,ptp_bc_info *bc_node,u8 *dev_mac,libnet_t *send_t)
{
	u8 temp_mac[6] = {0};

	//声明需要配置到硬件中寄存器的变量
	u64 reference_pit = 0;
	u64 syn_clk_cor = 0;

	tsmp_ptp *tsmp_ptp_pkt = (tsmp_ptp *)pkt;
	//调用opensync库函数，获取当前接收时间戳
	u64 receive_pit = os_get_receive_pit(pkt);
	u64 correctionfield = htonll(tsmp_ptp_pkt->ptp_pkt_info.corrField);
	correctionfield = correctionfield>>16;

	//根据公式计算出
	reference_pit = receive_pit;
	get_time_ns_from_timestamp(tsmp_ptp_pkt->ptp_pkt_info.originTimestamp);
	syn_clk_cor = correctionfield + bc_node->link_delay + get_time_ns_from_timestamp(tsmp_ptp_pkt->ptp_pkt_info.originTimestamp);

	//调用opensync库，构建配置报文发送到硬件
	//os_cfg_clock_value(bc_node->mac,reference_pit,syn_clk_cor);
	get_hcp_mac_from_mid(temp_mac,bc_node->mid);
	os_cfg_local_clock(temp_mac,dev_mac, syn_clk_cor,reference_pit,send_t);

	//计算主从时间偏差offset
	//计算主从时间偏差offset
	if(syn_clk_cor > reference_pit)
		bc_node->offset = syn_clk_cor - reference_pit;
	else
		bc_node->offset = reference_pit - syn_clk_cor;
	
	//bc_node->offset = syn_clk_cor - reference_pit;
	printf("mid:%d,offset=%lld\n",bc_node->mid,bc_node->offset);
	printf("reference_pit = 0x%llx,syn_clk_cor = 0x%llx\n",reference_pit,syn_clk_cor);

	//向下一级发送同步报文
	sync_seq = ntohs(tsmp_ptp_pkt->ptp_pkt_info.sequenceId);//从报文中获取序列号
	send_next_class_sync_pkt(get_mid_from_mac(dev_mac),bc_node->mid,bc_node->next_class_link,send_t);

	return 0;
}


int sync_pkt_process(u8 *pkt,u16 pkt_len,ptp_sync_context *ptp_sync,libnet_t *send_t)
{
	//判断是否为opensync报文
	//判断是否接收到正确的读报文
	tsmp_ptp *tsmp_ptp_pkt = (tsmp_ptp *)pkt;
	
	//使用node_find_flag来标志是否找到该节点
	u8 node_find_flag = 0;
	
	ptp_slave_info  *temp_slave = NULL;
	ptp_bc_info  *temp_bc = NULL;	

	u8 temp_mac[6] = {0};
	//pkt_print(pkt,pkt_len );
	//首先判断是否为opensync报文
	if(0xff01 == ntohs(tsmp_ptp_pkt->tsmp_head.eth_type) && OPENSYNC == tsmp_ptp_pkt->tsmp_head.type)
	{
		//根据源mac遍历bc链表
		temp_bc = ptp_sync->bc;
		while(temp_bc != NULL)
		{
			//判断源mac与当前bc的mac地址是否相同
			if(temp_bc->mid == get_mid_from_mac(tsmp_ptp_pkt->tsmp_head.smac))
			{
				get_opensync_mac_from_mid(temp_mac, ptp_sync->dev_info->mid);
				bc_process(pkt,temp_bc,temp_mac,send_t);
				node_find_flag = 1;//发现节点后置1
				//判断当前的offset是否为本轮同步最大的，如果是则替换ptp_sync中的状态中的max_offset
				if(temp_bc->offset > ptp_sync->sta->max_offset)
					ptp_sync->sta->max_offset = temp_bc->offset;
				get_node_num++;
				break;
			}
			temp_bc = temp_bc->next_bc;			
		}

		//判断遍历bc链表后是否发现节点，如果node_find_flag为0，表示未发现节点
		if(node_find_flag == 0)
		{
			//根据源mac遍历slave链表
			temp_slave = ptp_sync->slave;
			while(temp_slave != NULL)
			{
				//判断源mac与当前bc的mac地址是否相同
				//printf("temp_slave mid %d\n",temp_slave->mid);
				//printf("get pkt    mid %d\n",get_mid_from_mac(tsmp_ptp_pkt->ether_head.dmac));
				
				if(temp_slave->mid == get_mid_from_mac(tsmp_ptp_pkt->ether_head.dmac))
				{
					get_opensync_mac_from_mid(temp_mac, ptp_sync->dev_info->mid);
					slave_process(pkt,temp_slave,temp_mac,send_t);
					node_find_flag = 1;
					//判断当前的offset是否为本轮同步最大的，如果是则替换ptp_sync中的状态中的max_offset
					if(temp_slave->offset > ptp_sync->sta->max_offset)
						ptp_sync->sta->max_offset = temp_slave->offset;					
					get_node_num++;
					break;
				}
				temp_slave = temp_slave->next_slave;			
			}
		}

		if(node_find_flag == 0)
		{
			printf("*************error:not find node***************\n");
		}

	}

	return 0;
}



