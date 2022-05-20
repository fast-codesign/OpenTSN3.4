// Copyright (C) 1953-2022 NUDT
// Verilog module name - network_input_process_top  
// Version: V3.4.0.20220225
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         Network input process top module
//         include 3 GMII network interface
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module network_input_process_top  
    (
        i_clk,
        i_rst_n,          
        //network interface port 1 GMII RX signal
        i_gmii_dv_p0,
        iv_gmii_rxd_p0,
        //network interface port 2 GMII RX signal       
        i_gmii_dv_p1,
        iv_gmii_rxd_p1,
        //network interface port 3 GMII RX signal       
        i_gmii_dv_p2,
        iv_gmii_rxd_p2,
        // //network interface port 4 GMII RX signal        
        i_gmii_dv_p3,
        iv_gmii_rxd_p3,     
        //network interface port 5 GMII RX signal        
        i_gmii_dv_p4,
        iv_gmii_rxd_p4,
        //network interface port 6 GMII RX signal        
        i_gmii_dv_p5,
        iv_gmii_rxd_p5,
        //network interface port 7 GMII RX signal        
        i_gmii_dv_p6,
        iv_gmii_rxd_p6,
        //network interface port 8 GMII RX signal
        i_gmii_dv_p7,
        iv_gmii_rxd_p7,

        i_gmii_dv_p8,
        iv_gmii_rxd_p8,

        iv_addr,                          
        i_addr_fixed,                    
        iv_wdata,
        
        i_wr_ffi_p8          ,                 
        i_rd_ffi_p8          ,               
        o_wr_ffi_p8          ,
        ov_addr_ffi_p8       ,
        o_addr_fixed_ffi_p8  ,
        ov_rdata_ffi_p8      ,
        
        i_wr_dex_p8          ,     
        i_rd_dex_p8          ,
        o_wr_dex_p8          ,
        ov_addr_dex_p8       ,
        o_addr_fixed_dex_p8  ,
        ov_rdata_dex_p8      ,

        i_wr_ffi_p0          ,    
        i_rd_ffi_p0          ,    
        o_wr_ffi_p0          ,    
        ov_addr_ffi_p0       ,    
        o_addr_fixed_ffi_p0  ,    
        ov_rdata_ffi_p0      ,    
                        
        i_wr_dex_p0          ,    
        i_rd_dex_p0          ,    
        o_wr_dex_p0          ,    
        ov_addr_dex_p0       ,    
        o_addr_fixed_dex_p0  ,    
        ov_rdata_dex_p0      ,    
                   
        i_wr_ffi_p1          ,    
        i_rd_ffi_p1          ,    
        o_wr_ffi_p1          ,    
        ov_addr_ffi_p1       ,    
        o_addr_fixed_ffi_p1  ,    
        ov_rdata_ffi_p1      ,    
                    
        i_wr_dex_p1          ,    
        i_rd_dex_p1          ,    
        o_wr_dex_p1          ,    
        ov_addr_dex_p1       ,    
        o_addr_fixed_dex_p1  ,    
        ov_rdata_dex_p1      ,    
                   
        i_wr_ffi_p2          ,    
        i_rd_ffi_p2          ,    
        o_wr_ffi_p2          ,    
        ov_addr_ffi_p2       ,    
        o_addr_fixed_ffi_p2  ,    
        ov_rdata_ffi_p2      ,    
                   
        i_wr_dex_p2          ,    
        i_rd_dex_p2          ,    
        o_wr_dex_p2          ,    
        ov_addr_dex_p2       ,    
        o_addr_fixed_dex_p2  ,    
        ov_rdata_dex_p2      ,    
                   
        i_wr_ffi_p3          ,    
        i_rd_ffi_p3          ,    
        o_wr_ffi_p3          ,    
        ov_addr_ffi_p3       ,    
        o_addr_fixed_ffi_p3  ,    
        ov_rdata_ffi_p3      ,    
                    
        i_wr_dex_p3          ,    
        i_rd_dex_p3          ,    
        o_wr_dex_p3          ,    
        ov_addr_dex_p3       ,    
        o_addr_fixed_dex_p3  ,    
        ov_rdata_dex_p3      ,    
                    
        i_wr_ffi_p4          ,    
        i_rd_ffi_p4          ,    
        o_wr_ffi_p4          ,    
        ov_addr_ffi_p4       ,    
        o_addr_fixed_ffi_p4  ,    
        ov_rdata_ffi_p4      ,    
                   
        i_wr_dex_p4          ,    
        i_rd_dex_p4          ,    
        o_wr_dex_p4          ,    
        ov_addr_dex_p4       ,    
        o_addr_fixed_dex_p4  ,    
        ov_rdata_dex_p4      ,    
                    
        i_wr_ffi_p5          ,    
        i_rd_ffi_p5          ,    
        o_wr_ffi_p5          ,    
        ov_addr_ffi_p5       ,    
        o_addr_fixed_ffi_p5  ,    
        ov_rdata_ffi_p5      ,    
                    
        i_wr_dex_p5          ,    
        i_rd_dex_p5          ,    
        o_wr_dex_p5          ,    
        ov_addr_dex_p5       ,    
        o_addr_fixed_dex_p5  ,    
        ov_rdata_dex_p5      ,    
                     
        i_wr_ffi_p6          ,    
        i_rd_ffi_p6          ,    
        o_wr_ffi_p6          ,    
        ov_addr_ffi_p6       ,    
        o_addr_fixed_ffi_p6  ,    
        ov_rdata_ffi_p6      ,    
                     
        i_wr_dex_p6          ,    
        i_rd_dex_p6          ,    
        o_wr_dex_p6          ,    
        ov_addr_dex_p6       ,    
        o_addr_fixed_dex_p6  ,    
        ov_rdata_dex_p6      ,    
                      
        i_wr_ffi_p7          ,    
        i_rd_ffi_p7          ,    
        o_wr_ffi_p7          ,    
        ov_addr_ffi_p7       ,    
        o_addr_fixed_ffi_p7  ,    
        ov_rdata_ffi_p7      ,    
                        
        i_wr_dex_p7          ,    
        i_rd_dex_p7          ,    
        o_wr_dex_p7          ,    
        ov_addr_dex_p7       ,    
        o_addr_fixed_dex_p7  ,    
        ov_rdata_dex_p7      ,            
        //configuration of receiving pkt type.00:receive NMAC pkt;01:receive NMAC/PTP pkt;10:receive all pkt.
        i_rc_rxenable        ,  
        i_st_rxenable        ,
        i_hardware_initial_finish,        
        iv_be_threshold_value    ,          
        iv_rc_threshold_value    ,          
        iv_standardpkt_threshold_value , 
        //network interface port 1 receive pkt buffer id signal 
        i_pkt_bufid_wr_p0        ,
        iv_pkt_bufid_p0          ,
        o_pkt_bufid_ack_p0       ,
        //network interface port 2 receive pkt buffer id signal         
        i_pkt_bufid_wr_p1,
        iv_pkt_bufid_p1,
        o_pkt_bufid_ack_p1,
        //network interface port 3 receive pkt buffer id signal         
        i_pkt_bufid_wr_p2,
        iv_pkt_bufid_p2,
        o_pkt_bufid_ack_p2,
        //network interface port 4 receive pkt buffer id signal     
        i_pkt_bufid_wr_p3,
        iv_pkt_bufid_p3,
        o_pkt_bufid_ack_p3,
        //network interface port 5 receive pkt buffer id signal         
        i_pkt_bufid_wr_p4,
        iv_pkt_bufid_p4,
        o_pkt_bufid_ack_p4,
        //network interface port 6 receive pkt buffer id signal         
        i_pkt_bufid_wr_p5,
        iv_pkt_bufid_p5,
        o_pkt_bufid_ack_p5,
        //network interface port 7 receive pkt buffer id signal     
        i_pkt_bufid_wr_p6,
        iv_pkt_bufid_p6,
        o_pkt_bufid_ack_p6,
        //network interface port 8 receive pkt buffer id signal         
        i_pkt_bufid_wr_p7,
        iv_pkt_bufid_p7,
        o_pkt_bufid_ack_p7,
        
        i_pkt_bufid_wr_p8,
        iv_pkt_bufid_p8,
        o_pkt_bufid_ack_p8,
        //network interface port 1 send descriptor signal
        o_descriptor_wr_p0,
        ov_descriptor_p0,
        i_descriptor_ack_p0,
        //network interface port 2 send descriptor signal           
        o_descriptor_wr_p1,
        ov_descriptor_p1,
        i_descriptor_ack_p1,
        //network interface port 3 send descriptor signal           
        o_descriptor_wr_p2,
        ov_descriptor_p2,
        i_descriptor_ack_p2,
        //network interface port 4 send descriptor signal
        o_descriptor_wr_p3,
        ov_descriptor_p3,
        i_descriptor_ack_p3,
        //network interface port 5 send descriptor signal           
        o_descriptor_wr_p4,
        ov_descriptor_p4,
        i_descriptor_ack_p4,
        //network interface port 6 send descriptor signal           
        o_descriptor_wr_p5,
        ov_descriptor_p5,
        i_descriptor_ack_p5,
        //network interface port 7 send descriptor signal
        o_descriptor_wr_p6,
        ov_descriptor_p6,
        i_descriptor_ack_p6,
        //network interface port 8 send descriptor signal           
        o_descriptor_wr_p7,
        ov_descriptor_p7,
        i_descriptor_ack_p7,
        
        o_descriptor_wr_p8,
        ov_descriptor_p8,
        i_descriptor_ack_p8,        
        //network interface port 1 send 134bits pkt signal
        ov_pkt_p0,
        o_pkt_wr_p0,
        ov_pkt_bufadd_p0,
        i_pkt_ack_p0,
        //network interface port 2 send 134bits pkt signal
        ov_pkt_p1,
        o_pkt_wr_p1,
        ov_pkt_bufadd_p1,
        i_pkt_ack_p1,
        //network interface port 3 send 134bits pkt signal
        ov_pkt_p2,
        o_pkt_wr_p2,
        ov_pkt_bufadd_p2,
        i_pkt_ack_p2,
        //network interface port 4 send 134bits pkt signal
        ov_pkt_p3,
        o_pkt_wr_p3,
        ov_pkt_bufadd_p3,
        i_pkt_ack_p3,
        //network interface port 5 send 134bits pkt signal
        ov_pkt_p4,
        o_pkt_wr_p4,
        ov_pkt_bufadd_p4,
        i_pkt_ack_p4,
        //network interface port 6 send 134bits pkt signal
        ov_pkt_p5,
        o_pkt_wr_p5,
        ov_pkt_bufadd_p5,
        i_pkt_ack_p5,
        //network interface port 7 send 134bits pkt signal
        ov_pkt_p6,
        o_pkt_wr_p6,
        ov_pkt_bufadd_p6,
        i_pkt_ack_p6,
        //network interface port 8 send 134bits pkt signal
        ov_pkt_p7,
        o_pkt_wr_p7,
        ov_pkt_bufadd_p7,
        i_pkt_ack_p7,
        
        ov_pkt_p8,
        o_pkt_wr_p8,
        ov_pkt_bufadd_p8,
        i_pkt_ack_p8,

        iv_free_bufid_fifo_rdusedw,
        
        ov_descriptor_extract_state_p0, 
        ov_descriptor_send_state_p0,    
        ov_data_splice_state_p0,        
        ov_input_buf_interface_state_p0,
        
        ov_descriptor_extract_state_p1, 
        ov_descriptor_send_state_p1,    
        ov_data_splice_state_p1,        
        ov_input_buf_interface_state_p1,
         
        ov_descriptor_extract_state_p2, 
        ov_descriptor_send_state_p2,    
        ov_data_splice_state_p2,        
        ov_input_buf_interface_state_p2,
        
        ov_descriptor_extract_state_p3, 
        ov_descriptor_send_state_p3,    
        ov_data_splice_state_p3,        
        ov_input_buf_interface_state_p3,
         
        ov_descriptor_extract_state_p4, 
        ov_descriptor_send_state_p4,    
        ov_data_splice_state_p4,        
        ov_input_buf_interface_state_p4,
       
        ov_descriptor_extract_state_p5, 
        ov_descriptor_send_state_p5,    
        ov_data_splice_state_p5,        
        ov_input_buf_interface_state_p5,
       
        ov_descriptor_extract_state_p6, 
        ov_descriptor_send_state_p6,    
        ov_data_splice_state_p6,        
        ov_input_buf_interface_state_p6,
        
        ov_descriptor_extract_state_p7, 
        ov_descriptor_send_state_p7,    
        ov_data_splice_state_p7,        
        ov_input_buf_interface_state_p7,
        
        ov_descriptor_extract_state_p8, 
        ov_descriptor_send_state_p8,    
        ov_data_splice_state_p8,        
        ov_input_buf_interface_state_p8
   
    );
// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
//GMII RX input
input                   i_gmii_dv_p0;
input       [7:0]       iv_gmii_rxd_p0;
input                   i_gmii_dv_p1;
input       [7:0]       iv_gmii_rxd_p1;
input                   i_gmii_dv_p2;
input       [7:0]       iv_gmii_rxd_p2;
input                   i_gmii_dv_p3;
input       [7:0]       iv_gmii_rxd_p3;
input                   i_gmii_dv_p4;
input       [7:0]       iv_gmii_rxd_p4;
input                   i_gmii_dv_p5;
input       [7:0]       iv_gmii_rxd_p5;
input                   i_gmii_dv_p6;
input       [7:0]       iv_gmii_rxd_p6;
input                   i_gmii_dv_p7;
input       [7:0]       iv_gmii_rxd_p7;
input                   i_gmii_dv_p8;
input       [7:0]       iv_gmii_rxd_p8;

input       [18:0]      iv_addr;                         
input                   i_addr_fixed;                   
input       [31:0]      iv_wdata;

input                   i_wr_ffi_p8         ;   
input                   i_rd_ffi_p8         ; 
output                  o_wr_ffi_p8         ; 
output     [18:0]       ov_addr_ffi_p8      ; 
output                  o_addr_fixed_ffi_p8 ; 
output     [31:0]       ov_rdata_ffi_p8     ; 
         
