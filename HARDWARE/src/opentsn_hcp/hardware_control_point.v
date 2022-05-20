// Copyright (C) 1953-2022 NUDT
// Verilog module name - hardware_control_point
// Version: V3.4.0.20220228
// Created:
//         by - fenglin
////////////////////////////////////////////////////////////////////////////
// Description:
//         hardware control point
///////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module hardware_control_point
(
        i_clk,
        i_rst_n,  

        ov_syn_clk        ,
        ov_local_cnt      ,
        ov_syn_clock_cycle,        
        i_tsn_or_tte      ,
        
	    i_data_wr_from_tss ,
	    iv_data_from_tss   ,  
	    ov_data_to_tss     ,
	    o_data_wr_to_tss   ,
        
        i_gmii_rxclk_from_cpu ,
        i_gmii_rx_dv_from_cpu , 
        iv_gmii_rxd_from_cpu  ,
        i_gmii_rx_er_from_cpu ,
        ov_gmii_txd_to_cpu    ,
        o_gmii_tx_en_to_cpu   ,
        o_gmii_txclk_to_cpu        ,
        o_gmii_tx_er_to_cpu   ,

        ov_local_id                      , 
        iv_tss_ver                       , 
        o_rc_rxenable                    ,
        o_st_rxenable                    ,
        
        i_tsmp_lookup_table_key_wr       ,
        iv_tsmp_lookup_table_key         ,
        ov_tsmp_lookup_table_outport     ,
        o_tsmp_lookup_table_outport_wr   ,
		
		iv_time_slot_length      ,
		iv_schedule_period       ,
		o_cycle_start            ,
		
		o_wr_osm              ,
		ov_wdata_osm          ,
		ov_addr_osm           ,
		o_addr_fix_osm        ,
		o_rd_osm              ,
		i_wr_osm              ,
		iv_raddr_osm          ,
		i_addr_fix_osm        ,
		iv_rdata_osm          ,

        ov_command_1       ,
        o_command_wr_1     ,        
        iv_command_ack_1   ,
        i_command_ack_wr_1 ,
		
		ov_command_2      ,
		o_command_wr_2    ,
		iv_command_ack_2  ,
		i_command_ack_wr_2,
		
		ov_command_3      ,
		o_command_wr_3    ,
		iv_command_ack_3  ,
		i_command_ack_wr_3
);
// I/O
// clk & rst
input               i_clk;
input               i_rst_n; 

output  [63:0]      ov_syn_clk        ;
output  [63:0]      ov_local_cnt      ;
output  [31:0]      ov_syn_clock_cycle;        
input               i_tsn_or_tte      ; 

output  [63:0]	    ov_command_1        ;
output  	        o_command_wr_1      ;
input   [63:0]	    iv_command_ack_1    ;
input    	        i_command_ack_wr_1  ;

output  [63:0]	    ov_command_2        ;
output  	        o_command_wr_2      ;
input   [63:0]	    iv_command_ack_2    ;
input    	        i_command_ack_wr_2  ;

output  [63:0]	    ov_command_3        ;
output  	        o_command_wr_3      ;
input   [63:0]	    iv_command_ack_3    ;
input    	        i_command_ack_wr_3  ;

input	  		    i_data_wr_from_tss;
input	[7:0]	 	iv_data_from_tss  ;

input               i_gmii_rxclk_from_cpu ;
input	  		    i_gmii_rx_dv_from_cpu ;
input	[7:0]	 	iv_gmii_rxd_from_cpu  ;
input               i_gmii_rx_er_from_cpu ;

output  [7:0] 	  	ov_data_to_tss    ;
output      		o_data_wr_to_tss  ;

output              o_gmii_txclk_to_cpu       ;
output  [7:0] 	  	ov_gmii_txd_to_cpu   ;
output      		o_gmii_tx_en_to_cpu  ;
output              o_gmii_tx_er_to_cpu  ;

