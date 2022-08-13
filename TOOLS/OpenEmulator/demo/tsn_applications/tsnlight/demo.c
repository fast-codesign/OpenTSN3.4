/*
 * @Date: 2022-06-02 12:17:39
 * @LastEditTime: 2022-06-02 18:08:04
 * @Description: file content
 */

#include <stdio.h>
#include <unistd.h>


int main()
{   

    int i;
    for (i = 0;i<10;i++){
        sleep(1);
        printf("testtest\n");
    }
   
    return 0;
}