input                   i_wr_dex_p8         ; 
input                   i_rd_dex_p8         ; 
output                  o_wr_dex_p8         ; 
output     [18:0]       ov_addr_dex_p8      ; 
output                  o_addr_fixed_dex_p8 ; 
output     [31:0]       ov_rdata_dex_p8     ; 
          
input                   i_wr_ffi_p0         ; 
input                   i_rd_ffi_p0         ; 
output                  o_wr_ffi_p0         ; 
output     [18:0]       ov_addr_ffi_p0      ; 
output                  o_addr_fixed_ffi_p0 ; 
output     [31:0]       ov_rdata_ffi_p0     ; 
          
input                   i_wr_dex_p0         ; 
input                   i_rd_dex_p0         ; 
output                  o_wr_dex_p0         ; 
output     [18:0]       ov_addr_dex_p0      ; 
output                  o_addr_fixed_dex_p0 ; 
output     [31:0]       ov_rdata_dex_p0     ; 
           
input                   i_wr_ffi_p1         ; 
input                   i_rd_ffi_p1         ; 
output                  o_wr_ffi_p1         ; 
output     [18:0]       ov_addr_ffi_p1      ; 
output                  o_addr_fixed_ffi_p1 ; 
output     [31:0]       ov_rdata_ffi_p1     ; 
           
input                   i_wr_dex_p1         ; 
input                   i_rd_dex_p1         ; 
output                  o_wr_dex_p1         ; 
output     [18:0]       ov_addr_dex_p1      ; 
output                  o_addr_fixed_dex_p1 ; 
output     [31:0]       ov_rdata_dex_p1     ; 
          
input                   i_wr_ffi_p2         ; 
input                   i_rd_ffi_p2         ; 
output                  o_wr_ffi_p2         ; 
output     [18:0]       ov_addr_ffi_p2      ; 
output                  o_addr_fixed_ffi_p2 ; 
output     [31:0]       ov_rdata_ffi_p2     ; 
           
input                   i_wr_dex_p2         ; 
input                   i_rd_dex_p2         ; 
output                  o_wr_dex_p2         ; 
output     [18:0]       ov_addr_dex_p2      ; 
output                  o_addr_fixed_dex_p2 ; 
output     [31:0]       ov_rdata_dex_p2     ; 
          
input                   i_wr_ffi_p3         ; 
input                   i_rd_ffi_p3         ; 
output                  o_wr_ffi_p3         ; 
output     [18:0]       ov_addr_ffi_p3      ; 
output                  o_addr_fixed_ffi_p3 ; 
output     [31:0]       ov_rdata_ffi_p3     ; 
          
input                   i_wr_dex_p3         ; 
input                   i_rd_dex_p3         ; 
output                  o_wr_dex_p3         ; 
output     [18:0]       ov_addr_dex_p3      ; 
output                  o_addr_fixed_dex_p3 ; 
output     [31:0]       ov_rdata_dex_p3     ; 
        
input                   i_wr_ffi_p4         ; 
input                   i_rd_ffi_p4         ; 
output                  o_wr_ffi_p4         ; 
output     [18:0]       ov_addr_ffi_p4      ; 
output                  o_addr_fixed_ffi_p4 ; 
output     [31:0]       ov_rdata_ffi_p4     ; 
           
input                   i_wr_dex_p4         ; 
input                   i_rd_dex_p4         ; 
output                  o_wr_dex_p4         ; 
output     [18:0]       ov_addr_dex_p4      ; 
output                  o_addr_fixed_dex_p4 ; 
output     [31:0]       ov_rdata_dex_p4     ; 
            
input                   i_wr_ffi_p5         ; 
input                   i_rd_ffi_p5         ; 
output                  o_wr_ffi_p5         ; 
output     [18:0]       ov_addr_ffi_p5      ; 
output                  o_addr_fixed_ffi_p5 ; 
output     [31:0]       ov_rdata_ffi_p5     ; 
            
input                   i_wr_dex_p5         ; 
input                   i_rd_dex_p5         ; 
output                  o_wr_dex_p5         ; 
output     [18:0]       ov_addr_dex_p5      ; 
output                  o_addr_fixed_dex_p5 ; 
output     [31:0]       ov_rdata_dex_p5     ; 
            
input                   i_wr_ffi_p6         ; 
input                   i_rd_ffi_p6         ; 
output                  o_wr_ffi_p6         ; 
output     [18:0]       ov_addr_ffi_p6      ; 
output                  o_addr_fixed_ffi_p6 ; 
output     [31:0]       ov_rdata_ffi_p6     ; 
            
input                   i_wr_dex_p6         ; 
input                   i_rd_dex_p6         ; 
output                  o_wr_dex_p6         ; 
output     [18:0]       ov_addr_dex_p6      ; 
output                  o_addr_fixed_dex_p6 ; 
output     [31:0]       ov_rdata_dex_p6     ; 
             
