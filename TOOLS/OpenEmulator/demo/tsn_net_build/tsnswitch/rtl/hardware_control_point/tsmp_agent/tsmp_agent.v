// Copyright (C) 1953-2022 NUDT
// Verilog module name - tsmp_agent
// Version: V3.4.0.20220228
// Created:
//         by - fenglin
////////////////////////////////////////////////////////////////////////////
// Description:
//         hardware control point
///////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module tsmp_agent
(
        i_clk             ,
        i_rst_n           ,  

        iv_syn_clk        ,
        iv_local_time     ,
        iv_syn_clock_cycle,        
        i_tsn_or_tte      ,
        iv_os_cid         ,
        
	    i_data_wr         ,
	    iv_data           ,  
	    ov_data           ,
	    o_data_wr         ,
         
        ov_local_id       , 
        iv_tss_ver        ,
        o_rc_rxenable     ,
        o_st_rxenable     ,
       // o_tsmp_fwenable   ,//20220511
                
        o_wr_ost          ,        
        ov_wdata_ost      ,      
        ov_addr_ost       ,      
        o_addr_fix_ost    ,      
        o_rd_ost          ,      
        i_wr_ost          ,      
        iv_raddr_ost      ,      
        i_addr_fix_ost    ,      
        iv_rdata_ost      ,      

        o_wr_cc          ,      
        ov_wdata_cc      ,      
        ov_addr_cc       ,      
        o_addr_fix_cc    ,      
        o_rd_cc          ,      
        i_wr_cc          ,      
        iv_raddr_cc      ,      
        i_addr_fix_cc    ,      
        iv_rdata_cc      ,  
        
        o_wr_tft          ,      
        ov_wdata_tft      ,      
        ov_addr_tft       ,      
        o_addr_fix_tft    ,      
        o_rd_tft          ,      
        i_wr_tft          ,      
        iv_raddr_tft      ,      
        i_addr_fix_tft    ,      
        iv_rdata_tft      ,      
                  
        o_wr_osm          ,      
        ov_wdata_osm      ,      
        ov_addr_osm       ,      
        o_addr_fix_osm    ,      
        o_rd_osm          ,      
        i_wr_osm          ,      
        iv_raddr_osm      ,      
        i_addr_fix_osm    ,      
        iv_rdata_osm      ,  

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
input               i_clk             ;
input               i_rst_n           ; 

input   [63:0]      iv_syn_clk        ;
input   [63:0]      iv_local_time     ;
input   [31:0]      iv_syn_clock_cycle;        
input               i_tsn_or_tte      ; 

input   [11:0]      iv_os_cid         ;

output  [63:0]	    ov_command_1        ;
output  	        o_command_wr_1      ;
input   [63:0]	    iv_command_ack_1    ;
input    	        i_command_ack_wr_1  ;

output  [63:0]	    ov_command_2        ;
output  	        o_command_wr_2      ;
input   [63:0]	    iv_command_ack_2    ;
input    	        i_command_ack_wr_2  ;

output  [63:0]	    ov_command_3        ;
output  	        o_command_wr_3       ;
input   [63:0]	    iv_command_ack_3     ;
input    	        i_command_ack_wr_3   ;

input	  		    i_data_wr         ;
input	[7:0]	 	iv_data           ;
                                      
output  [7:0] 	  	ov_data           ;
output      		o_data_wr         ;

output  [11:0]      ov_local_id       ; 
input   [31:0]      iv_tss_ver        ;
output              o_rc_rxenable     ;
output              o_st_rxenable     ;
//output              o_tsmp_fwenable   ;

output              o_wr_ost          ;        
output  [31:0]      ov_wdata_ost      ;      
output  [18:0]      ov_addr_ost       ;      
output              o_addr_fix_ost    ;      
output              o_rd_ost          ;      
input               i_wr_ost          ;      
input   [18:0]      iv_raddr_ost      ;      
input               i_addr_fix_ost    ;      
input   [31:0]      iv_rdata_ost      ; 

output              o_wr_cc          ;      
output  [31:0]      ov_wdata_cc      ;      
output  [18:0]      ov_addr_cc       ;      
output              o_addr_fix_cc    ;      
output              o_rd_cc          ;      
input               i_wr_cc          ;      
input   [18:0]      iv_raddr_cc      ;      
input               i_addr_fix_cc    ;      
input   [31:0]      iv_rdata_cc      ;      
                              
output              o_wr_tft          ;      
output  [31:0]      ov_wdata_tft      ;      
output  [18:0]      ov_addr_tft       ;      
output              o_addr_fix_tft    ;      
output              o_rd_tft          ;      
input               i_wr_tft          ;      
input   [18:0]      iv_raddr_tft      ;      
input               i_addr_fix_tft    ;      
input   [31:0]      iv_rdata_tft      ;      
                               
output              o_wr_osm          ;      
output  [31:0]      ov_wdata_osm      ;      
output  [18:0]      ov_addr_osm       ;      
output              o_addr_fix_osm    ;      
output              o_rd_osm          ;      
input               i_wr_osm          ;      
input   [18:0]      iv_raddr_osm      ;      
input               i_addr_fix_osm    ;      
input   [31:0]      iv_rdata_osm      ;  

wire                w_data_wr_rpr2hta    ;
wire    [7:0]       wv_data_rpr2hta      ;

wire                w_gmii_tx_en_ntx2gad ;
wire                w_gmii_tx_er_ntx2gad ;
wire    [7:0]       wv_gmii_txd_ntx2gad  ;
                
wire    [8:0]       wv_data_tpp2nma      ;
wire                w_data_wr_tpp2nma    ;
wire    [8:0]       wv_data_tpp2osp      ;
wire                w_data_wr_tpp2osp    ;
wire    [8:0]       wv_data_tpp2tfp      ;
wire                w_data_wr_tpp2tfp    ;
wire                w_encapsulated_flag_tpp2tfp;
wire    [8:0]       wv_data_tpp2adi      ;
wire                w_data_wr_tpp2adi    ;

wire    [8:0]       wv_data_hrx2tpp      ;
wire                w_data_wr_hrx2tpp    ;
//nma
wire    [65:0]	    wv_command_nma2lac      ;
wire  	            w_command_wr_nma2lac    ;                   
wire    [65:0]	    wv_command_ack_lac2nma  ;
wire   	            w_command_ack_wr_lac2nma;

wire                w_hrg_wr_lac2hrg    ;
wire    [31:0]      wv_hrg_wdata_lac2hrg;
wire    [18:0]      wv_hrg_addr_lac2hrg ;
wire                w_hrg_addr_fix_lac2hrg;       
wire                w_hrg_rd_lac2hrg      ;          
wire                w_hrg_wr_hrg2lac      ;
wire    [18:0]      wv_hrg_raddr_hrg2lac;
wire                w_hrg_addr_fix_hrg2lac;
wire    [31:0]      wv_hrg_rdata_hrg2lac;    

wire    [8:0]       wv_data_nma2ttc   ;
wire                w_data_wr_nma2ttc ;
wire    [8:0]       wv_data_osp2ttc   ;
wire                w_data_wr_osp2ttc ;
wire    [8:0]       wv_data_tfp2ttc   ;
wire                w_data_wr_tfp2ttc ;
wire    [8:0]       wv_data_pop2ttc   ;
wire                w_data_wr_pop2ttc ;

wire    [8:0]       wv_data_ttc2htx   ;
wire                w_data_wr_ttc2htx ;

wire    [47:0]      wv_hcp_mac_hrg2other;
wire    [47:0]      wv_tsnlight_controller_mac_hrg2other;
wire    [47:0]      wv_opensync_controller_mac_hrg2other;

wire    [11:0]      wv_hcp_mid_adi2hrg;
wire    [11:0]      wv_tsnlight_mid_adi2hrg;
assign  ov_local_id = wv_hcp_mid_adi2hrg;
hcp_register_group hcp_register_group_inst
(
.i_clk                   (i_clk                  ),
.i_rst_n                 (i_rst_n                ),
.iv_hcp_mid              (wv_hcp_mid_adi2hrg     ),
.iv_tsnlight_mid         (wv_tsnlight_mid_adi2hrg),
.iv_os_cid               (iv_os_cid              ),
.iv_tss_ver              (iv_tss_ver             ),
.o_rc_rxenable           (o_rc_rxenable          ),
.o_st_rxenable           (o_st_rxenable          ),
//.o_tsmp_fwenable         (o_tsmp_fwenable        ),20220511
//.i_tsn_or_tte            (i_tsn_or_tte           ),

.iv_addr                 (wv_hrg_addr_lac2hrg    ),           
.i_addr_fixed            (w_hrg_addr_fix_lac2hrg ),       
.iv_wdata                (wv_hrg_wdata_lac2hrg   ),          
.i_wr                    (w_hrg_wr_lac2hrg       ),           
.i_rd                    (w_hrg_rd_lac2hrg       ),           
.o_wr                    (w_hrg_wr_hrg2lac       ),           
.ov_addr                 (wv_hrg_raddr_hrg2lac   ),       
.o_addr_fixed            (w_hrg_addr_fix_hrg2lac ),     
.ov_rdata                (wv_hrg_rdata_hrg2lac   ),  

.ov_hcp_mac              (wv_hcp_mac_hrg2other) ,
.ov_tsnlight_controller_mac      (wv_tsnlight_controller_mac_hrg2other),
.ov_opensync_controller_mac      (wv_opensync_controller_mac_hrg2other)        
);
opensync_receive_pit_record opensync_receive_pit_record_inst
(
.i_clk              (i_clk             ),
.i_rst_n            (i_rst_n           ),
                                       
.iv_syn_clk         (iv_syn_clk        ),
.iv_local_time      (iv_local_time     ),
                                       
.iv_data            (iv_data    ),
.i_data_wr          (i_data_wr  ),
                                       
.ov_data            (wv_data_rpr2hta   ), 
.o_data_wr          (w_data_wr_rpr2hta ) 
);

head_and_tail_add head_and_tail_add_inst
(
.i_clk       (i_clk  ),
.i_rst_n     (i_rst_n),

.i_data_wr   (w_data_wr_rpr2hta),
.iv_data     (wv_data_rpr2hta  ),

.ov_data     (wv_data_hrx2tpp  ),
.o_data_wr   (w_data_wr_hrx2tpp)
);

tsmp_protocol_process tsmp_protocol_process_inst
(
.i_clk                  (i_clk                  ),
.i_rst_n                (i_rst_n                ),
                                                
.iv_data                (wv_data_hrx2tpp        ),
.i_data_wr              (w_data_wr_hrx2tpp      ),
                                                
.ov_data_nma            (wv_data_tpp2nma        ),
.o_data_wr_nma          (w_data_wr_tpp2nma      ),
                                                
.ov_data_osp            (wv_data_tpp2osp        ),
.o_data_wr_osp          (w_data_wr_tpp2osp      ),
                                                
.ov_data_tfp            (wv_data_tpp2tfp        ),
.o_data_wr_tfp          (w_data_wr_tpp2tfp      ),
.o_encapsulated_flag_tfp(w_encapsulated_flag_tpp2tfp),

.ov_data_adi            (wv_data_tpp2adi        ),
.o_data_wr_adi          (w_data_wr_tpp2adi      )
);

network_management network_management_inst
(
.i_clk              (i_clk                    ),
.i_rst_n            (i_rst_n                  ),
                                              
.ov_command         (wv_command_nma2lac       ),
.o_command_wr       (w_command_wr_nma2lac     ),       
                                              
.iv_command_ack     (wv_command_ack_lac2nma   ),
.i_command_ack_wr   (w_command_ack_wr_lac2nma ),
                                              
.iv_hcp_mac         (wv_hcp_mac_hrg2other       ),
.iv_controller_mac  (wv_tsnlight_controller_mac_hrg2other),       

.iv_data            (wv_data_tpp2nma          ),
.i_data_wr          (w_data_wr_tpp2nma        ),

.ov_data            (wv_data_nma2ttc  ),
.o_data_wr          (w_data_wr_nma2ttc)
);

local_access_control local_access_control_inst
(
.i_clk                   (i_clk   ),
.i_rst_n                 (i_rst_n ),       
                         
.iv_command              (wv_command_nma2lac      ),
.i_command_wr            (w_command_wr_nma2lac    ),        
.ov_command_ack          (wv_command_ack_lac2nma  ),
.o_command_ack_wr        (w_command_ack_wr_lac2nma),
                         
.o_hrg_wr                (w_hrg_wr_lac2hrg        ),
.ov_hrg_wdata            (wv_hrg_wdata_lac2hrg    ),
.ov_hrg_addr             (wv_hrg_addr_lac2hrg     ),
.o_hrg_addr_fix          (w_hrg_addr_fix_lac2hrg  ), 
.o_hrg_rd                (w_hrg_rd_lac2hrg        ),       
.i_hrg_wr                (w_hrg_wr_hrg2lac        ),
.iv_hrg_raddr            (wv_hrg_raddr_hrg2lac    ),
.i_hrg_addr_fix          (w_hrg_addr_fix_hrg2lac  ),
.iv_hrg_rdata            (wv_hrg_rdata_hrg2lac    ),

.o_ost_wr                (o_wr_ost                ),
.ov_ost_wdata            (ov_wdata_ost            ),
.ov_ost_addr             (ov_addr_ost             ),
.o_ost_addr_fix          (o_addr_fix_ost          ), 
.o_ost_rd                (o_rd_ost                ),       
.i_ost_wr                (i_wr_ost                ),
.iv_ost_raddr            (iv_raddr_ost            ),
.i_ost_addr_fix          (i_addr_fix_ost          ),
.iv_ost_rdata            (iv_rdata_ost            ),

.o_cc_wr                (o_wr_cc                ),
.ov_cc_wdata            (ov_wdata_cc            ),
.ov_cc_addr             (ov_addr_cc             ),
.o_cc_addr_fix          (o_addr_fix_cc          ), 
.o_cc_rd                (o_rd_cc                ),       
.i_cc_wr                (i_wr_cc                ),
.iv_cc_raddr            (iv_raddr_cc            ),
.i_cc_addr_fix          (i_addr_fix_cc          ),
.iv_cc_rdata            (iv_rdata_cc            ),

.o_tft_wr                (o_wr_tft                ),
.ov_tft_wdata            (ov_wdata_tft            ),
.ov_tft_addr             (ov_addr_tft             ),
.o_tft_addr_fix          (o_addr_fix_tft          ), 
.o_tft_rd                (o_rd_tft                ),       
.i_tft_wr                (i_wr_tft                ),
.iv_tft_raddr            (iv_raddr_tft            ),
.i_tft_addr_fix          (i_addr_fix_tft          ),
.iv_tft_rdata            (iv_rdata_tft            ),

.o_osm_wr                (o_wr_osm                ),
.ov_osm_wdata            (ov_wdata_osm            ),
.ov_osm_addr             (ov_addr_osm             ),
.o_osm_addr_fix          (o_addr_fix_osm          ), 
.o_osm_rd                (o_rd_osm                ),       
.i_osm_wr                (i_wr_osm                ),
.iv_osm_raddr            (iv_raddr_osm            ),
.i_osm_addr_fix          (i_addr_fix_osm          ),
.iv_osm_rdata            (iv_rdata_osm            ),
                         
.ov_command_tsstse_1       (ov_command_1           ),
.o_command_wr_tsstse_1     (o_command_wr_1         ),
.iv_command_ack_tsstse_1   (iv_command_ack_1       ),
.i_command_ack_wr_tsstse_1 (i_command_ack_wr_1     ),  
                            
.ov_command_tsstse_2       (ov_command_2           ),
.o_command_wr_tsstse_2     (o_command_wr_2         ),
.iv_command_ack_tsstse_2   (iv_command_ack_2       ),
.i_command_ack_wr_tsstse_2 (i_command_ack_wr_2     ), 
		                    
.ov_command_tsstse_3       (ov_command_3           ),
.o_command_wr_tsstse_3     (o_command_wr_3         ),
.iv_command_ack_tsstse_3   (iv_command_ack_3       ),
.i_command_ack_wr_tsstse_3 (i_command_ack_wr_3     )					     
);

opensync_protocol opensync_protocol_inst
(
.i_clk            (i_clk                               ),
.i_rst_n          (i_rst_n                             ),
                                                       
.iv_hcp_mac       (wv_hcp_mac_hrg2other                ),
.iv_controller_mac(wv_opensync_controller_mac_hrg2other),

.iv_data          (wv_data_tpp2osp),
.i_data_wr        (w_data_wr_tpp2osp),

.ov_data          (wv_data_osp2ttc  ),
.o_data_wr        (w_data_wr_osp2ttc)   
);

tunnel_frame_process tunnel_frame_process_inst
(
.i_clk               (i_clk                      ),
.i_rst_n             (i_rst_n                    ),

.iv_hcp_mac          (wv_hcp_mac_hrg2other       ),
.iv_controller_mac   (wv_tsnlight_controller_mac_hrg2other),

.iv_data             (wv_data_tpp2tfp            ),
.i_data_wr           (w_data_wr_tpp2tfp          ),
.i_encapsulated_flag (w_encapsulated_flag_tpp2tfp),
                                               
.ov_data             (wv_data_tfp2ttc          ),
.o_data_wr           (w_data_wr_tfp2ttc        )   
);

address_dispatch address_dispatch_inst
(
.i_clk       (i_clk             ),
.i_rst_n     (i_rst_n           ),

.iv_data     (wv_data_tpp2adi   ),
.i_data_wr   (w_data_wr_tpp2adi ),

.ov_hcp_mid  (wv_hcp_mid_adi2hrg),
.ov_tsnlight_mid(wv_tsnlight_mid_adi2hrg)
);

tsmp_transmit_control tsmp_transmit_control_inst
(
.i_clk        (i_clk   ),
.i_rst_n      (i_rst_n ),
        
.iv_data_nma  (wv_data_nma2ttc   ),
.i_data_wr_nma(w_data_wr_nma2ttc ),
              
.iv_data_osp  (wv_data_osp2ttc   ),
.i_data_wr_osp(w_data_wr_osp2ttc ),
     
.iv_data_tfp  (wv_data_tfp2ttc   ),
.i_data_wr_tfp(w_data_wr_tfp2ttc ),
      
.iv_data_pop  (9'b0   ),
.i_data_wr_pop(1'b0   ),
     
.ov_data      (wv_data_ttc2htx   ),
.o_data_wr    (w_data_wr_ttc2htx )
);  

head_and_tail_discard head_and_tail_discard_inst(
.i_clk                 (i_clk),
.i_rst_n               (i_rst_n),
.i_gmii_clk            (i_clk),
.i_gmii_rst_n          (i_rst_n),
           
.iv_data               (wv_data_ttc2htx  ),
.i_data_wr             (w_data_wr_ttc2htx),
           
.ov_gmii_txd           (wv_gmii_txd_ntx2gad),
.o_gmii_tx_en          (w_gmii_tx_en_ntx2gad),
.o_gmii_tx_er          (       ),
.o_gmii_tx_clk         (       ), 

.o_fifo_overflow_pulse ( )
);
opensync_dispatch_pit_compensate opensync_dispatch_pit_compensate_inst
(
.i_clk               (i_clk              ),
.i_rst_n             (i_rst_n            ),

.iv_syn_clk          (iv_syn_clk         ),
.iv_local_time       (iv_local_time      ),

.iv_syn_clock_cycle  (iv_syn_clock_cycle ),
.i_tsn_or_tte        (i_tsn_or_tte       ),

.iv_data             (wv_gmii_txd_ntx2gad    ),
.i_data_wr           (w_gmii_tx_en_ntx2gad   ),

.ov_data             (ov_data  ),
.o_data_wr           (o_data_wr) 
);
endmodule 