/** *************************************************************************
 *  @file       TSNInsight.c
 *  @brief	    P2P应用与TSNInsight应用通信的接口
 *  @date		2022/03/29 
 *  @author		junshuai.li
 *  @version	0.0.1 
编写人：李军帅
version0.0.1
1、初始版本			  
****************************************************************************/
#include "ptp_tsninsight.h"
#include "./tsninsight/tsninsight.h"

u8 G_NET_STATE = 0;
u64 report_period = 0xffff;//单位ms，开始赋值为最大值


int client_fd;
struct sockaddr_in ser_addr;



int tsninsight_pkt_process(u8 *pkt,u16 pkt_len)
{
	u16 *tmp_pkt = (u16 *)pkt;
	tsninsight_set_net_state_pkt *net_state_pkt = (tsninsight_set_net_state_pkt *)(pkt + UDP_HEAD_LEN);
	tsninsight_set_offset_report_cycle_pkt *offset_report_cycle_pkt = (tsninsight_set_offset_report_cycle_pkt *)(pkt + UDP_HEAD_LEN);
	//判断目的端口号是否为PTP端口号,如果不是则直接退出
	if(ntohs(tmp_pkt[17]) != SERVER_PORT)
	{
		printf("port %d\n",ntohs(tmp_pkt[17]));
		return -1;
	}
	//判断设置的类型是否为网络状态
	//printf("set_type = %d\n",net_state_pkt->set_type);
	if(net_state_pkt->set_type == NETWORK_STATE)
	{
		printf("get set_type NETWORK_STATE\n");
		//解析状态报文
		if(net_state_pkt->net_state == START_SYNC)
		{
			printf("get TSNInsight set net state:START_SYNC\n");
			G_NET_STATE =  START_SYNC;
		}
		//发送网络状态响应报文
		printf("send net state rsq\n");
		tsninsight_send_set_res_pkt((u8 *)net_state_pkt,NETWORK_STATE);
	}
	else if(offset_report_cycle_pkt->set_type == OFFSET_REPORT_CYCLE)
	{
		//设置上报周期
		report_period = ntohs(offset_report_cycle_pkt->offset_report_cycle);
		printf("report_period = %lldms\n",report_period);
		//发送设置上报周期响应报文
		printf("send set req pkt\n");
		tsninsight_send_set_res_pkt((u8 *)offset_report_cycle_pkt,OFFSET_REPORT_CYCLE);
	}
}

int ptp_report_state_handle(ptp_sync_context *ptp_sync)
{
	u16 node_idx = 0;
	ptp_bc_info  *temp_bc = NULL;
	ptp_slave_info  *temp_salve = NULL;

	//开辟一个最大的报文空间
	tsninsight_sync_offset_trap_pkt *sync_offset_trap_pkt = (tsninsight_sync_offset_trap_pkt *)malloc(1024);
	sync_offset_trap_pkt->header.version = TSNINSIGHT_VERSION;
	sync_offset_trap_pkt->header.type 	 = TSNINSIGHT_TRAP;
	sync_offset_trap_pkt->trap_type 	 = SYNC_OFFSET;

	//遍历bc链表
	temp_bc = ptp_sync->bc;
	while(temp_bc != NULL)
	{
		sync_offset_trap_pkt->data[node_idx].mid 	= htons(temp_bc->mid);	
		sync_offset_trap_pkt->data[node_idx].offset = htonl(temp_bc->offset);
		//printf("temp_bc->offset %lld\n",temp_bc->offset);
		node_idx++;
		temp_bc = temp_bc->next_bc;
	}
	
	//遍历salve链表
	temp_salve = ptp_sync->slave;
	while(temp_salve != NULL)
	{
		sync_offset_trap_pkt->data[node_idx].mid 	= htons(temp_salve->mid);	
		sync_offset_trap_pkt->data[node_idx].offset = htonl(temp_salve->offset);
		//printf("temp_salve->offset %lld\n",temp_salve->offset);
		node_idx++;
		temp_salve = temp_salve->next_slave;
	}

	//对上报节点的数量进行赋值
	sync_offset_trap_pkt->num = node_idx;
	sync_offset_trap_pkt->header.length = htons(sizeof(tsninsight_sync_offset_trap_pkt) + sizeof(node_sync_offset)*node_idx);
	//发送trap报文
	tsninsight_msg_sender((u8 *)sync_offset_trap_pkt,sizeof(tsninsight_sync_offset_trap_pkt) + sizeof(node_sync_offset)*node_idx);
}

//上报超时函数
int report_timeout_fun(u64 cur_time_count_ns,ptp_sync_context *ptp_sync)
{
	//如果是第一次超时，不进行上报
	if(g_timer_array[REPORT_TIMEOUT_IDX] == 0)
	{
		g_timer_array[REPORT_TIMEOUT_IDX] = cur_time_count_ns;
		return 0;
	}
	//printf("report_timeout\n");
	g_timer_array[REPORT_TIMEOUT_IDX] = cur_time_count_ns;
	//判断所有节点是否同步
	if(G_NET_STATE == FININSH_SYNC)
	{
		//发送同步上报报文
		printf("send report pkt\n");
		ptp_report_state_handle(ptp_sync);

	}

	
	return 0;
}



