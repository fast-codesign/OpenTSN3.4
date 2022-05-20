// Copyright (C) 1953-2020 NUDT
// Verilog module name - read_delay 
// Version: RDD_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module read_delay #(
    parameter DATA_WIDTH = 8
)(
    input wire                  clk,
    input wire                  rst_n,
    
    input wire [7:0]            usedw,
    input wire [DATA_WIDTH+1:0] FIFO_data,
    
    output reg                  rdreq,
    output reg                  gmii_tx_en,
    output reg                  gmii_tx_er,
    output reg [DATA_WIDTH-1:0] gmii_txd
);

always @(posedge clk or negedge rst_n)
    if(!rst_n) rdreq <= 0;
    else if(usedw > 8'd3) rdreq <= 1;
    else rdreq <=0;

always @(posedge clk or negedge rst_n)
    if(!rst_n) begin
        gmii_tx_en <= 1'b0;
        gmii_tx_er <= 1'b0;
        gmii_txd   <= 8'd0;
    end
    else begin
        gmii_tx_en <= FIFO_data[9];
        gmii_tx_er <= FIFO_data[8];
        gmii_txd[7:0]   <= FIFO_data[7:0];
    end

endmodule

/*
read_delay read_delay_inst(
.clk(),
.rst_n(),
.usedw(),
.FIFO_data(),

.rdreq(),
.gmii_tx_en(),
.gmii_tx_er(),
.gmii_txd()
);
*/
