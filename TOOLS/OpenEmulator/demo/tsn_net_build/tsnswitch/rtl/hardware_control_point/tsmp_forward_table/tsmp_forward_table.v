// Copyright (C) 1953-2022 NUDT
// Verilog module name - tsmp_forward_table 
// Version: V3.4.0.20220225
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         use RAM to cahce the forward table
//         lookup table 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tsmp_forward_table
(
        i_clk                ,
        i_rst_n              ,
        
        iv_hcp_mid      ,
              
        iv_addr              , 
        iv_wdata             , 
        i_addr_fixed         , 
        i_wr                 , 
        i_rd                 ,                
        o_wr                 , 
        ov_addr              , 
        o_addr_fixed         , 
        ov_rdata             , 

        i_tsmp_lookup_table_key_wr       ,
        iv_tsmp_lookup_table_key         ,
        ov_tsmp_lookup_table_outport     ,
        o_tsmp_lookup_table_outport_wr   	   
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;

input     [11:0]       iv_hcp_mid;
//lookup table RAM
input      [18:0]      iv_addr              ;
input      [31:0]      iv_wdata             ;
input                  i_addr_fixed         ;
input                  i_wr                 ;
input                  i_rd                 ;            
output                 o_wr           ;
output     [18:0]      ov_addr        ;
output                 o_addr_fixed   ;
output     [31:0]      ov_rdata       ;
//lookup table RAM
input                  i_tsmp_lookup_table_key_wr       ;
input      [47:0]      iv_tsmp_lookup_table_key         ;
output     [32:0]      ov_tsmp_lookup_table_outport     ;
output                 o_tsmp_lookup_table_outport_wr   ;

wire       [11:0]      wv_tsmpforwardram_addr_cpe2ram   ;
wire       [33:0]      wv_tsmpforwardram_wdata_cpe2ram  ;
wire                   w_tsmpforwardram_wr_cpe2ram      ;
wire       [33:0]      wv_tsmpforwardram_rdata_ram2cpe  ;
wire                   w_tsmpforwardram_rd_cpe2ram      ;

wire       [11:0]      wv_ram_raddr_b;
wire                   w_ram_rd_b;
wire       [33:0]      wv_ram_rdata_b;
command_parse_and_encapsulate_tft command_parse_and_encapsulate_tft_inst
(
.i_clk                            (i_clk                ),
.i_rst_n                          (i_rst_n              ),

.iv_addr                          (iv_addr              ),                         
.i_addr_fixed                     (i_addr_fixed         ),                   
.iv_wdata                         (iv_wdata             ),                        
.i_wr                             (i_wr                 ),         
.i_rd                             (i_rd                 ),        
                                                  
.o_wr                             (o_wr              ),
.ov_addr                          (ov_addr           ),
.o_addr_fixed                     (o_addr_fixed      ), 
.ov_rdata                         (ov_rdata          ),

.ov_tsmpforwardram_addr            (wv_tsmpforwardram_addr_cpe2ram   ),
.ov_tsmpforwardram_wdata           (wv_tsmpforwardram_wdata_cpe2ram  ),
.o_tsmpforwardram_wr               (w_tsmpforwardram_wr_cpe2ram      ),
.iv_tsmpforwardram_rdata           (wv_tsmpforwardram_rdata_ram2cpe  ),
.o_tsmpforwardram_rd               (w_tsmpforwardram_rd_cpe2ram      )
);
mid_lookup_table mid_lookup_table_inst
(
.i_clk                            (i_clk                          ),
.i_rst_n                          (i_rst_n                        ),

.iv_hcp_mid                       (iv_hcp_mid                     ),
                                   
.i_tsmp_lookup_table_key_wr       (i_tsmp_lookup_table_key_wr     ),
.iv_tsmp_lookup_table_key         (iv_tsmp_lookup_table_key       ),
.ov_tsmp_lookup_table_outport     (ov_tsmp_lookup_table_outport   ),
.o_tsmp_lookup_table_outport_wr   (o_tsmp_lookup_table_outport_wr ),
                                   
.ov_ram_raddr                     (wv_ram_raddr_b                   ),
.o_ram_rd                         (w_ram_rd_b                       ),
.iv_ram_rdata		              (wv_ram_rdata_b		            )
);
truedualportram_singleclock_rdenab_outputaclr_w34d4096 truedualportram_singleclock_rdenab_outputaclr_w34d4096_inst(
.aclr                          (!i_rst_n),
                              
.address_a                     (wv_tsmpforwardram_addr_cpe2ram),
.address_b                     (wv_ram_raddr_b),
                             
.clock                         (i_clk),
                             
.data_a                        (wv_tsmpforwardram_wdata_cpe2ram),
.data_b                        (34'h0),
                              
.rden_a                        (w_tsmpforwardram_rd_cpe2ram),
.rden_b                        (w_ram_rd_b),
                             
.wren_a                        (w_tsmpforwardram_wr_cpe2ram),
.wren_b                        (1'b0),
                              
.q_a                           (wv_tsmpforwardram_rdata_ram2cpe),
.q_b                           (wv_ram_rdata_b)
);
endmodule