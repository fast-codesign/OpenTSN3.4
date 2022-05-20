// Copyright (C) 1953-2020 NUDT
// Verilog module name - clock_output_control
// Version: COC_V1.0.0_20211202
// Created:
//         by - fenglin 
//         at - 12.2021
////////////////////////////////////////////////////////////////////////////
// Description:
//         clock_output_control
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module sync_clock_control(
	i_sync_clk,
    i_sim_ctrl,           
	o_sync_clk
);
// I/O
//input

input                   i_sync_clk ;
input                   i_sim_ctrl ;
//output
output                  o_sync_clk ;


assign o_sync_clk = !i_sim_ctrl ? i_sync_clk:1'b0;
endmodule