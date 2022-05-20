// Copyright (C) 1953-2021 NUDT
// Verilog module name - host_input_process
// Version: V3.2.2.20210820
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         receive and process pkt from host.
//             - top module.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module host_input_process
(
        i_clk                            ,
        i_rst_n                          ,
                                         
        iv_addr                          ,      
        iv_wdata                         ,     
        i_addr_fixed                     ,     
        i_wr_frm                         ,     
        i_rd_frm                         ,
        i_wr_isc                         ,
        i_rd_isc                         ,       
        i_wr_tic                         ,
        i_rd_tic                         , 
 
        o_wr_frm                         ,     
        ov_addr_frm                      ,     
        o_addr_fixed_frm                 ,     
        ov_rdata_frm                     ,
        o_wr_isc                         ,
        ov_addr_isc                      ,
        o_addr_fixed_isc                 ,
        ov_rdata_isc                     ,                          
        o_wr_tic                         ,
        ov_addr_tic                      ,
        o_addr_fixed_tic                 ,
        ov_rdata_tic                     ,        
               
        i_data_wr                        ,
        iv_data                          ,
        
        iv_pkt_bufid                     ,
        i_pkt_bufid_wr                   ,
        o_pkt_bufid_ack                  ,                                                          
                                         
        ov_wdata                         ,
        o_data_wr                        ,
        ov_data_waddr                    ,
        i_wdata_ack                      ,
                                                                                 

        i_hardware_initial_finish        ,
        i_rc_rxenable        ,  
        i_st_rxenable        ,        
       
        iv_time_slot_period              ,
        iv_syn_clk                       ,
        iv_time_slot_length              ,
        ov_descriptor                    ,
        o_descriptor_wr                  ,
        i_descriptor_ack                 ,
             
        iv_free_bufid_num                ,
        iv_hpriority_be_threshold_value  ,
        iv_rc_threshold_value            ,
        iv_lpriority_be_threshold_value 
);
// I/O
// clk & rst
input                  i_clk                     ;
input                  i_rst_n                   ; 

input       [18:0]     iv_addr                   ;
input       [31:0]     iv_wdata                  ;
input                  i_addr_fixed              ;
input                  i_wr_frm                  ;
input                  i_rd_frm                  ;
input                  i_wr_isc                  ;
input                  i_rd_isc                  ;
input                  i_wr_tic                  ;
input                  i_rd_tic                  ;

output                 o_wr_frm                  ;
output      [18:0]     ov_addr_frm               ;
output                 o_addr_fixed_frm          ;
output      [31:0]     ov_rdata_frm              ;
output                 o_wr_isc                  ;
output      [18:0]     ov_addr_isc               ;
output                 o_addr_fixed_isc          ;
output      [31:0]     ov_rdata_isc              ; 
output                 o_wr_tic                  ;
output      [18:0]     ov_addr_tic               ;
output                 o_addr_fixed_tic          ;
output      [31:0]     ov_rdata_tic              ;           
// send pkt data from gmii     
input       [7:0]      iv_data                  ;
input                  i_data_wr                ;
// reset signal of local timer                   
  
// bufid input                                   
input      [8:0]       iv_pkt_bufid             ;
input                  i_pkt_bufid_wr           ;
output                 o_pkt_bufid_ack          ;
// pkt output                                    
output    [133:0]      ov_wdata                  ;
output                 o_data_wr                 ;
output    [15:0]       ov_data_waddr             ;
input                  i_wdata_ack               ;

input                  i_hardware_initial_finish ;
input                  i_rc_rxenable                   ;
input                  i_st_rxenable                   ;
//threshold of discard
input      [8:0]       iv_free_bufid_num              ;
input      [8:0]       iv_hpriority_be_threshold_value;
input      [8:0]       iv_rc_threshold_value          ;
input      [8:0]       iv_lpriority_be_threshold_value;


input      [10:0]       iv_time_slot_period;
input      [63:0]       iv_syn_clk         ;
input      [10:0]       iv_time_slot_length;
output     [39:0]       ov_descriptor    ;  
output                  o_descriptor_wr   ; 
input                   i_descriptor_ack ;  

///////////////////////////////////////////////////////////
wire      [8:0]        wv_data_hrx2frm               ;
wire                   w_data_wr_hrx2frm             ;
wire                   w_standardpkt_tsnpkt_flag_hrx2frm;
wire      [15:0]       wv_eth_type_hrx2frm;

