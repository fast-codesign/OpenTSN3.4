// Copyright (C) 1953-2021 NUDT
// Verilog module name - network_output_process_top
// Version: V3.3.0.2021130
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//        switch output process for all outport
//              - number of outport: 2 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module network_output_process_top
(
       i_clk                ,
       i_rst_n              ,
       
       i_qbv_or_qch         ,
       iv_time_slot_length  ,
       iv_schedule_period   ,
       iv_syn_clk           ,
       
       iv_addr              ,      
       iv_wdata             ,
       i_addr_fixed         ,
                      
       i_wr_qgc0             ,
       i_rd_qgc0             ,
       o_wr_qgc0             ,
       ov_addr_qgc0          ,
       o_addr_fixed_qgc0     ,
       ov_rdata_qgc0         ,
       
       i_wr_qgc1             ,
       i_rd_qgc1             ,
       o_wr_qgc1             ,
       ov_addr_qgc1          ,
       o_addr_fixed_qgc1     ,
       ov_rdata_qgc1         ,
       
       iv_tsntag_host2p0     ,
       iv_pkt_type_host2p0   ,
       iv_bufid_host2p0      ,
       i_descriptor_wr_host2p0 ,
       o_descriptor_ack_p02host,
       
       iv_tsntag_network2p0    ,
       iv_pkt_type_network2p0  ,
       iv_bufid_network2p0     ,
       i_descriptor_wr_network2p0 ,
       o_descriptor_ack_p02network,   

       ov_pkt_bufid_p0,
       o_pkt_bufid_wr_p0,
       i_pkt_bufid_ack_p0,  
       
       ov_pkt_raddr_p0,
       o_pkt_rd_p0,
       i_pkt_raddr_ack_p0,
       
       iv_pkt_data_p0,
       i_pkt_data_wr_p0,
       
       o_port0_outpkt_pulse, 
       
       ov_gmii_txd_p0,
       o_gmii_tx_en_p0,    
//port1      
       iv_tsntag_host2p1,
       iv_pkt_type_host2p1,
       iv_bufid_host2p1,
       i_descriptor_wr_host2p1,
       o_descriptor_ack_p12host,
       
       iv_tsntag_network2p1,
       iv_pkt_type_network2p1,
       iv_bufid_network2p1,
       i_descriptor_wr_network2p1,
       o_descriptor_ack_p12network,    

       ov_pkt_bufid_p1,
       o_pkt_bufid_wr_p1,
       i_pkt_bufid_ack_p1,  
       
       ov_pkt_raddr_p1,
       o_pkt_rd_p1,
       i_pkt_raddr_ack_p1,
       
       iv_pkt_data_p1,
       i_pkt_data_wr_p1,
       
       o_port1_outpkt_pulse,
       
       ov_gmii_txd_p1,
       o_gmii_tx_en_p1  
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;

input          [63:0]  iv_syn_clk;
input                  i_qbv_or_qch        ;
input          [10:0]  iv_time_slot_length ;
input          [10:0]  iv_schedule_period  ;

input          [18:0]  iv_addr             ;       
input          [31:0]  iv_wdata            ;      
input                  i_addr_fixed        ;   
                                        
input                  i_wr_qgc0             ;       
input                  i_rd_qgc0             ; 
output                 o_wr_qgc0             ;
output         [18:0]  ov_addr_qgc0          ;
output                 o_addr_fixed_qgc0     ;
output         [31:0]  ov_rdata_qgc0         ;

input                  i_wr_qgc1             ;       
input                  i_rd_qgc1             ; 
output                 o_wr_qgc1             ;
output         [18:0]  ov_addr_qgc1          ;
output                 o_addr_fixed_qgc1     ;
output         [31:0]  ov_rdata_qgc1         ;

//port0           
//tsntag & bufid input from host_port
input          [47:0]  iv_tsntag_host2p0;
input          [2:0]   iv_pkt_type_host2p0;
input          [8:0]   iv_bufid_host2p0;
input                  i_descriptor_wr_host2p0;
output                 o_descriptor_ack_p02host;
//tsntag & bufid input from hcp_port
input          [47:0]  iv_tsntag_network2p0;
input          [2:0]   iv_pkt_type_network2p0;
input          [8:0]   iv_bufid_network2p0;
input                  i_descriptor_wr_network2p0;
output                 o_descriptor_ack_p02network;

output         [8:0]   ov_pkt_bufid_p0;
output                 o_pkt_bufid_wr_p0;
input                  i_pkt_bufid_ack_p0;  
       
output         [15:0]  ov_pkt_raddr_p0;
output                 o_pkt_rd_p0;
input                  i_pkt_raddr_ack_p0;
       
input          [133:0] iv_pkt_data_p0;
input                  i_pkt_data_wr_p0;

output                 o_port0_outpkt_pulse;
      
output         [7:0]   ov_gmii_txd_p0;
output                 o_gmii_tx_en_p0;   
 //port1  
//tsntag & bufid input from host_port
input          [47:0]  iv_tsntag_host2p1;
input          [2:0]   iv_pkt_type_host2p1;
input          [8:0]   iv_bufid_host2p1;
input                  i_descriptor_wr_host2p1;
output                 o_descriptor_ack_p12host;
//tsntag & bufid input from hcp_port
input          [47:0]  iv_tsntag_network2p1;
input          [2:0]   iv_pkt_type_network2p1;
input          [8:0]   iv_bufid_network2p1;
input                  i_descriptor_wr_network2p1;
output                 o_descriptor_ack_p12network;

output         [8:0]   ov_pkt_bufid_p1;
output                 o_pkt_bufid_wr_p1;
input                  i_pkt_bufid_ack_p1;  
       
output         [15:0]  ov_pkt_raddr_p1;
output                 o_pkt_rd_p1;
input                  i_pkt_raddr_ack_p1;
       
input          [133:0] iv_pkt_data_p1;
input                  i_pkt_data_wr_p1;

output                 o_port1_outpkt_pulse;
       
output         [7:0]   ov_gmii_txd_p1;
output                 o_gmii_tx_en_p1;


network_output_process network_output_process_connect_with_hcp(
.i_clk                     (i_clk                       ),
.i_rst_n                   (i_rst_n                     ),
                                                                                                                                   
.iv_syn_clk                (iv_syn_clk                  ),
                                                                  
.iv_addr                   (iv_addr                     ),    
.iv_wdata                  (iv_wdata                    ),   
.i_addr_fixed              (i_addr_fixed                ),
                                                        
.i_wr                      (1'b0                        ),       
.i_rd                      (1'b0                        ), 
.o_wr                      (                            ),
.ov_addr                   (                            ),
.o_addr_fixed              (                            ),
.ov_rdata                  (                            ), 
                           
.i_qbv_or_qch              (i_qbv_or_qch                ),
.iv_time_slot_length       (iv_time_slot_length         ),
.iv_schedule_period        (iv_schedule_period          ),
                           
.iv_tsntag_host            (iv_tsntag_host2p0           ),
.iv_pkt_type_host          (iv_pkt_type_host2p0         ),
.iv_bufid_host             (iv_bufid_host2p0            ),
.i_descriptor_wr_host      (i_descriptor_wr_host2p0     ),
.o_descriptor_ack_host     (o_descriptor_ack_p02host    ),
                           
.iv_tsntag_network         (iv_tsntag_network2p0        ),
.iv_pkt_type_network       (iv_pkt_type_network2p0      ),
.iv_bufid_network          (iv_bufid_network2p0         ),
.i_descriptor_wr_network   (i_descriptor_wr_network2p0  ),
.o_descriptor_ack_network  (o_descriptor_ack_p02network ),
                           
.ov_pkt_bufid              (ov_pkt_bufid_p0             ),
.o_pkt_bufid_wr            (o_pkt_bufid_wr_p0           ),
.i_pkt_bufid_ack           (i_pkt_bufid_ack_p0          ),
                           
.ov_pkt_raddr              (ov_pkt_raddr_p0             ),
.o_pkt_rd                  (o_pkt_rd_p0                 ),
.i_pkt_raddr_ack           (i_pkt_raddr_ack_p0          ),
                           
.iv_pkt_data               (iv_pkt_data_p0              ),
.i_pkt_data_wr             (i_pkt_data_wr_p0            ),
                           
.o_pkt_output_pulse        (o_port0_outpkt_pulse        ),

.o_ts_underflow_error_pulse(                            ),
.o_ts_overflow_error_pulse (                            ), 
       
.ov_gmii_txd               (ov_gmii_txd_p0              ),
.o_gmii_tx_en              (o_gmii_tx_en_p0             )
);  
network_output_process network_output_process_connect_with_network(
.i_clk                           (i_clk                         ),
.i_rst_n                         (i_rst_n                       ),
                                                                
.iv_syn_clk                      (iv_syn_clk          ),
                                                                
.iv_addr                         (iv_addr                       ),    
.iv_wdata                        (iv_wdata                      ),   
.i_addr_fixed                    (i_addr_fixed                  ),
                                                                
.i_wr                            (i_wr_qgc1                     ),       
.i_rd                            (i_rd_qgc1                     ), 
.o_wr                            (o_wr_qgc1                     ),
.ov_addr                         (ov_addr_qgc1                  ),
.o_addr_fixed                    (o_addr_fixed_qgc1             ),
.ov_rdata                        (ov_rdata_qgc1                 ),

.i_qbv_or_qch                    (i_qbv_or_qch                  ),
.iv_time_slot_length             (iv_time_slot_length           ),
.iv_schedule_period              (iv_schedule_period            ),   
                                 
.iv_tsntag_host                  (iv_tsntag_host2p1             ),
.iv_pkt_type_host                (iv_pkt_type_host2p1           ),
.iv_bufid_host                   (iv_bufid_host2p1              ),
.i_descriptor_wr_host            (i_descriptor_wr_host2p1       ),
.o_descriptor_ack_host           (o_descriptor_ack_p12host      ),
                                 
.iv_tsntag_network               (iv_tsntag_network2p1          ),
.iv_pkt_type_network             (iv_pkt_type_network2p1        ),
.iv_bufid_network                (iv_bufid_network2p1           ),
.i_descriptor_wr_network         (i_descriptor_wr_network2p1    ),
.o_descriptor_ack_network        (o_descriptor_ack_p12network   ),
                                 
.ov_pkt_bufid                    (ov_pkt_bufid_p1               ),
.o_pkt_bufid_wr                  (o_pkt_bufid_wr_p1             ),
.i_pkt_bufid_ack                 (i_pkt_bufid_ack_p1            ),
                                 
.ov_pkt_raddr                    (ov_pkt_raddr_p1               ),
.o_pkt_rd                        (o_pkt_rd_p1                   ),
.i_pkt_raddr_ack                 (i_pkt_raddr_ack_p1            ),
                                 
.iv_pkt_data                     (iv_pkt_data_p1                ),
.i_pkt_data_wr                   (i_pkt_data_wr_p1              ),
                                 
.o_pkt_output_pulse              (o_port1_outpkt_pulse          ),

.o_ts_underflow_error_pulse      (                              ),
.o_ts_overflow_error_pulse       (                              ), 
       
.ov_gmii_txd                     (ov_gmii_txd_p1                ),
.o_gmii_tx_en                    (o_gmii_tx_en_p1               )
);  
endmodule