input                   i_wr_ffi_p7         ; 
input                   i_rd_ffi_p7         ; 
output                  o_wr_ffi_p7         ; 
output     [18:0]       ov_addr_ffi_p7      ; 
output                  o_addr_fixed_ffi_p7 ; 
output     [31:0]       ov_rdata_ffi_p7     ; 
               
input                   i_wr_dex_p7         ; 
input                   i_rd_dex_p7         ; 
output                  o_wr_dex_p7         ; 
output     [18:0]       ov_addr_dex_p7      ; 
output                  o_addr_fixed_dex_p7 ; 
output     [31:0]       ov_rdata_dex_p7     ; 

input                   i_rc_rxenable                   ;
input                   i_st_rxenable                   ;
input                   i_hardware_initial_finish       ;
input      [8:0]        iv_be_threshold_value           ; 
input      [8:0]        iv_rc_threshold_value           ;
input      [8:0]        iv_standardpkt_threshold_value  ;
//pkt bufid input
input                   i_pkt_bufid_wr_p0;
input       [8:0]       iv_pkt_bufid_p0;
output                  o_pkt_bufid_ack_p0;
input                   i_pkt_bufid_wr_p1;
input       [8:0]       iv_pkt_bufid_p1;
output                  o_pkt_bufid_ack_p1;
input                   i_pkt_bufid_wr_p2;
input       [8:0]       iv_pkt_bufid_p2;
output                  o_pkt_bufid_ack_p2;
input                   i_pkt_bufid_wr_p3;
input       [8:0]       iv_pkt_bufid_p3;
output                  o_pkt_bufid_ack_p3;
input                   i_pkt_bufid_wr_p4;
input       [8:0]       iv_pkt_bufid_p4;
output                  o_pkt_bufid_ack_p4;
input                   i_pkt_bufid_wr_p5;
input       [8:0]       iv_pkt_bufid_p5;
output                  o_pkt_bufid_ack_p5;
input                   i_pkt_bufid_wr_p6;
input       [8:0]       iv_pkt_bufid_p6;
output                  o_pkt_bufid_ack_p6;
input                   i_pkt_bufid_wr_p7;
input       [8:0]       iv_pkt_bufid_p7;
output                  o_pkt_bufid_ack_p7;
input                   i_pkt_bufid_wr_p8;
input       [8:0]       iv_pkt_bufid_p8;
output                  o_pkt_bufid_ack_p8;
//descriptor output
output                  o_descriptor_wr_p0;
output      [71:0]      ov_descriptor_p0;
input                   i_descriptor_ack_p0;
output                  o_descriptor_wr_p1;
output      [71:0]      ov_descriptor_p1;
input                   i_descriptor_ack_p1;
output                  o_descriptor_wr_p2;
output      [71:0]      ov_descriptor_p2;
input                   i_descriptor_ack_p2;
output                  o_descriptor_wr_p3;
output      [71:0]      ov_descriptor_p3;
input                   i_descriptor_ack_p3;
output                  o_descriptor_wr_p4;
output      [71:0]      ov_descriptor_p4;
input                   i_descriptor_ack_p4;
output                  o_descriptor_wr_p5;
output      [71:0]      ov_descriptor_p5;
input                   i_descriptor_ack_p5;
output                  o_descriptor_wr_p6;
output      [71:0]      ov_descriptor_p6;
input                   i_descriptor_ack_p6;
output                  o_descriptor_wr_p7;
output      [71:0]      ov_descriptor_p7;
input                   i_descriptor_ack_p7;
output                  o_descriptor_wr_p8;
output      [71:0]      ov_descriptor_p8;
input                   i_descriptor_ack_p8;
//user data output
output      [133:0]     ov_pkt_p0;
output                  o_pkt_wr_p0;
output      [15:0]      ov_pkt_bufadd_p0;
input                   i_pkt_ack_p0; 
output      [133:0]     ov_pkt_p1;
output                  o_pkt_wr_p1;
output      [15:0]      ov_pkt_bufadd_p1;
input                   i_pkt_ack_p1; 
output      [133:0]     ov_pkt_p2;
output                  o_pkt_wr_p2;
output      [15:0]      ov_pkt_bufadd_p2;
input                   i_pkt_ack_p2; 
output      [133:0]     ov_pkt_p3;
output                  o_pkt_wr_p3;
output      [15:0]      ov_pkt_bufadd_p3;
input                   i_pkt_ack_p3; 
output      [133:0]     ov_pkt_p4;
output                  o_pkt_wr_p4;
output      [15:0]      ov_pkt_bufadd_p4;
input                   i_pkt_ack_p4; 
output      [133:0]     ov_pkt_p5;
output                  o_pkt_wr_p5;
output      [15:0]      ov_pkt_bufadd_p5;
input                   i_pkt_ack_p5; 
output      [133:0]     ov_pkt_p6;
output                  o_pkt_wr_p6;
output      [15:0]      ov_pkt_bufadd_p6;
input                   i_pkt_ack_p6; 
output      [133:0]     ov_pkt_p7;
output                  o_pkt_wr_p7;
output      [15:0]      ov_pkt_bufadd_p7;
input                   i_pkt_ack_p7; 
output      [133:0]     ov_pkt_p8;
output                  o_pkt_wr_p8;
output      [15:0]      ov_pkt_bufadd_p8;
input                   i_pkt_ack_p8; 

input       [8:0]       iv_free_bufid_fifo_rdusedw;

output     [3:0]        ov_descriptor_extract_state_p0; 
output     [1:0]        ov_descriptor_send_state_p0;    
output     [1:0]        ov_data_splice_state_p0;        
output     [1:0]        ov_input_buf_interface_state_p0;
         
output     [3:0]        ov_descriptor_extract_state_p1; 
output     [1:0]        ov_descriptor_send_state_p1;    
output     [1:0]        ov_data_splice_state_p1;        
output     [1:0]        ov_input_buf_interface_state_p1;
        
output     [3:0]        ov_descriptor_extract_state_p2; 
output     [1:0]        ov_descriptor_send_state_p2;    
output     [1:0]        ov_data_splice_state_p2;        
output     [1:0]        ov_input_buf_interface_state_p2;
         
output     [3:0]        ov_descriptor_extract_state_p3; 
output     [1:0]        ov_descriptor_send_state_p3;    
output     [1:0]        ov_data_splice_state_p3;        
output     [1:0]        ov_input_buf_interface_state_p3;
        
