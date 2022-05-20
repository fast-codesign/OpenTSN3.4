#ifndef PCF_GENERAL_H
#define PCF_GENERAL_H

#include"../../include/opensync.h"
#include <stdbool.h>
#define MAX_DEVICE_NUM 20

//CM状态
enum cm_state
{
    CM_INTEGRATE,
    CM_UNSYNC,
    CM_ENABLE,
    CM_WAIT_4_IN,
    CM_SYNC
};

// SM状态
enum sm_state
{
    SM_INTEGRATE,
    SM_UNSYNC,
    SM_FLOOD,
    SM_WAIT_4_CS_CS,
    SM_TENTATIVE_SYNC,
    SM_SYNC,
    SM_STABLE
};

typedef struct device_info{
    u8 dmac[6]; // local device mac tsmp dmac
    u8 smac[6]; // controller mac
    u8 mac[6];  // eth_dmac
    u16 sync_clock_role;
    u16 mid;
}__attribute__((packed))device_info;

typedef struct global_param_set{
    u64 integrate_cycle_duration;
    u64 max_transmission_delay;
    u32 max_integration_cycle;
    u32 accuarcy;
}__attribute__((packed))global_param_set;

typedef struct local_sync_info{
    u32 local_integration_cycle;
    u32 local_sync_membership;      //bitmap
    u32 local_async_membership_1;   //bitmap
    u32 local_async_membership_2;   //bitmap
    u32 local_sync_membership_cnt;
    u32 local_async_membership_cnt;
}__attribute__((packed))local_sync_info;

typedef struct cm_param_set{
    u64 cm_listen_timeout;
    u64 cm_ca_enable_timeout;
    u64 cm_wait_4_in_timeout;
    u64 cm_restart_timeout;

    u32 cm_integerate_to_sync_thrld;
    u32 cm_unsync_to_sync_thrld;
    u32 cm_sync_threshold_sync;
    u32 cm_sync_threshold_async;

    u8  fault_tolerant;
    u32 observe_window;
    u32 max_observation_window_num;
    u32 cm_disaptch_delay;
    u32 cm_caculation_overhead;
    u32 cm_static_delay;
/*软硬件协同设置的不同状态下软件接收窗口*/   
    u32 cm_sync_listen_timeout;
    u32 cm_ca_listen_timeout;
    u32 cm_wait4in_listen_timeout;
    u64 cm_dispatch_pit;
}cm_param_set;

typedef struct sm_param_set{
    u64 sm_listen_timeout;
    u64 sm_coldstart_timeout;
    u64 sm_restart_timeout;
    u64 cs_offset;
    u64 ca_offset;
    u32 ca_accpetance_window;
    u32 ca_receive_timeout;
    u32 sm_integrate_to_sync_thrld;
    u32 sm_unsync_to_sync_thrld;
    u32 sm_unsync_to_tentative_thrld;
    u32 sm_tentative_sync_thrld_sync;
    u32 sm_tentative_to_sync_thrld;
    u32 sm_sync_threshold_sync;
    u32 num_stable_cycles;
    u32 num_unstable_cycles;
    u32 sm_stable_threshold_sync;
}sm_param_set;

typedef struct cm_sync_info{
    enum cm_state cur_state;
    struct local_sync_info* cur_sinfo;
    u32  static_delay;
    // struct cm_param_set* cmp_set;
}cm_sync_info;

typedef struct sm_sync_info{
    enum sm_state cur_state;
    struct local_sync_info* cur_sinfo;
    bool ca_receive;
    u16  stable_cycle_count;
    u64  static_delay;
    // struct sm_param_set* smp_set;
}sm_sync_info;

// typedef struct sc_sync_info{}sc_sync_info;

typedef struct sync_statistic{
    u32 last_offset;
    u32 max_offset;
    u64 min_offset;
}sync_statistic;

typedef struct pkt_info
{
    u8  pkt_type;
    u32 integration_cycle;
    u32 membership_new;
    u8  sync_priority;
    u8  sync_domain;
    u8  pcf_type;
    u64 transparent_clock;
    u64 receive_pit;
    u64 permanance_pit;
}__attribute__((packed))pkt_info;


typedef struct tte_sync_context{
    u32 device_id;
    device_info* dev_info;
    // global_param_set* gp_set;
    cm_sync_info* cm_info;
    sm_sync_info* sm_info;
    // sc_sync_info* sc_info;
    pkt_info* last_pcf_pkt;
    u16 pkt_info_num;
    sync_statistic* statistic_info;
}tte_sync_context;


typedef struct pcf_pkt
{
    u8  dmac[6];
    u8  smac[6];
    u16 ether_type;
    u32 integration_cycle;
    u32 membership_new;
    u32 reserved1;
    u8  sync_priority;
    u8  sync_domain;
    u16 type : 4,
        reserved2 : 4,
        reserved3 : 8;
    u32 reserved4;
    u64 transparent_clock;
}__attribute__((packed))pcf_pkt;

