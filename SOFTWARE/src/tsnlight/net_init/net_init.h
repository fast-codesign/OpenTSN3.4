#ifndef _NET_INIT_H__
#define _NET_INIT_H__

#include"../complib/include/comp_api.h"

#if 1
#include <libxml/xmlmemory.h>  
#include <libxml/parser.h>  
#endif


int net_init(u8 *network_inetrface,u16 *tsnlight_mid,u32 version);


int resource_clear(u8 *network_inetrface);


#endif




