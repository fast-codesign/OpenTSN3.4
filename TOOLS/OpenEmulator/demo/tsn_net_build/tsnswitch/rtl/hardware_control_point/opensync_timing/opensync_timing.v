// Copyright (C) 1953-2022 NUDT
// Verilog module name - opensync_timing 
// Version: V3.4.0.20220226
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         global time synchronization 
//         generate report pulse base on global time
///////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module opensync_timing 
(

        i_clk,
        i_rst_n,
       
        i_stc_wr         ,      
        iv_stc_wdata     ,      
        iv_stc_addr      ,
        i_stc_addr_fixed ,        
        i_stc_rd         ,      
              
        o_stc_wr         ,       
        ov_stc_rdata     ,        
        ov_stc_raddr     ,
        o_stc_addr_fixed ,        
        
        i_tsn_or_tte     ,
        //iv_time_slot_length    ,
        //iv_schedule_period     ,
        ov_syn_clock_cycle     ,
        //o_schedule_period_pulse,
        ov_os_cid        ,
       
        ov_syn_clk,
        ov_local_cnt
);
// clk & rst
input                  i_clk;
input                  i_rst_n;

input                  i_stc_wr;
input      [31:0]      iv_stc_wdata;
input      [18:0]      iv_stc_addr; 
input                  i_stc_addr_fixed;      
input                  i_stc_rd;

output                 o_stc_wr; 
output     [31:0]      ov_stc_rdata;  
output     [18:0]      ov_stc_raddr;
output                 o_stc_addr_fixed; 

input                  i_tsn_or_tte;
//input      [10:0]      iv_schedule_period       ; 
//input      [10:0]      iv_time_slot_length      ; 
output     [31:0]      ov_syn_clock_cycle       ;
//output                 o_schedule_period_pulse  ;           // 1024 ms / 1.024ms pluse
output     [11:0]      ov_os_cid                ;
 
output     [63:0]      ov_syn_clk;               // have syned global time 
output     [63:0]      ov_local_cnt;         // count reset pluse

wire       [63:0]      wv_syn_clock_set_cpe2scc      ;
wire       [31:0]      wv_reference_pit_cpe2scc      ;
wire                   w_syn_clock_set_wr_cpe2scc    ;
wire       [31:0]      wv_phase_cor_cpe2scc          ;
wire                   w_phase_cor_wr_cpe2scc        ;
wire       [31:0]      wv_frequency_cor_cpe2scc      ;
wire                   w_frequency_cor_wr_cpe2scc    ;
command_parse_and_encapsulate_ost command_parse_and_encapsulate_ost_inst
(
.i_clk                 (i_clk),
.i_rst_n               (i_rst_n),

.i_tsn_or_tte          (i_tsn_or_tte),
                       
.i_stc_wr              (i_stc_wr),
.iv_stc_wdata          (iv_stc_wdata),
.iv_stc_addr           (iv_stc_addr),
.i_stc_addr_fixed      (i_stc_addr_fixed),       
.i_stc_rd              (i_stc_rd),
                       
.o_stc_wr              (o_stc_wr), 
.ov_stc_rdata          (ov_stc_rdata),
.ov_stc_raddr          (ov_stc_raddr),
.o_stc_addr_fixed      (o_stc_addr_fixed),

.ov_os_cid              (ov_os_cid                     ),                       
.ov_syn_clock_set       (wv_syn_clock_set_cpe2scc      ),
.ov_reference_pit       (wv_reference_pit_cpe2scc      ),
.o_syn_clock_set_wr     (w_syn_clock_set_wr_cpe2scc    ),
.ov_syn_clock_cycle     (ov_syn_clock_cycle            ),
.ov_phase_cor           (wv_phase_cor_cpe2scc          ),
.o_phase_cor_wr         (w_phase_cor_wr_cpe2scc        ),
.ov_frequency_cor       (wv_frequency_cor_cpe2scc      ),
.o_frequency_cor_wr     (w_frequency_cor_wr_cpe2scc    )
);
clock_timing_and_correcting  clock_timing_and_correcting_inst
(
.i_clk                  (i_clk),
.i_rst_n                (i_rst_n),

.i_tsn_or_tte           (i_tsn_or_tte),

.iv_syn_clock_set       (wv_syn_clock_set_cpe2scc      ),
.iv_reference_pit       (wv_reference_pit_cpe2scc      ),
.i_syn_clock_set_wr     (w_syn_clock_set_wr_cpe2scc    ),
.iv_syn_clock_cycle     (ov_syn_clock_cycle            ),
.iv_phase_cor           (wv_phase_cor_cpe2scc          ),
.i_phase_cor_wr         (w_phase_cor_wr_cpe2scc        ),
.iv_frequency_cor       (wv_frequency_cor_cpe2scc      ),
.i_frequency_cor_wr     (w_frequency_cor_wr_cpe2scc    ),

.ov_syn_clk             (ov_syn_clk)
);
/*
sync_pulse_generate sync_pulse_generate_inst
( 
.i_clk                  (i_clk),
.i_rst_n                (i_rst_n),

.iv_time_slot_length    (iv_time_slot_length),
.iv_schedule_period     (iv_schedule_period),     
.iv_syn_clk             (ov_syn_clk),

.o_schedule_period_pulse(o_schedule_period_pulse)
);
*/
local_cnt_timing local_cnt_timing_inst 
(
.i_clk               (i_clk),
.i_rst_n             (i_rst_n),

.ov_local_cnt       (ov_local_cnt)
);
endmodule