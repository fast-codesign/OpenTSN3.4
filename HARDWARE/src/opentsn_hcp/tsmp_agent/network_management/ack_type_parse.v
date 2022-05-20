// Copyright (C) 1953-2021 NUDT
// Verilog module name - ack_type_parse 
// Version: V3.3.0.20211123
// Created:
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         parse command ack type
///////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module ack_type_parse
(
       i_clk,
       i_rst_n,

       iv_command_ack,
       i_command_ack_wr,
       
       ov_rd_command_ack,
	   o_rd_command_ack_wr
);


// I/O
// i_clk & rst
input                  i_clk;
input                  i_rst_n;
       
//nmac data
input      [65:0]      iv_command_ack;             
input                  i_command_ack_wr;             

output reg [63:0]	   ov_rd_command_ack;
output reg	           o_rd_command_ack_wr;
//***************************************************
//               command ack type
//***************************************************
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_rd_command_ack   <= 64'b0;
        o_rd_command_ack_wr <= 1'b0;
    end
    else begin
        if(i_command_ack_wr && (iv_command_ack[65:64] == 2'b11))begin
            ov_rd_command_ack   <= iv_command_ack[63:0];
            o_rd_command_ack_wr <= 1'b1;
        end
        else begin
            ov_rd_command_ack   <= 64'b0;
            o_rd_command_ack_wr <= 1'b0;        
        end
    end
end    

endmodule
    