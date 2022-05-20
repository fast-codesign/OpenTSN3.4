// Copyright (C) 1953-2022 NUDT
// Verilog module name - packet_switch 
// Version: V3.4.1.20220406
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//          
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module packet_switch
(
        i_clk           ,   
        i_rst_n         ,
        
        i_data_wr       ,
        iv_data         ,
        
        o_gmii_txclk_cpu ,
        ov_gmii_txd_cpu  ,
        o_gmii_tx_en_cpu ,
        o_gmii_tx_er_cpu ,
        ov_data_hcp      ,
        o_data_wr_hcp    ,
        
        i_gmii_rxclk_cpu   ,
        i_gmii_rx_dv_cpu   ,
        iv_gmii_rxd_cpu    ,
        i_gmii_rx_er_cpu   ,
        i_data_wr_hcp   ,
        iv_data_hcp     ,
        
        ov_data         , 
        o_data_wr         
);

// I/O
// clk & rst
input                   i_clk        ;
input                   i_rst_n      ;
// tss→hcp,cpu
input                   i_data_wr    ;
input       [7:0]       iv_data      ;

output                  o_gmii_txclk_cpu;
output      [7:0]       ov_gmii_txd_cpu ;
output                  o_gmii_tx_en_cpu;
output                  o_gmii_tx_er_cpu;
output      [7:0]       ov_data_hcp  ;
output                  o_data_wr_hcp;
// hcp,cpu→tss
input                   i_gmii_rxclk_cpu ;
input                   i_gmii_rx_dv_cpu ;
input       [7:0]       iv_gmii_rxd_cpu  ;
input                   i_gmii_rx_er_cpu ;

input                   i_data_wr_hcp;
input       [7:0]       iv_data_hcp  ;

output      [7:0]       ov_data      ;
output                  o_data_wr    ;
assign    o_gmii_txclk_cpu = i_gmii_rxclk_cpu;

wire                    w_data_wr_mp2cdc;
wire        [7:0]       wv_data_mp2cdc;
wire                    w_data_wr_cdc2ps;
wire        [7:0]       wv_data_cdc2ps;
 
wire                    w_data_wr_pd2cdc;
wire        [7:0]       wv_data_pd2cdc  ;
wire                    w_data_wr_cdc2mp;
wire        [7:0]       wv_data_cdc2mp  ;     
mac_process mac_process_inst
(
        .gmii_rxclk                   (i_gmii_rxclk_cpu          ),
        .gmii_txclk                   (i_gmii_rxclk_cpu          ),
        .rst_n                        (i_rst_n              ),
                                                           
        .port_type                    (1'b0                 ),
                                                           
        .gmii_rx_dv                   (i_gmii_rx_dv_cpu       ),
        .gmii_rx_er                   (i_gmii_rx_er_cpu       ),
        .gmii_rxd                     (iv_gmii_rxd_cpu        ),

        .gmii_rx_dv_adp2tsnchip       (w_data_wr_mp2cdc   ),
        .gmii_rx_er_adp2tsnchip       (),
        .gmii_rxd_adp2tsnchip         (wv_data_mp2cdc     ),

        .gmii_tx_en_tsnchip2adp       (w_data_wr_cdc2mp   ),
        .gmii_tx_er_tsnchip2adp       (1'b0               ),
        .gmii_txd_tsnchip2adp         (wv_data_cdc2mp     ),
                                                           
        .gmii_tx_en                   (o_gmii_tx_en_cpu        ),
        .gmii_tx_er                   (o_gmii_tx_er_cpu        ),
        .gmii_txd                     (ov_gmii_txd_cpu         )
);
clock_domain_cross clock_domain_cross_cpurx_inst
(
        .i_wr_clk                 (i_gmii_rxclk_cpu      ),
        .i_wr_rst_n               (i_rst_n          ),
                                                    
        .i_rd_clk                 (i_clk            ),
        .i_rd_rst_n               (i_rst_n          ),
        
        .iv_data                  (wv_data_mp2cdc  ),
        .i_data_wr                (w_data_wr_mp2cdc),
        
        .o_fifo_overflow_pulse    (),
        
        .ov_data                  (wv_data_cdc2ps  ),
        .o_data_wr                (w_data_wr_cdc2ps)
);
pkt_select pkt_select_inst
(
        .i_clk          (i_clk          ),
        .i_rst_n        (i_rst_n        ),
        
        .i_data_wr_cpu  (w_data_wr_cdc2ps  ),
        .iv_data_cpu    (wv_data_cdc2ps    ),

        .i_data_wr_hcp  (i_data_wr_hcp  ),
        .iv_data_hcp    (iv_data_hcp    ),         

        .o_data_wr      (o_data_wr      ),
        .ov_data        (ov_data        )     
);


pkt_dispatch pkt_dispatch_inst
(
        .i_clk           (i_clk         ),
        .i_rst_n         (i_rst_n       ),

        .i_data_wr       (i_data_wr     ),
        .iv_data         (iv_data       ),  
        
        .o_data_wr_cpu   (w_data_wr_pd2cdc),
        .ov_data_cpu     (wv_data_pd2cdc  ),

        .o_data_wr_hcp   (o_data_wr_hcp ),
        .ov_data_hcp     (ov_data_hcp   )      
);
clock_domain_cross clock_domain_cross_cputx_inst
(
        .i_wr_clk                 (i_clk            ),
        .i_wr_rst_n               (i_rst_n          ),
                                                    
        .i_rd_clk                 (i_gmii_rxclk_cpu ),
        .i_rd_rst_n               (i_rst_n          ),
        
        .iv_data                  (wv_data_pd2cdc  ),
        .i_data_wr                (w_data_wr_pd2cdc),
        
        .o_fifo_overflow_pulse    (),
        
        .ov_data                  (wv_data_cdc2mp  ),
        .o_data_wr                (w_data_wr_cdc2mp)
);
endmodule