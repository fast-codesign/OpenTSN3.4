#ifndef _PTP_TSNINSIGHT_H__
#define _PTP_TSNINSIGHT_H__


#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <string.h>/*memcpy*/
#include <strings.h>/*bzero*/

#include <unistd.h>
#include <errno.h>

#include <arpa/inet.h>/*htons,ntohs*/

#include <endian.h>/*htobeXX,beXXtoh,htoleXX,leXXtoh*/
#include <sys/types.h>
#include <sys/socket.h>
//#include <linux/in.h>/*struct sockaddr_in*/
#include <linux/if_ether.h>/*struct ethhdr*/
#include <linux/ip.h>/*struct iphdr*/
#include <sys/ioctl.h>
#include <net/if.h>
#include <netpacket/packet.h>

#include "./opensync/include/opensync.h"  

#ifndef SIM
	#include <libnet.h>
	#include <pcap.h>
#endif
/*
#include <libxml/xmlmemory.h>  
#include <libxml/parser.h>  
*/
#include <libxml/xmlmemory.h>  
#include <libxml/parser.h>  

#include "8021AS_PTP.h"


#define PTP_PORT 	9090
//#define PTP_MID 	2049


extern u8 G_NET_STATE;
extern u64 report_period;//单位ms，开始赋值为最大值



int tsninsight_pkt_process(u8 *pkt,u16 pkt_len);
int ptp_report_state_handle(ptp_sync_context *ptp_sync);
int report_timeout_fun(u64 cur_time_count_ns,ptp_sync_context *ptp_sync);


#endif


