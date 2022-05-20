// Copyright (C) 1953-2020 NUDT
// Verilog module name - pkt_centralized_buffer
// Version: PCB_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         Pkt Centralized Buffer
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module pkt_centralized_buffer
(
        clk_sys,
        reset_n,
        
        o_hardware_initial_finish,

        iv_addr,                          
        i_addr_fixed,                    
        iv_wdata,                                  
        i_wr_pcb,                         
        i_rd_pcb,                         

        o_wr_pcb,          
        ov_addr_pcb,       
        o_addr_fixed_pcb,  
        ov_rdata_pcb, 
        
        iv_pkt_p0,
        i_pkt_wr_p0,
        iv_pkt_wr_bufadd_p0,
        o_pkt_wr_ack_p0,
        
        iv_pkt_p1,
        i_pkt_wr_p1,
        iv_pkt_wr_bufadd_p1,
        o_pkt_wr_ack_p1,
        
        iv_pkt_p2,
        i_pkt_wr_p2,
        iv_pkt_wr_bufadd_p2,
        o_pkt_wr_ack_p2,
        
        iv_pkt_p3,
        i_pkt_wr_p3,
        iv_pkt_wr_bufadd_p3,
        o_pkt_wr_ack_p3,
        
        iv_pkt_p4,
        i_pkt_wr_p4,
        iv_pkt_wr_bufadd_p4,
        o_pkt_wr_ack_p4,
        
        iv_pkt_p5,
        i_pkt_wr_p5,
        iv_pkt_wr_bufadd_p5,
        o_pkt_wr_ack_p5,
        
        iv_pkt_p6,
        i_pkt_wr_p6,
        iv_pkt_wr_bufadd_p6,
        o_pkt_wr_ack_p6,
        
        iv_pkt_p7,
        i_pkt_wr_p7,
        iv_pkt_wr_bufadd_p7,
        o_pkt_wr_ack_p7, 
        
        iv_pkt_p8,
        i_pkt_wr_p8,
        iv_pkt_wr_bufadd_p8,
        o_pkt_wr_ack_p8,
        
        iv_pkt_rd_bufadd_p0,
        i_pkt_rd_p0,
        o_pkt_rd_ack_p0,
        ov_pkt_p0,
        o_pkt_wr_p0,
        
        iv_pkt_rd_bufadd_p1,
        i_pkt_rd_p1,
        o_pkt_rd_ack_p1,
        ov_pkt_p1,
        o_pkt_wr_p1,
        
        iv_pkt_rd_bufadd_p2,
        i_pkt_rd_p2,
        o_pkt_rd_ack_p2,
        ov_pkt_p2,
        o_pkt_wr_p2,
        
        iv_pkt_rd_bufadd_p3,
        i_pkt_rd_p3,
        o_pkt_rd_ack_p3,
        ov_pkt_p3,
        o_pkt_wr_p3,
        
        iv_pkt_rd_bufadd_p4,
        i_pkt_rd_p4,
        o_pkt_rd_ack_p4,
        ov_pkt_p4,
        o_pkt_wr_p4,
        
        iv_pkt_rd_bufadd_p5,
        i_pkt_rd_p5,
        o_pkt_rd_ack_p5,
        ov_pkt_p5,
        o_pkt_wr_p5,
        
        iv_pkt_rd_bufadd_p6,
        i_pkt_rd_p6,
        o_pkt_rd_ack_p6,
        ov_pkt_p6,
        o_pkt_wr_p6,
        
        iv_pkt_rd_bufadd_p7,
        i_pkt_rd_p7,
        o_pkt_rd_ack_p7,
        ov_pkt_p7,
        o_pkt_wr_p7,
        
        iv_pkt_rd_bufadd_p8,
        i_pkt_rd_p8,
        o_pkt_rd_ack_p8,
        ov_pkt_p8,
        o_pkt_wr_p8,
        
        ov_pkt_bufid_p0,
        o_pkt_bufid_wr_p0,
        i_pkt_bufid_ack_p0,
        
        ov_pkt_bufid_p1,
        o_pkt_bufid_wr_p1,
        i_pkt_bufid_ack_p1, 
        
        ov_pkt_bufid_p2,
        o_pkt_bufid_wr_p2,
        i_pkt_bufid_ack_p2,
        
        ov_pkt_bufid_p3,
        o_pkt_bufid_wr_p3,
        i_pkt_bufid_ack_p3,
        
        ov_pkt_bufid_p4,
        o_pkt_bufid_wr_p4,
        i_pkt_bufid_ack_p4,
        
        ov_pkt_bufid_p5,
        o_pkt_bufid_wr_p5,
        i_pkt_bufid_ack_p5,  
        
        ov_pkt_bufid_p6,
        o_pkt_bufid_wr_p6,
        i_pkt_bufid_ack_p6,
        
        ov_pkt_bufid_p7,
        o_pkt_bufid_wr_p7,
        i_pkt_bufid_ack_p7,
        
        ov_pkt_bufid_p8,
        o_pkt_bufid_wr_p8,
        i_pkt_bufid_ack_p8,
        
        i_pkt_bufid_wr_flt,
        iv_pkt_bufid_flt,
        iv_pkt_bufid_cnt_flt,
        
        iv_pkt_bufid_p0,
        i_pkt_bufid_wr_p0,
        o_pkt_bufid_ack_p0,
        
        iv_pkt_bufid_p1,
        i_pkt_bufid_wr_p1,
        o_pkt_bufid_ack_p1,
        
        iv_pkt_bufid_p2,
        i_pkt_bufid_wr_p2,
        o_pkt_bufid_ack_p2,
        
        iv_pkt_bufid_p3,
        i_pkt_bufid_wr_p3,
        o_pkt_bufid_ack_p3,
        
        iv_pkt_bufid_p4,
        i_pkt_bufid_wr_p4,
        o_pkt_bufid_ack_p4,
        
        iv_pkt_bufid_p5,
        i_pkt_bufid_wr_p5,
        o_pkt_bufid_ack_p5,
        
        iv_pkt_bufid_p6,
        i_pkt_bufid_wr_p6,
        o_pkt_bufid_ack_p6,
        
        iv_pkt_bufid_p7,
        i_pkt_bufid_wr_p7,
        o_pkt_bufid_ack_p7, 
        
        iv_pkt_bufid_p8,
        i_pkt_bufid_wr_p8,
        o_pkt_bufid_ack_p8,
        
        ov_pkt_write_state,      
        ov_pcb_pkt_read_state,   
        ov_address_write_state,  
        ov_address_read_state,   
        ov_free_buf_fifo_rdusedw
);
// I/O
// clk & rst
input                   clk_sys;
input                   reset_n;

