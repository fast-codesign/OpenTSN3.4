// Copyright (C) 1953-2021 NUDT
// Verilog module name - time_sensitive_end 
// Version: V3.2.2.20210820
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//		  top of TSNNic
//				 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module time_sensitive_end(
       i_clk,
       i_rst_n,
              
       ov_gmii_txd_hcp,
       o_gmii_tx_en_hcp,
       
       ov_gmii_txd_p0,
       o_gmii_tx_en_p0,
       
       ov_gmii_txd_p1,
       o_gmii_tx_en_p1,
       
       ov_gmii_txd_p2,
       o_gmii_tx_en_p2,
       
       i_gmii_dv_hcp,
       iv_gmii_rxd_hcp,

       i_gmii_dv_p0,
       iv_gmii_rxd_p0,

       i_gmii_dv_p1,
       iv_gmii_rxd_p1,

       i_gmii_dv_p2,
       iv_gmii_rxd_p2,
       
       //hrp
       i_gmii_dv_host,
       iv_gmii_rxd_host,
       
       //htp
       ov_gmii_txd_host,
       o_gmii_tx_en_host,

       iv_command,
	   i_command_wr,        
       ov_command_ack,
       o_command_ack_wr,        

       ov_tse_ver,  
       
       ov_addr_cpe2all        ,
       ov_wdata_cpe2all       ,
       o_addr_fixed_cpe2all   , 
       
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
       
       iv_syn_clk             ,    
       i_rc_rxenable                  ,
       i_st_rxenable                  ,       
       ov_schedule_period     ,
       ov_time_slot_length            
           
);

//I/O
input                   i_clk;                   //125Mhz
input                   i_rst_n;
                        

output     [7:0]        ov_gmii_txd_hcp;
output                  o_gmii_tx_en_hcp;

output     [7:0]        ov_gmii_txd_p0;
output                  o_gmii_tx_en_p0;

                        
output     [7:0]        ov_gmii_txd_p1;
output                  o_gmii_tx_en_p1;
                        
output     [7:0]        ov_gmii_txd_p2;
output                  o_gmii_tx_en_p2;   
//network input
input                   i_gmii_dv_hcp;
input      [7:0]        iv_gmii_rxd_hcp;

input                   i_gmii_dv_p0;
input      [7:0]        iv_gmii_rxd_p0;

input                   i_gmii_dv_p1;
input      [7:0]        iv_gmii_rxd_p1;

input                   i_gmii_dv_p2;
input      [7:0]        iv_gmii_rxd_p2;
// host output
output     [7:0]        ov_gmii_txd_host;
output                  o_gmii_tx_en_host;
//host input
input                   i_gmii_dv_host;
input      [7:0]        iv_gmii_rxd_host;

input                   i_rc_rxenable                 ;
input                   i_st_rxenable                 ;
//command
input	   [63:0]	    iv_command;
input	         	    i_command_wr;
output     [63:0]	    ov_command_ack;
output    	            o_command_ack_wr;
output     [31:0]       ov_tse_ver;
   
output     [18:0]       ov_addr_cpe2all                  ;
output     [31:0]       ov_wdata_cpe2all                 ;
output                  o_addr_fixed_cpe2all             ;

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

input        [63:0]     iv_syn_clk                       ;
output       [10:0]     ov_schedule_period               ;
output       [10:0]     ov_time_slot_length              ;

wire                    w_hardware_initial_finish;



//*******************************
//              hrp
//*******************************
wire       [8:0]        wv_bufid_pcb2hrp;
wire                    w_bufid_wr_pcb2hrp;
wire                    w_bufid_ack_hrp2pcb;

wire       [133:0]      wv_pkt_data_hrp2pcb;
wire                    w_pkt_data_wr_hrp2pcb;
wire       [15:0]       wv_pkt_addr_hrp2pcb;//11->15
wire                    w_pkt_ack_pcb2hrp;

wire       [45:0]       wv_ts_descriptor_hrp2flt;
wire                    w_ts_descriptor_wr_hrp2flt;
wire                    w_ts_descriptor_ack_flt2hrp;

wire       [45:0]       wv_nts_descriptor_hrp2flt;
wire                    w_nts_descriptor_wr_hrp2flt;
wire                    w_nts_descriptor_ack_flt2hrp;
//tsntag & bufid output for ip frame 
wire       [47:0]       wv_ip_tsntag_hrp2scp;
wire       [2:0]        wv_pkt_type_hrp2scp;
wire       [8:0]        wv_ip_bufid_hrp2scp;
wire                    w_ip_descriptor_wr_hrp2scp;
wire                    w_ip_descriptor_ack_scp2hrp;
//*******************************
//              nip
//*******************************
//port0
wire       [8:0]        wv_bufid_pcb2nip_0;
wire                    w_bufid_wr_pcb2nip_0;
wire                    w_bufid_ack_hrp2nip_0;

wire                    w_descriptor_wr_hcptohost; 
wire                    w_inverse_map_lookup_flag_hcp2host;
wire                    w_descriptor_wr_hcptonetwork;
wire       [39:0]       wv_descriptor_hcp;
wire                    w_descriptor_ack_hosttohcp;
wire                    w_descriptor_ack_networktohcp;

