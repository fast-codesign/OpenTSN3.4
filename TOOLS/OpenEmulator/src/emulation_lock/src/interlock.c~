/*
 * @Date: 2022-01-03 21:05:37
 * @LastEditTime: 2022-04-12 21:25:37
 * @Description: 互锁机制的软件控制程序
 */
#include "../include/interlock.h"


int main()
{
    data_pkt_receive_init(RECV_TXT, 0);
    data_pkt_send_init(SEND_TXT, SEND_STATE_TXT);
    u8* time_txt = TIME_TXT;
    u8* ipkt;
    u16 len;
    u8  nanosec[6] = { 0 };
    char tmp_buf[128] = { 0 };
    sprintf(tmp_buf, "cat /dev/null > %s", TIME_TXT);
    system(tmp_buf);
    while (1) {
        ipkt = data_pkt_receive_dispatch_1(&len);
        if (ipkt != NULL) {
            printf("read time-->");
            memcpy(nanosec, ipkt, 6);
            update_time(nanosec, time_txt);
            printf("update time-->");
            data_pkt_send_handle(ipkt, len);
            printf("return time\n");
        }

        else
            continue;
    }

    /*------------------------------gettimeoftxt测试---------------------------------------------*/
    // u8 nanosec[6] = { 0x00,0x00,0x3B,0x9A,0xDD,0x88 };
    // update_time(nanosec, time_txt);

    // struct  timeval tv_gettime = gettimeoftxt(time_txt);
    // u64 cur_us = tv_gettime.tv_sec * 1000000 + tv_gettime.tv_usec;

    // printf("cur_us:%ld\n", cur_us);


    data_pkt_receive_destroy();
    data_pkt_send_destroy();

    return 0;
}
