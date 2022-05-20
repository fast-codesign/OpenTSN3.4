// Copyright (C) 1953-2022 NUDT
// Verilog module name - tsnswitch 
// Version:V3.4.0.20220226
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//               
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tsnswitch
(
       i_clk,
       
       i_hard_rst_n,
       i_button_rst_n,
       i_et_resetc_rst_n,  
       
       ov_gmii_txd_p0,
       o_gmii_tx_en_p0,
       o_gmii_tx_er_p0,
       o_gmii_tx_clk_p0,

       ov_gmii_txd_p1,
       o_gmii_tx_en_p1,
       o_gmii_tx_er_p1,
       o_gmii_tx_clk_p1,
       
       ov_gmii_txd_p2,
       o_gmii_tx_en_p2,
       o_gmii_tx_er_p2,
       o_gmii_tx_clk_p2,
       
       ov_gmii_txd_p3,
       o_gmii_tx_en_p3,
       o_gmii_tx_er_p3,
       o_gmii_tx_clk_p3,

       ov_gmii_txd_p4,
       o_gmii_tx_en_p4,
       o_gmii_tx_er_p4,
       o_gmii_tx_clk_p4,
       
       ov_gmii_txd_p5,
       o_gmii_tx_en_p5,
       o_gmii_tx_er_p5,
       o_gmii_tx_clk_p5,
       
       ov_gmii_txd_p6,
       o_gmii_tx_en_p6,
       o_gmii_tx_er_p6,
       o_gmii_tx_clk_p6,

       ov_gmii_txd_p7,
       o_gmii_tx_en_p7,
       o_gmii_tx_er_p7,
       o_gmii_tx_clk_p7,    
       //Network input top module
       i_gmii_rxclk_p0,
       i_gmii_dv_p0,
       iv_gmii_rxd_p0,
       i_gmii_er_p0,
       
       i_gmii_rxclk_p1,
       i_gmii_dv_p1,
       iv_gmii_rxd_p1,
       i_gmii_er_p1,
       
       i_gmii_rxclk_p2,
       i_gmii_dv_p2,
       iv_gmii_rxd_p2,
       i_gmii_er_p2,

       i_gmii_rxclk_p3,
       i_gmii_dv_p3,
       iv_gmii_rxd_p3,
       i_gmii_er_p3,
       
       i_gmii_rxclk_p4,
       i_gmii_dv_p4,
       iv_gmii_rxd_p4,
       i_gmii_er_p4,
       
       i_gmii_rxclk_p5,
       i_gmii_dv_p5,
       iv_gmii_rxd_p5,
       i_gmii_er_p5,

       i_gmii_rxclk_p6,
       i_gmii_dv_p6,
       iv_gmii_rxd_p6,
       i_gmii_er_p6,
       
       i_gmii_rxclk_p7,
       i_gmii_dv_p7,
       iv_gmii_rxd_p7,
       i_gmii_er_p7, 
       
       i_gmii_rxclk_from_cpu  ,
       i_gmii_rx_dv_from_cpu  ,
       iv_gmii_rxd_from_cpu   ,
       i_gmii_rx_er_from_cpu  ,
       ov_gmii_txd_to_cpu     ,
       o_gmii_tx_en_to_cpu    ,
       o_gmii_txclk_to_cpu    ,
       o_gmii_tx_er_to_cpu    ,
       
       reset_clk_pulse,
       ov_hardware_stage,
       o_cycle_start       
);

input                   i_clk;                  //125Mhz

input                   i_hard_rst_n;
input                   i_button_rst_n;
input                   i_et_resetc_rst_n;

output                  reset_clk_pulse;
output                  o_cycle_start; 
//input
input                   i_gmii_rxclk_p0;
input                   i_gmii_dv_p0;
input       [7:0]       iv_gmii_rxd_p0;
input                   i_gmii_er_p0;

input                   i_gmii_rxclk_p1;
input                   i_gmii_dv_p1;
input       [7:0]       iv_gmii_rxd_p1;
input                   i_gmii_er_p1;

input                   i_gmii_rxclk_p2;
input                   i_gmii_dv_p2;
input       [7:0]       iv_gmii_rxd_p2;
input                   i_gmii_er_p2;


input                   i_gmii_rxclk_p3;
input                   i_gmii_dv_p3;
input       [7:0]       iv_gmii_rxd_p3;
input                   i_gmii_er_p3;

input                   i_gmii_rxclk_p4;
input                   i_gmii_dv_p4;
input       [7:0]       iv_gmii_rxd_p4;
input                   i_gmii_er_p4;

input                   i_gmii_rxclk_p5;
input                   i_gmii_dv_p5;
input       [7:0]       iv_gmii_rxd_p5;
input                   i_gmii_er_p5;

input                   i_gmii_rxclk_p6;
input                   i_gmii_dv_p6;
input       [7:0]       iv_gmii_rxd_p6;
input                   i_gmii_er_p6;

input                   i_gmii_rxclk_p7;
input                   i_gmii_dv_p7;
input       [7:0]       iv_gmii_rxd_p7;
input                   i_gmii_er_p7;
//output
output      [7:0]       ov_gmii_txd_p0;
output                  o_gmii_tx_en_p0;
output                  o_gmii_tx_er_p0;
output                  o_gmii_tx_clk_p0;

output      [7:0]       ov_gmii_txd_p1;
output                  o_gmii_tx_en_p1;
output                  o_gmii_tx_er_p1;
output                  o_gmii_tx_clk_p1;

output      [7:0]       ov_gmii_txd_p2;
output                  o_gmii_tx_en_p2;
output                  o_gmii_tx_er_p2;
output                  o_gmii_tx_clk_p2;

