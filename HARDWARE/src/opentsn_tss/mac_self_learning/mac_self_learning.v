// Copyright (C) 1953-2021 NUDT
// Verilog module name - mac_self_learning
// Version: V3.3.0.20211124
// Created:
//         by - fenglin
////////////////////////////////////////////////////////////////////////////
// Description:
//         pkt parse,extract standard pkt SMAC and inport
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module mac_self_learning
(
        i_clk,
        i_rst_n,
      
        iv_data,
        i_data_wr,
        iv_rec_ts,
    
        ov_data,
        o_data_wr,
        ov_rec_ts,
		
        ov_smac_inport,
        ov_entry_addr,
        o_mactable_wr
);
// I/O
// clk & rst
input                i_clk;
input                i_rst_n;

input    [8:0]       iv_data;
input                i_data_wr;
input    [18:0]      iv_rec_ts;
// data output
output   [8:0]       ov_data;
output               o_data_wr;
output   [18:0]      ov_rec_ts;

output   [56:0]      ov_smac_inport;
output   [4:0]       ov_entry_addr;
output               o_mactable_wr;
// internal reg&wire
wire     [47:0]      wv_smac_ppa2ecp ; 
wire     [8:0]       wv_inport_ppa2ecp;
wire                 w_data_wr_ppa2ecp;
entry_compare entry_compare_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

.iv_smac_ppa2ecp  (wv_smac_ppa2ecp  ),
.iv_inport_ppa2ecp(wv_inport_ppa2ecp),
.i_data_wr_ppa2ecp(w_data_wr_ppa2ecp),

.ov_smac_inport(ov_smac_inport),
.o_data_wr    (o_mactable_wr),
.ov_entry_addr(ov_entry_addr)
);

packet_parse packet_parse_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

.iv_data(iv_data),
.i_data_wr(i_data_wr),
.iv_rec_ts(iv_rec_ts),

.ov_data(ov_data),
.o_data_wr(o_data_wr),
.ov_rec_ts(ov_rec_ts),

.ov_smac_ppa2ecp  (wv_smac_ppa2ecp  ),
.o_data_wr_ppa2ecp(w_data_wr_ppa2ecp),
.ov_inport_ppa2ecp(wv_inport_ppa2ecp)
);

        
endmodule