output     [3:0]        ov_descriptor_extract_state_p4; 
output     [1:0]        ov_descriptor_send_state_p4;    
output     [1:0]        ov_data_splice_state_p4;        
output     [1:0]        ov_input_buf_interface_state_p4;
       
output     [3:0]        ov_descriptor_extract_state_p5; 
output     [1:0]        ov_descriptor_send_state_p5;    
output     [1:0]        ov_data_splice_state_p5;        
output     [1:0]        ov_input_buf_interface_state_p5;
      
output     [3:0]        ov_descriptor_extract_state_p6; 
output     [1:0]        ov_descriptor_send_state_p6;    
output     [1:0]        ov_data_splice_state_p6;        
output     [1:0]        ov_input_buf_interface_state_p6;
        
output     [3:0]        ov_descriptor_extract_state_p7; 
output     [1:0]        ov_descriptor_send_state_p7;    
output     [1:0]        ov_data_splice_state_p7;        
output     [1:0]        ov_input_buf_interface_state_p7;
        
output     [3:0]        ov_descriptor_extract_state_p8; 
output     [1:0]        ov_descriptor_send_state_p8;    
output     [1:0]        ov_data_splice_state_p8;        
output     [1:0]        ov_input_buf_interface_state_p8;
network_input_process #(.inport(4'b0000)) network_input_process_inst0
    (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),
        
        .i_data_wr(i_gmii_dv_p0),
        .iv_data(iv_gmii_rxd_p0),

        .iv_addr(iv_addr),                         
        .i_addr_fixed(i_addr_fixed),                   
        .iv_wdata(iv_wdata), 
        
        .i_wr_irx(i_wr_ffi_p0),         
        .i_rd_irx(i_rd_ffi_p0),          
        .o_wr_irx(o_wr_ffi_p0),         
        .ov_addr_irx(ov_addr_ffi_p0),      
        .o_addr_fixed_irx(o_addr_fixed_ffi_p0), 
        .ov_rdata_irx(ov_rdata_ffi_p0), 

        .i_wr_dex(i_wr_dex_p0),                        
        .i_rd_dex(i_rd_dex_p0),
        .o_wr_dex(o_wr_dex_p0),                     
        .ov_addr_dex(ov_addr_dex_p0),                  
        .o_addr_fixed_dex(o_addr_fixed_dex_p0),             
        .ov_rdata_dex(ov_rdata_dex_p0),                 

        .i_rc_rxenable                   (i_rc_rxenable                 ),
        .i_st_rxenable                   (i_st_rxenable                 ),
        .i_hardware_initial_finish       (i_hardware_initial_finish     ),
        .iv_rc_threshold_value           (iv_rc_threshold_value         ),
        .iv_be_threshold_value           (iv_be_threshold_value         ),
        .iv_standardpkt_threshold_value  (iv_standardpkt_threshold_value),
        
        .i_pkt_bufid_wr(i_pkt_bufid_wr_p0),
        .iv_pkt_bufid(iv_pkt_bufid_p0),
        .o_pkt_bufid_ack(o_pkt_bufid_ack_p0),

        .o_descriptor_wr(o_descriptor_wr_p0),
        .ov_descriptor(ov_descriptor_p0),
        .i_descriptor_ack(i_descriptor_ack_p0),

        .ov_pkt(ov_pkt_p0),
        .o_pkt_wr(o_pkt_wr_p0),
        .ov_pkt_bufadd(ov_pkt_bufadd_p0),
        .i_pkt_ack(i_pkt_ack_p0),
        
        .iv_free_bufid_fifo_rdusedw(iv_free_bufid_fifo_rdusedw),
         
        .ov_descriptor_extract_state(ov_descriptor_extract_state_p0), 
        .ov_descriptor_send_state(ov_descriptor_send_state_p0),    
        .ov_data_splice_state(ov_data_splice_state_p0),        
        .ov_input_buf_interface_state(ov_input_buf_interface_state_p0)  
    );
    
network_input_process #(.inport(4'b0001)) network_input_process_inst1
    (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),

        .i_data_wr(i_gmii_dv_p1),
        .iv_data(iv_gmii_rxd_p1),

        .iv_addr(iv_addr),                         
        .i_addr_fixed(i_addr_fixed),                   
        .iv_wdata(iv_wdata), 
        
        .i_wr_irx(i_wr_ffi_p1),         
        .i_rd_irx(i_rd_ffi_p1),          
        .o_wr_irx(o_wr_ffi_p1),         
        .ov_addr_irx(ov_addr_ffi_p1),      
        .o_addr_fixed_irx(o_addr_fixed_ffi_p1), 
        .ov_rdata_irx(ov_rdata_ffi_p1), 

        .i_wr_dex(i_wr_dex_p1),                        
        .i_rd_dex(i_rd_dex_p1),
        .o_wr_dex(o_wr_dex_p1),                     
        .ov_addr_dex(ov_addr_dex_p1),                  
        .o_addr_fixed_dex(o_addr_fixed_dex_p1),             
        .ov_rdata_dex(ov_rdata_dex_p1), 
        
        .i_rc_rxenable                   (i_rc_rxenable                 ),
        .i_st_rxenable                   (i_st_rxenable                 ),                
        .i_hardware_initial_finish       (i_hardware_initial_finish     ),
        .iv_rc_threshold_value           (iv_rc_threshold_value         ),
        .iv_be_threshold_value           (iv_be_threshold_value         ),
        .iv_standardpkt_threshold_value  (iv_standardpkt_threshold_value),    
        
        .i_pkt_bufid_wr(i_pkt_bufid_wr_p1),
        .iv_pkt_bufid(iv_pkt_bufid_p1),
        .o_pkt_bufid_ack(o_pkt_bufid_ack_p1),

        .o_descriptor_wr(o_descriptor_wr_p1),
        .ov_descriptor(ov_descriptor_p1),
        .i_descriptor_ack(i_descriptor_ack_p1),

        .ov_pkt(ov_pkt_p1),
        .o_pkt_wr(o_pkt_wr_p1),
        .ov_pkt_bufadd(ov_pkt_bufadd_p1),
        .i_pkt_ack(i_pkt_ack_p1),
        
        .iv_free_bufid_fifo_rdusedw(iv_free_bufid_fifo_rdusedw),
         
        .ov_descriptor_extract_state(ov_descriptor_extract_state_p1), 
        .ov_descriptor_send_state(ov_descriptor_send_state_p1),    
        .ov_data_splice_state(ov_data_splice_state_p1),        
        .ov_input_buf_interface_state(ov_input_buf_interface_state_p1) 
    );

