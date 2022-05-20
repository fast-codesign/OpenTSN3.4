#ifndef _BASIC_CFG_H__
#define _BASIC_CFG_H__


#include"../complib/include/comp_api.h"

#include <libxml/xmlmemory.h>  
#include <libxml/parser.h>  


#define INIT_XML_FILE "./config/tsnlight_init_cfg.xml"





void fwrite_file(u8 *const locla_mac,u64 hw_version,u8 *const name);

int basic_cfg(u8* state,u32 sw_ver,u16 tsnlight_mid);

#endif



