// Copyright (C) 1953-2020 NUDT
// Verilog module name - ts_clock_control
// Version: COC_V1.0.0_20211202
// Created:
//         by - fenglin 
//         at - 12.2021
////////////////////////////////////////////////////////////////////////////
// Description:
//         ts_clock_control
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module ts_clock_control(
    i_clk,
    i_rst_n, 
	i_sync_clk,
    o_sync_time_wr,
    ov_sync_time
);
// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
input                   i_sync_clk;
//output
output reg [47:0]       ov_sync_time ;
output reg              o_sync_time_wr ;

reg [31:0] time_cnt;
reg [47:0] rv_local_time;

always@(posedge i_sync_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        rv_local_time   <= 48'b0;
    end
    else begin
        rv_local_time <= rv_local_time + 48'd8;  
    end
end

always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        ov_sync_time   <= 48'b0;
        o_sync_time_wr <= 1'b0;
        time_cnt         <= 32'b0;
    end
    else begin
        ov_sync_time<= rv_local_time;  
        if(time_cnt==32'h2710)begin //10us
            o_sync_time_wr <= 1'b1;
            time_cnt         <= 32'b0;
        end
        else begin
            time_cnt         <= time_cnt + 32'd8;
            o_sync_time_wr <= 1'b0;
        end
    end
end
endmodule