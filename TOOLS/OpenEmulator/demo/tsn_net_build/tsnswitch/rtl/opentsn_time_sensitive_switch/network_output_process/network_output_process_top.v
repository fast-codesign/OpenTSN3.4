// Copyright (C) 1953-2021 NUDT
// Verilog module name - network_output_process_top
// Version: V3.3.0.20211126
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//        switch output process for all outport
//              - number of outport: 8 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module network_output_process_top
(
        i_clk,
        i_rst_n,
        
        iv_syn_clk ,
        i_qbv_or_qch         ,
        iv_time_slot_length  ,
        iv_schedule_period   ,

        iv_addr              ,       
        iv_wdata             ,      
        i_addr_fixed         ,           
//port0           
        iv_pkt_bufid_p0      ,
        iv_pkt_type_p0       ,
        i_frag_last_p0       ,
        i_pkt_bufid_wr_p0    ,
        
        ov_pkt_bufid_p0      ,
        o_pkt_bufid_wr_p0    ,
        i_pkt_bufid_ack_p0   ,  
        
        ov_pkt_raddr_p0      ,
        o_pkt_rd_p0          ,
        i_pkt_raddr_ack_p0   ,
        
        iv_pkt_data_p0       ,
        i_pkt_data_wr_p0     ,
        
        ov_gmii_txd_p0,
        o_gmii_tx_en_p0,     

        i_wr_ctx_p0          ,   
        i_rd_ctx_p0          ,
        o_wr_ctx_p0          ,
        ov_addr_ctx_p0       ,
        o_addr_fixed_ctx_p0  ,
        ov_rdata_ctx_p0      ,
                               
        i_wr_qgc0           ,       
        i_rd_qgc0           , 
        o_wr_qgc0           ,
        ov_addr_qgc0        ,
        o_addr_fixed_qgc0   ,
        ov_rdata_qgc0       ,     

        ov_osc_state_p0,
        ov_prc_state_p0,
        ov_opc_state_p0,       
//port1
        iv_pkt_bufid_p1,
        iv_pkt_type_p1,
        i_frag_last_p1,
        i_pkt_bufid_wr_p1,
        
        ov_pkt_bufid_p1,
        o_pkt_bufid_wr_p1,
        i_pkt_bufid_ack_p1,  
        
        ov_pkt_raddr_p1,
        o_pkt_rd_p1,
        i_pkt_raddr_ack_p1,
        
        iv_pkt_data_p1,
        i_pkt_data_wr_p1,
        
        ov_gmii_txd_p1,
        o_gmii_tx_en_p1,
        
        i_wr_ctx_p1          ,   
        i_rd_ctx_p1          ,
        o_wr_ctx_p1          ,
        ov_addr_ctx_p1       ,
        o_addr_fixed_ctx_p1  ,
        ov_rdata_ctx_p1      ,
        
        i_wr_qgc1           ,       
        i_rd_qgc1           , 
        o_wr_qgc1           ,
        ov_addr_qgc1        ,
        o_addr_fixed_qgc1   ,
        ov_rdata_qgc1       ,  
        
        ov_osc_state_p1,
        ov_prc_state_p1,
        ov_opc_state_p1, 
//port2        
        iv_pkt_bufid_p2,
        iv_pkt_type_p2,
        i_frag_last_p2,
        i_pkt_bufid_wr_p2,
        
        ov_pkt_bufid_p2,
        o_pkt_bufid_wr_p2,
        i_pkt_bufid_ack_p2,  
        
        ov_pkt_raddr_p2,
        o_pkt_rd_p2,
        i_pkt_raddr_ack_p2,
        
        iv_pkt_data_p2,
        i_pkt_data_wr_p2,
        
        ov_gmii_txd_p2,
        o_gmii_tx_en_p2,
        
        i_wr_ctx_p2          ,   
        i_rd_ctx_p2          ,
        o_wr_ctx_p2          ,
        ov_addr_ctx_p2       ,
        o_addr_fixed_ctx_p2  ,
        ov_rdata_ctx_p2      ,        
       
        i_wr_qgc2           ,       
        i_rd_qgc2           , 
        o_wr_qgc2           ,
        ov_addr_qgc2        ,
        o_addr_fixed_qgc2   ,
        ov_rdata_qgc2       ,   
       
        ov_osc_state_p2,
        ov_prc_state_p2,
        ov_opc_state_p2, 
//port3         
        iv_pkt_bufid_p3,
        iv_pkt_type_p3,
        i_frag_last_p3,
        i_pkt_bufid_wr_p3,
        
        ov_pkt_bufid_p3,
        o_pkt_bufid_wr_p3,
        i_pkt_bufid_ack_p3,  
        
        ov_pkt_raddr_p3,
        o_pkt_rd_p3,
        i_pkt_raddr_ack_p3,
        
        iv_pkt_data_p3,
        i_pkt_data_wr_p3,
        
        ov_gmii_txd_p3,
        o_gmii_tx_en_p3,
        
        i_wr_ctx_p3          ,   
        i_rd_ctx_p3          ,
        o_wr_ctx_p3          ,
        ov_addr_ctx_p3       ,
        o_addr_fixed_ctx_p3  ,
        ov_rdata_ctx_p3      ,        
       
        i_wr_qgc3           ,       
        i_rd_qgc3           , 
        o_wr_qgc3           ,
        ov_addr_qgc3        ,
        o_addr_fixed_qgc3   ,
        ov_rdata_qgc3       ,  
       
        ov_osc_state_p3,
        ov_prc_state_p3,
        ov_opc_state_p3, 
//port4         
        iv_pkt_bufid_p4,
        iv_pkt_type_p4,
        i_frag_last_p4,
        i_pkt_bufid_wr_p4,
        
        ov_pkt_bufid_p4,
        o_pkt_bufid_wr_p4,
        i_pkt_bufid_ack_p4,  
        
        ov_pkt_raddr_p4,
        o_pkt_rd_p4,
        i_pkt_raddr_ack_p4,
        
        iv_pkt_data_p4,
        i_pkt_data_wr_p4,
        
        ov_gmii_txd_p4,
        o_gmii_tx_en_p4,
        
        i_wr_ctx_p4          ,   
        i_rd_ctx_p4          ,
        o_wr_ctx_p4          ,
        ov_addr_ctx_p4       ,
        o_addr_fixed_ctx_p4  ,
        ov_rdata_ctx_p4      ,        
       
        i_wr_qgc4           ,       
        i_rd_qgc4           , 
        o_wr_qgc4           ,
        ov_addr_qgc4        ,
        o_addr_fixed_qgc4   ,
        ov_rdata_qgc4       ,  
       
        ov_osc_state_p4,
        ov_prc_state_p4,
        ov_opc_state_p4, 
//port5         
        iv_pkt_bufid_p5,
        iv_pkt_type_p5,
        i_frag_last_p5,
        i_pkt_bufid_wr_p5,
        
        ov_pkt_bufid_p5,
        o_pkt_bufid_wr_p5,
        i_pkt_bufid_ack_p5,  
        
        ov_pkt_raddr_p5,
        o_pkt_rd_p5,
        i_pkt_raddr_ack_p5,
        
        iv_pkt_data_p5,
        i_pkt_data_wr_p5,
        
        ov_gmii_txd_p5,
        o_gmii_tx_en_p5,
        
        i_wr_ctx_p5          ,   
        i_rd_ctx_p5          ,
        o_wr_ctx_p5          ,
        ov_addr_ctx_p5       ,
        o_addr_fixed_ctx_p5  ,
        ov_rdata_ctx_p5      ,        
       
        i_wr_qgc5           ,       
        i_rd_qgc5           , 
        o_wr_qgc5           ,
        ov_addr_qgc5        ,
        o_addr_fixed_qgc5   ,
        ov_rdata_qgc5       ,  
       
        ov_osc_state_p5,
        ov_prc_state_p5,
        ov_opc_state_p5, 
//port6         
        iv_pkt_bufid_p6,
        iv_pkt_type_p6,
        i_frag_last_p6,
        i_pkt_bufid_wr_p6,
        
        ov_pkt_bufid_p6,
        o_pkt_bufid_wr_p6,
        i_pkt_bufid_ack_p6,  
        
        ov_pkt_raddr_p6,
        o_pkt_rd_p6,
        i_pkt_raddr_ack_p6,
        
        iv_pkt_data_p6,
        i_pkt_data_wr_p6,
        
        ov_gmii_txd_p6,
        o_gmii_tx_en_p6, 
        
        i_wr_ctx_p6          ,   
        i_rd_ctx_p6          ,
        o_wr_ctx_p6          ,
        ov_addr_ctx_p6       ,
        o_addr_fixed_ctx_p6  ,
        ov_rdata_ctx_p6      ,        
       
        i_wr_qgc6           ,       
        i_rd_qgc6           , 
        o_wr_qgc6           ,
        ov_addr_qgc6        ,
        o_addr_fixed_qgc6   ,
        ov_rdata_qgc6       ,  
       
        ov_osc_state_p6,
        ov_prc_state_p6,
        ov_opc_state_p6, 
//port7         
        iv_pkt_bufid_p7,
        iv_pkt_type_p7,
        i_frag_last_p7,
        i_pkt_bufid_wr_p7,
        
        ov_pkt_bufid_p7,
        o_pkt_bufid_wr_p7,
        i_pkt_bufid_ack_p7,  
        
        ov_pkt_raddr_p7,
        o_pkt_rd_p7,
        i_pkt_raddr_ack_p7,
        
        iv_pkt_data_p7,
        i_pkt_data_wr_p7,
        
        ov_gmii_txd_p7,
        o_gmii_tx_en_p7,
        
        i_wr_ctx_p7          ,   
        i_rd_ctx_p7          ,
        o_wr_ctx_p7          ,
        ov_addr_ctx_p7       ,
        o_addr_fixed_ctx_p7  ,
        ov_rdata_ctx_p7      ,        
       
        i_wr_qgc7           ,       
        i_rd_qgc7           , 
        o_wr_qgc7           ,
        ov_addr_qgc7        ,
        o_addr_fixed_qgc7   ,
        ov_rdata_qgc7       ,  
       
        ov_osc_state_p7,
        ov_prc_state_p7,
        ov_opc_state_p7
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;

input     [63:0]       iv_syn_clk;
input                  i_qbv_or_qch          ;
input     [10:0]       iv_time_slot_length   ;
input     [10:0]       iv_schedule_period    ;

input     [18:0]       iv_addr          ;       
input     [31:0]       iv_wdata         ;      
input                  i_addr_fixed     ; 
//port0           
input     [8:0]        iv_pkt_bufid_p0;
input     [2:0]        iv_pkt_type_p0;
input                  i_frag_last_p0;
input                  i_pkt_bufid_wr_p0;

output    [8:0]        ov_pkt_bufid_p0;
output                 o_pkt_bufid_wr_p0;
input                  i_pkt_bufid_ack_p0;  
       
output    [15:0]       ov_pkt_raddr_p0;
output                 o_pkt_rd_p0;
input                  i_pkt_raddr_ack_p0;
       
input     [133:0]      iv_pkt_data_p0;
input                  i_pkt_data_wr_p0;
       
output    [7:0]        ov_gmii_txd_p0;
output                 o_gmii_tx_en_p0;

input                  i_wr_qgc0           ;       
input                  i_rd_qgc0           ; 
output                 o_wr_qgc0           ;
output    [18:0]       ov_addr_qgc0        ;
output                 o_addr_fixed_qgc0   ;
output    [31:0]       ov_rdata_qgc0       ; 

input                  i_wr_ctx_p0         ; 
input                  i_rd_ctx_p0         ;
output                 o_wr_ctx_p0         ;
output    [18:0]       ov_addr_ctx_p0      ;
output                 o_addr_fixed_ctx_p0 ;
output    [31:0]       ov_rdata_ctx_p0     ;

output    [1:0]        ov_osc_state_p0;                 
output    [1:0]        ov_prc_state_p0;                 
output    [2:0]        ov_opc_state_p0;        
 //port1              
input     [8:0]        iv_pkt_bufid_p1;
input     [2:0]        iv_pkt_type_p1;
input                  i_frag_last_p1;
input                  i_pkt_bufid_wr_p1;

output    [8:0]        ov_pkt_bufid_p1;
output                 o_pkt_bufid_wr_p1;
input                  i_pkt_bufid_ack_p1;  
       
output    [15:0]       ov_pkt_raddr_p1;
output                 o_pkt_rd_p1;
input                  i_pkt_raddr_ack_p1;
       
input     [133:0]      iv_pkt_data_p1;
input                  i_pkt_data_wr_p1;
       
output    [7:0]        ov_gmii_txd_p1;
output                 o_gmii_tx_en_p1;

input                  i_wr_qgc1           ;       
input                  i_rd_qgc1           ; 
output                 o_wr_qgc1           ;
output    [18:0]       ov_addr_qgc1        ;
output                 o_addr_fixed_qgc1   ;
output    [31:0]       ov_rdata_qgc1       ; 

input                  i_wr_ctx_p1         ; 
input                  i_rd_ctx_p1         ;
output                 o_wr_ctx_p1         ;
output    [18:0]       ov_addr_ctx_p1      ;
output                 o_addr_fixed_ctx_p1 ;
output    [31:0]       ov_rdata_ctx_p1     ; 

output    [1:0]        ov_osc_state_p1;                 
output    [1:0]        ov_prc_state_p1;                 
output    [2:0]        ov_opc_state_p1;   
//port2           
input     [8:0]        iv_pkt_bufid_p2;
input     [2:0]        iv_pkt_type_p2;
input                  i_frag_last_p2;
input                  i_pkt_bufid_wr_p2;

output    [8:0]        ov_pkt_bufid_p2;
output                 o_pkt_bufid_wr_p2;
input                  i_pkt_bufid_ack_p2;  
       
output    [15:0]       ov_pkt_raddr_p2;
output                 o_pkt_rd_p2;
input                  i_pkt_raddr_ack_p2;
       
input     [133:0]      iv_pkt_data_p2;
input                  i_pkt_data_wr_p2;
       
output    [7:0]        ov_gmii_txd_p2;
output                 o_gmii_tx_en_p2;

input                  i_wr_qgc2           ;       
input                  i_rd_qgc2           ; 
output                 o_wr_qgc2           ;
output    [18:0]       ov_addr_qgc2        ;
output                 o_addr_fixed_qgc2   ;
output    [31:0]       ov_rdata_qgc2       ; 

input                  i_wr_ctx_p2         ; 
input                  i_rd_ctx_p2         ;
output                 o_wr_ctx_p2         ;
output    [18:0]       ov_addr_ctx_p2      ;
output                 o_addr_fixed_ctx_p2 ;
output    [31:0]       ov_rdata_ctx_p2     ; 

output    [1:0]        ov_osc_state_p2;                 
output    [1:0]        ov_prc_state_p2;                 
output    [2:0]        ov_opc_state_p2;   
//port3           
input     [8:0]        iv_pkt_bufid_p3;
input     [2:0]        iv_pkt_type_p3;
input                  i_frag_last_p3;
input                  i_pkt_bufid_wr_p3;

output    [8:0]        ov_pkt_bufid_p3;
output                 o_pkt_bufid_wr_p3;
input                  i_pkt_bufid_ack_p3;  
       
output    [15:0]       ov_pkt_raddr_p3;
output                 o_pkt_rd_p3;
input                  i_pkt_raddr_ack_p3;
       
input     [133:0]      iv_pkt_data_p3;
input                  i_pkt_data_wr_p3;
       
output    [7:0]        ov_gmii_txd_p3;
output                 o_gmii_tx_en_p3;

input                  i_wr_qgc3           ;       
input                  i_rd_qgc3           ; 
output                 o_wr_qgc3           ;
output    [18:0]       ov_addr_qgc3        ;
output                 o_addr_fixed_qgc3   ;
output    [31:0]       ov_rdata_qgc3       ;  

input                  i_wr_ctx_p3         ; 
input                  i_rd_ctx_p3         ;
output                 o_wr_ctx_p3         ;
output    [18:0]       ov_addr_ctx_p3      ;
output                 o_addr_fixed_ctx_p3 ;
output    [31:0]       ov_rdata_ctx_p3     ;

output    [1:0]        ov_osc_state_p3;                 
output    [1:0]        ov_prc_state_p3;                 
output    [2:0]        ov_opc_state_p3; 
//port4           
input     [8:0]        iv_pkt_bufid_p4;
input     [2:0]        iv_pkt_type_p4;
input                  i_frag_last_p4;
input                  i_pkt_bufid_wr_p4;

output    [8:0]        ov_pkt_bufid_p4;
output                 o_pkt_bufid_wr_p4;
input                  i_pkt_bufid_ack_p4;  
       
output    [15:0]       ov_pkt_raddr_p4;
output                 o_pkt_rd_p4;
input                  i_pkt_raddr_ack_p4;
       
input     [133:0]      iv_pkt_data_p4;
input                  i_pkt_data_wr_p4;
       
output    [7:0]        ov_gmii_txd_p4;
output                 o_gmii_tx_en_p4;

input                  i_wr_qgc4           ;       
input                  i_rd_qgc4           ; 
output                 o_wr_qgc4           ;
output    [18:0]       ov_addr_qgc4        ;
output                 o_addr_fixed_qgc4   ;
output    [31:0]       ov_rdata_qgc4       ; 

input                  i_wr_ctx_p4         ; 
input                  i_rd_ctx_p4         ;
output                 o_wr_ctx_p4         ;
output    [18:0]       ov_addr_ctx_p4      ;
output                 o_addr_fixed_ctx_p4 ;
output    [31:0]       ov_rdata_ctx_p4     ; 

output    [1:0]        ov_osc_state_p4;                 
output    [1:0]        ov_prc_state_p4;                 
output    [2:0]        ov_opc_state_p4; 
//port5           
input     [8:0]        iv_pkt_bufid_p5;
input     [2:0]        iv_pkt_type_p5;
input                  i_frag_last_p5;
input                  i_pkt_bufid_wr_p5;

output    [8:0]        ov_pkt_bufid_p5;
output                 o_pkt_bufid_wr_p5;
input                  i_pkt_bufid_ack_p5;  
       
output    [15:0]       ov_pkt_raddr_p5;
output                 o_pkt_rd_p5;
input                  i_pkt_raddr_ack_p5;
       
input     [133:0]      iv_pkt_data_p5;
input                  i_pkt_data_wr_p5;
       
output    [7:0]        ov_gmii_txd_p5;
output                 o_gmii_tx_en_p5;

input                  i_wr_qgc5           ;       
input                  i_rd_qgc5           ; 
output                 o_wr_qgc5           ;
output    [18:0]       ov_addr_qgc5        ;
output                 o_addr_fixed_qgc5   ;
output    [31:0]       ov_rdata_qgc5       ; 

input                  i_wr_ctx_p5         ; 
input                  i_rd_ctx_p5         ;
output                 o_wr_ctx_p5         ;
output    [18:0]       ov_addr_ctx_p5      ;
output                 o_addr_fixed_ctx_p5 ;
output    [31:0]       ov_rdata_ctx_p5     ; 

output    [1:0]        ov_osc_state_p5;                 
output    [1:0]        ov_prc_state_p5;                 
output    [2:0]        ov_opc_state_p5; 
//port6           
input     [8:0]        iv_pkt_bufid_p6;
input     [2:0]        iv_pkt_type_p6;
input                  i_frag_last_p6;
input                  i_pkt_bufid_wr_p6;

output    [8:0]        ov_pkt_bufid_p6;
output                 o_pkt_bufid_wr_p6;
input                  i_pkt_bufid_ack_p6;  
       
output    [15:0]       ov_pkt_raddr_p6;
output                 o_pkt_rd_p6;
input                  i_pkt_raddr_ack_p6;
       
input     [133:0]      iv_pkt_data_p6;
input                  i_pkt_data_wr_p6;
       
output    [7:0]        ov_gmii_txd_p6;
output                 o_gmii_tx_en_p6;

input                  i_wr_qgc6           ;       
input                  i_rd_qgc6           ; 
output                 o_wr_qgc6           ;
output    [18:0]       ov_addr_qgc6        ;
output                 o_addr_fixed_qgc6   ;
output    [31:0]       ov_rdata_qgc6       ;

input                  i_wr_ctx_p6         ; 
input                  i_rd_ctx_p6         ;
output                 o_wr_ctx_p6         ;
output    [18:0]       ov_addr_ctx_p6      ;
output                 o_addr_fixed_ctx_p6 ;
output    [31:0]       ov_rdata_ctx_p6     ;  

output    [1:0]        ov_osc_state_p6;                 
output    [1:0]        ov_prc_state_p6;                 
output    [2:0]        ov_opc_state_p6; 
//port7           
input     [8:0]        iv_pkt_bufid_p7;
input     [2:0]        iv_pkt_type_p7;
input                  i_frag_last_p7;
input                  i_pkt_bufid_wr_p7;

output    [8:0]        ov_pkt_bufid_p7;
output                 o_pkt_bufid_wr_p7;
input                  i_pkt_bufid_ack_p7;  
       
output    [15:0]       ov_pkt_raddr_p7;
output                 o_pkt_rd_p7;
input                  i_pkt_raddr_ack_p7;
       
input     [133:0]      iv_pkt_data_p7;
input                  i_pkt_data_wr_p7;
       
output    [7:0]        ov_gmii_txd_p7;
output                 o_gmii_tx_en_p7;

input                  i_wr_qgc7           ;       
input                  i_rd_qgc7           ; 
output                 o_wr_qgc7           ;
output    [18:0]       ov_addr_qgc7        ;
output                 o_addr_fixed_qgc7   ;
output    [31:0]       ov_rdata_qgc7       ; 

input                  i_wr_ctx_p7         ; 
input                  i_rd_ctx_p7         ;
output                 o_wr_ctx_p7         ;
output    [18:0]       ov_addr_ctx_p7      ;
output                 o_addr_fixed_ctx_p7 ;
output    [31:0]       ov_rdata_ctx_p7     ; 

output    [1:0]        ov_osc_state_p7;                 
output    [1:0]        ov_prc_state_p7;                 
output    [2:0]        ov_opc_state_p7; 
network_output_process network_output_port0_inst
(
.i_clk                  (i_clk),
.i_rst_n                (i_rst_n),

.iv_syn_clk             (iv_syn_clk),

.iv_addr                (iv_addr          ),       
.iv_wdata               (iv_wdata         ),      
.i_addr_fixed           (i_addr_fixed     ),   

.i_wr_qgc                   (i_wr_qgc0        ),       
.i_rd_qgc                   (i_rd_qgc0        ), 
.o_wr_qgc                   (o_wr_qgc0        ),
.ov_addr_qgc                (ov_addr_qgc0     ),
.o_addr_fixed_qgc           (o_addr_fixed_qgc0),
.ov_rdata_qgc               (ov_rdata_qgc0    ),

.i_wr_ntx                   (i_wr_ctx_p0           ),       
.i_rd_ntx                   (i_rd_ctx_p0           ), 
.o_wr_ntx                   (o_wr_ctx_p0           ),
.ov_addr_ntx                (ov_addr_ctx_p0        ),
.o_addr_fixed_ntx           (o_addr_fixed_ctx_p0   ),
.ov_rdata_ntx               (ov_rdata_ctx_p0       ),

.i_qbv_or_qch           (i_qbv_or_qch        ),          
.iv_time_slot_length    (iv_time_slot_length ),          
.iv_schedule_period     (iv_schedule_period  ),    
                     
.iv_pkt_bufid           (iv_pkt_bufid_p0),
.iv_pkt_type            (iv_pkt_type_p0),
.i_pkt_bufid_wr         (i_pkt_bufid_wr_p0),
                      
.ov_pkt_bufid           (ov_pkt_bufid_p0),
.o_pkt_bufid_wr         (o_pkt_bufid_wr_p0),
.i_pkt_bufid_ack        (i_pkt_bufid_ack_p0),
                     
.ov_pkt_raddr           (ov_pkt_raddr_p0),
.o_pkt_rd               (o_pkt_rd_p0),
.i_pkt_raddr_ack        (i_pkt_raddr_ack_p0),
                     
.iv_pkt_data            (iv_pkt_data_p0),
.i_pkt_data_wr          (i_pkt_data_wr_p0),
                     
.ov_gmii_txd            (ov_gmii_txd_p0),
.o_gmii_tx_en           (o_gmii_tx_en_p0),
                        
.ov_osc_state           (ov_osc_state_p0),
.ov_prc_state           (ov_prc_state_p0),
.ov_opc_state           (ov_opc_state_p0)
);  

network_output_process network_output_port1_inst
(
.i_clk                  (i_clk),
.i_rst_n                (i_rst_n),
                       
.iv_syn_clk             (iv_syn_clk),

.iv_addr                (iv_addr          ),       
.iv_wdata               (iv_wdata         ),      
.i_addr_fixed           (i_addr_fixed     ),   

.i_wr_qgc                   (i_wr_qgc1        ),       
.i_rd_qgc                   (i_rd_qgc1        ), 
.o_wr_qgc                   (o_wr_qgc1        ),
.ov_addr_qgc                (ov_addr_qgc1     ),
.o_addr_fixed_qgc           (o_addr_fixed_qgc1),
.ov_rdata_qgc               (ov_rdata_qgc1    ),

.i_wr_ntx                   (i_wr_ctx_p1           ),       
.i_rd_ntx                   (i_rd_ctx_p1           ), 
.o_wr_ntx                   (o_wr_ctx_p1           ),
.ov_addr_ntx                (ov_addr_ctx_p1        ),
.o_addr_fixed_ntx           (o_addr_fixed_ctx_p1   ),
.ov_rdata_ntx               (ov_rdata_ctx_p1       ),

.i_qbv_or_qch           (i_qbv_or_qch        ),          
.iv_time_slot_length    (iv_time_slot_length ),          
.iv_schedule_period     (iv_schedule_period  ),    
                       
.iv_pkt_bufid           (iv_pkt_bufid_p1),
.iv_pkt_type            (iv_pkt_type_p1),
.i_pkt_bufid_wr         (i_pkt_bufid_wr_p1),
                      
.ov_pkt_bufid           (ov_pkt_bufid_p1),
.o_pkt_bufid_wr         (o_pkt_bufid_wr_p1),
.i_pkt_bufid_ack        (i_pkt_bufid_ack_p1),
                     
.ov_pkt_raddr           (ov_pkt_raddr_p1),
.o_pkt_rd               (o_pkt_rd_p1),
.i_pkt_raddr_ack        (i_pkt_raddr_ack_p1),
                     
.iv_pkt_data            (iv_pkt_data_p1),
.i_pkt_data_wr          (i_pkt_data_wr_p1),
                     
.ov_gmii_txd            (ov_gmii_txd_p1),
.o_gmii_tx_en           (o_gmii_tx_en_p1),

.ov_osc_state           (ov_osc_state_p1),
.ov_prc_state           (ov_prc_state_p1),
.ov_opc_state           (ov_opc_state_p1)
); 

network_output_process network_output_port2_inst
(
.i_clk                  (i_clk),
.i_rst_n                (i_rst_n),
                       
.iv_syn_clk             (iv_syn_clk), 

.iv_addr                (iv_addr          ),       
.iv_wdata               (iv_wdata         ),      
.i_addr_fixed           (i_addr_fixed     ),   

.i_wr_qgc                   (i_wr_qgc2        ),       
.i_rd_qgc                   (i_rd_qgc2        ), 
.o_wr_qgc                   (o_wr_qgc2        ),
.ov_addr_qgc                (ov_addr_qgc2     ),
.o_addr_fixed_qgc           (o_addr_fixed_qgc2),
.ov_rdata_qgc               (ov_rdata_qgc2    ),

.i_wr_ntx                   (i_wr_ctx_p2           ),       
.i_rd_ntx                   (i_rd_ctx_p2           ), 
.o_wr_ntx                   (o_wr_ctx_p2           ),
.ov_addr_ntx                (ov_addr_ctx_p2        ),
.o_addr_fixed_ntx           (o_addr_fixed_ctx_p2   ),
.ov_rdata_ntx               (ov_rdata_ctx_p2       ),

.i_qbv_or_qch           (i_qbv_or_qch        ),          
.iv_time_slot_length    (iv_time_slot_length ),          
.iv_schedule_period     (iv_schedule_period  ),     
                      
.iv_pkt_bufid           (iv_pkt_bufid_p2),
.iv_pkt_type            (iv_pkt_type_p2),
.i_pkt_bufid_wr         (i_pkt_bufid_wr_p2),
                      
.ov_pkt_bufid           (ov_pkt_bufid_p2),
.o_pkt_bufid_wr         (o_pkt_bufid_wr_p2),
.i_pkt_bufid_ack        (i_pkt_bufid_ack_p2),
                     
.ov_pkt_raddr           (ov_pkt_raddr_p2),
.o_pkt_rd               (o_pkt_rd_p2),
.i_pkt_raddr_ack        (i_pkt_raddr_ack_p2),
                     
.iv_pkt_data            (iv_pkt_data_p2),
.i_pkt_data_wr          (i_pkt_data_wr_p2),
                     
.ov_gmii_txd            (ov_gmii_txd_p2),
.o_gmii_tx_en           (o_gmii_tx_en_p2),

.ov_osc_state           (ov_osc_state_p2),
.ov_prc_state           (ov_prc_state_p2),
.ov_opc_state           (ov_opc_state_p2)
);                                            

network_output_process network_output_port3_inst
(
.i_clk                  (i_clk            ),
.i_rst_n                (i_rst_n          ),
                      
.iv_syn_clk             (iv_syn_clk       ), 

.iv_addr                (iv_addr          ),       
.iv_wdata               (iv_wdata         ),      
.i_addr_fixed           (i_addr_fixed     ),   

.i_wr_qgc                   (i_wr_qgc3        ),       
.i_rd_qgc                   (i_rd_qgc3        ), 
.o_wr_qgc                   (o_wr_qgc3        ),
.ov_addr_qgc                (ov_addr_qgc3     ),
.o_addr_fixed_qgc           (o_addr_fixed_qgc3),
.ov_rdata_qgc               (ov_rdata_qgc3    ),

.i_wr_ntx                   (i_wr_ctx_p3           ),       
.i_rd_ntx                   (i_rd_ctx_p3           ), 
.o_wr_ntx                   (o_wr_ctx_p3           ),
.ov_addr_ntx                (ov_addr_ctx_p3        ),
.o_addr_fixed_ntx           (o_addr_fixed_ctx_p3   ),
.ov_rdata_ntx               (ov_rdata_ctx_p3       ),

.i_qbv_or_qch           (i_qbv_or_qch        ),          
.iv_time_slot_length    (iv_time_slot_length ),          
.iv_schedule_period     (iv_schedule_period  ),     
                      
.iv_pkt_bufid           (iv_pkt_bufid_p3),
.iv_pkt_type            (iv_pkt_type_p3),
.i_pkt_bufid_wr         (i_pkt_bufid_wr_p3),
                      
.ov_pkt_bufid           (ov_pkt_bufid_p3),
.o_pkt_bufid_wr         (o_pkt_bufid_wr_p3),
.i_pkt_bufid_ack        (i_pkt_bufid_ack_p3),
                     
.ov_pkt_raddr           (ov_pkt_raddr_p3),
.o_pkt_rd               (o_pkt_rd_p3),
.i_pkt_raddr_ack        (i_pkt_raddr_ack_p3),
                     
.iv_pkt_data            (iv_pkt_data_p3),
.i_pkt_data_wr          (i_pkt_data_wr_p3),
                     
.ov_gmii_txd            (ov_gmii_txd_p3),
.o_gmii_tx_en           (o_gmii_tx_en_p3),

.ov_osc_state           (ov_osc_state_p3),
.ov_prc_state           (ov_prc_state_p3),
.ov_opc_state           (ov_opc_state_p3)
); 

network_output_process network_output_port4_inst
(
.i_clk                  (i_clk),
.i_rst_n                (i_rst_n),

.iv_syn_clk   (iv_syn_clk),

.iv_addr                (iv_addr          ),       
.iv_wdata               (iv_wdata         ),      
.i_addr_fixed           (i_addr_fixed     ),   

.i_wr_qgc                   (i_wr_qgc4        ),       
.i_rd_qgc                   (i_rd_qgc4        ), 
.o_wr_qgc                   (o_wr_qgc4        ),
.ov_addr_qgc                (ov_addr_qgc4     ),
.o_addr_fixed_qgc           (o_addr_fixed_qgc4),
.ov_rdata_qgc               (ov_rdata_qgc4    ),

.i_wr_ntx                   (i_wr_ctx_p4           ),       
.i_rd_ntx                   (i_rd_ctx_p4           ), 
.o_wr_ntx                   (o_wr_ctx_p4           ),
.ov_addr_ntx                (ov_addr_ctx_p4        ),
.o_addr_fixed_ntx           (o_addr_fixed_ctx_p4   ),
.ov_rdata_ntx               (ov_rdata_ctx_p4       ),

.i_qbv_or_qch           (i_qbv_or_qch        ),          
.iv_time_slot_length    (iv_time_slot_length ),          
.iv_schedule_period     (iv_schedule_period  ),     
 
.iv_pkt_bufid           (iv_pkt_bufid_p4),
.iv_pkt_type            (iv_pkt_type_p4),
.i_pkt_bufid_wr         (i_pkt_bufid_wr_p4),
                      
.ov_pkt_bufid           (ov_pkt_bufid_p4),
.o_pkt_bufid_wr         (o_pkt_bufid_wr_p4),
.i_pkt_bufid_ack        (i_pkt_bufid_ack_p4),
                     
.ov_pkt_raddr           (ov_pkt_raddr_p4),
.o_pkt_rd               (o_pkt_rd_p4),
.i_pkt_raddr_ack        (i_pkt_raddr_ack_p4),
                     
.iv_pkt_data            (iv_pkt_data_p4),
.i_pkt_data_wr          (i_pkt_data_wr_p4),
                     
.ov_gmii_txd            (ov_gmii_txd_p4),
.o_gmii_tx_en           (o_gmii_tx_en_p4),

.ov_osc_state           (ov_osc_state_p4),
.ov_prc_state           (ov_prc_state_p4),
.ov_opc_state           (ov_opc_state_p4)
); 

network_output_process network_output_port5_inst
(
.i_clk                  (i_clk),
.i_rst_n                (i_rst_n),
                       
.iv_syn_clk   (iv_syn_clk), 

.iv_addr                (iv_addr          ),       
.iv_wdata               (iv_wdata         ),      
.i_addr_fixed           (i_addr_fixed     ),   

.i_wr_qgc                   (i_wr_qgc5        ),       
.i_rd_qgc                   (i_rd_qgc5        ), 
.o_wr_qgc                   (o_wr_qgc5        ),
.ov_addr_qgc                (ov_addr_qgc5     ),
.o_addr_fixed_qgc           (o_addr_fixed_qgc5),
.ov_rdata_qgc               (ov_rdata_qgc5    ),

.i_wr_ntx                   (i_wr_ctx_p5           ),       
.i_rd_ntx                   (i_rd_ctx_p5           ), 
.o_wr_ntx                   (o_wr_ctx_p5           ),
.ov_addr_ntx                (ov_addr_ctx_p5        ),
.o_addr_fixed_ntx           (o_addr_fixed_ctx_p5   ),
.ov_rdata_ntx               (ov_rdata_ctx_p5       ),

.i_qbv_or_qch           (i_qbv_or_qch        ),          
.iv_time_slot_length    (iv_time_slot_length ),          
.iv_schedule_period     (iv_schedule_period  ),     
                        
.iv_pkt_bufid           (iv_pkt_bufid_p5),
.iv_pkt_type            (iv_pkt_type_p5),
.i_pkt_bufid_wr         (i_pkt_bufid_wr_p5),
                      
.ov_pkt_bufid           (ov_pkt_bufid_p5),
.o_pkt_bufid_wr         (o_pkt_bufid_wr_p5),
.i_pkt_bufid_ack        (i_pkt_bufid_ack_p5),
                     
.ov_pkt_raddr           (ov_pkt_raddr_p5),
.o_pkt_rd               (o_pkt_rd_p5),
.i_pkt_raddr_ack        (i_pkt_raddr_ack_p5),
                     
.iv_pkt_data            (iv_pkt_data_p5),
.i_pkt_data_wr          (i_pkt_data_wr_p5),
                     
.ov_gmii_txd            (ov_gmii_txd_p5),
.o_gmii_tx_en           (o_gmii_tx_en_p5),

.ov_osc_state           (ov_osc_state_p5),
.ov_prc_state           (ov_prc_state_p5),
.ov_opc_state           (ov_opc_state_p5)
); 

network_output_process network_output_port6_inst
(
.i_clk                  (i_clk),
.i_rst_n                (i_rst_n),
                       
.iv_syn_clk   (iv_syn_clk), 

.iv_addr                (iv_addr          ),       
.iv_wdata               (iv_wdata         ),      
.i_addr_fixed           (i_addr_fixed     ),   

.i_wr_qgc                   (i_wr_qgc6        ),       
.i_rd_qgc                   (i_rd_qgc6        ), 
.o_wr_qgc                   (o_wr_qgc6        ),
.ov_addr_qgc                (ov_addr_qgc6     ),
.o_addr_fixed_qgc           (o_addr_fixed_qgc6),
.ov_rdata_qgc               (ov_rdata_qgc6    ),

.i_wr_ntx                   (i_wr_ctx_p6           ),       
.i_rd_ntx                   (i_rd_ctx_p6           ), 
.o_wr_ntx                   (o_wr_ctx_p6           ),
.ov_addr_ntx                (ov_addr_ctx_p6        ),
.o_addr_fixed_ntx           (o_addr_fixed_ctx_p6   ),
.ov_rdata_ntx               (ov_rdata_ctx_p6       ),

.i_qbv_or_qch           (i_qbv_or_qch        ),          
.iv_time_slot_length    (iv_time_slot_length ),          
.iv_schedule_period     (iv_schedule_period  ),      
                        
.iv_pkt_bufid           (iv_pkt_bufid_p6),
.iv_pkt_type            (iv_pkt_type_p6),
.i_pkt_bufid_wr         (i_pkt_bufid_wr_p6),
                      
.ov_pkt_bufid           (ov_pkt_bufid_p6),
.o_pkt_bufid_wr         (o_pkt_bufid_wr_p6),
.i_pkt_bufid_ack        (i_pkt_bufid_ack_p6),
                     
.ov_pkt_raddr           (ov_pkt_raddr_p6),
.o_pkt_rd               (o_pkt_rd_p6),
.i_pkt_raddr_ack        (i_pkt_raddr_ack_p6),
                     
.iv_pkt_data            (iv_pkt_data_p6),
.i_pkt_data_wr          (i_pkt_data_wr_p6),
                     
.ov_gmii_txd            (ov_gmii_txd_p6),
.o_gmii_tx_en           (o_gmii_tx_en_p6),

.ov_osc_state           (ov_osc_state_p6),
.ov_prc_state           (ov_prc_state_p6),
.ov_opc_state           (ov_opc_state_p6)
); 

network_output_process network_output_port7_inst
(
.i_clk                  (i_clk),
.i_rst_n                (i_rst_n),
                       
.iv_syn_clk   (iv_syn_clk),

.iv_addr                (iv_addr          ),       
.iv_wdata               (iv_wdata         ),      
.i_addr_fixed           (i_addr_fixed     ),   

.i_wr_qgc                   (i_wr_qgc7        ),       
.i_rd_qgc                   (i_rd_qgc7        ), 
.o_wr_qgc                   (o_wr_qgc7        ),
.ov_addr_qgc                (ov_addr_qgc7     ),
.o_addr_fixed_qgc           (o_addr_fixed_qgc7),
.ov_rdata_qgc               (ov_rdata_qgc7    ),

.i_wr_ntx                   (i_wr_ctx_p7           ),       
.i_rd_ntx                   (i_rd_ctx_p7           ), 
.o_wr_ntx                   (o_wr_ctx_p7           ),
.ov_addr_ntx                (ov_addr_ctx_p7        ),
.o_addr_fixed_ntx           (o_addr_fixed_ctx_p7   ),
.ov_rdata_ntx               (ov_rdata_ctx_p7       ),

.i_qbv_or_qch           (i_qbv_or_qch        ),          
.iv_time_slot_length    (iv_time_slot_length ),          
.iv_schedule_period     (iv_schedule_period  ),     
                          
.iv_pkt_bufid           (iv_pkt_bufid_p7),
.iv_pkt_type            (iv_pkt_type_p7),
.i_pkt_bufid_wr         (i_pkt_bufid_wr_p7),
                      
.ov_pkt_bufid           (ov_pkt_bufid_p7),
.o_pkt_bufid_wr         (o_pkt_bufid_wr_p7),
.i_pkt_bufid_ack        (i_pkt_bufid_ack_p7),
                     
.ov_pkt_raddr           (ov_pkt_raddr_p7),
.o_pkt_rd               (o_pkt_rd_p7),
.i_pkt_raddr_ack        (i_pkt_raddr_ack_p7),
                     
.iv_pkt_data            (iv_pkt_data_p7),
.i_pkt_data_wr          (i_pkt_data_wr_p7),
                     
.ov_gmii_txd            (ov_gmii_txd_p7),
.o_gmii_tx_en           (o_gmii_tx_en_p7),

.ov_osc_state           (ov_osc_state_p7),
.ov_prc_state           (ov_prc_state_p7),
.ov_opc_state           (ov_opc_state_p7)
);       
endmodule