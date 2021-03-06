/*
 * @Date: 2021-12-30 16:13:16
 * @LastEditTime: 2022-01-05 15:23:04
 * @Description: file content
 */
#ifndef _SIM_H_
#define _SIM_H


#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/file.h>
#include <sys/time.h>
#include <math.h>
#include <arpa/inet.h>

#define BUF_LEN_2048 2048
#define BUF_LEN_5120 5120

#define SIM_DEBUG_BUFFER_MAX 4096
#define sim_write_debug_msg(format,...){char buffer[SIM_DEBUG_BUFFER_MAX+1]={0};snprintf(buffer,SIM_DEBUG_BUFFER_MAX,format,##__VA_ARGS__);FILE*fp = fopen("sim_debug_error.txt","a+");if(fp!=NULL){fwrite(buffer,strlen(buffer),1,fp);};fclose(fp);}


typedef unsigned long   u64;
typedef unsigned int    u32;
typedef unsigned short  u16;
typedef unsigned char   u8;

typedef struct
{
    u16 pkt_len;
    u16 interal_time;
}__attribute__((packed))tmp_pkt_header;



void sim_create_debug_file();

/*---------------------------------------报文读取接口-------------------------------------------------*/
int data_pkt_receive_init(u8* txtpath,u8 rule_type);

u8* data_pkt_receive_dispatch_1(u16* pkt_len);

int data_pkt_receive_destroy();

int str_del_space(u8* str);

int str2hex(u8* str, u8* out, u32* outlen);

/*---------------------------------------报文发送接口-------------------------------------------------*/

int array_to_Str(u8* buf, u32 buflen, u8* out);

int data_pkt_send_init(u8* txtfile_data,u8* txtfile_state);

int hx_libnet_write(u8* pkt, u32 len);

int hx_libnet_write_state();

int data_pkt_send_handle(u8* pkt_pkt, u16 len_len);

int data_pkt_send_destroy();

/*---------------------------------------时间、时钟获取接口--------------------------------------------*/

struct  timeval gettimeoftxt(u8* txtpath);

u64 get_nsec(u8* hex_array);

#endif