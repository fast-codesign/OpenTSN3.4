/** *************************************************************************
 *  @file       net_init.c
 *  @brief	    网络初始化函数
 *  @date		2021/04/23 
 *  @author		junshuai.li
 *  @version	0.0.1
 ****************************************************************************/
#include "net_init.h"


static u16 parse_tsnlight_info(xmlNodePtr cur)
{
	 xmlChar* value;
	 xmlNodePtr entry;	 
	 u32 tvalue = 0;
	 u16 tsnlight_mid = 0;
	 
	 cur=cur->xmlChildrenNode;
	 while(cur != NULL)
	 {	
		 /* （3）找到tsmp_forward_table子节点，并进行配置tsmp转发表 */	
		 if(!xmlStrcmp(cur->name, (const xmlChar *)"tsnlight_mid"))
		 {	
			value=xmlNodeGetContent(cur->children);
		 	sscanf(value,"%x",&tvalue);
			tsnlight_mid = (u16)tvalue;
		 }
		 cur = cur->next;
	 }

	 return tsnlight_mid;
}


int verify_tsnlight_mid_file(xmlDocPtr *doc,char *docname,xmlNodePtr *cur)
{

    /* 进行解析，如果没成功，显示一个错误并停止 */  
    *doc = xmlParseFile(docname); 
    if(*doc == NULL)
	{  
        fprintf(stderr, "init_doc not parse successfully. \n");  
        return -1;  
    }  
  
    /* 获取文档根节点，若无内容则释放文档树并返回 */  
    *cur = xmlDocGetRootElement(*doc);  
    if(*cur == NULL)
	{  
        fprintf(stderr, "empty document\n");  
        xmlFreeDoc(*doc);
		xmlCleanupParser();		
	    //xmlMemoryDump();
        return -1;  
    }  
  
    /* 确定根节点名是否为network_init_cfg，不是则返回 */  
    if(xmlStrcmp((*cur)->name, (const xmlChar *)"network_init_cfg"))
	{  
        fprintf(stderr, "document of the wrong type, root node != network_init_cfg");  
        xmlFreeDoc(*doc); 
		xmlCleanupParser();		
	    //xmlMemoryDump();
        return -1;  
    }  	
	return 0;
}


u16 get_tsnlight_mid_from_xml()
{
	int ret = 0;
	u16 tsnlight_mid = 0;

    /* 定义文档和节点指针 */  
    xmlDocPtr doc;  
    xmlNodePtr cur;  

	xmlKeepBlanksDefault(0);

	//验证基础配置文本格式是否正确
	ret = verify_tsnlight_mid_file(&doc,"./config/tsnlight_init_cfg.xml",&cur);
	if(ret == -1)
	{
		printf("verify_basic_cfg_file error! \n");
		return -1;
	}

    /* 遍历文档树 */  
    cur = cur->xmlChildrenNode;  
    while(cur != NULL)
	{  
       if(!xmlStrcmp(cur->name, (const xmlChar *)"tsnlight"))
		{  
            tsnlight_mid = parse_tsnlight_info(cur); /* 解析node子节点 */ 
			break;
		}		
        cur = cur->next; /* 下一个子节点 */  

    }

	xmlFreeDoc(doc); /* 释放文档树 */
	xmlCleanupParser();		
	//xmlMemoryDump();
	
    return tsnlight_mid;  
	
}



int net_init(u8 *network_inetrface,u16 *tsnlight_mid,u32 version)
{
	int ret = 0;
	u8 local_mac[6] = {0};	
	

	//初始化libnet和libpcap
	char test_rule[64] = {0};
	sprintf(test_rule,"%s","ether[12:2]=0xff01 && ether[14]!=0x06");

	data_pkt_receive_init(test_rule,network_inetrface);//数据接收初始化
	data_pkt_send_init(network_inetrface);//数据发送初始化
	tsninsight_init();//TSNInsight_init通信初始化
	
	*tsnlight_mid = get_tsnlight_mid_from_xml();
	printf("get tsnlight_mid %d\n",*tsnlight_mid);
	set_tsnlight_mac(*tsnlight_mid);

	//获取TSNLight的Mac地址,TSNLight_mid是解析tsnlight_init_cfg.xml中获取的
	get_tsnlight_mac_from_mid(local_mac,*tsnlight_mid);
	fwrite_file(local_mac,version,"TSNLight");
	
	//向TSNInsight发送hello报文
	tsninsight_send_hello_pkt(*tsnlight_mid,TSNLIGHT);

	//初始化完成，跳转到基础配置状态
	printf("*************enter BASIC_CFG_S********************\n");
	
	return 0;

}


int resource_clear(u8 *network_inetrface)
{
	data_pkt_send_destroy();
	data_pkt_receive_destroy();

	return 0;
}


