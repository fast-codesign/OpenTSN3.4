// Copyright (C) 1953-2022 NUDT
// Verilog module name - opensync_mac
// Version: V3.4.0.20220224
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         opensync enable mac
///////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module opensync_mac
(
        i_clk,
        i_rst_n,
        
        iv_syn_clk,       
        iv_local_time,
        
        i_port_type,        
        i_interface_type, 
        iv_syn_clock_cycle, 

        i_wr,      
        iv_wdata,      
        iv_addr,
        i_addr_fixed,        
        i_rd,           
        o_wr,       
        ov_rdata,        
        ov_raddr,
        o_addr_fixed,         
        //p0
        i_gmii_clk_p0,
        i_gmii_rst_n_p0,        
        iv_gmii_rxd_p0  ,
        i_gmii_rx_dv_p0 ,
        i_gmii_rx_er_p0 ,        
        ov_gmii_txd_p0  ,
        o_gmii_tx_en_p0 ,
        o_gmii_tx_er_p0 ,    
        
        iv_data_p0,
        i_data_wr_p0,   
            
        ov_data_p0,
        o_data_wr_p0, 
        //p1
        i_gmii_clk_p1,
        i_gmii_rst_n_p1,        
        iv_gmii_rxd_p1  ,
        i_gmii_rx_dv_p1 ,
        i_gmii_rx_er_p1 ,        
        ov_gmii_txd_p1  ,
        o_gmii_tx_en_p1 ,
        o_gmii_tx_er_p1 ,    
        
        iv_data_p1,
        i_data_wr_p1,   
            
        ov_data_p1,
        o_data_wr_p1,
        //p2
        i_gmii_clk_p2,
        i_gmii_rst_n_p2,        
        iv_gmii_rxd_p2  ,
        i_gmii_rx_dv_p2 ,
        i_gmii_rx_er_p2 ,        
        ov_gmii_txd_p2  ,
        o_gmii_tx_en_p2 ,
        o_gmii_tx_er_p2 ,    
        
        iv_data_p2,
        i_data_wr_p2,   
            
        ov_data_p2,
        o_data_wr_p2, 
        //p3
        i_gmii_clk_p3,
        i_gmii_rst_n_p3,        
        iv_gmii_rxd_p3  ,
        i_gmii_rx_dv_p3 ,
        i_gmii_rx_er_p3 ,        
        ov_gmii_txd_p3  ,
        o_gmii_tx_en_p3 ,
        o_gmii_tx_er_p3 ,    
        
        iv_data_p3,
        i_data_wr_p3,   
            
        ov_data_p3,
        o_data_wr_p3,
        //p4
        i_gmii_clk_p4,
        i_gmii_rst_n_p4,        
        iv_gmii_rxd_p4  ,
        i_gmii_rx_dv_p4 ,
        i_gmii_rx_er_p4 ,        
        ov_gmii_txd_p4  ,
        o_gmii_tx_en_p4 ,
        o_gmii_tx_er_p4 ,    
        
        iv_data_p4,
        i_data_wr_p4,   
            
        ov_data_p4,
        o_data_wr_p4,  
        //p5
        i_gmii_clk_p5,
        i_gmii_rst_n_p5,        
        iv_gmii_rxd_p5  ,
        i_gmii_rx_dv_p5 ,
        i_gmii_rx_er_p5 ,        
        ov_gmii_txd_p5  ,
        o_gmii_tx_en_p5 ,
        o_gmii_tx_er_p5 ,    
        
        iv_data_p5,
        i_data_wr_p5,   
            
        ov_data_p5,
        o_data_wr_p5,   
        //p6
        i_gmii_clk_p6,
        i_gmii_rst_n_p6,        
        iv_gmii_rxd_p6  ,
        i_gmii_rx_dv_p6 ,
        i_gmii_rx_er_p6 ,        
        ov_gmii_txd_p6  ,
        o_gmii_tx_en_p6 ,
        o_gmii_tx_er_p6 ,    
        
        iv_data_p6,
        i_data_wr_p6,   
            
        ov_data_p6,
        o_data_wr_p6,
        //p7
        i_gmii_clk_p7,
        i_gmii_rst_n_p7,        
        iv_gmii_rxd_p7  ,
        i_gmii_rx_dv_p7 ,
        i_gmii_rx_er_p7 ,        
        ov_gmii_txd_p7  ,
        o_gmii_tx_en_p7 ,
        o_gmii_tx_er_p7 ,    
        
        iv_data_p7,
        i_data_wr_p7,   
            
        ov_data_p7,
        o_data_wr_p7,

        o_tsn_or_tte		
);

