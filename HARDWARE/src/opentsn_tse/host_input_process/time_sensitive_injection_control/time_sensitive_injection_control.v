// Copyright (C) 1953-2021 NUDT
// Verilog module name - time_sensitive_injection_control
// Version: V3.4.0.20220405
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         map traffic transmitted by user into traffic identificated by network.
//             - monitor whether TS packet is overflow, 
//             - generate descriptor of packet, 
//             - write packet to ram,
//             - write descriptor of TS packet to ram,
//             - top module.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module time_sensitive_injection_control
(
       i_clk,
       i_rst_n,
       
       iv_addr       ,  
       iv_wdata      ,  
       i_addr_fixed  ,  
       i_wr          ,  
       i_rd          ,  
                     
       o_wr          ,  
       ov_addr       ,  
       o_addr_fixed  ,  
       ov_rdata      ,  
       
       iv_data,
       i_data_wr,                                    
                                                     
       iv_tsntag,                                    
       iv_pkt_type, 
       iv_eth_type,
       i_hit,                                        
       i_replication_flag,                           
       i_standardpkt_tsnpkt_flag,                    
       
       iv_pkt_bufid,
       i_pkt_bufid_wr,
       o_pkt_bufid_ack,
         
       iv_free_bufid_num                 ,
       iv_hpriority_be_threshold_value   ,
       iv_rc_threshold_value             ,
       iv_lpriority_be_threshold_value   ,   

       ov_wdata,
       o_data_wr,
       ov_data_waddr,
       i_wdata_ack,       
       
       iv_time_slot_period,
       iv_hardware_stage  ,
       iv_syn_clk         ,
       iv_time_slot_length,
       ov_descriptor      , 
       o_descriptor_wr    ,
       i_descriptor_ack       
);
// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;

input       [18:0]     iv_addr       ;
input       [31:0]     iv_wdata      ;
input                  i_addr_fixed  ;
input                  i_wr          ;
input                  i_rd          ;

output                 o_wr          ;
output      [18:0]     ov_addr       ;
output                 o_addr_fixed  ;
output      [31:0]     ov_rdata      ;  
// pkt input
input      [8:0]       iv_data;
input                  i_data_wr;
input                  i_standardpkt_tsnpkt_flag;
input                  i_replication_flag;
input      [47:0]      iv_tsntag;
input      [2:0]       iv_pkt_type;
input      [15:0]      iv_eth_type;
input                  i_hit;
// bufid input
input      [8:0]       iv_pkt_bufid;
input                  i_pkt_bufid_wr;
output                 o_pkt_bufid_ack;
// pkt output
output    [133:0]      ov_wdata;
output                 o_data_wr;
output    [15:0]       ov_data_waddr;
input                  i_wdata_ack;

//threshold of discard
input      [8:0]       iv_free_bufid_num               ;
input      [8:0]       iv_hpriority_be_threshold_value ;
input      [8:0]       iv_rc_threshold_value           ;
input      [8:0]       iv_lpriority_be_threshold_value ;

input      [10:0]      iv_time_slot_period ;
input      [2:0]       iv_hardware_stage   ;
input      [63:0]      iv_syn_clk          ;
input      [10:0]      iv_time_slot_length ;
output     [39:0]      ov_descriptor       ;
output                 o_descriptor_wr     ;
input                  i_descriptor_ack    ;

//
wire                   w_descriptor_valid_dge2des;
wire       [39:0]      wv_descriptor_dge2des  ;   
wire       [15:0]      wv_eth_type_dge2des    ; 
wire       [4:0]       wv_dbufid_dge2des      ;
wire                   w_descriptor_wr_to_tim ;
wire       [39:0]      wv_descriptor_to_tim   ;
wire       [4:0]       wv_dbufid_to_tim;
wire                   w_descriptor_wr_to_doc ;
wire       [39:0]      wv_descriptor_to_doc   ; 
wire                   w_pkt_bufid_wr2pwt;
wire       [39:0]      wv_descriptor_to_dop  ;
wire                   w_descriptor_wr_to_dop;
wire                   w_ts_descriptor_ack   ; 

