/** *************************************************************************
 *  @file       basic_cfg.c
 *  @brief	    基础配置函数
 *  @date		2021/04/24 
 *  @author		junshuai.li
 *  @version	0.0.1
 ****************************************************************************/
#include "local_cfg.h"

//定义最大配置内容数量，共8bit
#define MAX_CFG_DATA_NUM 256



//解析规划配置中交换机的addr和data
void parse_plan_entry(xmlNodePtr cur,u32 *addr,u32 *data,u8 *plan_cfg_data_idx)
{
	xmlNodePtr entry;
	xmlChar* value;
	int i = 0;

	for(entry=cur->children;entry;entry=entry->next)
	{  
		//可以有一个地址和多个data的情况，因此data使用数组表示
    	if(xmlStrcasecmp(entry->name,(const xmlChar *)"data")==0)
		{
			value=xmlNodeGetContent(entry);
			sscanf(value,"%x",&data[*plan_cfg_data_idx]);			
			//printf("data：%x \n",data[*plan_cfg_data_idx]);
			(*plan_cfg_data_idx)++;

		}
    	else if(xmlStrcasecmp(entry->name,(const xmlChar *)"addr")==0)
		{
			value=xmlNodeGetContent(entry);
			sscanf(value,"%x",addr);
			//printf("addr：%x \n",*addr);
			
		}
		
	}
	
	return;
}


/* 解析switch内容，提取出lid和entry */  
 int plan_cfg_and_parse_node(xmlNodePtr cur,u8 *pkt)
{  

	int ret = 0;
	u16 hcp_mid = 0;
	u8 local_mac[6] = {0};
	u8 cmp_mac[6] = {0};
	
	u32 addr = 0;
	u32 tvalue = 0;
	u32 *read_data = NULL;

	u8 read_request_pkt[64]={0};//定义一个变量存储读请求报文

	u32 *plan_cfg_data 		= NULL;//定义离线规划配置内容的指针
	u8  plan_cfg_data_idx 	= 0;//定义数组的索引值

	xmlChar* value;

	//sizeof(tsmp_header)表示TSMP头、sizeof(tsmp_set_req_or_get_res_pkt_data)表示NMAC头
	plan_cfg_data = (u32 *)(pkt + sizeof(tsmp_header) + sizeof(tsmp_set_req_or_get_res_pkt_data));//配置的数据

	cur=cur->xmlChildrenNode;
	while(cur != NULL)
	{  
        /* 找到lid节点 */  
        if(!xmlStrcmp(cur->name, (const xmlChar *)"hcp_mid"))
		{ 
			value=xmlNodeGetContent(cur->children);
			sscanf(value,"%x",&tvalue);

			hcp_mid = (u16)tvalue;

			get_hcp_mac_from_mid(local_mac,hcp_mid);

        }
		else if(!xmlStrcmp(cur->name, (const xmlChar *)"entry"))
		{  
			//验证是否已正确获取local_mac，如果是则可以继续运行
			if(memcmp(local_mac,cmp_mac,6) == 0)
			{
				printf("error:cfg local_mac is 0\n");
				return -1;
			}
			//解析entry
			parse_plan_entry(cur,&addr,plan_cfg_data,&plan_cfg_data_idx);
			if(plan_cfg_data_idx != 0)
			{
				tsmp_set_req(local_mac,plan_cfg_data_idx,addr,pkt);//写请求
			
				//配置验证
				ret = cfg_varify(local_mac,plan_cfg_data_idx,addr,pkt);
	
				//配置验证失败，程序退出
				if(ret == -1)
				{
					return -1;
				}
				
				//验证完成后清零复位
				plan_cfg_data_idx = 0;
			}

			
        }
        cur = cur->next; /* 下一个子节点 */  		
	}
	printf("debug222222222222\n");

#if 0
	//配规划置结束，配置硬件状态寄存器为
	ret= cfg_hw_state(local_mac,TIME_SYNC_STATE,pkt);
	if(ret == -1)
	{
		return -1;
	}	
#endif

    return 0;  
	
}

int verify_plan_cfg_file(xmlDocPtr *doc,char *docname,xmlNodePtr *cur)
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
	 xmlCleanupParser();		
	 //xmlMemoryDump();
	 return -1;  
	}	

	/* 确定根节点名是否为nodes，不是则返回 */  
	if(xmlStrcmp((*cur)->name, (const xmlChar *)"network_plan_cfg")){  
	 fprintf(stderr, "document of the wrong type, root node != network_plan_cfg");	
	 xmlFreeDoc(*doc); 
	 xmlCleanupParser();		
	 //xmlMemoryDump();
	 return -1;  
	}	

	return 0;


}



int plan_cfg_and_parse_file(u8 *docname,u8 *pkt)
{
	int ret = 0;
    /* 定义文档和节点指针 */  
    xmlDocPtr doc;  
    xmlNodePtr cur;  

	//验证规划配置文本格式是否正确
	ret = verify_plan_cfg_file(&doc,docname,&cur);
	if(ret == -1)
	{
		return -1;
	}
	
	cur = cur->xmlChildrenNode;
 
	//循环解析switch
	while(cur != NULL)
	{  
	
		if(!xmlStrcmp(cur->name, (const xmlChar *)"node"))
		{  	
			printf("debug111111111\n");
			ret= plan_cfg_and_parse_node(cur,pkt); /* 解析switch子节点 */ 
			if(ret == -1)
			{
				xmlFreeDoc(doc); /* 释放文档树 */
				xmlCleanupParser();		
				//xmlMemoryDump();
				return -1;
			}	
		}
		
		cur = cur->next; /* 下一个子节点 */  
	}
    xmlFreeDoc(doc); /* 释放文档树 */ 
	xmlCleanupParser();		
	//xmlMemoryDump();
    return 0; 

}
	

//离线规划配置的入口函数
int local_cfg(u8* state)
{
	int ret = 0;
	
	//申请空间，用于构造配置报文
	u8 *pkt = (u8 *)malloc(MAX_PKT_LEN);
	bzero(pkt,MAX_PKT_LEN);
	
	//解析配置文本，并进行配置	
	ret = plan_cfg_and_parse_file(OFFLINE_PLAN_XML_FILE,pkt);
	if(ret == -1)
	{
		printf("parse_offline_plan_cfg_file fail\n");
		return -1;
	}	

	//本地规划配置完成
	*state = LOCAL_PLAN_CFG_FINISH_STATE;

	//发送网络状态trap报文函数
 	tsninsight_send_netstate_or_syncstate_trap_pkt(NETWORK_STATE,LOCAL_PLAN_CFG_FINISH);
	printf("*************enter SYNC_INIT_S********************\n");
	write_debug_msg("*************enter SYNC_INIT_S********************\n");
	free(pkt);

	return 0;
}
		

