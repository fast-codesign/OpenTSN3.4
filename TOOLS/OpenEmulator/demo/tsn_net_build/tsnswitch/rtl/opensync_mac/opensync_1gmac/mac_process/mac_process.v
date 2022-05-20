// Copyright (C) 1953-2022 NUDT
// Verilog module name - mac_process 
// Version: V3.4.0.20220223
// Created:
//         by - fenglin 
//         at - 02.2022
////////////////////////////////////////////////////////////////////////////
// Description:
//         1.Deletion and addition of CRC field；
//         2.message length is controlled within 60-1514 bytes；
//         3.IP length controlled；
//         4.The camera can work normally,and the terminal system can 
//			 get the message through the packet capturing tool.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module mac_process(
    input  wire        gmii_rxclk,
    input  wire        gmii_txclk,

    input  wire        rst_n,
    
    input  wire        port_type,

    input  wire        gmii_rx_dv,
    input  wire        gmii_rx_er,
    input  wire [7:0]  gmii_rxd,
    
    output  wire        gmii_rx_dv_adp2tsnchip,
    output  wire        gmii_rx_er_adp2tsnchip,
    output  wire [7:0]  gmii_rxd_adp2tsnchip,
    
    
    output wire        gmii_tx_en,
    output wire        gmii_tx_er,
    output wire [7:0]  gmii_txd,

    input wire        gmii_tx_en_tsnchip2adp,
    input wire        gmii_tx_er_tsnchip2adp,
    input wire [7:0]  gmii_txd_tsnchip2adp
);

/*/////////////////////////////////////////////////////////////////////
            Intermediate variable Declaration
*////////////////////////////////////////////////////////////////////// 
wire       grc2ppt_gmii_dv;
wire       grc2ppt_gmii_er;
wire [7:0] grc2ppt_gmii_data;

wire       ppt2gtc_gmii_dv;
wire       ppt2gtc_gmii_er;
wire [7:0] ppt2gtc_gmii_data;

/*/////////////////////////////////////////////////////////////////////
            module or ip core instantiation
*//////////////////////////////////////////////////////////////////////

receive_mac_process receive_mac_process_inst(
    .clk(gmii_rxclk),
    .rst_n(rst_n),
    .port_type(port_type),                    
    
    .gmii_rx_dv(gmii_rx_dv),
    .gmii_rx_er(gmii_rx_er),
    .gmii_rxd(gmii_rxd),
       
    .grc2ppt_gmii_dv(gmii_rx_dv_adp2tsnchip),
    .grc2ppt_gmii_er(gmii_rx_er_adp2tsnchip),
    .grc2ppt_gmii_data(gmii_rxd_adp2tsnchip)

);

       
transmit_mac_process transmit_mac_process_inst(
    .i_clk(gmii_txclk),
    .i_rst_n(rst_n),

    .i_data_wr(gmii_tx_en_tsnchip2adp),
    .iv_data(gmii_txd_tsnchip2adp),                    
    
    .o_gmii_tx_en(gmii_tx_en),
    .o_gmii_tx_er(gmii_tx_er),
    .ov_gmii_txd  (gmii_txd  )
);

endmodule
