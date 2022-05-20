// Copyright (C) 1953-2022 NUDT
// Verilog module name - opensync_1gmac
// Version: V3.4.0.20220224
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         opensync 1gmac
///////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module opensync_1gmac
(
        i_gmii_clk,
        i_gmii_rst_n,
        i_clk,
        i_rst_n,
        
        iv_syn_clk,       
        iv_local_time,
        
        i_port_type, 
        
        iv_gmii_rxd  ,
        i_gmii_rx_dv ,
        i_gmii_rx_er ,        
        ov_gmii_txd  ,
        o_gmii_tx_en ,
        o_gmii_tx_er ,
       
        i_interface_type, 
        i_tsn_or_tte,
        iv_syn_clock_cycle,        
        
        iv_data,
        i_data_wr,   
            
        ov_data,
        o_data_wr       
);

// I/O
// clk & rst
input                   i_gmii_clk    ;
input                   i_gmii_rst_n  ;

input                   i_clk         ;                   //125Mhz
input                   i_rst_n       ;

input                   i_port_type   ;

input                   i_interface_type;
input                   i_tsn_or_tte  ;
input        [31:0]     iv_syn_clock_cycle;
//input data from gmii
input        [7:0]      iv_gmii_rxd   ;
input                   i_gmii_rx_dv  ;
input                   i_gmii_rx_er  ;
//output data to swc
output       [7:0]      ov_data;
output                  o_data_wr;

input        [63:0]     iv_syn_clk;
input        [63:0]     iv_local_time;
//input data from swc
input        [7:0]      iv_data;
input                   i_data_wr;
//output data to gmii
output       [7:0]      ov_gmii_txd;
output                  o_gmii_tx_en;
output                  o_gmii_tx_er;
//rx logic
wire         [7:0]      wv_data_rmp2cdc;
wire                    w_data_wr_rmp2cdc;
wire         [7:0]      wv_data_cdc2isw;
wire                    w_data_wr_cdc2isw;
wire         [7:0]      wv_data_isw2dpc;
wire                    w_data_wr_isw2dpc;
wire         [7:0]      wv_data_isw2ope;
wire                    w_data_wr_isw2ope;
wire         [7:0]      wv_data_dpc2isw;
wire                    w_data_wr_dpc2isw;
wire         [7:0]      wv_data_ope2isw;
wire                    w_data_wr_ope2isw;
//tx logic
wire         [7:0]      wv_data_isw2rpr;
wire                    w_data_wr_isw2rpr;
wire         [7:0]      wv_data_isw2opd;
wire                    w_data_wr_isw2opd;

wire         [63:0]     wv_receive_time_opd2cfu;
wire                    w_cf_update_flag_opd2cfu;
wire         [7:0]      wv_data_opd2cfu;
wire                    w_data_wr_opd2cfu;
wire         [7:0]      wv_data_cfu2isw;
wire                    w_data_wr_cfu2isw;

wire         [7:0]      wv_data_rpr2isw;
wire                    w_data_wr_rpr2isw;

wire         [7:0]      wv_data_isw2cdc;
wire                    w_data_wr_isw2cdc;

wire         [7:0]      wv_data_cdc2tmp;
wire                    w_data_wr_cdc2tmp;

