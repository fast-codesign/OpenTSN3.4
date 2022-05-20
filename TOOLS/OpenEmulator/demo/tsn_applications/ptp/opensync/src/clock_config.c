#include "../include/opensync.h"
u8 CTRL_MAC[6] = {0x11,0x22,0x33,0x44,0x55,0x65};


int os_cfg_local_clock_cycle (u8* dmac, os_time_value cycle_duration, libnet_t* libnet_handle)
{
	tsmp_cfg_pkt* pkt = (tsmp_cfg_pkt*)malloc(sizeof(tsmp_cfg_pkt));
	memset(pkt, 0, sizeof(tsmp_cfg_pkt));
	os_tsmp_header_generate(&(pkt->ts_header), dmac, CTRL_MAC, TSMP_ETH_TYPE, 0x2, 0x2);
	pkt->reg_num = htons(2);
	pkt->base_addr = htonl(0x80080004);
	pkt->reg2 = htonl(0xffffffff & cycle_duration);
	pkt->reg1 = htonl(0xffffffff & (cycle_duration >> 32));

	os_pkt_send((u8*)pkt, 128, libnet_handle);
}

int os_cfg_local_clock(u8* dmac,u8 *dev_mac, os_time_value clock_value, os_time_value reference_pit, libnet_t* libnet_handle)
{
	tsmp_cfg_pkt* pkt = (tsmp_cfg_pkt*)malloc(sizeof(tsmp_cfg_pkt));
	memset(pkt, 0, sizeof(tsmp_cfg_pkt));
	os_tsmp_header_generate(&(pkt->ts_header), dmac, dev_mac, TSMP_ETH_TYPE, 0x2, 0x2);

	pkt->reg_num = htons(3);
	pkt->base_addr = htonl(OS_CSET0_REG);//修改地址
	pkt->reg2 = htonl(0xffffffff & clock_value);
	pkt->reg1 = htonl(0xffffffff & (clock_value >> 32));
	pkt->reg3 = htonl(0xffffffff & reference_pit);
	pkt->reg4 = htonl(0);

	os_pkt_send((u8*)pkt, 128, libnet_handle);
	free((u8 *)pkt);
}


int os_cfg_freq_corr_cycleduration(u8* dmac, u32 frequency_corr, u32 frequency_corr_cycle, libnet_t* libnet_handle)
{
	tsmp_cfg_pkt* pkt = (tsmp_cfg_pkt*)malloc(sizeof(tsmp_cfg_pkt));
	memset(pkt, 0, sizeof(tsmp_cfg_pkt));
	os_tsmp_header_generate(&(pkt->ts_header), dmac, CTRL_MAC, TSMP_ETH_TYPE, 0x2, 0x2);

	pkt->reg_num = htons(2);
	pkt->base_addr = htonl(0x80080009);
	pkt->reg2 = htonl(frequency_corr_cycle);
	pkt->reg1 = htonl(0xfffffff & frequency_corr);

	os_pkt_send((u8*)pkt, 128, libnet_handle);

}

int os_cfg_phase_offset(u8* dmac, u32 flag ,os_time_value offset, libnet_t* libnet_handle)
{
	tsmp_cfg_pkt* pkt = (tsmp_cfg_pkt*)malloc(sizeof(tsmp_cfg_pkt));
	memset(pkt, 0, sizeof(tsmp_cfg_pkt));
	os_tsmp_header_generate(&(pkt->ts_header), dmac, CTRL_MAC, TSMP_ETH_TYPE, 0x2, 0x2);
	pkt->reg_num = htons(3);
	pkt->base_addr = htonl(0x80080006);
	pkt->reg1 = htonl(flag);
	pkt->reg3 = htonl(0xffffffff & offset);
	pkt->reg2 = htonl(0xffffffff & (offset >> 32));

	os_pkt_send((u8*)pkt, 128, libnet_handle);
}

int os_cfg_sync_mode(u8* dmac, u32 flag, libnet_t* libnet_handle)
{
	tsmp_cfg_pkt* pkt = (tsmp_cfg_pkt*)malloc(sizeof(tsmp_cfg_pkt));
	memset(pkt, 0, sizeof(tsmp_cfg_pkt));
	os_tsmp_header_generate(&(pkt->ts_header), dmac, CTRL_MAC, TSMP_ETH_TYPE, 0x2, 0x2);

	pkt->reg_num = htons(1);
	pkt->base_addr = htonl(0xc3d00006);
	pkt->reg1 = htonl(flag);

	os_pkt_send((u8*)pkt, 128, libnet_handle);	
}