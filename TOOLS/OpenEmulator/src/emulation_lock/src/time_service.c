/*
 * @Date: 2022-01-03 21:10:35
 * @LastEditTime: 2022-04-12 15:10:09
 * @Description: 将获取的仿真时间/时钟写入相关文件的操作
 */

#include "../include/interlock.h"

u8 ctoa(u8 in)
{
        u8 out;
        if (0 <= in && in <= 9)
                out = in + 48;
        if (0xa <= in && in <= 0xf)
                out = in + 'A' - 0xa;
        // printf("%x,%c\n", in, out);
        return out;
}

int hex2str(u8* hex_array, u8* hex_str)
{
        char high4, low4;
        int i = 0;
        for (i = 0;i < 6;i++) {
                high4 = ctoa(hex_array[i] >> 4);
                low4 = ctoa(hex_array[i] & 0x0f);
                hex_str[i * 2] = high4;
                hex_str[i * 2 + 1] = low4;
        }
        return 0;
}

int update_time(u8* nanosec_array, u8* time_txt)
{

        u8 hex_str[16] = { 0 };
        FILE* fp = NULL;
        int i = 0;

        hex2str(nanosec_array, hex_str);

        while (i < 3) {

                fp = fopen(time_txt, "w");

                if (fp != NULL) {
                        flock(fileno(fp), LOCK_EX);
                        fputs(hex_str, fp);
#if 0
                        for (int i = 0;i < 12;i++) {
                                printf("%c", hex_str[i]);

                        }
#endif
                        fclose(fp);
                        flock(fileno(fp), LOCK_UN);
                        break;
                }
                else {
                        i++;
                        printf("fopen time.txt error! i = %d \n", i);
                        continue;
                }

        }

        return 0;
}
