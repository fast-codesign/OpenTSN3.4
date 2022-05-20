// Copyright (C) 1953-2022 NUDT
// Verilog module name - command_parse_and_encapsulate
// Version: V3.4.0.20220224
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module command_parse_and_encapsulate_ffi
(
        i_clk,
        i_rst_n,
        
        iv_addr,                         
        i_addr_fixed,                   
        iv_wdata,                        
        i_wr_irx,         
        i_rd_irx,         
        
        o_wr_irx,          
        ov_addr_irx,       
        o_addr_fixed_irx,  
        ov_rdata_irx,

        iv_pkt_cnt_fts2cpe        
);

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;

input       [18:0]      iv_addr;                         
input                   i_addr_fixed;                   
input       [31:0]      iv_wdata;                        
input                   i_wr_irx;         
input                   i_rd_irx;         

output reg              o_wr_irx;          
output reg [18:0]       ov_addr_irx;       
output reg              o_addr_fixed_irx;  
output reg [31:0]       ov_rdata_irx;

input      [31:0]       iv_pkt_cnt_fts2cpe;
            
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        o_wr_irx           <= 1'b0;
        ov_addr_irx        <= 19'b0;
        o_addr_fixed_irx   <= 1'b0;
        ov_rdata_irx       <= 32'b0;
    end
    else begin
        if(i_wr_irx)begin//write
            o_wr_irx           <= 1'b0;
            ov_addr_irx        <= 19'b0;
            o_addr_fixed_irx   <= 1'b0;
            ov_rdata_irx       <= 32'b0;
        end
        else if(i_rd_irx)begin//read
            if(i_addr_fixed && (iv_addr == 19'b0))begin
                o_wr_irx           <= 1'b1;
                ov_addr_irx        <= iv_addr;
                o_addr_fixed_irx   <= i_addr_fixed;
                ov_rdata_irx       <= iv_pkt_cnt_fts2cpe;
            end
            else begin
                o_wr_irx           <= 1'b0;
                ov_addr_irx        <= 19'b0;
                o_addr_fixed_irx   <= 1'b0;
                ov_rdata_irx       <= 32'b0;            
            end
        end
        else begin
            o_wr_irx           <= 1'b0;
            ov_addr_irx        <= 19'b0;
            o_addr_fixed_irx   <= 1'b0;
            ov_rdata_irx       <= 32'b0;
        end        
    end
end       
endmodule