output      [7:0]       ov_gmii_txd_p3;
output                  o_gmii_tx_en_p3;
output                  o_gmii_tx_er_p3;
output                  o_gmii_tx_clk_p3;

output      [7:0]       ov_gmii_txd_p4;
output                  o_gmii_tx_en_p4;
output                  o_gmii_tx_er_p4;
output                  o_gmii_tx_clk_p4;

output      [7:0]       ov_gmii_txd_p5;
output                  o_gmii_tx_en_p5;
output                  o_gmii_tx_er_p5;
output                  o_gmii_tx_clk_p5;

output      [7:0]       ov_gmii_txd_p6;
output                  o_gmii_tx_en_p6;
output                  o_gmii_tx_er_p6;
output                  o_gmii_tx_clk_p6;

output      [7:0]       ov_gmii_txd_p7;
output                  o_gmii_tx_en_p7;
output                  o_gmii_tx_er_p7;
output                  o_gmii_tx_clk_p7;

input                   i_gmii_rxclk_from_cpu ;
input	      		    i_gmii_rx_dv_from_cpu ;
input	    [7:0]	 	iv_gmii_rxd_from_cpu  ;
input                   i_gmii_rx_er_from_cpu ;
output      [7:0] 	  	ov_gmii_txd_to_cpu    ;
output          		o_gmii_tx_en_to_cpu   ;
output                  o_gmii_txclk_to_cpu   ;
output                  o_gmii_tx_er_to_cpu   ;

output      [2:0]       ov_hardware_stage;

wire        [11:0]      wv_local_id_hcp2tss                   ;
wire        [31:0]      wv_tss_ver_tss2hcp                    ;
wire                    w_rc_rxenable_hcp2tss                 ;
wire                    w_st_rxenable_hcp2tss                 ;
wire                    w_tsmp_lookup_table_key_wr_tss2hcp    ;
wire        [47:0]      wv_tsmp_lookup_table_key_tss2hcp      ;
wire        [32:0]      wv_tsmp_lookup_table_outport_hcp2tss  ;
wire                    w_tsmp_lookup_table_outport_wr_hcp2tss;

wire        [63:0]      wv_command_hcp2tss        ;   
wire                    w_command_wr_hcp2tss      ; 
wire        [63:0]      wv_command_ack_tss2hcp    ;
wire                    w_command_ack_wr_tss2hcp  ;  

wire                    w_gmii_clk_p8_hcp2oem;
wire                    w_gmii_dv_p8_hcp2oem;
wire        [7:0]       wv_gmii_data_p8_hcp2oem;
wire                    w_gmii_er_p8_hcp2oem;
wire        [7:0]       wv_gmii_data_p8_oem2hcp;
wire                    w_gmii_en_p8_oem2hcp;
wire                    w_gmii_er_p8_oem2hcp;

wire        [63:0]      wv_syn_clk_stc2swc   ;
wire        [63:0]      wv_local_time_stc2swc;
wire        [10:0]      wv_schedule_period_tss2stc  ;
wire        [10:0]      wv_time_slot_length_tss2stc ;
//adp2tsnchip 
wire                    w_gmii_dv_p0_adp2tsnchip;
wire        [7:0]       wv_gmii_rxd_p0_adp2tsnchip;

wire                    w_gmii_dv_p1_adp2tsnchip;
wire        [7:0]       wv_gmii_rxd_p1_adp2tsnchip;

wire                    w_gmii_dv_p2_adp2tsnchip;
wire        [7:0]       wv_gmii_rxd_p2_adp2tsnchip;

wire                    w_gmii_dv_p3_adp2tsnchip;
wire        [7:0]       wv_gmii_rxd_p3_adp2tsnchip;

wire                    w_gmii_dv_p4_adp2tsnchip;
wire        [7:0]       wv_gmii_rxd_p4_adp2tsnchip;

wire                    w_gmii_dv_p5_adp2tsnchip;
wire        [7:0]       wv_gmii_rxd_p5_adp2tsnchip;

wire                    w_gmii_dv_p6_adp2tsnchip;
wire        [7:0]       wv_gmii_rxd_p6_adp2tsnchip;

wire                    w_gmii_dv_p7_adp2tsnchip;
wire        [7:0]       wv_gmii_rxd_p7_adp2tsnchip;

wire                    w_gmii_dv_p8_adp2tsnchip;
wire        [7:0]       wv_gmii_rxd_p8_adp2tsnchip;
//tsnchip2adp
wire      [7:0]         wv_gmii_txd_p0_tsnchip2adp;
wire                    w_gmii_tx_en_p0_tsnchip2adp;
    
wire      [7:0]         wv_gmii_txd_p1_tsnchip2adp;
wire                    w_gmii_tx_en_p1_tsnchip2adp;
    
wire      [7:0]         wv_gmii_txd_p2_tsnchip2adp;
wire                    w_gmii_tx_en_p2_tsnchip2adp;
    
wire      [7:0]         wv_gmii_txd_p3_tsnchip2adp;
wire                    w_gmii_tx_en_p3_tsnchip2adp;
    
wire      [7:0]         wv_gmii_txd_p4_tsnchip2adp;
wire                    w_gmii_tx_en_p4_tsnchip2adp;
    
wire      [7:0]         wv_gmii_txd_p5_tsnchip2adp;
wire                    w_gmii_tx_en_p5_tsnchip2adp;
    
wire      [7:0]         wv_gmii_txd_p6_tsnchip2adp;
wire                    w_gmii_tx_en_p6_tsnchip2adp;

wire      [7:0]         wv_gmii_txd_p7_tsnchip2adp;
wire                    w_gmii_tx_en_p7_tsnchip2adp;