output                  o_hardware_initial_finish;

input       [18:0]      iv_addr;                         
input                   i_addr_fixed;                   
input       [31:0]      iv_wdata;                              
input                   i_wr_pcb;                        
input                   i_rd_pcb; 

output                  o_wr_pcb;                     
output     [18:0]       ov_addr_pcb;                  
output                  o_addr_fixed_pcb;             
output     [31:0]       ov_rdata_pcb;
//receive port pkt
input       [133:0]     iv_pkt_p0;              //receive network interface port0 packet
input                   i_pkt_wr_p0;            //receive network interface port0 write signal
input       [15:0]      iv_pkt_wr_bufadd_p0;    //receive network interface port0 buffer address 
output                  o_pkt_wr_ack_p0;        //receive network interface port0 ack 
input       [133:0]     iv_pkt_p1;              
input                   i_pkt_wr_p1;            
input       [15:0]      iv_pkt_wr_bufadd_p1;    
output                  o_pkt_wr_ack_p1;        
input       [133:0]     iv_pkt_p2;              
input                   i_pkt_wr_p2;            
input       [15:0]      iv_pkt_wr_bufadd_p2;    
output                  o_pkt_wr_ack_p2;        
input       [133:0]     iv_pkt_p3;
input                   i_pkt_wr_p3;
input       [15:0]      iv_pkt_wr_bufadd_p3;
output                  o_pkt_wr_ack_p3;
input       [133:0]     iv_pkt_p4;
input                   i_pkt_wr_p4;
input       [15:0]      iv_pkt_wr_bufadd_p4;
output                  o_pkt_wr_ack_p4;
input       [133:0]     iv_pkt_p5;
input                   i_pkt_wr_p5;
input       [15:0]      iv_pkt_wr_bufadd_p5;
output                  o_pkt_wr_ack_p5;
input       [133:0]     iv_pkt_p6;
input                   i_pkt_wr_p6;
input       [15:0]      iv_pkt_wr_bufadd_p6;
output                  o_pkt_wr_ack_p6;
input       [133:0]     iv_pkt_p7;
input                   i_pkt_wr_p7;
input       [15:0]      iv_pkt_wr_bufadd_p7;
output                  o_pkt_wr_ack_p7;    
input       [133:0]     iv_pkt_p8;              //receive host interface packet
input                   i_pkt_wr_p8;            //receive host interface write signal
input       [15:0]      iv_pkt_wr_bufadd_p8;    //receive host interface buffer address 
output                  o_pkt_wr_ack_p8;        //receive host interface ack
//send port pkt
input       [15:0]      iv_pkt_rd_bufadd_p0;    //send network interface port0 buffer address 
input                   i_pkt_rd_p0;            //send network interface port0 read signal
output                  o_pkt_rd_ack_p0;        //send network interface port0 ack
output      [133:0]     ov_pkt_p0;              //send network interface port0 packet
output                  o_pkt_wr_p0;            //send network interface port0 write signal
input       [15:0]      iv_pkt_rd_bufadd_p1;    
input                   i_pkt_rd_p1;            
output                  o_pkt_rd_ack_p1;        
output      [133:0]     ov_pkt_p1;              
output                  o_pkt_wr_p1;            
input       [15:0]      iv_pkt_rd_bufadd_p2;    
input                   i_pkt_rd_p2;            
output                  o_pkt_rd_ack_p2;        
output      [133:0]     ov_pkt_p2;              
output                  o_pkt_wr_p2;            
input       [15:0]      iv_pkt_rd_bufadd_p3;
input                   i_pkt_rd_p3;
output                  o_pkt_rd_ack_p3;
output      [133:0]     ov_pkt_p3;
output                  o_pkt_wr_p3;
input       [15:0]      iv_pkt_rd_bufadd_p4;
input                   i_pkt_rd_p4;
output                  o_pkt_rd_ack_p4;
output      [133:0]     ov_pkt_p4;
output                  o_pkt_wr_p4;
input       [15:0]      iv_pkt_rd_bufadd_p5;
input                   i_pkt_rd_p5;
output                  o_pkt_rd_ack_p5;
output      [133:0]     ov_pkt_p5;
output                  o_pkt_wr_p5;
input       [15:0]      iv_pkt_rd_bufadd_p6;
input                   i_pkt_rd_p6;
output                  o_pkt_rd_ack_p6;
output      [133:0]     ov_pkt_p6;
output                  o_pkt_wr_p6;
input       [15:0]      iv_pkt_rd_bufadd_p7;
input                   i_pkt_rd_p7;
output                  o_pkt_rd_ack_p7;
output      [133:0]     ov_pkt_p7;
output                  o_pkt_wr_p7;
input       [15:0]      iv_pkt_rd_bufadd_p8;    //send host interface buffer address
input                   i_pkt_rd_p8;            //send host interface read signal
output                  o_pkt_rd_ack_p8;        //send host interface ack
output      [133:0]     ov_pkt_p8;              //send host interface  packet
output                  o_pkt_wr_p8;            //send host interface write signal
//send port buffer id
output      [8:0]       ov_pkt_bufid_p0;
output                  o_pkt_bufid_wr_p0;
input                   i_pkt_bufid_ack_p0;
output      [8:0]       ov_pkt_bufid_p1;
output                  o_pkt_bufid_wr_p1;
input                   i_pkt_bufid_ack_p1;     
output      [8:0]       ov_pkt_bufid_p2;
output                  o_pkt_bufid_wr_p2;
input                   i_pkt_bufid_ack_p2;
output      [8:0]       ov_pkt_bufid_p3;
output                  o_pkt_bufid_wr_p3;
input                   i_pkt_bufid_ack_p3;
output      [8:0]       ov_pkt_bufid_p4;
output                  o_pkt_bufid_wr_p4;
input                   i_pkt_bufid_ack_p4;
output      [8:0]       ov_pkt_bufid_p5;
output                  o_pkt_bufid_wr_p5;
input                   i_pkt_bufid_ack_p5;     
output      [8:0]       ov_pkt_bufid_p6;
output                  o_pkt_bufid_wr_p6;
input                   i_pkt_bufid_ack_p6;
output      [8:0]       ov_pkt_bufid_p7;
output                  o_pkt_bufid_wr_p7;
input                   i_pkt_bufid_ack_p7;
output      [8:0]       ov_pkt_bufid_p8;
output                  o_pkt_bufid_wr_p8;
input                   i_pkt_bufid_ack_p8;
//receive Forward Lookup Table Module's buf id and using cnt.
input                   i_pkt_bufid_wr_flt;
input       [8:0]       iv_pkt_bufid_flt;
input       [3:0]       iv_pkt_bufid_cnt_flt;
//receive port buffer id
input       [8:0]       iv_pkt_bufid_p0;
input                   i_pkt_bufid_wr_p0;
output                  o_pkt_bufid_ack_p0;
input       [8:0]       iv_pkt_bufid_p1;
input                   i_pkt_bufid_wr_p1;
output                  o_pkt_bufid_ack_p1;
input       [8:0]       iv_pkt_bufid_p2;
input                   i_pkt_bufid_wr_p2;
output                  o_pkt_bufid_ack_p2;
input       [8:0]       iv_pkt_bufid_p3;
input                   i_pkt_bufid_wr_p3;
output                  o_pkt_bufid_ack_p3;
input       [8:0]       iv_pkt_bufid_p4;
input                   i_pkt_bufid_wr_p4;
output                  o_pkt_bufid_ack_p4;
input       [8:0]       iv_pkt_bufid_p5;
input                   i_pkt_bufid_wr_p5;
output                  o_pkt_bufid_ack_p5;
input       [8:0]       iv_pkt_bufid_p6;
input                   i_pkt_bufid_wr_p6;
output                  o_pkt_bufid_ack_p6;
input       [8:0]       iv_pkt_bufid_p7;
input                   i_pkt_bufid_wr_p7;
output                  o_pkt_bufid_ack_p7; 
input       [8:0]       iv_pkt_bufid_p8;
input                   i_pkt_bufid_wr_p8;
output                  o_pkt_bufid_ack_p8;
//state
output     [3:0]        ov_pkt_write_state;      
output     [3:0]        ov_pcb_pkt_read_state;   
output     [3:0]        ov_address_write_state;  
output     [3:0]        ov_address_read_state;   
output     [8:0]        ov_free_buf_fifo_rdusedw;

