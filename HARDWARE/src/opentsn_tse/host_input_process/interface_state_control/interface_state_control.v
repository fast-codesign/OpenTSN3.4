// Copyright (C) 1953-2022 NUDT
// Verilog module name - interface_state_control 
// Version: V3.4.0.20220224
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         Network receive interface
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module interface_state_control
(
        i_clk,
        i_rst_n,
        
        i_data_wr,
        iv_data,

        iv_addr,                          
        i_addr_fixed,                    
        iv_wdata,                         
        i_wr_isc,          
        i_rd_isc,                               
        
        o_wr_isc,          
        ov_addr_isc,       
        o_addr_fixed_isc,  
        ov_rdata_isc, 
       
        i_rc_rxenable    ,
        i_st_rxenable    ,
        i_hardware_initial_finish,        

        ov_data,
        o_data_wr,
        
        ov_eth_type,        
		o_standardpkt_tsnpkt_flag
);

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
//data input
input                   i_data_wr;
input       [7:0]       iv_data;

input       [18:0]      iv_addr;                         
input                   i_addr_fixed;                   
input       [31:0]      iv_wdata;                        
input                   i_wr_isc;         
input                   i_rd_isc;         

output                  o_wr_isc;          
output     [18:0]       ov_addr_isc;       
output                  o_addr_fixed_isc;  
output     [31:0]       ov_rdata_isc;
//configuration
input                   i_rc_rxenable    ;
input                   i_st_rxenable    ;
input                   i_hardware_initial_finish; 
//user data output
output     [8:0]        ov_data;
output                  o_data_wr;
output     [15:0]       ov_eth_type;
output                  o_standardpkt_tsnpkt_flag;
// internal wire
wire       [8:0]        wv_data_htd2fts;
wire                    w_data_wr_htd2fts;

wire       [31:0]       wv_pkt_cnt_fts2cpe;
head_and_tail_distinguish head_and_tail_distinguish_inst
    (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
       
        .i_data_wr(i_data_wr),
        .iv_data(iv_data),
        
        .ov_data(wv_data_htd2fts),
        .o_data_wr(w_data_wr_htd2fts)
    );

frame_transmittion_select frame_transmittion_select_inst
    (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        
        .i_rc_rxenable    (i_rc_rxenable    ),
        .i_st_rxenable    (i_st_rxenable    ),
        .i_hardware_initial_finish(i_hardware_initial_finish),
        
        .iv_data  (wv_data_htd2fts),
        .i_data_wr(w_data_wr_htd2fts),
        
        .ov_data(ov_data),
        .o_data_wr(o_data_wr),
		.o_standardpkt_tsnpkt_flag(o_standardpkt_tsnpkt_flag),
        .ov_eth_type(ov_eth_type),
        .ov_pkt_cnt(wv_pkt_cnt_fts2cpe)
    );
command_parse_and_encapsulate_isc command_parse_and_encapsulate_isc_inst
    (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        
        .iv_addr(iv_addr),                         
        .i_addr_fixed(i_addr_fixed),                   
        .iv_wdata(iv_wdata),                        
        .i_wr_isc(i_wr_isc),         
        .i_rd_isc(i_rd_isc),         

        .o_wr_isc(o_wr_isc),         
        .ov_addr_isc(ov_addr_isc),      
        .o_addr_fixed_isc(o_addr_fixed_isc), 
        .ov_rdata_isc(ov_rdata_isc),
        
        .iv_pkt_cnt_fts2cpe(wv_pkt_cnt_fts2cpe)
    );
endmodule