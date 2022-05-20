// Copyright (C) 1953-2020 NUDT
// Verilog module name - network_input_process  
// Version: NIP_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         Network input process
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module network_input_process #(parameter inport = 4'b0000)
    (
        i_clk,
        i_rst_n,

        i_data_wr,
        iv_data,

        iv_addr,                          
        i_addr_fixed,                    
        iv_wdata,                         
        i_wr_irx,          
        i_rd_irx,          
        i_wr_dex,                         
        i_rd_dex,                         
        
        o_wr_irx,          
        ov_addr_irx,       
        o_addr_fixed_irx,  
        ov_rdata_irx, 

        o_wr_dex,          
        ov_addr_dex,       
        o_addr_fixed_dex,  
        ov_rdata_dex, 
        
        i_rc_rxenable                   ,
        i_st_rxenable                   ,
        i_hardware_initial_finish       ,
        iv_rc_threshold_value           ,
        iv_standardpkt_threshold_value  ,
        iv_be_threshold_value           ,

        i_pkt_bufid_wr,
        iv_pkt_bufid,
        o_pkt_bufid_ack,

        o_descriptor_wr,
        ov_descriptor,
        i_descriptor_ack,

        ov_pkt,
        o_pkt_wr,
        ov_pkt_bufadd,
        i_pkt_ack,
        
        iv_free_bufid_fifo_rdusedw,
               
        o_discard_pkt_pulse,
                
        ov_descriptor_extract_state,
        ov_descriptor_send_state,   
        ov_data_splice_state,        
        ov_input_buf_interface_state
    );

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
//GMII RX input
input                   i_data_wr;
input       [7:0]       iv_data;

input       [18:0]      iv_addr;                         
input                   i_addr_fixed;                   
input       [31:0]      iv_wdata;                        
input                   i_wr_irx;         
input                   i_rd_irx;         
input                   i_wr_dex;                        
input                   i_rd_dex; 

output                  o_wr_irx;          
output     [18:0]       ov_addr_irx;       
output                  o_addr_fixed_irx;  
output     [31:0]       ov_rdata_irx; 

output                  o_wr_dex;                     
output     [18:0]       ov_addr_dex;                  
output                  o_addr_fixed_dex;             
output     [31:0]       ov_rdata_dex; 
//configuration
input                   i_rc_rxenable                   ;
input                   i_st_rxenable                   ;
input                   i_hardware_initial_finish       ;
input      [8:0]        iv_rc_threshold_value           ;
input      [8:0]        iv_standardpkt_threshold_value  ;
input      [8:0]        iv_be_threshold_value           ;
//pkt bufid input
input                   i_pkt_bufid_wr;
input       [8:0]       iv_pkt_bufid;
output                  o_pkt_bufid_ack;
//descriptor output
output                  o_descriptor_wr;
output      [71:0]      ov_descriptor;
input                   i_descriptor_ack;
//user data output
output      [133:0]     ov_pkt;
output                  o_pkt_wr;
output      [15:0]      ov_pkt_bufadd;
input                   i_pkt_ack;  

input       [8:0]       iv_free_bufid_fifo_rdusedw;
      
output                  o_discard_pkt_pulse;

output     [3:0]        ov_descriptor_extract_state;
output     [1:0]        ov_descriptor_send_state;   
output     [1:0]        ov_data_splice_state;        
output     [1:0]        ov_input_buf_interface_state;

// internal wire
wire        [8:0]       wv_data_ffi2dex;
wire                    w_data_wr_ffi2dex;
wire        [15:0]      wv_eth_type_ffi2dex;
wire        [133:0]     pkt_dex2ibi;
wire                    pkt_wr_dex2ibi;
wire        [8:0]       pkt_bufid_dex2ibi;
wire                    pkt_bufid_wr_dex2ibi;
wire                    w_standardpkt_tsnpkt_flag_ffi2dex;