wire      [7:0]         wv_gmii_txd_p8_tsnchip2adp;
wire                    w_gmii_tx_en_p8_tsnchip2adp;

wire      [18:0]        wv_addr_cit2all                ;
wire      [31:0]        wv_wdata_cit2all               ;
wire                    w_addr_fixed_cit2all           ;

wire                    w_wr_cfu_cpe2cfu               ;    
wire                    w_rd_cfu_cpe2cfu               ;    
wire                    w_wr_cfu_cfu2cpe               ;    
wire      [18:0]        wv_addr_cfu_cfu2cpe            ;    
wire                    w_addr_fixed_cfu_cfu2cpe       ;    
wire      [31:0]        wv_rdata_cfu                   ;

wire                    w_wr_cdc_p8_cpe2cdc            ;    
wire                    w_rd_cdc_p8_cpe2cdc            ;    
wire                    w_wr_cdc_p8_cdc2cpe            ;    
wire      [18:0]        wv_addr_cdc_p8_cdc2cpe         ;    
wire                    w_addr_fixed_cdc_p8_cdc2cpe    ;    
wire      [31:0]        wv_rdata_cdc_p8_cdc2cpe        ;    

wire                    w_wr_cdc_p0_cpe2cdc            ;    
wire                    w_rd_cdc_p0_cpe2cdc            ;    
wire                    w_wr_cdc_p0_cdc2cpe            ;    
wire      [18:0]        wv_addr_cdc_p0_cdc2cpe         ;    
wire                    w_addr_fixed_cdc_p0_cdc2cpe    ;    
wire      [31:0]        wv_rdata_cdc_p0                ;

wire                    w_wr_cdc_p1_cpe2cdc            ;    
wire                    w_rd_cdc_p1_cpe2cdc            ;    
wire                    w_wr_cdc_p1_cdc2cpe            ;    
wire      [18:0]        wv_addr_cdc_p1_cdc2cpe         ;    
wire                    w_addr_fixed_cdc_p1_cdc2cpe    ;    
wire      [31:0]        wv_rdata_cdc_p1_cdc2cpe        ;    

wire                    w_wr_cdc_p2_cpe2cdc            ;    
wire                    w_rd_cdc_p2_cpe2cdc            ;    
wire                    w_wr_cdc_p2_cdc2cpe            ;    
wire      [18:0]        wv_addr_cdc_p2_cdc2cpe         ;    
wire                    w_addr_fixed_cdc_p2_cdc2cpe    ;    
wire      [31:0]        wv_rdata_cdc_p2_cdc2cpe        ;    

wire                    w_wr_cdc_p3_cpe2cdc            ;    
wire                    w_rd_cdc_p3_cpe2cdc            ;    
wire                    w_wr_cdc_p3_cdc2cpe            ;    
wire       [18:0]       wv_addr_cdc_p3_cdc2cpe         ;    
wire                    w_addr_fixed_cdc_p3_cdc2cpe    ;    
wire       [31:0]       wv_rdata_cdc_p3_cdc2cpe        ;    

wire                    w_wr_cdc_p4_cpe2cdc            ;    
wire                    w_rd_cdc_p4_cpe2cdc            ;    
wire                    w_wr_cdc_p4_cdc2cpe            ;    
wire       [18:0]       wv_addr_cdc_p4_cdc2cpe         ;    
wire                    w_addr_fixed_cdc_p4_cdc2cpe    ;    
wire       [31:0]       wv_rdata_cdc_p4_cdc2cpe        ;    

wire                    w_wr_cdc_p5_cpe2cdc            ;    
wire                    w_rd_cdc_p5_cpe2cdc            ;    
wire                    w_wr_cdc_p5_cdc2cpe            ;    
wire       [18:0]       wv_addr_cdc_p5_cdc2cpe         ;    
wire                    w_addr_fixed_cdc_p5_cdc2cpe    ;    
wire       [31:0]       wv_rdata_cdc_p5_cdc2cpe        ;    

wire                    w_wr_cdc_p6_cpe2cdc            ;    
wire                    w_rd_cdc_p6_cpe2cdc            ;    
wire                    w_wr_cdc_p6_cdc2cpe            ;    
wire       [18:0]       wv_addr_cdc_p6_cdc2cpe         ;    
wire                    w_addr_fixed_cdc_p6_cdc2cpe    ;    
wire       [31:0]       wv_rdata_cdc_p6_cdc2cpe        ;    

wire                    w_wr_cdc_p7_cpe2cdc            ;    
wire                    w_rd_cdc_p7_cpe2cdc            ;    
wire                    w_wr_cdc_p7_cdc2cpe            ;    
wire       [18:0]       wv_addr_cdc_p7_cdc2cpe         ;    
wire                    w_addr_fixed_cdc_p7_cdc2cpe    ;    
wire       [31:0]       wv_rdata_cdc_p7_cdc2cpe        ; 

wire                    w_wr_hcp2osm                   ;
wire       [31:0]       wv_wdata_hcp2osm               ;
wire       [18:0]       wv_addr_hcp2osm                ;
wire                    w_addr_fixed_hcp2osm           ;
wire                    w_rd_hcp2osm                   ;
wire                    w_wr_osm2hcp                   ;
wire       [31:0]       wv_rdata_osm2hcp               ;
wire       [18:0]       wv_raddr_osm2hcp               ;
wire                    w_addr_fixed_osm2hcp           ;