network_input_process #(.inport(4'b0010)) network_input_process_inst2
    (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),

        .i_data_wr(i_gmii_dv_p2),
        .iv_data(iv_gmii_rxd_p2),

        .iv_addr(iv_addr),                         
        .i_addr_fixed(i_addr_fixed),                   
        .iv_wdata(iv_wdata), 
        
        .i_wr_irx(i_wr_ffi_p2),         
        .i_rd_irx(i_rd_ffi_p2),          
        .o_wr_irx(o_wr_ffi_p2),         
        .ov_addr_irx(ov_addr_ffi_p2),      
        .o_addr_fixed_irx(o_addr_fixed_ffi_p2), 
        .ov_rdata_irx(ov_rdata_ffi_p2), 

        .i_wr_dex(i_wr_dex_p2),                        
        .i_rd_dex(i_rd_dex_p2),
        .o_wr_dex(o_wr_dex_p2),                     
        .ov_addr_dex(ov_addr_dex_p2),                  
        .o_addr_fixed_dex(o_addr_fixed_dex_p2),             
        .ov_rdata_dex(ov_rdata_dex_p2), 

        .i_rc_rxenable                   (i_rc_rxenable                 ),
        .i_st_rxenable                   (i_st_rxenable                 ),         
        .i_hardware_initial_finish       (i_hardware_initial_finish     ),
        .iv_rc_threshold_value           (iv_rc_threshold_value         ),
        .iv_be_threshold_value           (iv_be_threshold_value         ),
        .iv_standardpkt_threshold_value  (iv_standardpkt_threshold_value),
        
        .i_pkt_bufid_wr(i_pkt_bufid_wr_p2),
        .iv_pkt_bufid(iv_pkt_bufid_p2),
        .o_pkt_bufid_ack(o_pkt_bufid_ack_p2),

        .o_descriptor_wr(o_descriptor_wr_p2),
        .ov_descriptor(ov_descriptor_p2),
        .i_descriptor_ack(i_descriptor_ack_p2),

        .ov_pkt(ov_pkt_p2),
        .o_pkt_wr(o_pkt_wr_p2),
        .ov_pkt_bufadd(ov_pkt_bufadd_p2),
        .i_pkt_ack(i_pkt_ack_p2),
        
        .iv_free_bufid_fifo_rdusedw(iv_free_bufid_fifo_rdusedw),
         
        .ov_descriptor_extract_state(ov_descriptor_extract_state_p2), 
        .ov_descriptor_send_state(ov_descriptor_send_state_p2),    
        .ov_data_splice_state(ov_data_splice_state_p2),        
        .ov_input_buf_interface_state(ov_input_buf_interface_state_p2) 
    );  
    
 network_input_process #(.inport(4'b0011)) network_input_process_inst3
     (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),

        .i_data_wr(i_gmii_dv_p3),
        .iv_data(iv_gmii_rxd_p3),
        
        .iv_addr(iv_addr),                         
        .i_addr_fixed(i_addr_fixed),                   
        .iv_wdata(iv_wdata), 
        
        .i_wr_irx(i_wr_ffi_p3),         
        .i_rd_irx(i_rd_ffi_p3),          
        .o_wr_irx(o_wr_ffi_p3),         
        .ov_addr_irx(ov_addr_ffi_p3),      
        .o_addr_fixed_irx(o_addr_fixed_ffi_p3), 
        .ov_rdata_irx(ov_rdata_ffi_p3), 

        .i_wr_dex(i_wr_dex_p3),                        
        .i_rd_dex(i_rd_dex_p3),
        .o_wr_dex(o_wr_dex_p3),                     
        .ov_addr_dex(ov_addr_dex_p3),                  
        .o_addr_fixed_dex(o_addr_fixed_dex_p3),             
        .ov_rdata_dex(ov_rdata_dex_p3), 

        .i_rc_rxenable                   (i_rc_rxenable                 ),
        .i_st_rxenable                   (i_st_rxenable                 ),         
        .i_hardware_initial_finish       (i_hardware_initial_finish     ),
        .iv_rc_threshold_value           (iv_rc_threshold_value         ),
        .iv_be_threshold_value           (iv_be_threshold_value         ),
        .iv_standardpkt_threshold_value  (iv_standardpkt_threshold_value),
        
        .i_pkt_bufid_wr(i_pkt_bufid_wr_p3),
        .iv_pkt_bufid(iv_pkt_bufid_p3),
        .o_pkt_bufid_ack(o_pkt_bufid_ack_p3),

        .o_descriptor_wr(o_descriptor_wr_p3),
        .ov_descriptor(ov_descriptor_p3),
        .i_descriptor_ack(i_descriptor_ack_p3),

        .ov_pkt(ov_pkt_p3),
        .o_pkt_wr(o_pkt_wr_p3),
        .ov_pkt_bufadd(ov_pkt_bufadd_p3),
        .i_pkt_ack(i_pkt_ack_p3),
        
        .iv_free_bufid_fifo_rdusedw(iv_free_bufid_fifo_rdusedw),
         
        .ov_descriptor_extract_state(ov_descriptor_extract_state_p3), 
        .ov_descriptor_send_state(ov_descriptor_send_state_p3),    
        .ov_data_splice_state(ov_data_splice_state_p3),        
        .ov_input_buf_interface_state(ov_input_buf_interface_state_p3) 
     );

 network_input_process #(.inport(4'b0100)) network_input_process_inst4
     (
         .i_clk(i_clk),
         .i_rst_n(i_rst_n),

         .i_data_wr(i_gmii_dv_p4),
         .iv_data(iv_gmii_rxd_p4),

        .iv_addr(iv_addr),                         
        .i_addr_fixed(i_addr_fixed),                   
        .iv_wdata(iv_wdata), 
        
        .i_wr_irx(i_wr_ffi_p4),         
        .i_rd_irx(i_rd_ffi_p4),          
        .o_wr_irx(o_wr_ffi_p4),         
        .ov_addr_irx(ov_addr_ffi_p4),      
        .o_addr_fixed_irx(o_addr_fixed_ffi_p4), 
        .ov_rdata_irx(ov_rdata_ffi_p4), 

        .i_wr_dex(i_wr_dex_p4),                        
        .i_rd_dex(i_rd_dex_p4),
        .o_wr_dex(o_wr_dex_p4),                     
        .ov_addr_dex(ov_addr_dex_p4),                  
        .o_addr_fixed_dex(o_addr_fixed_dex_p4),             
        .ov_rdata_dex(ov_rdata_dex_p4), 

        .i_rc_rxenable                   (i_rc_rxenable                 ),
        .i_st_rxenable                   (i_st_rxenable                 ),         
        .i_hardware_initial_finish       (i_hardware_initial_finish     ),
        .iv_rc_threshold_value           (iv_rc_threshold_value         ),
        .iv_be_threshold_value           (iv_be_threshold_value         ),
        .iv_standardpkt_threshold_value  (iv_standardpkt_threshold_value),
        
        .i_pkt_bufid_wr(i_pkt_bufid_wr_p4),
        .iv_pkt_bufid(iv_pkt_bufid_p4),
        .o_pkt_bufid_ack(o_pkt_bufid_ack_p4),

        .o_descriptor_wr(o_descriptor_wr_p4),
        .ov_descriptor(ov_descriptor_p4),
        .i_descriptor_ack(i_descriptor_ack_p4),

        .ov_pkt(ov_pkt_p4),
        .o_pkt_wr(o_pkt_wr_p4),
        .ov_pkt_bufadd(ov_pkt_bufadd_p4),
        .i_pkt_ack(i_pkt_ack_p4),
        
        .iv_free_bufid_fifo_rdusedw(iv_free_bufid_fifo_rdusedw),
         
        .ov_descriptor_extract_state(ov_descriptor_extract_state_p4), 
        .ov_descriptor_send_state(ov_descriptor_send_state_p4),    
        .ov_data_splice_state(ov_data_splice_state_p4),        
        .ov_input_buf_interface_state(ov_input_buf_interface_state_p4) 
     );

 network_input_process #(.inport(4'b0101)) network_input_process_inst5
     (
        .i_clk(i_clk),
        .i_rst_n(i_rst_n),

        .i_data_wr(i_gmii_dv_p5),
        .iv_data(iv_gmii_rxd_p5),

        .iv_addr(iv_addr),                         
        .i_addr_fixed(i_addr_fixed),                   
        .iv_wdata(iv_wdata), 
        
        .i_wr_irx(i_wr_ffi_p5),         
        .i_rd_irx(i_rd_ffi_p5),          
        .o_wr_irx(o_wr_ffi_p5),         
        .ov_addr_irx(ov_addr_ffi_p5),      
        .o_addr_fixed_irx(o_addr_fixed_ffi_p5), 
        .ov_rdata_irx(ov_rdata_ffi_p5), 

        .i_wr_dex(i_wr_dex_p5),                        
        .i_rd_dex(i_rd_dex_p5),
        .o_wr_dex(o_wr_dex_p5),                     
        .ov_addr_dex(ov_addr_dex_p5),                  
        .o_addr_fixed_dex(o_addr_fixed_dex_p5),             
        .ov_rdata_dex(ov_rdata_dex_p5), 

        .i_rc_rxenable                   (i_rc_rxenable                 ),
        .i_st_rxenable                   (i_st_rxenable                 ),         
        .i_hardware_initial_finish       (i_hardware_initial_finish     ),
        .iv_rc_threshold_value           (iv_rc_threshold_value         ),
        .iv_be_threshold_value           (iv_be_threshold_value         ),
        .iv_standardpkt_threshold_value  (iv_standardpkt_threshold_value),
         
        .i_pkt_bufid_wr(i_pkt_bufid_wr_p5),
        .iv_pkt_bufid(iv_pkt_bufid_p5),
        .o_pkt_bufid_ack(o_pkt_bufid_ack_p5),

        .o_descriptor_wr(o_descriptor_wr_p5),
        .ov_descriptor(ov_descriptor_p5),
        .i_descriptor_ack(i_descriptor_ack_p5),

        .ov_pkt(ov_pkt_p5),
        .o_pkt_wr(o_pkt_wr_p5),
        .ov_pkt_bufadd(ov_pkt_bufadd_p5),
        .i_pkt_ack(i_pkt_ack_p5),
        
        .iv_free_bufid_fifo_rdusedw(iv_free_bufid_fifo_rdusedw),
        
        .ov_descriptor_extract_state(ov_descriptor_extract_state_p5), 
        .ov_descriptor_send_state(ov_descriptor_send_state_p5),    
        .ov_data_splice_state(ov_data_splice_state_p5),        
        .ov_input_buf_interface_state(ov_input_buf_interface_state_p5) 
     );
    
 network_input_process #(.inport(4'b0110)) network_input_process_inst6
     (
         .i_clk(i_clk),
         .i_rst_n(i_rst_n),

         .i_data_wr(i_gmii_dv_p6),
         .iv_data(iv_gmii_rxd_p6),

        .iv_addr(iv_addr),                         
        .i_addr_fixed(i_addr_fixed),                   
        .iv_wdata(iv_wdata), 
        
        .i_wr_irx(i_wr_ffi_p6),         
        .i_rd_irx(i_rd_ffi_p6),          
        .o_wr_irx(o_wr_ffi_p6),         
        .ov_addr_irx(ov_addr_ffi_p6),      
        .o_addr_fixed_irx(o_addr_fixed_ffi_p6), 
        .ov_rdata_irx(ov_rdata_ffi_p6), 

        .i_wr_dex(i_wr_dex_p6),                        
        .i_rd_dex(i_rd_dex_p6),
        .o_wr_dex(o_wr_dex_p6),                     
        .ov_addr_dex(ov_addr_dex_p6),                  
        .o_addr_fixed_dex(o_addr_fixed_dex_p6),             
        .ov_rdata_dex(ov_rdata_dex_p6), 

        .i_rc_rxenable                   (i_rc_rxenable                 ),
        .i_st_rxenable                   (i_st_rxenable                 ),         
        .i_hardware_initial_finish       (i_hardware_initial_finish     ),
        .iv_rc_threshold_value           (iv_rc_threshold_value         ),
        .iv_be_threshold_value           (iv_be_threshold_value         ),
        .iv_standardpkt_threshold_value  (iv_standardpkt_threshold_value),
         
         .i_pkt_bufid_wr(i_pkt_bufid_wr_p6),
         .iv_pkt_bufid(iv_pkt_bufid_p6),
         .o_pkt_bufid_ack(o_pkt_bufid_ack_p6),

         .o_descriptor_wr(o_descriptor_wr_p6),
         .ov_descriptor(ov_descriptor_p6),
         .i_descriptor_ack(i_descriptor_ack_p6),

         .ov_pkt(ov_pkt_p6),
         .o_pkt_wr(o_pkt_wr_p6),
         .ov_pkt_bufadd(ov_pkt_bufadd_p6),
         .i_pkt_ack(i_pkt_ack_p6),
         
         .iv_free_bufid_fifo_rdusedw(iv_free_bufid_fifo_rdusedw),
         
         .ov_descriptor_extract_state(ov_descriptor_extract_state_p6), 
         .ov_descriptor_send_state(ov_descriptor_send_state_p6),    
         .ov_data_splice_state(ov_data_splice_state_p6),        
         .ov_input_buf_interface_state(ov_input_buf_interface_state_p6) 
     );

 network_input_process #(.inport(4'b0111)) network_input_process_inst7
     (
         .i_clk(i_clk),
         .i_rst_n(i_rst_n),

         .i_data_wr(i_gmii_dv_p7),
         .iv_data(iv_gmii_rxd_p7),

        .iv_addr(iv_addr),                         
        .i_addr_fixed(i_addr_fixed),                   
        .iv_wdata(iv_wdata), 
        
        .i_wr_irx(i_wr_ffi_p7),         
        .i_rd_irx(i_rd_ffi_p7),          
        .o_wr_irx(o_wr_ffi_p7),         
        .ov_addr_irx(ov_addr_ffi_p7),      
        .o_addr_fixed_irx(o_addr_fixed_ffi_p7), 
        .ov_rdata_irx(ov_rdata_ffi_p7), 

        .i_wr_dex(i_wr_dex_p7),                        
        .i_rd_dex(i_rd_dex_p7),
        .o_wr_dex(o_wr_dex_p7),                     
        .ov_addr_dex(ov_addr_dex_p7),                  
        .o_addr_fixed_dex(o_addr_fixed_dex_p7),             
        .ov_rdata_dex(ov_rdata_dex_p7), 

        .i_rc_rxenable                   (i_rc_rxenable                 ),
        .i_st_rxenable                   (i_st_rxenable                 ),         
        .i_hardware_initial_finish       (i_hardware_initial_finish     ),
        .iv_rc_threshold_value           (iv_rc_threshold_value         ),
        .iv_be_threshold_value           (iv_be_threshold_value         ),
        .iv_standardpkt_threshold_value  (iv_standardpkt_threshold_value),
         
         .i_pkt_bufid_wr(i_pkt_bufid_wr_p7),
         .iv_pkt_bufid(iv_pkt_bufid_p7),
         .o_pkt_bufid_ack(o_pkt_bufid_ack_p7),

         .o_descriptor_wr(o_descriptor_wr_p7),
         .ov_descriptor(ov_descriptor_p7),
         .i_descriptor_ack(i_descriptor_ack_p7),

         .ov_pkt(ov_pkt_p7),
         .o_pkt_wr(o_pkt_wr_p7),
         .ov_pkt_bufadd(ov_pkt_bufadd_p7),
         .i_pkt_ack(i_pkt_ack_p7),
         
         .iv_free_bufid_fifo_rdusedw(iv_free_bufid_fifo_rdusedw),
        
         .ov_descriptor_extract_state(ov_descriptor_extract_state_p7), 
         .ov_descriptor_send_state(ov_descriptor_send_state_p7),    
         .ov_data_splice_state(ov_data_splice_state_p7),        
         .ov_input_buf_interface_state(ov_input_buf_interface_state_p7) 
     ); 
 
 network_input_process #(.inport(4'b1000)) network_input_process_inst8
     (
         .i_clk(i_clk),
         .i_rst_n(i_rst_n),

         .i_data_wr(i_gmii_dv_p8),
         .iv_data(iv_gmii_rxd_p8),

        .iv_addr(iv_addr),                         
        .i_addr_fixed(i_addr_fixed),                   
        .iv_wdata(iv_wdata), 
        
        .i_wr_irx(i_wr_ffi_p8),         
        .i_rd_irx(i_rd_ffi_p8),          
        .o_wr_irx(o_wr_ffi_p8),         
        .ov_addr_irx(ov_addr_ffi_p8),      
        .o_addr_fixed_irx(o_addr_fixed_ffi_p8), 
        .ov_rdata_irx(ov_rdata_ffi_p8), 

        .i_wr_dex(i_wr_dex_p8),                        
        .i_rd_dex(i_rd_dex_p8),
        .o_wr_dex(o_wr_dex_p8),                     
        .ov_addr_dex     (ov_addr_dex_p8     ),                  
        .o_addr_fixed_dex(o_addr_fixed_dex_p8),             
        .ov_rdata_dex    (ov_rdata_dex_p8    ), 
        
        .i_rc_rxenable                   (i_rc_rxenable                 ),
        .i_st_rxenable                   (i_st_rxenable                 ),        
        .i_hardware_initial_finish       (i_hardware_initial_finish     ),
        .iv_rc_threshold_value           (iv_rc_threshold_value         ),
        .iv_be_threshold_value           (iv_be_threshold_value         ),
        .iv_standardpkt_threshold_value  (iv_standardpkt_threshold_value),
         
         .i_pkt_bufid_wr(i_pkt_bufid_wr_p8),
         .iv_pkt_bufid(iv_pkt_bufid_p8),
         .o_pkt_bufid_ack(o_pkt_bufid_ack_p8),

         .o_descriptor_wr(o_descriptor_wr_p8),
         .ov_descriptor(ov_descriptor_p8),
         .i_descriptor_ack(i_descriptor_ack_p8),

         .ov_pkt(ov_pkt_p8),
         .o_pkt_wr(o_pkt_wr_p8),
         .ov_pkt_bufadd(ov_pkt_bufadd_p8),
         .i_pkt_ack(i_pkt_ack_p8),
         
         .iv_free_bufid_fifo_rdusedw(iv_free_bufid_fifo_rdusedw),
         
         .ov_descriptor_extract_state(ov_descriptor_extract_state_p8), 
         .ov_descriptor_send_state(ov_descriptor_send_state_p8),    
         .ov_data_splice_state(ov_data_splice_state_p8),        
         .ov_input_buf_interface_state(ov_input_buf_interface_state_p8) 
     ); 
 
endmodule