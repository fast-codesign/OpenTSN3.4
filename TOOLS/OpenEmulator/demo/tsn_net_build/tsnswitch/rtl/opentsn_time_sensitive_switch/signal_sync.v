// Copyright (C) 1953-2020 NUDT
// Verilog module name - signal_sync
// Version: signal_sync_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         Synchronize signal in the clock domain.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module signal_sync
(
       i_clk,
       i_rst_n,
       
       i_signal_async,
       o_signal_sync   
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n; 
//port type
input                  i_signal_async;  
output reg             o_signal_sync; 


reg r_signal_1;
reg r_signal_2;
reg r_signal_3;

always@(posedge i_clk or negedge i_rst_n) begin
  if (!i_rst_n) begin
    r_signal_1 <= 1'b0;
    r_signal_2 <= 1'b0;
    r_signal_3 <= 1'b0;
    o_signal_sync <= 1'b0;
  end
  else begin
    r_signal_1 <= i_signal_async;
    r_signal_2 <= r_signal_1;
    r_signal_3 <= r_signal_2;
    o_signal_sync <= r_signal_3;
  end
end
endmodule