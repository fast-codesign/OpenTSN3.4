// Copyright (C) 1953-2022 NUDT
// Verilog module name - command_parse_and_encapsulate_cfu
// Version: V3.4.0.20220224
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module command_parse_and_encapsulate_cfu
(
        i_clk,
        i_rst_n,
        
        iv_addr,                         
        i_addr_fixed,                   
        iv_wdata,                        
        i_wr,         
        i_rd,         
        
        o_wr,          
        ov_addr,       
        o_addr_fixed,  
        ov_rdata,

        o_tsn_or_tte        
);

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;

input       [18:0]      iv_addr;                         
input                   i_addr_fixed;                   
input       [31:0]      iv_wdata;                        
input                   i_wr;         
input                   i_rd;         

output reg              o_wr;          
output reg [18:0]       ov_addr;       
output reg              o_addr_fixed;  
output reg [31:0]       ov_rdata;

output reg              o_tsn_or_tte;
            
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        o_wr           <= 1'b0;
        ov_addr        <= 19'b0;
        o_addr_fixed   <= 1'b0;
        ov_rdata       <= 32'b0;
        
        o_tsn_or_tte      <= 1'b0;//tte
    end
    else begin
        if(i_wr)begin//write
            o_wr           <= 1'b0;
            ov_addr        <= 19'b0;
            o_addr_fixed   <= 1'b0;
            ov_rdata       <= 32'b0;
            if(i_addr_fixed && (iv_addr == 19'b0))begin//tsn_or_tte
                o_tsn_or_tte   <= iv_wdata[0];
            end
            else begin
                o_tsn_or_tte   <= o_tsn_or_tte;
            end
        end
        else if(i_rd)begin//read
            if(i_addr_fixed && (iv_addr == 19'b0))begin//tsn_or_tte        
                o_wr           <= 1'b1;
                ov_addr        <= iv_addr;
                o_addr_fixed   <= i_addr_fixed;
                ov_rdata       <= {31'b0,o_tsn_or_tte};
            end
            else begin
                o_wr           <= 1'b0;
                ov_addr        <= 19'b0;
                o_addr_fixed   <= 1'b0;
                ov_rdata       <= 32'b0;            
            end
        end
        else begin
            o_wr         <= 1'b0;
            ov_addr      <= 19'b0;
            o_addr_fixed <= 1'b0;
            ov_rdata     <= 32'b0;
        end        
    end
end       
endmodule