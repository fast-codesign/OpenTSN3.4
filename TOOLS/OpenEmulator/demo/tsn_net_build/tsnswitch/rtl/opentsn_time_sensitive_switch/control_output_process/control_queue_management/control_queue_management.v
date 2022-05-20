// Copyright (C) 1953-2021 NUDT
// Verilog module name - control_queue_management 
// Version: V3.2.0.20210722
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         cache bufid of not ts packet with fifo.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module control_queue_management
(
        i_clk,
        i_rst_n,
        
        iv_pkt_type_ctrl,
	    iv_pkt_bufid_ctrl,
        i_mac_entry_hit_ctrl,
        iv_pkt_inport_ctrl,
        i_pkt_bufid_wr_ctrl,
       
        ov_descriptor,
        o_descriptor_wr,
        i_descriptor_ready
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;  
//tsntag & bufid input from host_port
input          [2:0]   iv_pkt_type_ctrl;
input          [8:0]   iv_pkt_bufid_ctrl;
input                  i_mac_entry_hit_ctrl;
input          [3:0]   iv_pkt_inport_ctrl;
input                  i_pkt_bufid_wr_ctrl;
//tsntag & bufid output
output         [13:0]  ov_descriptor;
output                 o_descriptor_wr;
input                  i_descriptor_ready;

wire           [13:0]  wv_fifo_wdata;
wire                   w_fifo_wr;
wire                   w_fifo_empty;
wire                   w_fifo_rd;
wire           [13:0]  wv_fifo_rdata;
control_input_queue control_input_queue_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

.iv_pkt_type_ctrl      (iv_pkt_type_ctrl    ),
.iv_pkt_bufid_ctrl     (iv_pkt_bufid_ctrl   ),
.i_mac_entry_hit_ctrl  (i_mac_entry_hit_ctrl),
.iv_pkt_inport_ctrl    (iv_pkt_inport_ctrl  ),
.i_pkt_bufid_wr_ctrl   (i_pkt_bufid_wr_ctrl ),

.ov_fifo_wdata         (wv_fifo_wdata),
.o_fifo_wr             (w_fifo_wr)
);
fifo_w14d16 fifo_w14d16_inst(
    .aclr(!i_rst_n),                   //Reset the all signal
    .data(wv_fifo_wdata),    //The Inport of data 
    .rdreq(w_fifo_rd),       //active-high
    .clock(i_clk),                       //ASYNC WriteClk(), SYNC use wrclk
    .wrreq(w_fifo_wr),       //active-high
    .q(wv_fifo_rdata),       //The output of data
    .empty(w_fifo_empty),            //Read domain empty
    .full(),                        //Write-usedword
    .usedw()                         //Read-usedword
);
control_output_queue control_output_queue_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

.i_fifo_empty(w_fifo_empty),
.o_fifo_rd(w_fifo_rd),
.iv_fifo_rdata(wv_fifo_rdata),

.ov_descriptor(ov_descriptor),
.o_descriptor_wr(o_descriptor_wr),
.i_descriptor_ready(i_descriptor_ready)
);
endmodule