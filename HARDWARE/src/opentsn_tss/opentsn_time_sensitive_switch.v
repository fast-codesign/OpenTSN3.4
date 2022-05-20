// Copyright (C) 1953-2022 NUDT
// Verilog module name - opentsn_time_sensitive_switch 
// Version: V3.4.0.20220225
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:        
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module opentsn_time_sensitive_switch
(
       i_clk,
       i_rst_n,
       
       ov_gmii_txd_p0,
       o_gmii_tx_en_p0,

       ov_gmii_txd_p1,
       o_gmii_tx_en_p1,
       
       ov_gmii_txd_p2,
       o_gmii_tx_en_p2,
       
       ov_gmii_txd_p3,
       o_gmii_tx_en_p3,
       
       ov_gmii_txd_p4,
       o_gmii_tx_en_p4,

       ov_gmii_txd_p5,
       o_gmii_tx_en_p5,
       
       ov_gmii_txd_p6,
       o_gmii_tx_en_p6,
       
       ov_gmii_txd_p7,
       o_gmii_tx_en_p7,
       
       ov_gmii_txd_p8,
       o_gmii_tx_en_p8,     
       //Network input top module
       i_gmii_dv_p0,
       iv_gmii_rxd_p0,

       i_gmii_dv_p1,
       iv_gmii_rxd_p1,

       i_gmii_dv_p2,
       iv_gmii_rxd_p2,

       i_gmii_dv_p3,
       iv_gmii_rxd_p3,

       i_gmii_dv_p4,
       iv_gmii_rxd_p4,

       i_gmii_dv_p5,
       iv_gmii_rxd_p5,

       i_gmii_dv_p6,
       iv_gmii_rxd_p6,

       i_gmii_dv_p7,
       iv_gmii_rxd_p7,

       i_gmii_dv_p8,
       iv_gmii_rxd_p8,   

       iv_local_id                    ,
       ov_tss_ver                     ,
       i_rc_rxenable                  ,
       i_st_rxenable                  ,
       o_tsmp_lookup_table_key_wr     ,
       ov_tsmp_lookup_table_key       ,
       iv_tsmp_lookup_table_outport   ,
       i_tsmp_lookup_table_outport_wr ,  
       
       iv_command             ,   
       i_command_wr           ,  
       ov_command_ack         ,  
       o_command_ack_wr       ,

       ov_addr_cit2all        ,
       ov_wdata_cit2all       ,
       o_addr_fixed_cit2all   , 
       
       o_wr_stc               ,
       o_rd_stc               ,       
       i_wr_stc               ,
       iv_addr_stc            ,
       i_addr_fixed_stc       ,
       iv_rdata_stc           ,
       
       o_wr_cfu               ,
       o_rd_cfu               ,          
       i_wr_cfu               ,
       iv_addr_cfu            ,
       i_addr_fixed_cfu       ,
       iv_rdata_cfu           ,
       
       o_wr_cdc_p8            , 
       o_rd_cdc_p8            ,
       i_wr_cdc_p8            ,
       iv_addr_cdc_p8         ,
       i_addr_fixed_cdc_p8    ,
       iv_rdata_cdc_p8        ,
                 
       o_wr_cdc_p0            ,
       o_rd_cdc_p0            ,
       i_wr_cdc_p0            ,
       iv_addr_cdc_p0         ,
       i_addr_fixed_cdc_p0    ,
       iv_rdata_cdc_p0        ,
                 
       o_wr_cdc_p1            ,
       o_rd_cdc_p1            ,
       i_wr_cdc_p1            ,
       iv_addr_cdc_p1         ,
       i_addr_fixed_cdc_p1    ,
       iv_rdata_cdc_p1        ,
                  
       o_wr_cdc_p2            ,
       o_rd_cdc_p2            ,
       i_wr_cdc_p2            ,
       iv_addr_cdc_p2         ,
       i_addr_fixed_cdc_p2    ,
       iv_rdata_cdc_p2        ,
                  
       o_wr_cdc_p3            ,
       o_rd_cdc_p3            ,
       i_wr_cdc_p3            ,
       iv_addr_cdc_p3         ,
       i_addr_fixed_cdc_p3    ,
       iv_rdata_cdc_p3        ,
                      
       o_wr_cdc_p4            ,
       o_rd_cdc_p4            ,
       i_wr_cdc_p4            ,
       iv_addr_cdc_p4         ,
       i_addr_fixed_cdc_p4    ,
       iv_rdata_cdc_p4        ,
                      
       o_wr_cdc_p5            ,
       o_rd_cdc_p5            ,
       i_wr_cdc_p5            ,
       iv_addr_cdc_p5         ,
       i_addr_fixed_cdc_p5    ,
       iv_rdata_cdc_p5        ,
                      
       o_wr_cdc_p6            ,
       o_rd_cdc_p6            ,
       i_wr_cdc_p6            ,
       iv_addr_cdc_p6         ,
       i_addr_fixed_cdc_p6    ,
       iv_rdata_cdc_p6        ,
                        
       o_wr_cdc_p7            ,
       o_rd_cdc_p7            ,
       i_wr_cdc_p7            ,
       iv_addr_cdc_p7         ,
       i_addr_fixed_cdc_p7    ,
       iv_rdata_cdc_p7        ,   

       iv_syn_clk             ,       
       ov_schedule_period     ,
       ov_time_slot_length       
       
);
//I/O
input                   i_clk;                   //125Mhz
input                   i_rst_n;
// network output       
output     [7:0]        ov_gmii_txd_p0;
output                  o_gmii_tx_en_p0;
                        
output     [7:0]        ov_gmii_txd_p1;
output                  o_gmii_tx_en_p1;
                        
output     [7:0]        ov_gmii_txd_p2;
output                  o_gmii_tx_en_p2; 
                        
output     [7:0]        ov_gmii_txd_p3;
output                  o_gmii_tx_en_p3;
                        
output     [7:0]        ov_gmii_txd_p4;
output                  o_gmii_tx_en_p4;
                        
output     [7:0]        ov_gmii_txd_p5;
output                  o_gmii_tx_en_p5;
                        
output     [7:0]        ov_gmii_txd_p6;
output                  o_gmii_tx_en_p6;
                        
output     [7:0]        ov_gmii_txd_p7;
output                  o_gmii_tx_en_p7;
                        
output     [7:0]        ov_gmii_txd_p8;
output                  o_gmii_tx_en_p8;
//network input
input                   i_gmii_dv_p0;
input      [7:0]        iv_gmii_rxd_p0;

input                   i_gmii_dv_p1;
input      [7:0]        iv_gmii_rxd_p1;

input                   i_gmii_dv_p2;
input      [7:0]        iv_gmii_rxd_p2;

input                   i_gmii_dv_p3;
input      [7:0]        iv_gmii_rxd_p3;

input                   i_gmii_dv_p4;
input      [7:0]        iv_gmii_rxd_p4;

input                   i_gmii_dv_p5;
input      [7:0]        iv_gmii_rxd_p5;

input                   i_gmii_dv_p6;
input      [7:0]        iv_gmii_rxd_p6;

input                   i_gmii_dv_p7;
input      [7:0]        iv_gmii_rxd_p7;

input                   i_gmii_dv_p8;
input      [7:0]        iv_gmii_rxd_p8;

input      [11:0]       iv_local_id                   ;
output     [31:0]       ov_tss_ver                    ;
input                   i_rc_rxenable                 ;
input                   i_st_rxenable                 ;
output                  o_tsmp_lookup_table_key_wr    ;
output     [47:0]       ov_tsmp_lookup_table_key      ;
input      [32:0]       iv_tsmp_lookup_table_outport  ;
input                   i_tsmp_lookup_table_outport_wr;

input      [63:0]       iv_command                       ;
input                   i_command_wr                     ;
output     [63:0]       ov_command_ack                   ; 
output                  o_command_ack_wr                 ;
                                                         
output     [18:0]       ov_addr_cit2all                  ;
output     [31:0]       ov_wdata_cit2all                 ;
output                  o_addr_fixed_cit2all             ;
//from stc 
output                  o_wr_stc                         ; 
output                  o_rd_stc                         ;
input                   i_wr_stc                         ;
input        [18:0]     iv_addr_stc                      ;
input                   i_addr_fixed_stc                 ;
input        [31:0]     iv_rdata_stc                     ;

output                  o_wr_cfu                         ;
output                  o_rd_cfu                         ;
input                   i_wr_cfu                         ;
input        [18:0]     iv_addr_cfu                      ;
input                   i_addr_fixed_cfu                 ;
input        [31:0]     iv_rdata_cfu                     ;

output                  o_wr_cdc_p8                      ;
output                  o_rd_cdc_p8                      ;
input                   i_wr_cdc_p8                      ; 
input        [18:0]     iv_addr_cdc_p8                   ; 
input                   i_addr_fixed_cdc_p8              ; 
input        [31:0]     iv_rdata_cdc_p8                  ; 
                               
output                  o_wr_cdc_p0                      ;
output                  o_rd_cdc_p0                      ;
input                   i_wr_cdc_p0                      ; 
input        [18:0]     iv_addr_cdc_p0                   ; 
input                   i_addr_fixed_cdc_p0              ; 
input        [31:0]     iv_rdata_cdc_p0                  ; 
                                
output                  o_wr_cdc_p1                      ;
output                  o_rd_cdc_p1                      ;
input                   i_wr_cdc_p1                      ; 
input        [18:0]     iv_addr_cdc_p1                   ; 
input                   i_addr_fixed_cdc_p1              ; 
input        [31:0]     iv_rdata_cdc_p1                  ; 
                                 
output                  o_wr_cdc_p2                      ;
output                  o_rd_cdc_p2                      ;
input                   i_wr_cdc_p2                      ; 
input        [18:0]     iv_addr_cdc_p2                   ; 
input                   i_addr_fixed_cdc_p2              ; 
input        [31:0]     iv_rdata_cdc_p2                  ; 
                                 
output                  o_wr_cdc_p3                      ;
output                  o_rd_cdc_p3                      ;
input                   i_wr_cdc_p3                      ; 
input        [18:0]     iv_addr_cdc_p3                   ; 
input                   i_addr_fixed_cdc_p3              ; 
input        [31:0]     iv_rdata_cdc_p3                  ; 
                                  
output                  o_wr_cdc_p4                      ;
output                  o_rd_cdc_p4                      ;
input                   i_wr_cdc_p4                      ; 
input        [18:0]     iv_addr_cdc_p4                   ; 
input                   i_addr_fixed_cdc_p4              ; 
input        [31:0]     iv_rdata_cdc_p4                  ;
                                  
output                  o_wr_cdc_p5                      ;
output                  o_rd_cdc_p5                      ;
input                   i_wr_cdc_p5                      ; 
input        [18:0]     iv_addr_cdc_p5                   ; 
input                   i_addr_fixed_cdc_p5              ; 
input        [31:0]     iv_rdata_cdc_p5                  ;
                              
output                  o_wr_cdc_p6                      ;
output                  o_rd_cdc_p6                      ;
input                   i_wr_cdc_p6                      ; 
input        [18:0]     iv_addr_cdc_p6                   ; 
input                   i_addr_fixed_cdc_p6              ; 
input        [31:0]     iv_rdata_cdc_p6                  ; 
                               
output                  o_wr_cdc_p7                      ;
output                  o_rd_cdc_p7                      ;
input                   i_wr_cdc_p7                      ; 
input        [18:0]     iv_addr_cdc_p7                   ; 
input                   i_addr_fixed_cdc_p7              ; 
input        [31:0]     iv_rdata_cdc_p7                  ; 

input        [63:0]     iv_syn_clk                       ;
output       [10:0]     ov_schedule_period               ;
output       [10:0]     ov_time_slot_length              ;
//*******************************
//              nip
//*******************************
wire                    w_hardware_initial_finish;

wire       [4:0]        wv_dmacram_addr_msl2flt                  ;
wire       [56:0]       wv_dmacram_wdata_msl2flt                 ;
wire                    w_dmacram_wr_msl2flt                     ;    
//port0
wire       [8:0]        wv_bufid_pcb2nip_0;		
wire                    w_bufid_wr_pcb2nip_0;	
wire                    w_bufid_ack_nip2pcb_0;	

wire       [71:0]       wv_descriptor_nip2flt_0;   
wire                    w_descriptor_wr_nip2flt_0; 
wire                    w_descriptor_ack_flt2nip_0;

wire       [133:0]      wv_pkt_data_pcb2nip_0;		
wire                    w_pkt_data_wr_pcb2nip_0;	
wire       [15:0]       wv_pkt_addr_pcb2nip_0;		
wire                    w_pkt_ack_pcb2nip_0;		
//port1
wire       [8:0]        wv_bufid_pcb2nip_1;
wire                    w_bufid_wr_pcb2nip_1;
wire                    w_bufid_ack_nip2pcb_1;

wire       [71:0]       wv_descriptor_nip2flt_1;
wire                    w_descriptor_wr_nip2flt_1;
wire                    w_descriptor_ack_flt2nip_1;

wire       [133:0]      wv_pkt_data_pcb2nip_1;
wire                    w_pkt_data_wr_pcb2nip_1;
wire       [15:0]       wv_pkt_addr_pcb2nip_1;
wire                    w_pkt_ack_pcb2nip_1;
//port2
wire       [8:0]        wv_bufid_pcb2nip_2;
wire                    w_bufid_wr_pcb2nip_2;
wire                    w_bufid_ack_nip2pcb_2;

wire       [71:0]       wv_descriptor_nip2flt_2;
wire                    w_descriptor_wr_nip2flt_2;
wire                    w_descriptor_ack_flt2nip_2;

wire       [133:0]      wv_pkt_data_pcb2nip_2;
wire                    w_pkt_data_wr_pcb2nip_2;
wire       [15:0]       wv_pkt_addr_pcb2nip_2;
wire                    w_pkt_ack_pcb2nip_2;
//port3
wire       [8:0]        wv_bufid_pcb2nip_3;
wire                    w_bufid_wr_pcb2nip_3;
wire                    w_bufid_ack_nip2pcb_3;

wire       [71:0]       wv_descriptor_nip2flt_3;
wire                    w_descriptor_wr_nip2flt_3;
wire                    w_descriptor_ack_flt2nip_3;

wire       [133:0]      wv_pkt_data_pcb2nip_3;
wire                    w_pkt_data_wr_pcb2nip_3;
wire       [15:0]       wv_pkt_addr_pcb2nip_3;
wire                    w_pkt_ack_pcb2nip_3;
//port4
wire       [8:0]        wv_bufid_pcb2nip_4;
wire                    w_bufid_wr_pcb2nip_4;
wire                    w_bufid_ack_nip2pcb_4;

wire       [71:0]       wv_descriptor_nip2flt_4;
wire                    w_descriptor_wr_nip2flt_4;
wire                    w_descriptor_ack_flt2nip_4;

wire       [133:0]      wv_pkt_data_pcb2nip_4;
wire                    w_pkt_data_wr_pcb2nip_4;
wire       [15:0]       wv_pkt_addr_pcb2nip_4;
wire                    w_pkt_ack_pcb2nip_4;
//port5
wire       [8:0]        wv_bufid_pcb2nip_5;
wire                    w_bufid_wr_pcb2nip_5;
wire                    w_bufid_ack_hrp2nip_5;

wire       [71:0]       wv_descriptor_pcb2nip_5;
wire                    w_descriptor_wr_pcb2nip_5;
wire                    w_descriptor_ack_pcb2nip_5;

wire       [133:0]      wv_pkt_data_pcb2nip_5;
wire                    w_pkt_data_wr_pcb2nip_5;
wire       [15:0]       wv_pkt_addr_pcb2nip_5;
wire                    w_pkt_ack_pcb2nip_5;
//port6
wire       [8:0]        wv_bufid_pcb2nip_6;
wire                    w_bufid_wr_pcb2nip_6;
wire                    w_bufid_ack_hrp2nip_6;

wire       [71:0]       wv_descriptor_pcb2nip_6;
wire                    w_descriptor_wr_pcb2nip_6;
wire                    w_descriptor_ack_pcb2nip_6;

wire       [133:0]      wv_pkt_data_pcb2nip_6;
wire                    w_pkt_data_wr_pcb2nip_6;
wire       [15:0]       wv_pkt_addr_pcb2nip_6;
wire                    w_pkt_ack_pcb2nip_6;
//port7
wire       [8:0]        wv_bufid_pcb2nip_7;
wire                    w_bufid_wr_pcb2nip_7;
wire                    w_bufid_ack_hrp2nip_7;

wire       [71:0]       wv_descriptor_pcb2nip_7;
wire                    w_descriptor_wr_pcb2nip_7;
wire                    w_descriptor_ack_pcb2nip_7;

wire       [133:0]      wv_pkt_data_pcb2nip_7;
wire                    w_pkt_data_wr_pcb2nip_7;
wire       [15:0]       wv_pkt_addr_pcb2nip_7;
wire                    w_pkt_ack_pcb2nip_7;
//port8
wire       [8:0]        wv_bufid_pcb2nip_8;
wire                    w_bufid_wr_pcb2nip_8;
wire                    w_bufid_ack_hrp2nip_8;