wire                    w_descriptor_wr_p1tohost; 
wire                    w_descriptor_wr_p1tohcp;
wire       [39:0]       wv_descriptor_p1;
wire                    w_inverse_map_lookup_flag_p1tohost;
wire       [2:0]        wv_pkt_type_p1;
wire                    w_descriptor_ack_hosttop1;   
wire                    w_descriptor_ack_hcptop1;

wire       [133:0]      wv_pkt_data_pcb2nip_0;
wire                    w_pkt_data_wr_pcb2nip_0;
wire       [15:0]       wv_pkt_addr_pcb2nip_0;
wire                    w_pkt_ack_pcb2nip_0;

//port1
wire       [8:0]        wv_bufid_pcb2nip_1;
wire                    w_bufid_wr_pcb2nip_1;
wire                    w_bufid_ack_hrp2nip_1;

wire       [45:0]       wv_descriptor_pcb2nip_1;
wire                    w_descriptor_wr_pcb2nip_1;
wire                    w_descriptor_ack_pcb2nip_1;

wire       [133:0]      wv_pkt_data_pcb2nip_1;
wire                    w_pkt_data_wr_pcb2nip_1;
wire       [15:0]       wv_pkt_addr_pcb2nip_1;
wire                    w_pkt_ack_pcb2nip_1;
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

//host port
wire       [8:0]        wv_pkt_bufid_flt2nop;
wire       [2:0]        wv_pkt_type_flt2nop;
wire       [4:0]        wv_submit_addr_flt2nop;
wire       [3:0]        wv_inport_flt2nop;
wire                    w_pkt_bufid_wr_flt2nop;
//*******************************
//            htp
//*******************************
wire       [8:0]        wv_pkt_bufid_htp2pcb;    
wire                    w_pkt_bufid_wr_htp2pcb;  
wire                    w_pkt_bufid_ack_pcb2htp; 

wire       [15:0]       wv_pkt_raddr_htp2pcb;    //11->15  
wire                    w_pkt_rd_htp2pcb;       
wire                    w_pkt_raddr_ack_pcb2htp;

wire       [133:0]      wv_pkt_data_pcb2htp;  
wire                    w_pkt_data_wr_pcb2htp;
//*******************************
//             nop
//*******************************
//port0
wire       [8:0]        wv_pkt_bufid_nop2pcb_0;    
wire                    w_pkt_bufid_wr_nop2pcb_0;  
wire                    w_pkt_bufid_ack_pcb2nop_0; 

wire       [15:0]       wv_pkt_raddr_nop2pcb_0; //11->15  
wire                    w_pkt_rd_nop2pcb_0;       
wire                    w_pkt_raddr_ack_pcb2nop_0;

wire       [133:0]      wv_pkt_data_pcb2nop_0;  
wire                    w_pkt_data_wr_pcb2nop_0;

//port1
wire       [8:0]        wv_pkt_bufid_nop2pcb_1;    
wire                    w_pkt_bufid_wr_nop2pcb_1;  
wire                    w_pkt_bufid_ack_pcb2nop_1; 

wire       [15:0]       wv_pkt_raddr_nop2pcb_1;    //11->15  
wire                    w_pkt_rd_nop2pcb_1;       
wire                    w_pkt_raddr_ack_pcb2nop_1;

wire       [133:0]      wv_pkt_data_pcb2nop_1;  
wire                    w_pkt_data_wr_pcb2nop_1;

wire                    w_ts_inj_underflow_error_pulse_hip2tsm;
wire                    w_ts_inj_overflow_error_pulse_hip2tsm; 
wire                    w_ts_sub_underflow_error_pulse_hop2tsm;
wire                    w_ts_sub_overflow_error_pulse_hop2tsm;

wire                    w_fifo_overflow_pulse_host_rx;
wire                    w_fifo_underflow_pulse_host_rx;
wire                    w_fifo_underflow_pulse_hcp_rx;
wire                    w_fifo_overflow_pulse_hcp_rx; 
wire                    w_fifo_underflow_pulse_p1_rx;
wire                    w_fifo_overflow_pulse_p1_rx; 
                        
wire                    w_fifo_overflow_pulse_host_tx;
wire                    w_fifo_overflow_pulse_hcp_tx;
wire                    w_fifo_overflow_pulse_p1_tx;               

wire       [8:0]        wv_free_bufid_fifo_rdusedw;
//adp2tsnchip 
wire					w_gmii_dv_hcp_adp2tsnchip;
wire		[7:0]		wv_gmii_rxd_hcp_adp2tsnchip;
wire					w_gmii_er_hcp_adp2tsnchip;

wire					w_gmii_dv_p1_adp2tsnchip;
wire		[7:0]		wv_gmii_rxd_p1_adp2tsnchip;
wire					w_gmii_er_p1_adp2tsnchip;

wire	  				w_gmii_dv_host_adp2tsnchip;
wire		[7:0]	 	wv_gmii_rxd_host_adp2tsnchip;
wire					w_gmii_er_host_adp2tsnchip;




//nop2tcc
wire      [8:0] 	   wv_data_hcp_nop2tcc;
wire      		 	   w_data_wr_hcp_nop2tcc;  
//nop2fre
wire      [8:0] 	   wv_data_p1_nop2fre;
wire      		 	   w_data_wr_p1_nop2fre; 

wire      [8:0]        wv_be_threshold_value_grm2nip           ;
wire      [8:0]        wv_rc_threshold_value_grm2nip           ;
wire      [8:0]        wv_standardpkt_threshold_value_grm2nip  ;

