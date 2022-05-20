    // Copyright (C) 1953-2021 NUDT
// Verilog module name - action_selecting
// Version: V3.2.0.20210722
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         select data from TPA and SPA
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module action_selecting
(
       i_clk,
       i_rst_n,
       //from tpa
       iv_pkt_bufid_p0_tpa,
       iv_pkt_type_p0_tpa,
       i_pkt_bufid_wr_p0_tpa,
       
       iv_pkt_bufid_p1_tpa,
       iv_pkt_type_p1_tpa,
       i_pkt_bufid_wr_p1_tpa,
	   
       iv_pkt_bufid_p2_tpa,
       iv_pkt_type_p2_tpa,
       i_pkt_bufid_wr_p2_tpa,
       
       iv_pkt_bufid_p3_tpa,
       iv_pkt_type_p3_tpa,
       i_pkt_bufid_wr_p3_tpa,
       
       iv_pkt_bufid_p4_tpa,
       iv_pkt_type_p4_tpa,
       i_pkt_bufid_wr_p4_tpa,
       
       iv_pkt_bufid_p5_tpa,
       iv_pkt_type_p5_tpa,
       i_pkt_bufid_wr_p5_tpa,
       
       iv_pkt_bufid_p6_tpa,
       iv_pkt_type_p6_tpa,
       i_pkt_bufid_wr_p6_tpa,
       
       iv_pkt_bufid_p7_tpa,
       iv_pkt_type_p7_tpa,
       i_pkt_bufid_wr_p7_tpa,
       
       iv_pkt_bufid_host_tpa,
       iv_pkt_type_host_tpa,
       iv_pkt_inport_host_tpa,
       i_pkt_bufid_wr_host_tpa,
       
       iv_pkt_bufid_tpa,        
       i_pkt_bufid_wr_tpa,   
       iv_pkt_bufid_cnt_tpa, 
	   //from spa
       iv_pkt_bufid_p0_spa,
       iv_pkt_type_p0_spa,
       i_pkt_bufid_req_p0_spa,
	   o_pkt_bufid_ack_p0_spa,
       
       iv_pkt_bufid_p1_spa,
       iv_pkt_type_p1_spa,
       i_pkt_bufid_req_p1_spa,
       o_pkt_bufid_ack_p1_spa,
	   
       iv_pkt_bufid_p2_spa,
       iv_pkt_type_p2_spa,
       i_pkt_bufid_req_p2_spa,
	   o_pkt_bufid_ack_p2_spa,
       
       iv_pkt_bufid_p3_spa,
       iv_pkt_type_p3_spa,
       i_pkt_bufid_req_p3_spa,
	   o_pkt_bufid_ack_p3_spa,
       
       iv_pkt_bufid_p4_spa,
       iv_pkt_type_p4_spa,
       i_pkt_bufid_req_p4_spa,
	   o_pkt_bufid_ack_p4_spa,
       
       iv_pkt_bufid_p5_spa,
       iv_pkt_type_p5_spa,
       i_pkt_bufid_req_p5_spa,
	   o_pkt_bufid_ack_p5_spa,
       
       iv_pkt_bufid_p6_spa,
       iv_pkt_type_p6_spa,
       i_pkt_bufid_req_p6_spa,
	   o_pkt_bufid_ack_p6_spa,
       
       iv_pkt_bufid_p7_spa,
       iv_pkt_type_p7_spa,
       i_pkt_bufid_req_p7_spa,
	   o_pkt_bufid_ack_p7_spa,
       
       iv_pkt_bufid_host_spa,
       iv_pkt_type_host_spa,
	   i_mac_entry_hit_spa,
       iv_pkt_inport_host_spa,
       i_pkt_bufid_req_host_spa,
	   o_pkt_bufid_ack_host_spa,
       
       iv_pkt_bufid_spa,        
       i_pkt_bufid_req_spa, 
       o_pkt_bufid_ack_spa,	   
       iv_pkt_bufid_cnt_spa,
       //output
       ov_pkt_bufid_p0,
       ov_pkt_type_p0,
       o_pkt_bufid_wr_p0,
       
       ov_pkt_bufid_p1,
       ov_pkt_type_p1,
       o_pkt_bufid_wr_p1,
       
       ov_pkt_bufid_p2,
       ov_pkt_type_p2,
       o_pkt_bufid_wr_p2,
       
       ov_pkt_bufid_p3,
       ov_pkt_type_p3,
       o_pkt_bufid_wr_p3,
       
       ov_pkt_bufid_p4,
       ov_pkt_type_p4,
       o_pkt_bufid_wr_p4,
       
       ov_pkt_bufid_p5,
       ov_pkt_type_p5,
       o_pkt_bufid_wr_p5,
       
       ov_pkt_bufid_p6,
       ov_pkt_type_p6,
       o_pkt_bufid_wr_p6,
       
       ov_pkt_bufid_p7,
       ov_pkt_type_p7,
       o_pkt_bufid_wr_p7,
       
       ov_pkt_bufid_host,
       ov_pkt_type_host,
       o_mac_entry_hit_host,
       ov_pkt_inport_host,
       o_pkt_bufid_wr_host,
       
       ov_pkt_bufid,        
       o_pkt_bufid_wr,      
       ov_pkt_bufid_cnt 	   
);

