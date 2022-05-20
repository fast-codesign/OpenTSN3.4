// Copyright (C) 1953-2020 NUDT
// Verilog module name - reset_glitch
// Version: RSG_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         reset glitch.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module reset_glitch
(
       i_clk,
       i_rst_n,
       
       o_rst_n_glitch   
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n; 

output reg             o_rst_n_glitch; 

reg [13:0] rstn_reg;
always @ (posedge i_clk) begin
  rstn_reg <= {rstn_reg[12:0],i_rst_n};
  o_rst_n_glitch <= |rstn_reg[13:0];
end
endmodule