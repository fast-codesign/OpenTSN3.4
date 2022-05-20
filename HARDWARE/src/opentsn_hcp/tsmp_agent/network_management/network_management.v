// Copyright (C) 1953-2022 NUDT
// Verilog module name - network_management
// Version: V3.4.0.20220228
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//        configure&state manage,process and build nmac pkt              
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module network_management
(
       i_clk,
       i_rst_n,
       
       ov_command,
       o_command_wr,       
       
       iv_command_ack,
       i_command_ack_wr,

       iv_hcp_mac,
       iv_controller_mac,       

       iv_data,
       i_data_wr,
       
       ov_data,
       o_data_wr
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;

output    [65:0]	   ov_command;
output  	           o_command_wr;

input     [65:0]	   iv_command_ack;
input    	           i_command_ack_wr;

input     [47:0]       iv_hcp_mac       ;
input     [47:0]       iv_controller_mac;      

input     [8:0]        iv_data;
input                  i_data_wr;

output    [8:0]        ov_data;
output                 o_data_wr;

wire                   w_tsmp_receive_pulse;
wire      [31:0]       wv_tsmp_ack_cnt;

wire      [15:0]       wv_rd_state_num;

wire      [63:0]	   wv_rd_command_ack_atp2fifo;
wire    	           w_rd_command_ack_wr_atp2fifo;
wire                   w_rd_command_ack_rd_npg2fifo;
wire      [63:0]       wv_rd_command_ack_rdata_fifo2npg;
wire                   w_rd_command_ack_fifo_empty_fifo2npg;
wire      [7:0]        wv_rd_command_ack_fifo_usedw_fifo2npg;

wire      [47:0]       wv_dmac_nmp2nmg;
wire      [47:0]       wv_smac_nmp2nmg;
network_management_parse network_management_parse_inst(
.i_clk                      (i_clk               ),
.i_rst_n                    (i_rst_n             ),

.ov_dmac                    (wv_dmac_nmp2nmg     ),
.ov_smac                    (wv_smac_nmp2nmg     ),
       
.iv_data                    (iv_data             ),
.i_data_wr                  (i_data_wr           ),
                                                 
.ov_command                 (ov_command          ),
.o_command_wr               (o_command_wr        ), 
.ov_rd_state_num            (wv_rd_state_num     ), 

.o_tsmp_receive_pulse       (w_tsmp_receive_pulse)
);
ack_type_parse ack_type_parse_inst(
.i_clk                     (i_clk),
.i_rst_n                   (i_rst_n),

.iv_command_ack            (iv_command_ack),
.i_command_ack_wr          (i_command_ack_wr),

.ov_rd_command_ack         (wv_rd_command_ack_atp2fifo),
.o_rd_command_ack_wr       (w_rd_command_ack_wr_atp2fifo)

);  
syncfifo_showahead_aclr_w64d256 cache_rd_command_ack(
.data  (wv_rd_command_ack_atp2fifo), 
.wrreq (w_rd_command_ack_wr_atp2fifo),
.rdreq (w_rd_command_ack_rd_npg2fifo),
.clock (i_clk),
.aclr  (!i_rst_n), 
.q     (wv_rd_command_ack_rdata_fifo2npg),    
.usedw (wv_rd_command_ack_fifo_usedw_fifo2npg),
.full  (), 
.empty (w_rd_command_ack_fifo_empty_fifo2npg) 
);
network_management_generate network_management_generate_inst(
.i_clk                              (i_clk),
.i_rst_n                            (i_rst_n),

.iv_dmac                            (wv_dmac_nmp2nmg     ),
.iv_smac                            (wv_smac_nmp2nmg     ),

.iv_hcp_mac                         (iv_hcp_mac       ),
.iv_controller_mac                  (iv_controller_mac),
.iv_rd_state_num                    (wv_rd_state_num),

.iv_fifo_usedw                      (wv_rd_command_ack_fifo_usedw_fifo2npg),  
.o_fifo_rd                          (w_rd_command_ack_rd_npg2fifo),      
.iv_command_ack                     (wv_rd_command_ack_rdata_fifo2npg),

.ov_data                            (ov_data),
.o_data_wr                          (o_data_wr),

.ov_tsmp_ack_cnt                    (wv_tsmp_ack_cnt),
.ov_fifo_underflow_cnt              ()
);
endmodule

  

