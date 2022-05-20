// Copyright (C) 1953-2020 NUDT
// Verilog module name - ts_injection_schedule 
// Version: TIS_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         injection schedule of time-sensitive packet
//             - parse command;
//             - use a true dual port ram to cache injection slot table; 
//             - schedule descriptor of time-sensitive packet according to injection slot table;
//             - top module.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module ts_injection_schedule
(
       i_clk,
       i_rst_n,
       iv_hardware_stage,       
       iv_syn_clk,
       iv_time_slot_length,
       
       i_ts_injection_addr_ack,
       ov_ts_injection_addr,
       o_ts_injection_addr_wr,

       iv_injection_slot_table_wdata,       
       i_injection_slot_table_wr,       
       iv_injection_slot_table_addr,       
       ov_injection_slot_table_rdata,       
       i_injection_slot_table_rd,       
       ism_state,
       iv_injection_slot_table_period       
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;
//configuration finish and time synchronization finish
input      [2:0]       iv_hardware_stage; 
// calculation of time slot
input      [63:0]      iv_syn_clk;      
input      [10:0]      iv_time_slot_length;    // measure:us

// result of schedule
output     [4:0]       ov_ts_injection_addr;
output                 o_ts_injection_addr_wr;
input                  i_ts_injection_addr_ack; 
input      [15:0]      iv_injection_slot_table_wdata;
input                  i_injection_slot_table_wr;
input      [9:0]       iv_injection_slot_table_addr;
output     [15:0]      ov_injection_slot_table_rdata;
input                  i_injection_slot_table_rd;
output     [2:0]       ism_state; 

input      [10:0]      iv_injection_slot_table_period;

wire       [9:0]       wv_time_slot;
wire                   w_time_slot_switch;



time_slot_calculation injection_time_calculation_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

.iv_syn_clk         (iv_syn_clk),
.iv_time_slot_length(iv_time_slot_length),

.iv_slot_period     (iv_injection_slot_table_period),

.ov_time_slot       (wv_time_slot),
.o_time_slot_switch (w_time_slot_switch)
);

injection_schedule_module injection_schedule_module_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.iv_hardware_stage  (iv_hardware_stage),
.iv_time_slot       (wv_time_slot),
.i_time_slot_switch (w_time_slot_switch),

.iv_injection_slot_table_wdata(iv_injection_slot_table_wdata),
.i_injection_slot_table_wr    (i_injection_slot_table_wr),
.iv_injection_slot_table_addr (iv_injection_slot_table_addr),
.ov_injection_slot_table_rdata(ov_injection_slot_table_rdata),
.i_injection_slot_table_rd    (i_injection_slot_table_rd),

.i_ts_injection_addr_ack(i_ts_injection_addr_ack),
.ov_ts_injection_addr   (ov_ts_injection_addr),
.o_ts_injection_addr_wr (o_ts_injection_addr_wr),

.ism_state(ism_state)  
);
endmodule