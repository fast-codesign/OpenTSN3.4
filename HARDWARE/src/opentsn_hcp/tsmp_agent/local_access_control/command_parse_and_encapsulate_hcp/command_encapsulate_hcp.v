// Copyright (C) 1953-2022 NUDT
// Verilog module name - command_encapsulate_hcp 
// Version: V3.4.0.20220228
// Created:
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module command_encapsulate_hcp
(
        i_clk,
        i_rst_n,   
       
        i_hrg_wr,
        iv_hrg_raddr,
        i_hrg_addr_fix,
        iv_hrg_rdata,
        
        i_ost_wr,
        iv_ost_raddr,
        i_ost_addr_fix,
        iv_ost_rdata,

        i_tft_wr,
        iv_tft_raddr,
        i_tft_addr_fix,
        iv_tft_rdata,
        
        i_cc_wr,
        iv_cc_raddr,
        i_cc_addr_fix,
        iv_cc_rdata,        

        i_osm_wr,
        iv_osm_raddr,
        i_osm_addr_fix,
        iv_osm_rdata,        
      
        ov_command,
	    o_command_wr              
);
// I/O
// i_clk & rst
input                  i_clk;
input                  i_rst_n;    

input                  i_hrg_wr;
input      [18:0]      iv_hrg_raddr;
input                  i_hrg_addr_fix;
input      [31:0]      iv_hrg_rdata;

input                  i_ost_wr;
input      [18:0]      iv_ost_raddr;
input                  i_ost_addr_fix;
input      [31:0]      iv_ost_rdata;

input                  i_tft_wr;
input      [18:0]      iv_tft_raddr;
input                  i_tft_addr_fix;
input      [31:0]      iv_tft_rdata;

input                  i_cc_wr;
input      [18:0]      iv_cc_raddr;
input                  i_cc_addr_fix;
input      [31:0]      iv_cc_rdata;

input                  i_osm_wr;
input      [18:0]      iv_osm_raddr;
input                  i_osm_addr_fix;
input      [31:0]      iv_osm_rdata;

output reg [63:0]      ov_command;              
output reg             o_command_wr;      
//***************************************************
//               command generate
//***************************************************
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_command         <= 64'b0;
        o_command_wr       <= 1'b0;     
    end
    else begin
        if(i_hrg_wr)begin
            ov_command[31:0]    <= iv_hrg_rdata;
            ov_command[50:32]   <= iv_hrg_raddr;
            ov_command[57:51]   <= 7'd0;
            ov_command[60:58]   <= 3'd0;
            ov_command[61]      <= i_hrg_addr_fix;
            ov_command[63:62]   <= 2'b11;            
            o_command_wr        <= 1'b1;             
        end
        else if(i_ost_wr)begin
            ov_command[31:0]    <= iv_ost_rdata;
            ov_command[50:32]   <= iv_ost_raddr;
            ov_command[57:51]   <= 7'd1;
            ov_command[60:58]   <= 3'd0;
            ov_command[61]      <= i_ost_addr_fix;
            ov_command[63:62]   <= 2'b11;            
            o_command_wr        <= 1'b1;             
        end
        else if(i_cc_wr)begin
            ov_command[31:0]    <= iv_cc_rdata;
            ov_command[50:32]   <= iv_cc_raddr;
            ov_command[57:51]   <= 7'd2;
            ov_command[60:58]   <= 3'd0;
            ov_command[61]      <= i_cc_addr_fix;
            ov_command[63:62]   <= 2'b11;            
            o_command_wr        <= 1'b1;             
        end        
        else if(i_tft_wr)begin
            ov_command[31:0]    <= iv_tft_rdata;
            ov_command[50:32]   <= iv_tft_raddr;
            ov_command[57:51]   <= 7'd3;
            ov_command[60:58]   <= 3'd0;
            ov_command[61]      <= i_tft_addr_fix;
            ov_command[63:62]   <= 2'b11;            
            o_command_wr        <= 1'b1;             
        end
        else if(i_osm_wr)begin
            ov_command[31:0]    <= iv_osm_rdata;
            ov_command[50:32]   <= iv_osm_raddr;
            ov_command[57:51]   <= 7'd4;
            ov_command[60:58]   <= 3'd0;
            ov_command[61]      <= i_osm_addr_fix;
            ov_command[63:62]   <= 2'b11;            
            o_command_wr        <= 1'b1;             
        end        
        else begin
            ov_command         <= 62'b0;
            o_command_wr       <= 1'b0;        
        end
    end
end    
endmodule
    