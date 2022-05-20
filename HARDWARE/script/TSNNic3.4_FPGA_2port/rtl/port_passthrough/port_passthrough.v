// Copyright (C) 1953-2020 NUDT
// Verilog module name - port_passthrough 
// Version: PPT_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module port_passthrough #(
    parameter DATA_WIDTH = 8
)(
    input wire                  gmii_rxclk,
    input wire                  gmii_txclk,
    input wire                  rst_n,
    
    input wire                  gmii_rx_en,
    input wire                  gmii_rx_er,
    input wire [DATA_WIDTH-1:0] gmii_rxd,
    
    output wire                   gmii_tx_en,
    output wire                   gmii_tx_er,
    output wire [DATA_WIDTH-1:0] gmii_txd
);

/*/////////////////////////////////////////////////////////////////////
            Intermediate variable Declaration
*//////////////////////////////////////////////////////////////////////

wire [7:0]  usedw;
wire [9:0]  FIFO_data;
wire        rdreq;
wire        wrreq;
wire [9:0]  q_sig;

/*/////////////////////////////////////////////////////////////////////
            module or ip core instantiation
*//////////////////////////////////////////////////////////////////////

write_start write_start_inst(
.clk(gmii_rxclk),
.rst_n(rst_n),
.gmii_rx_en(gmii_rx_en),
.gmii_rx_er(gmii_rx_er),
.gmii_rxd(gmii_rxd),

.wrreq(wrreq),
.usedw(usedw),
.FIFO_data(FIFO_data)
);

DCFIFO_10bit_64 DCFIFO_10bit_64_inst(
.data  (FIFO_data),  //  fifo_input.datain
.wrreq (wrreq), //            .wrreq
.rdreq (rdreq), //            .rdreq
.wrclk (gmii_rxclk), //            .wrclk
.rdclk (gmii_txclk), //            .rdclk
.aclr  (!rst_n),  //            .aclr
.q     (q_sig)      // fifo_output.dataout
);

read_delay read_delay_inst(
.clk(gmii_txclk),
.rst_n(rst_n),
.usedw(usedw),
.FIFO_data(q_sig),

.rdreq(rdreq),
.gmii_tx_en(gmii_tx_en),
.gmii_tx_er(gmii_tx_er),
.gmii_txd(gmii_txd)
);

endmodule
