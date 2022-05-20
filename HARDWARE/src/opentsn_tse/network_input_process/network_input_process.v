// Copyright (C) 1953-2021 NUDT
// Verilog module name - network_input_process  
// Version: V3.2.0.20210726
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         Network receive process
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module network_input_process #(parameter inport = 4'b0000,from_hcp_or_scp = 2'b01)//{scp,hcp}
    (
        i_clk,
        i_rst_n,
        
        i_gmii_rx_dv,
        iv_gmii_rxd,
        
        iv_addr             ,      
        i_addr_fixed        ,
        iv_wdata            ,
        i_wr_isc            ,
        i_rd_isc            ,
        i_wr_dex            ,
        i_rd_dex            ,
                                     
        o_wr_isc            ,
        ov_addr_isc         ,
        o_addr_fixed_isc    ,
        ov_rdata_isc        ,                                       
        o_wr_dex            ,
        ov_addr_dex         ,
        o_addr_fixed_dex    ,
        ov_rdata_dex        ,
                          
        i_rc_rxenable                   ,
        i_st_rxenable                   ,
        i_hardware_initial_finish,

        i_pkt_bufid_wr      ,
        iv_pkt_bufid        ,
        o_pkt_bufid_ack     ,

        o_descriptor_wr_to_host    ,
        o_descriptor_wr_to_hcp     ,
        o_descriptor_wr_to_network ,
        ov_descriptor              ,
        o_inverse_map_lookup_flag  ,		
        i_descriptor_ack           ,

        ov_pkt,
        o_pkt_wr,
        ov_pkt_bufadd,
        i_pkt_ack,
        
        iv_free_bufid_num,
        iv_hpriority_be_threshold_value,
        iv_rc_threshold_value,
        iv_lpriority_be_threshold_value,

        o_inpkt_pulse,          
        o_discard_pkt_pulse,
        o_fifo_underflow_pulse,
        o_fifo_overflow_pulse,
          
        o_gmii_fifo_full,           
        o_gmii_fifo_empty
    );

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
//GMII RX input
input                   i_gmii_rx_dv;
input       [7:0]       iv_gmii_rxd ;

input       [18:0]      iv_addr;                         
input                   i_addr_fixed;                   
input       [31:0]      iv_wdata;                        
input                   i_wr_isc;         
input                   i_rd_isc;         
input                   i_wr_dex;                        
input                   i_rd_dex; 

output                  o_wr_isc;          
output     [18:0]       ov_addr_isc;       
output                  o_addr_fixed_isc;  
output     [31:0]       ov_rdata_isc; 

output                  o_wr_dex;                     
output     [18:0]       ov_addr_dex;                  
output                  o_addr_fixed_dex;             
output     [31:0]       ov_rdata_dex; 
//configuration
input                   i_hardware_initial_finish;
input                   i_rc_rxenable                   ;
input                   i_st_rxenable                   ;
//pkt bufid input
input                   i_pkt_bufid_wr;
input       [8:0]       iv_pkt_bufid;
output                  o_pkt_bufid_ack;
//descriptor output
output                  o_descriptor_wr_to_host;
output                  o_descriptor_wr_to_hcp;
output                  o_descriptor_wr_to_network;
output      [56:0]      ov_descriptor;
output                  o_inverse_map_lookup_flag;
input                   i_descriptor_ack;
//user data output
output      [133:0]     ov_pkt;
output                  o_pkt_wr;
output      [15:0]      ov_pkt_bufadd;
input                   i_pkt_ack;  

input       [8:0]       iv_free_bufid_num;
input       [8:0]       iv_hpriority_be_threshold_value;
input       [8:0]       iv_rc_threshold_value;
input       [8:0]       iv_lpriority_be_threshold_value;

output                  o_inpkt_pulse;         
output                  o_discard_pkt_pulse;
output                  o_fifo_underflow_pulse;
output                  o_fifo_overflow_pulse;
    
output                  o_gmii_fifo_full;           
output                  o_gmii_fifo_empty;
// internal wire
wire        [8:0]       wv_data_isc2dex     ;
wire                    w_data_wr_isc2dex   ;
wire        [15:0]      wv_eth_type_isc2dex ;
wire                    w_standardpkt_tsnpkt_flag_isc2dex;

