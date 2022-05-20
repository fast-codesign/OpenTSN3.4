// Copyright (C) 1953-2022 NUDT
// Verilog module name - packet_statistics
// Version: V3.4.1.20220413
// Created:
//         by - fenglin 
//         at - 04.2022
////////////////////////////////////////////////////////////////////////////
// Description:
//         statistic pkt.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module packet_statistics
(
        i_clk,
        i_rst_n,
              
        iv_data,
        i_data_wr,
       
        ov_pkt_cnt  
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
//receive pkt
input      [7:0]       iv_data;
input                  i_data_wr;
//statistics 
output reg [31:0]      ov_pkt_cnt;
///////////////////delay 1 cycle///////////////
reg                    r_data_wr;
reg        [7:0]       rv_data;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)begin
        r_data_wr <= 1'b0;
        rv_data   <= 8'b0;        
    end
    else begin
        r_data_wr <= i_data_wr;
        rv_data   <= iv_data  ;
    end
end
///////////////////count//////////////////////
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)begin
        ov_pkt_cnt <= 32'b0;       
    end
    else begin
        if(!r_data_wr && i_data_wr)begin//first cycle.
            ov_pkt_cnt <= ov_pkt_cnt + 1'b1;
        end
        else begin 
            ov_pkt_cnt <= ov_pkt_cnt;
        end
    end
end
endmodule