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
#include "tsnlight_tsninsight.h"



int tsninsight_pkt_process(u8 *pkt,u16 pkt_len)
{
	tsninsight_pkt *tmp_pkt = (tsninsight_pkt *)(pkt+UDP_HEAD_LEN);

	if(tmp_pkt->header.type == TSNINSIGHT_GET_REQ)
	{
		printf("get TSNINSIGHT_GET_REQ pkt\n");
		return 0;
	}
	else if(tmp_pkt->header.type == TSNINSIGHT_SET_REQ)
	{
		return 0;
	}
}




