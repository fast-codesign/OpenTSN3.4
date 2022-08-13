/** *************************************************************************
 *  @file       main.c
 *  @brief	    TSNLight主函数
 *  @date		2021/11/26 
 *  @author		junshuai.li
 *  @version	3.3.0 
 修改人：李军帅
version3.3.1  0x2021113001
1、屏蔽读取HCP外围逻辑版本的功能
****************************************************************************
version3.3.0  0x2021112601
1、修改各个状态机的功能，
	网络初始化只进行网络接口初始化
	基础配置解析基础配置的xml文本，并进行配置，文本中时间同步参数和LID转发表
	规划配置解析规划配置的xml文本，并进行配置，文本中只有lid、addr、data
	时间同步只修改了发送报文和接收报文的接口
	状态监测未修改	
2、修改发送报文和接收报文的接口，增加write和read的功能，取消主动上报的功能
3、在主函数中不再统一接收报文，在各个需要接收报文的模块独立接收  
 ****************************************************************************/

#include "complib/include/comp_api.h"
#include "basic_cfg/basic_cfg.h"
#include "local_cfg/local_cfg.h"
#include "net_init/net_init.h"




int net_run(u8 *pkt,u16 pkt_length)
{

	return 0;
}


int net_run_handle(u8 cur_node_num)
{

	u16 pkt_len  = 1;//报文长度
	u8 *pkt 	 = NULL;//报文的指针
	int ret = 0;

	while(1)
	{
		
		//每次获取一个报文
		pkt = data_pkt_receive_dispatch_1(&pkt_len);

		if(pkt == NULL)
			continue;
		else if(pkt[12] == 0xff && pkt[13] == 0x01)//判断是否为TSMP报文，以太网类型为0xff01
		{
			net_run(pkt,pkt_len);//对配置报文进行处理			
		}
		else
			tsninsight_pkt_process(pkt,pkt_len);
		
	}

	return 0;
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
	int ret = 0;
	u8 tsnlight_state = 0;
	
	u16 tsnlight_mid = 0;
	//初始化进程
	char test_rule[64] = {0};
	char temp_net_interface[16]={0};

	u8 cur_node_num = 0;
	u32 sw_version = 0x20220408;


	if(argc != 2)
	{
		printf("input format:./tsnlight net_interface\n");
		return 0;
	}

	//libpcap initialization
	sprintf(temp_net_interface,"%s",argv[1]);


	create_debug_file();

	//进入网络初始化状态
    ret = net_init(temp_net_interface,&tsnlight_mid,sw_version);
	if(ret == -1)
	{
		printf("net_init fail\n");
		return 0;
	}

	
	//进入基础配置状态，在基础配置中对时间同步的参数赋值
	ret = basic_cfg(&tsnlight_state,sw_version,tsnlight_mid);
	if(ret == -1)
	{
		printf("basic_cfg fail\n");
		return 0;
	}
	else
	{
		cur_node_num = ret;
	}



	//进入本地规划配置状态
	ret = local_cfg(&tsnlight_state);
	if(ret == -1)
	{
		printf("local_cfg fail\n");
		return 0;
	}	

	//进入网络运行状态
	net_run_handle(cur_node_num);

	resource_clear(temp_net_interface);

	return 0;
}




