/** *************************************************************************
 *  @file       basic_cfg.c
 *  @brief	    基础配置函数
 *  @date		2021/11/26 
 *  @author		junshuai.li
 *  @version	3.3.0
 ****************************************************************************/
#include "basic_cfg.h"

//用于判断是否为第一次version.txt
u8 flag_file_open_num = 0;

//存储节点版本信息
node_version node_version_data[MAX_NODE_NUM]={0};
//存储节点版本信息数目
u8 total_node_version_num = 0;


void fwrite_file(u8 *const locla_mac,u64 hw_version,u8 *const name)
{
	FILE *fp = NULL;

	u8 buf[100] = {0};
	if(flag_file_open_num == 0)
	{
		fp = fopen("./version.txt", "w");
		flag_file_open_num++;
	}		
	else
		fp = fopen("./version.txt", "a+");
	sprintf(buf, "%s\n", "*************************");
	fwrite(buf, sizeof(char), strlen(buf), fp);

	fwrite(name, sizeof(char), strlen(name), fp);
	sprintf(buf, "%s\n", ": ");
	fwrite(buf, sizeof(char), strlen(buf), fp);
	
	sprintf(buf, "locla_mac = %02x:%02x:%02x:%02x:%02x:%02x\n", locla_mac[0],locla_mac[1],locla_mac[2],locla_mac[3],locla_mac[4],locla_mac[5]);
	fwrite(buf, sizeof(char), strlen(buf), fp);
	
	
	sprintf(buf, "version = 0x%llx\n", hw_version);
	fwrite(buf, sizeof(char), strlen(buf), fp);
	fclose(fp);

	return;
}



u32 get_hw_version(u8 *local_mac,u8 *pkt,u8 type)
{
	int ret = 0;
	u32 *read_data = NULL;
    u32 version = 0;
	u32 addr=0;
	u8 name[8] = {0};

	if(type == 1)
	{
		addr = htonl(HCP_VER_REG);
		strcpy(name,"HCP");
	}
	else if(type == 2)
	{
		addr = htonl(TSS_VER_REG);
		strcpy(name,"TSS");
	}
	
	//读请求
	tsmp_get_req(local_mac,1,addr,pkt);
	read_data = tsmp_get_res(local_mac,1,addr);//读响应
	
	version = ntohl(*read_data);
	
	fwrite_file(local_mac,version,name);

	//清空pkt
	bzero(pkt,2048);

	return version;
	
}



//解析转发表中的每个标签
void parse_tsmp_fwd_entry(xmlNodePtr cur,u32 *data,u16 *dmid)
{
	xmlNodePtr entry = NULL;
	xmlChar* value;
	u32 tvalue32 = 0;
	u64 tvalue64 = 0;
	char* endptr=NULL;

	//printf("parse_mac_fwd_entry start! \n");

	if(cur == NULL)
	{
		printf("parse_mac_fwd_entry,cur = NULL! \n");
		return ;
	}

	if(data == NULL)
	{
		printf("parse_mac_fwd_entry,data = NULL! \n");
		return ;
	}
	
	//获取TSMP转发表信息
	for(entry=cur->children;entry!= NULL;entry=entry->next)
	{  
    	if(xmlStrcasecmp(entry->name,(const xmlChar *)"dmid")==0)
		{
			value=xmlNodeGetContent(entry);
			sscanf(value,"%x",&tvalue32);

			*dmid = (u16)tvalue32;
			printf("dmid 0x%x \n",*dmid);
			

		}
    	else if(xmlStrcasecmp(entry->name,(const xmlChar *)"outport")==0)
		{
			value=xmlNodeGetContent(entry);			
			tvalue64 = strtoull(value,&endptr,16);//十六进制转换

			tvalue32 = (u32)(tvalue64>>32);
			tvalue32 = 0x80000000 + tvalue32;
			data[0] = htonl(tvalue32);

			tvalue32 = (u32)(tvalue64&0xffffffff);
			data[1] = htonl(tvalue32);
			
		}


	}
	
	return ;

}


 void tsmp_fwd_init(u8 *local_mac,u8 *pkt)
 {
	int i = 0;
	u16 data_num = 0;
	
	u32 addr = 0;//配置的地址	
	u32 *data = NULL;

	//清空pkt
	bzero(pkt,2048);
	
	//data内容直接放到pkt中，省去再次赋值
	data = (u32 *)(pkt + sizeof(tsmp_header) + sizeof(tsmp_set_req_or_get_res_pkt_data));//配置的数据
	 
	 //TSMP转发表初始化，TSMP转发表总共4096条表项，每条表项2个寄存器，因此每次配置128条表项，总共配置32次
	 for(i = 0; i< 32 ;i++)
	 { 
		 addr = MID_TABLE + 2*128*i;
		 data_num = 2*128; 
		 tsmp_set_req(local_mac,data_num,htonl(addr),pkt);//写请求
	 }


	  //配置TSMP转发表使能为1
	  data[0] = htonl(0x4);
	  tsmp_set_req(local_mac,1,htonl(HCP_CFG_REG),pkt);//写请求

	  bzero(pkt,2048);

	 return ;
 }


 //循环解析转发表
 int basic_cfg_and_parse_tsmp_fwd(xmlNodePtr cur,u8 *local_mac,u8 *pkt)
{
	int ret = 0; 
	xmlNodePtr entry;
	
	u16 data_num = 0;
	u16 mid = 0;
	
	u32 addr = 0;//配置的地址	
	u32 *data = NULL;


	if(cur == NULL)
	{
		printf("basic_cfg_and_parse_mac_fwd,cur = NULL! \n");
		return -1;
	}

	if(local_mac[0] == 0)
	{
		printf("basic_cfg_and_parse_mac_fwd,local_mac[0] = 0! \n");
		return -1;
	}


	if(pkt == NULL)
	{
		printf("basic_cfg_and_parse_mac_fwd,pkt = NULL! \n");
		return -1;
	}

	
	//data内容直接放到pkt中，省去再次赋值
	data = (u32 *)(pkt + sizeof(tsmp_header) + sizeof(tsmp_set_req_or_get_res_pkt_data));//配置的数据

	//循环解析mac_forward_table中的entry
	for(entry=cur->children;entry!= NULL;entry=entry->next)
	{  
    	if(xmlStrcasecmp(entry->name,(const xmlChar *)"entry")==0)
		{
			//每条表项包含两个data
			parse_tsmp_fwd_entry(entry,data,&mid);

			addr = MID_TABLE + 2*mid;
		    data_num = 2; 
	
		    tsmp_set_req(local_mac,data_num,htonl(addr),pkt);//写请求

		    //配置验证
		    ret = cfg_varify(local_mac,data_num,htonl(addr),pkt);

		    //配置验证失败，程序退出
			if(ret == -1)
			{
				printf("varify parse_tsmp_fwd_entry error!addr=%x,dmid=%x \n",addr,mid);
				return -1;
			}

    	}

		
	}
	return 0;

}