wire       [31:0]       wv_syn_clock_cycle_stc2tss     ;
wire                    w_tsn_or_tte_osm2hcp           ;   
//reset sync
wire                    w_core_rst_n;
wire                    w_gmii_rst_n_p0;
wire                    w_gmii_rst_n_p1;
wire                    w_gmii_rst_n_p2;
wire                    w_gmii_rst_n_p3;
wire                    w_gmii_rst_n_p4;
wire                    w_gmii_rst_n_p5;
wire                    w_gmii_rst_n_p6;
wire                    w_gmii_rst_n_p7;
wire                    w_gmii_rst_n_p8;
                        
wire                    w_rst_n;

assign w_rst_n = i_hard_rst_n & i_button_rst_n & i_et_resetc_rst_n;
assign o_gmii_tx_clk_p0 = i_gmii_rxclk_p0;
assign o_gmii_tx_clk_p1 = i_gmii_rxclk_p1;
assign o_gmii_tx_clk_p2 = i_gmii_rxclk_p2;
assign o_gmii_tx_clk_p3 = i_gmii_rxclk_p3;
assign o_gmii_tx_clk_p4 = i_gmii_rxclk_p4;
assign o_gmii_tx_clk_p5 = i_gmii_rxclk_p5;
assign o_gmii_tx_clk_p6 = i_gmii_rxclk_p6;
assign o_gmii_tx_clk_p7 = i_gmii_rxclk_p7;