// I/O
input                   i_clk         ;                   //125Mhz
input                   i_rst_n       ;

input                   i_port_type   ;
input                   i_interface_type;
input        [31:0]     iv_syn_clock_cycle;

input        [63:0]     iv_syn_clk;
input        [63:0]     iv_local_time;

input                   i_wr;
input        [31:0]     iv_wdata;
input        [18:0]     iv_addr; 
input                   i_addr_fixed;      
input                   i_rd;            
output                  o_wr; 
output       [31:0]     ov_rdata;  
output       [18:0]     ov_raddr;
output                  o_addr_fixed; 
/////////////////////p0////////////////////
// clk & rst
input                   i_gmii_clk_p0    ;
input                   i_gmii_rst_n_p0  ;
//input data from gmii
input        [7:0]      iv_gmii_rxd_p0   ;
input                   i_gmii_rx_dv_p0  ;
input                   i_gmii_rx_er_p0  ;
//output data to swc
output       [7:0]      ov_data_p0;
output                  o_data_wr_p0;
//input data from swc
input        [7:0]      iv_data_p0;
input                   i_data_wr_p0;
//output data to gmii
output       [7:0]      ov_gmii_txd_p0;
output                  o_gmii_tx_en_p0;
output                  o_gmii_tx_er_p0;
/////////////////////p1////////////////////
// clk & rst
input                   i_gmii_clk_p1    ;
input                   i_gmii_rst_n_p1  ;
//input data from gmii
input        [7:0]      iv_gmii_rxd_p1   ;
input                   i_gmii_rx_dv_p1  ;
input                   i_gmii_rx_er_p1  ;
//output data to swc
output       [7:0]      ov_data_p1;
output                  o_data_wr_p1;
//input data from swc
input        [7:0]      iv_data_p1;
input                   i_data_wr_p1;
//output data to gmii
output       [7:0]      ov_gmii_txd_p1;
output                  o_gmii_tx_en_p1;
output                  o_gmii_tx_er_p1;
/////////////////////p2////////////////////
// clk & rst
input                   i_gmii_clk_p2    ;
input                   i_gmii_rst_n_p2  ;
//input data from gmii
input        [7:0]      iv_gmii_rxd_p2   ;
input                   i_gmii_rx_dv_p2  ;
input                   i_gmii_rx_er_p2  ;
//output data to swc
output       [7:0]      ov_data_p2;
output                  o_data_wr_p2;
//input data from swc
input        [7:0]      iv_data_p2;
input                   i_data_wr_p2;
//output data to gmii
output       [7:0]      ov_gmii_txd_p2;
output                  o_gmii_tx_en_p2;
output                  o_gmii_tx_er_p2;
/////////////////////p3////////////////////
// clk & rst
input                   i_gmii_clk_p3    ;
input                   i_gmii_rst_n_p3  ;
//input data from gmii
input        [7:0]      iv_gmii_rxd_p3   ;
input                   i_gmii_rx_dv_p3  ;
input                   i_gmii_rx_er_p3  ;
//output data to swc
output       [7:0]      ov_data_p3;
output                  o_data_wr_p3;
//input data from swc
input        [7:0]      iv_data_p3;
input                   i_data_wr_p3;
//output data to gmii
output       [7:0]      ov_gmii_txd_p3;
output                  o_gmii_tx_en_p3;
output                  o_gmii_tx_er_p3;
/////////////////////p4////////////////////
// clk & rst
input                   i_gmii_clk_p4    ;
input                   i_gmii_rst_n_p4  ;
//input data from gmii
input        [7:0]      iv_gmii_rxd_p4   ;
input                   i_gmii_rx_dv_p4  ;
input                   i_gmii_rx_er_p4  ;
//output data to swc
output       [7:0]      ov_data_p4;
output                  o_data_wr_p4;
//input data from swc
input        [7:0]      iv_data_p4;
input                   i_data_wr_p4;
//output data to gmii
output       [7:0]      ov_gmii_txd_p4;
output                  o_gmii_tx_en_p4;
output                  o_gmii_tx_er_p4;
/////////////////////p5////////////////////
// clk & rst
input                   i_gmii_clk_p5    ;
input                   i_gmii_rst_n_p5  ;
//input data from gmii
input        [7:0]      iv_gmii_rxd_p5   ;
input                   i_gmii_rx_dv_p5  ;
input                   i_gmii_rx_er_p5  ;
//output data to swc
output       [7:0]      ov_data_p5;
output                  o_data_wr_p5;
//input data from swc
input        [7:0]      iv_data_p5;
input                   i_data_wr_p5;
//output data to gmii
output       [7:0]      ov_gmii_txd_p5;
output                  o_gmii_tx_en_p5;
output                  o_gmii_tx_er_p5;
/////////////////////p6////////////////////
// clk & rst
input                   i_gmii_clk_p6    ;
input                   i_gmii_rst_n_p6  ;
//input data from gmii
input        [7:0]      iv_gmii_rxd_p6   ;
input                   i_gmii_rx_dv_p6  ;
input                   i_gmii_rx_er_p6  ;
//output data to swc
output       [7:0]      ov_data_p6;
output                  o_data_wr_p6;
//input data from swc
input        [7:0]      iv_data_p6;
input                   i_data_wr_p6;
//output data to gmii
output       [7:0]      ov_gmii_txd_p6;
output                  o_gmii_tx_en_p6;
output                  o_gmii_tx_er_p6;
/////////////////////p7////////////////////
// clk & rst
input                   i_gmii_clk_p7    ;
input                   i_gmii_rst_n_p7  ;
//input data from gmii
input        [7:0]      iv_gmii_rxd_p7   ;
input                   i_gmii_rx_dv_p7  ;
input                   i_gmii_rx_er_p7  ;
//output data to swc
output       [7:0]      ov_data_p7;
output                  o_data_wr_p7;
//input data from swc
input        [7:0]      iv_data_p7;
input                   i_data_wr_p7;
//output data to gmii
output       [7:0]      ov_gmii_txd_p7;
output                  o_gmii_tx_en_p7;
output                  o_gmii_tx_er_p7;