wire        [133:0]     wv_pkt_dex2ibi;
wire                    w_pkt_wr_dex2ibi;
wire        [8:0]       wv_pkt_bufid_dex2ibi;
wire                    w_pkt_bufid_wr_dex2ibi; 
  
  
interface_state_control interface_state_control_inst(
.i_clk                            (i_clk                          ),
.i_rst_n                          (i_rst_n                        ),

.i_rc_rxenable                    (i_rc_rxenable                    ),
.i_st_rxenable                    (i_st_rxenable                    ),
.i_hardware_initial_finish        (i_hardware_initial_finish      ),                                                          
.i_data_wr                        (i_gmii_rx_dv                   ),
.iv_data                          (iv_gmii_rxd                    ),
                                                                
.iv_addr                          (iv_addr                        ),                         
.i_addr_fixed                     (i_addr_fixed                   ),                   
.iv_wdata                         (iv_wdata                       ),                        
.i_wr_isc                         (i_wr_isc                       ),         
.i_rd_isc                         (i_rd_isc                       ),         
                                                                  
.o_wr_isc                         (o_wr_isc                       ),         
.ov_addr_isc                      (ov_addr_isc                    ),      
.o_addr_fixed_isc                 (o_addr_fixed_isc               ), 
.ov_rdata_isc                     (ov_rdata_isc                   ), 

.ov_data                          (wv_data_isc2dex                ),
.o_data_wr                        (w_data_wr_isc2dex              ),
.ov_eth_type                      (wv_eth_type_isc2dex            ),
.o_standardpkt_tsnpkt_flag        (w_standardpkt_tsnpkt_flag_isc2dex )
);    

descriptor_extract #(.inport(inport),.from_hcp_or_scp(from_hcp_or_scp)) descriptor_extract_inst(
.i_clk          (i_clk),
.i_rst_n        (i_rst_n),

.iv_addr        (iv_addr),                         
.i_addr_fixed   (i_addr_fixed),                   
.iv_wdata       (iv_wdata),                            
.i_wr_dex       (i_wr_dex),                        
.i_rd_dex       (i_rd_dex), 

.o_wr_dex       (o_wr_dex),                     
.ov_addr_dex    (ov_addr_dex),                  
.o_addr_fixed_dex(o_addr_fixed_dex),             
.ov_rdata_dex   (ov_rdata_dex), 

.iv_data        (wv_data_isc2dex),
.i_data_wr      (w_data_wr_isc2dex),
.iv_eth_type    (wv_eth_type_isc2dex),
.i_standardpkt_tsnpkt_flag(w_standardpkt_tsnpkt_flag_isc2dex),

.i_pkt_bufid_wr (i_pkt_bufid_wr),
.iv_pkt_bufid   (iv_pkt_bufid),
.o_pkt_bufid_ack(o_pkt_bufid_ack),

.ov_pkt         (wv_pkt_dex2ibi),
.o_pkt_wr       (w_pkt_wr_dex2ibi),
.o_pkt_bufid_wr (w_pkt_bufid_wr_dex2ibi),
.ov_pkt_bufid   (wv_pkt_bufid_dex2ibi),

.o_descriptor_wr_to_host    (o_descriptor_wr_to_host),
.o_descriptor_wr_to_hcp     (o_descriptor_wr_to_hcp),
.o_descriptor_wr_to_network (o_descriptor_wr_to_network),          
.ov_descriptor              (ov_descriptor),
.o_inverse_map_lookup_flag  (o_inverse_map_lookup_flag),		
.i_descriptor_ack           (i_descriptor_ack),

.iv_hardware_stage          (3'b0),
.iv_free_bufid_num               (iv_free_bufid_num      ),
.iv_hpriority_be_threshold_value (iv_hpriority_be_threshold_value ),
.iv_rc_threshold_value           (iv_rc_threshold_value           ),
.iv_lpriority_be_threshold_value (iv_lpriority_be_threshold_value )       
);

input_buffer_interface  input_buffer_interface_inst(
.i_clk          (i_clk),
.i_rst_n        (i_rst_n),
.i_pkt_wr       (w_pkt_wr_dex2ibi),
.iv_pkt         (wv_pkt_dex2ibi),
.i_pkt_bufid_wr (w_pkt_bufid_wr_dex2ibi),
.iv_pkt_bufid   (wv_pkt_bufid_dex2ibi),
.ov_pkt         (ov_pkt),
.o_pkt_wr       (o_pkt_wr),
.ov_pkt_bufadd  (ov_pkt_bufadd),
.i_pkt_ack      (i_pkt_ack),
.input_buf_interface_state(ov_input_buf_interface_state)
);
endmodule