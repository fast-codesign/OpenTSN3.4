/*
 * @Date: 2021-12-30 17:00:10
 * @LastEditTime: 2022-01-05 14:54:19
 * @Description: file content
 */
#include "../include/sim.h"



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

struct  timeval gettimeoftxt(u8* txtpath)
{
    struct  timeval tv_gettime;
    tv_gettime.tv_sec = 0;
    tv_gettime.tv_usec = 0;

    u64 cur_nsec = 0;
    int len = 0;
    FILE* file = NULL;

    u8 hex_str[32] = {0};
    u8 hex_array[8];

    char* ptr_head_time = NULL;
    file = fopen(txtpath, "r");
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


u64 get_nsec_of_txt(u8* txtpath)
{
    u64 cur_nsec = 0;
    int len = 0;
    FILE* file = NULL;

    u8 hex_str[32] = {0};
    u8 hex_array[8];
    // printf("path:%s\n",txtpath);

    char* ptr_head_time = NULL;
    file = fopen(txtpath, "r");
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

        }
		else
		{
			flock(fileno(file), LOCK_UN);
            fclose(file);
		}
    }
    // printf("cur_nsec:%ld\n",cur_nsec);
    return cur_nsec;

}

