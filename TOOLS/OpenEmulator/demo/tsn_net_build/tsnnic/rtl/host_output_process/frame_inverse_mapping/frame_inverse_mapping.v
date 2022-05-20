// Copyright (C) 1953-2020 NUDT
// Verilog module name - inversemap_lookup_table
// Version: inversemap_lookup_table_V1.0
// Created:
//         by - peng jintao 
//         at - 08.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         lookup inversemap table.
//             - lookup table and get dmac and outport of packet; 
//             - replace tsntag of first frag with dmac;
//             - discard the first 16B of middle frag or last frag;
//             - add 16B metadata;
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module frame_inverse_mapping
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
        
	    iv_descriptor       ,
	    i_descriptor_wr     ,
        o_descriptor_ready  ,
	   
	    ov_dmac             ,
	    ov_bufid            ,
        o_lookup_table_match_flag,
        o_dmac_replace_flag ,   
        o_descriptor_wr     ,
        i_descriptor_ready
);

// I/O
// clk & rst
input                  i_clk                             ;
input                  i_rst_n                           ;  
// pkt input                                             
input      [21:0]      iv_descriptor                     ;
input                  i_descriptor_wr                   ;
output                 o_descriptor_ready                ;
                                                         
input      [18:0]      iv_addr                           ;
input      [31:0]      iv_wdata                          ;
input                  i_addr_fixed                      ;
input                  i_wr_fim                          ;
input                  i_rd_fim                          ;
                                                         
output                 o_wr_fim                          ;
output      [18:0]     ov_addr_fim                       ;
output                 o_addr_fixed_fim                  ;
output      [31:0]     ov_rdata_fim                      ;
//result of look up table                                
output      [47:0]	   ov_dmac                           ;
output      [8:0]	   ov_bufid                          ;
output                 o_lookup_table_match_flag         ;
output                 o_dmac_replace_flag               ; 
output                 o_descriptor_wr                   ;
input                  i_descriptor_ready                ;
//read ram - portb
wire        [59:0]	   wv_inversemap_ram_rdata_ram2lit   ;
wire       	           w_inversemap_ram_rd_lit2ram       ;
wire        [7:0]	   wv_inversemap_ram_raddr_lit2ram   ;

//ram write - porta 
wire        [59:0]	   wv_inversemap_ram_wdata_rwi2ram   ;
wire        	       w_inversemap_ram_wr_rwi2ram       ;
wire        [7:0]	   wv_inversemap_ram_addr_rwi2ram    ;
wire        [59:0]     wv_inversemap_ram_rdata_ram2rwi   ;
wire                   w_inversemap_ram_rd_rwi2ram       ;
command_parse_and_encapsulate_fim command_parse_and_encapsulate_fim_inst
(
.i_clk                      (i_clk                   ),       
.i_rst_n                    (i_rst_n                 ),      
                             
.iv_addr                    (iv_addr                 ),         
.i_addr_fixed               (i_addr_fixed            ),        
.iv_wdata                   (iv_wdata                ),         
.i_wr_fim                   (i_wr_fim                ),      
.i_rd_fim                   (i_rd_fim                ),      
                             
.o_wr_fim                   (o_wr_fim                ),      
.ov_addr_fim                (ov_addr_fim             ),      
.o_addr_fixed_fim           (o_addr_fixed_fim        ),      
.ov_rdata_fim               (ov_rdata_fim            ),      
                             
.ov_inversemap_ram_wdata    (wv_inversemap_ram_wdata_rwi2ram ),
.ov_inversemap_ram_wr       (w_inversemap_ram_wr_rwi2ram    ),
.ov_inversemap_ram_addr     (wv_inversemap_ram_addr_rwi2ram  ),
.iv_inversemap_ram_rdata    (wv_inversemap_ram_rdata_ram2rwi ),
.ov_inversemap_ram_rd       (w_inversemap_ram_rd_rwi2ram    )       
);
lookup_inversemapping_table lookup_inversemapping_table_inst(
.i_clk                    (i_clk),
.i_rst_n                  (i_rst_n),

.iv_descriptor            (iv_descriptor),
.i_descriptor_wr          (i_descriptor_wr),
.o_descriptor_ready       (o_descriptor_ready),

.iv_inversemap_ram_rdata  (wv_inversemap_ram_rdata_ram2lit),
.o_inversemap_ram_rd      (w_inversemap_ram_rd_lit2ram),
.ov_inversemap_ram_raddr  (wv_inversemap_ram_raddr_lit2ram),

.ov_dmac                  (ov_dmac),
.ov_bufid                 (ov_bufid),
.o_lookup_table_match_flag(o_lookup_table_match_flag),
.o_dmac_replace_flag      (o_dmac_replace_flag), 
.o_descriptor_wr          (o_descriptor_wr),
.i_descriptor_ready       (i_descriptor_ready)
);

truedualportram_sclock_outputaclr_w60d32 inversemap_map_table
(
.address_a(wv_inversemap_ram_addr_rwi2ram),
.address_b(wv_inversemap_ram_raddr_lit2ram),
.clock(i_clk),
.aclr(!i_rst_n),
.data_a(wv_inversemap_ram_wdata_rwi2ram),
.data_b(60'b0),
.rden_a(w_inversemap_ram_rd_rwi2ram),
.rden_b(w_inversemap_ram_rd_lit2ram),
.wren_a(w_inversemap_ram_wr_rwi2ram),
.wren_b(1'b0),
.q_a(wv_inversemap_ram_rdata_ram2rwi),
.q_b(wv_inversemap_ram_rdata_ram2lit)
);
endmodule