typedef struct pcf_payload
{
    u32 integration_cycle;
    u32 membership_new;
    u32 reserved1;
    u8  sync_priority;
    u8  sync_domain;
    u16 type : 4,
        reserved2 : 4,
        reserved3 : 8;
    u32 reserved4;
    u64 transparent_clock;
}__attribute__((packed))pcf_payload;

enum clock_role
{
    ROLE_CM = 0x11,
    ROLE_SM = 0x12
};

typedef struct timer_list_node
{
    unsigned int device_id;
    unsigned char valid;
    unsigned long long timer_start;
    unsigned long long timer_length;
    unsigned long cycle_correction;
}timer_list_node;

typedef struct tsmp_sync_pkt
{
    os_tsmp_header  os_t_header;
    opensync_header os_header;
    pcf_pkt         payload;
}__attribute__((packed))tsmp_sync_pkt;


#define TSMP_PROTOCOL                   0xff01
#define PCF_SIZE                        0x60
#define ETHERNET_PCF_TYPE               0x891d

#define IN_TYPE                         0x2
#define CS_TYPE                         0x4
#define CA_TYPE                         0x8
#define SYNC_PRIORITY                   0x7f
#define SYNC_DOMAIN                     0x88

#define CM_DISPATCH_PIT                 0x1374aa0
#define CM_SCHEDULED_RECEIVED_PIT       0x100
#define INIT_INTEGRATION_CYCLE          0
#define SM_DISPATCH_PIT                 0
#define FT                              1
#if 0
/*******************************************************Global Param************************************************************/
#define PI                              1000
#define INTEGRATION_CYCLE_DURATION      100000000
#define MAX_TRANSMISSION_DELAY          20000000
#define MAX_INTEGRATION_CYCLE           0xc9
/*******************************************************Global Param************************************************************/


/*******************************************************CM Param************************************************************/
#define CM_LISTEN_TIMEOUT               1*INTEGRATION_CYCLE_DURATION
#define CM_CA_ENABLE_TIMEOUT            INTEGRATION_CYCLE_DURATION
#define CM_WAIT_4_IN_TIMEOUT            1*INTEGRATION_CYCLE_DURATION
#define CM_RESTART_TIMEOUT              INTEGRATION_CYCLE_DURATION
#define CM_DISPATCH_DEALY               0x190
#define CM_CALCULATION_OVERHEAD         20


#define CM_INTEGRATE_TO_SYNC_THRLD      1
#define CM_UNSYNC_TO_SYNC_THRLD         1
#define CM_SYNC_THRESHOLD_SYNC          1
#define CM_SYNC_THRESHOLD_ASYNC         2


#define PRECISION                       200
#define OBERSERVE_WINDOW                200
#define MAX_OBSERVATION_WINDOW_NUM      FT+1


/*软硬件协同设置的不同状态下软件接收窗口*/
#define CM_SYNC_LISTEN_TIMEOUT          INTEGRATION_CYCLE_DURATION
#define CM_CA_LISTEN_TIMEOUT            4 * MAX_TRANSMISSION_DELAY
#define CM_WAIT4IN_LISTEN_TIMEOUT       4 * MAX_TRANSMISSION_DELAY
/*******************************************************CM Param************************************************************/


/*******************************************************SM Param************************************************************/
// 本地配置信息



// 超时参数
#define SM_LISTEN_TIMEOUT                      2 * INTEGRATION_CYCLE_DURATION
#define SM_COLDSTART_TIMEOUT                   5 * INTEGRATION_CYCLE_DURATION
#define SM_RESTART_TIMEOUT                     2 * INTEGRATION_CYCLE_DURATION
#define CS_OFFSET                              2 * MAX_TRANSMISSION_DELAY
#define CA_OFFSET                              2 * MAX_TRANSMISSION_DELAY
#define CA_ACCEPTANCE_WINDOW                   PI
#define CA_RECEIVE_TIMEOUT                     2 * INTEGRATION_CYCLE_DURATION


//阈值
#define SM_INTEGRATE_TO_SYNC_THRLD             1
#define SM_UNSYNC_TO_SYNC_THRLD                1
#define SM_UNSYNC_TO_TENTATIVE_THRLD           2
#define SM_TENTATIVE_SYNC_THRESHOLD_SYNC       1
#define SM_TENTATIVE_TO_SYNC_THRLD             1
#define SM_SYNC_THRESHOLD_SYNC                 1
#define NUM_STABLE_CYCLES                      8
#define NUM_UNSTABLE_CYCLES                    2
#define SM_STABLE_THRESHOLD_SYNC               1


#define SM_STATIC_DELAY                 800
#define CM_STATIC_DELAY                 800
/*******************************************************SM Param************************************************************/
#endif

#endif
