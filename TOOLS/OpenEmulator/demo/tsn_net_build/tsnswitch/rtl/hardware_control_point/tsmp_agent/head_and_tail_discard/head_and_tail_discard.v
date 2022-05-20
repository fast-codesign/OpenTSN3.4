// Copyright (C) 1953-2022 NUDT
// Verilog module name - head_and_tail_discard 
// Version: V3.4.0.2022
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         receive pkt_bufid,and convert it into read address
//         read pkt data from pkt_centralize_bufm_memory on the basis of read address
//         parse pkt,and calculates and updatas the transparent clock for PTP
//         send pkt data from gmii
//         one network interface have one network_tx 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module head_and_tail_discard
(
        i_clk,
        i_rst_n,
       
        i_gmii_clk,
        i_gmii_rst_n,
                     
        iv_data,
	    i_data_wr,
       
        ov_gmii_txd,
        o_gmii_tx_en,
        o_gmii_tx_er,
        o_gmii_tx_clk,

        o_fifo_overflow_pulse
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;

input                  i_gmii_clk;                   
input                  i_gmii_rst_n;
// pkt input from fem
input	   [8:0]	   iv_data;
input	         	   i_data_wr;
// send pkt data from gmii     
output     [7:0]       ov_gmii_txd;
output                 o_gmii_tx_en;
output                 o_gmii_tx_er;
output                 o_gmii_tx_clk;
// local timer rst signal
output                 o_fifo_overflow_pulse;             
cross_clock_domain_hcp cross_clock_domain_hcp_inst(
.i_clk                 (i_clk                ),
.i_rst_n               (i_rst_n              ),
                       
.i_gmii_clk            (i_gmii_clk           ),
.i_gmii_rst_n          (i_gmii_rst_n         ),
                       
.iv_pkt_data           (iv_data[7:0]         ),
.i_pkt_data_wr         (i_data_wr            ),

.o_fifo_overflow_pulse (o_fifo_overflow_pulse),
                       
.ov_gmii_txd           (ov_gmii_txd          ),
.o_gmii_tx_en          (o_gmii_tx_en         ),
.o_gmii_tx_er          (o_gmii_tx_er         ),
.o_gmii_tx_clk         (o_gmii_tx_clk        )
);
endmodule