//
wire       [8:0]       wv_data_2pwt     ;
wire                   w_data_wr_2pwt   ;
wire       [8:0]       wv_bufid_2pwt    ;

wire       [133:0]     wv_data1_trw2trr;
wire                   w_data1_write_flag_trw2trr;
wire       [133:0]     wv_data2_trw2trr;
wire                   w_data2_write_flag_trw2trr;

wire       [8:0]       wv_bufid_pwt2cbi;
wire                   w_ts_injection_addr_ack;
wire       [4:0]       wv_ts_injection_addr   ; 
wire                   w_ts_injection_addr_wr ;
                    
wire       [9:0]       wv_ram_addr_tic2ram     ;   
wire       [15:0]      wv_ram_wdata_tic2ram    ;  
wire                   w_ram_wr_tic2ram        ;   
wire       [15:0]      wv_ram_rdata_ram2tic    ;  
wire                   w_ram_rd_tic2ram        ;

time_sensitive_injection_control_cpe time_sensitive_injection_control_cpe_inst(
.i_clk                    (i_clk                ),                
.i_rst_n                  (i_rst_n              ),      
                                                
.iv_addr                  (iv_addr              ),         
.i_addr_fixed             (i_addr_fixed         ),        
.iv_wdata                 (iv_wdata             ),         
.i_wr                     (i_wr                 ),      
.i_rd                     (i_rd                 ),      
                                                
.o_wr                     (o_wr                 ),      
.ov_addr                  (ov_addr              ),      
.o_addr_fixed             (o_addr_fixed         ),      
.ov_rdata                 (ov_rdata             ),      

.ov_ram_addr              (wv_ram_addr_tic2ram  ),      
.ov_ram_wdata             (wv_ram_wdata_tic2ram ),      
.o_ram_wr                 (w_ram_wr_tic2ram     ),         
.iv_ram_rdata             (wv_ram_rdata_ram2tic ),      
.o_ram_rd                 (w_ram_rd_tic2ram     )             
);
generate_descriptor generate_descriptor_inst(
.i_clk                          (i_clk                    ),
.i_rst_n                        (i_rst_n                  ),
        
.iv_data                        (iv_data                  ),
.i_data_wr                      (i_data_wr                ),
.i_replication_flag             (i_replication_flag       ),
.iv_tsntag                      (iv_tsntag                ),
.i_standardpkt_tsnpkt_flag      (i_standardpkt_tsnpkt_flag),
.iv_eth_type                    (iv_eth_type              ),
.i_hit                          (i_hit                    ),
.iv_free_bufid_num              (iv_free_bufid_num               ),
.iv_hpriority_be_threshold_value(iv_hpriority_be_threshold_value ),
.iv_rc_threshold_value          (iv_rc_threshold_value           ),
.iv_lpriority_be_threshold_value(iv_lpriority_be_threshold_value ),

.ov_pkt_discard_cnt             (   ),
.ov_data                        (wv_data_2pwt   ),
.o_data_wr                      (w_data_wr_2pwt   ),
.o_descriptor_valid             (w_descriptor_valid_dge2des   ),
.ov_descriptor                  (wv_descriptor_dge2des        ),
.ov_dbufid                      (wv_dbufid_dge2des        ),
.ov_eth_type                    (wv_eth_type_dge2des          )
); 
descriptor_dispatch descriptor_dispatch_inst(
.i_clk                    (i_clk                ),
.i_rst_n                  (i_rst_n              ),
.iv_dbufid                (wv_dbufid_dge2des        ),
.i_descriptor_valid       (w_descriptor_valid_dge2des  ),
.iv_descriptor            (wv_descriptor_dge2des       ), 
.iv_eth_type              (wv_eth_type_dge2des         ), 
                          
.i_pkt_bufid_wr           (i_pkt_bufid_wr  ),
.iv_pkt_bufid             (iv_pkt_bufid    ),
.o_pkt_bufid_ack          (o_pkt_bufid_ack ),
                          
.o_pkt_bufid_wr           (w_pkt_bufid_wr2pwt  ),
.ov_pkt_bufid             (wv_bufid_2pwt),

.o_descriptor_wr_to_tim   (w_descriptor_wr_to_tim  ),
.ov_descriptor_to_tim     (wv_descriptor_to_tim    ),
.ov_dbufid                (wv_dbufid_to_tim        ),      
.o_descriptor_wr_to_doc   (w_descriptor_wr_to_doc  ),
.ov_descriptor_to_doc     (wv_descriptor_to_doc    )
);

