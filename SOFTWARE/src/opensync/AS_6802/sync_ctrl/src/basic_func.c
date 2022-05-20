#include"../include/basic_fun.h"
#define MAX_DEVICE_NUM 20

extern global_param_set gp_param;
extern sm_param_set sm_param;
extern cm_param_set cm_param;

void tte_sync_init(tte_sync_context* context_table[], timer_list_node* timer_list[], u8* cfg_filename, int device_num)
{
    for (int i = 0; i < device_num; i++)
    {
        context_table[i] = (tte_sync_context*)malloc(sizeof(tte_sync_context));
        timer_list[i] = (timer_list_node*)malloc(sizeof(timer_list_node));
    }

    u8 ctrl_mac[6];
    u8 multicast[6];

    /* 定义文档和节点指针 */
    xmlDocPtr doc;
    xmlNodePtr cur;

    /* 进行解析，如果没成功，显示一个错误并停止 */
    doc = xmlParseFile(cfg_filename);
    if (doc == NULL)
    {
        fprintf(stderr, "Document not parse successfully. \n");
        return;
    }

    /* 获取文档根节点，若无内容则释放文档树并返回 */
    cur = xmlDocGetRootElement(doc);
    if (cur == NULL)
    {
        fprintf(stderr, "empty document\n");
        xmlFreeDoc(doc);
        return;
    }

    /* 确定根节点名是否正确，不是则返回 */
    if (xmlStrcmp(cur->name, (const xmlChar *)"init_cfg"))
    {
        fprintf(stderr, "document of the wrong type, root node != init cfg");
        xmlFreeDoc(doc);
        return;
    }
    /* 遍历文档树 */
    cur = cur->xmlChildrenNode;
    while (cur != NULL)
    {
        if (!xmlStrcmp(cur->name, (const xmlChar *)"sync_ctrl"))
        {
            xmlNodePtr temp = cur->xmlChildrenNode;
            u16 mid1,mid2;
            while (temp != NULL)
            {
                if (!xmlStrcmp(temp->name, (const xmlChar *)"mid"))
                {
                    mid1 = atoi(xmlNodeGetContent(temp));
                }
                if (!xmlStrcmp(temp->name, (const xmlChar *)"multi_mac"))
                {
                    mid2 = atoi(xmlNodeGetContent(temp));
                }
                temp = temp->next;
            }
            printf("ctrl mid %d\n",mid1);   
            printf("multi mid %d\n",mid2);
            get_opensync_mac_from_mid(ctrl_mac,mid1);
            get_hcp_mac_from_mid(multicast,mid2);
            print_mac(ctrl_mac);
            print_mac(multicast);
        }
        if (!xmlStrcmp(cur->name, (const xmlChar *)"device"))
        {
            init_node_info(cur, context_table, timer_list,ctrl_mac,multicast);
        }
        cur = cur->next;
    }
    xmlFreeDoc(doc); /* 释放文档树 */
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


void pkt_print(u8* pkt, int len)
{
    int i = 0;

    printf("-----------------------***PACKET***-----------------------\n");
    printf("Packet Addr:%p\n", pkt);
    for (i = 0;i < 16;i++)
    {
        if (i % 16 == 0)
            printf("      ");
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

void cm_debug(u8* content)
{
    printf("CM[0] DEBUG INFO : %s", content);
}

int maccmp(unsigned char* mac1, unsigned char* mac2)
{
    for (int i = 0; i < 6; i++)
    {
        if (mac1[i] != mac2[i])
        {
            return -1;
        }
    }
    return 0;
}

void print_mac(u8* mac)
{
    printf("%02x:%02x:%02x:%02x:%02x:%02x\n",mac[0],mac[1],mac[2],mac[3],mac[4],mac[5]);
}

void sm_debug(const u8* content, u32 sm_id)
{
    printf("SM[%d] DEBUG INFO : %s", sm_id, content);
}

u64 time_trans_s2h(u64 time)
{
    u64 time_nano = time%1000000000;
    u64 time_s = time/1000000000;
    return (time_s << 32)|time_nano;
}

u64 time_trans_h2s(u64 time)
{
    u64 re = (time >> 32) * 1000000000 + (time & 0xffffffff);
    return re;
}

void pkt_info_print(struct pkt_info* pinfo)
{
    printf("Integration Cycle = %d\n", pinfo->integration_cycle);
    printf("Membership New    = %d\n", pinfo->membership_new);
    printf("Pcf Type          = %d\n", pinfo->pcf_type);
    printf("Transparent Clock = %ld\n", pinfo->transparent_clock);
    printf("Permanence PIT    = %ld\n", pinfo->permanance_pit);
    printf("Receive PIT       = %ld\n", pinfo->receive_pit);
}

void my_sleep(u64 nanotimer_length)
{
	u64 start_time = get_cur_nano_sec();
	u64 cur_time;
	while(1)
	{
		cur_time = get_cur_nano_sec();
		if(cur_time - start_time >= nanotimer_length)
        {
            return;
        }
			
		else
        {
			continue;
        }
	}
}

unsigned char atoc(unsigned char in_c)
{
    unsigned char out_c;
    if (in_c >= 'a')
        out_c = in_c - 'a' + 10;
    else if (in_c >= 'A')
        out_c = in_c - 'A' + 10;
    else
        out_c = in_c - '0';
    return out_c;
}

int str2mac(unsigned char *mac_str, unsigned char *mac)
{
    for (int i = 0; i < 6; i++)
    {
        *(mac + i) = atoc(mac_str[i * 3]) * 16;
        *(mac + i) += atoc(mac_str[i * 3 + 1]);
    }
    return 0;
}

void init_cfg(char *docname, int *devicenum, unsigned char **net_interface)
{
    /* 定义文档和节点指针 */
    xmlDocPtr doc;
    xmlNodePtr cur;

    /* 进行解析，如果没成功，显示一个错误并停止 */
    doc = xmlParseFile(docname);
    if (doc == NULL)
    {
        fprintf(stderr, "Document not parse successfully. \n");
        return;
    }

    /* 获取文档根节点，若无内容则释放文档树并返回 */
    cur = xmlDocGetRootElement(doc);
    if (cur == NULL)
    {
        fprintf(stderr, "empty document\n");
        xmlFreeDoc(doc);
        return;
    }

    /* 确定根节点名是否正确，不是则返回 */
    if (xmlStrcmp(cur->name, (const xmlChar *)"init_cfg"))
    {
        fprintf(stderr, "document of the wrong type, root node != init cfg");
        xmlFreeDoc(doc);
        return;
    }

    /* 遍历文档树 */
    cur = cur->xmlChildrenNode;
    while (cur != NULL)
    {
        /* 找到 device 子节点 */
        if (!xmlStrcmp(cur->name, (const xmlChar *)"device_num"))
        {
            xmlChar *temp;
            temp = xmlNodeGetContent(cur);
            *devicenum = atoi(temp);
        }
        if (!xmlStrcmp(cur->name, (const xmlChar *)"net_interface"))
        {
            xmlChar *temp;
            temp = xmlNodeGetContent(cur);
            *net_interface = temp;
        }
        cur = cur->next;
    }
    xmlFreeDoc(doc); /* 释放文档树 */
    return;
}

void init_node_info(xmlNodePtr cur, tte_sync_context* context_table[], timer_list_node* timer_list[],u8* ctrl_mac, u8* multimac)
{
    int index;
    int static_delay;
    int clock_role;
    u8 cm_mac[6];
    u8 mac[6];
    u16 mid;

    xmlNodePtr temp = cur->xmlChildrenNode;

    while (temp!=NULL)
    {
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"id")))
        {
            index = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"clock_role")))
        {
            clock_role = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"mid")))
        {
            // u8* str1 = xmlNodeGetContent(temp);
            mid = atoi(xmlNodeGetContent(temp));
            get_hcp_mac_from_mid(mac, mid);
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"static_delay")))
        {
            static_delay = atoi(xmlNodeGetContent(temp));
        }
        temp = temp->next;
    }
    
    
    printf("index %d \n",index);  
    printf("clock role %d \n",clock_role);
    print_mac(mac);

    if (clock_role == ROLE_CM)
    {
        context_table[index]->device_id = index;

        context_table[index]->dev_info = (device_info*)malloc(sizeof(device_info));
        context_table[index]->dev_info->sync_clock_role = ROLE_CM;
        for (int i = 0; i < 6; i++)
        {
            context_table[index]->dev_info->dmac[i] = mac[i];
            cm_mac[i] = mac[i];
            context_table[index]->dev_info->smac[i] = ctrl_mac[i];
            context_table[index]->dev_info->mac[i] = multimac[i];
        }
        context_table[index]->dev_info->mid = mid;

        context_table[index]->cm_info = (cm_sync_info*)malloc(sizeof(cm_sync_info));
        context_table[index]->cm_info->cur_state = CM_INTEGRATE;
        context_table[index]->cm_info->cur_sinfo = (local_sync_info*)malloc(sizeof(local_sync_info));
        memset(context_table[index]->cm_info->cur_sinfo,0,sizeof(local_sync_info));
        context_table[index]->cm_info->static_delay = static_delay;

        context_table[index]->pkt_info_num = 0;
        context_table[index]->last_pcf_pkt = (pkt_info*)malloc(sizeof(pkt_info)*MAX_DEVICE_NUM);
        context_table[index]->sm_info = NULL;
        context_table[index]->statistic_info = NULL;

        timer_list[index]->valid = 1;
        timer_list[index]->device_id = index;
        // timer_list[index]->timer_length = CM_LISTEN_TIMEOUT;
        timer_list[index]->timer_length = cm_param.cm_listen_timeout;
        timer_list[index]->cycle_correction = 0;
        timer_list[index]->timer_start = get_cur_nano_sec();
    }
    else if(clock_role == ROLE_SM)
    {
        context_table[index]->device_id = index;

        context_table[index]->dev_info = (device_info*)malloc(sizeof(device_info));
        context_table[index]->dev_info->sync_clock_role = ROLE_SM;
        for (int i = 0; i < 6; i++)
        {
            context_table[index]->dev_info->dmac[i] = mac[i];
            context_table[index]->dev_info->smac[i] = ctrl_mac[i];
            context_table[index]->dev_info->mac[i] = cm_mac[i];
        }
        context_table[index]->dev_info->mid = mid;
        
        context_table[index]->sm_info = (sm_sync_info*)malloc(sizeof(sm_sync_info));
        context_table[index]->sm_info->cur_state = SM_INTEGRATE;
        context_table[index]->sm_info->cur_sinfo = (local_sync_info*)malloc(sizeof(local_sync_info));
        memset(context_table[index]->sm_info->cur_sinfo,0,sizeof(local_sync_info));
        context_table[index]->sm_info->static_delay = static_delay;
        context_table[index]->sm_info->ca_receive = false;
        context_table[index]->sm_info->stable_cycle_count = 0;


        context_table[index]->pkt_info_num = 0;
        context_table[index]->last_pcf_pkt = (pkt_info*)malloc(sizeof(pkt_info));
        context_table[index]->cm_info = NULL;
        context_table[index]->statistic_info = NULL;

        timer_list[index]->valid = 1;
        timer_list[index]->device_id = index;
        // timer_list[index]->timer_length = SM_LISTEN_TIMEOUT;
        timer_list[index]->timer_length = sm_param.sm_listen_timeout;
        timer_list[index]->cycle_correction = 0;
        timer_list[index]->timer_start = get_cur_nano_sec();
    }
}



