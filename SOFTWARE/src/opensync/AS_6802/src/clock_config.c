#include "../include/opensync.h"
u8 CTRL_MAC[6] = {0x66,0x26,0x62,0x00,0x60,0x02};


int os_cfg_local_clock_cycle (u8* dmac,u32 cycle_duration, libnet_t* libnet_handle)
{
	tsmp_cfg_pkt* pkt = (tsmp_cfg_pkt*)malloc(sizeof(tsmp_cfg_pkt));
	memset(pkt, 0, sizeof(tsmp_cfg_pkt));
	os_tsmp_header_generate(&(pkt->ts_header), dmac, CTRL_MAC, TSMP_ETH_TYPE, 0x2, 0x2);
	pkt->reg_num = htons(1);
	pkt->base_addr = htonl(0x00080005);
	// pkt->reg2 = htonl(0xffffffff & cycle_duration);
	// pkt->reg1 = htonl(0xffffffff & (cycle_duration >> 32));
	pkt->reg1 = htonl(cycle_duration);

	os_pkt_send((u8*)pkt, 128, libnet_handle);
}

int os_cfg_local_clock(u8* dmac, os_time_value clock_value, os_time_value reference_pit, libnet_t* libnet_handle)
{
	tsmp_cfg_pkt* pkt = (tsmp_cfg_pkt*)malloc(sizeof(tsmp_cfg_pkt));
	memset(pkt, 0, sizeof(tsmp_cfg_pkt));
	os_tsmp_header_generate(&(pkt->ts_header), dmac, CTRL_MAC, TSMP_ETH_TYPE, 0x2, 0x2);

	pkt->reg_num = htons(3);
	// pkt->base_addr = htonl(0x80080000);
	pkt->base_addr = htonl(OS_CSET0_REG);
	pkt->reg2 = htonl(0xffffffff & clock_value);
	pkt->reg1 = htonl(0xffffffff & (clock_value >> 32));
	pkt->reg3 = htonl(0xffffffff & reference_pit);
	pkt->reg4 = htonl(0);

	os_pkt_send((u8*)pkt, 128, libnet_handle);
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

int os_cfg_phase_offset(u8* dmac, int offset, libnet_t* libnet_handle)
{
	tsmp_cfg_pkt* pkt = (tsmp_cfg_pkt*)malloc(sizeof(tsmp_cfg_pkt));
	memset(pkt, 0, sizeof(tsmp_cfg_pkt));
	os_tsmp_header_generate(&(pkt->ts_header), dmac, CTRL_MAC, TSMP_ETH_TYPE, 0x2, 0x2);
	pkt->reg_num = htons(1);
	pkt->base_addr = htonl(0x00080006);
	if (offset >= 0)
	{
		pkt->reg1 = htonl(offset);
		if(offset > 1000)
			return 0;
	}
	else
	{
		if(offset < -1000)
			return 0;
		int temp = -offset;
		pkt->reg1 = htonl(0x80000000|temp);
	}
	os_pkt_send((u8*)pkt, 128, libnet_handle);
}

int os_cfg_sync_mode(u8* dmac, u32 flag, libnet_t* libnet_handle)
{
	tsmp_cfg_pkt* pkt = (tsmp_cfg_pkt*)malloc(sizeof(tsmp_cfg_pkt));
	memset(pkt, 0, sizeof(tsmp_cfg_pkt));
	os_tsmp_header_generate(&(pkt->ts_header), dmac, CTRL_MAC, TSMP_ETH_TYPE, 0x2, 0x2);

	pkt->reg_num = htons(1);
	pkt->base_addr = htonl(0x00200000);
	pkt->reg1 = htonl(flag);

	os_pkt_send((u8*)pkt, 128, libnet_handle);	
}

int os_cfg_node_mac(u8* dmac, u8* sync_mac ,libnet_t* libnet_handle)
{
	tsmp_cfg_pkt* pkt = (tsmp_cfg_pkt*)malloc(sizeof(tsmp_cfg_pkt));
	memset(pkt, 0, sizeof(tsmp_cfg_pkt));
	os_tsmp_header_generate(&(pkt->ts_header), dmac, CTRL_MAC, TSMP_ETH_TYPE, 0x2, 0x2);
	pkt->reg_num = htons(2);
	pkt->base_addr = htonl(0x4);

	// u32 *reg = (u32 *)sync_mac;
	// pkt->reg2 = reg[0]; 
	// reg[1] = reg[1] & 0xffff;
	// pkt->reg1 = reg[1];

	u32 reg = 0;
	for (int i = 2; i < 6; i++)
	{
		reg = (reg << 8);
		reg = reg | sync_mac[i];
	}
	pkt->reg2 = htonl(reg);
	reg = 0;
	reg = reg | sync_mac[0];
	reg = reg << 8;
	reg = reg | sync_mac[1];
	pkt->reg1 = htonl(reg);

	os_pkt_send((u8*)pkt, 128, libnet_handle);
}

int os_cfg_node_mid(u8* dmac, u16 mid ,libnet_t* libnet_handle)
{
	tsmp_cfg_pkt* pkt = (tsmp_cfg_pkt*)malloc(sizeof(tsmp_cfg_pkt));
	memset(pkt, 0, sizeof(tsmp_cfg_pkt));
	os_tsmp_header_generate(&(pkt->ts_header), dmac, CTRL_MAC, TSMP_ETH_TYPE, 0x2, 0x2);
	pkt->reg_num = htons(1);
	pkt->base_addr = htonl(0x00080001);
	pkt->reg1 = htonl(mid);


	os_pkt_send((u8*)pkt, 128, libnet_handle);
}