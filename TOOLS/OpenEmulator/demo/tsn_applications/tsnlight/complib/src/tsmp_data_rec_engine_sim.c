
#include "../include/comp_api.h"




#define BUF_LEN_2048 2048
#define BUF_LEN_5120 5120


//控制器为0号端口
#define READ_FILE_PATH8 "../../data/data010.txt"

#define READ_FILE_PATHget "./data038.txt"
#define TIME_TXT  "../../data/time.txt"


FILE* recv_file = NULL;


unsigned char* read_line=NULL;
unsigned char* line=NULL;


void sim_create_debug_file()
{
	FILE *fp;
	char str[] = "****** debug message ******\n";
	fp = fopen("sim_debug_error.txt","w");
	fwrite(str,sizeof(char),strlen(str),fp);
	fclose(fp);
	return;
}


int data_pkt_receive_init(u8* rule, u8* net_interface) //检测，重建文本；
{
    char tmp_buf[128] = { 0 };
    read_line = (u8*)malloc(BUF_LEN_5120 * sizeof(u8));
    line = (u8*)malloc(BUF_LEN_2048 * sizeof(u8));

    if (access(READ_FILE_PATH8, F_OK) == -1)
    {
        sprintf(tmp_buf, "touch %s", READ_FILE_PATH8);
        system(tmp_buf);
    }
	

    if (NULL == (recv_file = fopen(READ_FILE_PATH8, "r")))
    {
        printf("open %s failed\n", READ_FILE_PATH8);
        return -1;
    }
	
	sim_create_debug_file();

    return 0;

}



void str_del_space(unsigned char* str)
{
    unsigned char* str_c = str;
    int i, j = 0;
    for (i = 0;str[i] != '\0';i++)
    {
        if ((str[i] != ' ') && (str[i] != '\r') && (str[i] != '\n'))
            str_c[j++] = str[i];
    }
    str_c[j] = '\0';
    str = str_c;
    //printf("del_space = %s\n", str);
}

int str2hex(unsigned char* str, unsigned char* out, unsigned int* outlen)
{
    unsigned char* p = str;
    unsigned char high = 0, low = 0;
    int tmplen = strlen(p), cnt = 0;
    tmplen = strlen(p);
    while (cnt < (tmplen / 2))
    {
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
	if(pkt_len < 60)
			return -1;//报文长度不足60字节，报文错误
		
	if((line[0]==0x66) && (line[1]==0x26 ) && (line[2]==0x62) && ((line[5]&0x3)==0x1))
	{	
		return 0;//dmid为TSNLight的mid
	}
	else if((line[36]==0x80) && (line[37]==0x80 ))
	{
		return 0;//udp协议目的端口号为TSNLight
	}
	else
	{
		return -1;
	}
}



u8* data_pkt_receive_dispatch_1(u16* len_len) //读入文本
{

    int tmp_len = 0;
    u8* eol = NULL; //END OF LINE "1111"
    u8* pkt_str = NULL;
	int ret = 0;

    memset(line, 0, BUF_LEN_2048);
    memset(read_line, 0, BUF_LEN_5120);
	
	fseek(recv_file, 0, SEEK_CUR);
	
    if (fgets(read_line, BUF_LEN_5120, recv_file) != NULL)
    {
        tmp_len = strlen(read_line);

        if ((eol = strstr(read_line, "1111")) != NULL)
        {
            strcpy(eol, "\0");
            str_del_space(read_line);
            pkt_str = read_line + 24;
            str2hex(pkt_str, line, &tmp_len);
            *len_len = tmp_len - 4;   //去掉报文末尾CRC校验和

			ret = tsnlight_filter_judge(tmp_len - 4);
			if(ret == -1)
			{
				//未找到符合过滤条件的报文
				return NULL;				
			}
			//cnc_pkt_print((u8 *)line,*len_len);
        }

        //报文不完整，指针回退
        else {
            fseek(recv_file, -tmp_len, SEEK_CUR);
			clearerr(recv_file);
            return NULL;
        }
    }
    else
	{
		//未读取到报文
		if(ferror(recv_file))
		{
			sim_write_debug_msg("error:data_pkt_receive_dispatch_1 ferror\n");	
			clearerr(recv_file);
		}
		else if(feof(recv_file))
		{
			//sim_write_debug_msg("error:data_pkt_receive_dispatch_1 feof\n");	
			clearerr(recv_file);			
		}
		
		return NULL;
	}
        
    return line;
}

u64 get_nsec(u8* hex_array)
{
    u64 nsec = 0;
	int i = 0;
    for (i = 0;i < 6;i++) {
        nsec = nsec << 8;
        nsec += hex_array[i];
    }

    return nsec;

}


struct  timeval gettimeoftxt()
{
    struct  timeval tv_gettime;
    tv_gettime.tv_sec = 0;
    tv_gettime.tv_usec = 0;

    u64 cur_nsec = 0;
    int len = 0;
    FILE* file = NULL;

    u8 hex_str[32] = {0};
    u8 hex_array[8] = {0};

    char* ptr_head_time = NULL;
    file = fopen(TIME_TXT, "r");
    if (file != NULL) {

        flock(fileno(file), LOCK_EX);
        if (fgets(hex_str, 32, file) != NULL)
        {
            flock(fileno(file), LOCK_UN);
             fclose(file);
            // str_del_space(hex_str);
            len = strlen(hex_str);
            str2hex(hex_str, hex_array, &len);
            cur_nsec = get_nsec(hex_array);

            tv_gettime.tv_sec = cur_nsec / 1000000000;
            tv_gettime.tv_usec = (cur_nsec % 1000000000) / 1000;
        }
		else
		{
			flock(fileno(file), LOCK_UN);
             fclose(file);
		}
    }

    return tv_gettime;

}


/*
    定义：int data_pkt_receive_destroy ( );
    功能：完成数据报文接收资源的销毁
    输入参数：无
    返回结果：成功返回0，失败返回-1
*/

int data_pkt_receive_destroy()
{
    if (recv_file != NULL)
    {
        fclose(recv_file);
    }

    if (line != NULL)
    {
        free(line);
        line = NULL;
    }

    if (read_line != NULL)
    {
        free(read_line);
        read_line = NULL;
    }
    return 0;
}








