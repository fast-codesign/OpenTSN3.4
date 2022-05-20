// Copyright (C) 1953-2022 NUDT
// Verilog module name - tsmp_transmit_control
// Version: V3.4.0.20220301
// Created:
//         by - fenglin
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tsmp_transmit_control
(
        i_clk  ,
        i_rst_n,
       
        iv_data_nma  ,
	    i_data_wr_nma,

        iv_data_osp  ,
        i_data_wr_osp,
        
        iv_data_tfp  ,
        i_data_wr_tfp,
        
        iv_data_pop  ,
        i_data_wr_pop,

        ov_data,
        o_data_wr
); 
// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n; 
// pkt input
input	   [8:0]	   iv_data_nma  ;
input	         	   i_data_wr_nma;
                       
input	   [8:0]	   iv_data_osp  ;
input	         	   i_data_wr_osp;
                       
input	   [8:0]	   iv_data_tfp  ;
input	         	   i_data_wr_tfp;
                       
input	   [8:0]	   iv_data_pop  ;
input	         	   i_data_wr_pop;

output     [8:0]	   ov_data  ;
output     	           o_data_wr;

wire                   w_data_fifo_rden_nma2cos;
wire                   w_data_fifo_empty_cos2nma;
wire       [8:0]       wv_data_fifo_rdata_cos2nma;

wire                   w_data_fifo_rden_osp2cos;
wire                   w_data_fifo_empty_cos2osp;
wire       [8:0]       wv_data_fifo_rdata_cos2osp;

wire                   w_data_fifo_rden_tfp2cos;
wire                   w_data_fifo_empty_cos2tfp;
wire       [8:0]       wv_data_fifo_rdata_cos2tfp;

wire                   w_data_fifo_rden_pop2cos;
wire                   w_data_fifo_empty_cos2pop;
wire       [8:0]       wv_data_fifo_rdata_cos2pop;
syncfifo_showahead_aclr_w9d256 nma_packet_cache_inst(
    .data  (iv_data_nma), 
    .wrreq (i_data_wr_nma),
    .rdreq (w_data_fifo_rden_nma2cos),
    .clock (i_clk),
    .aclr  (!i_rst_n), 
    .q     (wv_data_fifo_rdata_cos2nma),    
    .usedw (),
    .full  (), 
    .empty (w_data_fifo_empty_cos2nma) 
);
syncfifo_showahead_aclr_w9d256 osp_packet_cache_inst(
    .data  (iv_data_osp), 
    .wrreq (i_data_wr_osp),
    .rdreq (w_data_fifo_rden_osp2cos),
    .clock (i_clk),
    .aclr  (!i_rst_n), 
    .q     (wv_data_fifo_rdata_cos2osp),    
    .usedw (),
    .full  (), 
    .empty (w_data_fifo_empty_cos2osp) 
);
syncfifo_showahead_aclr_w9d256 tfp_packet_cache_inst(
    .data  (iv_data_tfp), 
    .wrreq (i_data_wr_tfp),
    .rdreq (w_data_fifo_rden_tfp2cos),
    .clock (i_clk),
    .aclr  (!i_rst_n), 
    .q     (wv_data_fifo_rdata_cos2tfp),    
    .usedw (),
    .full  (), 
    .empty (w_data_fifo_empty_cos2tfp) 
);
syncfifo_showahead_aclr_w9d256 pop_packet_cache_inst(
    .data  (iv_data_pop), 
    .wrreq (i_data_wr_pop),
    .rdreq (w_data_fifo_rden_pop2cos),
    .clock (i_clk),
    .aclr  (!i_rst_n), 
    .q     (wv_data_fifo_rdata_cos2pop),    
    .usedw (),
    .full  (), 
    .empty (w_data_fifo_empty_cos2pop) 
);
controller_output_schedule controller_output_schedule_inst
(
        .i_clk              (i_clk            ),
        .i_rst_n            (i_rst_n          ),
                                              
	    .i_fifo_empty_nma   (w_data_fifo_empty_cos2nma ),
        .o_fifo_rden_nma    (w_data_fifo_rden_nma2cos  ),
        .iv_fifo_rdata_nma  (wv_data_fifo_rdata_cos2nma),
                                             
	    .i_fifo_empty_osp   (w_data_fifo_empty_cos2osp ),
        .o_fifo_rden_osp    (w_data_fifo_rden_osp2cos  ),
        .iv_fifo_rdata_osp  (wv_data_fifo_rdata_cos2osp),
                                           
	    .i_fifo_empty_tfp   (w_data_fifo_empty_cos2tfp ),
        .o_fifo_rden_tfp    (w_data_fifo_rden_tfp2cos  ),
        .iv_fifo_rdata_tfp  (wv_data_fifo_rdata_cos2tfp),          
                                          
	    .i_fifo_empty_pop   (w_data_fifo_empty_cos2pop ),
        .o_fifo_rden_pop    (w_data_fifo_rden_pop2cos  ),
        .iv_fifo_rdata_pop  (wv_data_fifo_rdata_cos2pop),  
                                            
        .ov_data            (ov_data          ),
        .o_data_wr          (o_data_wr        )
); 
endmodule