pkt_width_transfer pkt_width_transfer_inst(
.i_clk              (i_clk),
.i_rst_n            (i_rst_n),

.iv_data            (wv_data_2pwt  ),
.i_data_wr          (w_data_wr_2pwt),
.i_pkt_bufid_wr     (w_pkt_bufid_wr2pwt),
.iv_bufid           (wv_bufid_2pwt ),

.ov_data1           (wv_data1_trw2trr),
.o_data1_write_flag (w_data1_write_flag_trw2trr),
.ov_data2           (wv_data2_trw2trr),
.o_data2_write_flag (w_data2_write_flag_trw2trr),  
.ov_bufid           (wv_bufid_pwt2cbi)
);  
centralized_buffer_interface centralized_buffer_interface_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

.iv_data1(wv_data1_trw2trr),
.iv_data2(wv_data2_trw2trr),
.i_data1_write_flag(w_data1_write_flag_trw2trr),
.i_data2_write_flag(w_data2_write_flag_trw2trr),
.iv_bufid(wv_bufid_pwt2cbi),

.ov_wdata     (ov_wdata     ),
.o_data_wr    (o_data_wr    ),
.ov_data_waddr(ov_data_waddr),
.i_wdata_ack  (i_wdata_ack  ),
.transmission_state(),
.ov_debug_ts_out_cnt()
);
ts_injection_schedule ts_injection_schedule_inst(
.i_clk                          (i_clk),
.i_rst_n                        (i_rst_n),
.iv_hardware_stage              (iv_hardware_stage  ),   
.iv_syn_clk                     (iv_syn_clk         ),
.iv_time_slot_length            (iv_time_slot_length),
    
.i_ts_injection_addr_ack        (w_ts_injection_addr_ack),
.ov_ts_injection_addr           (wv_ts_injection_addr   ),
.o_ts_injection_addr_wr         (w_ts_injection_addr_wr ),

.iv_injection_slot_table_wdata  (wv_ram_wdata_tic2ram),
.i_injection_slot_table_wr      (w_ram_wr_tic2ram    ),
.iv_injection_slot_table_addr   (wv_ram_addr_tic2ram ),
.ov_injection_slot_table_rdata  (wv_ram_rdata_ram2tic),
.i_injection_slot_table_rd      (w_ram_rd_tic2ram    ),
.iv_injection_slot_table_period (iv_time_slot_period) ,
.ism_state()
);
ts_injection_management ts_injection_management_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

.iv_ts_descriptor       (wv_descriptor_to_tim  ),
.i_ts_descriptor_wr     (w_descriptor_wr_to_tim),
.iv_ts_descriptor_waddr (wv_dbufid_to_tim      ),

.iv_ts_injection_addr   (wv_ts_injection_addr),
.i_ts_injection_addr_wr (w_ts_injection_addr_wr),
.o_ts_injection_addr_ack(w_ts_injection_addr_ack),

.ov_ts_descriptor        (wv_descriptor_to_dop),
.o_ts_descriptor_wr      (w_descriptor_wr_to_dop),
.i_ts_descriptor_ack     (w_ts_descriptor_ack),

.ov_ts_cnt(),
.o_ts_underflow_error_pulse(),
.tim_state()    
);      
descriptor_output descriptor_output_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
.iv_ts_descriptor   (wv_descriptor_to_dop  ),
.i_ts_descriptor_wr (w_descriptor_wr_to_dop),
.o_ts_descriptor_ack(w_ts_descriptor_ack   ),
.iv_nts_descriptor  (wv_descriptor_to_doc),
.i_nts_descriptor_wr(w_descriptor_wr_to_doc ),

.ov_descriptor      (ov_descriptor  ),
.o_descriptor_wr    (o_descriptor_wr),
.i_descriptor_ack   (i_descriptor_ack)
);


endmodule