/* 解析switch */  
static int basic_cfg_and_parse_node(xmlNodePtr cur,u8 *pkt,u16 tsnlight_mid)
{  

/* 基础配置的基本顺序：
   配置HCP地址->配置硬件状态寄存器->配置和验证转发表->获取硬件版本号->配置和校验控制器的MAC地址
   ->验证HCP的MAC地址
  这么做的原因：只有配置转发表之后，配置报文才能到达控制器，才能进行HCP地址和控制器MAC地址的配置校验。
  另外，硬件状态寄存器的配置是否生效，可以通过判断设备状态灯来确认，所以未再进行配置校验。 
*/

	int ret = 0;
	u8 local_mac[6] = {0};
	u16 hcp_mid = 0;

	xmlChar* value;
	xmlNodePtr entry;
	u32 tvalue = 0;

	//定义一个变量存储配置内容
	u32* tmp_data = NULL;


	if(cur == NULL)
	{
		printf("basic_cfg_and_parse_node,cur = NULL! \n");
		return -1;
	}
	
	tmp_data = (u32 *)(pkt + sizeof(tsmp_header) + sizeof(tsmp_set_req_or_get_res_pkt_data));//配置的数据
	
	cur=cur->xmlChildrenNode;
	while(cur != NULL)
	{        
		if(!xmlStrcmp(cur->name, (const xmlChar *)"tsmp_forward_table"))
		{  
			 //（2）TSMP转发表初始化及TSMP转发表使能为1
			tsmp_fwd_init(local_mac,pkt);

			 /* （3）找到tsmp_forward_table子节点，并进行配置tsmp转发表 */ 
			ret = basic_cfg_and_parse_tsmp_fwd(cur,local_mac,pkt);
			if(ret == -1)
			{
				return -1;
			}

			//（4）校验HCP配置状态寄存器
			//tmp_data[0] = htonl(0x4);	
			//ret = cfg_varify(local_mac,1,htonl(HCP_CFG_REG),pkt);
			//if(ret == -1)
			//{
			//	printf("varify HCP and tsnlight MID error!\n");
			//	return -1;
			//}
        }
		else if(!xmlStrcmp(cur->name, (const xmlChar *)"hcp_mid"))
		{  
			value=xmlNodeGetContent(cur->children);
			sscanf(value,"%x",&tvalue);

			hcp_mid = (u16)tvalue;

			get_hcp_mac_from_mid(local_mac,hcp_mid);

			//（1）发送mid分配帧，分配节点hcp和TSNLightd的mid，未校验
			tsmp_cfg_hcp_tsnlight_mid(local_mac,hcp_mid,tsnlight_mid,pkt);
		#if 0

			//（2）配置TSNLight的mid地址		
			tmp_data = (u32 *)(pkt + sizeof(tsmp_header) + sizeof(tsmp_set_req_or_get_res_pkt_data));//配置的数据
			tmp_data[0] = htonl((u32)tsnlight_mid);
			tsmp_set_req(local_mac,1,htonl(TSNLIGHT_MID_REG),pkt);//写请求


			
			//（2）复位硬件状态寄存器
			cfg_hw_state(local_mac,INIT,pkt);
		#endif

		}
		
		cur = cur->next; /* 下一个子节点 */  
	}
	

	//（5）校验HCP和tsnlight的MID
	tmp_data[0] = (tsnlight_mid<<12)|hcp_mid;
	printf("tmp_data[0] = %x \n",tmp_data[0]);
	tmp_data[0] = htonl(tmp_data[0]);

	
	ret = cfg_varify(local_mac,1,htonl(HCP_MID_REG),pkt);
	if(ret == -1)
	{
		printf("varify HCP and tsnlight MID error!\n");
		return -1;
	}



	/*（6）获取版本号*/
	tvalue = 0;		
	tvalue = get_hw_version(local_mac,pkt,1);//HCP版本号
	get_hw_version(local_mac,pkt,2);//TSS版本号

	node_version_data[total_node_version_num].mid = htons(hcp_mid);
	node_version_data[total_node_version_num].version = htonl(tvalue);
	total_node_version_num++;
			
    return 0; 
	
}

