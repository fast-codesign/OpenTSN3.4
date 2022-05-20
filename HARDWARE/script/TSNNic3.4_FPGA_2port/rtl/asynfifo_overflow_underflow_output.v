// Copyright (C) 1953-2020 NUDT
// Verilog module name - asynfifo_overflow_underflow_pulse
// Version: AOU.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         judge overflow and underflow of asynfifo.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module asynfifo_overflow_underflow_output
(
       i_clk,
       i_rst_n,
       
       i_fifo_overflow_pulse_host_rx,
       i_fifo_underflow_pulse_host_rx,
       i_fifo_underflow_pulse_p0_rx,
       i_fifo_overflow_pulse_p0_rx,
       i_fifo_underflow_pulse_p1_rx,
       i_fifo_overflow_pulse_p1_rx, 
       i_fifo_underflow_pulse_p2_rx,
       i_fifo_overflow_pulse_p2_rx, 
       i_fifo_underflow_pulse_p3_rx,
       i_fifo_overflow_pulse_p3_rx, 
  
 
       i_fifo_overflow_pulse_host_tx,
       i_fifo_overflow_pulse_p0_tx,
       i_fifo_overflow_pulse_p1_tx,
       i_fifo_overflow_pulse_p2_tx,
       i_fifo_overflow_pulse_p3_tx,

 
       o_asynfifo_rx_overflow_pulse, 
       o_asynfifo_rx_underflow_pulse,
       o_asynfifo_tx_overflow_pulse 
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n; 
//port type
input                  i_fifo_overflow_pulse_host_rx;
input                  i_fifo_underflow_pulse_host_rx;
input                  i_fifo_underflow_pulse_p0_rx;
input                  i_fifo_overflow_pulse_p0_rx; 
input                  i_fifo_underflow_pulse_p1_rx;
input                  i_fifo_overflow_pulse_p1_rx; 
input                  i_fifo_underflow_pulse_p2_rx;
input                  i_fifo_overflow_pulse_p2_rx; 
input                  i_fifo_underflow_pulse_p3_rx;
input                  i_fifo_overflow_pulse_p3_rx; 
 

input                  i_fifo_overflow_pulse_host_tx;
input                  i_fifo_overflow_pulse_p0_tx;
input                  i_fifo_overflow_pulse_p1_tx;
input                  i_fifo_overflow_pulse_p2_tx;
input                  i_fifo_overflow_pulse_p3_tx;


output                 o_asynfifo_rx_overflow_pulse; 
output                 o_asynfifo_rx_underflow_pulse;
output                 o_asynfifo_tx_overflow_pulse;  

wire                   w_fifo_overflow_pulse_host_rx;
wire                   w_fifo_overflow_pulse_p0_rx; 
wire                   w_fifo_overflow_pulse_p1_rx; 
wire                   w_fifo_overflow_pulse_p2_rx; 
wire                   w_fifo_overflow_pulse_p3_rx; 
 

assign w_asynfifo_rx_overflow_pulse = w_fifo_overflow_pulse_host_rx || w_fifo_overflow_pulse_p0_rx || w_fifo_overflow_pulse_p1_rx || w_fifo_overflow_pulse_p2_rx ||w_fifo_overflow_pulse_p3_rx ;
assign w_asynfifo_rx_underflow_pulse = i_fifo_underflow_pulse_host_rx || i_fifo_underflow_pulse_p0_rx || i_fifo_underflow_pulse_p1_rx || i_fifo_underflow_pulse_p2_rx ||i_fifo_underflow_pulse_p3_rx ;
assign w_asynfifo_tx_overflow_pulse = i_fifo_overflow_pulse_host_tx || i_fifo_overflow_pulse_p0_tx || i_fifo_overflow_pulse_p1_tx || i_fifo_overflow_pulse_p2_tx ||i_fifo_overflow_pulse_p3_tx ;

led_on_time asynfifo_rx_overflow_pulse_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

.i_pulse(w_asynfifo_rx_overflow_pulse),
.o_led(o_asynfifo_rx_overflow_pulse) 
);

led_on_time asynfifo_rx_underflow_pulse_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

.i_pulse(w_asynfifo_rx_underflow_pulse),
.o_led(o_asynfifo_rx_underflow_pulse) 
);

led_on_time asynfifo_tx_overflow_pulse_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

.i_pulse(w_asynfifo_tx_overflow_pulse),
.o_led(o_asynfifo_tx_overflow_pulse) 
);

signal_sync host_rx_overflow_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
       
.i_signal_async(i_fifo_overflow_pulse_host_rx),
.o_signal_sync(w_fifo_overflow_pulse_host_rx) 
);


signal_sync p0_rx_overflow_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
       
.i_signal_async(i_fifo_overflow_pulse_p0_rx),
.o_signal_sync(w_fifo_overflow_pulse_p0_rx) 
);

signal_sync p1_rx_overflow_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
       
.i_signal_async(i_fifo_overflow_pulse_p1_rx),
.o_signal_sync(w_fifo_overflow_pulse_p1_rx) 
);

signal_sync p2_rx_overflow_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
       
.i_signal_async(i_fifo_overflow_pulse_p2_rx),
.o_signal_sync(w_fifo_overflow_pulse_p2_rx) 
);

signal_sync p3_rx_overflow_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
       
.i_signal_async(i_fifo_overflow_pulse_p3_rx),
.o_signal_sync(w_fifo_overflow_pulse_p3_rx) 
);

endmodule