wire      [39:0]       wv_descriptor_host2p1   ;
wire                   w_descriptor_wr_host2p1 ;
wire                   w_descriptor_ack_host2p1;
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
wire                    w_wr_frm_cpe2dex ;
wire                    w_rd_frm_cpe2dex ;
wire                    w_wr_tic_cpe2ctx ;
wire                    w_rd_tic_cpe2ctx ;

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

wire              w_wr_cit2fim;
wire              w_rd_cit2fim;

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
                                   
                                      
wire              w_wr_tic2cpe            ;     
wire   [18:0]     wv_addr_tic2cpe         ;     
wire              w_addr_fixed_tic2cpe    ;     
wire   [31:0]     wv_rdata_tic2cpe        ;       
                                    
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

wire              w_wr_fim2cit;
wire   [18:0]     wv_addr_fim2cit;
wire              w_addr_fixed_fim2cit;
wire   [31:0]     wv_rdata_fim2cit;

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



host_input_process host_input_process_inst(
.i_clk                          (i_clk                  ),
.i_rst_n                        (i_rst_n                ),
                                                                   
.i_data_wr                      (i_gmii_dv_host         ),
.iv_data                        (iv_gmii_rxd_host       ),
                                                                    
.iv_addr                        (ov_addr_cpe2all        ),
.iv_wdata                       (ov_wdata_cpe2all       ),
.i_addr_fixed                   (o_addr_fixed_cpe2all   ),                     
.i_wr_frm                       (w_wr_frm_cpe2dex       ),
.i_rd_frm                       (w_rd_frm_cpe2dex       ),
.i_wr_isc                       (w_wr_ffi_p3_cpe2ffi    ),
.i_rd_isc                       (w_rd_ffi_p3_cpe2ffi    ),   
.i_wr_tic                       (w_wr_tic_cpe2ctx       ),
.i_rd_tic                       (w_rd_tic_cpe2ctx       ),
                                 
.o_wr_frm                       (w_wr_frm2cpe                 ),  
.ov_addr_frm                    (wv_addr_frm2cpe              ),  
.o_addr_fixed_frm               (w_addr_fixed_frm2cpe         ),  
.ov_rdata_frm                   (wv_rdata_frm2cpe             ),  
.o_wr_isc                       (w_wr_ffi_p3_ffi2cpe          ),                      
.ov_addr_isc                    (wv_addr_ffi_p3_ffi2cpe       ), 
.o_addr_fixed_isc               (w_addr_fixed_ffi_p3_ffi2cpe  ), 
.ov_rdata_isc                   (wv_rdata_ffi_p3_ffi2cpe      ), 
.o_wr_tic                       (w_wr_tic2cpe                 ), 
.ov_addr_tic                    (wv_addr_tic2cpe              ),
.o_addr_fixed_tic               (w_addr_fixed_tic2cpe         ),
.ov_rdata_tic                   (wv_rdata_tic2cpe             ),
        
.iv_pkt_bufid                   (wv_bufid_pcb2hrp             ),
.i_pkt_bufid_wr                 (w_bufid_wr_pcb2hrp           ),
.o_pkt_bufid_ack                (w_bufid_ack_hrp2pcb          ),
                                                             
.ov_wdata                       (wv_pkt_data_hrp2pcb          ),
.o_data_wr                      (w_pkt_data_wr_hrp2pcb        ),
.ov_data_waddr                  (wv_pkt_addr_hrp2pcb          ),
.i_wdata_ack                    (w_pkt_ack_pcb2hrp            ),
                                                                                         
.iv_time_slot_period            (ov_schedule_period ),                                          
.iv_syn_clk                     (iv_syn_clk         ),                                
.iv_time_slot_length            (ov_time_slot_length),                                 
.ov_descriptor                  (wv_descriptor_host2p1   ),                                                   
.o_descriptor_wr                (w_descriptor_wr_host2p1 ),                                                    
.i_descriptor_ack               (w_descriptor_ack_host2p1),                                                     

.i_hardware_initial_finish      (w_hardware_initial_finish      ),
 
.iv_free_bufid_num              (wv_free_bufid_fifo_rdusedw             ),
.iv_hpriority_be_threshold_value(wv_be_threshold_value_grm2nip          ),
.iv_rc_threshold_value          (wv_rc_threshold_value_grm2nip          ),
.iv_lpriority_be_threshold_value(wv_standardpkt_threshold_value_grm2nip ),
.i_rc_rxenable                      (i_rc_rxenable                      ),
.i_st_rxenable                      (i_st_rxenable                      )
);

