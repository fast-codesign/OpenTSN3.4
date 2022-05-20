// Copyright (C) 1953-2022 NUDT
// Verilog module name - descriptor_extract
// Version: V3.4.0.20220225
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         Frame Phase 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module descriptor_extract #(parameter inport = 4'b0000)
    (
        i_clk,
        i_rst_n,

        iv_addr,                          
        i_addr_fixed,                    
        iv_wdata,                                  
        i_wr_dex,                         
        i_rd_dex,                         

        o_wr_dex,          
        ov_addr_dex,       
        o_addr_fixed_dex,  
        ov_rdata_dex, 
        
        iv_data,
        i_data_wr,
		i_standardpkt_tsnpkt_flag,
        iv_eth_type,
  
        i_pkt_bufid_wr,
        iv_pkt_bufid,
        o_pkt_bufid_ack,
        
        ov_pkt,
        o_pkt_wr,
        o_pkt_bufid_wr,
        ov_pkt_bufid,
        o_descriptor_wr,
        ov_descriptor,
        i_descriptor_ack,       
        //for discarding pkt while the fifo_used_findows is over the threshold 
        free_bufid_fifo_rdusedw,
        iv_rc_threshold_value           ,
        iv_standardpkt_threshold_value  ,
        iv_be_threshold_value           ,

        descriptor_extract_state,
        descriptor_send_state   ,
        data_splice_state
    );

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;

input       [18:0]      iv_addr;                         
input                   i_addr_fixed;                   
input       [31:0]      iv_wdata;                              
input                   i_wr_dex;                        
input                   i_rd_dex; 

output                  o_wr_dex;                     
output     [18:0]       ov_addr_dex;                  
output                  o_addr_fixed_dex;             
output     [31:0]       ov_rdata_dex;
//input
input       [8:0]       iv_data;
input                   i_data_wr;
input                   i_standardpkt_tsnpkt_flag;

input       [15:0]      iv_eth_type;
input                   i_pkt_bufid_wr;
input       [8:0]       iv_pkt_bufid;
output                  o_pkt_bufid_ack;

//temp ov_descriptor and ov_pkt for discarding pkt while the fifo_used_findows is over the threshold 
input       [8:0]       free_bufid_fifo_rdusedw         ;
input       [8:0]       iv_rc_threshold_value           ;
input       [8:0]       iv_standardpkt_threshold_value  ;
input       [8:0]       iv_be_threshold_value           ;
//output
output                  o_pkt_wr;
output      [133:0]     ov_pkt;
output                  o_pkt_bufid_wr;
output      [8:0]       ov_pkt_bufid;
output                  o_descriptor_wr;
output      [71:0]      ov_descriptor;
input                   i_descriptor_ack; 
//state
output      [3:0]       descriptor_extract_state;
output      [1:0]       descriptor_send_state;
output      [1:0]       data_splice_state;  
//internal wire
wire        [8:0]       data_dee2das;
wire                    data_wr_dee2das;
wire                    descriptor_valid_dat2des;
wire        [71:0]      descriptor_dat2des;

wire        [8:0]       wv_be_threshold_value;
wire        [8:0]       wv_rc_threshold_value;
wire        [8:0]       wv_standardpkt_threshold_value;
descriptor_generate  #(.inport(inport)) descriptor_generate_inst
    (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
       
        .iv_data(iv_data),
		.i_standardpkt_tsnpkt_flag(i_standardpkt_tsnpkt_flag),
        .i_data_wr(i_data_wr),
        
        .iv_free_bufid_num(free_bufid_fifo_rdusedw),
        .iv_hpriority_be_threshold_value(iv_be_threshold_value),
        .iv_rc_threshold_value(iv_rc_threshold_value),
        .iv_lpriority_be_threshold_value(iv_standardpkt_threshold_value),
        .iv_eth_type(iv_eth_type),
        
        .ov_data(data_dee2das),
        .o_data_wr(data_wr_dee2das),
        .o_descriptor_valid(descriptor_valid_dat2des),
        .ov_descriptor(descriptor_dat2des),
        .descriptor_extract_state(descriptor_extract_state)
    );  
    
descriptor_send descriptor_send_inst
    (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_pkt_bufid_wr(i_pkt_bufid_wr),
        .iv_pkt_bufid(iv_pkt_bufid),
        .i_descriptor_valid(descriptor_valid_dat2des),
        .iv_descriptor(descriptor_dat2des),             
        .o_pkt_bufid_ack(o_pkt_bufid_ack),  
        .o_pkt_bufid_wr(o_pkt_bufid_wr),
        .ov_pkt_bufid(ov_pkt_bufid),
        .o_descriptor_wr(o_descriptor_wr),
        .ov_descriptor(ov_descriptor),
        .i_descriptor_ack(i_descriptor_ack),

        .descriptor_send_state(descriptor_send_state)
    );

data_splice data_splice_inst
    (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_data_wr(data_wr_dee2das),
        .iv_data(data_dee2das),
        .o_pkt_wr(o_pkt_wr),
        .ov_pkt(ov_pkt),
        .data_splice_state(data_splice_state)
    ); 

command_parse_and_encapsulate_dex command_parse_and_encapsulate_dex_inst
    (
        .i_clk                         (i_clk                         ),
        .i_rst_n                       (i_rst_n                       ),
        
        .iv_addr                       (iv_addr                       ),                         
        .i_addr_fixed                  (i_addr_fixed                  ),                   
        .iv_wdata                      (iv_wdata                      ),                        
        .i_wr_dex                      (i_wr_dex                      ),         
        .i_rd_dex                      (i_rd_dex                      ),         

        .o_wr_dex                      (o_wr_dex                      ),         
        .ov_addr_dex                   (ov_addr_dex                   ),      
        .o_addr_fixed_dex              (o_addr_fixed_dex              ), 
        .ov_rdata_dex                  (ov_rdata_dex                  )
    );    
endmodule