mac_process mac_process_inst
(
        .gmii_rxclk                   (i_gmii_clk          ),
        .gmii_txclk                   (i_gmii_clk          ),
        .rst_n                        (i_gmii_rst_n        ),
                                                           
        .port_type                    (i_port_type         ),
                                                           
        .gmii_rx_dv                   (i_gmii_rx_dv        ),
        .gmii_rx_er                   (i_gmii_rx_er        ),
        .gmii_rxd                     (iv_gmii_rxd         ),

        .gmii_rx_dv_adp2tsnchip       (w_data_wr_rmp2cdc   ),
        .gmii_rx_er_adp2tsnchip       (),
        .gmii_rxd_adp2tsnchip         (wv_data_rmp2cdc     ),

        .gmii_tx_en_tsnchip2adp       (w_data_wr_cdc2tmp   ),
        .gmii_tx_er_tsnchip2adp       (1'b0                ),
        .gmii_txd_tsnchip2adp         (wv_data_cdc2tmp     ),
                                                           
        .gmii_tx_en                   (o_gmii_tx_en        ),
        .gmii_tx_er                   (o_gmii_tx_er        ),
        .gmii_txd                     (ov_gmii_txd         )
);
//rx logic
clock_domain_cross clock_domain_cross_rx_inst
(
        .i_wr_clk                 (i_gmii_clk       ),
        .i_wr_rst_n               (i_gmii_rst_n     ),
                                                    
        .i_rd_clk                 (i_clk            ),
        .i_rd_rst_n               (i_rst_n          ),
        
        .iv_data                  (wv_data_rmp2cdc  ),
        .i_data_wr                (w_data_wr_rmp2cdc),
        
        .o_fifo_overflow_pulse    (),
        
        .ov_data                  (wv_data_cdc2isw  ),
        .o_data_wr                (w_data_wr_cdc2isw)
);
interface_switch_1to2 interface_switch_1to2_rx_inst
(
        .i_clk               (i_clk            ),
        .i_rst_n             (i_rst_n          ),

        .i_interface_type    (i_interface_type ),

        .iv_data             (wv_data_cdc2isw  ),
        .i_data_wr           (w_data_wr_cdc2isw),

        .ov_data_ctrl        (wv_data_isw2dpc  ),
        .o_data_wr_ctrl      (w_data_wr_isw2dpc),
        .ov_data_network     (wv_data_isw2ope  ),
        .o_data_wr_network   (w_data_wr_isw2ope)   
);
opensync_dispatch_pit_compensate opensync_dispatch_pit_compensate_inst
(
        .i_clk               (i_clk              ),
        .i_rst_n             (i_rst_n            ),
        
        .iv_syn_clk          (iv_syn_clk         ),
        .iv_local_time       (iv_local_time      ),
        
        .iv_syn_clock_cycle  (iv_syn_clock_cycle ),
        .i_tsn_or_tte        (i_tsn_or_tte       ),
        
        .iv_data             (wv_data_isw2dpc    ),
        .i_data_wr           (w_data_wr_isw2dpc  ),
        
        .ov_data             (wv_data_dpc2isw    ),
        .o_data_wr           (w_data_wr_dpc2isw  ) 
);
opensync_protocol_encapsulate opensync_protocol_encapsulate_inst
(
        .i_clk              (i_clk              ),
        .i_rst_n            (i_rst_n            ),
                            
        .iv_data            (wv_data_isw2ope    ),
        .i_data_wr          (w_data_wr_isw2ope  ),
                            
        .iv_local_time      (iv_local_time      ),       
                            
        .ov_data            (wv_data_ope2isw    ),
        .o_data_wr          (w_data_wr_ope2isw  )
);
interface_switch_2to1 interface_switch_2to1_rx_inst
(
        .i_clk               (i_clk            ),
        .i_rst_n             (i_rst_n          ),

        .i_interface_type    (i_interface_type ),

        .iv_data_ctrl        (wv_data_dpc2isw  ),
        .i_data_wr_ctrl      (w_data_wr_dpc2isw),
        .iv_data_network     (wv_data_ope2isw  ),
        .i_data_wr_network   (w_data_wr_ope2isw),        

        .ov_data             (ov_data          ),
        .o_data_wr           (o_data_wr        ) 
);
//tx logic
interface_switch_1to2 interface_switch_1to2_tx_inst
(
        .i_clk               (i_clk            ),
        .i_rst_n             (i_rst_n          ),

        .i_interface_type    (i_interface_type ),

        .iv_data             (iv_data          ),
        .i_data_wr           (i_data_wr        ),

        .ov_data_ctrl        (wv_data_isw2rpr  ),
        .o_data_wr_ctrl      (w_data_wr_isw2rpr),
        .ov_data_network     (wv_data_isw2opd  ),
        .o_data_wr_network   (w_data_wr_isw2opd)   
);
opensync_receive_pit_record opensync_receive_pit_record_inst
(
        .i_clk              (i_clk             ),
        .i_rst_n            (i_rst_n           ),
                                               
        .iv_syn_clk         (iv_syn_clk        ),
        .iv_local_time      (iv_local_time     ),
                                               
        .iv_data            (wv_data_isw2rpr   ),
        .i_data_wr          (w_data_wr_isw2rpr ),
                                               
        .ov_data            (wv_data_rpr2isw   ), 
        .o_data_wr          (w_data_wr_rpr2isw ) 
);
opensync_protocol_decapsulate opensync_protocol_decapsulate_inst
(
        .i_clk              (i_clk                   ),
        .i_rst_n            (i_rst_n                 ),
                                                     
        .iv_data            (wv_data_isw2opd         ),
        .i_data_wr          (w_data_wr_isw2opd       ),

        .ov_receive_time    (wv_receive_time_opd2cfu ),
        .o_cf_update_flag   (w_cf_update_flag_opd2cfu), 

        .ov_data            (wv_data_opd2cfu         ),
        .o_data_wr          (w_data_wr_opd2cfu       )
    );
opensync_correctionfield_update opensync_correctionfield_update_inst
(
        .i_clk              (i_clk                      ),
        .i_rst_n            (i_rst_n                    ),

        .iv_addr            (),                         
        .i_addr_fixed       (),                   
        .iv_wdata           (),                        
        .i_wr               (),         
        .i_rd               (),         

        .o_wr               (),          
        .ov_addr            (),       
        .o_addr_fixed       (),  
        .ov_rdata           (),
        
        .i_tsn_or_tte       (i_tsn_or_tte               ),

        .iv_data            (wv_data_opd2cfu            ),
        .i_data_wr          (w_data_wr_opd2cfu          ),

        .iv_receive_time    (wv_receive_time_opd2cfu    ),
        .i_cf_update_flag   (w_cf_update_flag_opd2cfu   ),       
        .iv_local_time      (iv_local_time              ),      

        .ov_data            (wv_data_cfu2isw            ),
        .o_data_wr          (w_data_wr_cfu2isw          )       
);
    
interface_switch_2to1 interface_switch_2to1_tx_inst
(
        .i_clk               (i_clk            ),
        .i_rst_n             (i_rst_n          ),

        .i_interface_type    (i_interface_type ),

        .iv_data_ctrl        (wv_data_rpr2isw  ),
        .i_data_wr_ctrl      (w_data_wr_rpr2isw),
        .iv_data_network     (wv_data_cfu2isw  ),
        .i_data_wr_network   (w_data_wr_cfu2isw),        

        .ov_data             (wv_data_isw2cdc  ),
        .o_data_wr           (w_data_wr_isw2cdc) 
);
clock_domain_cross clock_domain_cross_tx_inst
(
        .i_wr_clk                 (i_clk            ),
        .i_wr_rst_n               (i_rst_n          ),
                                                    
        .i_rd_clk                 (i_gmii_clk       ),
        .i_rd_rst_n               (i_gmii_rst_n     ),
        
        .iv_data                  (wv_data_isw2cdc  ),
        .i_data_wr                (w_data_wr_isw2cdc),
        
        .o_fifo_overflow_pulse    (),
        
        .ov_data                  (wv_data_cdc2tmp  ),
        .o_data_wr                (w_data_wr_cdc2tmp)
);
endmodule 