/*
 * @Date: 2022-01-03 21:06:26
 * @LastEditTime: 2022-04-28 16:06:31
 * @Description: file content
 */
#ifndef _INTERLOCK_H
#define _INTERLOCK_H

#include "../../libsim/include/sim.h"

#define RECV_TXT "../../Data/data018.txt"
#define SEND_TXT "../../Data/data118.txt"
#define SEND_STATE_TXT "../../Data/data218.txt"
#define TIME_TXT "../../Data/time.txt"
 // #define RECV_TXT "./data018.txt"
 // #define SEND_TXT "./data118.txt"
 // #define TIME_TXT "./time.txt"


  /**
   * @name:
   * @msg: 十六进制值转换为字符，0x0 -> '0' ,0xf -> 'f'
   * @param {u8} in,十六进制值，如0x0/0xf
   * @return {*} 十六进制自身，如'f'
   */
u8 ctoa(u8 in);

/**
 * @name:
 * @msg:十六进制数组转换为十六进制字符串，如：{0x00,0x00,0x00,0x00,0x00,0x00} -> "000000000000"
 * @param {u8*} hex_array，十六进制数组
 * @param {u8*} hex_str，十六进制字符串
 * @return {*}
 */
int hex2str(u8* hex_array, u8* hex_str);

/**
 * @name:
 * @msg: 向TIME_TXT中写入新的时间，以提供给端应用
 * @param {u8*} nanosec_array
 * @param {u8*} time_txt
 * @return {*}
 */
int update_time(u8* nanosec_array, u8* time_txt);


#endif