wire                   w_standardpkt_tsnpkt_flag_frm2ttp;
wire                   w_replication_flag_frm2ttp       ;
wire      [47:0]       wv_tsntag_frm2ttp                ;
wire      [2:0]        wv_pkt_type_frm2ttp              ;
wire                   w_hit_frm2ttp                    ;
wire      [8:0]        wv_data_data_frm2ttp             ;
wire                   w_data_wr_frm2ttp                ;

wire                   w_standardpkt_tsnpkt_flag_ttp2tic;
wire                   w_replication_flag_ttp2tic       ;
wire      [47:0]       wv_tsntag_ttp2tic                ;
wire                   w_hit_ttp2tic                    ;
wire      [8:0]        wv_data_data_ttp2tic             ;
wire                   w_data_wr_ttp2tic                ;

wire                   w_standardpkt_tsnpkt_flag_fet2tic;
wire                   w_replication_flag_fet2tic       ;
wire      [47:0]       wv_tsntag_fet2tic                ;
wire      [15:0]       wv_eth_type_fet2tic              ;
wire                   w_hit_fet2tic                    ;
wire      [8:0]        wv_data_data_fet2tic             ;
wire                   w_data_wr_fet2tic                ;
             
interface_state_control host_rx_inst(
.i_clk                            (i_clk                          ),
.i_rst_n                          (i_rst_n                        ),

.i_rc_rxenable                    (i_rc_rxenable                    ),
.i_st_rxenable                    (i_st_rxenable                    ),
.i_hardware_initial_finish        (i_hardware_initial_finish      ),                                                          
.i_data_wr                        (i_data_wr                      ),
.iv_data                          (iv_data                        ),
                                                                
.iv_addr                          (iv_addr                        ),                         
.i_addr_fixed                     (i_addr_fixed                   ),                   
.iv_wdata                         (iv_wdata                       ),                        
.i_wr_isc                         (i_wr_isc                       ),         
.i_rd_isc                         (i_rd_isc                       ),         
                                                                  
.o_wr_isc                         (o_wr_isc                       ),         
.ov_addr_isc                      (ov_addr_isc                    ),      
.o_addr_fixed_isc                 (o_addr_fixed_isc               ), 
.ov_rdata_isc                     (ov_rdata_isc                   ), 

.ov_data                          (wv_data_hrx2frm                ),
.o_data_wr                        (w_data_wr_hrx2frm              ),
.ov_eth_type                      (wv_eth_type_hrx2frm            ),
.o_standardpkt_tsnpkt_flag        (w_standardpkt_tsnpkt_flag_hrx2frm )
);
frame_resolution_mapping frame_resolution_mapping_inst(
.i_clk                              (i_clk                          )  ,
.i_rst_n                            (i_rst_n                        )  ,
                                                                    
.iv_addr                            (iv_addr                        )  ,
.iv_wdata                           (iv_wdata                       )  ,
.i_addr_fixed                       (i_addr_fixed                   )  ,
.i_wr                               (i_wr_frm                       )  ,
.i_rd                               (i_rd_frm                       )  ,                                                             
.o_wr                               (o_wr_frm                       )  ,
.ov_addr                            (ov_addr_frm                    )  ,
.o_addr_fixed                       (o_addr_fixed_frm               )  ,
.ov_rdata                           (ov_rdata_frm                   )  ,
                                                                   
.iv_data                            (wv_data_hrx2frm                )  ,
.i_data_wr                          (w_data_wr_hrx2frm              )  ,
.i_standardpkt_tsnpkt_flag          (w_standardpkt_tsnpkt_flag_hrx2frm),
                                                                                                                                      
.o_standardpkt_tsnpkt_flag          (w_standardpkt_tsnpkt_flag_frm2ttp )  ,
.o_replication_flag                 (w_replication_flag_frm2ttp        )  ,
.ov_tsntag                          (wv_tsntag_frm2ttp                 )  ,
.ov_pkt_type                        (wv_pkt_type_frm2ttp               )  ,                                                                  
.o_hit                              (w_hit_frm2ttp                     )  ,
.ov_data                            (wv_data_data_frm2ttp              )  ,                                                                 
.o_data_wr                          (w_data_wr_frm2ttp                 )
);