void param_cfg(u8* param_filename)
{
    /* 定义文档和节点指针 */
    xmlDocPtr doc;
    xmlNodePtr cur;

    /* 进行解析，如果没成功，显示一个错误并停止 */
    doc = xmlParseFile(param_filename);
    if (doc == NULL)
    {
        fprintf(stderr, "Document not parse successfully. \n");
        return;
    }

    /* 获取文档根节点，若无内容则释放文档树并返回 */
    cur = xmlDocGetRootElement(doc);
    if (cur == NULL)
    {
        fprintf(stderr, "empty document\n");
        xmlFreeDoc(doc);
        return;
    }

    /* 确定根节点名是否正确，不是则返回 */
    if (xmlStrcmp(cur->name, (const xmlChar *)"param_cfg"))
    {
        fprintf(stderr, "document of the wrong type, root node != init cfg");
        xmlFreeDoc(doc);
        return;
    }

    /* 遍历文档树 */
    cur = cur->xmlChildrenNode;
    while (cur != NULL)
    {
        /* 找到 device 子节点 */
        if (!xmlStrcmp(cur->name, (const xmlChar *)"global_param"))
        {
            init_global_param(cur);
        }
        if (!xmlStrcmp(cur->name, (const xmlChar *)"cm_param"))
        {
            init_cm_param(cur);
        }
        if (!xmlStrcmp(cur->name, (const xmlChar *)"sm_param"))
        {
            init_sm_param(cur);
        }
        cur = cur->next;
    }
    xmlFreeDoc(doc); /* 释放文档树 */
    return;
}