output                  o_tsn_or_tte;  
              
wire         [31:0]     wv_rxasyncfifo_overflow_cnt_mac2mpe; 
wire         [31:0]     wv_rxasyncfifo_underflow_cnt_mac2mpe;
wire         [31:0]     wv_txasyncfifo_overflow_cnt_mac2mpe; 
wire         [31:0]     wv_txasyncfifo_underflow_cnt_mac2mpe;
wire         [31:0]     wv_inpkt_cnt_p0_mac2mpe               ;             
wire         [31:0]     wv_outpkt_cnt_p0_mac2mpe              ;
wire         [31:0]     wv_inpkt_cnt_p1_mac2mpe               ;
wire         [31:0]     wv_outpkt_cnt_p1_mac2mpe              ;
wire         [31:0]     wv_inpkt_cnt_p2_mac2mpe               ;
wire         [31:0]     wv_outpkt_cnt_p2_mac2mpe              ;
wire         [31:0]     wv_inpkt_cnt_p3_mac2mpe               ;
wire         [31:0]     wv_outpkt_cnt_p3_mac2mpe              ;
wire         [31:0]     wv_inpkt_cnt_p4_mac2mpe               ;
wire         [31:0]     wv_outpkt_cnt_p4_mac2mpe              ;
wire         [31:0]     wv_inpkt_cnt_p5_mac2mpe               ;
wire         [31:0]     wv_outpkt_cnt_p5_mac2mpe              ;
wire         [31:0]     wv_inpkt_cnt_p6_mac2mpe               ;
wire         [31:0]     wv_outpkt_cnt_p6_mac2mpe              ;
wire         [31:0]     wv_inpkt_cnt_p7_mac2mpe               ;
wire         [31:0]     wv_outpkt_cnt_p7_mac2mpe              ;
mbus_parse_and_encapsulate_osm mbus_parse_and_encapsulate_osm_inst
(
.i_clk                  (i_clk),
.i_rst_n                (i_rst_n),
                       
.i_wr                   (i_wr),
.iv_wdata               (iv_wdata),
.iv_addr                (iv_addr),
.i_addr_fixed           (i_addr_fixed),       
.i_rd                   (i_rd),                            
.o_wr                   (o_wr), 
.ov_rdata               (ov_rdata),
.ov_raddr               (ov_raddr),
.o_addr_fixed           (o_addr_fixed),

.o_tsn_or_tte                  (o_tsn_or_tte                ),
.iv_rxasyncfifo_overflow_cnt   (wv_rxasyncfifo_overflow_cnt_mac2mpe ),
.iv_rxasyncfifo_underflow_cnt  (wv_rxasyncfifo_underflow_cnt_mac2mpe),
.iv_txasyncfifo_overflow_cnt   (wv_txasyncfifo_overflow_cnt_mac2mpe ),
.iv_txasyncfifo_underflow_cnt  (wv_txasyncfifo_underflow_cnt_mac2mpe),
.iv_inpkt_cnt_p0               (wv_inpkt_cnt_p0_mac2mpe             ),
.iv_outpkt_cnt_p0              (wv_outpkt_cnt_p0_mac2mpe            ),
.iv_inpkt_cnt_p1               (wv_inpkt_cnt_p1_mac2mpe             ),
.iv_outpkt_cnt_p1              (wv_outpkt_cnt_p1_mac2mpe            ),
.iv_inpkt_cnt_p2               (wv_inpkt_cnt_p2_mac2mpe             ),
.iv_outpkt_cnt_p2              (wv_outpkt_cnt_p2_mac2mpe            ),
.iv_inpkt_cnt_p3               (wv_inpkt_cnt_p3_mac2mpe             ),
.iv_outpkt_cnt_p3              (wv_outpkt_cnt_p3_mac2mpe            ),
.iv_inpkt_cnt_p4               (wv_inpkt_cnt_p4_mac2mpe             ),
.iv_outpkt_cnt_p4              (wv_outpkt_cnt_p4_mac2mpe            ),
.iv_inpkt_cnt_p5               (wv_inpkt_cnt_p5_mac2mpe             ),
.iv_outpkt_cnt_p5              (wv_outpkt_cnt_p5_mac2mpe            ),
.iv_inpkt_cnt_p6               (wv_inpkt_cnt_p6_mac2mpe             ),
.iv_outpkt_cnt_p6              (wv_outpkt_cnt_p6_mac2mpe            ),
.iv_inpkt_cnt_p7               (wv_inpkt_cnt_p7_mac2mpe             ),
.iv_outpkt_cnt_p7              (wv_outpkt_cnt_p7_mac2mpe            )  
);

