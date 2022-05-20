// Copyright (C) 1953-2021 NUDT
// Verilog module name - frame_resolution_mapping
// Version: V3.2.2.20211102
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         map traffic transmitted by user into TSN traffic identificated by network.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
module frame_resolution_mapping
(
        i_clk,
        i_rst_n,
        
        iv_addr          ,  
        iv_wdata         ,  
        i_addr_fixed     ,  
        i_wr             ,  
        i_rd             ,  
                       
        o_wr             ,  
        ov_addr          ,  
        o_addr_fixed     ,  
        ov_rdata         ,          
             
        iv_data,
        i_data_wr,
		i_standardpkt_tsnpkt_flag,
              
		o_standardpkt_tsnpkt_flag,	
        o_replication_flag,
        ov_tsntag,
        ov_pkt_type,
        o_hit,        
        ov_data,
        o_data_wr     
);
// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;  
// pkt input

input       [18:0]     iv_addr                   ;
input       [31:0]     iv_wdata                  ;
input                  i_addr_fixed              ;
input                  i_wr                      ;
input                  i_rd                      ;

output                 o_wr                      ;
output      [18:0]     ov_addr                   ;
output                 o_addr_fixed              ;
output      [31:0]     ov_rdata                  ;  


input      [8:0]        iv_data;
input                   i_data_wr;
input                   i_standardpkt_tsnpkt_flag;
//output 
output                  o_standardpkt_tsnpkt_flag;
output                  o_replication_flag;
output     [47:0]       ov_tsntag;
output     [2:0]        ov_pkt_type;
output                  o_hit;
output     [8:0]        ov_data;
output                  o_data_wr;
//read ram
wire                    w_map_ram_rd_lmt2ram;
wire       [4:0]        wv_map_ram_addr_lmt2ram;
wire       [162:0]      wv_map_ram_rdata_ram2lmt;
wire                    w_map_ram_wr_lmt2ram;
wire       [162:0]      wv_map_ram_wdata_lmt2ram;                     
//five tuple
wire       [103:0]      wv_5tuple_data_mke2lmt;
wire                    w_5tuple_data_wr_mke2lmt;
//frag info
wire                    w_ip_flag_mke2lmt;
wire       [15:0]       wv_identification_mke2lmt;
wire                    w_first_fragment_mke2lmt;
wire                    w_tcp_or_udp_flag_mke2lmt;

wire                    w_standardpkt_tsnpkt_flag_mke2lmt;
wire                    w_standardpkt_tsnpkt_flag_lmt2mfo;
wire       [47:0]       rv_tsntag_lmt2mpo;
wire                    r_replication_flag;
wire                    w_hit_lmt2mfo;
wire                    w_lookup_finish_wr_lmt2mfo;

wire                    w_fifo_empty_fifo2mfo;
wire                    w_fifo_rd_mfo2fifo;
wire       [8:0]        wv_fifo_rdata_fifo2mfo;

wire       [4:0]       wv_ram_addr_rwi2ram     ;   
wire       [162:0]     wv_ram_wdata_rwi2ram    ;  
wire                   w_ram_wr_rwi2ram        ;   
wire       [162:0]     wv_ram_rdata_ram2rwi    ;  
wire                   w_ram_rd_rwi2ram        ;


command_parse_and_encapsulate_frm command_parse_and_encapsulate_frm_inst
(
.i_clk                    (i_clk                ),                
.i_rst_n                  (i_rst_n              ),      
                                                
.iv_addr                  (iv_addr              ),         
.i_addr_fixed             (i_addr_fixed         ),        
.iv_wdata                 (iv_wdata             ),         
.i_wr                     (i_wr                 ),      
.i_rd                     (i_rd                 ),      
                                                
.o_wr                     (o_wr                 ),      
.ov_addr                  (ov_addr              ),      
.o_addr_fixed             (o_addr_fixed         ),      
.ov_rdata                 (ov_rdata             ),      

.ov_ram_addr              (wv_ram_addr_rwi2ram  ),      
.ov_ram_wdata             (wv_ram_wdata_rwi2ram ),      
.o_ram_wr                 (w_ram_wr_rwi2ram     ),         
.iv_ram_rdata             (wv_ram_rdata_ram2rwi ),      
.o_ram_rd                 (w_ram_rd_rwi2ram     )             
);

