// Copyright (C) 1953-2022 NUDT
// Verilog module name - local_cnt_timing 
// Version: V3.4.0.20210226
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         global time synchronization 
//         generate report pulse base on global time
///////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module local_cnt_timing 
(
        i_clk,
        i_rst_n,

        ov_local_cnt
);
// clk & rst
input                  i_clk;
input                  i_rst_n;

output reg [63:0]      ov_local_cnt;            

always @(posedge i_clk or negedge i_rst_n) begin//local time rst 
    if(!i_rst_n)begin
        ov_local_cnt <= 64'b0;
    end
    else begin
        ov_local_cnt <= ov_local_cnt + 64'd8;
    end
end
endmodule