network_input_process_top_tse network_input_process_top_inst(
.i_clk                              (i_clk                     ),
.i_rst_n                            (i_rst_n                   ),          
              
.i_gmii_dv_p0                       (i_gmii_dv_hcp             ),
.iv_gmii_rxd_p0                     (iv_gmii_rxd_hcp           ),

.i_gmii_dv_p1                       (i_gmii_dv_p1              ),
.iv_gmii_rxd_p1                     (iv_gmii_rxd_p1            ),

.iv_addr                            (ov_addr_cpe2all           ),
.i_addr_fixed                       (o_addr_fixed_cpe2all      ), 
.iv_wdata                           (ov_wdata_cpe2all          ),                               
.i_wr_isc_p0                        (w_wr_ffi_p8_cpe2ffi       ),
.i_rd_isc_p0                        (w_rd_ffi_p8_cpe2ffi       ),                               
.i_wr_dex_p0                        (w_wr_dex_p8_cpe2dex       ),
.i_rd_dex_p0                        (w_rd_dex_p8_cpe2dex       ),
.o_wr_isc_p0                        (w_wr_ffi_p8_ffi2cpe         ),
.ov_addr_isc_p0                     (wv_addr_ffi_p8_ffi2cpe      ),
.o_addr_fixed_isc_p0                (w_addr_fixed_ffi_p8_ffi2cpe ),
.ov_rdata_isc_p0                    (wv_rdata_ffi_p8_ffi2cpe     ),  
                                                                
.o_wr_dex_p0                        (w_wr_dex_p8_dex2cpe         ),
.ov_addr_dex_p0                     (wv_addr_dex_p8_dex2cpe      ),
.o_addr_fixed_dex_p0                (w_addr_fixed_dex_p8_dex2cpe ),
.ov_rdata_dex_p0                    (wv_rdata_dex_p8_dex2cpe     ),	
       
.i_wr_isc_p1                        (w_wr_ffi_p1_cpe2ffi         ),
.i_rd_isc_p1                        (w_rd_ffi_p1_cpe2ffi         ),                               
.i_wr_dex_p1                        (w_wr_dex_p1_cpe2dex         ),
.i_rd_dex_p1                        (w_rd_dex_p1_cpe2dex         ),
.o_wr_isc_p1                        (w_wr_ffi_p1_ffi2cpe         ),
.ov_addr_isc_p1                     (wv_addr_ffi_p1_ffi2cpe      ),
.o_addr_fixed_isc_p1                (w_addr_fixed_ffi_p1_ffi2cpe ),
.ov_rdata_isc_p1                    (wv_rdata_ffi_p1_ffi2cpe     ),  
                                                                
.o_wr_dex_p1                        (w_wr_dex_p1_dex2cpe         ),
.ov_addr_dex_p1                     (wv_addr_dex_p1_dex2cpe      ),
.o_addr_fixed_dex_p1                (w_addr_fixed_dex_p1_dex2cpe ),
.ov_rdata_dex_p1                    (wv_rdata_dex_p1_dex2cpe     ),
       
.i_hardware_initial_finish          (w_hardware_initial_finish          ),
.i_rc_rxenable                      (i_rc_rxenable                      ),
.i_st_rxenable                      (i_st_rxenable                      ),

.iv_pkt_bufid_p0                    (wv_bufid_pcb2nip_0                 ),            
.i_pkt_bufid_wr_p0                  (w_bufid_wr_pcb2nip_0               ),
.o_pkt_bufid_ack_p0                 (w_bufid_ack_hrp2nip_0              ),

.iv_pkt_bufid_p1                    (wv_bufid_pcb2nip_1                 ),
.i_pkt_bufid_wr_p1                  (w_bufid_wr_pcb2nip_1               ),                   
.o_pkt_bufid_ack_p1                 (w_bufid_ack_hrp2nip_1              ),

.o_descriptor_wr_p0tohost           (w_descriptor_wr_hcptohost          ), 
.o_descriptor_wr_p0tonetwork        (w_descriptor_wr_hcptonetwork       ),
.ov_descriptor_p0                   (wv_descriptor_hcp                  ),
.o_inverse_map_lookup_flag_p0       (w_inverse_map_lookup_flag_hcp2host ),
.i_descriptor_ack_hosttop0          (w_descriptor_ack_hosttohcp         ),
.i_descriptor_ack_networktop0       (w_descriptor_ack_networktohcp      ),
            
.o_descriptor_wr_p1tohost           (w_descriptor_wr_p1tohost           ), 
.o_descriptor_wr_p1tohcp            (w_descriptor_wr_p1tohcp            ),
.ov_descriptor_p1                   (wv_descriptor_p1                   ),
.o_inverse_map_lookup_flag_p1       (w_inverse_map_lookup_flag_p1tohost ),
.i_descriptor_ack_hosttop1          (w_descriptor_ack_hosttop1          ),               
.i_descriptor_ack_hcptop1           (w_descriptor_ack_hcptop1           ),

.ov_pkt_p0                          (wv_pkt_data_pcb2nip_0              ),
.o_pkt_wr_p0                        (w_pkt_data_wr_pcb2nip_0            ),
.ov_pkt_bufadd_p0                   (wv_pkt_addr_pcb2nip_0              ),
.i_pkt_ack_p0                       (w_pkt_ack_pcb2nip_0                ),
            
.ov_pkt_p1                          (wv_pkt_data_pcb2nip_1              ),
.o_pkt_wr_p1                        (w_pkt_data_wr_pcb2nip_1            ),
.ov_pkt_bufadd_p1                   (wv_pkt_addr_pcb2nip_1              ),
.i_pkt_ack_p1                       (w_pkt_ack_pcb2nip_1                ),

.iv_free_bufid_num                  (wv_free_bufid_fifo_rdusedw         ),
.iv_hpriority_be_threshold_value    (wv_be_threshold_value_grm2nip      ),
.iv_rc_threshold_value              (wv_rc_threshold_value_grm2nip      ),
.iv_lpriority_be_threshold_value    (wv_standardpkt_threshold_value_grm2nip ),

.o_port0_inpkt_pulse                (w_port0_inpkt_pulse_nip2tsm        ),
.o_port0_discard_pkt_pulse          (w_port0_discard_pkt_pulse_nip2tsm  ),
.o_port1_inpkt_pulse                (w_port1_inpkt_pulse_nip2tsm        ),
.o_port1_discard_pkt_pulse          (w_port1_discard_pkt_pulse_nip2tsm  ),
                                                                        
.o_fifo_underflow_pulse_p0          (w_fifo_underflow_pulse_hcp_rx      ),
.o_fifo_overflow_pulse_p0           (w_fifo_overflow_pulse_hcp_rx       ),
.o_fifo_underflow_pulse_p1          (w_fifo_underflow_pulse_p1_rx       ),
.o_fifo_overflow_pulse_p1           (w_fifo_overflow_pulse_p1_rx        )
);