wire       [71:0]       wv_descriptor_pcb2nip_8;
wire                    w_descriptor_wr_pcb2nip_8;
wire                    w_descriptor_ack_pcb2nip_8;

wire       [133:0]      wv_pkt_data_pcb2nip_8;
wire                    w_pkt_data_wr_pcb2nip_8;
wire       [15:0]       wv_pkt_addr_pcb2nip_8;
wire                    w_pkt_ack_pcb2nip_8;
//*******************************
//              flt
//*******************************
wire       [8:0]        wv_pkt_bufid_flt2pcb;    
wire                    w_pkt_bufid_wr_flt2pcb;  
wire       [3:0]        wv_pkt_bufid_cnt_flt2pcb;
//port0
wire       [8:0]        wv_pkt_bufid_flt2nop_0;
wire       [2:0]        wv_pkt_type_flt2nop_0;
wire                    w_pkt_bufid_wr_flt2nop_0;
//port1
wire       [8:0]        wv_pkt_bufid_flt2nop_1;
wire       [2:0]        wv_pkt_type_flt2nop_1;
wire                    w_pkt_bufid_wr_flt2nop_1;
//port2
wire       [8:0]        wv_pkt_bufid_flt2nop_2;
wire       [2:0]        wv_pkt_type_flt2nop_2;
wire                    w_pkt_bufid_wr_flt2nop_2;
//port3
wire       [8:0]        wv_pkt_bufid_flt2nop_3;
wire       [2:0]        wv_pkt_type_flt2nop_3;
wire                    w_pkt_bufid_wr_flt2nop_3;
//port4
wire       [8:0]        wv_pkt_bufid_flt2nop_4;
wire       [2:0]        wv_pkt_type_flt2nop_4;
wire                    w_pkt_bufid_wr_flt2nop_4;
//port5
wire       [8:0]        wv_pkt_bufid_flt2nop_5;
wire       [2:0]        wv_pkt_type_flt2nop_5;
wire                    w_pkt_bufid_wr_flt2nop_5;
//port6
wire       [8:0]        wv_pkt_bufid_flt2nop_6;
wire       [2:0]        wv_pkt_type_flt2nop_6;
wire                    w_pkt_bufid_wr_flt2nop_6;
//port7
wire       [8:0]        wv_pkt_bufid_flt2nop_7;
wire       [2:0]        wv_pkt_type_flt2nop_7;
wire                    w_pkt_bufid_wr_flt2nop_7;
//port8  HCP
wire       [8:0]        wv_pkt_bufid_flt2nop_8;
wire       [2:0]        wv_pkt_type_flt2nop_8;
wire                    w_mac_entry_hit_8;
wire       [3:0]        wv_pkt_inport_8  ;
wire                    w_pkt_bufid_wr_flt2nop_8;
//*******************************
//             nop
//*******************************
//port0
wire       [8:0]        wv_pkt_bufid_nop2pcb_0;    
wire                    w_pkt_bufid_wr_nop2pcb_0;  
wire                    w_pkt_bufid_ack_pcb2nop_0; 

wire       [15:0]       wv_pkt_raddr_nop2pcb_0;  
wire                    w_pkt_rd_nop2pcb_0;       
wire                    w_pkt_raddr_ack_pcb2nop_0;

wire       [133:0]      wv_pkt_data_pcb2nop_0;  
wire                    w_pkt_data_wr_pcb2nop_0;
//port1
wire       [8:0]        wv_pkt_bufid_nop2pcb_1;    
wire                    w_pkt_bufid_wr_nop2pcb_1;  
wire                    w_pkt_bufid_ack_pcb2nop_1; 

wire       [15:0]       wv_pkt_raddr_nop2pcb_1;      
wire                    w_pkt_rd_nop2pcb_1;       
wire                    w_pkt_raddr_ack_pcb2nop_1;

wire       [133:0]      wv_pkt_data_pcb2nop_1;  
wire                    w_pkt_data_wr_pcb2nop_1;
//port2
wire       [8:0]        wv_pkt_bufid_nop2pcb_2;    
wire                    w_pkt_bufid_wr_nop2pcb_2;  
wire                    w_pkt_bufid_ack_pcb2nop_2; 

wire       [15:0]       wv_pkt_raddr_nop2pcb_2;     
wire                    w_pkt_rd_nop2pcb_2;       
wire                    w_pkt_raddr_ack_pcb2nop_2;

wire       [133:0]      wv_pkt_data_pcb2nop_2;  
wire                    w_pkt_data_wr_pcb2nop_2;
//port3
wire       [8:0]        wv_pkt_bufid_nop2pcb_3;    
wire                    w_pkt_bufid_wr_nop2pcb_3;  
wire                    w_pkt_bufid_ack_pcb2nop_3; 

wire       [15:0]       wv_pkt_raddr_nop2pcb_3;     
wire                    w_pkt_rd_nop2pcb_3;       
wire                    w_pkt_raddr_ack_pcb2nop_3;

wire       [133:0]      wv_pkt_data_pcb2nop_3;  
wire                    w_pkt_data_wr_pcb2nop_3;
//port4
wire       [8:0]        wv_pkt_bufid_nop2pcb_4;    
wire                    w_pkt_bufid_wr_nop2pcb_4;  
wire                    w_pkt_bufid_ack_pcb2nop_4; 

wire       [15:0]       wv_pkt_raddr_nop2pcb_4;    
wire                    w_pkt_rd_nop2pcb_4;       
wire                    w_pkt_raddr_ack_pcb2nop_4;

wire       [133:0]      wv_pkt_data_pcb2nop_4;  
wire                    w_pkt_data_wr_pcb2nop_4;
//port5
wire       [8:0]        wv_pkt_bufid_nop2pcb_5;    
wire                    w_pkt_bufid_wr_nop2pcb_5;  
wire                    w_pkt_bufid_ack_pcb2nop_5; 

wire       [15:0]       wv_pkt_raddr_nop2pcb_5;   //11->15   
wire                    w_pkt_rd_nop2pcb_5;       
wire                    w_pkt_raddr_ack_pcb2nop_5;

wire       [133:0]      wv_pkt_data_pcb2nop_5;  
wire                    w_pkt_data_wr_pcb2nop_5;
//port6
wire       [8:0]        wv_pkt_bufid_nop2pcb_6;    
wire                    w_pkt_bufid_wr_nop2pcb_6;  
wire                    w_pkt_bufid_ack_pcb2nop_6; 

wire       [15:0]       wv_pkt_raddr_nop2pcb_6;    //11->15  
wire                    w_pkt_rd_nop2pcb_6;       
wire                    w_pkt_raddr_ack_pcb2nop_6;

wire       [133:0]      wv_pkt_data_pcb2nop_6;  
wire                    w_pkt_data_wr_pcb2nop_6;
//port7
wire       [8:0]        wv_pkt_bufid_nop2pcb_7;    
wire                    w_pkt_bufid_wr_nop2pcb_7;  
wire                    w_pkt_bufid_ack_pcb2nop_7; 

wire       [15:0]       wv_pkt_raddr_nop2pcb_7;    //11->15  
wire                    w_pkt_rd_nop2pcb_7;       
wire                    w_pkt_raddr_ack_pcb2nop_7;

wire       [133:0]      wv_pkt_data_pcb2nop_7;  
wire                    w_pkt_data_wr_pcb2nop_7;
//port8
wire       [8:0]        wv_pkt_bufid_nop2pcb_8;    
wire                    w_pkt_bufid_wr_nop2pcb_8;  
wire                    w_pkt_bufid_ack_pcb2nop_8; 

wire       [15:0]       wv_pkt_raddr_nop2pcb_8;    //11->15  
wire                    w_pkt_rd_nop2pcb_8;       
wire                    w_pkt_raddr_ack_pcb2nop_8;

wire       [133:0]      wv_pkt_data_pcb2nop_8;  
wire                    w_pkt_data_wr_pcb2nop_8;
//*******************************
//             CPA
//*******************************                                                       //                     
//port0              
wire       [3:0]        wv_descriptor_extract_state_p0_nip2cpa;  
wire       [1:0]        wv_descriptor_send_state_p0_nip2cpa;     
wire       [1:0]        wv_data_splice_state_p0_nip2cpa;         
wire       [1:0]        wv_input_buf_interface_state_p0_nip2cpa; 
//port1               
wire       [3:0]        wv_descriptor_extract_state_p1_nip2cpa;  
wire       [1:0]        wv_descriptor_send_state_p1_nip2cpa;     
wire       [1:0]        wv_data_splice_state_p1_nip2cpa;         
wire       [1:0]        wv_input_buf_interface_state_p1_nip2cpa; 
//port2              
wire       [3:0]        wv_descriptor_extract_state_p2_nip2cpa;  
wire       [1:0]        wv_descriptor_send_state_p2_nip2cpa;     
wire       [1:0]        wv_data_splice_state_p2_nip2cpa;         
wire       [1:0]        wv_input_buf_interface_state_p2_nip2cpa; 
//port3       
wire       [3:0]        wv_descriptor_extract_state_p3_nip2cpa;  
wire       [1:0]        wv_descriptor_send_state_p3_nip2cpa;     
wire       [1:0]        wv_data_splice_state_p3_nip2cpa;         
wire       [1:0]        wv_input_buf_interface_state_p3_nip2cpa; 
//port4                
wire       [3:0]        wv_descriptor_extract_state_p4_nip2cpa;  
wire       [1:0]        wv_descriptor_send_state_p4_nip2cpa;     
wire       [1:0]        wv_data_splice_state_p4_nip2cpa;         
wire       [1:0]        wv_input_buf_interface_state_p4_nip2cpa; 
//port5                
wire       [3:0]        wv_descriptor_extract_state_p5_nip2cpa;  
wire       [1:0]        wv_descriptor_send_state_p5_nip2cpa;     
wire       [1:0]        wv_data_splice_state_p5_nip2cpa;         
wire       [1:0]        wv_input_buf_interface_state_p5_nip2cpa; 
//port6          
wire       [3:0]        wv_descriptor_extract_state_p6_nip2cpa;  
wire       [1:0]        wv_descriptor_send_state_p6_nip2cpa;     
wire       [1:0]        wv_data_splice_state_p6_nip2cpa;         
wire       [1:0]        wv_input_buf_interface_state_p6_nip2cpa; 
//port7         
wire       [3:0]        wv_descriptor_extract_state_p7_nip2cpa;  
wire       [1:0]        wv_descriptor_send_state_p7_nip2cpa;     
wire       [1:0]        wv_data_splice_state_p7_nip2cpa;         
wire       [1:0]        wv_input_buf_interface_state_p7_nip2cpa; 
//port8          
wire       [3:0]        wv_descriptor_extract_state_p8_nip2cpa;  
wire       [1:0]        wv_descriptor_send_state_p8_nip2cpa;     
wire       [1:0]        wv_data_splice_state_p8_nip2cpa;         
wire       [1:0]        wv_input_buf_interface_state_p8_nip2cpa; 

wire       [3:0]        wv_pkt_write_state_pcb2cpa;      
wire       [3:0]        wv_pcb_pkt_read_state_pcb2cpa;   
wire       [3:0]        wv_address_write_state_pcb2cpa;  
wire       [3:0]        wv_address_read_state_pcb2cpa;   
wire       [8:0]        wv_free_buf_fifo_rdusedw_pcb2cpa;
//police threshold
wire       [8:0]        wv_be_threshold_value_grm2nip            ;
wire       [8:0]        wv_rc_threshold_value_grm2nip            ;
wire       [8:0]        wv_standardpkt_threshold_value_grm2nip   ;
wire                    w_qbv_or_qch_grm2nop          ;
//wire       [10:0]       wv_time_slot_length_grm2nop   ;
//command to each module
wire                    w_wr_ffi_p8_cpe2ffi ;
wire                    w_rd_ffi_p8_cpe2ffi ;
wire                    w_wr_dex_p8_cpe2dex ;
wire                    w_rd_dex_p8_cpe2dex ;
wire                    w_wr_ctx_p8_cpe2ctx ;
wire                    w_rd_ctx_p8_cpe2ctx ;

wire                    w_wr_ffi_p0_cpe2ffi ;
wire                    w_rd_ffi_p0_cpe2ffi ;
wire                    w_wr_dex_p0_cpe2dex ;
wire                    w_rd_dex_p0_cpe2dex ;
wire                    w_wr_ctx_p0_cpe2ctx ;
wire                    w_rd_ctx_p0_cpe2ctx ;

wire                    w_wr_ffi_p1_cpe2ffi ;
wire                    w_rd_ffi_p1_cpe2ffi ;
wire                    w_wr_dex_p1_cpe2dex ;
wire                    w_rd_dex_p1_cpe2dex ;
wire                    w_wr_ctx_p1_cpe2ctx ;
wire                    w_rd_ctx_p1_cpe2ctx ;

wire                    w_wr_ffi_p2_cpe2ffi ;
wire                    w_rd_ffi_p2_cpe2ffi ;
wire                    w_wr_dex_p2_cpe2dex ;
wire                    w_rd_dex_p2_cpe2dex ;
wire                    w_wr_ctx_p2_cpe2ctx ;
wire                    w_rd_ctx_p2_cpe2ctx ;

wire                    w_wr_ffi_p3_cpe2ffi ;
wire                    w_rd_ffi_p3_cpe2ffi ;
wire                    w_wr_dex_p3_cpe2dex ;
wire                    w_rd_dex_p3_cpe2dex ;
wire                    w_wr_ctx_p3_cpe2ctx ;
wire                    w_rd_ctx_p3_cpe2ctx ;

wire                    w_wr_ffi_p4_cpe2ffi ;
wire                    w_rd_ffi_p4_cpe2ffi ;
wire                    w_wr_dex_p4_cpe2dex ;
wire                    w_rd_dex_p4_cpe2dex ;
wire                    w_wr_ctx_p4_cpe2ctx ;
wire                    w_rd_ctx_p4_cpe2ctx ;

wire                    w_wr_ffi_p5_cpe2ffi ;
wire                    w_rd_ffi_p5_cpe2ffi ;
wire                    w_wr_dex_p5_cpe2dex ;
wire                    w_rd_dex_p5_cpe2dex ;
wire                    w_wr_ctx_p5_cpe2ctx ;
wire                    w_rd_ctx_p5_cpe2ctx ;

wire                    w_wr_ffi_p6_cpe2ffi ;
wire                    w_rd_ffi_p6_cpe2ffi ;
wire                    w_wr_dex_p6_cpe2dex ;
wire                    w_rd_dex_p6_cpe2dex ;
wire                    w_wr_ctx_p6_cpe2ctx ;
wire                    w_rd_ctx_p6_cpe2ctx ;

wire                    w_wr_ffi_p7_cpe2ffi ;
wire                    w_rd_ffi_p7_cpe2ffi ;
wire                    w_wr_dex_p7_cpe2dex ;
wire                    w_rd_dex_p7_cpe2dex ;
wire                    w_wr_ctx_p7_cpe2ctx ;
wire                    w_rd_ctx_p7_cpe2ctx ;

wire              w_wr_cit2grm;
wire              w_rd_cit2grm;	

wire              w_wr_cit2flt;
wire              w_rd_cit2flt;

wire              w_wr_cit2pcb;
wire              w_rd_cit2pcb;

wire              w_wr_cit2qgc0;
wire              w_rd_cit2qgc0;

wire              w_wr_cit2qgc1;
wire              w_rd_cit2qgc1;

wire              w_wr_cit2qgc2;
wire              w_rd_cit2qgc2;

wire              w_wr_cit2qgc3;
wire              w_rd_cit2qgc3;

wire              w_wr_cit2qgc4;
wire              w_rd_cit2qgc4;

wire              w_wr_cit2qgc5;
wire              w_rd_cit2qgc5;

wire              w_wr_cit2qgc6;
wire              w_rd_cit2qgc6;

wire              w_wr_cit2qgc7;
wire              w_rd_cit2qgc7;                  

wire              w_wr_ffi_p8_ffi2cpe            ;             
wire   [18:0]     wv_addr_ffi_p8_ffi2cpe         ;     
wire              w_addr_fixed_ffi_p8_ffi2cpe    ;     
wire   [31:0]     wv_rdata_ffi_p8_ffi2cpe        ;     
                                     
wire              w_wr_dex_p8_dex2cpe            ;     
wire   [18:0]     wv_addr_dex_p8_dex2cpe         ;     
wire              w_addr_fixed_dex_p8_dex2cpe    ;     
wire   [31:0]     wv_rdata_dex_p8_dex2cpe        ;     
                                    
wire              w_wr_ctx_p8_ctx2cpe            ;     
wire   [18:0]     wv_addr_ctx_p8_ctx2cpe         ;     
wire              w_addr_fixed_ctx_p8_ctx2cpe    ;     
wire   [31:0]     wv_rdata_ctx_p8_ctx2cpe        ;      
                                       