// internal wire for pkt_RAM
wire        [133:0]     pkt_pwr2ram;
wire                    pkt_wr_pwr2ram;
wire        [15:0]      pkt_bufadd_pwr2ram;
wire        [15:0]      pkt_bufadd_prd2ram;
wire                    pkt_rd_prd2ram;
wire        [133:0]     pkt_ram2prd;
// internal wire for FIFO
wire                    pkt_bufid_rd_ard2fifo;
wire        [8:0]       pkt_bufid_fifo2ard;
wire                    pkt_bufid_empty_fifo2ard;
wire                    pkt_bufid_wr_awr2fifo;
wire        [8:0]       pkt_bufid_awr2fifo;
wire                    pkt_bufid_full_awr2fifo;
//internal wire for portnum_RAM
wire        [3:0]       rd_outport_num;
wire        [8:0]       bufid_addr;
wire                    rd_bufid_wr;
wire        [3:0]       wr_outport_num;
wire                    wr_bufid_wr;
        
//assign rd_outport_num = rd_outport_num_ram[3:0];

pkt_write pkt_write_inst
    (
        .clk_sys(clk_sys),
        .reset_n(reset_n),
        .iv_pkt_p0(iv_pkt_p0),
        .i_pkt_wr_p0(i_pkt_wr_p0),
        .iv_pkt_wr_bufadd_p0(iv_pkt_wr_bufadd_p0),
        .o_pkt_wr_ack_p0(o_pkt_wr_ack_p0),
        .iv_pkt_p1(iv_pkt_p1),
        .i_pkt_wr_p1(i_pkt_wr_p1),
        .iv_pkt_wr_bufadd_p1(iv_pkt_wr_bufadd_p1),
        .o_pkt_wr_ack_p1(o_pkt_wr_ack_p1),
        .iv_pkt_p2(iv_pkt_p2),
        .i_pkt_wr_p2(i_pkt_wr_p2),
        .iv_pkt_wr_bufadd_p2(iv_pkt_wr_bufadd_p2),
        .o_pkt_wr_ack_p2(o_pkt_wr_ack_p2),
        .iv_pkt_p3(iv_pkt_p3),
        .i_pkt_wr_p3(i_pkt_wr_p3),
        .iv_pkt_wr_bufadd_p3(iv_pkt_wr_bufadd_p3),
        .o_pkt_wr_ack_p3(o_pkt_wr_ack_p3),
        .iv_pkt_p4(iv_pkt_p4),
        .i_pkt_wr_p4(i_pkt_wr_p4),
        .iv_pkt_wr_bufadd_p4(iv_pkt_wr_bufadd_p4),
        .o_pkt_wr_ack_p4(o_pkt_wr_ack_p4),
        .iv_pkt_p5(iv_pkt_p5),
        .i_pkt_wr_p5(i_pkt_wr_p5),
        .iv_pkt_wr_bufadd_p5(iv_pkt_wr_bufadd_p5),
        .o_pkt_wr_ack_p5(o_pkt_wr_ack_p5),
        .iv_pkt_p6(iv_pkt_p6),
        .i_pkt_wr_p6(i_pkt_wr_p6),
        .iv_pkt_wr_bufadd_p6(iv_pkt_wr_bufadd_p6),
        .o_pkt_wr_ack_p6(o_pkt_wr_ack_p6),
        .iv_pkt_p7(iv_pkt_p7),
        .i_pkt_wr_p7(i_pkt_wr_p7),
        .iv_pkt_wr_bufadd_p7(iv_pkt_wr_bufadd_p7),
        .o_pkt_wr_ack_p7(o_pkt_wr_ack_p7),  
        .iv_pkt_p8(iv_pkt_p8),
        .i_pkt_wr_p8(i_pkt_wr_p8),
        .iv_pkt_wr_bufadd_p8(iv_pkt_wr_bufadd_p8),
        .o_pkt_wr_ack_p8(o_pkt_wr_ack_p8),
        .o_pkt(pkt_pwr2ram),
        .o_pkt_wr(pkt_wr_pwr2ram),
        .o_pkt_bufadd(pkt_bufadd_pwr2ram),
        .ov_pkt_write_state(ov_pkt_write_state)
    );

