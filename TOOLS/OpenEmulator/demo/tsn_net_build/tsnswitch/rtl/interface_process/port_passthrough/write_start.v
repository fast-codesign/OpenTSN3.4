// Copyright (C) 1953-2020 NUDT
// Verilog module name - write_start 
// Version: WRS_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module write_start #(
    parameter DATA_WIDTH = 8
)(
    input wire                  clk,
    input wire                  rst_n,
    
    input wire                  gmii_rx_en,
    input wire                  gmii_rx_er,
    input wire [DATA_WIDTH-1:0] gmii_rxd,
    
    output reg                  wrreq,
    output reg [7:0]            usedw,
    output reg [DATA_WIDTH+1:0] FIFO_data
);

always @(posedge clk or negedge rst_n)
    if(!rst_n) begin
        FIFO_data <= 10'd0;
        wrreq <= 0;
        usedw <= 0;
    end
    else begin
        FIFO_data <= {gmii_rx_en, gmii_rx_er, gmii_rxd};//10bit combination 
        wrreq <= 1;
        if(usedw > 8'd3) usedw <= 8'd4;
        else usedw <= usedw + 8'b1;
    end

endmodule

/*
write_start write_start_inst(
.clk(),
.rst_n(),
.gmii_rx_en(),
.gmii_rx_er(),
.gmii_rxd(),

.wrreg(),
.usedw(),
.FIFO_data()
);
*/
