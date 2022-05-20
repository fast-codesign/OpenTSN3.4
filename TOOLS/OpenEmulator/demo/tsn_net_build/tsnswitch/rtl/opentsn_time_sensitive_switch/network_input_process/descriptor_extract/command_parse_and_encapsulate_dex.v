// Copyright (C) 1953-2021 NUDT
// Verilog module name - command_parse_and_encapsulate_dex
// Version: V3.4.0.20220225
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module command_parse_and_encapsulate_dex
(
        i_clk,
        i_rst_n,
        
        iv_addr,                         
        i_addr_fixed,                   
        iv_wdata,                        
        i_wr_dex,         
        i_rd_dex,         
        
        o_wr_dex,          
        ov_addr_dex,       
        o_addr_fixed_dex,  
        ov_rdata_dex 
);

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;

input       [18:0]      iv_addr;                         
input                   i_addr_fixed;                   
input       [31:0]      iv_wdata;                        
input                   i_wr_dex;         
input                   i_rd_dex;         

output reg              o_wr_dex;          
output reg [18:0]       ov_addr_dex;       
output reg              o_addr_fixed_dex;  
output reg [31:0]       ov_rdata_dex;
            
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        o_wr_dex           <= 1'b0;
        ov_addr_dex        <= 19'b0;
        o_addr_fixed_dex   <= 1'b0;
        ov_rdata_dex       <= 32'b0;
    end
    else begin
        if(i_wr_dex)begin//write
            o_wr_dex           <= 1'b0;
            ov_addr_dex        <= 19'b0;
            o_addr_fixed_dex   <= 1'b0;
            ov_rdata_dex       <= 32'b0;
        end
        else if(i_rd_dex)begin//read
            o_wr_dex           <= 1'b0;
            ov_addr_dex        <= 19'b0;
            o_addr_fixed_dex   <= 1'b0;
            ov_rdata_dex       <= 32'b0;
        end
        else begin
            o_wr_dex         <= 1'b0;
            ov_addr_dex      <= 19'b0;
            o_addr_fixed_dex <= 1'b0;
            ov_rdata_dex     <= 32'b0;
        end        
    end
end       
endmodule