void init_global_param(xmlNodePtr cur)
{
    xmlNodePtr temp = cur->xmlChildrenNode;

    while (temp!=NULL)
    {
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"integration_cycle_duration")))
        {
            gp_param.integrate_cycle_duration =  atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"max_transmission_delay")))
        {
            gp_param.max_transmission_delay =  atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"max_integration_cycle")))
        {
            gp_param.max_integration_cycle =  atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"accuracy")))
        {
            gp_param.accuarcy =  atoi(xmlNodeGetContent(temp));
        }
        temp = temp->next;
    }
}

void init_cm_param(xmlNodePtr cur)
{
    xmlNodePtr temp = cur->xmlChildrenNode;

    while (temp!=NULL)
    {
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"cm_listen_timeout")))
        {
            cm_param.cm_listen_timeout = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"cm_ca_enable_timeout")))
        {
            cm_param.cm_ca_enable_timeout = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"cm_wait_4_in_timeout")))
        {
            cm_param.cm_wait_4_in_timeout = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"cm_restart_timeout")))
        {
            cm_param.cm_restart_timeout = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"cm_dispatch_delay")))
        {
            cm_param.cm_disaptch_delay = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"cm_caculation_overhead")))
        {
            cm_param.cm_caculation_overhead = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"cm_integrate_to_sync_thrld")))
        {
            cm_param.cm_integerate_to_sync_thrld = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"cm_unsync_to_sync_thrld")))
        {
            cm_param.cm_unsync_to_sync_thrld = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"cm_sync_threshold_sync")))
        {
            cm_param.cm_sync_threshold_sync = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"cm_sync_threshold_async")))
        {
            cm_param.cm_sync_threshold_async = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"cm_sync_listen_timeout")))
        {
            cm_param.cm_sync_listen_timeout = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"cm_ca_listen_timeout")))
        {
            cm_param.cm_ca_listen_timeout = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"cm_wait4in_listen_timeout")))
        {
            cm_param.cm_wait4in_listen_timeout = atoi(xmlNodeGetContent(temp));
        }
        temp = temp->next;
    }
}