wire              w_wr_ffi_p0_ffi2cpe            ;     
wire   [18:0]     wv_addr_ffi_p0_ffi2cpe         ;     
wire              w_addr_fixed_ffi_p0_ffi2cpe    ;     
wire   [31:0]     wv_rdata_ffi_p0_ffi2cpe        ;     
                                        
wire              w_wr_dex_p0_dex2cpe            ;     
wire   [18:0]     wv_addr_dex_p0_dex2cpe         ;     
wire              w_addr_fixed_dex_p0_dex2cpe    ;     
wire   [31:0]     wv_rdata_dex_p0_dex2cpe        ;     
                                       
wire              w_wr_ctx_p0_ctx2cpe            ;     
wire   [18:0]     wv_addr_ctx_p0_ctx2cpe         ;     
wire              w_addr_fixed_ctx_p0_ctx2cpe    ;     
wire   [31:0]     wv_rdata_ctx_p0_ctx2cpe        ;     

wire              w_wr_ffi_p1_ffi2cpe            ;     
wire   [18:0]     wv_addr_ffi_p1_ffi2cpe         ;     
wire              w_addr_fixed_ffi_p1_ffi2cpe    ;     
wire   [31:0]     wv_rdata_ffi_p1_ffi2cpe        ;     
                                       
wire              w_wr_dex_p1_dex2cpe            ;     
wire   [18:0]     wv_addr_dex_p1_dex2cpe         ;     
wire              w_addr_fixed_dex_p1_dex2cpe    ;     
wire   [31:0]     wv_rdata_dex_p1_dex2cpe        ;     
                                       
wire              w_wr_ctx_p1_ctx2cpe            ;     
wire   [18:0]     wv_addr_ctx_p1_ctx2cpe         ;     
wire              w_addr_fixed_ctx_p1_ctx2cpe    ;     
wire   [31:0]     wv_rdata_ctx_p1_ctx2cpe        ;      
                                      
wire              w_wr_ffi_p2_ffi2cpe            ;     
wire   [18:0]     wv_addr_ffi_p2_ffi2cpe         ;     
wire              w_addr_fixed_ffi_p2_ffi2cpe    ;     
wire   [31:0]     wv_rdata_ffi_p2_ffi2cpe        ;     
                                    
wire              w_wr_dex_p2_dex2cpe            ;     
wire   [18:0]     wv_addr_dex_p2_dex2cpe         ;     
wire              w_addr_fixed_dex_p2_dex2cpe    ;     
wire   [31:0]     wv_rdata_dex_p2_dex2cpe        ;     
                                     
wire              w_wr_ctx_p2_ctx2cpe            ;     
wire   [18:0]     wv_addr_ctx_p2_ctx2cpe         ;     
wire              w_addr_fixed_ctx_p2_ctx2cpe    ;     
wire   [31:0]     wv_rdata_ctx_p2_ctx2cpe        ;       
                                    
wire              w_wr_ffi_p3_ffi2cpe            ;     
wire   [18:0]     wv_addr_ffi_p3_ffi2cpe         ;     
wire              w_addr_fixed_ffi_p3_ffi2cpe    ;     
wire   [31:0]     wv_rdata_ffi_p3_ffi2cpe        ;     
                                   
wire              w_wr_dex_p3_dex2cpe            ;     
wire   [18:0]     wv_addr_dex_p3_dex2cpe         ;     
wire              w_addr_fixed_dex_p3_dex2cpe    ;     
wire   [31:0]     wv_rdata_dex_p3_dex2cpe        ;     
                                    
wire              w_wr_ctx_p3_ctx2cpe            ;     
wire   [18:0]     wv_addr_ctx_p3_ctx2cpe         ;     
wire              w_addr_fixed_ctx_p3_ctx2cpe    ;     
wire   [31:0]     wv_rdata_ctx_p3_ctx2cpe        ;       
                                    
wire              w_wr_ffi_p4_ffi2cpe            ;     
wire   [18:0]     wv_addr_ffi_p4_ffi2cpe         ;     
wire              w_addr_fixed_ffi_p4_ffi2cpe    ;     
wire   [31:0]     wv_rdata_ffi_p4_ffi2cpe        ;     
                                    
wire              w_wr_dex_p4_dex2cpe            ;     
wire   [18:0]     wv_addr_dex_p4_dex2cpe         ;     
wire              w_addr_fixed_dex_p4_dex2cpe    ;     
wire   [31:0]     wv_rdata_dex_p4_dex2cpe        ;     
                                    
wire              w_wr_ctx_p4_ctx2cpe            ;     
wire   [18:0]     wv_addr_ctx_p4_ctx2cpe         ;     
wire              w_addr_fixed_ctx_p4_ctx2cpe    ;     
wire   [31:0]     wv_rdata_ctx_p4_ctx2cpe        ;        
                                   
wire              w_wr_ffi_p5_ffi2cpe            ;     
wire   [18:0]     wv_addr_ffi_p5_ffi2cpe         ;     
wire              w_addr_fixed_ffi_p5_ffi2cpe    ;     
wire   [31:0]     wv_rdata_ffi_p5_ffi2cpe        ;     
                                    
wire              w_wr_dex_p5_dex2cpe            ;     
wire   [18:0]     wv_addr_dex_p5_dex2cpe         ;     
wire              w_addr_fixed_dex_p5_dex2cpe    ;     
wire   [31:0]     wv_rdata_dex_p5_dex2cpe        ;     
                                    
wire              w_wr_ctx_p5_ctx2cpe            ;     
wire   [18:0]     wv_addr_ctx_p5_ctx2cpe         ;     
wire              w_addr_fixed_ctx_p5_ctx2cpe    ;     
wire   [31:0]     wv_rdata_ctx_p5_ctx2cpe        ;      
                                     
wire              w_wr_ffi_p6_ffi2cpe            ;     
wire   [18:0]     wv_addr_ffi_p6_ffi2cpe         ;     
wire              w_addr_fixed_ffi_p6_ffi2cpe    ;     
wire   [31:0]     wv_rdata_ffi_p6_ffi2cpe        ;     
                                   
wire              w_wr_dex_p6_dex2cpe            ;     
wire   [18:0]     wv_addr_dex_p6_dex2cpe         ;     
wire              w_addr_fixed_dex_p6_dex2cpe    ;     
wire   [31:0]     wv_rdata_dex_p6_dex2cpe        ;     
                                     
wire              w_wr_ctx_p6_ctx2cpe            ;     
wire   [18:0]     wv_addr_ctx_p6_ctx2cpe         ;     
wire              w_addr_fixed_ctx_p6_ctx2cpe    ;     
wire   [31:0]     wv_rdata_ctx_p6_ctx2cpe        ;      
                                   
wire              w_wr_ffi_p7_ffi2cpe            ;     
wire   [18:0]     wv_addr_ffi_p7_ffi2cpe         ;     
wire              w_addr_fixed_ffi_p7_ffi2cpe    ;     
wire   [31:0]     wv_rdata_ffi_p7_ffi2cpe        ;     
                                    
wire              w_wr_dex_p7_dex2cpe            ;     
wire   [18:0]     wv_addr_dex_p7_dex2cpe         ;     
wire              w_addr_fixed_dex_p7_dex2cpe    ;     
wire   [31:0]     wv_rdata_dex_p7_dex2cpe        ;     
                                   
wire              w_wr_ctx_p7                    ;     
wire   [18:0]     wv_addr_ctx_p7                 ;     
wire              w_addr_fixed_ctx_p7            ;     
wire   [31:0]     wv_rdata_ctx_p7                ;        

wire              w_wr_grm2cit         ;
wire   [18:0]     wv_addr_grm2cit      ;
wire              w_addr_fixed_grm2cit ;
wire   [31:0]     wv_rdata_grm2cit     ;
          
wire              w_wr_pcb2cit;
wire   [18:0]     wv_addr_pcb2cit;
wire              w_addr_fixed_pcb2cit;
wire   [31:0]     wv_rdata_pcb2cit;

wire              w_wr_flt2cit;
wire   [18:0]     wv_addr_flt2cit;
wire              w_addr_fixed_flt2cit;
wire   [31:0]     wv_rdata_flt2cit;

wire              w_wr_qgc02cit;
wire   [18:0]     wv_addr_qgc02cit;
wire              w_addr_fixed_qgc02cit;
wire   [31:0]     wv_rdata_qgc02cit;

wire              w_wr_qgc12cit;
wire   [18:0]     wv_addr_qgc12cit;
wire              w_addr_fixed_qgc12cit;
wire   [31:0]     wv_rdata_qgc12cit;

wire              w_wr_qgc22cit;
wire   [18:0]     wv_addr_qgc22cit;
wire              w_addr_fixed_qgc22cit;
wire   [31:0]     wv_rdata_qgc22cit;

wire              w_wr_qgc32cit;
wire   [18:0]     wv_addr_qgc32cit;
wire              w_addr_fixed_qgc32cit;
wire   [31:0]     wv_rdata_qgc32cit;

wire              w_wr_qgc42cit;
wire   [18:0]     wv_addr_qgc42cit;
wire              w_addr_fixed_qgc42cit;
wire   [31:0]     wv_rdata_qgc42cit;

wire              w_wr_qgc52cit;
wire   [18:0]     wv_addr_qgc52cit;
wire              w_addr_fixed_qgc52cit;
wire   [31:0]     wv_rdata_qgc52cit;

wire              w_wr_qgc62cit;
wire   [18:0]     wv_addr_qgc62cit;
wire              w_addr_fixed_qgc62cit;
wire   [31:0]     wv_rdata_qgc62cit;

wire              w_wr_qgc72cit;
wire   [18:0]     wv_addr_qgc72cit;
wire              w_addr_fixed_qgc72cit;
wire   [31:0]     wv_rdata_qgc72cit; 