output  [11:0]      ov_local_id                      ; 
input   [31:0]      iv_tss_ver                       ;
output              o_rc_rxenable                    ;
output              o_st_rxenable                    ;
input               i_tsmp_lookup_table_key_wr       ;
input   [47:0]      iv_tsmp_lookup_table_key         ;
output  [32:0]      ov_tsmp_lookup_table_outport     ;
output              o_tsmp_lookup_table_outport_wr   ;

input   [10:0]      iv_time_slot_length    ; 
input   [10:0]      iv_schedule_period     ; 
output              o_cycle_start;           // 1024 ms / 1.024ms pluse
                
output              o_wr_osm            ;
output  [31:0]      ov_wdata_osm        ;
output  [18:0]      ov_addr_osm         ;
output              o_addr_fix_osm      ;
output              o_rd_osm            ;
input               i_wr_osm            ;
input   [18:0]      iv_raddr_osm        ;
input               i_addr_fix_osm      ;
input   [31:0]      iv_rdata_osm        ;

wire    [11:0]      wv_os_cid_ost2ta    ;

wire    [7:0] 	  	wv_data_tss2ta  ;
wire        		w_data_wr_tss2ta;

wire    [7:0] 	  	wv_data_ta2tss  ;
wire        		w_data_wr_ta2tss;

wire                w_wr_ta2ost         ;
wire    [31:0]      wv_wdata_ta2ost     ;
wire    [18:0]      wv_addr_ta2ost      ;
wire                w_addr_fix_ta2ost   ;
wire                w_rd_ta2ost         ;
wire                w_wr_ost2ta         ;
wire    [18:0]      wv_raddr_ost2ta     ;
wire                w_addr_fix_ost2ta   ;
wire    [31:0]      wv_rdata_ost2ta     ;
           
wire                w_wr_ta2tft         ;
wire    [31:0]      wv_wdata_ta2tft     ;
wire    [18:0]      wv_addr_ta2tft      ;
wire                w_addr_fix_ta2tft   ;
wire                w_rd_ta2tft         ;
wire                w_wr_tft2ta         ;
wire    [18:0]      wv_raddr_tft2ta     ;
wire                w_addr_fix_tft2ta   ;
wire    [31:0]      wv_rdata_tft2ta     ;

wire                w_wr_ta2cc         ;
wire    [31:0]      wv_wdata_ta2cc     ;
wire    [18:0]      wv_addr_ta2cc      ;
wire                w_addr_fix_ta2cc   ;
wire                w_rd_ta2cc         ;
wire                w_wr_cc2ta         ;
wire    [18:0]      wv_raddr_cc2ta     ;
wire                w_addr_fix_cc2ta   ;
wire    [31:0]      wv_rdata_cc2ta     ;

wire    [63:0]      wv_syn_clk         ;

//wire                w_tsmp_fwenable_ta2tft;

packet_switch packet_switch_inst
(
.i_clk           (i_clk                 ),   
.i_rst_n         (i_rst_n               ),

.i_data_wr       (i_data_wr_from_tss    ),
.iv_data         (iv_data_from_tss      ),

.o_gmii_txclk_cpu(o_gmii_txclk_to_cpu   ),
.ov_gmii_txd_cpu (ov_gmii_txd_to_cpu    ),
.o_gmii_tx_en_cpu(o_gmii_tx_en_to_cpu   ),
.o_gmii_tx_er_cpu(o_gmii_tx_er_to_cpu   ),
.ov_data_hcp     (wv_data_tss2ta        ),
.o_data_wr_hcp   (w_data_wr_tss2ta      ),

.i_gmii_rxclk_cpu(i_gmii_rxclk_from_cpu ),
.i_gmii_rx_dv_cpu(i_gmii_rx_dv_from_cpu ),
.iv_gmii_rxd_cpu (iv_gmii_rxd_from_cpu  ),
.i_gmii_rx_er_cpu(i_gmii_rx_er_from_cpu ),
.i_data_wr_hcp   (w_data_wr_ta2tss      ),
.iv_data_hcp     (wv_data_ta2tss        ),

.ov_data         (ov_data_to_tss        ), 
.o_data_wr       (o_data_wr_to_tss      )  
);