void init_sm_param(xmlNodePtr cur)
{
    xmlNodePtr temp = cur->xmlChildrenNode;

    while (temp!=NULL)
    {
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"sm_listen_timeout")))
        {
            sm_param.sm_listen_timeout = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"sm_coldstart_timeout")))
        {
            sm_param.sm_coldstart_timeout = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"sm_restart_timeout")))
        {
            sm_param.sm_restart_timeout = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"cs_offset")))
        {
            sm_param.cs_offset = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"ca_offset")))
        {
            sm_param.ca_offset = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"ca_receive_timeout")))
        {
            sm_param.ca_receive_timeout = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"ca_acceptance_window")))
        {
            sm_param.ca_accpetance_window = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"sm_integrate_to_sync_thrld")))
        {
            sm_param.sm_integrate_to_sync_thrld = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"sm_unsync_to_sync_thrld")))
        {
            sm_param.sm_unsync_to_sync_thrld = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"sm_unsync_to_tentative_thrld")))
        {
            sm_param.sm_unsync_to_tentative_thrld = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"sm_tentative_sync_threshold_sync")))
        {
            sm_param.sm_tentative_sync_thrld_sync = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"sm_tentative_to_sync_thrld")))
        {
            sm_param.sm_tentative_to_sync_thrld = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"sm_sync_threshold_sync")))
        {
            sm_param.sm_sync_threshold_sync = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"num_stable_cycles")))
        {
            sm_param.num_stable_cycles = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"num_unstable_cycles")))
        {
            sm_param.num_unstable_cycles = atoi(xmlNodeGetContent(temp));
        }
        if(!(xmlStrcmp(temp->name, (const xmlChar *)"sm_stable_threshold_sync")))
        {
            sm_param.sm_stable_threshold_sync = atoi(xmlNodeGetContent(temp));
        }
        temp = temp->next;
    }
}

