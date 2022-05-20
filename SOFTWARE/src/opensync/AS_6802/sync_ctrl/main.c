// #include"./include/pcf_general.h"
#include "./include/timerlist.h"
#include "./include/pkt_process.h"
#include "./include/basic_fun.h"
#include "./include/pcf_general.h"

global_param_set gp_param;
sm_param_set sm_param;
cm_param_set cm_param;
#define __USE_GNU
#include <sched.h>
int main()
{
/***Initialization include 4 steps,all configuration in a xml file****/

    cpu_set_t mask;
    CPU_ZERO(&mask);
    CPU_SET(2,&mask);
    sched_setaffinity(0, sizeof(cpu_set_t), &mask);

    int device_num = 0;
    unsigned char *interface = NULL;

    /*Step1 Get global config*/
    init_cfg("init_cfg.xml", &device_num, &interface);
    param_cfg("param_cfg.xml");
    print_param_cfg();
    printf("%d   %s\n",device_num, interface);
    
    /*Step2 Initialize Send and Receive PKT handle*/
    pcap_t *pcap_handle = os_pkt_receive_init(interface, "ether[12:2]=0xff01");
    libnet_t *libnet_handle = os_pkt_send_init(interface, SEND_STATE_FILE);

    /*Step3 Initialize global data context and timerlist*/
    timer_list_node *timerlist[device_num];
    tte_sync_context *tsc_table[device_num];
    tte_sync_init(tsc_table, timerlist, "init_cfg.xml", device_num);

    /*Step4 Initialize each device sync mode/ integration cycle duration/ ctrl mac */ 
    for (int i = 0; i < device_num; i++)
    {
        os_cfg_sync_mode(tsc_table[i]->dev_info->dmac, 0, libnet_handle);
        os_cfg_node_mid(tsc_table[i]->dev_info->dmac, 6, libnet_handle);
        os_cfg_local_clock_cycle(tsc_table[i]->dev_info->dmac, gp_param.integrate_cycle_duration, libnet_handle);
    }
/***Initialization include 4 steps,all configuration in a xml file****/

    u8 *pkt;
    u16 pkt_len = 0;
    u32 device_id = 0;
    u64 cur_time = get_cur_nano_sec();
    while (1)
    {
        for (int i = 0; i < device_num; i++)
        {
            cur_time = get_cur_nano_sec();
            if (cur_time - timerlist[i]->timer_start >= timerlist[i]->timer_length && timerlist[i]->valid == 1)
            {
                timeout_handle(i, tsc_table[i], timerlist[i], libnet_handle);
            }
        }
        pkt = os_pkt_receive(&pkt_len, pcap_handle);
        if (pkt != NULL)
        {
            device_id = get_device_id(pkt, tsc_table, device_num);
            if (device_id == -1)
            {
                printf("no device\n");
                continue;
            }
            printf("pcf processed by device[%d]\n", device_id);
            // pkt_print(pkt, pkt_len);
            pkt_process(pkt, tsc_table[device_id], timerlist[device_id], libnet_handle);
        }
    }
}