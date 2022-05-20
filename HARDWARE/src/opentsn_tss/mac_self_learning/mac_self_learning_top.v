// Copyright (C) 1953-2021 NUDT
// Verilog module name - mac_self_learning_top
// Version: V3.3.0.20211124
// Created:
//         by - fenglin
////////////////////////////////////////////////////////////////////////////
// Description:
//         pkt parse,extract standard pkt SMAC and inport
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module mac_self_learning_top
(
        i_clk,
        i_rst_n,

	    i_data_wr,
	    iv_data,  
		
        ov_smac_inport,
        ov_entry_addr,
        o_mactable_wr
);
// I/O
// clk & rst
input                i_clk;
input                i_rst_n;
 
input	  		     i_data_wr;
input	 [7:0]	 	 iv_data;

output   [56:0]      ov_smac_inport;
output   [4:0]       ov_entry_addr;
output               o_mactable_wr;

wire      [8:0]      wv_data_htd2msl;
wire                 w_data_wr_htd2msl;
head_and_tail_distinguish head_and_tail_distinguish_inst
(
        .i_clk    (i_clk),
        .i_rst_n  (i_rst_n),
        
        .i_data_wr(i_data_wr),
        .iv_data  (iv_data),
        
        .ov_data  (wv_data_htd2msl),
        .o_data_wr(w_data_wr_htd2msl)
);

mac_self_learning mac_self_learning_inst(
.i_clk             (i_clk),
.i_rst_n           (i_rst_n),

.iv_data           (wv_data_htd2msl),
.i_data_wr         (w_data_wr_htd2msl),
.iv_rec_ts         (19'b0),
           
.ov_data           (),
.o_data_wr         (),
.ov_rec_ts         (),
           
.ov_smac_inport    (ov_smac_inport),
.o_mactable_wr     (o_mactable_wr),
.ov_entry_addr     (ov_entry_addr)
);   
endmodule