void print_param_cfg()
{
    printf("integration_cycle_duration = %ld\n",gp_param.integrate_cycle_duration);
    printf("max_transmission_delay = %ld\n",gp_param.max_transmission_delay);
    printf("max_integration_cycle = %d\n",gp_param.max_integration_cycle);
    printf("accuracy = %d\n",gp_param.accuarcy);

    printf("cm_listen_timeout = %ld\n",cm_param.cm_listen_timeout);
    printf("cm_ca_enable_timeout = %ld\n",cm_param.cm_ca_enable_timeout);
    printf("cm_wait_4_in_timeout = %ld\n",cm_param.cm_wait_4_in_timeout);
    printf("cm_restart_timeout = %ld\n",cm_param.cm_restart_timeout);
    printf("cm_dispatch_delay = %d\n",cm_param.cm_disaptch_delay);
    printf("cm_caculation_overhead = %d\n",cm_param.cm_caculation_overhead);
    printf("cm_integrate_to_sync_thrld = %d\n",cm_param.cm_integerate_to_sync_thrld);
    printf("cm_unsync_to_sync_thrld = %d\n",cm_param.cm_unsync_to_sync_thrld);
    printf("cm_sync_threshold_sync = %d\n",cm_param.cm_sync_threshold_sync);
    printf("cm_sync_threshold_async = %d\n",cm_param.cm_sync_threshold_async);
    printf("cm_sync_listen_timeout = %d\n",cm_param.cm_sync_listen_timeout);
    printf("cm_ca_listen_timeout = %d\n",cm_param.cm_ca_listen_timeout);
    printf("cm_wait4in_listen_timeout = %d\n",cm_param.cm_wait4in_listen_timeout);

    printf("sm_listen_timeout = %ld\n",sm_param.sm_listen_timeout);
    printf("sm_coldstart_timeout = %ld\n",sm_param.sm_coldstart_timeout);
    printf("sm_restart_timeout = %ld\n",sm_param.sm_restart_timeout);
    printf("cs_offset = %ld\n",sm_param.cs_offset);
    printf("ca_offset = %ld\n",sm_param.ca_offset);
    printf("ca_receive_timeout = %d\n",sm_param.ca_receive_timeout);
    printf("ca_acceptance_window = %d\n",sm_param.ca_accpetance_window);
    printf("sm_integrate_to_sync_thrld = %d\n",sm_param.sm_integrate_to_sync_thrld);
    printf("sm_unsync_to_sync_thrld = %d\n",sm_param.sm_unsync_to_sync_thrld);
    printf("sm_unsync_to_tentative_thrld = %d\n",sm_param.sm_unsync_to_tentative_thrld);
    printf("sm_tentative_sync_threshold_sync = %d\n",sm_param.sm_tentative_sync_thrld_sync);
    printf("sm_tentative_to_sync_thrld = %d\n",sm_param.sm_tentative_to_sync_thrld);
    printf("sm_sync_threshold_sync = %d\n",sm_param.sm_sync_threshold_sync);
    printf("num_stable_cycles = %d\n",sm_param.num_stable_cycles);
    printf("num_unstable_cycles = %d\n",sm_param.num_unstable_cycles);
    printf("sm_stable_threshold_sync = %d\n",sm_param.sm_stable_threshold_sync);
}