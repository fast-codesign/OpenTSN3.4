// Copyright (C) 1953-2020 NUDT
// Verilog module name - host_output_process 
// Version: HTP_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         transmit process of host.
//             -top module.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module host_output_process
(
        i_clk,
        i_rst_n,
                 
        iv_addr             ,
        iv_wdata            ,
        i_addr_fixed        ,
        i_wr_fim            ,
        i_rd_fim            ,
        
        o_wr_fim            ,
        ov_addr_fim         ,
        o_addr_fixed_fim    ,
        ov_rdata_fim        ,
        
        iv_tsntag_hcp,
        iv_bufid_hcp,
	    i_inverse_map_lookup_flag_hcp,
        i_descriptor_wr_hcp,
        o_descriptor_ack_hcp,
        
        iv_tsntag_network,
        iv_bufid_network,
        i_inverse_map_lookup_flag_network,
        i_descriptor_wr_network,
        o_descriptor_ack_network,
        
        ov_pkt_bufid,
        o_pkt_bufid_wr,
        i_pkt_bufid_ack, 
        
        ov_pkt_raddr,
        o_pkt_rd,
        i_pkt_raddr_ack,
        
        iv_pkt_data,
        i_pkt_data_wr,
        
        o_pkt_output_pulse,
        o_host_inqueue_discard_pulse,     
        o_fifo_overflow_pulse,       
        
        o_ts_underflow_error_pulse,
        o_ts_overflow_error_pulse, 
        
        ov_gmii_txd,
        o_gmii_tx_en   
);

// I/O
// clk & rst
input                  i_clk;   
input                  i_rst_n;

input      [18:0]      iv_addr             ;
input      [31:0]      iv_wdata            ;
input                  i_addr_fixed        ;
input                  i_wr_fim            ;
input                  i_rd_fim            ;
                       
output                 o_wr_fim            ;
output      [18:0]     ov_addr_fim         ;
output                 o_addr_fixed_fim    ;
output      [31:0]     ov_rdata_fim        ;
//tsntag & bufid input from host_port
input      [47:0]      iv_tsntag_hcp;
input      [8:0]       iv_bufid_hcp;
input                  i_inverse_map_lookup_flag_hcp;
input                  i_descriptor_wr_hcp;
output                 o_descriptor_ack_hcp;
//tsntag & bufid input from hcp_port
input      [47:0]      iv_tsntag_network;
input      [8:0]       iv_bufid_network;
input                  i_inverse_map_lookup_flag_network;
input                  i_descriptor_wr_network;
output                 o_descriptor_ack_network;
//receive pkt from PCB  
input       [133:0]    iv_pkt_data;
input                  i_pkt_data_wr;

output                 o_pkt_output_pulse;
output                 o_host_inqueue_discard_pulse; 
output                 o_fifo_overflow_pulse;
// pkt_bufid to PCB in order to release pkt_bufid
output     [8:0]       ov_pkt_bufid;
output                 o_pkt_bufid_wr;
input                  i_pkt_bufid_ack; 
// read address to PCB in order to read pkt data       
output     [15:0]      ov_pkt_raddr;
output                 o_pkt_rd;
input                  i_pkt_raddr_ack;
// transmit pkt to phy     
output     [7:0]       ov_gmii_txd;
output                 o_gmii_tx_en;

output                 o_ts_underflow_error_pulse;
output                 o_ts_overflow_error_pulse;

wire       [12:0]      wv_nts_descriptor_wdata;
wire                   w_nts_descriptor_wr;

wire       [31:0]      wv_ts_cnt; 

wire       [21:0]      wv_descriptor_hqm2fim;
wire                   w_descriptor_wr_hqm2fim;
wire                   w_descriptor_ready_fim2hqm;