pkt_centralized_buffer_tse pkt_centralized_buffer_inst(
.clk_sys                 (i_clk),
.reset_n                 (i_rst_n),

.iv_addr                 (ov_addr_cpe2all     ),                                   
.i_addr_fixed            (o_addr_fixed_cpe2all),                           
.iv_wdata                (ov_wdata_cpe2all    ),                            
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
                         
.iv_pkt_p2               (134'b0),//(wv_pkt_data_pcb2nip_2),
.i_pkt_wr_p2             (1'b0),//(w_pkt_data_wr_pcb2nip_2),
.iv_pkt_wr_bufadd_p2     (16'b0),//(wv_pkt_addr_pcb2nip_2),
.o_pkt_wr_ack_p2         (),//(w_pkt_ack_pcb2nip_2),

.iv_pkt_p3               (134'b0),//(wv_pkt_data_pcb2nip_3),
.i_pkt_wr_p3             (1'b0),//(w_pkt_data_wr_pcb2nip_3),
.iv_pkt_wr_bufadd_p3     (16'b0),//(wv_pkt_addr_pcb2nip_3),
.o_pkt_wr_ack_p3         (),//(w_pkt_ack_pcb2nip_3), 

.iv_pkt_p8               (wv_pkt_data_hrp2pcb),
.i_pkt_wr_p8             (w_pkt_data_wr_hrp2pcb),
.iv_pkt_wr_bufadd_p8     (wv_pkt_addr_hrp2pcb),  
.o_pkt_wr_ack_p8         (w_pkt_ack_pcb2hrp),

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

.iv_pkt_rd_bufadd_p2     (16'b0),//(wv_pkt_raddr_nop2pcb_2),
.i_pkt_rd_p2             (1'b0),//(w_pkt_rd_nop2pcb_2),
.o_pkt_rd_ack_p2         (),//(w_pkt_raddr_ack_pcb2nop_2),
.ov_pkt_p2               (),//(wv_pkt_data_pcb2nop_2),   
.o_pkt_wr_p2             (),//(w_pkt_data_wr_pcb2nop_2),

.iv_pkt_rd_bufadd_p3     (16'b0),//(wv_pkt_raddr_nop2pcb_3),
.i_pkt_rd_p3             (1'b0),//(w_pkt_rd_nop2pcb_3),
.o_pkt_rd_ack_p3         (),//(w_pkt_raddr_ack_pcb2nop_3),
.ov_pkt_p3               (),//(wv_pkt_data_pcb2nop_3),   
.o_pkt_wr_p3             (),//(w_pkt_data_wr_pcb2nop_3),

.iv_pkt_rd_bufadd_p8     (wv_pkt_raddr_htp2pcb),
.i_pkt_rd_p8             (w_pkt_rd_htp2pcb),
.o_pkt_rd_ack_p8         (w_pkt_raddr_ack_pcb2htp),
.ov_pkt_p8               (wv_pkt_data_pcb2htp), 
.o_pkt_wr_p8             (w_pkt_data_wr_pcb2htp),

.ov_pkt_bufid_p0         (wv_bufid_pcb2nip_0),
.o_pkt_bufid_wr_p0       (w_bufid_wr_pcb2nip_0),
.i_pkt_bufid_ack_p0      (w_bufid_ack_hrp2nip_0),
                         
.ov_pkt_bufid_p1         (wv_bufid_pcb2nip_1),
.o_pkt_bufid_wr_p1       (w_bufid_wr_pcb2nip_1),
.i_pkt_bufid_ack_p1      (w_bufid_ack_hrp2nip_1),
                         
.ov_pkt_bufid_p2         (),//(wv_bufid_pcb2nip_2),
.o_pkt_bufid_wr_p2       (),//(w_bufid_wr_pcb2nip_2),
.i_pkt_bufid_ack_p2      (1'b0),//(w_bufid_ack_hrp2nip_2),
                 
.ov_pkt_bufid_p3         (),//(wv_bufid_pcb2nip_3),
.o_pkt_bufid_wr_p3       (),//(w_bufid_wr_pcb2nip_3),
.i_pkt_bufid_ack_p3      (1'b0),//(w_bufid_ack_hrp2nip_3),

.ov_pkt_bufid_p8         (wv_bufid_pcb2hrp),
.o_pkt_bufid_wr_p8       (w_bufid_wr_pcb2hrp),
.i_pkt_bufid_ack_p8      (w_bufid_ack_hrp2pcb),

.i_pkt_bufid_wr_flt      (r_pkt_bufid_wr),//(w_pkt_bufid_wr_flt2pcb),
.iv_pkt_bufid_flt        (rv_pkt_bufid),//(wv_pkt_bufid_flt2pcb),
.iv_pkt_bufid_cnt_flt    (rv_pkt_bufid_cnt),//(wv_pkt_bufid_cnt_flt2pcb),

.iv_pkt_bufid_p0         (wv_pkt_bufid_nop2pcb_0),
.i_pkt_bufid_wr_p0       (w_pkt_bufid_wr_nop2pcb_0),
.o_pkt_bufid_ack_p0      (w_pkt_bufid_ack_pcb2nop_0),

.iv_pkt_bufid_p1         (wv_pkt_bufid_nop2pcb_1),
.i_pkt_bufid_wr_p1       (w_pkt_bufid_wr_nop2pcb_1),
.o_pkt_bufid_ack_p1      (w_pkt_bufid_ack_pcb2nop_1),

.iv_pkt_bufid_p2         (9'b0),//(wv_pkt_bufid_nop2pcb_2),
.i_pkt_bufid_wr_p2       (1'b0),//(w_pkt_bufid_wr_nop2pcb_2),
.o_pkt_bufid_ack_p2      (),//(w_pkt_bufid_ack_pcb2nop_2),
             
.iv_pkt_bufid_p3         (9'b0),//(wv_pkt_bufid_nop2pcb_3),
.i_pkt_bufid_wr_p3       (1'b0),//(w_pkt_bufid_wr_nop2pcb_3),
.o_pkt_bufid_ack_p3      (),//(w_pkt_bufid_ack_pcb2nop_3),

.iv_pkt_bufid_p8         (wv_pkt_bufid_htp2pcb),
.i_pkt_bufid_wr_p8       (w_pkt_bufid_wr_htp2pcb),
.o_pkt_bufid_ack_p8      (w_pkt_bufid_ack_pcb2htp),

.ov_free_buf_fifo_rdusedw(wv_free_bufid_fifo_rdusedw),
.o_hardware_initial_finish(w_hardware_initial_finish),

.bufid_state             (),
.bufid_overflow_cnt      (),
.bufid_underflow_cnt     ()	
);

host_output_process host_output_process_inst(
.i_clk                          (i_clk),
.i_rst_n                        (i_rst_n),
            
.iv_addr                        (ov_addr_cpe2all               ),     
.iv_wdata                       (ov_wdata_cpe2all              ),
.i_addr_fixed                   (o_addr_fixed_cpe2all          ),                         
.i_wr_fim                       (w_wr_cit2fim                  ),
.i_rd_fim                       (w_rd_cit2fim                  ),
                                 
.o_wr_fim                       (w_wr_fim2cit                  ),
.ov_addr_fim                    (wv_addr_fim2cit               ),
.o_addr_fixed_fim               (w_addr_fixed_fim2cit          ),
.ov_rdata_fim                   (wv_rdata_fim2cit              ),
            
.iv_tsntag_hcp                  ({wv_descriptor_hcp[30:28],2'b0,wv_descriptor_hcp[27:0],15'b0}),
.iv_bufid_hcp                   (wv_descriptor_hcp[39:31]),
.i_inverse_map_lookup_flag_hcp  (w_inverse_map_lookup_flag_hcp2host),
.i_descriptor_wr_hcp            (w_descriptor_wr_hcptohost),
.o_descriptor_ack_hcp           (w_descriptor_ack_hosttohcp),

.iv_tsntag_network              ({wv_descriptor_p1[30:28],2'b0,wv_descriptor_p1[27:0],15'b0}),
.iv_bufid_network               (wv_descriptor_p1[39:31]),
.i_inverse_map_lookup_flag_network(w_inverse_map_lookup_flag_p1tohost),
.i_descriptor_wr_network        (w_descriptor_wr_p1tohost),
.o_descriptor_ack_network       (w_descriptor_ack_hosttop1),
 
.ov_pkt_bufid                   (wv_pkt_bufid_htp2pcb),
.o_pkt_bufid_wr                 (w_pkt_bufid_wr_htp2pcb),
.i_pkt_bufid_ack                (w_pkt_bufid_ack_pcb2htp),
            
.ov_pkt_raddr                   (wv_pkt_raddr_htp2pcb),
.o_pkt_rd                       (w_pkt_rd_htp2pcb),
.i_pkt_raddr_ack                (w_pkt_raddr_ack_pcb2htp),
            
.iv_pkt_data                    (wv_pkt_data_pcb2htp),
.i_pkt_data_wr                  (w_pkt_data_wr_pcb2htp),
             
.ov_gmii_txd                    (ov_gmii_txd_host ),
.o_gmii_tx_en                   (o_gmii_tx_en_host),
    
.o_ts_underflow_error_pulse     (w_ts_sub_underflow_error_pulse_hop2tsm),
.o_ts_overflow_error_pulse      (w_ts_sub_overflow_error_pulse_hop2tsm ),

.o_pkt_output_pulse             (w_host_outpkt_pulse_hop2tsm           ),
.o_host_inqueue_discard_pulse   (w_host_in_queue_discard_pulse_hop2tsm ),
.o_fifo_overflow_pulse          (w_fifo_overflow_pulse_host_tx         )
);

network_output_process_top_tse network_output_process_top_inst(
.i_clk                      (i_clk),
.i_rst_n                    (i_rst_n),
                            
.i_qbv_or_qch               (w_qbv_or_qch_grm2nop  ),
.iv_time_slot_length        (ov_time_slot_length   ),                    
.iv_schedule_period         (ov_schedule_period    ),                    
.iv_syn_clk                 (iv_syn_clk),                     
.iv_addr                    (ov_addr_cpe2all      ),
.iv_wdata                   (ov_wdata_cpe2all     ),
.i_addr_fixed               (o_addr_fixed_cpe2all ),
            
.i_wr_qgc0                  ( 1'b0                 ),
.i_rd_qgc0                  ( 1'b0                 ),                           
.o_wr_qgc0                  (w_wr_qgc02cit         ),
.ov_addr_qgc0               (wv_addr_qgc02cit      ),
.o_addr_fixed_qgc0          (w_addr_fixed_qgc02cit ),
.ov_rdata_qgc0              (wv_rdata_qgc02cit     ),

.i_wr_qgc1                  (w_wr_cit2qgc1         ),
.i_rd_qgc1                  (w_rd_cit2qgc1         ),                          
.o_wr_qgc1                  (w_wr_qgc12cit         ),
.ov_addr_qgc1               (wv_addr_qgc12cit      ),
.o_addr_fixed_qgc1          (w_addr_fixed_qgc12cit ),
.ov_rdata_qgc1              (wv_rdata_qgc12cit     ),
                                                     
                                                     
.iv_tsntag_host2p0          (48'b0),                 
.iv_pkt_type_host2p0        (3'b0),
.iv_bufid_host2p0           (9'b0),
.i_descriptor_wr_host2p0    (1'b0),
.o_descriptor_ack_p02host   (),

.iv_tsntag_network2p0       ({wv_descriptor_p1[30:28],2'b0,wv_descriptor_p1[27:0],15'b0}),
.iv_pkt_type_network2p0     (wv_descriptor_p1[30:28]),
.iv_bufid_network2p0        (wv_descriptor_p1[39:31]),
.i_descriptor_wr_network2p0 (w_descriptor_wr_p1tohcp),
.o_descriptor_ack_p02network(w_descriptor_ack_hcptop1),  

.ov_pkt_bufid_p0            (wv_pkt_bufid_nop2pcb_0),
.o_pkt_bufid_wr_p0          (w_pkt_bufid_wr_nop2pcb_0),
.i_pkt_bufid_ack_p0         (w_pkt_bufid_ack_pcb2nop_0),
                            
.ov_pkt_raddr_p0            (wv_pkt_raddr_nop2pcb_0),
.o_pkt_rd_p0                (w_pkt_rd_nop2pcb_0),
.i_pkt_raddr_ack_p0         (w_pkt_raddr_ack_pcb2nop_0),
                            
.iv_pkt_data_p0             (wv_pkt_data_pcb2nop_0),
.i_pkt_data_wr_p0           (w_pkt_data_wr_pcb2nop_0),
                            
.ov_gmii_txd_p0             (ov_gmii_txd_hcp),  
.o_gmii_tx_en_p0            (o_gmii_tx_en_hcp),

.o_port0_outpkt_pulse       (w_port0_outpkt_pulse_nop2tsm),
//port 1 connect with scp
.iv_tsntag_host2p1          ({wv_descriptor_host2p1[30:28],2'b0,wv_descriptor_host2p1[27:0],15'b0}),          
.iv_pkt_type_host2p1        (wv_descriptor_host2p1[30:28]),         
.iv_bufid_host2p1           (wv_descriptor_host2p1[39:31]),        
.i_descriptor_wr_host2p1    (w_descriptor_wr_host2p1),
.o_descriptor_ack_p12host   (w_descriptor_ack_host2p1),

.iv_tsntag_network2p1       ({wv_descriptor_hcp[30:28],2'b0,wv_descriptor_hcp[27:0],15'b0}),
.iv_pkt_type_network2p1     (wv_descriptor_hcp[30:28]),
.iv_bufid_network2p1        (wv_descriptor_hcp[39:31]),
.i_descriptor_wr_network2p1 (w_descriptor_wr_hcptonetwork),
.o_descriptor_ack_p12network(w_descriptor_ack_networktohcp), 

.ov_pkt_bufid_p1            (wv_pkt_bufid_nop2pcb_1),
.o_pkt_bufid_wr_p1          (w_pkt_bufid_wr_nop2pcb_1),
.i_pkt_bufid_ack_p1         (w_pkt_bufid_ack_pcb2nop_1),
                            
.ov_pkt_raddr_p1            (wv_pkt_raddr_nop2pcb_1),
.o_pkt_rd_p1                (w_pkt_rd_nop2pcb_1),
.i_pkt_raddr_ack_p1         (w_pkt_raddr_ack_pcb2nop_1),
                            
.iv_pkt_data_p1             (wv_pkt_data_pcb2nop_1),
.i_pkt_data_wr_p1           (w_pkt_data_wr_pcb2nop_1),
                            
.ov_gmii_txd_p1             (ov_gmii_txd_p1 ),
.o_gmii_tx_en_p1            (o_gmii_tx_en_p1),         
                       
.o_port1_outpkt_pulse       (w_port1_outpkt_pulse_nop2tsm)
);

command_parse_and_encapsulate_tse command_parse_and_encapsulate_tse_inst(
.i_clk		                      (i_clk                               ),
.i_rst_n	                      (i_rst_n                             ),
                                                                       
.iv_command                       (iv_command                          ), 
.i_command_wr                     (i_command_wr                        ),          
                                                                       
.ov_addr                          (ov_addr_cpe2all                     ),
.ov_wdata                         (ov_wdata_cpe2all                    ),
.o_addr_fixed                     (o_addr_fixed_cpe2all                ),

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
.o_wr_frm                         (w_wr_frm_cpe2dex),
.o_rd_frm                         (w_rd_frm_cpe2dex),
.o_wr_tic                         (w_wr_tic_cpe2ctx),
.o_rd_tic                         (w_rd_tic_cpe2ctx),
.o_wr_cdc_p3                      (o_wr_cdc_p3),
.o_rd_cdc_p3                      (o_rd_cdc_p3),
                                                       
.o_wr_grm                         (w_wr_cit2grm                        ),
.o_rd_grm                         (w_rd_cit2grm                        ),	
                                                                                                                                          
.o_wr_pcb                         (w_wr_cit2pcb                        ),
.o_rd_pcb                         (w_rd_cit2pcb                        ),
                                                                       
.o_wr_qgc0                        (w_wr_cit2qgc0                       ),
.o_rd_qgc0                        (w_rd_cit2qgc0                       ),
                                                                       
.o_wr_qgc1                        (w_wr_cit2qgc1                       ),
.o_rd_qgc1                        (w_rd_cit2qgc1                       ),
                                                                       
.o_wr_qgc2                        (w_wr_cit2qgc2                       ),
.o_rd_qgc2                        (w_rd_cit2qgc2                       ),
                                                                       
.o_wr_fim                        (w_wr_cit2fim                       ),
.o_rd_fim                        (w_rd_cit2fim                       ),
                                                                                                                                     
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
                                                                       
.i_wr_frm                         (w_wr_frm2cpe                 ),
.iv_addr_frm                      (wv_addr_frm2cpe              ),
.i_addr_fixed_frm                 (w_addr_fixed_frm2cpe         ),
.iv_rdata_frm                     (wv_rdata_frm2cpe             ),
                                                                       
.i_wr_tic                         (w_wr_tic2cpe                 ),
.iv_addr_tic                      (wv_addr_tic2cpe              ),
.i_addr_fixed_tic                 (w_addr_fixed_tic2cpe         ),
.iv_rdata_tic                     (wv_rdata_tic2cpe             ),
                                                                       
.i_wr_cdc_p3                      (i_wr_cdc_p3        ),
.iv_addr_cdc_p3                   (iv_addr_cdc_p3     ),
.i_addr_fixed_cdc_p3              (i_addr_fixed_cdc_p3),
.iv_rdata_cdc_p3                  (iv_rdata_cdc_p3    ),
                                                                                                                                                                      
.i_wr_grm                         (w_wr_grm2cit                        ),
.iv_addr_grm                      (wv_addr_grm2cit                     ),
.i_addr_fixed_grm                 (w_addr_fixed_grm2cit                ),
.iv_rdata_grm                     (wv_rdata_grm2cit                    ),
                                 
.i_wr_pcb                         (w_wr_pcb2cit                        ),
.iv_addr_pcb                      (wv_addr_pcb2cit                     ),
.i_addr_fixed_pcb                 (w_addr_fixed_pcb2cit                ),
.iv_rdata_pcb                     (wv_rdata_pcb2cit                    ),	
                                                                                                                                             
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
                                                                      
.i_wr_fim                         (w_wr_fim2cit                       ),
.iv_addr_fim                      (wv_addr_fim2cit                    ),
.i_addr_fixed_fim                 (w_addr_fixed_fim2cit               ),
.iv_rdata_fim                     (wv_rdata_fim2cit                   ),
                                                                                                      
.ov_command_ack                   (ov_command_ack                      ),
.o_command_ack_wr                 (o_command_ack_wr                    )         
);

global_registers_management_tse global_registers_management_inst(
.i_clk                            (i_clk                                 ),                
.i_rst_n                          (i_rst_n                               ),      
                                                                         
.iv_addr                          (ov_addr_cpe2all                       ),              
.i_addr_fixed                     (o_addr_fixed_cpe2all                  ),            
.iv_wdata                         (ov_wdata_cpe2all                      ),         
.i_wr                             (w_wr_cit2grm                          ),      
.i_rd                             (w_rd_cit2grm                          ),      
                                                                         
.o_wr                             (w_wr_grm2cit                          ),      
.ov_addr                          (wv_addr_grm2cit                       ),      
.o_addr_fixed                     (w_addr_fixed_grm2cit                  ),      
.ov_rdata                         (wv_rdata_grm2cit                      ),      

.ov_tse_ver                       (ov_tse_ver                            ),
.ov_hardware_stage                (                     ),
.ov_be_threshold_value            (wv_be_threshold_value_grm2nip         ), 
.ov_rc_threshold_value            (wv_rc_threshold_value_grm2nip         ),
.ov_standardpkt_threshold_value   (wv_standardpkt_threshold_value_grm2nip),
.o_qbv_or_qch                     (w_qbv_or_qch_grm2nop                  ),          
.ov_time_slot_length              (ov_time_slot_length                   ),          
.ov_schedule_period               (ov_schedule_period                    )  
);
endmodule
 
