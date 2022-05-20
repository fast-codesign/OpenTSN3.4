#include"../include/opensync.h"

/*opensync 生成*/


int  os_tsmp_header_generate(os_tsmp_header* ts_header, u8* dmac, u8* smac, u16 ethtype, u8 type, u8 subtype)
{
    for (int i = 0; i < 6; i++)
    {
        ts_header->dmac[i] = dmac[i];
        ts_header->smac[i] = smac[i];
    }

    ts_header->sub_type = subtype;
    ts_header->eth_type = htons(ethtype);
    ts_header->type = type;
}


int os_header_generate(os_time_value dispatch_pit , opensync_header* os_header)
{
    int len = 64;
    for (int i = 0; i < 8; i++)
    {
        len -= 8;
        os_header->timestamp1[i] = (dispatch_pit >> len) & 0xff;
    }
}

