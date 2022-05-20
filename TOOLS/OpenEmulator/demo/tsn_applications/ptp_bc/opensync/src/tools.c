/*
 * @Date: 2021-11-22 20:20:24
 * @LastEditTime: 2021-11-22 20:21:49
 * @Description: file content
 */
#include "../include/opensync.h"
#include <time.h>
#include <sys/time.h>

 /**
  * @file tools.c
  * @brief 获取时间、计算差值等工具函数的实现
  */



  /**
   *
   * @return 返回纳秒为单位的 64 bit 的当前时间
   */
u64 get_cur_nano_sec()
{
#ifndef SIM
    unsigned long CurNanoSec;
    struct timespec tv;
    clock_gettime(ITIMER_REAL, &tv);
    CurNanoSec = tv.tv_sec * 1000000000 + tv.tv_nsec;

    return CurNanoSec;
#endif
#if SIM
    struct timeval t = gettimeoftxt(CLOCK_PATH); 
    u64 CurTime = t.tv_sec * 1000000000 + t.tv_usec * 1000;
    return CurTime;
#endif
}



/**
 * 计算两个时间的差值
 * @param cur_time 当前时刻，64bit 以纳秒为单位
 * @param start_time 起始时刻，64bit 以纳秒为单位
 * @return 两个时刻之间的差值
 */
u64 get_diff(u64 cur_time, u64 start_time)
{
    u64 diff = cur_time - start_time;
    return diff;
}




unsigned long long ntohll(unsigned long long val)
{
    if (__BYTE_ORDER == __LITTLE_ENDIAN)
        return (((unsigned long long)htonl((int)((val << 32) >> 32))) << 32) | (unsigned int)htonl((int)(val >> 32));
    else if (__BYTE_ORDER == __BIG_ENDIAN)
        return val;

}


unsigned long long htonll(unsigned long long val)
{
    if (__BYTE_ORDER == __LITTLE_ENDIAN)
        return (((unsigned long long)htonl((int)((val << 32) >> 32))) << 32) | (unsigned int)htonl((int)(val >> 32));
    else if (__BYTE_ORDER == __BIG_ENDIAN)
        return val;
}


void os_pkt_print(u8* pkt, int len)
{
    int i = 0;

    printf("-----------------------***PACKET***-----------------------\n");
    printf("Packet Addr:%p\n", pkt);
    for (i = 0;i < 16;i++)
    {
        if (i % 16 == 0)
            printf("      ");
        printf(" %X ", i);
        if (i % 16 == 15)
            printf("\n");
    }

    for (i = 0;i < len;i++)
    {
        if (i % 16 == 0)
            printf("%04X: ", i);
        printf("%02X ", *((u8*)pkt + i));
        if (i % 16 == 15)
            printf("\n");
    }
    if (len % 16 != 0)
        printf("\n");
    printf("-----------------------***PACKET***-----------------------\n\n");
}