assign ov_hardware_stage = {1'b0,w_st_rxenable_hcp2tss,w_rc_rxenable_hcp2tss};
hardware_control_point hardware_control_point_inst
(
.i_clk                            (i_clk                ),
.i_rst_n                          (w_core_rst_n         ),  

.ov_syn_clk                       (wv_syn_clk_stc2swc   ),
.ov_local_cnt                     (wv_local_time_stc2swc),
.ov_syn_clock_cycle               (wv_syn_clock_cycle_stc2tss),        
.i_tsn_or_tte                     (w_tsn_or_tte_osm2hcp ),

.i_data_wr_from_tss               (w_gmii_tx_en_p8_tsnchip2adp ),
.iv_data_from_tss                 (wv_gmii_txd_p8_tsnchip2adp  ),  
.ov_data_to_tss                   (wv_gmii_rxd_p8_adp2tsnchip  ),
.o_data_wr_to_tss                 (w_gmii_dv_p8_adp2tsnchip    ),

.i_gmii_rxclk_from_cpu            (i_gmii_rxclk_from_cpu  ),
.i_gmii_rx_dv_from_cpu            (i_gmii_rx_dv_from_cpu  ), 
.iv_gmii_rxd_from_cpu             (iv_gmii_rxd_from_cpu   ),
.i_gmii_rx_er_from_cpu            (i_gmii_rx_er_from_cpu  ),
.ov_gmii_txd_to_cpu               (ov_gmii_txd_to_cpu     ),
.o_gmii_tx_en_to_cpu              (o_gmii_tx_en_to_cpu    ),
.o_gmii_txclk_to_cpu              (o_gmii_txclk_to_cpu    ),
.o_gmii_tx_er_to_cpu              (o_gmii_tx_er_to_cpu    ),

.ov_local_id                      (wv_local_id_hcp2tss                   ), 
.iv_tss_ver                       (wv_tss_ver_tss2hcp                    ),
.o_rc_rxenable                    (w_rc_rxenable_hcp2tss                 ),
.o_st_rxenable                    (w_st_rxenable_hcp2tss                 ),
.i_tsmp_lookup_table_key_wr       (w_tsmp_lookup_table_key_wr_tss2hcp    ),
.iv_tsmp_lookup_table_key         (wv_tsmp_lookup_table_key_tss2hcp      ),
.ov_tsmp_lookup_table_outport     (wv_tsmp_lookup_table_outport_hcp2tss  ),
.o_tsmp_lookup_table_outport_wr   (w_tsmp_lookup_table_outport_wr_hcp2tss),

.iv_time_slot_length              (wv_time_slot_length_tss2stc),  
.iv_schedule_period               (wv_schedule_period_tss2stc ),
.o_cycle_start                    (o_cycle_start),

.o_wr_osm                         (w_wr_hcp2osm        ),
.ov_wdata_osm                     (wv_wdata_hcp2osm    ),
.ov_addr_osm                      (wv_addr_hcp2osm     ),
.o_addr_fix_osm                   (w_addr_fixed_hcp2osm),
.o_rd_osm                         (w_rd_hcp2osm        ),
.i_wr_osm                         (w_wr_osm2hcp        ),
.iv_raddr_osm                     (wv_raddr_osm2hcp    ),
.i_addr_fix_osm                   (w_addr_fixed_osm2hcp),
.iv_rdata_osm                     (wv_rdata_osm2hcp    ),

.ov_command_1                       (wv_command_hcp2tss                    ),
.o_command_wr_1                     (w_command_wr_hcp2tss                  ),        
.iv_command_ack_1                   (wv_command_ack_tss2hcp                ),
.i_command_ack_wr_1                 (w_command_ack_wr_tss2hcp              )
);  
reset_top reset_top_inst(
.i_clk                (i_clk),
.i_rst_n              (w_rst_n),
                      
.i_gmii_rxclk_p0      (i_gmii_rxclk_p0),
.i_gmii_rxclk_p1      (i_gmii_rxclk_p1),
.i_gmii_rxclk_p2      (i_gmii_rxclk_p2),
.i_gmii_rxclk_p3      (i_gmii_rxclk_p3),
.i_gmii_rxclk_p4      (i_gmii_rxclk_p4),
.i_gmii_rxclk_p5      (i_gmii_rxclk_p5),
.i_gmii_rxclk_p6      (i_gmii_rxclk_p6),
.i_gmii_rxclk_p7      (i_gmii_rxclk_p7),
.i_gmii_rxclk_host    (i_clk),
                     
.o_core_rst_n         (w_core_rst_n),
.o_gmii_rst_n_p0      (w_gmii_rst_n_p0),
.o_gmii_rst_n_p1      (w_gmii_rst_n_p1),
.o_gmii_rst_n_p2      (w_gmii_rst_n_p2),
.o_gmii_rst_n_p3      (w_gmii_rst_n_p3),
.o_gmii_rst_n_p4      (w_gmii_rst_n_p4),
.o_gmii_rst_n_p5      (w_gmii_rst_n_p5),
.o_gmii_rst_n_p6      (w_gmii_rst_n_p6),
.o_gmii_rst_n_p7      (w_gmii_rst_n_p7),
.o_gmii_rst_n_host    (w_gmii_rst_n_p8)
);

reset_clock_check reset_clock_check_inst(
.i_clk(i_clk),
.i_rst_n(w_core_rst_n),

.o_reset_clk_pulse(reset_clk_pulse)  
);
opensync_mac opensync_mac_inst
(
.i_clk               (i_clk          ),
.i_rst_n             (w_core_rst_n   ),
                     
.iv_syn_clk          (wv_syn_clk_stc2swc     ),       
.iv_local_time       (wv_local_time_stc2swc  ),
                     
.i_port_type         (1'b0           ),
.i_interface_type    (1'b0           ),//network interface
.iv_syn_clock_cycle  (wv_syn_clock_cycle_stc2tss),
                     
.i_wr                (w_wr_hcp2osm        ),      
.iv_wdata            (wv_wdata_hcp2osm    ),      
.iv_addr             (wv_addr_hcp2osm     ),
.i_addr_fixed        (w_addr_fixed_hcp2osm),        
.i_rd                (w_rd_hcp2osm        ),           
.o_wr                (w_wr_osm2hcp        ),       
.ov_rdata            (wv_rdata_osm2hcp    ),        
.ov_raddr            (wv_raddr_osm2hcp    ),
.o_addr_fixed        (w_addr_fixed_osm2hcp), 

.o_tsn_or_tte        (w_tsn_or_tte_osm2hcp),
//p0
.i_gmii_clk_p0       (i_gmii_rxclk_p0),                   
.i_gmii_rst_n_p0     (w_gmii_rst_n_p0),
              
.i_gmii_rx_dv_p0     (i_gmii_dv_p0   ),
.i_gmii_rx_er_p0     (i_gmii_er_p0   ),
.iv_gmii_rxd_p0      (iv_gmii_rxd_p0 ),
.o_gmii_tx_en_p0     (o_gmii_tx_en_p0),
.o_gmii_tx_er_p0     (o_gmii_tx_er_p0),
.ov_gmii_txd_p0      (ov_gmii_txd_p0 ),
    
.i_data_wr_p0        (w_gmii_tx_en_p0_tsnchip2adp),
.iv_data_p0          (wv_gmii_txd_p0_tsnchip2adp ),
.o_data_wr_p0        (w_gmii_dv_p0_adp2tsnchip   ),
.ov_data_p0          (wv_gmii_rxd_p0_adp2tsnchip ),
//p1
.i_gmii_clk_p1       (i_gmii_rxclk_p1),                   
.i_gmii_rst_n_p1     (w_gmii_rst_n_p1),
              
.i_gmii_rx_dv_p1     (i_gmii_dv_p1   ),
.i_gmii_rx_er_p1     (i_gmii_er_p1   ),
.iv_gmii_rxd_p1      (iv_gmii_rxd_p1 ),
.o_gmii_tx_en_p1     (o_gmii_tx_en_p1),
.o_gmii_tx_er_p1     (o_gmii_tx_er_p1),
.ov_gmii_txd_p1      (ov_gmii_txd_p1 ),
    
.i_data_wr_p1        (w_gmii_tx_en_p1_tsnchip2adp),
.iv_data_p1          (wv_gmii_txd_p1_tsnchip2adp ),
.o_data_wr_p1        (w_gmii_dv_p1_adp2tsnchip   ),
.ov_data_p1          (wv_gmii_rxd_p1_adp2tsnchip ),
//p2
.i_gmii_clk_p2       (i_gmii_rxclk_p2),                   
.i_gmii_rst_n_p2     (w_gmii_rst_n_p2),
              
.i_gmii_rx_dv_p2     (i_gmii_dv_p2   ),
.i_gmii_rx_er_p2     (i_gmii_er_p2   ),
.iv_gmii_rxd_p2      (iv_gmii_rxd_p2 ),
.o_gmii_tx_en_p2     (o_gmii_tx_en_p2),
.o_gmii_tx_er_p2     (o_gmii_tx_er_p2),
.ov_gmii_txd_p2      (ov_gmii_txd_p2 ),
    
.i_data_wr_p2        (w_gmii_tx_en_p2_tsnchip2adp),
.iv_data_p2          (wv_gmii_txd_p2_tsnchip2adp ),
.o_data_wr_p2        (w_gmii_dv_p2_adp2tsnchip   ),
.ov_data_p2          (wv_gmii_rxd_p2_adp2tsnchip ),
//p3
.i_gmii_clk_p3       (i_gmii_rxclk_p3),                   
.i_gmii_rst_n_p3     (w_gmii_rst_n_p3),
              
.i_gmii_rx_dv_p3     (i_gmii_dv_p3   ),
.i_gmii_rx_er_p3     (i_gmii_er_p3   ),
.iv_gmii_rxd_p3      (iv_gmii_rxd_p3 ),
.o_gmii_tx_en_p3     (o_gmii_tx_en_p3),
.o_gmii_tx_er_p3     (o_gmii_tx_er_p3),
.ov_gmii_txd_p3      (ov_gmii_txd_p3 ),
    
.i_data_wr_p3        (w_gmii_tx_en_p3_tsnchip2adp),
.iv_data_p3          (wv_gmii_txd_p3_tsnchip2adp ),
.o_data_wr_p3        (w_gmii_dv_p3_adp2tsnchip   ),
.ov_data_p3          (wv_gmii_rxd_p3_adp2tsnchip ),
//p4
.i_gmii_clk_p4       (i_clk),                   
.i_gmii_rst_n_p4     (w_gmii_rst_n_p4),
              
.i_gmii_rx_dv_p4     (1'b0 ),
.i_gmii_rx_er_p4     (1'b0 ),
.iv_gmii_rxd_p4      (8'b0  ),
.o_gmii_tx_en_p4     (o_gmii_tx_en_p4),
.o_gmii_tx_er_p4     (o_gmii_tx_er_p4),
.ov_gmii_txd_p4      (ov_gmii_txd_p4 ),
    
.i_data_wr_p4        (w_gmii_tx_en_p4_tsnchip2adp),
.iv_data_p4          (wv_gmii_txd_p4_tsnchip2adp ),
.o_data_wr_p4        (w_gmii_dv_p4_adp2tsnchip   ),
.ov_data_p4          (wv_gmii_rxd_p4_adp2tsnchip ),
//p5
.i_gmii_clk_p5       (i_clk),                   
.i_gmii_rst_n_p5     (w_gmii_rst_n_p5),

.i_gmii_rx_dv_p5     (1'b0  ),
.i_gmii_rx_er_p5     (1'b0  ),
.iv_gmii_rxd_p5      (8'b0  ),
.o_gmii_tx_en_p5     (o_gmii_tx_en_p5),
.o_gmii_tx_er_p5     (o_gmii_tx_er_p5),
.ov_gmii_txd_p5      (ov_gmii_txd_p5 ),
    
.i_data_wr_p5        (w_gmii_tx_en_p5_tsnchip2adp),
.iv_data_p5          (wv_gmii_txd_p5_tsnchip2adp ),
.o_data_wr_p5        (w_gmii_dv_p5_adp2tsnchip   ),
.ov_data_p5          (wv_gmii_rxd_p5_adp2tsnchip ),
//p6
.i_gmii_clk_p6       (i_clk),                   
.i_gmii_rst_n_p6     (w_gmii_rst_n_p6),
              
.i_gmii_rx_dv_p6     (1'b0  ),
.i_gmii_rx_er_p6     (1'b0  ),
.iv_gmii_rxd_p6      (8'b0  ),
.o_gmii_tx_en_p6     (o_gmii_tx_en_p6),
.o_gmii_tx_er_p6     (o_gmii_tx_er_p6),
.ov_gmii_txd_p6      (ov_gmii_txd_p6 ),
    
.i_data_wr_p6        (w_gmii_tx_en_p6_tsnchip2adp),
.iv_data_p6          (wv_gmii_txd_p6_tsnchip2adp ),
.o_data_wr_p6        (w_gmii_dv_p6_adp2tsnchip   ),
.ov_data_p6          (wv_gmii_rxd_p6_adp2tsnchip ),
//p7
.i_gmii_clk_p7       (i_clk),                   
.i_gmii_rst_n_p7     (w_gmii_rst_n_p7),

.i_gmii_rx_dv_p7     (1'b0 ),
.i_gmii_rx_er_p7     (1'b0 ),
.iv_gmii_rxd_p7      (8'b0 ),
.o_gmii_tx_en_p7     (o_gmii_tx_en_p7),
.o_gmii_tx_er_p7     (o_gmii_tx_er_p7),
.ov_gmii_txd_p7      (ov_gmii_txd_p7 ),
    
.i_data_wr_p7        (w_gmii_tx_en_p7_tsnchip2adp),
.iv_data_p7          (wv_gmii_txd_p7_tsnchip2adp ),
.o_data_wr_p7        (w_gmii_dv_p7_adp2tsnchip   ),
.ov_data_p7          (wv_gmii_rxd_p7_adp2tsnchip )
);
/*
opensync_enable_mac opensync_enable_mac_network8
(                    
.i_gmii_clk       (i_clk      ),                   
.i_gmii_rst_n     (w_gmii_rst_n_p8            ),
                                              
.i_clk            (i_clk                      ),
.i_rst_n          (w_core_rst_n               ),
                                              
.iv_syn_clk       (wv_syn_clk_stc2swc         ),       
.iv_local_time    (wv_local_time_stc2swc      ),
                                              
.i_port_type      (1'b0                       ),
.i_interface_type (1'b1                       ),//ctrl interface
.iv_syn_clock_cycle(wv_syn_clock_cycle_stc2tss),
                                              
.i_gmii_rx_dv     (w_gmii_dv_p8_hcp2oem       ),
.i_gmii_rx_er     (w_gmii_er_p8_hcp2oem       ),
.iv_gmii_rxd      (wv_gmii_data_p8_hcp2oem    ),
.o_gmii_tx_en     (w_gmii_en_p8_oem2hcp       ),
.o_gmii_tx_er     (w_gmii_er_p8_oem2hcp       ),
.ov_gmii_txd      (wv_gmii_data_p8_oem2hcp    ),
    
.i_data_wr        (w_gmii_tx_en_p8_tsnchip2adp),
.iv_data          (wv_gmii_txd_p8_tsnchip2adp ),
.o_data_wr        (w_gmii_dv_p8_adp2tsnchip   ),
.ov_data          (wv_gmii_rxd_p8_adp2tsnchip )
);
*/
opentsn_time_sensitive_switch opentsn_time_sensitive_switch_inst(
.i_clk                          (i_clk                     ),
.i_rst_n                        (w_core_rst_n              ),

.iv_syn_clk                     (wv_syn_clk_stc2swc        ) ,   
//rx              
.i_gmii_dv_p0                   (w_gmii_dv_p0_adp2tsnchip  ),
.iv_gmii_rxd_p0                 (wv_gmii_rxd_p0_adp2tsnchip), 

.i_gmii_dv_p1                   (w_gmii_dv_p1_adp2tsnchip  ),
.iv_gmii_rxd_p1                 (wv_gmii_rxd_p1_adp2tsnchip),

.i_gmii_dv_p2                   (w_gmii_dv_p2_adp2tsnchip  ),
.iv_gmii_rxd_p2                 (wv_gmii_rxd_p2_adp2tsnchip),

.i_gmii_dv_p3                   (w_gmii_dv_p3_adp2tsnchip  ),
.iv_gmii_rxd_p3                 (wv_gmii_rxd_p3_adp2tsnchip),

.i_gmii_dv_p4                   (w_gmii_dv_p4_adp2tsnchip  ),
.iv_gmii_rxd_p4                 (wv_gmii_rxd_p4_adp2tsnchip),

.i_gmii_dv_p5                   (w_gmii_dv_p5_adp2tsnchip  ),
.iv_gmii_rxd_p5                 (wv_gmii_rxd_p5_adp2tsnchip),

.i_gmii_dv_p6                   (w_gmii_dv_p6_adp2tsnchip  ),
.iv_gmii_rxd_p6                 (wv_gmii_rxd_p6_adp2tsnchip),

.i_gmii_dv_p7                   (w_gmii_dv_p7_adp2tsnchip  ),
.iv_gmii_rxd_p7                 (wv_gmii_rxd_p7_adp2tsnchip),

.i_gmii_dv_p8                   (w_gmii_dv_p8_adp2tsnchip  ),
.iv_gmii_rxd_p8                 (wv_gmii_rxd_p8_adp2tsnchip),
//tx                              
.ov_gmii_txd_p0                 (wv_gmii_txd_p0_tsnchip2adp ),
.o_gmii_tx_en_p0                (w_gmii_tx_en_p0_tsnchip2adp),
                                
.ov_gmii_txd_p1                 (wv_gmii_txd_p1_tsnchip2adp ),
.o_gmii_tx_en_p1                (w_gmii_tx_en_p1_tsnchip2adp),
                                
.ov_gmii_txd_p2                 (wv_gmii_txd_p2_tsnchip2adp ),
.o_gmii_tx_en_p2                (w_gmii_tx_en_p2_tsnchip2adp),
                                
.ov_gmii_txd_p3                 (wv_gmii_txd_p3_tsnchip2adp ),
.o_gmii_tx_en_p3                (w_gmii_tx_en_p3_tsnchip2adp),
                                
.ov_gmii_txd_p4                 (wv_gmii_txd_p4_tsnchip2adp ),
.o_gmii_tx_en_p4                (w_gmii_tx_en_p4_tsnchip2adp),
                                
.ov_gmii_txd_p5                 (wv_gmii_txd_p5_tsnchip2adp ),  
.o_gmii_tx_en_p5                (w_gmii_tx_en_p5_tsnchip2adp),
                                
.ov_gmii_txd_p6                 (wv_gmii_txd_p6_tsnchip2adp ),
.o_gmii_tx_en_p6                (w_gmii_tx_en_p6_tsnchip2adp),
                                
.ov_gmii_txd_p7                 (wv_gmii_txd_p7_tsnchip2adp ),
.o_gmii_tx_en_p7                (w_gmii_tx_en_p7_tsnchip2adp),
                                
.ov_gmii_txd_p8                 (wv_gmii_txd_p8_tsnchip2adp ),
.o_gmii_tx_en_p8                (w_gmii_tx_en_p8_tsnchip2adp),

.iv_local_id                    (wv_local_id_hcp2tss                   ),
.ov_tss_ver                     (wv_tss_ver_tss2hcp                    ),
.i_rc_rxenable                  (w_rc_rxenable_hcp2tss                 ),
.i_st_rxenable                  (w_st_rxenable_hcp2tss                 ),
.o_tsmp_lookup_table_key_wr     (w_tsmp_lookup_table_key_wr_tss2hcp    ),
.ov_tsmp_lookup_table_key       (wv_tsmp_lookup_table_key_tss2hcp      ),
.iv_tsmp_lookup_table_outport   (wv_tsmp_lookup_table_outport_hcp2tss  ),
.i_tsmp_lookup_table_outport_wr (w_tsmp_lookup_table_outport_wr_hcp2tss),  

.iv_command                     (wv_command_hcp2tss         ),  
.i_command_wr                   (w_command_wr_hcp2tss       ), 
.ov_command_ack                 (wv_command_ack_tss2hcp     ),
.o_command_ack_wr               (w_command_ack_wr_tss2hcp   ), 

.ov_time_slot_length            (wv_time_slot_length_tss2stc),
.ov_schedule_period             (wv_schedule_period_tss2stc ),

.ov_addr_cit2all                (wv_addr_cit2all                ),
.ov_wdata_cit2all               (wv_wdata_cit2all               ),
.o_addr_fixed_cit2all           (w_addr_fixed_cit2all           ),
                                 
.o_wr_cfu                       (w_wr_cfu_cpe2cfu               ),      
.o_rd_cfu                       (w_rd_cfu_cpe2cfu               ),                                                 
.i_wr_cfu                       (w_wr_cfu_cfu2cpe               ),  
.iv_addr_cfu                    (wv_addr_cfu_cfu2cpe            ),
.i_addr_fixed_cfu               (w_addr_fixed_cfu_cfu2cpe       ),
.iv_rdata_cfu                   (wv_rdata_cfu                   ),
                                 
.o_wr_cdc_p8                    (w_wr_cdc_p8_cpe2cdc            ),      
.o_rd_cdc_p8                    (w_rd_cdc_p8_cpe2cdc            ),                                                 
.i_wr_cdc_p8                    (w_wr_cdc_p8_cdc2cpe            ),  
.iv_addr_cdc_p8                 (wv_addr_cdc_p8_cdc2cpe         ),
.i_addr_fixed_cdc_p8            (w_addr_fixed_cdc_p8_cdc2cpe    ),
.iv_rdata_cdc_p8                (wv_rdata_cdc_p8_cdc2cpe        ),
                                 
.o_wr_cdc_p0                    (w_wr_cdc_p0_cpe2cdc            ),      
.o_rd_cdc_p0                    (w_rd_cdc_p0_cpe2cdc            ),                                                 
.i_wr_cdc_p0                    (w_wr_cdc_p0_cdc2cpe            ),  
.iv_addr_cdc_p0                 (wv_addr_cdc_p0_cdc2cpe         ),
.i_addr_fixed_cdc_p0            (w_addr_fixed_cdc_p0_cdc2cpe    ),
.iv_rdata_cdc_p0                (wv_rdata_cdc_p0                ),
                                 
.o_wr_cdc_p1                    (w_wr_cdc_p1_cpe2cdc            ), 
.o_rd_cdc_p1                    (w_rd_cdc_p1_cpe2cdc            ), 
.i_wr_cdc_p1                    (w_wr_cdc_p1_cdc2cpe            ), 
.iv_addr_cdc_p1                 (wv_addr_cdc_p1_cdc2cpe         ),
.i_addr_fixed_cdc_p1            (w_addr_fixed_cdc_p1_cdc2cpe    ),
.iv_rdata_cdc_p1                (wv_rdata_cdc_p1_cdc2cpe        ),
                                 
.o_wr_cdc_p2                    (w_wr_cdc_p2_cpe2cdc            ), 
.o_rd_cdc_p2                    (w_rd_cdc_p2_cpe2cdc            ), 
.i_wr_cdc_p2                    (w_wr_cdc_p2_cdc2cpe            ), 
.iv_addr_cdc_p2                 (wv_addr_cdc_p2_cdc2cpe         ),
.i_addr_fixed_cdc_p2            (w_addr_fixed_cdc_p2_cdc2cpe    ),
.iv_rdata_cdc_p2                (wv_rdata_cdc_p2_cdc2cpe        ),
                                 
.o_wr_cdc_p3                    (w_wr_cdc_p3_cpe2cdc            ), 
.o_rd_cdc_p3                    (w_rd_cdc_p3_cpe2cdc            ), 
.i_wr_cdc_p3                    (w_wr_cdc_p3_cdc2cpe            ), 
.iv_addr_cdc_p3                 (wv_addr_cdc_p3_cdc2cpe         ),
.i_addr_fixed_cdc_p3            (w_addr_fixed_cdc_p3_cdc2cpe    ),
.iv_rdata_cdc_p3                (wv_rdata_cdc_p3_cdc2cpe        ),
                                 
.o_wr_cdc_p4                    (w_wr_cdc_p4_cpe2cdc            ), 
.o_rd_cdc_p4                    (w_rd_cdc_p4_cpe2cdc            ), 
.i_wr_cdc_p4                    (w_wr_cdc_p4_cdc2cpe            ), 
.iv_addr_cdc_p4                 (wv_addr_cdc_p4_cdc2cpe         ),
.i_addr_fixed_cdc_p4            (w_addr_fixed_cdc_p4_cdc2cpe    ),
.iv_rdata_cdc_p4                (wv_rdata_cdc_p4_cdc2cpe        ),
                                 
.o_wr_cdc_p5                    (w_wr_cdc_p5_cpe2cdc            ), 
.o_rd_cdc_p5                    (w_rd_cdc_p5_cpe2cdc            ), 
.i_wr_cdc_p5                    (w_wr_cdc_p5_cdc2cpe            ), 
.iv_addr_cdc_p5                 (wv_addr_cdc_p5_cdc2cpe         ),
.i_addr_fixed_cdc_p5            (w_addr_fixed_cdc_p5_cdc2cpe    ),
.iv_rdata_cdc_p5                (wv_rdata_cdc_p5_cdc2cpe        ),
                                 
.o_wr_cdc_p6                    (w_wr_cdc_p6_cpe2cdc            ), 
.o_rd_cdc_p6                    (w_rd_cdc_p6_cpe2cdc            ), 
.i_wr_cdc_p6                    (w_wr_cdc_p6_cdc2cpe            ), 
.iv_addr_cdc_p6                 (wv_addr_cdc_p6_cdc2cpe         ),
.i_addr_fixed_cdc_p6            (w_addr_fixed_cdc_p6_cdc2cpe    ),
.iv_rdata_cdc_p6                (wv_rdata_cdc_p6_cdc2cpe        ),
                                 
.o_wr_cdc_p7                    (w_wr_cdc_p7_cpe2cdc            ),
.o_rd_cdc_p7                    (w_rd_cdc_p7_cpe2cdc            ),
.i_wr_cdc_p7                    (w_wr_cdc_p7_cdc2cpe            ),
.iv_addr_cdc_p7                 (wv_addr_cdc_p7_cdc2cpe         ),
.i_addr_fixed_cdc_p7            (w_addr_fixed_cdc_p7_cdc2cpe    ),
.iv_rdata_cdc_p7                (wv_rdata_cdc_p7_cdc2cpe        )
);
endmodule            