int verify_basic_cfg_file(xmlDocPtr *doc,char *docname,xmlNodePtr *cur)
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


int basic_cfg_and_parse_file(u8 *init_cfg_file_name,u8 *pkt,u16 tsnlight_mid)
{
	int ret = 0;

    /* 定义文档和节点指针 */  
    xmlDocPtr doc;  
    xmlNodePtr cur;  
	u8 cur_node_num = 0;

	xmlKeepBlanksDefault(0);

	//验证基础配置文本格式是否正确
	ret = verify_basic_cfg_file(&doc,init_cfg_file_name,&cur);
	if(ret == -1)
	{
		printf("verify_basic_cfg_file error! \n");
		return -1;
	}

    /* 遍历文档树 */  
    cur = cur->xmlChildrenNode;  
    while(cur != NULL)
	{  
		printf("start\n");
        /* 找到node子节点 */  
        if(!xmlStrcmp(cur->name, (const xmlChar *)"node"))
		{  
            ret = basic_cfg_and_parse_node(cur,pkt,tsnlight_mid); /* 解析node子节点 */ 
			if(ret == -1)
			{
				xmlFreeDoc(doc); /* 释放文档树 */
				xmlCleanupParser();		
				//xmlMemoryDump();
				return -1;
			}
			cur_node_num++;
			
		}
		
		printf("end %d\n",cur_node_num);
        cur = cur->next; /* 下一个子节点 */  

    }

	xmlFreeDoc(doc); /* 释放文档树 */
	xmlCleanupParser();		
	//xmlMemoryDump();
	
    return cur_node_num;  
	
}


//基础配置的入口函数
int basic_cfg(u8* state,u32 sw_ver,u16 tsnlight_mid)
{
		
	int ret = 0;
	
	//申请空间，用于构造配置报文
	u8 *pkt = NULL;
	u8 *init_cfg_file_name = NULL;
	u8 tsninsight_netstate = 0;
	
	node_version_data[0].mid = htons(tsnlight_mid);
	node_version_data[0].version = htonl(sw_ver);
	total_node_version_num++;
	
	pkt = (u8 *)malloc(MAX_PKT_LEN);
	if(NULL == pkt)
	{
		printf("basic_cfg,malloc buf fail\n");
		return -1;
	}
	
	bzero(pkt,MAX_PKT_LEN);
	
	init_cfg_file_name = INIT_XML_FILE;//初始配置文本

	//解析初始配置xml文本,解析一个表项，配置一个表项
	ret = basic_cfg_and_parse_file(init_cfg_file_name,pkt,tsnlight_mid);
	if(ret == -1)
	{
		printf("parse_init_cfg_xml fail\n");
		return -1;
	}

	//释放基础配置申请的空间
	free(pkt);
	
	//基础配置状态完成
	*state = BASIC_CFG_FINISH_STATE;
	 //发送网络状态trap报文函数
 	tsninsight_send_netstate_or_syncstate_trap_pkt(NETWORK_STATE,BASE_CFG_FINISH);
	tsninsight_send_version_trap_pkt(total_node_version_num,node_version_data);
	printf("*************enter LOCAL_PLAN_CFG_S********************\n");
	write_debug_msg("*************enter LOCAL_PLAN_CFG_S********************\n");

	return ret;
		
}
		