// I/O
// clk & rst
input             i_clk;                   //125Mhz
input             i_rst_n;
//************from tpa**************
// pkt_bufid and pkt_type to p0
input [8:0]       iv_pkt_bufid_p0_tpa;
input [2:0]       iv_pkt_type_p0_tpa;
input             i_pkt_bufid_wr_p0_tpa;
// pkt_bufid and pkt_type to p1   
input [8:0]       iv_pkt_bufid_p1_tpa;
input [2:0]       iv_pkt_type_p1_tpa;
input             i_pkt_bufid_wr_p1_tpa;
// pkt_bufid and pkt_type to p2    
input [8:0]       iv_pkt_bufid_p2_tpa;
input [2:0]       iv_pkt_type_p2_tpa;
input             i_pkt_bufid_wr_p2_tpa;
// pkt_bufid and pkt_type to p3    
input [8:0]       iv_pkt_bufid_p3_tpa;
input [2:0]       iv_pkt_type_p3_tpa;
input             i_pkt_bufid_wr_p3_tpa;
// pkt_bufid and pkt_type to p4    
input [8:0]       iv_pkt_bufid_p4_tpa;
input [2:0]       iv_pkt_type_p4_tpa;
input             i_pkt_bufid_wr_p4_tpa;
// pkt_bufid and pkt_type to p5    
input [8:0]       iv_pkt_bufid_p5_tpa;
input [2:0]       iv_pkt_type_p5_tpa;
input             i_pkt_bufid_wr_p5_tpa;
// pkt_bufid and pkt_type to p6    
input [8:0]       iv_pkt_bufid_p6_tpa;
input [2:0]       iv_pkt_type_p6_tpa;
input             i_pkt_bufid_wr_p6_tpa;
// pkt_bufid and pkt_type to p7    
input [8:0]       iv_pkt_bufid_p7_tpa;
input [2:0]       iv_pkt_type_p7_tpa;
input             i_pkt_bufid_wr_p7_tpa;
// pkt_bufid and pkt_type to host      
input [8:0]       iv_pkt_bufid_host_tpa;
input [2:0]       iv_pkt_type_host_tpa;
input [3:0]       iv_pkt_inport_host_tpa;
input             i_pkt_bufid_wr_host_tpa;
//forward cnt to pkt_centralize_bufm_memory
input [8:0]       iv_pkt_bufid_tpa;
input             i_pkt_bufid_wr_tpa;
input [3:0]       iv_pkt_bufid_cnt_tpa;
//************from spa**************
// pkt_bufid and pkt_type to p0
input [8:0]       iv_pkt_bufid_p0_spa;
input [2:0]       iv_pkt_type_p0_spa;
input             i_pkt_bufid_req_p0_spa;
output reg        o_pkt_bufid_ack_p0_spa;
// pkt_bufid and pkt_type to p1   
input [8:0]       iv_pkt_bufid_p1_spa;
input [2:0]       iv_pkt_type_p1_spa;
input             i_pkt_bufid_req_p1_spa;
output reg        o_pkt_bufid_ack_p1_spa;
// pkt_bufid and pkt_type to p2    
input [8:0]       iv_pkt_bufid_p2_spa;
input [2:0]       iv_pkt_type_p2_spa;
input             i_pkt_bufid_req_p2_spa;
output reg        o_pkt_bufid_ack_p2_spa;
// pkt_bufid and pkt_type to p3    
input [8:0]       iv_pkt_bufid_p3_spa;
input [2:0]       iv_pkt_type_p3_spa;
input             i_pkt_bufid_req_p3_spa;
output reg        o_pkt_bufid_ack_p3_spa;
// pkt_bufid and pkt_type to p4    
input [8:0]       iv_pkt_bufid_p4_spa;
input [2:0]       iv_pkt_type_p4_spa;
input             i_pkt_bufid_req_p4_spa;
output reg        o_pkt_bufid_ack_p4_spa;
// pkt_bufid and pkt_type to p5    
input [8:0]       iv_pkt_bufid_p5_spa;
input [2:0]       iv_pkt_type_p5_spa;
input             i_pkt_bufid_req_p5_spa;
output reg        o_pkt_bufid_ack_p5_spa;
// pkt_bufid and pkt_type to p6    
input [8:0]       iv_pkt_bufid_p6_spa;
input [2:0]       iv_pkt_type_p6_spa;
input             i_pkt_bufid_req_p6_spa;
output reg        o_pkt_bufid_ack_p6_spa;
// pkt_bufid and pkt_type to p7    
input [8:0]       iv_pkt_bufid_p7_spa;
input [2:0]       iv_pkt_type_p7_spa;
input             i_pkt_bufid_req_p7_spa;
output reg        o_pkt_bufid_ack_p7_spa;
// pkt_bufid and pkt_type to host      
input [8:0]       iv_pkt_bufid_host_spa;
input [2:0]       iv_pkt_type_host_spa;
input             i_mac_entry_hit_spa;
input [3:0]       iv_pkt_inport_host_spa;
input             i_pkt_bufid_req_host_spa;
output reg        o_pkt_bufid_ack_host_spa;
//forward cnt to pkt_centralize_bufm_memory
input [8:0]       iv_pkt_bufid_spa;
input             i_pkt_bufid_req_spa;
output reg        o_pkt_bufid_ack_spa;
input [3:0]       iv_pkt_bufid_cnt_spa;
//************output**************
// pkt_bufid and pkt_type to p0
output reg [8:0]       ov_pkt_bufid_p0;
output reg [2:0]       ov_pkt_type_p0;
output reg             o_pkt_bufid_wr_p0;
// pkt_bufid and pkt_type to p1   
output reg [8:0]       ov_pkt_bufid_p1;
output reg [2:0]       ov_pkt_type_p1;
output reg             o_pkt_bufid_wr_p1;
// pkt_bufid and pkt_type to p2    
output reg [8:0]       ov_pkt_bufid_p2;
output reg [2:0]       ov_pkt_type_p2;
output reg             o_pkt_bufid_wr_p2;
// pkt_bufid and pkt_type to p3    
output reg [8:0]       ov_pkt_bufid_p3;
output reg [2:0]       ov_pkt_type_p3;
output reg             o_pkt_bufid_wr_p3;
// pkt_bufid and pkt_type to p4    
output reg [8:0]       ov_pkt_bufid_p4;
output reg [2:0]       ov_pkt_type_p4;
output reg             o_pkt_bufid_wr_p4;
// pkt_bufid and pkt_type to p5    
output reg [8:0]       ov_pkt_bufid_p5;
output reg [2:0]       ov_pkt_type_p5;
output reg             o_pkt_bufid_wr_p5;
// pkt_bufid and pkt_type to p6    
output reg [8:0]       ov_pkt_bufid_p6;
output reg [2:0]       ov_pkt_type_p6;
output reg             o_pkt_bufid_wr_p6;
// pkt_bufid and pkt_type to p7    
output reg [8:0]       ov_pkt_bufid_p7;
output reg [2:0]       ov_pkt_type_p7;
output reg             o_pkt_bufid_wr_p7;
// pkt_bufid and pkt_type to host      
output reg [8:0]       ov_pkt_bufid_host;
output reg [2:0]       ov_pkt_type_host;
output reg             o_mac_entry_hit_host;
output reg [3:0]       ov_pkt_inport_host;
output reg             o_pkt_bufid_wr_host;
//forward cnt to pkt_centralize_bufm_memory
output reg [8:0]       ov_pkt_bufid;
output reg             o_pkt_bufid_wr;
output reg [3:0]       ov_pkt_bufid_cnt;
//////////////////////////////////////////////////
//              forward                         //
//////////////////////////////////////////////////
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
	    o_pkt_bufid_ack_p0_spa    <= 1'b0;
		o_pkt_bufid_ack_p1_spa    <= 1'b0;
		o_pkt_bufid_ack_p2_spa    <= 1'b0;
		o_pkt_bufid_ack_p3_spa    <= 1'b0;
		o_pkt_bufid_ack_p4_spa    <= 1'b0;
		o_pkt_bufid_ack_p5_spa    <= 1'b0;
		o_pkt_bufid_ack_p6_spa    <= 1'b0;
		o_pkt_bufid_ack_p7_spa    <= 1'b0;
		o_pkt_bufid_ack_host_spa  <= 1'b0;
		o_pkt_bufid_ack_spa       <= 1'b0; 
		 
        ov_pkt_bufid_p0      <= 9'h0;
        ov_pkt_type_p0       <= 3'h0;
        o_pkt_bufid_wr_p0    <= 1'h0;
                            
        ov_pkt_bufid_p1      <= 9'h0;
        ov_pkt_type_p1       <= 3'h0;
        o_pkt_bufid_wr_p1    <= 1'h0;
                             
        ov_pkt_bufid_p2      <= 9'h0;
        ov_pkt_type_p2       <= 3'h0;
        o_pkt_bufid_wr_p2    <= 1'h0;
        
        ov_pkt_bufid_p3      <= 9'h0;
        ov_pkt_type_p3       <= 3'h0;
        o_pkt_bufid_wr_p3    <= 1'h0;
        
        ov_pkt_bufid_p4      <= 9'h0;
        ov_pkt_type_p4       <= 3'h0;
        o_pkt_bufid_wr_p4    <= 1'h0;
        
        ov_pkt_bufid_p5      <= 9'h0;
        ov_pkt_type_p5       <= 3'h0;
        o_pkt_bufid_wr_p5    <= 1'h0;
        
        ov_pkt_bufid_p6      <= 9'h0;
        ov_pkt_type_p6       <= 3'h0;
        o_pkt_bufid_wr_p6    <= 1'h0;
        
        ov_pkt_bufid_p7      <= 9'h0;
        ov_pkt_type_p7       <= 3'h0;
        o_pkt_bufid_wr_p7    <= 1'h0;
                            
        ov_pkt_bufid_host    <= 9'h0;
        ov_pkt_type_host     <= 3'h0;
        o_mac_entry_hit_host <= 1'h0;
        ov_pkt_inport_host   <= 4'h0;
        o_pkt_bufid_wr_host  <= 1'h0;
                                     
        ov_pkt_bufid         <= 9'h0;
        o_pkt_bufid_wr       <= 1'h0;
        ov_pkt_bufid_cnt     <= 4'h0;
    end                              
    else begin
        if(i_pkt_bufid_wr_p0_tpa|i_pkt_bufid_wr_p1_tpa|i_pkt_bufid_wr_p2_tpa|i_pkt_bufid_wr_p3_tpa|i_pkt_bufid_wr_p4_tpa|i_pkt_bufid_wr_p5_tpa|i_pkt_bufid_wr_p6_tpa|i_pkt_bufid_wr_p7_tpa|i_pkt_bufid_wr_host_tpa)begin
			ov_pkt_bufid_p0      <= iv_pkt_bufid_p0_tpa;
			ov_pkt_type_p0       <= iv_pkt_type_p0_tpa;
			o_pkt_bufid_wr_p0    <= i_pkt_bufid_wr_p0_tpa;
								
			ov_pkt_bufid_p1      <= iv_pkt_bufid_p1_tpa;
			ov_pkt_type_p1       <= iv_pkt_type_p1_tpa;
			o_pkt_bufid_wr_p1    <= i_pkt_bufid_wr_p1_tpa;
								 
			ov_pkt_bufid_p2      <= iv_pkt_bufid_p2_tpa;
			ov_pkt_type_p2       <= iv_pkt_type_p2_tpa;
			o_pkt_bufid_wr_p2    <= i_pkt_bufid_wr_p2_tpa;
			
			ov_pkt_bufid_p3      <= iv_pkt_bufid_p3_tpa;
			ov_pkt_type_p3       <= iv_pkt_type_p3_tpa;
			o_pkt_bufid_wr_p3    <= i_pkt_bufid_wr_p3_tpa;
			
			ov_pkt_bufid_p4      <= iv_pkt_bufid_p4_tpa;
			ov_pkt_type_p4       <= iv_pkt_type_p4_tpa;
			o_pkt_bufid_wr_p4    <= i_pkt_bufid_wr_p4_tpa;
			
			ov_pkt_bufid_p5      <= iv_pkt_bufid_p5_tpa;
			ov_pkt_type_p5       <= iv_pkt_type_p5_tpa;
			o_pkt_bufid_wr_p5    <= i_pkt_bufid_wr_p5_tpa;
			
			ov_pkt_bufid_p6      <= iv_pkt_bufid_p6_tpa;
			ov_pkt_type_p6       <= iv_pkt_type_p6_tpa;
			o_pkt_bufid_wr_p6    <= i_pkt_bufid_wr_p6_tpa;
			
			ov_pkt_bufid_p7      <= iv_pkt_bufid_p7_tpa;
			ov_pkt_type_p7       <= iv_pkt_type_p7_tpa;
			o_pkt_bufid_wr_p7    <= i_pkt_bufid_wr_p7_tpa;
								
			ov_pkt_bufid_host    <= iv_pkt_bufid_host_tpa;
			ov_pkt_type_host     <= iv_pkt_type_host_tpa;
			o_mac_entry_hit_host <= 1'b1;//default value is 1.
			ov_pkt_inport_host   <= iv_pkt_inport_host_tpa;
			o_pkt_bufid_wr_host  <= i_pkt_bufid_wr_host_tpa;
										 
			ov_pkt_bufid         <= iv_pkt_bufid_tpa;
			o_pkt_bufid_wr       <= i_pkt_bufid_wr_tpa;
			ov_pkt_bufid_cnt     <= iv_pkt_bufid_cnt_tpa;	

			o_pkt_bufid_ack_p0_spa    <= 1'b0;
			o_pkt_bufid_ack_p1_spa    <= 1'b0;
			o_pkt_bufid_ack_p2_spa    <= 1'b0;
			o_pkt_bufid_ack_p3_spa    <= 1'b0;
			o_pkt_bufid_ack_p4_spa    <= 1'b0;
			o_pkt_bufid_ack_p5_spa    <= 1'b0;
			o_pkt_bufid_ack_p6_spa    <= 1'b0;
			o_pkt_bufid_ack_p7_spa    <= 1'b0;
			o_pkt_bufid_ack_host_spa  <= 1'b0;
			o_pkt_bufid_ack_spa       <= 1'b0; 			
        end
        else if((i_pkt_bufid_req_p0_spa&!o_pkt_bufid_ack_p0_spa)|(i_pkt_bufid_req_p1_spa&!o_pkt_bufid_ack_p1_spa)|(i_pkt_bufid_req_p2_spa&!o_pkt_bufid_ack_p2_spa)|(i_pkt_bufid_req_p3_spa&!o_pkt_bufid_ack_p3_spa)|(i_pkt_bufid_req_p4_spa&!o_pkt_bufid_ack_p4_spa)|(i_pkt_bufid_req_p5_spa&!o_pkt_bufid_ack_p5_spa)|(i_pkt_bufid_req_p6_spa&!o_pkt_bufid_ack_p6_spa)|(i_pkt_bufid_req_p7_spa&!o_pkt_bufid_ack_p7_spa)|(i_pkt_bufid_req_host_spa&!o_pkt_bufid_ack_host_spa))begin
			ov_pkt_bufid_p0      <= iv_pkt_bufid_p0_spa;
			ov_pkt_type_p0       <= iv_pkt_type_p0_spa;
			o_pkt_bufid_wr_p0    <= i_pkt_bufid_req_p0_spa;
								
			ov_pkt_bufid_p1      <= iv_pkt_bufid_p1_spa;
			ov_pkt_type_p1       <= iv_pkt_type_p1_spa;
			o_pkt_bufid_wr_p1    <= i_pkt_bufid_req_p1_spa;
								 
			ov_pkt_bufid_p2      <= iv_pkt_bufid_p2_spa;
			ov_pkt_type_p2       <= iv_pkt_type_p2_spa;
			o_pkt_bufid_wr_p2    <= i_pkt_bufid_req_p2_spa;
			
			ov_pkt_bufid_p3      <= iv_pkt_bufid_p3_spa;
			ov_pkt_type_p3       <= iv_pkt_type_p3_spa;
			o_pkt_bufid_wr_p3    <= i_pkt_bufid_req_p3_spa;
			
			ov_pkt_bufid_p4      <= iv_pkt_bufid_p4_spa;
			ov_pkt_type_p4       <= iv_pkt_type_p4_spa;
			o_pkt_bufid_wr_p4    <= i_pkt_bufid_req_p4_spa;
			
			ov_pkt_bufid_p5      <= iv_pkt_bufid_p5_spa;
			ov_pkt_type_p5       <= iv_pkt_type_p5_spa;
			o_pkt_bufid_wr_p5    <= i_pkt_bufid_req_p5_spa;
			
			ov_pkt_bufid_p6      <= iv_pkt_bufid_p6_spa;
			ov_pkt_type_p6       <= iv_pkt_type_p6_spa;
			o_pkt_bufid_wr_p6    <= i_pkt_bufid_req_p6_spa;
			
			ov_pkt_bufid_p7      <= iv_pkt_bufid_p7_spa;
			ov_pkt_type_p7       <= iv_pkt_type_p7_spa;
			o_pkt_bufid_wr_p7    <= i_pkt_bufid_req_p7_spa;
								
			ov_pkt_bufid_host    <= iv_pkt_bufid_host_spa;
			ov_pkt_type_host     <= iv_pkt_type_host_spa;
			o_mac_entry_hit_host <= i_mac_entry_hit_spa;
			ov_pkt_inport_host   <= iv_pkt_inport_host_spa;
			o_pkt_bufid_wr_host  <= i_pkt_bufid_req_host_spa;
										 
			ov_pkt_bufid         <= iv_pkt_bufid_spa;
			o_pkt_bufid_wr       <= i_pkt_bufid_req_spa;
			ov_pkt_bufid_cnt     <= iv_pkt_bufid_cnt_spa;	

			o_pkt_bufid_ack_p0_spa    <= i_pkt_bufid_req_p0_spa;
			o_pkt_bufid_ack_p1_spa    <= i_pkt_bufid_req_p1_spa;
			o_pkt_bufid_ack_p2_spa    <= i_pkt_bufid_req_p2_spa;
			o_pkt_bufid_ack_p3_spa    <= i_pkt_bufid_req_p3_spa;
			o_pkt_bufid_ack_p4_spa    <= i_pkt_bufid_req_p4_spa;
			o_pkt_bufid_ack_p5_spa    <= i_pkt_bufid_req_p5_spa;
			o_pkt_bufid_ack_p6_spa    <= i_pkt_bufid_req_p6_spa;
			o_pkt_bufid_ack_p7_spa    <= i_pkt_bufid_req_p7_spa;
			o_pkt_bufid_ack_host_spa  <= i_pkt_bufid_req_host_spa;
			o_pkt_bufid_ack_spa       <= i_pkt_bufid_req_spa; 			
        end
        else begin
			o_pkt_bufid_ack_p0_spa    <= 1'b0;
			o_pkt_bufid_ack_p1_spa    <= 1'b0;
			o_pkt_bufid_ack_p2_spa    <= 1'b0;
			o_pkt_bufid_ack_p3_spa    <= 1'b0;
			o_pkt_bufid_ack_p4_spa    <= 1'b0;
			o_pkt_bufid_ack_p5_spa    <= 1'b0;
			o_pkt_bufid_ack_p6_spa    <= 1'b0;
			o_pkt_bufid_ack_p7_spa    <= 1'b0;
			o_pkt_bufid_ack_host_spa  <= 1'b0;
			o_pkt_bufid_ack_spa       <= 1'b0; 
			 
			ov_pkt_bufid_p0      <= 9'h0;
			ov_pkt_type_p0       <= 3'h0;
			o_pkt_bufid_wr_p0    <= 1'h0;
								
			ov_pkt_bufid_p1      <= 9'h0;
			ov_pkt_type_p1       <= 3'h0;
			o_pkt_bufid_wr_p1    <= 1'h0;
								 
			ov_pkt_bufid_p2      <= 9'h0;
			ov_pkt_type_p2       <= 3'h0;
			o_pkt_bufid_wr_p2    <= 1'h0;
			
			ov_pkt_bufid_p3      <= 9'h0;
			ov_pkt_type_p3       <= 3'h0;
			o_pkt_bufid_wr_p3    <= 1'h0;
			
			ov_pkt_bufid_p4      <= 9'h0;
			ov_pkt_type_p4       <= 3'h0;
			o_pkt_bufid_wr_p4    <= 1'h0;
			
			ov_pkt_bufid_p5      <= 9'h0;
			ov_pkt_type_p5       <= 3'h0;
			o_pkt_bufid_wr_p5    <= 1'h0;
			
			ov_pkt_bufid_p6      <= 9'h0;
			ov_pkt_type_p6       <= 3'h0;
			o_pkt_bufid_wr_p6    <= 1'h0;
			
			ov_pkt_bufid_p7      <= 9'h0;
			ov_pkt_type_p7       <= 3'h0;
			o_pkt_bufid_wr_p7    <= 1'h0;
								
			ov_pkt_bufid_host    <= 9'h0;
			ov_pkt_type_host     <= 3'h0;
			o_mac_entry_hit_host <= 1'h0;
			ov_pkt_inport_host   <= 4'h0;
			o_pkt_bufid_wr_host  <= 1'h0;
										 
			ov_pkt_bufid         <= 9'h0;
			o_pkt_bufid_wr       <= 1'h0;
			ov_pkt_bufid_cnt     <= 4'h0;
        end
    end
end
endmodule