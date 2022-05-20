// Copyright (C) 1953-2021 NUDT
// Verilog module name - control_transmit_process 
// Version: V3.2.0.20210722
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         transmit process of host.
//             -top module.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module control_output_process
(
       i_clk,
       i_rst_n,
       
       i_wr_ctx         ,   
       i_rd_ctx         ,
       o_wr_ctx         ,
       ov_addr_ctx      ,
       o_addr_fixed_ctx ,
       ov_rdata_ctx     ,
       
       iv_pkt_type_ctrl,
	   iv_pkt_bufid_ctrl,
       i_mac_entry_hit_ctrl,
       iv_pkt_inport_ctrl,
       i_pkt_bufid_wr_ctrl,
       
       ov_pkt_bufid,
       o_pkt_bufid_wr,
       i_pkt_bufid_ack, 
       
       ov_pkt_raddr,
       o_pkt_rd,
       i_pkt_raddr_ack,
       
       iv_pkt_data,
       i_pkt_data_wr,   
       
       ov_hcp_data   ,
       o_hcp_data_wr ,
       
       ov_eth_data   ,
       o_eth_data_wr ,

       hoi_state,
       bufid_state,
       pkt_read_state    
);

// I/O
// clk & rst
input                  i_clk           ;   
input                  i_rst_n         ;

input                  i_wr_ctx        ; 
input                  i_rd_ctx        ;
output                 o_wr_ctx        ;
output    [18:0]       ov_addr_ctx     ;
output                 o_addr_fixed_ctx;
output    [31:0]       ov_rdata_ctx    ; 
//tsntag & bufid input from host_port
input          [2:0]   iv_pkt_type_ctrl;
input          [8:0]   iv_pkt_bufid_ctrl;
input                  i_mac_entry_hit_ctrl;
input          [3:0]   iv_pkt_inport_ctrl;
input                  i_pkt_bufid_wr_ctrl;
//receive pkt from PCB  
input       [133:0]    iv_pkt_data;
input                  i_pkt_data_wr;
// pkt_bufid to PCB in order to release pkt_bufid
output     [8:0]       ov_pkt_bufid;
output                 o_pkt_bufid_wr;
input                  i_pkt_bufid_ack; 
// read address to PCB in order to read pkt data       
output     [15:0]      ov_pkt_raddr;
output                 o_pkt_rd;
input                  i_pkt_raddr_ack;
// transmit pkt to phy     
output     [7:0]       ov_hcp_data  ;
output                 o_hcp_data_wr;

output     [7:0]       ov_eth_data  ;
output                 o_eth_data_wr;

output     [3:0]       hoi_state;
output     [1:0]       bufid_state;
output     [2:0]       pkt_read_state;

wire       [13:0]      wv_descriptor_nqm2ntx;
wire                   w_descriptor_wr_nqm2ntx;
wire                   w_descriptor_ready_ntx2nqm;
control_queue_management control_queue_management_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

.iv_pkt_type_ctrl     (iv_pkt_type_ctrl    ),
.iv_pkt_bufid_ctrl    (iv_pkt_bufid_ctrl   ),
.i_mac_entry_hit_ctrl (i_mac_entry_hit_ctrl),
.iv_pkt_inport_ctrl   (iv_pkt_inport_ctrl  ),
.i_pkt_bufid_wr_ctrl  (i_pkt_bufid_wr_ctrl ),

.ov_descriptor        (wv_descriptor_nqm2ntx),
.o_descriptor_wr      (w_descriptor_wr_nqm2ntx),
.i_descriptor_ready   (w_descriptor_ready_ntx2nqm)
);
control_tx control_tx_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

//.i_wr_ctx         (i_wr_ctx        ),
//.i_rd_ctx         (i_rd_ctx        ),
//.o_wr_ctx         (o_wr_ctx        ),
//.ov_addr_ctx      (ov_addr_ctx     ),
//.o_addr_fixed_ctx (o_addr_fixed_ctx),
//.ov_rdata_ctx     (ov_rdata_ctx    ),

.iv_pkt_descriptor(wv_descriptor_nqm2ntx),
.i_pkt_descriptor_wr(w_descriptor_wr_nqm2ntx),
.o_pkt_descriptor_ready(w_descriptor_ready_ntx2nqm),

.ov_pkt_bufid(ov_pkt_bufid),
.o_pkt_bufid_wr(o_pkt_bufid_wr),
.i_pkt_bufid_ack(i_pkt_bufid_ack),  

.ov_pkt_raddr(ov_pkt_raddr),
.o_pkt_rd(o_pkt_rd),
.i_pkt_raddr_ack(i_pkt_raddr_ack),

.iv_pkt_data(iv_pkt_data),
.i_pkt_data_wr(i_pkt_data_wr),

.ov_hcp_data  (ov_hcp_data  ),
.o_hcp_data_wr(o_hcp_data_wr),
 
.ov_eth_data  (ov_eth_data  ),  
.o_eth_data_wr(o_eth_data_wr),

.hoi_state(hoi_state),
.bufid_state(bufid_state),
.pkt_read_state(pkt_read_state),

.ov_debug_ts_cnt(),
.ov_debug_cnt()   
);
endmodule