pkt_read pkt_read_inst
    (
        .clk_sys(clk_sys),
        .reset_n(reset_n),  
        .iv_pkt_rd_bufadd_p0(iv_pkt_rd_bufadd_p0),
        .i_pkt_rd_p0(i_pkt_rd_p0),
        .o_pkt_rd_ack_p0(o_pkt_rd_ack_p0),
        .ov_pkt_p0(ov_pkt_p0),
        .o_pkt_wr_p0(o_pkt_wr_p0),
        .iv_pkt_rd_bufadd_p1(iv_pkt_rd_bufadd_p1),
        .i_pkt_rd_p1(i_pkt_rd_p1),
        .o_pkt_rd_ack_p1(o_pkt_rd_ack_p1),
        .ov_pkt_p1(ov_pkt_p1),
        .o_pkt_wr_p1(o_pkt_wr_p1),
        .iv_pkt_rd_bufadd_p2(iv_pkt_rd_bufadd_p2),
        .i_pkt_rd_p2(i_pkt_rd_p2),
        .o_pkt_rd_ack_p2(o_pkt_rd_ack_p2),
        .ov_pkt_p2(ov_pkt_p2),
        .o_pkt_wr_p2(o_pkt_wr_p2),
        .iv_pkt_rd_bufadd_p3(iv_pkt_rd_bufadd_p3),
        .i_pkt_rd_p3(i_pkt_rd_p3),
        .o_pkt_rd_ack_p3(o_pkt_rd_ack_p3),
        .ov_pkt_p3(ov_pkt_p3),
        .o_pkt_wr_p3(o_pkt_wr_p3),
        .iv_pkt_rd_bufadd_p4(iv_pkt_rd_bufadd_p4),
        .i_pkt_rd_p4(i_pkt_rd_p4),
        .o_pkt_rd_ack_p4(o_pkt_rd_ack_p4),
        .ov_pkt_p4(ov_pkt_p4),
        .o_pkt_wr_p4(o_pkt_wr_p4),
        .iv_pkt_rd_bufadd_p5(iv_pkt_rd_bufadd_p5),
        .i_pkt_rd_p5(i_pkt_rd_p5),
        .o_pkt_rd_ack_p5(o_pkt_rd_ack_p5),
        .ov_pkt_p5(ov_pkt_p5),
        .o_pkt_wr_p5(o_pkt_wr_p5),
        .iv_pkt_rd_bufadd_p6(iv_pkt_rd_bufadd_p6),
        .i_pkt_rd_p6(i_pkt_rd_p6),
        .o_pkt_rd_ack_p6(o_pkt_rd_ack_p6),
        .ov_pkt_p6(ov_pkt_p6),
        .o_pkt_wr_p6(o_pkt_wr_p6),
        .iv_pkt_rd_bufadd_p7(iv_pkt_rd_bufadd_p7),
        .i_pkt_rd_p7(i_pkt_rd_p7),
        .o_pkt_rd_ack_p7(o_pkt_rd_ack_p7),
        .ov_pkt_p7(ov_pkt_p7),
        .o_pkt_wr_p7(o_pkt_wr_p7),
        .iv_pkt_rd_bufadd_p8(iv_pkt_rd_bufadd_p8),
        .i_pkt_rd_p8(i_pkt_rd_p8),
        .o_pkt_rd_ack_p8(o_pkt_rd_ack_p8),
        .ov_pkt_p8(ov_pkt_p8),
        .o_pkt_wr_p8(o_pkt_wr_p8),
        .o_pkt_bufadd(pkt_bufadd_prd2ram),
        .o_pkt_rd(pkt_rd_prd2ram),
        .i_pkt(pkt_ram2prd),
        .ov_pcb_pkt_read_state(ov_pcb_pkt_read_state)
    );
    