frame_filter frame_filter_inst
    (
        .i_clk                    (i_clk                            ),
        .i_rst_n                  (i_rst_n                          ),
                                                                    
        .i_data_wr                (i_data_wr                        ),
        .iv_data                  (iv_data                          ),      
                                                                    
        .iv_addr                  (iv_addr                          ),                         
        .i_addr_fixed             (i_addr_fixed                     ),                   
        .iv_wdata                 (iv_wdata                         ),                        
        .i_wr_irx                 (i_wr_irx                         ),         
        .i_rd_irx                 (i_rd_irx                         ),         
                                                                    
        .o_wr_irx                 (o_wr_irx                         ),         
        .ov_addr_irx              (ov_addr_irx                      ),      
        .o_addr_fixed_irx         (o_addr_fixed_irx                 ), 
        .ov_rdata_irx             (ov_rdata_irx                     ), 
                                                                    
        .i_rc_rxenable            (i_rc_rxenable                    ),
        .i_st_rxenable            (i_st_rxenable                    ),
        .i_hardware_initial_finish(i_hardware_initial_finish        ),
                      
        .ov_data                  (wv_data_ffi2dex                  ),
        .o_data_wr                (w_data_wr_ffi2dex                ),
        .ov_eth_type              (wv_eth_type_ffi2dex              ),
        .o_standardpkt_tsnpkt_flag(w_standardpkt_tsnpkt_flag_ffi2dex)
    );
    
descriptor_extract #(.inport(inport)) descriptor_extract_inst
    (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
       
        .iv_data(wv_data_ffi2dex),
        .i_data_wr(w_data_wr_ffi2dex),
		.i_standardpkt_tsnpkt_flag(w_standardpkt_tsnpkt_flag_ffi2dex),
        .iv_eth_type(wv_eth_type_ffi2dex),          
        .i_pkt_bufid_wr(i_pkt_bufid_wr),
        .iv_pkt_bufid(iv_pkt_bufid),
        .o_pkt_bufid_ack(o_pkt_bufid_ack),

        .iv_addr(iv_addr),                         
        .i_addr_fixed(i_addr_fixed),                   
        .iv_wdata(iv_wdata),                            
        .i_wr_dex(i_wr_dex),                        
        .i_rd_dex(i_rd_dex), 

        .o_wr_dex(o_wr_dex),                     
        .ov_addr_dex(ov_addr_dex),                  
        .o_addr_fixed_dex(o_addr_fixed_dex),             
        .ov_rdata_dex(ov_rdata_dex),  
        
        .ov_pkt(pkt_dex2ibi),
        .o_pkt_wr(pkt_wr_dex2ibi),

        .o_pkt_bufid_wr(pkt_bufid_wr_dex2ibi),
        .ov_pkt_bufid(pkt_bufid_dex2ibi),
        .o_descriptor_wr(o_descriptor_wr),
        .ov_descriptor(ov_descriptor),
        .i_descriptor_ack(i_descriptor_ack),
        
        .free_bufid_fifo_rdusedw          (iv_free_bufid_fifo_rdusedw      ),      
        .iv_rc_threshold_value            (iv_rc_threshold_value           ),
        .iv_standardpkt_threshold_value   (iv_standardpkt_threshold_value  ),
        .iv_be_threshold_value            (iv_be_threshold_value           ),

        .descriptor_extract_state(ov_descriptor_extract_state),
        .descriptor_send_state(ov_descriptor_send_state),  
        .data_splice_state(ov_data_splice_state)       
    );

input_buffer_interface  input_buffer_interface_inst
    (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        .i_pkt_wr(pkt_wr_dex2ibi),
        .iv_pkt(pkt_dex2ibi),

        .i_pkt_bufid_wr(pkt_bufid_wr_dex2ibi),
        .iv_pkt_bufid(pkt_bufid_dex2ibi),
        .ov_pkt(ov_pkt),
        .o_pkt_wr(o_pkt_wr),
        .ov_pkt_bufadd(ov_pkt_bufadd),
        .i_pkt_ack(i_pkt_ack),
        .input_buf_interface_state(ov_input_buf_interface_state)
    );
endmodule