wire   [7:0]      wv_eth_data_cop2msl     ;
wire              w_eth_data_wr_cop2msl   ;
network_input_process_top network_input_process_top_inst(
.i_clk                              (i_clk),
.i_rst_n                            (i_rst_n),

.iv_free_bufid_fifo_rdusedw         (wv_free_buf_fifo_rdusedw_pcb2cpa),

.i_gmii_dv_p0                       (i_gmii_dv_p0),
.iv_gmii_rxd_p0                     (iv_gmii_rxd_p0),

.i_gmii_dv_p1                       (i_gmii_dv_p1),
.iv_gmii_rxd_p1                     (iv_gmii_rxd_p1),

.i_gmii_dv_p2                       (i_gmii_dv_p2),
.iv_gmii_rxd_p2                     (iv_gmii_rxd_p2),

.i_gmii_dv_p3                       (i_gmii_dv_p3),
.iv_gmii_rxd_p3                     (iv_gmii_rxd_p3),

.i_gmii_dv_p4                       (i_gmii_dv_p4),
.iv_gmii_rxd_p4                     (iv_gmii_rxd_p4),

.i_gmii_dv_p5                       (i_gmii_dv_p5),
.iv_gmii_rxd_p5                     (iv_gmii_rxd_p5),

.i_gmii_dv_p6                       (i_gmii_dv_p6),
.iv_gmii_rxd_p6                     (iv_gmii_rxd_p6),

.i_gmii_dv_p7                       (i_gmii_dv_p7),
.iv_gmii_rxd_p7                     (iv_gmii_rxd_p7),

.i_gmii_dv_p8                       (i_gmii_dv_p8),
.iv_gmii_rxd_p8                     (iv_gmii_rxd_p8),

.i_rc_rxenable                      (i_rc_rxenable                         ),
.i_st_rxenable                      (i_st_rxenable                         ),
.i_hardware_initial_finish          (w_hardware_initial_finish             ),
.iv_be_threshold_value              (wv_be_threshold_value_grm2nip         ),           
.iv_rc_threshold_value              (wv_rc_threshold_value_grm2nip         ),
.iv_standardpkt_threshold_value     (wv_standardpkt_threshold_value_grm2nip),

.iv_addr                            (ov_addr_cit2all              ),
.i_addr_fixed                       (o_addr_fixed_cit2all         ), 
.iv_wdata                           (ov_wdata_cit2all             ),                                                          

.i_wr_ffi_p8                      (w_wr_ffi_p8_cpe2ffi),
.i_rd_ffi_p8                      (w_rd_ffi_p8_cpe2ffi),
.o_wr_ffi_p8                      (w_wr_ffi_p8_ffi2cpe          ),              
.ov_addr_ffi_p8                   (wv_addr_ffi_p8_ffi2cpe       ),  
.o_addr_fixed_ffi_p8              (w_addr_fixed_ffi_p8_ffi2cpe  ),  
.ov_rdata_ffi_p8                  (wv_rdata_ffi_p8_ffi2cpe      ), 

.i_wr_dex_p8                      (w_wr_dex_p8_cpe2dex),
.i_rd_dex_p8                      (w_rd_dex_p8_cpe2dex),
.o_wr_dex_p8                      (w_wr_dex_p8_dex2cpe          ),  
.ov_addr_dex_p8                   (wv_addr_dex_p8_dex2cpe       ),  
.o_addr_fixed_dex_p8              (w_addr_fixed_dex_p8_dex2cpe  ),  
.ov_rdata_dex_p8                  (wv_rdata_dex_p8_dex2cpe      ),  

.i_wr_ffi_p0                      (w_wr_ffi_p0_cpe2ffi),
.i_rd_ffi_p0                      (w_rd_ffi_p0_cpe2ffi),
.o_wr_ffi_p0                      (w_wr_ffi_p0_ffi2cpe          ),  
.ov_addr_ffi_p0                   (wv_addr_ffi_p0_ffi2cpe       ),  
.o_addr_fixed_ffi_p0              (w_addr_fixed_ffi_p0_ffi2cpe  ),  
.ov_rdata_ffi_p0                  (wv_rdata_ffi_p0_ffi2cpe      ),  

.i_wr_dex_p0                      (w_wr_dex_p0_cpe2dex),
.i_rd_dex_p0                      (w_rd_dex_p0_cpe2dex),
.o_wr_dex_p0                      (w_wr_dex_p0_dex2cpe          ),  
.ov_addr_dex_p0                   (wv_addr_dex_p0_dex2cpe       ),  
.o_addr_fixed_dex_p0              (w_addr_fixed_dex_p0_dex2cpe  ),  
.ov_rdata_dex_p0                  (wv_rdata_dex_p0_dex2cpe      ),  

.i_wr_ffi_p1                      (w_wr_ffi_p1_cpe2ffi),
.i_rd_ffi_p1                      (w_rd_ffi_p1_cpe2ffi),
.o_wr_ffi_p1                      (w_wr_ffi_p1_ffi2cpe          ),  
.ov_addr_ffi_p1                   (wv_addr_ffi_p1_ffi2cpe       ),  
.o_addr_fixed_ffi_p1              (w_addr_fixed_ffi_p1_ffi2cpe  ),  
.ov_rdata_ffi_p1                  (wv_rdata_ffi_p1_ffi2cpe      ), 
 
.i_wr_dex_p1                      (w_wr_dex_p1_cpe2dex),
.i_rd_dex_p1                      (w_rd_dex_p1_cpe2dex),
.o_wr_dex_p1                      (w_wr_dex_p1_dex2cpe          ),  
.ov_addr_dex_p1                   (wv_addr_dex_p1_dex2cpe       ),  
.o_addr_fixed_dex_p1              (w_addr_fixed_dex_p1_dex2cpe  ),  
.ov_rdata_dex_p1                  (wv_rdata_dex_p1_dex2cpe      ),  

.i_wr_ffi_p2                      (w_wr_ffi_p2_cpe2ffi),
.i_rd_ffi_p2                      (w_rd_ffi_p2_cpe2ffi),
.o_wr_ffi_p2                      (w_wr_ffi_p2_ffi2cpe          ),  
.ov_addr_ffi_p2                   (wv_addr_ffi_p2_ffi2cpe       ),  
.o_addr_fixed_ffi_p2              (w_addr_fixed_ffi_p2_ffi2cpe  ),  
.ov_rdata_ffi_p2                  (wv_rdata_ffi_p2_ffi2cpe      ), 

.i_wr_dex_p2                      (w_wr_dex_p2_cpe2dex),
.i_rd_dex_p2                      (w_rd_dex_p2_cpe2dex),
.o_wr_dex_p2                      (w_wr_dex_p2_dex2cpe          ),  
.ov_addr_dex_p2                   (wv_addr_dex_p2_dex2cpe       ),  
.o_addr_fixed_dex_p2              (w_addr_fixed_dex_p2_dex2cpe  ),  
.ov_rdata_dex_p2                  (wv_rdata_dex_p2_dex2cpe      ),  

.i_wr_ffi_p3                      (w_wr_ffi_p3_cpe2ffi),
.i_rd_ffi_p3                      (w_rd_ffi_p3_cpe2ffi),
.o_wr_ffi_p3                      (w_wr_ffi_p3_ffi2cpe          ),  
.ov_addr_ffi_p3                   (wv_addr_ffi_p3_ffi2cpe       ),  
.o_addr_fixed_ffi_p3              (w_addr_fixed_ffi_p3_ffi2cpe  ),  
.ov_rdata_ffi_p3                  (wv_rdata_ffi_p3_ffi2cpe      ), 

.i_wr_dex_p3                      (w_wr_dex_p3_cpe2dex),
.i_rd_dex_p3                      (w_rd_dex_p3_cpe2dex),
.o_wr_dex_p3                      (w_wr_dex_p3_dex2cpe          ),  
.ov_addr_dex_p3                   (wv_addr_dex_p3_dex2cpe       ),  
.o_addr_fixed_dex_p3              (w_addr_fixed_dex_p3_dex2cpe  ),  
.ov_rdata_dex_p3                  (wv_rdata_dex_p3_dex2cpe      ),  

.i_wr_ffi_p4                      (w_wr_ffi_p4_cpe2ffi),
.i_rd_ffi_p4                      (w_rd_ffi_p4_cpe2ffi),
.o_wr_ffi_p4                      (w_wr_ffi_p4_ffi2cpe          ),  
.ov_addr_ffi_p4                   (wv_addr_ffi_p4_ffi2cpe       ),  
.o_addr_fixed_ffi_p4              (w_addr_fixed_ffi_p4_ffi2cpe  ),  
.ov_rdata_ffi_p4                  (wv_rdata_ffi_p4_ffi2cpe      ),  

.i_wr_dex_p4                      (w_wr_dex_p4_cpe2dex),
.i_rd_dex_p4                      (w_rd_dex_p4_cpe2dex),
.o_wr_dex_p4                      (w_wr_dex_p4_dex2cpe          ),  
.ov_addr_dex_p4                   (wv_addr_dex_p4_dex2cpe       ),  
.o_addr_fixed_dex_p4              (w_addr_fixed_dex_p4_dex2cpe  ),  
.ov_rdata_dex_p4                  (wv_rdata_dex_p4_dex2cpe      ),  

.i_wr_ffi_p5                      (w_wr_ffi_p5_cpe2ffi),
.i_rd_ffi_p5                      (w_rd_ffi_p5_cpe2ffi),
.o_wr_ffi_p5                      (w_wr_ffi_p5_ffi2cpe          ),  
.ov_addr_ffi_p5                   (wv_addr_ffi_p5_ffi2cpe       ),  
.o_addr_fixed_ffi_p5              (w_addr_fixed_ffi_p5_ffi2cpe  ),  
.ov_rdata_ffi_p5                  (wv_rdata_ffi_p5_ffi2cpe      ),  

.i_wr_dex_p5                      (w_wr_dex_p5_cpe2dex),
.i_rd_dex_p5                      (w_rd_dex_p5_cpe2dex),
.o_wr_dex_p5                      (w_wr_dex_p5_dex2cpe          ),  
.ov_addr_dex_p5                   (wv_addr_dex_p5_dex2cpe       ),  
.o_addr_fixed_dex_p5              (w_addr_fixed_dex_p5_dex2cpe  ),  
.ov_rdata_dex_p5                  (wv_rdata_dex_p5_dex2cpe      ), 

.i_wr_ffi_p6                      (w_wr_ffi_p6_cpe2ffi),
.i_rd_ffi_p6                      (w_rd_ffi_p6_cpe2ffi),
.o_wr_ffi_p6                      (w_wr_ffi_p6_ffi2cpe          ),  
.ov_addr_ffi_p6                   (wv_addr_ffi_p6_ffi2cpe       ),  
.o_addr_fixed_ffi_p6              (w_addr_fixed_ffi_p6_ffi2cpe  ),  
.ov_rdata_ffi_p6                  (wv_rdata_ffi_p6_ffi2cpe      ),  

.i_wr_dex_p6                      (w_wr_dex_p6_cpe2dex),
.i_rd_dex_p6                      (w_rd_dex_p6_cpe2dex),
.o_wr_dex_p6                      (w_wr_dex_p6_dex2cpe          ),  
.ov_addr_dex_p6                   (wv_addr_dex_p6_dex2cpe       ),  
.o_addr_fixed_dex_p6              (w_addr_fixed_dex_p6_dex2cpe  ),  
.ov_rdata_dex_p6                  (wv_rdata_dex_p6_dex2cpe      ), 

.i_wr_ffi_p7                      (w_wr_ffi_p7_cpe2ffi),
.i_rd_ffi_p7                      (w_rd_ffi_p7_cpe2ffi),
.o_wr_ffi_p7                      (w_wr_ffi_p7_ffi2cpe          ),  
.ov_addr_ffi_p7                   (wv_addr_ffi_p7_ffi2cpe       ),  
.o_addr_fixed_ffi_p7              (w_addr_fixed_ffi_p7_ffi2cpe  ),  
.ov_rdata_ffi_p7                  (wv_rdata_ffi_p7_ffi2cpe      ), 

.i_wr_dex_p7                      (w_wr_dex_p7_cpe2dex),
.i_rd_dex_p7                      (w_rd_dex_p7_cpe2dex),
.o_wr_dex_p7                      (w_wr_dex_p7_dex2cpe          ),  
.ov_addr_dex_p7                   (wv_addr_dex_p7_dex2cpe       ),  
.o_addr_fixed_dex_p7              (w_addr_fixed_dex_p7_dex2cpe  ),  
.ov_rdata_dex_p7                  (wv_rdata_dex_p7_dex2cpe      ),  

.iv_pkt_bufid_p0                    (wv_bufid_pcb2nip_0),            
.i_pkt_bufid_wr_p0                  (w_bufid_wr_pcb2nip_0),
.o_pkt_bufid_ack_p0                 (w_bufid_ack_nip2pcb_0),

.iv_pkt_bufid_p1                    (wv_bufid_pcb2nip_1),
.i_pkt_bufid_wr_p1                  (w_bufid_wr_pcb2nip_1),                   
.o_pkt_bufid_ack_p1                 (w_bufid_ack_nip2pcb_1),
            
.iv_pkt_bufid_p2                    (wv_bufid_pcb2nip_2),            
.i_pkt_bufid_wr_p2                  (w_bufid_wr_pcb2nip_2),
.o_pkt_bufid_ack_p2                 (w_bufid_ack_nip2pcb_2),
            
.iv_pkt_bufid_p3                    (wv_bufid_pcb2nip_3),    
.i_pkt_bufid_wr_p3                  (w_bufid_wr_pcb2nip_3),
.o_pkt_bufid_ack_p3                 (w_bufid_ack_nip2pcb_3),
            
.iv_pkt_bufid_p4                    (wv_bufid_pcb2nip_4),    
.i_pkt_bufid_wr_p4                  (w_bufid_wr_pcb2nip_4),
.o_pkt_bufid_ack_p4                 (w_bufid_ack_nip2pcb_4),

.iv_pkt_bufid_p5                    (wv_bufid_pcb2nip_5),    
.i_pkt_bufid_wr_p5                  (w_bufid_wr_pcb2nip_5),
.o_pkt_bufid_ack_p5                 (w_bufid_ack_hrp2nip_5),
            
.iv_pkt_bufid_p6                    (wv_bufid_pcb2nip_6),    
.i_pkt_bufid_wr_p6                  (w_bufid_wr_pcb2nip_6),
.o_pkt_bufid_ack_p6                 (w_bufid_ack_hrp2nip_6),
            
.iv_pkt_bufid_p7                    (wv_bufid_pcb2nip_7),    
.i_pkt_bufid_wr_p7                  (w_bufid_wr_pcb2nip_7),
.o_pkt_bufid_ack_p7                 (w_bufid_ack_hrp2nip_7),

.iv_pkt_bufid_p8                    (wv_bufid_pcb2nip_8),    //
.i_pkt_bufid_wr_p8                  (w_bufid_wr_pcb2nip_8),
.o_pkt_bufid_ack_p8                 (w_bufid_ack_hrp2nip_8),
             
.ov_descriptor_p0                   (wv_descriptor_nip2flt_0), 
.o_descriptor_wr_p0                 (w_descriptor_wr_nip2flt_0),
.i_descriptor_ack_p0                (w_descriptor_ack_flt2nip_0),
            
.ov_descriptor_p1                   (wv_descriptor_nip2flt_1), 
.o_descriptor_wr_p1                 (w_descriptor_wr_nip2flt_1),
.i_descriptor_ack_p1                (w_descriptor_ack_flt2nip_1),
            
.ov_descriptor_p2                   (wv_descriptor_nip2flt_2), 
.o_descriptor_wr_p2                 (w_descriptor_wr_nip2flt_2),
.i_descriptor_ack_p2                (w_descriptor_ack_flt2nip_2),
            
.ov_descriptor_p3                   (wv_descriptor_nip2flt_3), 
.o_descriptor_wr_p3                 (w_descriptor_wr_nip2flt_3),
.i_descriptor_ack_p3                (w_descriptor_ack_flt2nip_3),
                
.ov_descriptor_p4                   (wv_descriptor_nip2flt_4), 
.o_descriptor_wr_p4                 (w_descriptor_wr_nip2flt_4),
.i_descriptor_ack_p4                (w_descriptor_ack_flt2nip_4), 

.ov_descriptor_p5                   (wv_descriptor_pcb2nip_5), 
.o_descriptor_wr_p5                 (w_descriptor_wr_pcb2nip_5),
.i_descriptor_ack_p5                (w_descriptor_ack_pcb2nip_5),
                
.ov_descriptor_p6                   (wv_descriptor_pcb2nip_6), 
.o_descriptor_wr_p6                 (w_descriptor_wr_pcb2nip_6),
.i_descriptor_ack_p6                (w_descriptor_ack_pcb2nip_6),
                
.ov_descriptor_p7                   (wv_descriptor_pcb2nip_7), 
.o_descriptor_wr_p7                 (w_descriptor_wr_pcb2nip_7),
.i_descriptor_ack_p7                (w_descriptor_ack_pcb2nip_7),              
    
.ov_descriptor_p8                   (wv_descriptor_pcb2nip_8), //
.o_descriptor_wr_p8                 (w_descriptor_wr_pcb2nip_8),
.i_descriptor_ack_p8                (w_descriptor_ack_pcb2nip_8),  
    
.ov_pkt_p0                          (wv_pkt_data_pcb2nip_0),
.o_pkt_wr_p0                        (w_pkt_data_wr_pcb2nip_0),
.ov_pkt_bufadd_p0                   (wv_pkt_addr_pcb2nip_0),
.i_pkt_ack_p0                       (w_pkt_ack_pcb2nip_0),
            
.ov_pkt_p1                          (wv_pkt_data_pcb2nip_1),
.o_pkt_wr_p1                        (w_pkt_data_wr_pcb2nip_1),
.ov_pkt_bufadd_p1                   (wv_pkt_addr_pcb2nip_1),
.i_pkt_ack_p1                       (w_pkt_ack_pcb2nip_1),
            
.ov_pkt_p2                          (wv_pkt_data_pcb2nip_2),
.o_pkt_wr_p2                        (w_pkt_data_wr_pcb2nip_2),
.ov_pkt_bufadd_p2                   (wv_pkt_addr_pcb2nip_2),
.i_pkt_ack_p2                       (w_pkt_ack_pcb2nip_2),
            
.ov_pkt_p3                          (wv_pkt_data_pcb2nip_3),
.o_pkt_wr_p3                        (w_pkt_data_wr_pcb2nip_3),
.ov_pkt_bufadd_p3                   (wv_pkt_addr_pcb2nip_3),
.i_pkt_ack_p3                       (w_pkt_ack_pcb2nip_3),
            
.ov_pkt_p4                          (wv_pkt_data_pcb2nip_4),
.o_pkt_wr_p4                        (w_pkt_data_wr_pcb2nip_4),
.ov_pkt_bufadd_p4                   (wv_pkt_addr_pcb2nip_4),
.i_pkt_ack_p4                       (w_pkt_ack_pcb2nip_4),

.ov_pkt_p5                          (wv_pkt_data_pcb2nip_5),
.o_pkt_wr_p5                        (w_pkt_data_wr_pcb2nip_5),
.ov_pkt_bufadd_p5                   (wv_pkt_addr_pcb2nip_5),
.i_pkt_ack_p5                       (w_pkt_ack_pcb2nip_5),
                                    
.ov_pkt_p6                          (wv_pkt_data_pcb2nip_6),
.o_pkt_wr_p6                        (w_pkt_data_wr_pcb2nip_6),
.ov_pkt_bufadd_p6                   (wv_pkt_addr_pcb2nip_6),
.i_pkt_ack_p6                       (w_pkt_ack_pcb2nip_6),
                                    
.ov_pkt_p7                          (wv_pkt_data_pcb2nip_7),
.o_pkt_wr_p7                        (w_pkt_data_wr_pcb2nip_7),
.ov_pkt_bufadd_p7                   (wv_pkt_addr_pcb2nip_7),
.i_pkt_ack_p7                       (w_pkt_ack_pcb2nip_7),

.ov_pkt_p8                          (wv_pkt_data_pcb2nip_8),
.o_pkt_wr_p8                        (w_pkt_data_wr_pcb2nip_8),
.ov_pkt_bufadd_p8                   (wv_pkt_addr_pcb2nip_8),
.i_pkt_ack_p8                       (w_pkt_ack_pcb2nip_8),                                        
           
.ov_descriptor_extract_state_p0     (),      
.ov_descriptor_send_state_p0        (),         
.ov_data_splice_state_p0            (),             
.ov_input_buf_interface_state_p0    (),     
              
.ov_descriptor_extract_state_p1     (),      
.ov_descriptor_send_state_p1        (),         
.ov_data_splice_state_p1            (),             
.ov_input_buf_interface_state_p1    (),     
              
.ov_descriptor_extract_state_p2     (),      
.ov_descriptor_send_state_p2        (),         
.ov_data_splice_state_p2            (),             
.ov_input_buf_interface_state_p2    (),     
               
.ov_descriptor_extract_state_p3     (),      
.ov_descriptor_send_state_p3        (),         
.ov_data_splice_state_p3            (),             
.ov_input_buf_interface_state_p3    (),     
              
.ov_descriptor_extract_state_p4     (),      
.ov_descriptor_send_state_p4        (),         
.ov_data_splice_state_p4            (),             
.ov_input_buf_interface_state_p4    (),     

.ov_descriptor_extract_state_p5     (),
.ov_descriptor_send_state_p5        (),
.ov_data_splice_state_p5            (),
.ov_input_buf_interface_state_p5    (),

.ov_descriptor_extract_state_p6     (),
.ov_descriptor_send_state_p6        (),
.ov_data_splice_state_p6            (),
.ov_input_buf_interface_state_p6    (),

.ov_descriptor_extract_state_p7     (),
.ov_descriptor_send_state_p7        (),
.ov_data_splice_state_p7            (),
.ov_input_buf_interface_state_p7    (),

.ov_descriptor_extract_state_p8     (),
.ov_descriptor_send_state_p8        (),
.ov_data_splice_state_p8            (),
.ov_input_buf_interface_state_p8    ()  
);

