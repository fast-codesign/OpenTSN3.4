#include "../include/opensync.h"

int os_pkt_parse(u8 *pkt, opensync_header *os_header)
{

}

os_time_value os_get_receive_pit(u8* pkt)
{
    u8 *timestamp1 = (pkt);

    u64 ts = 0;
    int count = 0;
    while (count < 8)
    {
        ts = ts | timestamp1[count];
        if (count == 7)
        {
            break;
        }
        ts = ts << 8;
        count++;
    }

    return ts;
}