wire       [47:0]	   wv_dmac_fim2htx;
wire       [8:0]	   wv_bufid_fim2htx;
wire                   w_lookup_table_match_flag_fim2htx;
wire                   w_dmac_replace_flag;///
wire                   w_descriptor_wr_fim2htx;
wire                   w_descriptor_ready_htx2fim;
host_queue_management host_queue_management_inst(
.i_clk                          (i_clk),
.i_rst_n                        (i_rst_n),
        
.iv_tsntag_hcp                  (iv_tsntag_hcp),
.iv_bufid_hcp                   (iv_bufid_hcp),
.i_inverse_map_lookup_flag_hcp  (i_inverse_map_lookup_flag_hcp),///
.i_descriptor_wr_hcp            (i_descriptor_wr_hcp),
.o_descriptor_ack_hcp           (o_descriptor_ack_hcp),

.iv_tsntag_network              (iv_tsntag_network),
.iv_bufid_network               (iv_bufid_network),
.i_inverse_map_lookup_flag_network(i_inverse_map_lookup_flag_network),
.i_descriptor_wr_network        (i_descriptor_wr_network),
.o_descriptor_ack_network       (o_descriptor_ack_network),

.ov_descriptor                  (wv_descriptor_hqm2fim),
.o_descriptor_wr                (w_descriptor_wr_hqm2fim),
.i_descriptor_ready             (w_descriptor_ready_fim2hqm)
);
frame_inverse_mapping frame_inverse_mapping_inst(
.i_clk                          (i_clk                                ),
.i_rst_n                        (i_rst_n                              ),
                                                                      
.iv_addr                        (iv_addr                              ),
.iv_wdata                       (iv_wdata                             ),
.i_addr_fixed                   (i_addr_fixed                         ),
.i_wr_fim                       (i_wr_fim                             ),
.i_rd_fim                       (i_rd_fim                             ),
                                                                      
.o_wr_fim                       (o_wr_fim                             ),
.ov_addr_fim                    (ov_addr_fim                          ),
.o_addr_fixed_fim               (o_addr_fixed_fim                     ),
.ov_rdata_fim                   (ov_rdata_fim                         ),
                                
.iv_descriptor                  (wv_descriptor_hqm2fim                ),
.i_descriptor_wr                (w_descriptor_wr_hqm2fim              ),
.o_descriptor_ready             (w_descriptor_ready_fim2hqm           ),
                                
.ov_dmac                        (wv_dmac_fim2htx                      ),
.ov_bufid                       (wv_bufid_fim2htx                     ),
.o_lookup_table_match_flag      (w_lookup_table_match_flag_fim2htx    ),
.o_dmac_replace_flag            (w_dmac_replace_flag                  ),
.o_descriptor_wr                (w_descriptor_wr_fim2htx              ),
.i_descriptor_ready             (w_descriptor_ready_htx2fim           )
);
host_tx host_tx_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

.iv_pkt_descriptor      ({wv_dmac_fim2htx,~w_lookup_table_match_flag_fim2htx,~w_lookup_table_match_flag_fim2htx,~w_lookup_table_match_flag_fim2htx,~w_lookup_table_match_flag_fim2htx,wv_bufid_fim2htx}),
.i_dmac_replace_flag    (w_dmac_replace_flag),///
.i_pkt_descriptor_wr    (w_descriptor_wr_fim2htx),
.o_pkt_descriptor_ready (w_descriptor_ready_htx2fim),

.ov_pkt_bufid           (ov_pkt_bufid),
.o_pkt_bufid_wr         (o_pkt_bufid_wr),
.i_pkt_bufid_ack        (i_pkt_bufid_ack),  

.ov_pkt_raddr           (ov_pkt_raddr),
.o_pkt_rd               (o_pkt_rd),
.i_pkt_raddr_ack        (i_pkt_raddr_ack),

.iv_pkt_data            (iv_pkt_data),
.i_pkt_data_wr          (i_pkt_data_wr),

.o_pkt_output_pulse     (o_pkt_output_pulse),
.o_fifo_overflow_pulse  (o_fifo_overflow_pulse),

.ov_gmii_txd            (ov_gmii_txd),
.o_gmii_tx_en           (o_gmii_tx_en)
);

endmodule