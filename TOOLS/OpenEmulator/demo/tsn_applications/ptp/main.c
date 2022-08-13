/** *************************************************************************
 *  @file       main.c
 *  @brief	    802.1AS P2P同步主函数
 *  @date		2022/02/28 
 *  @author		junshuai.li
 *  @version	0.0.1 
编写人：李军帅
version0.0.1
1、初始版本，			  
****************************************************************************/
#include "8021AS_PTP.h"
#include "./tsninsight/tsninsight.h"
#include "ptp_tsninsight.h"


void p2p_exit()
{
	printf("receive stop signal\n");
}

void create_debug_file()
{
	FILE *fp;
	char str[] = "****** debug message ******\n";
	fp = fopen("debug_error.txt","w");
	fwrite(str,sizeof(char),strlen(str),fp);
	fclose(fp);
	return;
}


int main(int argc,char* argv[])
{
    setbuf(stdout,NULL);
	int i =5;
	int ret = 0;
	char temp_net_interface[16]={0};
    struct  timeval tv_current;//记录当前的时间
	u64 cur_time_count_ns = 0;//单位为ns
	
	libnet_t *send_t;
	pcap_t *receive_t;	
	
	ptp_sync_context ptp_sync;//ptp同步的全局数据结构,并进行初始化
	ptp_sync.dev_info = NULL;
	ptp_sync.gm = NULL;
	ptp_sync.bc = NULL;
	ptp_sync.slave = NULL;
	ptp_sync.sta = NULL;


	u8 *pkt = NULL;//用于指针接收报文
	u16 pkt_len = 0;//

	if(argc != 2)
	{
		printf("input format:./p2p net_interface\n");
		return 0;
	}
	sprintf(temp_net_interface,"%s",argv[1]);

	create_debug_file();

	sync_init(temp_net_interface,&send_t,&receive_t,&ptp_sync);//同步初始化
	tsninsight_init(PTP_PORT);//TSNInsight_init通信初始化

#if 0
	//向TSNInsight发送hello报文
	tsninsight_send_hello_pkt(ptp_sync.dev_info->mid,ptp_sync.dev_info->dev_type);

	//循环接收报文,如果接收TSNInsight的启动信号，跳出循环
	while(1)
	{
		pkt = os_pkt_receive((u16 *)&pkt_len,receive_t);//非阻塞接收报文 
		if(pkt == NULL)
			continue;
		else
		{
			//printf("get pkt\n");
			tsninsight_pkt_process(pkt,pkt_len);//对同步报文进行处理
			if(G_NET_STATE == START_SYNC)
				break;
		}
	}
#endif

	ptp_init_cfg(&ptp_sync,send_t);

	printf("***********init finish,start timer and receive pkt*******\n");
	while(1)
	{
	
		//向gm节点的下一级发送sync报文
		//send_next_class_sync_pkt(ptp_sync.dev_info->mid,ptp_sync.gm->mid,ptp_sync.gm->next_class_link,send_t);
		//sleep(1);
#if 1
		//PTP集中控制器、gm、周期上报需要定时服务
		//if(ptp_sync.dev_info->dev_type == PTP_CTL || ptp_sync.dev_info->dev_type == PTP_GM)
		//{
		cur_time_count_ns = get_cur_nano_sec();//获取当前系统时间
		//printf("cur_time_count_ns %lld\n",cur_time_count_ns);
		if(cur_time_count_ns != 0)
		{
			ret = timer_func(cur_time_count_ns,&ptp_sync,send_t);//超时处理函数
			if(ret == -1)
				return 0;
		}
		//}
#endif
		pkt = os_pkt_receive((u16 *)&pkt_len,receive_t);//非阻塞接收报文

		if(pkt == NULL)
			continue;
		else if(pkt[12] == 0xff && pkt[13] == 0x01)//判断是否为TSMP报文，以太网类型为0xff01
		{
			sync_pkt_process(pkt,pkt_len,&ptp_sync,send_t);//对同步报文进行处理			
		}
		else
			tsninsight_pkt_process(pkt,pkt_len);

		//signal(SIGINT,p2p_exit);//如果接收到ctrl c信号，执行p2p_exit函数
	}

	return 0;
}