forward_lookup_table forward_lookup_table_inst(
.i_clk                      (i_clk),
.i_rst_n                    (i_rst_n),
    
.iv_descriptor_p0           (wv_descriptor_nip2flt_0),
.i_descriptor_wr_p0         (w_descriptor_wr_nip2flt_0),
.o_descriptor_ack_p0        (w_descriptor_ack_flt2nip_0),
                            
.iv_descriptor_p1           (wv_descriptor_nip2flt_1),
.i_descriptor_wr_p1         (w_descriptor_wr_nip2flt_1),
.o_descriptor_ack_p1        (w_descriptor_ack_flt2nip_1),
                            
.iv_descriptor_p2           (wv_descriptor_nip2flt_2),
.i_descriptor_wr_p2         (w_descriptor_wr_nip2flt_2),
.o_descriptor_ack_p2        (w_descriptor_ack_flt2nip_2),
    
.iv_descriptor_p3           (wv_descriptor_nip2flt_3),
.i_descriptor_wr_p3         (w_descriptor_wr_nip2flt_3),
.o_descriptor_ack_p3        (w_descriptor_ack_flt2nip_3),
    
.iv_descriptor_p4           (wv_descriptor_nip2flt_4),
.i_descriptor_wr_p4         (w_descriptor_wr_nip2flt_4),
.o_descriptor_ack_p4        (w_descriptor_ack_flt2nip_4),
 
.iv_descriptor_p5           (wv_descriptor_pcb2nip_5),
.i_descriptor_wr_p5         (w_descriptor_wr_pcb2nip_5),
.o_descriptor_ack_p5        (w_descriptor_ack_pcb2nip_5),
    
.iv_descriptor_p6           (wv_descriptor_pcb2nip_6),
.i_descriptor_wr_p6         (w_descriptor_wr_pcb2nip_6),
.o_descriptor_ack_p6        (w_descriptor_ack_pcb2nip_6),
    
.iv_descriptor_p7           (wv_descriptor_pcb2nip_7),
.i_descriptor_wr_p7         (w_descriptor_wr_pcb2nip_7),
.o_descriptor_ack_p7        (w_descriptor_ack_pcb2nip_7), 

.iv_descriptor_p8           (wv_descriptor_pcb2nip_8),
.i_descriptor_wr_p8         (w_descriptor_wr_pcb2nip_8),
.o_descriptor_ack_p8        (w_descriptor_ack_pcb2nip_8), 

.iv_local_id                    (iv_local_id                   ),
.o_tsmp_lookup_table_key_wr     (o_tsmp_lookup_table_key_wr    ),
.ov_tsmp_lookup_table_key       (ov_tsmp_lookup_table_key      ),
.iv_tsmp_lookup_table_outport   (iv_tsmp_lookup_table_outport  ),
.i_tsmp_lookup_table_outport_wr (i_tsmp_lookup_table_outport_wr),     
 
.ov_pkt_bufid_p0            (wv_pkt_bufid_flt2nop_0),
.ov_pkt_type_p0             (wv_pkt_type_flt2nop_0),
.o_pkt_bufid_wr_p0          (w_pkt_bufid_wr_flt2nop_0),
    
.ov_pkt_bufid_p1            (wv_pkt_bufid_flt2nop_1),
.ov_pkt_type_p1             (wv_pkt_type_flt2nop_1),
.o_pkt_bufid_wr_p1          (w_pkt_bufid_wr_flt2nop_1),
    
.ov_pkt_bufid_p2            (wv_pkt_bufid_flt2nop_2),
.ov_pkt_type_p2             (wv_pkt_type_flt2nop_2),
.o_pkt_bufid_wr_p2          (w_pkt_bufid_wr_flt2nop_2),
    
.ov_pkt_bufid_p3            (wv_pkt_bufid_flt2nop_3),
.ov_pkt_type_p3             (wv_pkt_type_flt2nop_3),
.o_pkt_bufid_wr_p3          (w_pkt_bufid_wr_flt2nop_3),
    
.ov_pkt_bufid_p4            (wv_pkt_bufid_flt2nop_4),
.ov_pkt_type_p4             (wv_pkt_type_flt2nop_4),
.o_pkt_bufid_wr_p4          (w_pkt_bufid_wr_flt2nop_4),

.ov_pkt_bufid_p5            (wv_pkt_bufid_flt2nop_5),
.ov_pkt_type_p5             (wv_pkt_type_flt2nop_5),
.o_pkt_bufid_wr_p5          (w_pkt_bufid_wr_flt2nop_5),
    
.ov_pkt_bufid_p6            (wv_pkt_bufid_flt2nop_6),
.ov_pkt_type_p6             (wv_pkt_type_flt2nop_6),
.o_pkt_bufid_wr_p6          (w_pkt_bufid_wr_flt2nop_6),
    
.ov_pkt_bufid_p7            (wv_pkt_bufid_flt2nop_7),
.ov_pkt_type_p7             (wv_pkt_type_flt2nop_7),
.o_pkt_bufid_wr_p7          (w_pkt_bufid_wr_flt2nop_7),

.ov_pkt_bufid_host          (wv_pkt_bufid_flt2nop_8),
.ov_pkt_type_host           (wv_pkt_type_flt2nop_8),
.o_mac_entry_hit_host       (w_mac_entry_hit_8),
.ov_pkt_inport_host         (wv_pkt_inport_8  ),
.o_pkt_bufid_wr_host        (w_pkt_bufid_wr_flt2nop_8),
   
.ov_pkt_bufid               (wv_pkt_bufid_flt2pcb),
.o_pkt_bufid_wr             (w_pkt_bufid_wr_flt2pcb),
.ov_pkt_bufid_cnt           (wv_pkt_bufid_cnt_flt2pcb),

.iv_addr                    (ov_addr_cit2all             ),
.iv_wdata                   (ov_wdata_cit2all            ),
.i_addr_fixed               (o_addr_fixed_cit2all        ),                             
.i_wr_flt                   (w_wr_cit2flt                ),
.i_rd_flt                   (w_rd_cit2flt                ),
                                  
.o_wr_flt                   (w_wr_flt2cit         ),
.ov_addr_flt                (wv_addr_flt2cit      ),
.o_addr_fixed_flt           (w_addr_fixed_flt2cit ),
.ov_rdata_flt               (wv_rdata_flt2cit     ),
  
.iv_dmacram_addr            (wv_dmacram_addr_msl2flt      ),
.iv_dmacram_wdata           (wv_dmacram_wdata_msl2flt     ),
.i_dmacram_wr               (w_dmacram_wr_msl2flt         ),
.ov_dmacram_rdata           (             ),
.i_dmacram_rd               (1'b0         )      
);

pkt_centralized_buffer pkt_centralized_buffer_inst(
.clk_sys                 (i_clk               ),
.reset_n                 (i_rst_n             ), 

.o_hardware_initial_finish(w_hardware_initial_finish),

.iv_addr                 (ov_addr_cit2all     ),                         
.i_addr_fixed            (o_addr_fixed_cit2all),                   
.iv_wdata                (ov_wdata_cit2all    ),                            
.i_wr_pcb                (w_wr_cit2pcb        ),                        
.i_rd_pcb                (w_rd_cit2pcb        ), 

.o_wr_pcb                (w_wr_pcb2cit        ),                     
.ov_addr_pcb             (wv_addr_pcb2cit     ),                  
.o_addr_fixed_pcb        (w_addr_fixed_pcb2cit),             
.ov_rdata_pcb            (wv_rdata_pcb2cit    ),  
    
.iv_pkt_p0               (wv_pkt_data_pcb2nip_0),
.i_pkt_wr_p0             (w_pkt_data_wr_pcb2nip_0),
.iv_pkt_wr_bufadd_p0     (wv_pkt_addr_pcb2nip_0),
.o_pkt_wr_ack_p0         (w_pkt_ack_pcb2nip_0),
                         
.iv_pkt_p1               (wv_pkt_data_pcb2nip_1),
.i_pkt_wr_p1             (w_pkt_data_wr_pcb2nip_1),
.iv_pkt_wr_bufadd_p1     (wv_pkt_addr_pcb2nip_1),
.o_pkt_wr_ack_p1         (w_pkt_ack_pcb2nip_1),
                         
.iv_pkt_p2               (wv_pkt_data_pcb2nip_2),
.i_pkt_wr_p2             (w_pkt_data_wr_pcb2nip_2),
.iv_pkt_wr_bufadd_p2     (wv_pkt_addr_pcb2nip_2),
.o_pkt_wr_ack_p2         (w_pkt_ack_pcb2nip_2),

.iv_pkt_p3               (wv_pkt_data_pcb2nip_3),
.i_pkt_wr_p3             (w_pkt_data_wr_pcb2nip_3),
.iv_pkt_wr_bufadd_p3     (wv_pkt_addr_pcb2nip_3),
.o_pkt_wr_ack_p3         (w_pkt_ack_pcb2nip_3), 

.iv_pkt_p4               (wv_pkt_data_pcb2nip_4),
.i_pkt_wr_p4             (w_pkt_data_wr_pcb2nip_4),
.iv_pkt_wr_bufadd_p4     (wv_pkt_addr_pcb2nip_4),
.o_pkt_wr_ack_p4         (w_pkt_ack_pcb2nip_4), 

.iv_pkt_p5               (wv_pkt_data_pcb2nip_5),
.i_pkt_wr_p5             (w_pkt_data_wr_pcb2nip_5),
.iv_pkt_wr_bufadd_p5     (wv_pkt_addr_pcb2nip_5),
.o_pkt_wr_ack_p5         (w_pkt_ack_pcb2nip_5),
    
.iv_pkt_p6               (wv_pkt_data_pcb2nip_6),
.i_pkt_wr_p6             (w_pkt_data_wr_pcb2nip_6),
.iv_pkt_wr_bufadd_p6     (wv_pkt_addr_pcb2nip_6),
.o_pkt_wr_ack_p6         (w_pkt_ack_pcb2nip_6),
    
.iv_pkt_p7               (wv_pkt_data_pcb2nip_7),
.i_pkt_wr_p7             (w_pkt_data_wr_pcb2nip_7),
.iv_pkt_wr_bufadd_p7     (wv_pkt_addr_pcb2nip_7),
.o_pkt_wr_ack_p7         (w_pkt_ack_pcb2nip_7), 

.iv_pkt_p8               (wv_pkt_data_pcb2nip_8),//
.i_pkt_wr_p8             (w_pkt_data_wr_pcb2nip_8),
.iv_pkt_wr_bufadd_p8     (wv_pkt_addr_pcb2nip_8),
.o_pkt_wr_ack_p8         (w_pkt_ack_pcb2nip_8), 

.iv_pkt_rd_bufadd_p0     (wv_pkt_raddr_nop2pcb_0),
.i_pkt_rd_p0             (w_pkt_rd_nop2pcb_0),
.o_pkt_rd_ack_p0         (w_pkt_raddr_ack_pcb2nop_0),
.ov_pkt_p0               (wv_pkt_data_pcb2nop_0),
.o_pkt_wr_p0             (w_pkt_data_wr_pcb2nop_0),
                         
.iv_pkt_rd_bufadd_p1     (wv_pkt_raddr_nop2pcb_1),
.i_pkt_rd_p1             (w_pkt_rd_nop2pcb_1),
.o_pkt_rd_ack_p1         (w_pkt_raddr_ack_pcb2nop_1),
.ov_pkt_p1               (wv_pkt_data_pcb2nop_1),   
.o_pkt_wr_p1             (w_pkt_data_wr_pcb2nop_1),

.iv_pkt_rd_bufadd_p2     (wv_pkt_raddr_nop2pcb_2),
.i_pkt_rd_p2             (w_pkt_rd_nop2pcb_2),
.o_pkt_rd_ack_p2         (w_pkt_raddr_ack_pcb2nop_2),
.ov_pkt_p2               (wv_pkt_data_pcb2nop_2),   
.o_pkt_wr_p2             (w_pkt_data_wr_pcb2nop_2),

.iv_pkt_rd_bufadd_p3     (wv_pkt_raddr_nop2pcb_3),
.i_pkt_rd_p3             (w_pkt_rd_nop2pcb_3),
.o_pkt_rd_ack_p3         (w_pkt_raddr_ack_pcb2nop_3),
.ov_pkt_p3               (wv_pkt_data_pcb2nop_3),   
.o_pkt_wr_p3             (w_pkt_data_wr_pcb2nop_3),

.iv_pkt_rd_bufadd_p4     (wv_pkt_raddr_nop2pcb_4),
.i_pkt_rd_p4             (w_pkt_rd_nop2pcb_4),
.o_pkt_rd_ack_p4         (w_pkt_raddr_ack_pcb2nop_4),
.ov_pkt_p4               (wv_pkt_data_pcb2nop_4),   
.o_pkt_wr_p4             (w_pkt_data_wr_pcb2nop_4),

.iv_pkt_rd_bufadd_p5     (wv_pkt_raddr_nop2pcb_5),
.i_pkt_rd_p5             (w_pkt_rd_nop2pcb_5),
.o_pkt_rd_ack_p5         (w_pkt_raddr_ack_pcb2nop_5),
.ov_pkt_p5               (wv_pkt_data_pcb2nop_5),   
.o_pkt_wr_p5             (w_pkt_data_wr_pcb2nop_5),

.iv_pkt_rd_bufadd_p6     (wv_pkt_raddr_nop2pcb_6),
.i_pkt_rd_p6             (w_pkt_rd_nop2pcb_6),
.o_pkt_rd_ack_p6         (w_pkt_raddr_ack_pcb2nop_6),
.ov_pkt_p6               (wv_pkt_data_pcb2nop_6),   
.o_pkt_wr_p6             (w_pkt_data_wr_pcb2nop_6),

.iv_pkt_rd_bufadd_p7     (wv_pkt_raddr_nop2pcb_7),
.i_pkt_rd_p7             (w_pkt_rd_nop2pcb_7),
.o_pkt_rd_ack_p7         (w_pkt_raddr_ack_pcb2nop_7),
.ov_pkt_p7               (wv_pkt_data_pcb2nop_7),   
.o_pkt_wr_p7             (w_pkt_data_wr_pcb2nop_7),

.iv_pkt_rd_bufadd_p8     (wv_pkt_raddr_nop2pcb_8),
.i_pkt_rd_p8             (w_pkt_rd_nop2pcb_8),
.o_pkt_rd_ack_p8         (w_pkt_raddr_ack_pcb2nop_8),
.ov_pkt_p8               (wv_pkt_data_pcb2nop_8),   
.o_pkt_wr_p8             (w_pkt_data_wr_pcb2nop_8),

.ov_pkt_bufid_p0         (wv_bufid_pcb2nip_0),
.o_pkt_bufid_wr_p0       (w_bufid_wr_pcb2nip_0),
.i_pkt_bufid_ack_p0      (w_bufid_ack_nip2pcb_0),
                         
.ov_pkt_bufid_p1         (wv_bufid_pcb2nip_1),
.o_pkt_bufid_wr_p1       (w_bufid_wr_pcb2nip_1),
.i_pkt_bufid_ack_p1      (w_bufid_ack_nip2pcb_1),
                         
.ov_pkt_bufid_p2         (wv_bufid_pcb2nip_2),
.o_pkt_bufid_wr_p2       (w_bufid_wr_pcb2nip_2),
.i_pkt_bufid_ack_p2      (w_bufid_ack_nip2pcb_2),

.ov_pkt_bufid_p3         (wv_bufid_pcb2nip_3),
.o_pkt_bufid_wr_p3       (w_bufid_wr_pcb2nip_3),
.i_pkt_bufid_ack_p3      (w_bufid_ack_nip2pcb_3),

.ov_pkt_bufid_p4         (wv_bufid_pcb2nip_4),
.o_pkt_bufid_wr_p4       (w_bufid_wr_pcb2nip_4),
.i_pkt_bufid_ack_p4      (w_bufid_ack_nip2pcb_4),

.ov_pkt_bufid_p5         (wv_bufid_pcb2nip_5),
.o_pkt_bufid_wr_p5       (w_bufid_wr_pcb2nip_5),
.i_pkt_bufid_ack_p5      (w_bufid_ack_hrp2nip_5),

.ov_pkt_bufid_p6         (wv_bufid_pcb2nip_6),
.o_pkt_bufid_wr_p6       (w_bufid_wr_pcb2nip_6),
.i_pkt_bufid_ack_p6      (w_bufid_ack_hrp2nip_6),

.ov_pkt_bufid_p7         (wv_bufid_pcb2nip_7),
.o_pkt_bufid_wr_p7       (w_bufid_wr_pcb2nip_7),
.i_pkt_bufid_ack_p7      (w_bufid_ack_hrp2nip_7),

.ov_pkt_bufid_p8         (wv_bufid_pcb2nip_8),
.o_pkt_bufid_wr_p8       (w_bufid_wr_pcb2nip_8),
.i_pkt_bufid_ack_p8      (w_bufid_ack_hrp2nip_8),

.i_pkt_bufid_wr_flt      (w_pkt_bufid_wr_flt2pcb),
.iv_pkt_bufid_flt        (wv_pkt_bufid_flt2pcb),
.iv_pkt_bufid_cnt_flt    (wv_pkt_bufid_cnt_flt2pcb),

.iv_pkt_bufid_p0         (wv_pkt_bufid_nop2pcb_0),
.i_pkt_bufid_wr_p0       (w_pkt_bufid_wr_nop2pcb_0),
.o_pkt_bufid_ack_p0      (w_pkt_bufid_ack_pcb2nop_0),

.iv_pkt_bufid_p1         (wv_pkt_bufid_nop2pcb_1),
.i_pkt_bufid_wr_p1       (w_pkt_bufid_wr_nop2pcb_1),
.o_pkt_bufid_ack_p1      (w_pkt_bufid_ack_pcb2nop_1),

.iv_pkt_bufid_p2         (wv_pkt_bufid_nop2pcb_2),
.i_pkt_bufid_wr_p2       (w_pkt_bufid_wr_nop2pcb_2),
.o_pkt_bufid_ack_p2      (w_pkt_bufid_ack_pcb2nop_2),

.iv_pkt_bufid_p3         (wv_pkt_bufid_nop2pcb_3),
.i_pkt_bufid_wr_p3       (w_pkt_bufid_wr_nop2pcb_3),
.o_pkt_bufid_ack_p3      (w_pkt_bufid_ack_pcb2nop_3),

.iv_pkt_bufid_p4         (wv_pkt_bufid_nop2pcb_4),
.i_pkt_bufid_wr_p4       (w_pkt_bufid_wr_nop2pcb_4),
.o_pkt_bufid_ack_p4      (w_pkt_bufid_ack_pcb2nop_4),

.iv_pkt_bufid_p5         (wv_pkt_bufid_nop2pcb_5),
.i_pkt_bufid_wr_p5       (w_pkt_bufid_wr_nop2pcb_5),
.o_pkt_bufid_ack_p5      (w_pkt_bufid_ack_pcb2nop_5),

.iv_pkt_bufid_p6         (wv_pkt_bufid_nop2pcb_6),
.i_pkt_bufid_wr_p6       (w_pkt_bufid_wr_nop2pcb_6),
.o_pkt_bufid_ack_p6      (w_pkt_bufid_ack_pcb2nop_6),

.iv_pkt_bufid_p7         (wv_pkt_bufid_nop2pcb_7),
.i_pkt_bufid_wr_p7       (w_pkt_bufid_wr_nop2pcb_7),
.o_pkt_bufid_ack_p7      (w_pkt_bufid_ack_pcb2nop_7),

.iv_pkt_bufid_p8         (wv_pkt_bufid_nop2pcb_8),
.i_pkt_bufid_wr_p8       (w_pkt_bufid_wr_nop2pcb_8),
.o_pkt_bufid_ack_p8      (w_pkt_bufid_ack_pcb2nop_8),

.ov_pkt_write_state      (),             
.ov_pcb_pkt_read_state   (),          
.ov_address_write_state  (),         
.ov_address_read_state   (),          
.ov_free_buf_fifo_rdusedw(wv_free_buf_fifo_rdusedw_pcb2cpa)        
);

network_output_process_top network_output_process_top_inst(
.i_clk                  (i_clk),
.i_rst_n                (i_rst_n),

.iv_syn_clk             (iv_syn_clk                   ), 
.i_qbv_or_qch           (w_qbv_or_qch_grm2nop         ),     
.iv_time_slot_length    (ov_time_slot_length  ),
.iv_schedule_period     (ov_schedule_period   ),
//command signal
.iv_addr                (ov_addr_cit2all               ),
.iv_wdata               (ov_wdata_cit2all              ),
.i_addr_fixed           (o_addr_fixed_cit2all          ),

.i_wr_ctx_p0                      (w_wr_ctx_p0_cpe2ctx),
.i_rd_ctx_p0                      (w_rd_ctx_p0_cpe2ctx),
.o_wr_ctx_p0                      (w_wr_ctx_p0_ctx2cpe          ),  
.ov_addr_ctx_p0                   (wv_addr_ctx_p0_ctx2cpe       ),  
.o_addr_fixed_ctx_p0              (w_addr_fixed_ctx_p0_ctx2cpe  ),  
.ov_rdata_ctx_p0                  (wv_rdata_ctx_p0_ctx2cpe      ),  

.i_wr_ctx_p1                      (w_wr_ctx_p1_cpe2ctx),
.i_rd_ctx_p1                      (w_rd_ctx_p1_cpe2ctx),
.o_wr_ctx_p1                      (w_wr_ctx_p1_ctx2cpe          ),  
.ov_addr_ctx_p1                   (wv_addr_ctx_p1_ctx2cpe       ),  
.o_addr_fixed_ctx_p1              (w_addr_fixed_ctx_p1_ctx2cpe  ),  
.ov_rdata_ctx_p1                  (wv_rdata_ctx_p1_ctx2cpe      ), 

.i_wr_ctx_p2                      (w_wr_ctx_p2_cpe2ctx),
.i_rd_ctx_p2                      (w_rd_ctx_p2_cpe2ctx),
.o_wr_ctx_p2                      (w_wr_ctx_p2_ctx2cpe          ),  
.ov_addr_ctx_p2                   (wv_addr_ctx_p2_ctx2cpe       ),  
.o_addr_fixed_ctx_p2              (w_addr_fixed_ctx_p2_ctx2cpe  ),  
.ov_rdata_ctx_p2                  (wv_rdata_ctx_p2_ctx2cpe      ),  

.i_wr_ctx_p3                      (w_wr_ctx_p3_cpe2ctx),
.i_rd_ctx_p3                      (w_rd_ctx_p3_cpe2ctx),
.o_wr_ctx_p3                      (w_wr_ctx_p3_ctx2cpe          ),  
.ov_addr_ctx_p3                   (wv_addr_ctx_p3_ctx2cpe       ),  
.o_addr_fixed_ctx_p3              (w_addr_fixed_ctx_p3_ctx2cpe  ),  
.ov_rdata_ctx_p3                  (wv_rdata_ctx_p3_ctx2cpe      ),  

.i_wr_ctx_p4                      (w_wr_ctx_p4_cpe2ctx),
.i_rd_ctx_p4                      (w_rd_ctx_p4_cpe2ctx),
.o_wr_ctx_p4                      (w_wr_ctx_p4_ctx2cpe          ),  
.ov_addr_ctx_p4                   (wv_addr_ctx_p4_ctx2cpe       ),  
.o_addr_fixed_ctx_p4              (w_addr_fixed_ctx_p4_ctx2cpe  ),  
.ov_rdata_ctx_p4                  (wv_rdata_ctx_p4_ctx2cpe      ),  

.i_wr_ctx_p5                      (w_wr_ctx_p5_cpe2ctx),
.i_rd_ctx_p5                      (w_rd_ctx_p5_cpe2ctx),
.o_wr_ctx_p5                      (w_wr_ctx_p5_ctx2cpe          ),  
.ov_addr_ctx_p5                   (wv_addr_ctx_p5_ctx2cpe       ),  
.o_addr_fixed_ctx_p5              (w_addr_fixed_ctx_p5_ctx2cpe  ),  
.ov_rdata_ctx_p5                  (wv_rdata_ctx_p5_ctx2cpe      ),  

.i_wr_ctx_p6                      (w_wr_ctx_p6_cpe2ctx),
.i_rd_ctx_p6                      (w_rd_ctx_p6_cpe2ctx),
.o_wr_ctx_p6                      (w_wr_ctx_p6_ctx2cpe          ),  
.ov_addr_ctx_p6                   (wv_addr_ctx_p6_ctx2cpe       ),  
.o_addr_fixed_ctx_p6              (w_addr_fixed_ctx_p6_ctx2cpe  ),  
.ov_rdata_ctx_p6                  (wv_rdata_ctx_p6_ctx2cpe      ),  

.i_wr_ctx_p7                      (w_wr_ctx_p7_cpe2ctx),
.i_rd_ctx_p7                      (w_rd_ctx_p7_cpe2ctx),
.o_wr_ctx_p7                      (w_wr_ctx_p7                  ),  
.ov_addr_ctx_p7                   (wv_addr_ctx_p7               ),  
.o_addr_fixed_ctx_p7              (w_addr_fixed_ctx_p7          ),  
.ov_rdata_ctx_p7                  (wv_rdata_ctx_p7              ), 
                    
.i_wr_qgc0              (w_wr_cit2qgc0                 ),
.i_rd_qgc0              (w_rd_cit2qgc0                 ),
.o_wr_qgc0              (w_wr_qgc02cit                 ),
.ov_addr_qgc0           (wv_addr_qgc02cit              ),
.o_addr_fixed_qgc0      (w_addr_fixed_qgc02cit         ),
.ov_rdata_qgc0          (wv_rdata_qgc02cit             ),
                         
.i_wr_qgc1              (w_wr_cit2qgc1                 ),
.i_rd_qgc1              (w_rd_cit2qgc1                 ),
.o_wr_qgc1              (w_wr_qgc12cit                 ),
.ov_addr_qgc1           (wv_addr_qgc12cit              ),
.o_addr_fixed_qgc1      (w_addr_fixed_qgc12cit         ),
.ov_rdata_qgc1          (wv_rdata_qgc12cit             ),
                         
.i_wr_qgc2              (w_wr_cit2qgc2                 ),
.i_rd_qgc2              (w_rd_cit2qgc2                 ),
.o_wr_qgc2              (w_wr_qgc22cit                 ),
.ov_addr_qgc2           (wv_addr_qgc22cit              ),
.o_addr_fixed_qgc2      (w_addr_fixed_qgc22cit         ),
.ov_rdata_qgc2          (wv_rdata_qgc22cit             ),
                         
.i_wr_qgc3              (w_wr_cit2qgc3                 ),
.i_rd_qgc3              (w_rd_cit2qgc3                 ),
.o_wr_qgc3              (w_wr_qgc32cit                 ),
.ov_addr_qgc3           (wv_addr_qgc32cit              ),
.o_addr_fixed_qgc3      (w_addr_fixed_qgc32cit         ),
.ov_rdata_qgc3          (wv_rdata_qgc32cit             ),
                         
.i_wr_qgc4              (w_wr_cit2qgc4                 ),
.i_rd_qgc4              (w_rd_cit2qgc4                 ),
.o_wr_qgc4              (w_wr_qgc42cit                 ),
.ov_addr_qgc4           (wv_addr_qgc42cit              ),
.o_addr_fixed_qgc4      (w_addr_fixed_qgc42cit         ),
.ov_rdata_qgc4          (wv_rdata_qgc42cit             ),
                         
.i_wr_qgc5              (w_wr_cit2qgc5                 ),
.i_rd_qgc5              (w_rd_cit2qgc5                 ),
.o_wr_qgc5              (w_wr_qgc52cit                 ),
.ov_addr_qgc5           (wv_addr_qgc52cit              ),
.o_addr_fixed_qgc5      (w_addr_fixed_qgc52cit         ),
.ov_rdata_qgc5          (wv_rdata_qgc52cit             ),
                         
.i_wr_qgc6              (w_wr_cit2qgc6                 ),
.i_rd_qgc6              (w_rd_cit2qgc6                 ),
.o_wr_qgc6              (w_wr_qgc62cit                 ),
.ov_addr_qgc6           (wv_addr_qgc62cit              ),
.o_addr_fixed_qgc6      (w_addr_fixed_qgc62cit         ),
.ov_rdata_qgc6          (wv_rdata_qgc62cit             ),
                         
.i_wr_qgc7              (w_wr_cit2qgc7                 ),
.i_rd_qgc7              (w_rd_cit2qgc7                 ),                              
.o_wr_qgc7              (w_wr_qgc72cit                 ),
.ov_addr_qgc7           (wv_addr_qgc72cit              ),
.o_addr_fixed_qgc7      (w_addr_fixed_qgc72cit         ),
.ov_rdata_qgc7          (wv_rdata_qgc72cit             ),
//port 0
.iv_pkt_bufid_p0        (wv_pkt_bufid_flt2nop_0),
.iv_pkt_type_p0         (wv_pkt_type_flt2nop_0),
.i_pkt_bufid_wr_p0      (w_pkt_bufid_wr_flt2nop_0),

.ov_pkt_bufid_p0        (wv_pkt_bufid_nop2pcb_0),
.o_pkt_bufid_wr_p0      (w_pkt_bufid_wr_nop2pcb_0),
.i_pkt_bufid_ack_p0     (w_pkt_bufid_ack_pcb2nop_0),

.ov_pkt_raddr_p0        (wv_pkt_raddr_nop2pcb_0),
.o_pkt_rd_p0            (w_pkt_rd_nop2pcb_0),
.i_pkt_raddr_ack_p0     (w_pkt_raddr_ack_pcb2nop_0),

.iv_pkt_data_p0         (wv_pkt_data_pcb2nop_0),
.i_pkt_data_wr_p0       (w_pkt_data_wr_pcb2nop_0),

.ov_gmii_txd_p0         (ov_gmii_txd_p0),
.o_gmii_tx_en_p0        (o_gmii_tx_en_p0),      
                                                       
.ov_osc_state_p0        (),                            
.ov_prc_state_p0        (),
.ov_opc_state_p0        (),
//port 1
.iv_pkt_bufid_p1        (wv_pkt_bufid_flt2nop_1),
.iv_pkt_type_p1         (wv_pkt_type_flt2nop_1),
.i_pkt_bufid_wr_p1      (w_pkt_bufid_wr_flt2nop_1),

.ov_pkt_bufid_p1        (wv_pkt_bufid_nop2pcb_1),
.o_pkt_bufid_wr_p1      (w_pkt_bufid_wr_nop2pcb_1),
.i_pkt_bufid_ack_p1     (w_pkt_bufid_ack_pcb2nop_1),

.ov_pkt_raddr_p1        (wv_pkt_raddr_nop2pcb_1),
.o_pkt_rd_p1            (w_pkt_rd_nop2pcb_1),
.i_pkt_raddr_ack_p1     (w_pkt_raddr_ack_pcb2nop_1),

.iv_pkt_data_p1         (wv_pkt_data_pcb2nop_1),
.i_pkt_data_wr_p1       (w_pkt_data_wr_pcb2nop_1),

.ov_gmii_txd_p1         (ov_gmii_txd_p1),
.o_gmii_tx_en_p1        (o_gmii_tx_en_p1),     

.ov_osc_state_p1        (),
.ov_prc_state_p1        (),
.ov_opc_state_p1        (),
//port 2
.iv_pkt_bufid_p2        (wv_pkt_bufid_flt2nop_2),
.iv_pkt_type_p2         (wv_pkt_type_flt2nop_2),
.i_pkt_bufid_wr_p2      (w_pkt_bufid_wr_flt2nop_2),

.ov_pkt_bufid_p2        (wv_pkt_bufid_nop2pcb_2),
.o_pkt_bufid_wr_p2      (w_pkt_bufid_wr_nop2pcb_2),
.i_pkt_bufid_ack_p2     (w_pkt_bufid_ack_pcb2nop_2),

.ov_pkt_raddr_p2        (wv_pkt_raddr_nop2pcb_2),
.o_pkt_rd_p2            (w_pkt_rd_nop2pcb_2),
.i_pkt_raddr_ack_p2     (w_pkt_raddr_ack_pcb2nop_2),

.iv_pkt_data_p2         (wv_pkt_data_pcb2nop_2),
.i_pkt_data_wr_p2       (w_pkt_data_wr_pcb2nop_2),

.ov_gmii_txd_p2         (ov_gmii_txd_p2),
.o_gmii_tx_en_p2        (o_gmii_tx_en_p2),

.ov_osc_state_p2        (),
.ov_prc_state_p2        (),
.ov_opc_state_p2        (),         
//port 3
.iv_pkt_bufid_p3        (wv_pkt_bufid_flt2nop_3),
.iv_pkt_type_p3         (wv_pkt_type_flt2nop_3),
.i_pkt_bufid_wr_p3      (w_pkt_bufid_wr_flt2nop_3),
                        
.ov_pkt_bufid_p3        (wv_pkt_bufid_nop2pcb_3),
.o_pkt_bufid_wr_p3      (w_pkt_bufid_wr_nop2pcb_3),
.i_pkt_bufid_ack_p3     (w_pkt_bufid_ack_pcb2nop_3),
                        
.ov_pkt_raddr_p3        (wv_pkt_raddr_nop2pcb_3),
.o_pkt_rd_p3            (w_pkt_rd_nop2pcb_3),
.i_pkt_raddr_ack_p3     (w_pkt_raddr_ack_pcb2nop_3),
                        
.iv_pkt_data_p3         (wv_pkt_data_pcb2nop_3),
.i_pkt_data_wr_p3       (w_pkt_data_wr_pcb2nop_3),
                        
.ov_gmii_txd_p3         (ov_gmii_txd_p3),
.o_gmii_tx_en_p3        (o_gmii_tx_en_p3),      
                        
.ov_osc_state_p3        (),
.ov_prc_state_p3        (),
.ov_opc_state_p3        (),
//port 4
.iv_pkt_bufid_p4        (wv_pkt_bufid_flt2nop_4),
.iv_pkt_type_p4         (wv_pkt_type_flt2nop_4),
.i_pkt_bufid_wr_p4      (w_pkt_bufid_wr_flt2nop_4),
                        
.ov_pkt_bufid_p4        (wv_pkt_bufid_nop2pcb_4),
.o_pkt_bufid_wr_p4      (w_pkt_bufid_wr_nop2pcb_4),
.i_pkt_bufid_ack_p4     (w_pkt_bufid_ack_pcb2nop_4),
                        
.ov_pkt_raddr_p4        (wv_pkt_raddr_nop2pcb_4),
.o_pkt_rd_p4            (w_pkt_rd_nop2pcb_4),
.i_pkt_raddr_ack_p4     (w_pkt_raddr_ack_pcb2nop_4),
                        
.iv_pkt_data_p4         (wv_pkt_data_pcb2nop_4),
.i_pkt_data_wr_p4       (w_pkt_data_wr_pcb2nop_4),
                        
.ov_gmii_txd_p4         (ov_gmii_txd_p4),
.o_gmii_tx_en_p4        (o_gmii_tx_en_p4),

.ov_osc_state_p4        (),
.ov_prc_state_p4        (),
.ov_opc_state_p4        (),

//port 5
.iv_pkt_bufid_p5        (wv_pkt_bufid_flt2nop_5),
.iv_pkt_type_p5         (wv_pkt_type_flt2nop_5),
.i_pkt_bufid_wr_p5      (w_pkt_bufid_wr_flt2nop_5),
                        
.ov_pkt_bufid_p5        (wv_pkt_bufid_nop2pcb_5),
.o_pkt_bufid_wr_p5      (w_pkt_bufid_wr_nop2pcb_5),
.i_pkt_bufid_ack_p5     (w_pkt_bufid_ack_pcb2nop_5),
                        
.ov_pkt_raddr_p5        (wv_pkt_raddr_nop2pcb_5),
.o_pkt_rd_p5            (w_pkt_rd_nop2pcb_5),
.i_pkt_raddr_ack_p5     (w_pkt_raddr_ack_pcb2nop_5),
                        
.iv_pkt_data_p5         (wv_pkt_data_pcb2nop_5),
.i_pkt_data_wr_p5       (w_pkt_data_wr_pcb2nop_5),
                        
.ov_gmii_txd_p5         (ov_gmii_txd_p5),
.o_gmii_tx_en_p5        (o_gmii_tx_en_p5),
 
.ov_osc_state_p5        (),
.ov_prc_state_p5        (),
.ov_opc_state_p5        (),
//port 6
.iv_pkt_bufid_p6        (wv_pkt_bufid_flt2nop_6),
.iv_pkt_type_p6         (wv_pkt_type_flt2nop_6),
.i_pkt_bufid_wr_p6      (w_pkt_bufid_wr_flt2nop_6),
                        
.ov_pkt_bufid_p6        (wv_pkt_bufid_nop2pcb_6),
.o_pkt_bufid_wr_p6      (w_pkt_bufid_wr_nop2pcb_6),
.i_pkt_bufid_ack_p6     (w_pkt_bufid_ack_pcb2nop_6),
                        
.ov_pkt_raddr_p6        (wv_pkt_raddr_nop2pcb_6),
.o_pkt_rd_p6            (w_pkt_rd_nop2pcb_6),
.i_pkt_raddr_ack_p6     (w_pkt_raddr_ack_pcb2nop_6),
                        
.iv_pkt_data_p6         (wv_pkt_data_pcb2nop_6),
.i_pkt_data_wr_p6       (w_pkt_data_wr_pcb2nop_6),
                        
.ov_gmii_txd_p6         (ov_gmii_txd_p6),
.o_gmii_tx_en_p6        (o_gmii_tx_en_p6),
      
.ov_osc_state_p6        (),
.ov_prc_state_p6        (),
.ov_opc_state_p6        (),
//port 7
.iv_pkt_bufid_p7        (wv_pkt_bufid_flt2nop_7),
.iv_pkt_type_p7         (wv_pkt_type_flt2nop_7),
.i_pkt_bufid_wr_p7      (w_pkt_bufid_wr_flt2nop_7),
                        
.ov_pkt_bufid_p7        (wv_pkt_bufid_nop2pcb_7),
.o_pkt_bufid_wr_p7      (w_pkt_bufid_wr_nop2pcb_7),
.i_pkt_bufid_ack_p7     (w_pkt_bufid_ack_pcb2nop_7),
                        
.ov_pkt_raddr_p7        (wv_pkt_raddr_nop2pcb_7),
.o_pkt_rd_p7            (w_pkt_rd_nop2pcb_7),
.i_pkt_raddr_ack_p7     (w_pkt_raddr_ack_pcb2nop_7),
                        
.iv_pkt_data_p7         (wv_pkt_data_pcb2nop_7),
.i_pkt_data_wr_p7       (w_pkt_data_wr_pcb2nop_7),
                        
.ov_gmii_txd_p7         (ov_gmii_txd_p7),
.o_gmii_tx_en_p7        (o_gmii_tx_en_p7),
        
.ov_osc_state_p7        (),
.ov_prc_state_p7        (),
.ov_opc_state_p7        () 
);

control_output_process control_output_process_inst(
.i_clk                  (i_clk),
.i_rst_n                (i_rst_n),

.i_wr_ctx             (w_wr_ctx_p8_cpe2ctx          ),
.i_rd_ctx             (w_rd_ctx_p8_cpe2ctx          ),
.o_wr_ctx             (w_wr_ctx_p8_ctx2cpe          ),  
.ov_addr_ctx          (wv_addr_ctx_p8_ctx2cpe       ),  
.o_addr_fixed_ctx     (w_addr_fixed_ctx_p8_ctx2cpe  ),  
.ov_rdata_ctx         (wv_rdata_ctx_p8_ctx2cpe      ),  

.iv_pkt_bufid_ctrl      (wv_pkt_bufid_flt2nop_8   ),
.iv_pkt_type_ctrl       (wv_pkt_type_flt2nop_8    ),
.i_mac_entry_hit_ctrl   (w_mac_entry_hit_8        ),
.iv_pkt_inport_ctrl     (wv_pkt_inport_8          ),
.i_pkt_bufid_wr_ctrl    (w_pkt_bufid_wr_flt2nop_8 ),
                        
.ov_pkt_bufid           (wv_pkt_bufid_nop2pcb_8   ),
.o_pkt_bufid_wr         (w_pkt_bufid_wr_nop2pcb_8 ),
.i_pkt_bufid_ack        (w_pkt_bufid_ack_pcb2nop_8),
                        
.ov_pkt_raddr           (wv_pkt_raddr_nop2pcb_8   ),
.o_pkt_rd               (w_pkt_rd_nop2pcb_8       ),
.i_pkt_raddr_ack        (w_pkt_raddr_ack_pcb2nop_8),
                        
.iv_pkt_data            (wv_pkt_data_pcb2nop_8    ),
.i_pkt_data_wr          (w_pkt_data_wr_pcb2nop_8  ),
                        
.ov_hcp_data            (ov_gmii_txd_p8           ),
.o_hcp_data_wr          (o_gmii_tx_en_p8          ),
                        
.ov_eth_data            (wv_eth_data_cop2msl              ),  
.o_eth_data_wr          (w_eth_data_wr_cop2msl            ),
                  
.hoi_state              (),
.bufid_state            (),
.pkt_read_state         ()
);
  

mac_self_learning_top mac_self_learning_top_inst
(
        .i_clk          (i_clk    ),
        .i_rst_n        (i_rst_n  ),

	    .i_data_wr      (w_eth_data_wr_cop2msl),
	    .iv_data        (wv_eth_data_cop2msl  ),   

        .ov_smac_inport (wv_dmacram_wdata_msl2flt),
        .ov_entry_addr  (wv_dmacram_addr_msl2flt ),
        .o_mactable_wr  (w_dmacram_wr_msl2flt    )
);  
command_parse_and_encapsulate_tss command_parse_and_encapsulate_tss_inst(
.i_clk		                      (i_clk                               ),
.i_rst_n	                      (i_rst_n                             ),
                                                                       
.iv_command                       (iv_command                          ), 
.i_command_wr                     (i_command_wr                        ),          
                                                                       
.ov_addr                          (ov_addr_cit2all                     ),
.ov_wdata                         (ov_wdata_cit2all                    ),
.o_addr_fixed                     (o_addr_fixed_cit2all                ),

.o_wr_stc                         (o_wr_stc   ),
.o_rd_stc                         (o_rd_stc   ),

.o_wr_ffi_p8                      (w_wr_ffi_p8_cpe2ffi),
.o_rd_ffi_p8                      (w_rd_ffi_p8_cpe2ffi),
.o_wr_dex_p8                      (w_wr_dex_p8_cpe2dex),
.o_rd_dex_p8                      (w_rd_dex_p8_cpe2dex),
.o_wr_ctx_p8                      (w_wr_ctx_p8_cpe2ctx),
.o_rd_ctx_p8                      (w_rd_ctx_p8_cpe2ctx),
.o_wr_cdc_p8                      (o_wr_cdc_p8),
.o_rd_cdc_p8                      (o_rd_cdc_p8),

.o_wr_ffi_p0                      (w_wr_ffi_p0_cpe2ffi),
.o_rd_ffi_p0                      (w_rd_ffi_p0_cpe2ffi),
.o_wr_dex_p0                      (w_wr_dex_p0_cpe2dex),
.o_rd_dex_p0                      (w_rd_dex_p0_cpe2dex),
.o_wr_ctx_p0                      (w_wr_ctx_p0_cpe2ctx),
.o_rd_ctx_p0                      (w_rd_ctx_p0_cpe2ctx),
.o_wr_cdc_p0                      (o_wr_cdc_p0),
.o_rd_cdc_p0                      (o_rd_cdc_p0),

.o_wr_ffi_p1                      (w_wr_ffi_p1_cpe2ffi),
.o_rd_ffi_p1                      (w_rd_ffi_p1_cpe2ffi),
.o_wr_dex_p1                      (w_wr_dex_p1_cpe2dex),
.o_rd_dex_p1                      (w_rd_dex_p1_cpe2dex),
.o_wr_ctx_p1                      (w_wr_ctx_p1_cpe2ctx),
.o_rd_ctx_p1                      (w_rd_ctx_p1_cpe2ctx),
.o_wr_cdc_p1                      (o_wr_cdc_p1),
.o_rd_cdc_p1                      (o_rd_cdc_p1),

.o_wr_ffi_p2                      (w_wr_ffi_p2_cpe2ffi),
.o_rd_ffi_p2                      (w_rd_ffi_p2_cpe2ffi),
.o_wr_dex_p2                      (w_wr_dex_p2_cpe2dex),
.o_rd_dex_p2                      (w_rd_dex_p2_cpe2dex),
.o_wr_ctx_p2                      (w_wr_ctx_p2_cpe2ctx),
.o_rd_ctx_p2                      (w_rd_ctx_p2_cpe2ctx),
.o_wr_cdc_p2                      (o_wr_cdc_p2),
.o_rd_cdc_p2                      (o_rd_cdc_p2),

.o_wr_ffi_p3                      (w_wr_ffi_p3_cpe2ffi),
.o_rd_ffi_p3                      (w_rd_ffi_p3_cpe2ffi),
.o_wr_dex_p3                      (w_wr_dex_p3_cpe2dex),
.o_rd_dex_p3                      (w_rd_dex_p3_cpe2dex),
.o_wr_ctx_p3                      (w_wr_ctx_p3_cpe2ctx),
.o_rd_ctx_p3                      (w_rd_ctx_p3_cpe2ctx),
.o_wr_cdc_p3                      (o_wr_cdc_p3),
.o_rd_cdc_p3                      (o_rd_cdc_p3),

.o_wr_ffi_p4                      (w_wr_ffi_p4_cpe2ffi),
.o_rd_ffi_p4                      (w_rd_ffi_p4_cpe2ffi),
.o_wr_dex_p4                      (w_wr_dex_p4_cpe2dex),
.o_rd_dex_p4                      (w_rd_dex_p4_cpe2dex),
.o_wr_ctx_p4                      (w_wr_ctx_p4_cpe2ctx),
.o_rd_ctx_p4                      (w_rd_ctx_p4_cpe2ctx),
.o_wr_cdc_p4                      (o_wr_cdc_p4),
.o_rd_cdc_p4                      (o_rd_cdc_p4),

.o_wr_ffi_p5                      (w_wr_ffi_p5_cpe2ffi),
.o_rd_ffi_p5                      (w_rd_ffi_p5_cpe2ffi),
.o_wr_dex_p5                      (w_wr_dex_p5_cpe2dex),
.o_rd_dex_p5                      (w_rd_dex_p5_cpe2dex),
.o_wr_ctx_p5                      (w_wr_ctx_p5_cpe2ctx),
.o_rd_ctx_p5                      (w_rd_ctx_p5_cpe2ctx),
.o_wr_cdc_p5                      (o_wr_cdc_p5),
.o_rd_cdc_p5                      (o_rd_cdc_p5),

.o_wr_ffi_p6                      (w_wr_ffi_p6_cpe2ffi),
.o_rd_ffi_p6                      (w_rd_ffi_p6_cpe2ffi),
.o_wr_dex_p6                      (w_wr_dex_p6_cpe2dex),
.o_rd_dex_p6                      (w_rd_dex_p6_cpe2dex),
.o_wr_ctx_p6                      (w_wr_ctx_p6_cpe2ctx),
.o_rd_ctx_p6                      (w_rd_ctx_p6_cpe2ctx),
.o_wr_cdc_p6                      (o_wr_cdc_p6),
.o_rd_cdc_p6                      (o_rd_cdc_p6),

.o_wr_ffi_p7                      (w_wr_ffi_p7_cpe2ffi),
.o_rd_ffi_p7                      (w_rd_ffi_p7_cpe2ffi),
.o_wr_dex_p7                      (w_wr_dex_p7_cpe2dex),
.o_rd_dex_p7                      (w_rd_dex_p7_cpe2dex),
.o_wr_ctx_p7                      (w_wr_ctx_p7_cpe2ctx),
.o_rd_ctx_p7                      (w_rd_ctx_p7_cpe2ctx),
.o_wr_cdc_p7                      (o_wr_cdc_p7),
.o_rd_cdc_p7                      (o_rd_cdc_p7),
                                                                      
.o_wr_grm                         (w_wr_cit2grm                        ),
.o_rd_grm                         (w_rd_cit2grm                        ),	
                                                                       
.o_wr_flt                         (w_wr_cit2flt                        ),
.o_rd_flt                         (w_rd_cit2flt                        ),
                                                                       
.o_wr_pcb                         (w_wr_cit2pcb                        ),
.o_rd_pcb                         (w_rd_cit2pcb                        ),
                                                                       
.o_wr_qgc0                        (w_wr_cit2qgc0                       ),
.o_rd_qgc0                        (w_rd_cit2qgc0                       ),
                                                                       
.o_wr_qgc1                        (w_wr_cit2qgc1                       ),
.o_rd_qgc1                        (w_rd_cit2qgc1                       ),
                                                                       
.o_wr_qgc2                        (w_wr_cit2qgc2                       ),
.o_rd_qgc2                        (w_rd_cit2qgc2                       ),
                                                                       
.o_wr_qgc3                        (w_wr_cit2qgc3                       ),
.o_rd_qgc3                        (w_rd_cit2qgc3                       ),
                                                                       
.o_wr_qgc4                        (w_wr_cit2qgc4                       ),
.o_rd_qgc4                        (w_rd_cit2qgc4                       ),
                                                                       
.o_wr_qgc5                        (w_wr_cit2qgc5                       ),
.o_rd_qgc5                        (w_rd_cit2qgc5                       ),
                                                                       
.o_wr_qgc6                        (w_wr_cit2qgc6                       ),
.o_rd_qgc6                        (w_rd_cit2qgc6                       ),
                                                                       
.o_wr_qgc7                        (w_wr_cit2qgc7                       ),
.o_rd_qgc7                        (w_rd_cit2qgc7                       ), 

.o_wr_cfu                         (o_wr_cfu                            ),
.o_rd_cfu                         (o_rd_cfu                            ), 

.i_wr_stc                         (i_wr_stc                            ),
.iv_addr_stc                      (iv_addr_stc                         ),
.i_addr_fixed_stc                 (i_addr_fixed_stc                    ),
.iv_rdata_stc                     (iv_rdata_stc                        ),
                                                                       
.i_wr_cfu                         (i_wr_cfu                            ),
.iv_addr_cfu                      (iv_addr_cfu                         ),
.i_addr_fixed_cfu                 (i_addr_fixed_cfu                    ),
.iv_rdata_cfu                     (iv_rdata_cfu                        ),

.i_wr_ffi_p8                      (w_wr_ffi_p8_ffi2cpe                 ),
.iv_addr_ffi_p8                   (wv_addr_ffi_p8_ffi2cpe              ),
.i_addr_fixed_ffi_p8              (w_addr_fixed_ffi_p8_ffi2cpe         ),
.iv_rdata_ffi_p8                  (wv_rdata_ffi_p8_ffi2cpe             ),
                                                                       
.i_wr_dex_p8                      (w_wr_dex_p8_dex2cpe                 ),
.iv_addr_dex_p8                   (wv_addr_dex_p8_dex2cpe              ),
.i_addr_fixed_dex_p8              (w_addr_fixed_dex_p8_dex2cpe         ),
.iv_rdata_dex_p8                  (wv_rdata_dex_p8_dex2cpe             ),
                                                                       
.i_wr_ctx_p8                      (w_wr_ctx_p8_ctx2cpe                 ),
.iv_addr_ctx_p8                   (wv_addr_ctx_p8_ctx2cpe              ),
.i_addr_fixed_ctx_p8              (w_addr_fixed_ctx_p8_ctx2cpe         ),
.iv_rdata_ctx_p8                  (wv_rdata_ctx_p8_ctx2cpe             ),
                                                                       
.i_wr_cdc_p8                      (i_wr_cdc_p8        ),
.iv_addr_cdc_p8                   (iv_addr_cdc_p8     ),
.i_addr_fixed_cdc_p8              (i_addr_fixed_cdc_p8),
.iv_rdata_cdc_p8                  (iv_rdata_cdc_p8    ),
                                                                       
.i_wr_ffi_p0                      (w_wr_ffi_p0_ffi2cpe                 ),
.iv_addr_ffi_p0                   (wv_addr_ffi_p0_ffi2cpe              ),
.i_addr_fixed_ffi_p0              (w_addr_fixed_ffi_p0_ffi2cpe         ),
.iv_rdata_ffi_p0                  (wv_rdata_ffi_p0_ffi2cpe             ),
                                                                       
.i_wr_dex_p0                      (w_wr_dex_p0_dex2cpe                 ),
.iv_addr_dex_p0                   (wv_addr_dex_p0_dex2cpe              ),
.i_addr_fixed_dex_p0              (w_addr_fixed_dex_p0_dex2cpe         ),
.iv_rdata_dex_p0                  (wv_rdata_dex_p0_dex2cpe             ),
                                                                       
.i_wr_ctx_p0                      (w_wr_ctx_p0_ctx2cpe                 ),
.iv_addr_ctx_p0                   (wv_addr_ctx_p0_ctx2cpe              ),
.i_addr_fixed_ctx_p0              (w_addr_fixed_ctx_p0_ctx2cpe         ),
.iv_rdata_ctx_p0                  (wv_rdata_ctx_p0_ctx2cpe             ),
                                                                       
.i_wr_cdc_p0                      (i_wr_cdc_p0         ),
.iv_addr_cdc_p0                   (iv_addr_cdc_p0      ),
.i_addr_fixed_cdc_p0              (i_addr_fixed_cdc_p0 ),
.iv_rdata_cdc_p0                  (iv_rdata_cdc_p0     ),
                                                                       
.i_wr_ffi_p1                      (w_wr_ffi_p1_ffi2cpe                 ),
.iv_addr_ffi_p1                   (wv_addr_ffi_p1_ffi2cpe              ),
.i_addr_fixed_ffi_p1              (w_addr_fixed_ffi_p1_ffi2cpe         ),
.iv_rdata_ffi_p1                  (wv_rdata_ffi_p1_ffi2cpe             ),
                                                                       
.i_wr_dex_p1                      (w_wr_dex_p1_dex2cpe                 ),
.iv_addr_dex_p1                   (wv_addr_dex_p1_dex2cpe              ),
.i_addr_fixed_dex_p1              (w_addr_fixed_dex_p1_dex2cpe         ),
.iv_rdata_dex_p1                  (wv_rdata_dex_p1_dex2cpe             ),
                                                                       
.i_wr_ctx_p1                      (w_wr_ctx_p1_ctx2cpe                 ),
.iv_addr_ctx_p1                   (wv_addr_ctx_p1_ctx2cpe              ),
.i_addr_fixed_ctx_p1              (w_addr_fixed_ctx_p1_ctx2cpe         ),
.iv_rdata_ctx_p1                  (wv_rdata_ctx_p1_ctx2cpe             ),
                                                                       
.i_wr_cdc_p1                      (i_wr_cdc_p1        ),
.iv_addr_cdc_p1                   (iv_addr_cdc_p1     ),
.i_addr_fixed_cdc_p1              (i_addr_fixed_cdc_p1),
.iv_rdata_cdc_p1                  (iv_rdata_cdc_p1    ),
                                                                       
.i_wr_ffi_p2                      (w_wr_ffi_p2_ffi2cpe                 ),
.iv_addr_ffi_p2                   (wv_addr_ffi_p2_ffi2cpe              ),
.i_addr_fixed_ffi_p2              (w_addr_fixed_ffi_p2_ffi2cpe         ),
.iv_rdata_ffi_p2                  (wv_rdata_ffi_p2_ffi2cpe             ),
                                                                       
.i_wr_dex_p2                      (w_wr_dex_p2_dex2cpe                 ),
.iv_addr_dex_p2                   (wv_addr_dex_p2_dex2cpe              ),
.i_addr_fixed_dex_p2              (w_addr_fixed_dex_p2_dex2cpe         ),
.iv_rdata_dex_p2                  (wv_rdata_dex_p2_dex2cpe             ),
                                                                       
.i_wr_ctx_p2                      (w_wr_ctx_p2_ctx2cpe                 ),
.iv_addr_ctx_p2                   (wv_addr_ctx_p2_ctx2cpe              ),
.i_addr_fixed_ctx_p2              (w_addr_fixed_ctx_p2_ctx2cpe         ),
.iv_rdata_ctx_p2                  (wv_rdata_ctx_p2_ctx2cpe             ),
                                                                       
.i_wr_cdc_p2                      (i_wr_cdc_p2         ),
.iv_addr_cdc_p2                   (iv_addr_cdc_p2      ),
.i_addr_fixed_cdc_p2              (i_addr_fixed_cdc_p2 ),
.iv_rdata_cdc_p2                  (iv_rdata_cdc_p2     ),
                                                                       
.i_wr_ffi_p3                      (w_wr_ffi_p3_ffi2cpe                 ),
.iv_addr_ffi_p3                   (wv_addr_ffi_p3_ffi2cpe              ),
.i_addr_fixed_ffi_p3              (w_addr_fixed_ffi_p3_ffi2cpe         ),
.iv_rdata_ffi_p3                  (wv_rdata_ffi_p3_ffi2cpe             ),
                                                                       
.i_wr_dex_p3                      (w_wr_dex_p3_dex2cpe                 ),
.iv_addr_dex_p3                   (wv_addr_dex_p3_dex2cpe              ),
.i_addr_fixed_dex_p3              (w_addr_fixed_dex_p3_dex2cpe         ),
.iv_rdata_dex_p3                  (wv_rdata_dex_p3_dex2cpe             ),
                                                                       
.i_wr_ctx_p3                      (w_wr_ctx_p3_ctx2cpe                 ),
.iv_addr_ctx_p3                   (wv_addr_ctx_p3_ctx2cpe              ),
.i_addr_fixed_ctx_p3              (w_addr_fixed_ctx_p3_ctx2cpe         ),
.iv_rdata_ctx_p3                  (wv_rdata_ctx_p3_ctx2cpe             ),
                                                                       
.i_wr_cdc_p3                      (i_wr_cdc_p3        ),
.iv_addr_cdc_p3                   (iv_addr_cdc_p3     ),
.i_addr_fixed_cdc_p3              (i_addr_fixed_cdc_p3),
.iv_rdata_cdc_p3                  (iv_rdata_cdc_p3    ),
                                                                       
.i_wr_ffi_p4                      (w_wr_ffi_p4_ffi2cpe                 ),
.iv_addr_ffi_p4                   (wv_addr_ffi_p4_ffi2cpe              ),
.i_addr_fixed_ffi_p4              (w_addr_fixed_ffi_p4_ffi2cpe         ),
.iv_rdata_ffi_p4                  (wv_rdata_ffi_p4_ffi2cpe             ),
                                                                       
.i_wr_dex_p4                      (w_wr_dex_p4_dex2cpe                 ),
.iv_addr_dex_p4                   (wv_addr_dex_p4_dex2cpe              ),
.i_addr_fixed_dex_p4              (w_addr_fixed_dex_p4_dex2cpe         ),
.iv_rdata_dex_p4                  (wv_rdata_dex_p4_dex2cpe             ),
                                                                       
.i_wr_ctx_p4                      (w_wr_ctx_p4_ctx2cpe                 ),
.iv_addr_ctx_p4                   (wv_addr_ctx_p4_ctx2cpe              ),
.i_addr_fixed_ctx_p4              (w_addr_fixed_ctx_p4_ctx2cpe         ),
.iv_rdata_ctx_p4                  (wv_rdata_ctx_p4_ctx2cpe             ),
                                                                       
.i_wr_cdc_p4                      (i_wr_cdc_p4        ),
.iv_addr_cdc_p4                   (iv_addr_cdc_p4     ),
.i_addr_fixed_cdc_p4              (i_addr_fixed_cdc_p4),
.iv_rdata_cdc_p4                  (iv_rdata_cdc_p4    ),
                                                                       
.i_wr_ffi_p5                      (w_wr_ffi_p5_ffi2cpe                 ),
.iv_addr_ffi_p5                   (wv_addr_ffi_p5_ffi2cpe              ),
.i_addr_fixed_ffi_p5              (w_addr_fixed_ffi_p5_ffi2cpe         ),
.iv_rdata_ffi_p5                  (wv_rdata_ffi_p5_ffi2cpe             ),
                                                                       
.i_wr_dex_p5                      (w_wr_dex_p5_dex2cpe                 ),
.iv_addr_dex_p5                   (wv_addr_dex_p5_dex2cpe              ),
.i_addr_fixed_dex_p5              (w_addr_fixed_dex_p5_dex2cpe         ),
.iv_rdata_dex_p5                  (wv_rdata_dex_p5_dex2cpe             ),
                                                                       
.i_wr_ctx_p5                      (w_wr_ctx_p5_ctx2cpe                 ),
.iv_addr_ctx_p5                   (wv_addr_ctx_p5_ctx2cpe              ),
.i_addr_fixed_ctx_p5              (w_addr_fixed_ctx_p5_ctx2cpe         ),
.iv_rdata_ctx_p5                  (wv_rdata_ctx_p5_ctx2cpe             ),
                                                                       
.i_wr_cdc_p5                      (i_wr_cdc_p5        ),
.iv_addr_cdc_p5                   (iv_addr_cdc_p5     ), 
.i_addr_fixed_cdc_p5              (i_addr_fixed_cdc_p5),
.iv_rdata_cdc_p5                  (iv_rdata_cdc_p5    ),
                                                                       
.i_wr_ffi_p6                      (w_wr_ffi_p6_ffi2cpe                 ),
.iv_addr_ffi_p6                   (wv_addr_ffi_p6_ffi2cpe              ),
.i_addr_fixed_ffi_p6              (w_addr_fixed_ffi_p6_ffi2cpe         ),
.iv_rdata_ffi_p6                  (wv_rdata_ffi_p6_ffi2cpe             ),
                                                                       
.i_wr_dex_p6                      (w_wr_dex_p6_dex2cpe                 ),
.iv_addr_dex_p6                   (wv_addr_dex_p6_dex2cpe              ),
.i_addr_fixed_dex_p6              (w_addr_fixed_dex_p6_dex2cpe         ),
.iv_rdata_dex_p6                  (wv_rdata_dex_p6_dex2cpe             ),
                                                                       
.i_wr_ctx_p6                      (w_wr_ctx_p6_ctx2cpe                 ),
.iv_addr_ctx_p6                   (wv_addr_ctx_p6_ctx2cpe              ),
.i_addr_fixed_ctx_p6              (w_addr_fixed_ctx_p6_ctx2cpe         ),
.iv_rdata_ctx_p6                  (wv_rdata_ctx_p6_ctx2cpe             ),
                                                                       
.i_wr_cdc_p6                      (i_wr_cdc_p6        ),
.iv_addr_cdc_p6                   (iv_addr_cdc_p6     ),
.i_addr_fixed_cdc_p6              (i_addr_fixed_cdc_p6),
.iv_rdata_cdc_p6                  (iv_rdata_cdc_p6    ),
                                                                       
.i_wr_ffi_p7                      (w_wr_ffi_p7_ffi2cpe                 ),
.iv_addr_ffi_p7                   (wv_addr_ffi_p7_ffi2cpe              ),
.i_addr_fixed_ffi_p7              (w_addr_fixed_ffi_p7_ffi2cpe         ),
.iv_rdata_ffi_p7                  (wv_rdata_ffi_p7_ffi2cpe             ),
                                                                       
.i_wr_dex_p7                      (w_wr_dex_p7_dex2cpe                 ),
.iv_addr_dex_p7                   (wv_addr_dex_p7_dex2cpe              ),
.i_addr_fixed_dex_p7              (w_addr_fixed_dex_p7_dex2cpe         ),
.iv_rdata_dex_p7                  (wv_rdata_dex_p7_dex2cpe             ),

.i_wr_ctx_p7                      (w_wr_ctx_p7                         ),
.iv_addr_ctx_p7                   (wv_addr_ctx_p7                      ),
.i_addr_fixed_ctx_p7              (w_addr_fixed_ctx_p7                 ),
.iv_rdata_ctx_p7                  (wv_rdata_ctx_p7                     ),
                                                                       
.i_wr_cdc_p7                      (i_wr_cdc_p7        ),
.iv_addr_cdc_p7                   (iv_addr_cdc_p7     ),
.i_addr_fixed_cdc_p7              (i_addr_fixed_cdc_p7),
.iv_rdata_cdc_p7                  (iv_rdata_cdc_p7    ),
                             
.i_wr_grm                         (w_wr_grm2cit                        ),
.iv_addr_grm                      (wv_addr_grm2cit                     ),
.i_addr_fixed_grm                 (w_addr_fixed_grm2cit                ),
.iv_rdata_grm                     (wv_rdata_grm2cit                    ),
                                 
.i_wr_pcb                         (w_wr_pcb2cit                        ),
.iv_addr_pcb                      (wv_addr_pcb2cit                     ),
.i_addr_fixed_pcb                 (w_addr_fixed_pcb2cit                ),
.iv_rdata_pcb                     (wv_rdata_pcb2cit                    ),	
                                                                       
.i_wr_flt                         (w_wr_flt2cit                        ),
.iv_addr_flt                      (wv_addr_flt2cit                     ),
.i_addr_fixed_flt                 (w_addr_fixed_flt2cit                ),
.iv_rdata_flt                     (wv_rdata_flt2cit                    ),
                                                                       
.i_wr_qgc0                        (w_wr_qgc02cit                       ),
.iv_addr_qgc0                     (wv_addr_qgc02cit                    ),
.i_addr_fixed_qgc0                (w_addr_fixed_qgc02cit               ),
.iv_rdata_qgc0                    (wv_rdata_qgc02cit                   ),
                                 
.i_wr_qgc1                        (w_wr_qgc12cit                       ),
.iv_addr_qgc1                     (wv_addr_qgc12cit                    ),
.i_addr_fixed_qgc1                (w_addr_fixed_qgc12cit               ),
.iv_rdata_qgc1                    (wv_rdata_qgc12cit                   ),
                                                                      
.i_wr_qgc2                        (w_wr_qgc22cit                       ),
.iv_addr_qgc2                     (wv_addr_qgc22cit                    ),
.i_addr_fixed_qgc2                (w_addr_fixed_qgc22cit               ),
.iv_rdata_qgc2                    (wv_rdata_qgc22cit                   ),
                                                                      
.i_wr_qgc3                        (w_wr_qgc32cit                       ),
.iv_addr_qgc3                     (wv_addr_qgc32cit                    ),
.i_addr_fixed_qgc3                (w_addr_fixed_qgc32cit               ),
.iv_rdata_qgc3                    (wv_rdata_qgc32cit                   ),
                                                                      
.i_wr_qgc4                        (w_wr_qgc42cit                       ),
.iv_addr_qgc4                     (wv_addr_qgc42cit                    ),
.i_addr_fixed_qgc4                (w_addr_fixed_qgc42cit               ),
.iv_rdata_qgc4                    (wv_rdata_qgc42cit                   ),
                                   
.i_wr_qgc5                        (w_wr_qgc52cit                       ),
.iv_addr_qgc5                     (wv_addr_qgc52cit                    ),
.i_addr_fixed_qgc5                (w_addr_fixed_qgc52cit               ),
.iv_rdata_qgc5                    (wv_rdata_qgc52cit                   ),
                                                                       
.i_wr_qgc6                        (w_wr_qgc62cit                       ),
.iv_addr_qgc6                     (wv_addr_qgc62cit                    ),
.i_addr_fixed_qgc6                (w_addr_fixed_qgc62cit               ),
.iv_rdata_qgc6                    (wv_rdata_qgc62cit                   ),
                                                                       
.i_wr_qgc7                        (w_wr_qgc72cit                       ),
.iv_addr_qgc7                     (wv_addr_qgc72cit                    ),
.i_addr_fixed_qgc7                (w_addr_fixed_qgc72cit               ),
.iv_rdata_qgc7                    (wv_rdata_qgc72cit                   ),
                                                                       
.ov_command_ack                   (ov_command_ack                      ),
.o_command_ack_wr                 (o_command_ack_wr                    )         
);

global_registers_management global_registers_management_inst
(
        .i_clk                            (i_clk                                 ),                
        .i_rst_n                          (i_rst_n                               ),      
                                                                                 
        .iv_addr                          (ov_addr_cit2all                       ),         
        .i_addr_fixed                     (o_addr_fixed_cit2all                  ),        
        .iv_wdata                         (ov_wdata_cit2all                      ),         
        .i_wr                             (w_wr_cit2grm                          ),      
        .i_rd                             (w_rd_cit2grm                          ),      
                                                                                 
        .o_wr                             (w_wr_grm2cit                          ),      
        .ov_addr                          (wv_addr_grm2cit                       ),      
        .o_addr_fixed                     (w_addr_fixed_grm2cit                  ),      
        .ov_rdata                         (wv_rdata_grm2cit                      ),      

        .ov_tss_ver                       (ov_tss_ver                            ),
        .ov_be_threshold_value            (wv_be_threshold_value_grm2nip         ), 
        .ov_rc_threshold_value            (wv_rc_threshold_value_grm2nip         ),
        .ov_standardpkt_threshold_value   (wv_standardpkt_threshold_value_grm2nip),
        .o_qbv_or_qch                     (w_qbv_or_qch_grm2nop                  ),          
        .ov_time_slot_length              (ov_time_slot_length           ),          
        .ov_schedule_period               (ov_schedule_period            )     
);
endmodule


