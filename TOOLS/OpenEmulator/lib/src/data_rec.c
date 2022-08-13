#include "../include/sim.h"

FILE* recv_file = NULL;

u8* read_line = NULL;
u8* pkt_hex = NULL;

u8 filter_rule_type = 0;//0表示不需要过滤；1表示TSNLight的过滤规则；2表示OpenSync软件过滤规则;



int data_pkt_receive_init(u8* txtpath, u8 rule_type)
{
    char tmp_buf[128] = { 0 };
    read_line = (u8*)malloc(BUF_LEN_5120 * sizeof(u8));
    pkt_hex = (u8*)malloc(BUF_LEN_2048 * sizeof(u8));

    if (access(txtpath, F_OK) == -1) {
        sprintf(tmp_buf, "touch %s", txtpath);
        system(tmp_buf);
    }


    if (NULL == (recv_file = fopen(txtpath, "r"))) {
        printf("open %s failed\n", txtpath);
        return -1;
    }

    filter_rule_type = rule_type;

    return 0;

}


int str_del_space(u8* str)
{
    u8* str_c = str;
    int i, j = 0;
    for (i = 0;str[i] != '\0';i++) {
        if ((str[i] != ' ') && (str[i] != '\r') && (str[i] != '\n'))
            str_c[j++] = str[i];
    }
    str_c[j] = '\0';
    str = str_c;
    return 0;
}


int str2hex(u8* str, u8* out, u32* outlen)
{
    u8* p = str;
    u8 high = 0, low = 0;
    int tmplen = strlen(p), cnt = 0;
    tmplen = strlen(p);
    while (cnt < (tmplen / 2)) {
        high = ((*p > '9') && ((*p <= 'F') || (*p <= 'f'))) ? *p - 48 - 7 : *p - 48;
        low = (*(++p) > '9' && ((*p <= 'F') || (*p <= 'f'))) ? *(p)-48 - 7 : *(p)-48;
        out[cnt] = ((high & 0x0f) << 4 | (low & 0x0f));
        p++;
        cnt++;
    }
    if (tmplen % 2 != 0)
        out[cnt] = ((*p > '9') && ((*p <= 'F') || (*p <= 'f'))) ? *p - 48 - 7 : *p - 48;

    if (outlen != NULL)
        *outlen = tmplen / 2 + tmplen % 2;

    return tmplen / 2 + tmplen % 2;
}


int tsnlight_filter_judge(int pkt_len)
{
    if (pkt_len < 60)
        return -1;//报文长度不足60字节，报文错误

    if ((pkt_hex[0] == 0x66) && (pkt_hex[1] == 0x26) && (pkt_hex[2] == 0x62) && ((pkt_hex[5] & 0x3) == 0x1)) {
        return 0;//dmid为TSNLight的mid
    }
    else if ((pkt_hex[36] == 0x80) && (pkt_hex[37] == 0x80)) {
        return 0;//udp协议目的端口号为TSNLight
    }
    else {
        return -1;
    }
}


int opensync_filter_judge(int pkt_len)
{
    if (pkt_len < 60)
        return -1;//报文长度不足60字节，报文错误

    if ((pkt_hex[0] == 0x66) && (pkt_hex[1] == 0x26) && (pkt_hex[2] == 0x62) && ((pkt_hex[5] & 0x3) == 0x2)) {
        return 0;//dmid为opensync软件的mid
    }
    else if ((pkt_hex[36] == 0x90) && (pkt_hex[37] == 0x90)) {
        return 0;//udp协议目的端口号为OpenSync软件
    }
    else {
        return -1;
    }
}


int pkt_filter_handle(int pkt_len)
{
    int ret = 0;

    if (filter_rule_type == 0) {
        //不需要过滤规则
        return 0;
    }
    else if (filter_rule_type == 1) {
        ret = tsnlight_filter_judge(pkt_len);

    }
    else if (filter_rule_type == 2) {
        ret = opensync_filter_judge(pkt_len);
    }

    return ret;

}

u8* data_pkt_receive_dispatch_1(u16* pkt_len)
{

    int tmp_len = 0;
    u8* eol = NULL; //END OF LINE "1111"
    u8* pkt_str = NULL;

    int ret = 0;

    memset(pkt_hex, 0, BUF_LEN_2048);
    memset(read_line, 0, BUF_LEN_5120);
    // fflush(recv_file);
    fseek(recv_file, 0, SEEK_CUR);

    if (fgets(read_line, BUF_LEN_5120, recv_file) != NULL) {
        tmp_len = strlen(read_line);

        if ((eol = strstr(read_line, "1111")) != NULL) {
            strcpy(eol, "\0");
            str_del_space(read_line);
            pkt_str = read_line + 24;
            str2hex(pkt_str, pkt_hex, &tmp_len);
            *pkt_len = tmp_len - 4;

            ret = pkt_filter_handle(tmp_len - 4);
            if (ret == -1) {
                //未找到符合过滤条件的报文
                return NULL;
            }
        }

        //报文不完整，指针回退
        else {
            //printf("fseek back\n");
            fseek(recv_file, -tmp_len, SEEK_CUR);
            return NULL;
        }
    }
    //未读取到报文
    else {
        // printf("no packet\n");
        return NULL;
    }

    return pkt_hex;
}



int data_pkt_receive_destroy()
{
    if (recv_file != NULL) {
        fclose(recv_file);
    }

    if (pkt_hex != NULL) {
        free(pkt_hex);
        pkt_hex = NULL;
    }

    if (read_line != NULL) {
        free(read_line);
        read_line = NULL;
    }
    return 0;
}








