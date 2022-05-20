// Copyright (C) 1953-2020 NUDT
// Verilog module name - chip_clock_control
// Version: COC_V1.0.0_20220110
// Created:
//         by - fenglin 
//         at - 1.2022
////////////////////////////////////////////////////////////////////////////
// Description:
//         chip_clock_control
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module chip_clock_control(
	i_clk0,
	i_clk1,
	i_clk2,
	i_clk3,
	i_clk4,
	i_clk5,    
    i_sim_ctrl,
	o_clk0,
	o_clk1,	
	o_clk2,
	o_clk3,
	o_clk4,	
	o_clk5    
);
// I/O
//input

input                   i_clk0 ;
input                   i_clk1 ;
input                   i_clk2 ;
input                   i_clk3 ;
input                   i_clk4 ;
input                   i_clk5 ;
input                   i_sim_ctrl ;
//output
output                  o_clk0 ;
output                  o_clk1 ;
output                  o_clk2 ;
output                  o_clk3 ;
output                  o_clk4 ;
output                  o_clk5 ;

assign o_clk0 = !i_sim_ctrl ? i_clk0:1'b0;
assign o_clk1 = !i_sim_ctrl ? i_clk1:1'b0;
assign o_clk2 = !i_sim_ctrl ? i_clk2:1'b0;
assign o_clk3 = !i_sim_ctrl ? i_clk3:1'b0;
assign o_clk4 = !i_sim_ctrl ? i_clk4:1'b0;
assign o_clk5 = !i_sim_ctrl ? i_clk5:1'b0;
endmodule