// Copyright (C) 1953-2021 NUDT
// Verilog module name - descriptor_select 
// Version: V3.2.0.20210727
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         control bufid and tsntag  to input queue
//              
//             
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module descriptor_output
(
        i_clk,
        i_rst_n,
        
        
        iv_ts_descriptor,   
        i_ts_descriptor_wr, 
        o_ts_descriptor_ack,
        iv_nts_descriptor  ,
        i_nts_descriptor_wr,
        
        ov_descriptor    ,  
        o_descriptor_wr    ,
        i_descriptor_ack  
    );
// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
//input
//tsntag & bufid output 
input       [39:0]      iv_ts_descriptor;
input                   i_ts_descriptor_wr;
input       [39:0]      iv_nts_descriptor;
input                   i_nts_descriptor_wr;

output reg              o_ts_descriptor_ack;
output reg  [39:0]      ov_descriptor;
output reg              o_descriptor_wr;
input                   i_descriptor_ack;
//***************************************************
//          control bufid to input queue 
//***************************************************

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin   
        ov_descriptor <= 40'b0;
        o_descriptor_wr <= 1'b0;
    end
    else begin
        if(i_ts_descriptor_wr == 1'b1)begin
            o_ts_descriptor_ack <= 1'b1;
            ov_descriptor       <= iv_ts_descriptor;
            o_descriptor_wr     <= 1'b1;
                        
        end
        else if(i_nts_descriptor_wr == 1'b1)begin
            ov_descriptor <= iv_nts_descriptor;
            o_descriptor_wr <= 1'b1;                       
        end
        else begin  
            ov_descriptor <= 40'b0;
            o_descriptor_wr <= 1'b0;
        end
    end
end
endmodule