// Copyright (C) 1953-2020 NUDT
// Verilog module name - reset_sync
// Version: RSS_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         Synchronize reset signal.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module reset_sync
(
       i_clk,
       i_rst_n,
       
       o_rst_n_sync   
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n; 

output reg             o_rst_n_sync; 

reg rv_rst_n;

always@(posedge i_clk or negedge i_rst_n) begin
  if (!i_rst_n) begin
    rv_rst_n <= 1'b0;
  end
  else begin
    rv_rst_n <= 1'b1;
  end
end

always@(posedge i_clk or negedge i_rst_n) begin
  if (!i_rst_n) begin
    o_rst_n_sync <= 1'b0;
  end
  else begin
    o_rst_n_sync <= rv_rst_n;
  end
end

endmodule