tsmp_agent tsmp_agent_inst
(
.i_clk                          (i_clk              ),
.i_rst_n                        (i_rst_n            ),
                                                    
.iv_syn_clk                     (ov_syn_clk         ),
.iv_local_time                  (ov_local_cnt       ),
.iv_syn_clock_cycle             (ov_syn_clock_cycle ),
.i_tsn_or_tte                   (i_tsn_or_tte       ),
                                                                                                  
.i_data_wr                      (w_data_wr_tss2ta   ),                            
.iv_data                        (wv_data_tss2ta     ),                                                                               
.ov_data                        (wv_data_ta2tss     ),                          
.o_data_wr                      (w_data_wr_ta2tss   ),
                                                    
.ov_local_id                    (ov_local_id        ),
.iv_tss_ver                     (iv_tss_ver         ),
.iv_os_cid                      (wv_os_cid_ost2ta   ),
.o_rc_rxenable                  (o_rc_rxenable      ),
.o_st_rxenable                  (o_st_rxenable      ),
//.o_tsmp_fwenable                (w_tsmp_fwenable_ta2tft),//20220511

.o_wr_ost                       (w_wr_ta2ost        ),
.ov_wdata_ost                   (wv_wdata_ta2ost    ),
.ov_addr_ost                    (wv_addr_ta2ost     ),
.o_addr_fix_ost                 (w_addr_fix_ta2ost  ),
.o_rd_ost                       (w_rd_ta2ost        ),
.i_wr_ost                       (w_wr_ost2ta        ),
.iv_raddr_ost                   (wv_raddr_ost2ta    ),
.i_addr_fix_ost                 (w_addr_fix_ost2ta  ),
.iv_rdata_ost                   (wv_rdata_ost2ta    ),
                                            
.o_wr_tft                       (w_wr_ta2tft        ),
.ov_wdata_tft                   (wv_wdata_ta2tft    ),
.ov_addr_tft                    (wv_addr_ta2tft     ),
.o_addr_fix_tft                 (w_addr_fix_ta2tft  ),
.o_rd_tft                       (w_rd_ta2tft        ),
.i_wr_tft                       (w_wr_tft2ta        ),
.iv_raddr_tft                   (wv_raddr_tft2ta    ),
.i_addr_fix_tft                 (w_addr_fix_tft2ta  ),
.iv_rdata_tft                   (wv_rdata_tft2ta    ),

.o_wr_cc                        (w_wr_ta2cc         ),
.ov_wdata_cc                    (wv_wdata_ta2cc     ),
.ov_addr_cc                     (wv_addr_ta2cc      ),
.o_addr_fix_cc                  (w_addr_fix_ta2cc   ),
.o_rd_cc                        (w_rd_ta2cc         ),
.i_wr_cc                        (w_wr_cc2ta         ),
.iv_raddr_cc                    (wv_raddr_cc2ta     ),
.i_addr_fix_cc                  (w_addr_fix_cc2ta   ),
.iv_rdata_cc                    (wv_rdata_cc2ta     ),
                                              
.o_wr_osm                       (o_wr_osm           ),
.ov_wdata_osm                   (ov_wdata_osm       ),
.ov_addr_osm                    (ov_addr_osm        ),
.o_addr_fix_osm                 (o_addr_fix_osm     ),
.o_rd_osm                       (o_rd_osm           ),
.i_wr_osm                       (i_wr_osm           ),
.iv_raddr_osm                   (iv_raddr_osm       ),
.i_addr_fix_osm                 (i_addr_fix_osm     ),
.iv_rdata_osm                   (iv_rdata_osm       ),
                                               
.ov_command_1                   (ov_command_1      ),
.o_command_wr_1                 (o_command_wr_1    ),
.iv_command_ack_1               (iv_command_ack_1  ),
.i_command_ack_wr_1             (i_command_ack_wr_1),
                                 
.ov_command_2                   (ov_command_2      ),
.o_command_wr_2                 (o_command_wr_2    ),
.iv_command_ack_2               (iv_command_ack_2  ),
.i_command_ack_wr_2             (i_command_ack_wr_2),
                                 
.ov_command_3                   (ov_command_3      ),
.o_command_wr_3                 (o_command_wr_3    ),
.iv_command_ack_3               (iv_command_ack_3  ),
.i_command_ack_wr_3             (i_command_ack_wr_3)
);

