// Copyright (C) 1953-2020 NUDT
// Verilog module name - host_queue_management 
// Version: HQM_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         cache bufid of not ts packet with fifo.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module host_queue_management
(
        i_clk,
        i_rst_n,
        
        iv_tsntag_hcp,
        iv_bufid_hcp,
		i_inverse_map_lookup_flag_hcp,///
        i_descriptor_wr_hcp,
        o_descriptor_ack_hcp,
        
        iv_tsntag_network,
        iv_bufid_network,
        i_inverse_map_lookup_flag_network,
        i_descriptor_wr_network,
        o_descriptor_ack_network,
       
        ov_descriptor,
        o_descriptor_wr,
        i_descriptor_ready
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;  
//tsntag & bufid input from host_port
input          [47:0]  iv_tsntag_hcp;
input          [8:0]   iv_bufid_hcp;
input                  i_inverse_map_lookup_flag_hcp;
input                  i_descriptor_wr_hcp;
output                 o_descriptor_ack_hcp;
//tsntag & bufid input from hcp_port
input          [47:0]  iv_tsntag_network;
input          [8:0]   iv_bufid_network;
input                  i_inverse_map_lookup_flag_network;
input                  i_descriptor_wr_network;
output                 o_descriptor_ack_network;
//tsntag & bufid output
output         [21:0]  ov_descriptor;
output                 o_descriptor_wr;
input                  i_descriptor_ready;

wire           [21:0]  wv_fifo_wdata;
wire                   w_fifo_wr;
wire                   w_fifo_empty;
wire                   w_fifo_rd;
wire           [21:0]  wv_fifo_rdata;
host_input_queue host_input_queue_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

.iv_tsntag_hcp(iv_tsntag_hcp),
.iv_bufid_hcp(iv_bufid_hcp),
.i_inverse_map_lookup_flag_hcp(i_inverse_map_lookup_flag_hcp),///
.i_descriptor_wr_hcp(i_descriptor_wr_hcp),
.o_descriptor_ack_hcp(o_descriptor_ack_hcp),

.iv_tsntag_network(iv_tsntag_network),
.iv_bufid_network(iv_bufid_network),
.i_inverse_map_lookup_flag_network(i_inverse_map_lookup_flag_network),
.i_descriptor_wr_network(i_descriptor_wr_network),
.o_descriptor_ack_network(o_descriptor_ack_network),

.ov_fifo_wdata(wv_fifo_wdata),
.o_fifo_wr(w_fifo_wr)
);
SFIFO_22_16 SFIFO_22_16_inst(
    .aclr(!i_rst_n),                   //Reset the all signal
    .data(wv_fifo_wdata),    //The Inport of data 
    .rdreq(w_fifo_rd),       //active-high
    .clk(i_clk),                       //ASYNC WriteClk(), SYNC use wrclk
    .wrreq(w_fifo_wr),       //active-high
    .q(wv_fifo_rdata),       //The output of data
    .wrfull(),              //Write domain full 
    .wralfull(),                       //Write domain almost-full
    .wrempty(),                        //Write domain empty
    .wralempty(),                      //Write domain almost-full  
    .rdfull(),                         //Read domain full
    .rdalfull(),                       //Read domain almost-full   
    .rdempty(w_fifo_empty),            //Read domain empty
    .rdalempty(),                      //Read domain almost-empty
    .wrusedw(),                        //Write-usedword
    .rdusedw()                         //Read-usedword
);
host_output_queue host_output_queue_inst(
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