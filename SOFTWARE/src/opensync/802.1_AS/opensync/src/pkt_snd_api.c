#include "../include/opensync.h"



libnet_t* os_pkt_send_init(u8* net_interface,u8* sim_write_state)
{
#ifndef SIM
	char error_info[LIBNET_ERRBUF_SIZE];
	libnet_t* libnet_handle = libnet_init(LIBNET_LINK, net_interface, error_info);
	if (libnet_handle == NULL)
	{
		fprintf(stderr, "libnet_init() failed: %s", error_info);
		exit(EXIT_FAILURE);
	}
	printf("LIBNET INIT SUCCESS.\n");
	return libnet_handle;
#endif
#if SIM
	data_pkt_send_init(net_interface,sim_write_state);
#endif
}


int os_pkt_send(u8* pkt, u16 pkt_len, libnet_t* libnet_handle)
{
#ifndef SIM
	libnet_ptag_t lib_t = 0;
	lib_t = libnet_build_ethernet(pkt, pkt + 6, 0xff01, pkt + 14, pkt_len, libnet_handle, 0);

	//printf("send pkt\n");
	//os_pkt_print(pkt, pkt_len);

	int re = libnet_write(libnet_handle);
	if (re == -1)
	{
		printf("Libnet send error!\n");
	}

	libnet_clear_packet(libnet_handle);
	return re;
#endif
#if SIM
	//printf("send pkt\n");
	//os_pkt_print(pkt, pkt_len);

	data_pkt_send_handle(pkt, pkt_len);
#endif
}

int os_pkt_send_destroy(libnet_t* libnet_handle)
{
#ifndef SIM
	libnet_destroy(libnet_handle);
	return (EXIT_SUCCESS);
#endif
#if SIM
	data_pkt_send_destroy();
#endif
}