opensync_1gmac opensync_1gmac_p0
(                    
.i_gmii_clk        (i_gmii_clk_p0              ),                   
.i_gmii_rst_n      (i_gmii_rst_n_p0            ),
                                               
.i_clk             (i_clk                      ),
.i_rst_n           (i_rst_n                    ),
                                               
.iv_syn_clk        (iv_syn_clk                 ),       
.iv_local_time     (iv_local_time              ),
                   
.i_port_type       (1'b0                       ),
.i_interface_type  (1'b0                       ),//network interface
.i_tsn_or_tte      (o_tsn_or_tte               ),
.iv_syn_clock_cycle(iv_syn_clock_cycle         ),
              
.i_gmii_rx_dv      (i_gmii_rx_dv_p0            ),
.i_gmii_rx_er      (i_gmii_rx_er_p0            ),
.iv_gmii_rxd       (iv_gmii_rxd_p0             ),
.o_gmii_tx_en      (o_gmii_tx_en_p0            ),
.o_gmii_tx_er      (o_gmii_tx_er_p0            ),
.ov_gmii_txd       (ov_gmii_txd_p0             ),
                                               
.i_data_wr         (i_data_wr_p0               ),
.iv_data           (iv_data_p0                 ),
.o_data_wr         (o_data_wr_p0               ),
.ov_data           (ov_data_p0                 )
);

opensync_1gmac opensync_1gmac_p1
(                    
.i_gmii_clk        (i_gmii_clk_p1              ),                   
.i_gmii_rst_n      (i_gmii_rst_n_p1            ),
                                               
.i_clk             (i_clk                      ),
.i_rst_n           (i_rst_n                    ),
                                               
.iv_syn_clk        (iv_syn_clk                 ),       
.iv_local_time     (iv_local_time              ),
                   
.i_port_type       (1'b0                       ),
.i_interface_type  (1'b0                       ),//network interface
.i_tsn_or_tte      (o_tsn_or_tte               ),
.iv_syn_clock_cycle(iv_syn_clock_cycle         ),
              
.i_gmii_rx_dv      (i_gmii_rx_dv_p1            ),
.i_gmii_rx_er      (i_gmii_rx_er_p1            ),
.iv_gmii_rxd       (iv_gmii_rxd_p1             ),
.o_gmii_tx_en      (o_gmii_tx_en_p1            ),
.o_gmii_tx_er      (o_gmii_tx_er_p1            ),
.ov_gmii_txd       (ov_gmii_txd_p1             ),
                                               
.i_data_wr         (i_data_wr_p1               ),
.iv_data           (iv_data_p1                 ),
.o_data_wr         (o_data_wr_p1               ),
.ov_data           (ov_data_p1                 )
);

opensync_1gmac opensync_1gmac_p2
(                    
.i_gmii_clk        (i_gmii_clk_p2              ),                   
.i_gmii_rst_n      (i_gmii_rst_n_p2            ),
                                               
.i_clk             (i_clk                      ),
.i_rst_n           (i_rst_n                    ),
                                               
.iv_syn_clk        (iv_syn_clk                 ),       
.iv_local_time     (iv_local_time              ),
                   
.i_port_type       (1'b0                       ),
.i_interface_type  (1'b0                       ),//network interface
.i_tsn_or_tte      (o_tsn_or_tte               ),
.iv_syn_clock_cycle(iv_syn_clock_cycle         ),
              
.i_gmii_rx_dv      (i_gmii_rx_dv_p2            ),
.i_gmii_rx_er      (i_gmii_rx_er_p2            ),
.iv_gmii_rxd       (iv_gmii_rxd_p2             ),
.o_gmii_tx_en      (o_gmii_tx_en_p2            ),
.o_gmii_tx_er      (o_gmii_tx_er_p2            ),
.ov_gmii_txd       (ov_gmii_txd_p2             ),
                                               
.i_data_wr         (i_data_wr_p2               ),
.iv_data           (iv_data_p2                 ),
.o_data_wr         (o_data_wr_p2               ),
.ov_data           (ov_data_p2                 )
);

opensync_1gmac opensync_1gmac_p3
(                    
.i_gmii_clk        (i_gmii_clk_p3              ),                   
.i_gmii_rst_n      (i_gmii_rst_n_p3            ),
                                               
.i_clk             (i_clk                      ),
.i_rst_n           (i_rst_n                    ),
                                               
.iv_syn_clk        (iv_syn_clk                 ),       
.iv_local_time     (iv_local_time              ),
                   
.i_port_type       (1'b0                       ),
.i_interface_type  (1'b0                       ),//network interface
.i_tsn_or_tte      (o_tsn_or_tte               ),
.iv_syn_clock_cycle(iv_syn_clock_cycle         ),
              
.i_gmii_rx_dv      (i_gmii_rx_dv_p3            ),
.i_gmii_rx_er      (i_gmii_rx_er_p3            ),
.iv_gmii_rxd       (iv_gmii_rxd_p3             ),
.o_gmii_tx_en      (o_gmii_tx_en_p3            ),
.o_gmii_tx_er      (o_gmii_tx_er_p3            ),
.ov_gmii_txd       (ov_gmii_txd_p3             ),
                                               
.i_data_wr         (i_data_wr_p3               ),
.iv_data           (iv_data_p3                 ),
.o_data_wr         (o_data_wr_p3               ),
.ov_data           (ov_data_p3                 )
);

opensync_1gmac opensync_1gmac_p4
(                    
.i_gmii_clk        (i_gmii_clk_p4              ),                   
.i_gmii_rst_n      (i_gmii_rst_n_p4            ),
                                               
.i_clk             (i_clk                      ),
.i_rst_n           (i_rst_n                    ),
                                               
.iv_syn_clk        (iv_syn_clk                 ),       
.iv_local_time     (iv_local_time              ),
                   
.i_port_type       (1'b0                       ),
.i_interface_type  (1'b0                       ),//network interface
.i_tsn_or_tte      (o_tsn_or_tte               ),
.iv_syn_clock_cycle(iv_syn_clock_cycle         ),
              
.i_gmii_rx_dv      (i_gmii_rx_dv_p4            ),
.i_gmii_rx_er      (i_gmii_rx_er_p4            ),
.iv_gmii_rxd       (iv_gmii_rxd_p4             ),
.o_gmii_tx_en      (o_gmii_tx_en_p4            ),
.o_gmii_tx_er      (o_gmii_tx_er_p4            ),
.ov_gmii_txd       (ov_gmii_txd_p4             ),
                                               
.i_data_wr         (i_data_wr_p4               ),
.iv_data           (iv_data_p4                 ),
.o_data_wr         (o_data_wr_p4               ),
.ov_data           (ov_data_p4                 )
);

opensync_1gmac opensync_1gmac_p5
(                    
.i_gmii_clk        (i_gmii_clk_p5              ),                   
.i_gmii_rst_n      (i_gmii_rst_n_p5            ),
                                               
.i_clk             (i_clk                      ),
.i_rst_n           (i_rst_n                    ),
                                               
.iv_syn_clk        (iv_syn_clk                 ),       
.iv_local_time     (iv_local_time              ),
                   
.i_port_type       (1'b0                       ),
.i_interface_type  (1'b0                       ),//network interface
.i_tsn_or_tte      (o_tsn_or_tte               ),
.iv_syn_clock_cycle(iv_syn_clock_cycle         ),
              
.i_gmii_rx_dv      (i_gmii_rx_dv_p5            ),
.i_gmii_rx_er      (i_gmii_rx_er_p5            ),
.iv_gmii_rxd       (iv_gmii_rxd_p5             ),
.o_gmii_tx_en      (o_gmii_tx_en_p5            ),
.o_gmii_tx_er      (o_gmii_tx_er_p5            ),
.ov_gmii_txd       (ov_gmii_txd_p5             ),
                                               
.i_data_wr         (i_data_wr_p5               ),
.iv_data           (iv_data_p5                 ),
.o_data_wr         (o_data_wr_p5               ),
.ov_data           (ov_data_p5                 )
);

opensync_1gmac opensync_1gmac_p6
(                    
.i_gmii_clk        (i_gmii_clk_p6              ),                   
.i_gmii_rst_n      (i_gmii_rst_n_p6            ),
                                               
.i_clk             (i_clk                      ),
.i_rst_n           (i_rst_n                    ),
                                               
.iv_syn_clk        (iv_syn_clk                 ),       
.iv_local_time     (iv_local_time              ),
                   
.i_port_type       (1'b0                       ),
.i_interface_type  (1'b0                       ),//network interface
.i_tsn_or_tte      (o_tsn_or_tte               ),
.iv_syn_clock_cycle(iv_syn_clock_cycle         ),
              
.i_gmii_rx_dv      (i_gmii_rx_dv_p6            ),
.i_gmii_rx_er      (i_gmii_rx_er_p6            ),
.iv_gmii_rxd       (iv_gmii_rxd_p6             ),
.o_gmii_tx_en      (o_gmii_tx_en_p6            ),
.o_gmii_tx_er      (o_gmii_tx_er_p6            ),
.ov_gmii_txd       (ov_gmii_txd_p6             ),
                                               
.i_data_wr         (i_data_wr_p6               ),
.iv_data           (iv_data_p6                 ),
.o_data_wr         (o_data_wr_p6               ),
.ov_data           (ov_data_p6                 )
);

opensync_1gmac opensync_1gmac_p7
(                    
.i_gmii_clk        (i_gmii_clk_p7              ),                   
.i_gmii_rst_n      (i_gmii_rst_n_p7            ),
                                               
.i_clk             (i_clk                      ),
.i_rst_n           (i_rst_n                    ),
                                               
.iv_syn_clk        (iv_syn_clk                 ),       
.iv_local_time     (iv_local_time              ),
                   
.i_port_type       (1'b0                       ),
.i_interface_type  (1'b0                       ),//network interface
.i_tsn_or_tte      (o_tsn_or_tte               ),
.iv_syn_clock_cycle(iv_syn_clock_cycle         ),
              
.i_gmii_rx_dv      (i_gmii_rx_dv_p7            ),
.i_gmii_rx_er      (i_gmii_rx_er_p7            ),
.iv_gmii_rxd       (iv_gmii_rxd_p7             ),
.o_gmii_tx_en      (o_gmii_tx_en_p7            ),
.o_gmii_tx_er      (o_gmii_tx_er_p7            ),
.ov_gmii_txd       (ov_gmii_txd_p7             ),
                                               
.i_data_wr         (i_data_wr_p7               ),
.iv_data           (iv_data_p7                 ),
.o_data_wr         (o_data_wr_p7               ),
.ov_data           (ov_data_p7                 )
);

endmodule 