suhddpsram65536x134_s suhddpsram65536x134_s_inst(
        .aclr       (!reset_n               ),  //asynchronous reset(high active)
        .address_a  (pkt_bufadd_prd2ram     ),  //RAM read address
        .address_b  (pkt_bufadd_pwr2ram     ),  //RAM write address
        .clock      (clk_sys                ),  //ASYNC WriteClk, SYNC use wrclk,
        .data_a     ({134{1'b0}}            ),  //
        .data_b     (pkt_pwr2ram            ),  //RAM input data
        .rden_a     (pkt_rd_prd2ram         ),  //RAM read request(high active)
        .rden_b     (1'b0                   ),  //
        .wren_a     (1'b0                   ),  //
        .wren_b     (pkt_wr_pwr2ram         ),  //RAM write request(high active)
        .q_a        (pkt_ram2prd            ),  //RAM output data
        .q_b        (                       )   //
);                  

suhddpsram512x4_rq suhddpsram512x4_rq_inst( 
        .aclr(!reset_n),                        //asynchronous reset(high active)
        
        .address_a(iv_pkt_bufid_flt),           //port A: address
        .address_b(bufid_addr),                 //port B: address
        
        .clock(clk_sys),                        //port A & B: clock
        
        .data_a(iv_pkt_bufid_cnt_flt),          //port A: data input
        .data_b(wr_outport_num),                //port B: data input
        
        .rden_a(1'b0),                          //port A: read enable(high active)
        .rden_b(rd_bufid_wr),                   //port B: read enable(high active)
        
        .wren_a(i_pkt_bufid_wr_flt),            //port A: write enable(high active)
        .wren_b(wr_bufid_wr),                   //port B: write enable(high active)
        
        .q_a(),                                 //port A: data output
        .q_b(rd_outport_num)                    //port B: data output
);          

address_read address_read_inst
    (
        .clk_sys(clk_sys),
        .reset_n(reset_n),  
        .ov_pkt_bufid_p0(ov_pkt_bufid_p0),
        .o_pkt_bufid_wr_p0(o_pkt_bufid_wr_p0),
        .i_pkt_bufid_ack_p0(i_pkt_bufid_ack_p0),
        .ov_pkt_bufid_p1(ov_pkt_bufid_p1),
        .o_pkt_bufid_wr_p1(o_pkt_bufid_wr_p1),
        .i_pkt_bufid_ack_p1(i_pkt_bufid_ack_p1),        
        .ov_pkt_bufid_p2(ov_pkt_bufid_p2),
        .o_pkt_bufid_wr_p2(o_pkt_bufid_wr_p2),
        .i_pkt_bufid_ack_p2(i_pkt_bufid_ack_p2),
        .ov_pkt_bufid_p3(ov_pkt_bufid_p3),
        .o_pkt_bufid_wr_p3(o_pkt_bufid_wr_p3),
        .i_pkt_bufid_ack_p3(i_pkt_bufid_ack_p3),
        .ov_pkt_bufid_p4(ov_pkt_bufid_p4),
        .o_pkt_bufid_wr_p4(o_pkt_bufid_wr_p4),
        .i_pkt_bufid_ack_p4(i_pkt_bufid_ack_p4),
        .ov_pkt_bufid_p5(ov_pkt_bufid_p5),
        .o_pkt_bufid_wr_p5(o_pkt_bufid_wr_p5),
        .i_pkt_bufid_ack_p5(i_pkt_bufid_ack_p5),        
        .ov_pkt_bufid_p6(ov_pkt_bufid_p6),
        .o_pkt_bufid_wr_p6(o_pkt_bufid_wr_p6),
        .i_pkt_bufid_ack_p6(i_pkt_bufid_ack_p6),
        .ov_pkt_bufid_p7(ov_pkt_bufid_p7),
        .o_pkt_bufid_wr_p7(o_pkt_bufid_wr_p7),
        .i_pkt_bufid_ack_p7(i_pkt_bufid_ack_p7),
        .ov_pkt_bufid_p8(ov_pkt_bufid_p8),
        .o_pkt_bufid_wr_p8(o_pkt_bufid_wr_p8),
        .i_pkt_bufid_ack_p8(i_pkt_bufid_ack_p8),
        .o_pkt_bufid_rd(pkt_bufid_rd_ard2fifo),
        .iv_pkt_bufid(pkt_bufid_fifo2ard),
        .i_pkt_bufid_empty(pkt_bufid_empty_fifo2ard),
        .ov_address_read_state(ov_address_read_state)
    );

address_write add_write_inst
    (
        .clk_sys(clk_sys),
        .reset_n(reset_n),
        .o_hardware_initial_finish(o_hardware_initial_finish),
        .iv_pkt_bufid_p0(iv_pkt_bufid_p0),
        .i_pkt_bufid_wr_p0(i_pkt_bufid_wr_p0),
        .o_pkt_bufid_ack_p0(o_pkt_bufid_ack_p0),
        .iv_pkt_bufid_p1(iv_pkt_bufid_p1),
        .i_pkt_bufid_wr_p1(i_pkt_bufid_wr_p1),
        .o_pkt_bufid_ack_p1(o_pkt_bufid_ack_p1),
        .iv_pkt_bufid_p2(iv_pkt_bufid_p2),
        .i_pkt_bufid_wr_p2(i_pkt_bufid_wr_p2),
        .o_pkt_bufid_ack_p2(o_pkt_bufid_ack_p2),
        .iv_pkt_bufid_p3(iv_pkt_bufid_p3),
        .i_pkt_bufid_wr_p3(i_pkt_bufid_wr_p3),
        .o_pkt_bufid_ack_p3(o_pkt_bufid_ack_p3),
        .iv_pkt_bufid_p4(iv_pkt_bufid_p4),
        .i_pkt_bufid_wr_p4(i_pkt_bufid_wr_p4),
        .o_pkt_bufid_ack_p4(o_pkt_bufid_ack_p4),
        .iv_pkt_bufid_p5(iv_pkt_bufid_p5),
        .i_pkt_bufid_wr_p5(i_pkt_bufid_wr_p5),
        .o_pkt_bufid_ack_p5(o_pkt_bufid_ack_p5),
        .iv_pkt_bufid_p6(iv_pkt_bufid_p6),
        .i_pkt_bufid_wr_p6(i_pkt_bufid_wr_p6),
        .o_pkt_bufid_ack_p6(o_pkt_bufid_ack_p6),
        .iv_pkt_bufid_p7(iv_pkt_bufid_p7),
        .i_pkt_bufid_wr_p7(i_pkt_bufid_wr_p7),
        .o_pkt_bufid_ack_p7(o_pkt_bufid_ack_p7),    
        .iv_pkt_bufid_p8(iv_pkt_bufid_p8),
        .i_pkt_bufid_wr_p8(i_pkt_bufid_wr_p8),
        .o_pkt_bufid_ack_p8(o_pkt_bufid_ack_p8),
        .o_pkt_bufid_wr(pkt_bufid_wr_awr2fifo),
        .o_pkt_bufid(pkt_bufid_awr2fifo),
        .i_pkt_bufid_full(pkt_bufid_full_awr2fifo),
        .ov_address_write_state(ov_address_write_state),
        .rd_outport_num(rd_outport_num),
        .bufid_addr(bufid_addr),
        .rd_bufid_wr(rd_bufid_wr),
        .wr_outport_num(wr_outport_num),
        .wr_bufid_wr(wr_bufid_wr)   
    );

SFIFO_9_512  SFIFO_9_512_inst
    (
        .aclr(!reset_n),                    //Reset the all signal(active high)
        .data(pkt_bufid_awr2fifo),          //The Inport of data 
        .rdreq(pkt_bufid_rd_ard2fifo),      //active-high
        .clk(clk_sys),                      //ASYNC WriteClk, SYNC use wrclk
        .wrreq(pkt_bufid_wr_awr2fifo),      //active-high
        .q(pkt_bufid_fifo2ard),             //The output of data
        .wrfull(pkt_bufid_full_awr2fifo),   //Write domain full 
        .rdempty(pkt_bufid_empty_fifo2ard), //Read domain empty
        
        .wralfull(),    
        .wrempty(), 
        .wralempty(),   
        .rdfull(),      
        .rdalfull(),    
        .rdalempty(),   
        .wrusedw(), 
        .rdusedw(ov_free_buf_fifo_rdusedw)  
    );
    
command_parse_and_encapsulate_pcb command_parse_and_encapsulate_pcb_inst
    (
        .i_clk                 (clk_sys                ),
        .i_rst_n               (reset_n                ),
        
        .iv_free_pkt_bufid_num(ov_free_buf_fifo_rdusedw),
        
        .iv_addr              (iv_addr                 ),                         
        .i_addr_fixed         (i_addr_fixed            ),                   
        .iv_wdata             (iv_wdata                ),                        
        .i_wr_pcb             (i_wr_pcb                ),         
        .i_rd_pcb             (i_rd_pcb                ),         
                                                       
        .o_wr_pcb             (o_wr_pcb                ),         
        .ov_addr_pcb          (ov_addr_pcb             ),      
        .o_addr_fixed_pcb     (o_addr_fixed_pcb        ), 
        .ov_rdata_pcb         (ov_rdata_pcb            )
    ); 
endmodule   