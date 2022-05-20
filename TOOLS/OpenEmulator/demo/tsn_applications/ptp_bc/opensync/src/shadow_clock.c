#include "../include/opensync.h"


void init_shadow_clock(shadow_clock* sc)
{
    sc->local_clock_tv = 0;
    sc->local_counter_tv = 0;
    sc->sys_time = 0;
}


void update_shadow_clock(u64 local_clock, u32 local_counter, shadow_clock* sc)
{
    sc->local_clock_tv = local_clock;
    sc->local_counter_tv = local_counter;
    sc->sys_time = get_cur_nano_sec();
}

unsigned int get_local_counter_tv(shadow_clock* sc)
{
    u64 cur_time = get_cur_nano_sec();
    u64 diff = cur_time - sc->sys_time;
    return sc->local_counter_tv + diff;
}

unsigned long get_local_clock_tv(shadow_clock* sc)
{
    u64 cur_time = get_cur_nano_sec();
    u64 diff = cur_time - sc->sys_time;
    return sc->local_clock_tv + diff;
}