tsntag_process tsntag_process_inst(
.i_clk                              (i_clk                          )  ,
.i_rst_n                            (i_rst_n                        )  ,
                                                                    
.i_standardpkt_tsnpkt_flag          (w_standardpkt_tsnpkt_flag_frm2ttp )  ,
.i_replication_flag                 (w_replication_flag_frm2ttp        )  ,
.iv_tsntag                          (wv_tsntag_frm2ttp                 )  ,
.iv_pkt_type                        (wv_pkt_type_frm2ttp               )  ,                                                                  
.i_hit                              (w_hit_frm2ttp                     )  ,
.iv_data                            (wv_data_data_frm2ttp              )  ,                                                                 
.i_data_wr                          (w_data_wr_frm2ttp                 )  ,
                                                                   
.o_standardpkt_tsnpkt_flag          (w_standardpkt_tsnpkt_flag_ttp2tic )  ,
.o_replication_flag                 (w_replication_flag_ttp2tic        )  ,
.ov_tsntag                          (wv_tsntag_ttp2tic                 )  ,                                                                 
.o_hit                              (w_hit_ttp2tic                     )  ,
.ov_data                            (wv_data_data_ttp2tic              )  ,                                                                 
.o_data_wr                          (w_data_wr_ttp2tic                 )
);

frame_ethtype frame_ethtype_inst(
.i_clk                              (i_clk                          )  ,
.i_rst_n                            (i_rst_n                        )  ,
                                                                    
.i_standardpkt_tsnpkt_flag          (w_standardpkt_tsnpkt_flag_ttp2tic )  ,
.i_replication_flag                 (w_replication_flag_ttp2tic        )  ,
.iv_tsntag                          (wv_tsntag_ttp2tic                 )  ,                                                                 
.i_hit                              (w_hit_ttp2tic                     )  ,
.iv_data                            (wv_data_data_ttp2tic              )  ,                                                                 
.i_data_wr                          (w_data_wr_ttp2tic                 )  ,
                                                                   
.o_standardpkt_tsnpkt_flag          (w_standardpkt_tsnpkt_flag_fet2tic )  ,
.o_replication_flag                 (w_replication_flag_fet2tic        )  ,
.ov_tsntag                          (wv_tsntag_fet2tic                 )  ,
.ov_eth_type                        (wv_eth_type_fet2tic               )  ,                                                                  
.o_hit                              (w_hit_fet2tic                     )  ,
.ov_data                            (wv_data_data_fet2tic              )  ,                                                                 
.o_data_wr                          (w_data_wr_fet2tic                 )
);

time_sensitive_injection_control time_sensitive_injection_control_inst(
.i_clk                      (i_clk                          )  ,
.i_rst_n                    (i_rst_n                        )  ,
                                                            
.iv_addr                    (iv_addr                        )  ,
.iv_wdata                   (iv_wdata                       )  ,
.i_addr_fixed               (i_addr_fixed                   )  ,
.i_wr                       (i_wr_tic                       )  ,
.i_rd                       (i_rd_tic                       )  ,                                                             
.o_wr                       (o_wr_tic                       )  ,
.ov_addr                    (ov_addr_tic                    )  ,
.o_addr_fixed               (o_addr_fixed_tic               )  ,
.ov_rdata                   (ov_rdata_tic                   )  ,                                                                    
                                                                                                                                                                                                                                                                                                                              
.i_standardpkt_tsnpkt_flag  (w_standardpkt_tsnpkt_flag_fet2tic )  ,
.i_replication_flag         (w_replication_flag_fet2tic        )  ,
.iv_tsntag                  (wv_tsntag_fet2tic                 )  ,
.iv_eth_type                (wv_eth_type_fet2tic               )  ,                                                                  
.i_hit                      (w_hit_fet2tic                     )  ,
.iv_data                    (wv_data_data_fet2tic              )  ,                                                                 
.i_data_wr                  (w_data_wr_fet2tic                 )  ,
                                                                   
.iv_pkt_bufid               (iv_pkt_bufid ) ,
.i_pkt_bufid_wr             (i_pkt_bufid_wr ) ,
.o_pkt_bufid_ack            (o_pkt_bufid_ack ) ,

.iv_free_bufid_num              (iv_free_bufid_num               ),
.iv_hpriority_be_threshold_value(iv_hpriority_be_threshold_value ),
.iv_rc_threshold_value          (iv_rc_threshold_value           ),
.iv_lpriority_be_threshold_value(iv_lpriority_be_threshold_value ),

.iv_time_slot_period(iv_time_slot_period )  ,
.iv_hardware_stage  ({1'b0,i_rc_rxenable, i_st_rxenable})  ,
.iv_syn_clk         (iv_syn_clk          )  ,     
.iv_time_slot_length(iv_time_slot_length )  ,
.ov_descriptor      (ov_descriptor       )  ,
.o_descriptor_wr    (o_descriptor_wr     )  ,
.i_descriptor_ack   (i_descriptor_ack    )  ,

.ov_wdata           (ov_wdata            )  ,                                                                  
.o_data_wr          (o_data_wr           )  ,
.ov_data_waddr      (ov_data_waddr       )  ,                                                                 
.i_wdata_ack        (i_wdata_ack         )
);

endmodule