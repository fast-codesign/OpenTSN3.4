
#include "../include/comp_api.h"



#define BUF_LEN_2048 2048
#define BUF_LEN_5120 5120



unsigned char* send_line = NULL;


#define WRITE_FILE_PATH "../../data/data110.txt"
#define WRITE_FILE_STATE_PATH "../../data/data210.txt"



FILE* send_file = NULL;
FILE* send_file_state = NULL;

FILE* hx_libnet_fp = NULL;

typedef struct
{
    u16 pkt_len;
    u16 interal_time;
}__attribute__((packed))tmp_pkt_header;

int first_flag = 0;
int array_to_Str(unsigned char* buf, unsigned int buflen, unsigned char* out)
{

    tmp_pkt_header tmp_header;
    u8* tmp_p = NULL;

	if(first_flag == 0)
	{
    	tmp_header.interal_time = htons(0x0271);
		first_flag++;
	}
	else		
		tmp_header.interal_time = htons(0x00ff);//由0x000c修改为0x00ff，因为在配置状态寄存器时，隔根据才生效
    tmp_header.pkt_len = htons(buflen + 4);//报文末尾增加4字节的CRC校验和

    unsigned char pbuf[32];

    tmp_p = (u8*)&tmp_header;

    int i = 0;

    sprintf(pbuf, "%02X", tmp_p[i]);
    strncat(out, pbuf, 2);

    for (i = 1; i < 4; i++)
    {
        sprintf(pbuf, "%02X", tmp_p[i]);
        strncat(out, " ", 1);
        strncat(out, pbuf, 2);
    }


    for (i = 0; i < buflen; i++)
    {
        sprintf(pbuf, "%02X", buf[i]);
        strncat(out, " ", 1);
        strncat(out, pbuf, 2);
    }

	//报文末尾增加4字节的CRC校验和,全部设置为0
	tmp_header.interal_time = 0;
    tmp_header.pkt_len = 0;

	 for (i = 0; i < 4; i++)
    {
        sprintf(pbuf, "%02X", tmp_p[i]);
        strncat(out, " ", 1);
        strncat(out, pbuf, 2);
    }


	 //报文末尾增加换行符
    strncat(out, "\r\n", 2);
	
   // strncpy(out, str_buf, (buflen + 4 +4) * 2 + i + 4 +2);
   // printf("out = %s", out);

    return (buflen + 4 +4) * 2 + i + 4 +2;
}

/*
    定义：int data_pkt_send_init();
    功能：完成数据报文发送资源的初始化。包括raw scoket句柄的初始化、指定网卡名称、原始套接字地址结构赋值等	
    输入参数：无
    返回结果：成功返回0，失败返回-1
*/

int data_pkt_send_init(u8* net_interface)
{
    char* file_path = WRITE_FILE_PATH;
	char* file_state_path = WRITE_FILE_STATE_PATH;
   // str_buf = (u8*)malloc(BUF_LEN_5120 * sizeof(u8));
    send_line = (u8*)malloc(BUF_LEN_5120 * sizeof(u8));
	 char tmp_buf[128] = { 0 };
	
	  if (access(WRITE_FILE_PATH, F_OK) == -1)
    {
        sprintf(tmp_buf, "touch %s", WRITE_FILE_PATH);
        system(tmp_buf);
    }


	 if (access(WRITE_FILE_STATE_PATH, F_OK) == -1)
    {
        sprintf(tmp_buf, "touch %s", WRITE_FILE_STATE_PATH);
        system(tmp_buf);
    }


    if (NULL == (send_file = fopen(file_path, "a")))
    {
        printf("open %s failed\n", file_path);
        exit(1);
    }


	if (NULL == (send_file_state = fopen(file_state_path, "a")))
    {
        printf("open %s failed\n", file_state_path);
        exit(1);
    }

    return 0;
}


int hx_libnet_write(unsigned char* pkt, unsigned int len)
{
    int ret = EOF;
	int i = 0;
    memset(send_line, 0, BUF_LEN_5120);
    array_to_Str(pkt, len, send_line);

	//增加文件锁
	flock(fileno(send_file), LOCK_EX);

	//把文件指针定位到文件末尾
	fseek(send_file, 0, SEEK_END);

	while((ret == EOF) && (i<10))
	{
		ret = fputs(send_line, send_file);
		i++;

    	if (ret == EOF)
		{
			sim_write_debug_msg("error:hx_libnet_write error!i = %d,ret = %d\n",i,ret);
			if(ferror(send_file))
			{
				sim_write_debug_msg("error:hx_libnet_write ferror = %d\n",ferror(send_file));
				clearerr(send_file);
			}
		}
        
	}
	  
    //fputc('\r', send_file);
    //fputc('\n', send_file);
    fflush(send_file);

	//释放文件锁
	flock(fileno(send_file), LOCK_UN);

    return 	ret;
}


int hx_libnet_write_state()
{
    int ret = EOF;
	int i = 0;
	
	unsigned char tmp[8] = {0};
	tmp[0]= '1';
	tmp[1]= '\r';
	tmp[2]= '\n';

	//增加文件锁
	flock(fileno(send_file_state), LOCK_EX);

	//把文件指针定位到文件末尾
	fseek(send_file_state, 0, SEEK_END);  

	while((ret == EOF) && (i<10))
	{
		ret = fputs(tmp, send_file_state);
		i++;

    	if (ret == EOF)
		{
			sim_write_debug_msg("error:hx_libnet_write_state error!i = %d,ret = %d\n",i,ret);
			if(ferror(send_file_state))
			{
				sim_write_debug_msg("error:hx_libnet_write_state ferror\n");
				clearerr(send_file_state);
			}
		}
        
	}

    fflush(send_file_state);

	//释放文件锁
	flock(fileno(send_file_state), LOCK_UN);

    return 	ret;
}



/*
    定义：int data_pkt_send_handle(u8* pkt,u16 len);
    功能：完成数据报文的发送处理
    输入参数：数据报文指针、数据报文长度
    返回结果：成功返回0，失败返回-1
*/


int data_pkt_send_handle(u8* pkt_pkt, u16 len_len)
{
	
    hx_libnet_write(pkt_pkt, len_len);
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
    if (send_file != NULL)

    {

        fclose(send_file);

    }


    if (send_file_state != NULL)

    {

        fclose(send_file_state);

    }


    if (send_line != NULL)
    {
        free(send_line);
        send_line = NULL;
    }
    return 0;
}



