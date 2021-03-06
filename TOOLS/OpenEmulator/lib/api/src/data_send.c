#include "../include/sim.h"

#define BUF_LEN_5120 5120

//u8* str_buf = NULL;
u8* send_line = NULL;

FILE* send_file = NULL;
FILE* send_file_state = NULL;


int array_to_Str(unsigned char* buf, unsigned int buflen, unsigned char* out)
{

    //     tmp_pkt_header tmp_header;
    //     u8* tmp_p = NULL;

    //     tmp_header.interal_time = htons(0x000c);
    //     tmp_header.pkt_len = htons(buflen );

    //     unsigned char pbuf[32];
    //     //memset(str_buf, 0, BUF_LEN_5120);

    //     tmp_p = (u8*)&tmp_header;

    //     int i = 0;

    //     sprintf(pbuf, "%02X", tmp_p[i]);
    //     strncat(out, pbuf, 2);

    //     for (i = 1; i < 4; i++)
    //     {
    //         sprintf(pbuf, "%02X", tmp_p[i]);
    //         strncat(out, " ", 1);
    //         strncat(out, pbuf, 2);
    //     }


    //     for (i = 0; i < buflen; i++)
    //     {
    //         sprintf(pbuf, "%02X", buf[i]);
    //         strncat(out, " ", 1);
    //         strncat(out, pbuf, 2);
    //     }



    // 	 //报文末尾增加换行符
    //     strncat(out, "\r\n", 2);

    //    // strncpy(out, str_buf, (buflen + 4 +4) * 2 + i + 4 +2);
    //    // printf("out = %s", out);

    //     return (buflen + 4 ) * 2 + i + 4 +2;

    tmp_pkt_header tmp_header;
    u8* tmp_p = NULL;

    tmp_header.interal_time = htons(0x000c);
    tmp_header.pkt_len = htons(buflen + 4);//报文末尾增加4字节的CRC校验和

    unsigned char pbuf[32];
    //memset(str_buf, 0, BUF_LEN_5120);

    tmp_p = (u8*)&tmp_header;

    int i = 0;

    sprintf(pbuf, "%02X", tmp_p[i]);
    strncat(out, pbuf, 2);

    for (i = 1; i < 4; i++) {
        sprintf(pbuf, "%02X", tmp_p[i]);
        strncat(out, " ", 1);
        strncat(out, pbuf, 2);
    }


    for (i = 0; i < buflen; i++) {
        sprintf(pbuf, "%02X", buf[i]);
        strncat(out, " ", 1);
        strncat(out, pbuf, 2);
    }

    //报文末尾增加4字节的CRC校验和,全部设置为0
    tmp_header.interal_time = 0;
    tmp_header.pkt_len = 0;

    for (i = 0; i < 4; i++) {
        sprintf(pbuf, "%02X", tmp_p[i]);
        strncat(out, " ", 1);
        strncat(out, pbuf, 2);
    }


    //报文末尾增加换行符
    strncat(out, " \r\n", 2);

    // strncpy(out, str_buf, (buflen + 4 +4) * 2 + i + 4 +2);
    // printf("out = %s", out);

    return (buflen + 4 + 4) * 2 + i + 4 + 2;
}


int data_pkt_send_init(u8* txtfile_data, u8* txtfile_state)
{
    // str_buf = (u8*)malloc(BUF_LEN_4096 * sizeof(u8));
    send_line = (u8*)malloc(BUF_LEN_5120 * sizeof(u8));
    char tmp_buf[128] = { 0 };

    if (access(txtfile_data, F_OK) == -1) {
        sprintf(tmp_buf, "touch %s", txtfile_data);
        system(tmp_buf);
    }

    if (access(txtfile_state, F_OK) == -1) {
        sprintf(tmp_buf, "touch %s", txtfile_state);
        system(tmp_buf);
    }


    if (NULL == (send_file = fopen(txtfile_data, "a"))) {
        printf("open %s failed\n", txtfile_data);
        exit(1);
    }

    if (NULL == (send_file_state = fopen(txtfile_state, "a"))) {
        printf("open %s failed\n", txtfile_state);
        exit(1);
    }

    return 0;
}


int hx_libnet_write(u8* pkt, u32 len)
{
    int ret;
    memset(send_line, 0, BUF_LEN_5120);
    array_to_Str(pkt, len, send_line);

    //增加文件锁
    flock(fileno(send_file), LOCK_EX);

    //把文件指针定位到文件末尾
    fseek(send_file, 0, SEEK_END);
    ret = fputs(send_line, send_file);

    if (-1 == ret)
        printf("hx_libnet_write error! \n");

    //fputc('\r', send_file);
    //fputc('\n', send_file);
    fflush(send_file);

    //释放文件锁
    flock(fileno(send_file), LOCK_UN);

    return 	ret;
}


int hx_libnet_write_state()
{
    int ret;
    unsigned char tmp[8] = { 0 };
    tmp[0] = '1';
    tmp[1] = '\r';
    tmp[2] = '\n';

    //增加文件锁
    flock(fileno(send_file_state), LOCK_EX);

    //把文件指针定位到文件末尾
    fseek(send_file_state, 0, SEEK_END);

    ret = fputs(tmp, send_file_state);

    if (-1 == ret)
        printf("hx_libnet_write_state error! \n");

    //fputc('\r', send_file);
    //fputc('\n', send_file);
    fflush(send_file_state);

    //释放文件锁
    flock(fileno(send_file_state), LOCK_UN);

    return 	ret;
}

int data_pkt_send_handle(u8* pkt, u16 len)
{
    hx_libnet_write(pkt, len);
    hx_libnet_write_state();
    return 0;
}


/*
    定义：int data_pkt_send_destroy();
    功能：完成数据报文发送相关资源的销毁
    输入参数：无
    返回结果：成功返回0，失败返回-1
*/

int data_pkt_send_destroy()
{
    if (send_file != NULL) {
        fclose(send_file);
    }

    if (send_file_state != NULL) {
        fclose(send_file_state);
    }


    if (send_line != NULL) {
        free(send_line);
        send_line = NULL;
    }
    return 0;
}