tsmp_forward_table tsmp_forward_table_inst
(
.i_clk                            (i_clk                            ),
.i_rst_n                          (i_rst_n                          ),

.iv_hcp_mid                       (ov_local_id                      ),
 
.iv_addr                          (wv_addr_ta2tft                   ), 
.iv_wdata                         (wv_wdata_ta2tft                  ), 
.i_addr_fixed                     (w_addr_fix_ta2tft                ), 
.i_wr                             (w_wr_ta2tft                      ), 
.i_rd                             (w_rd_ta2tft                      ),                
.o_wr                             (w_wr_tft2ta                      ), 
.ov_addr                          (wv_raddr_tft2ta                  ), 
.o_addr_fixed                     (w_addr_fix_tft2ta                ), 
.ov_rdata                         (wv_rdata_tft2ta                  ), 

.i_tsmp_lookup_table_key_wr       (i_tsmp_lookup_table_key_wr       ),
.iv_tsmp_lookup_table_key         (iv_tsmp_lookup_table_key         ),
.ov_tsmp_lookup_table_outport     (ov_tsmp_lookup_table_outport     ),
.o_tsmp_lookup_table_outport_wr   (o_tsmp_lookup_table_outport_wr   )	   
);

opensync_timing opensync_timing_inst
(

.i_clk                  (i_clk                  ),
.i_rst_n                (i_rst_n                ),

.i_stc_wr               (w_wr_ta2ost            ),      
.iv_stc_wdata           (wv_wdata_ta2ost        ),      
.iv_stc_addr            (wv_addr_ta2ost         ),
.i_stc_addr_fixed       (w_addr_fix_ta2ost      ),        
.i_stc_rd               (w_rd_ta2ost            ),      
.o_stc_wr               (w_wr_ost2ta            ),       
.ov_stc_rdata           (wv_rdata_ost2ta        ),        
.ov_stc_raddr           (wv_raddr_ost2ta        ),
.o_stc_addr_fixed       (w_addr_fix_ost2ta      ),        

.i_tsn_or_tte           (i_tsn_or_tte           ),  
.ov_syn_clock_cycle     (ov_syn_clock_cycle     ),
.ov_os_cid              (wv_os_cid_ost2ta       ),

.ov_syn_clk             (ov_syn_clk             ),
.ov_local_cnt           (ov_local_cnt           )
);

syn_clk_judge syn_clk_judge_inst
(
.i_clk                   (i_clk              ),
.i_rst_n                 (i_rst_n            ),

.i_tsn_or_tte            (i_tsn_or_tte      ),
.iv_syn_clk_cycle        (ov_syn_clock_cycle),
.iv_syn_clk              (ov_syn_clk         ),

.ov_syn_clk              (wv_syn_clk         )
);

cycle_control cycle_control_inst
(
.i_clk                   (i_clk              ),
.i_rst_n                 (i_rst_n            ),

.i_wr_cc                 (w_wr_ta2cc         ),
.iv_wdata_cc             (wv_wdata_ta2cc     ),
.iv_addr_cc              (wv_addr_ta2cc      ),
.i_addr_fixed_cc         (w_addr_fix_ta2cc   ),
.i_rd_cc                 (w_rd_ta2cc         ),
.o_wr_cc                 (w_wr_cc2ta         ),
.ov_rdata_cc             (wv_rdata_cc2ta     ),
.ov_raddr_cc             (wv_raddr_cc2ta     ),
.o_addr_fixed_cc         (w_addr_fix_cc2ta   ),

.iv_syn_clk              (wv_syn_clk         ),

.o_cycle_start           (o_cycle_start      )
);
endmodule 