map_key_extract map_key_extract_inst(
.i_clk                    (i_clk),
.i_rst_n                  (i_rst_n),

.iv_data                  (iv_data),
.i_data_wr                (i_data_wr),
.i_standardpkt_tsnpkt_flag(i_standardpkt_tsnpkt_flag),
.o_standardpkt_tsnpkt_flag(w_standardpkt_tsnpkt_flag_mke2lmt),
.ov_5tuple_data           (wv_5tuple_data_mke2lmt),
.o_5tuple_data_wr         (w_5tuple_data_wr_mke2lmt),          
.ov_identification        (wv_identification_mke2lmt),
.o_first_fragment         (w_first_fragment_mke2lmt),
.o_ip_flag                (w_ip_flag_mke2lmt),
.o_tcp_or_udp_flag        (w_tcp_or_udp_flag_mke2lmt)  
); 

lookup_map_table lookup_map_table_inst(
.i_clk                      (i_clk),
.i_rst_n                    (i_rst_n),
.i_standardpkt_tsnpkt_flag  (w_standardpkt_tsnpkt_flag_mke2lmt),
.iv_5tuple_data             (wv_5tuple_data_mke2lmt),
.i_5tuple_data_wr           (w_5tuple_data_wr_mke2lmt),
.iv_identification          (wv_identification_mke2lmt),
.i_first_fragment           (w_first_fragment_mke2lmt),
.i_ip_flag                  (w_ip_flag_mke2lmt),
.i_tcp_or_udp_flag          (w_tcp_or_udp_flag_mke2lmt),
.o_map_ram_rd               (w_map_ram_rd_lmt2ram),
.ov_map_ram_addr            (wv_map_ram_addr_lmt2ram),
.iv_map_ram_rdata           (wv_map_ram_rdata_ram2lmt),
.o_map_ram_wr               (w_map_ram_wr_lmt2ram),
.ov_map_ram_wdata           (wv_map_ram_wdata_lmt2ram),
.o_standardpkt_tsnpkt_flag  (w_standardpkt_tsnpkt_flag_lmt2mfo),
.ov_tsntag                  (rv_tsntag_lmt2mpo          ),
.o_replication_flag         (r_replication_flag         ),
.o_hit                      (w_hit_lmt2mfo              ),
.o_lookup_finish_wr         (w_lookup_finish_wr_lmt2mfo)
);

mapped_frame_outport mapped_frame_outport_inst(
.i_clk                    (i_clk),
.i_rst_n                  (i_rst_n),
                          
.iv_tsntag                (rv_tsntag_lmt2mpo ),
.i_replication_flag       (r_replication_flag ),
.i_hit                    (w_hit_lmt2mfo),
.i_lookup_finish_wr       (w_lookup_finish_wr_lmt2mfo),
.i_standardpkt_tsnpkt_flag(w_standardpkt_tsnpkt_flag_lmt2mfo),	

.i_fifo_empty             (w_fifo_empty_fifo2mfo),
.o_fifo_rd                (w_fifo_rd_mfo2fifo),
.iv_fifo_rdata            (wv_fifo_rdata_fifo2mfo),
 
.o_standardpkt_tsnpkt_flag(o_standardpkt_tsnpkt_flag),	
.o_replication_flag       (o_replication_flag ),
.ov_tsntag                (ov_tsntag),
.ov_pkt_type              (ov_pkt_type),
.o_hit                    (o_hit),        
.ov_data                  (ov_data),
.o_data_wr                (o_data_wr)
);

syncfifo_w9d128_aclr_showahead syncfifo_w9d128_aclr_showahead_inst(
.data      (iv_data), 
.wrreq     (i_data_wr),
.rdreq     (w_fifo_rd_mfo2fifo),
.clock     (i_clk),
.aclr      (!i_rst_n),
.q         (wv_fifo_rdata_fifo2mfo),   
.usedw     (),
.full      (),
.empty     (w_fifo_empty_fifo2mfo) 
);

truedualportram_w163d32 truedualportram_w163d32_inst(
.data_a    (wv_ram_wdata_rwi2ram),    //  ram_input.datain_a
.data_b    (wv_map_ram_wdata_lmt2ram),    //           .datain_b
.address_a (wv_ram_addr_rwi2ram), //           .address_a
.address_b (wv_map_ram_addr_lmt2ram), //           .address_b
.wren_a    (w_ram_wr_rwi2ram),    //           .wren_a
.wren_b    (w_map_ram_wr_lmt2ram),    //           .wren_b
.clock     (i_clk),     //           .clock
.rden_a    (w_ram_rd_rwi2ram),    //           .rden_a
.rden_b    (w_map_ram_rd_lmt2ram),    //           .rden_b
.q_a       (wv_ram_rdata_ram2rwi),       // ram_output.dataout_a
.q_b       (wv_map_ram_rdata_ram2lmt)        //           .dataout_b
);   
endmodule