// Copyright (C) 1953-2020 NUDT
// Verilog module name - time_division_multiplexing 
// Version:TDM_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         time division multiplexing for receive descriptor come from network port and host port
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module time_division_multiplexing
(
       i_clk,
       i_rst_n,
              
       iv_descriptor_p0,
       i_descriptor_wr_p0,
       o_descriptor_ack_p0,
       
       iv_descriptor_p1,
       i_descriptor_wr_p1,
       o_descriptor_ack_p1,
       
       iv_descriptor_p2,
       i_descriptor_wr_p2,
       o_descriptor_ack_p2,
       
       iv_descriptor_p3,
       i_descriptor_wr_p3,
       o_descriptor_ack_p3,
       
       iv_descriptor_p4,
       i_descriptor_wr_p4,
       o_descriptor_ack_p4,
       
       iv_descriptor_p5,
       i_descriptor_wr_p5,
       o_descriptor_ack_p5,
       
       iv_descriptor_p6,
       i_descriptor_wr_p6,
       o_descriptor_ack_p6,
       
       iv_descriptor_p7,
       i_descriptor_wr_p7,
       o_descriptor_ack_p7,
       
       iv_descriptor_host_ts,
       i_descriptor_wr_host_ts,
       o_descriptor_ack_host_ts,
       
       iv_descriptor_host_rc_be,
       i_descriptor_wr_host_rc_be,
       o_descriptor_ack_host_rc_be,
       
       ov_descriptor,
       o_descriptor_wr,
       
       ov_tdm_state
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
// descriptor from p0
input      [71:0]      iv_descriptor_p0;
input                  i_descriptor_wr_p0;
output reg             o_descriptor_ack_p0;
// descriptor from p1      
input      [71:0]      iv_descriptor_p1;
input                  i_descriptor_wr_p1;
output reg             o_descriptor_ack_p1;
// descriptor from p2      
input      [71:0]      iv_descriptor_p2;
input                  i_descriptor_wr_p2;
output reg             o_descriptor_ack_p2;
// descriptor from p3      
input      [71:0]      iv_descriptor_p3;
input                  i_descriptor_wr_p3;
output reg             o_descriptor_ack_p3;
// descriptor from p4      
input      [71:0]      iv_descriptor_p4;
input                  i_descriptor_wr_p4;
output reg             o_descriptor_ack_p4;
// descriptor from p5      
input      [71:0]      iv_descriptor_p5;
input                  i_descriptor_wr_p5;
output reg             o_descriptor_ack_p5;
// descriptor from p6      
input      [71:0]      iv_descriptor_p6;
input                  i_descriptor_wr_p6;
output reg             o_descriptor_ack_p6;
// descriptor from p7      
input      [71:0]      iv_descriptor_p7;
input                  i_descriptor_wr_p7;
output reg             o_descriptor_ack_p7;
// descriptor of ts frame from host    
input      [71:0]      iv_descriptor_host_ts;
input                  i_descriptor_wr_host_ts;
output reg             o_descriptor_ack_host_ts;
// descriptor of rc and be frame from host      
input      [71:0]      iv_descriptor_host_rc_be;
input                  i_descriptor_wr_host_rc_be;
output reg             o_descriptor_ack_host_rc_be;
// descriptor to lookup_table   
output reg [71:0]      ov_descriptor;
output reg             o_descriptor_wr;

output reg [3:0]       ov_tdm_state;
//////////////////////////////////////////////////
//                  state                       //
//////////////////////////////////////////////////
// allocate slots for each interface
// process the corresponding interface in the slot

localparam             IDLE_S        = 4'd0,
                       SLOT1_S       = 4'd1,
                       SLOT2_S       = 4'd2,
                       SLOT3_S       = 4'd3,
                       SLOT4_S       = 4'd4,
                       SLOT5_S       = 4'd5,
                       SLOT6_S       = 4'd6,
                       SLOT7_S       = 4'd7,
                       SLOT8_S       = 4'd8,
                       SLOT9_S       = 4'd9;

always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_descriptor               <= 72'h0;
        o_descriptor_wr             <= 1'h0;
        o_descriptor_ack_p0         <= 1'h0;
        o_descriptor_ack_p1         <= 1'h0;
        o_descriptor_ack_p2         <= 1'h0;
        o_descriptor_ack_p3         <= 1'h0;
        o_descriptor_ack_p4         <= 1'h0;
        o_descriptor_ack_p5         <= 1'h0;
        o_descriptor_ack_p6         <= 1'h0;
        o_descriptor_ack_p7         <= 1'h0;    
        o_descriptor_ack_host_ts    <= 1'h0;
        o_descriptor_ack_host_rc_be <= 1'h0;
        
        ov_tdm_state                   <= IDLE_S;
    end
    else begin
        case(ov_tdm_state)
            IDLE_S:begin//slot0 for port0
                o_descriptor_ack_p1         <= 1'h0;
                o_descriptor_ack_p2         <= 1'h0;
                o_descriptor_ack_p3         <= 1'h0;
                o_descriptor_ack_p4         <= 1'h0;
                o_descriptor_ack_p5         <= 1'h0;
                o_descriptor_ack_p6         <= 1'h0;
                o_descriptor_ack_p7         <= 1'h0;
                o_descriptor_ack_host_ts    <= 1'h0;
                o_descriptor_ack_host_rc_be <= 1'h0;
                
                ov_tdm_state                   <= SLOT1_S;
                if(i_descriptor_wr_p0 == 1'b1)begin
                    ov_descriptor               <= iv_descriptor_p0;
                    o_descriptor_wr             <= 1'h1;
                    o_descriptor_ack_p0         <= 1'h1;
                end     
                else begin      
                    ov_descriptor               <= 72'h0;
                    o_descriptor_wr             <= 1'h0;
                    o_descriptor_ack_p0         <= 1'h0;
                end 
            end
            
            SLOT1_S:begin//slot1 for port1
                o_descriptor_ack_p0         <= 1'h0;
                o_descriptor_ack_p2         <= 1'h0;
                o_descriptor_ack_p3         <= 1'h0;
                o_descriptor_ack_p4         <= 1'h0;
                o_descriptor_ack_p5         <= 1'h0;
                o_descriptor_ack_p6         <= 1'h0;
                o_descriptor_ack_p7         <= 1'h0;
                o_descriptor_ack_host_ts    <= 1'h0;
                o_descriptor_ack_host_rc_be <= 1'h0;
                
                ov_tdm_state                   <= SLOT2_S;
                if(i_descriptor_wr_p1 == 1'b1)begin
                    ov_descriptor               <= iv_descriptor_p1;
                    o_descriptor_wr             <= 1'h1;
                    o_descriptor_ack_p1         <= 1'h1;
                end     
                else begin      
                    ov_descriptor               <= 72'h0;
                    o_descriptor_wr             <= 1'h0;
                    o_descriptor_ack_p1         <= 1'h0;
                end
            end
            
            SLOT2_S:begin//slot2 for port2
                o_descriptor_ack_p0         <= 1'h0;
                o_descriptor_ack_p1         <= 1'h0;
                o_descriptor_ack_p3         <= 1'h0;
                o_descriptor_ack_p4         <= 1'h0;
                o_descriptor_ack_p5         <= 1'h0;
                o_descriptor_ack_p6         <= 1'h0;
                o_descriptor_ack_p7         <= 1'h0;
                o_descriptor_ack_host_ts    <= 1'h0;
                o_descriptor_ack_host_rc_be <= 1'h0;
                
                ov_tdm_state                   <= SLOT3_S;
                if(i_descriptor_wr_p2 == 1'b1)begin
                    ov_descriptor               <= iv_descriptor_p2;
                    o_descriptor_wr             <= 1'h1;
                    o_descriptor_ack_p2         <= 1'h1;
                end     
                else begin      
                    ov_descriptor               <= 72'h0;
                    o_descriptor_wr             <= 1'h0;
                    o_descriptor_ack_p2         <= 1'h0;
                end
            end
            
            SLOT3_S:begin//slot3 for port3
                o_descriptor_ack_p0         <= 1'h0;
                o_descriptor_ack_p1         <= 1'h0;
                o_descriptor_ack_p2         <= 1'h0;
                o_descriptor_ack_p4         <= 1'h0;
                o_descriptor_ack_p5         <= 1'h0;
                o_descriptor_ack_p6         <= 1'h0;
                o_descriptor_ack_p7         <= 1'h0;
                o_descriptor_ack_host_ts    <= 1'h0;
                o_descriptor_ack_host_rc_be <= 1'h0;
                
                ov_tdm_state                   <= SLOT4_S;
                if(i_descriptor_wr_p3 == 1'b1)begin
                    ov_descriptor               <= iv_descriptor_p3;
                    o_descriptor_wr             <= 1'h1;
                    o_descriptor_ack_p3         <= 1'h1;
                end     
                else begin      
                    ov_descriptor               <= 72'h0;
                    o_descriptor_wr             <= 1'h0;
                    o_descriptor_ack_p3         <= 1'h0;
                end
            end
            
            SLOT4_S:begin//slot4 for port4
                o_descriptor_ack_p0         <= 1'h0;
                o_descriptor_ack_p1         <= 1'h0;
                o_descriptor_ack_p2         <= 1'h0;
                o_descriptor_ack_p3         <= 1'h0;
                o_descriptor_ack_p5         <= 1'h0;
                o_descriptor_ack_p6         <= 1'h0;
                o_descriptor_ack_p7         <= 1'h0;
                o_descriptor_ack_host_ts    <= 1'h0;
                o_descriptor_ack_host_rc_be <= 1'h0;
                
                ov_tdm_state                   <= SLOT5_S;
                if(i_descriptor_wr_p4 == 1'b1)begin
                    ov_descriptor               <= iv_descriptor_p4;
                    o_descriptor_wr             <= 1'h1;
                    o_descriptor_ack_p4         <= 1'h1;
                end     
                else begin      
                    ov_descriptor               <= 72'h0;
                    o_descriptor_wr             <= 1'h0;
                    o_descriptor_ack_p4         <= 1'h0;
                end
            end
            
            SLOT5_S:begin//slot5 for port5 
                o_descriptor_ack_p0         <= 1'h0;
                o_descriptor_ack_p1         <= 1'h0;
                o_descriptor_ack_p2         <= 1'h0;
                o_descriptor_ack_p3         <= 1'h0;
                o_descriptor_ack_p4         <= 1'h0;
                o_descriptor_ack_p6         <= 1'h0;
                o_descriptor_ack_p7         <= 1'h0;
                o_descriptor_ack_host_ts    <= 1'h0;
                o_descriptor_ack_host_rc_be <= 1'h0;
                
                ov_tdm_state                   <= SLOT6_S;
                if(i_descriptor_wr_p5 == 1'b1)begin
                    ov_descriptor               <= iv_descriptor_p5;
                    o_descriptor_wr             <= 1'h1;
                    o_descriptor_ack_p5         <= 1'h1;
                end     
                else begin      
                    ov_descriptor               <= 72'h0;
                    o_descriptor_wr             <= 1'h0;
                    o_descriptor_ack_p5         <= 1'h0;
                end
            end
                        
            SLOT6_S:begin//slot6 for port6
                o_descriptor_ack_p0         <= 1'h0;
                o_descriptor_ack_p1         <= 1'h0;
                o_descriptor_ack_p2         <= 1'h0;
                o_descriptor_ack_p3         <= 1'h0;
                o_descriptor_ack_p4         <= 1'h0;
                o_descriptor_ack_p5         <= 1'h0;
                o_descriptor_ack_p7         <= 1'h0;
                o_descriptor_ack_host_ts    <= 1'h0;
                o_descriptor_ack_host_rc_be <= 1'h0;
                
                ov_tdm_state                   <= SLOT7_S;
                if(i_descriptor_wr_p6 == 1'b1)begin
                    ov_descriptor               <= iv_descriptor_p6;
                    o_descriptor_wr             <= 1'h1;
                    o_descriptor_ack_p6         <= 1'h1;
                end     
                else begin      
                    ov_descriptor               <= 72'h0;
                    o_descriptor_wr             <= 1'h0;
                    o_descriptor_ack_p6         <= 1'h0;
                end
            end
            
            SLOT7_S:begin//slot7 for port7
                o_descriptor_ack_p0         <= 1'h0;
                o_descriptor_ack_p1         <= 1'h0;
                o_descriptor_ack_p2         <= 1'h0;
                o_descriptor_ack_p3         <= 1'h0;
                o_descriptor_ack_p4         <= 1'h0;
                o_descriptor_ack_p5         <= 1'h0;
                o_descriptor_ack_p6         <= 1'h0;
                o_descriptor_ack_host_ts    <= 1'h0;
                o_descriptor_ack_host_rc_be <= 1'h0;
                
                ov_tdm_state                   <= SLOT8_S;
                if(i_descriptor_wr_p7 == 1'b1)begin
                    ov_descriptor               <= iv_descriptor_p7;
                    o_descriptor_wr             <= 1'h1;
                    o_descriptor_ack_p7         <= 1'h1;
                end     
                else begin      
                    ov_descriptor               <= 72'h0;
                    o_descriptor_wr             <= 1'h0;
                    o_descriptor_ack_p7         <= 1'h0;
                end
            end
            
            SLOT8_S:begin//slot8 for host transmit TS
                o_descriptor_ack_p0         <= 1'h0;
                o_descriptor_ack_p1         <= 1'h0;
                o_descriptor_ack_p2         <= 1'h0;
                o_descriptor_ack_p3         <= 1'h0;
                o_descriptor_ack_p4         <= 1'h0;
                o_descriptor_ack_p5         <= 1'h0;
                o_descriptor_ack_p6         <= 1'h0;
                o_descriptor_ack_p7         <= 1'h0;
                o_descriptor_ack_host_rc_be <= 1'h0;
                
                ov_tdm_state                   <= SLOT9_S;
                if(i_descriptor_wr_host_ts == 1'b1)begin
                    ov_descriptor               <= iv_descriptor_host_ts;
                    o_descriptor_wr             <= 1'h1;
                    o_descriptor_ack_host_ts    <= 1'h1;
                end     
                else begin      
                    ov_descriptor               <= 72'h0;
                    o_descriptor_wr             <= 1'h0;
                    o_descriptor_ack_host_ts    <= 1'h0;
                end
            end
            
            SLOT9_S:begin//slot9 for host transmit RC and BE
                o_descriptor_ack_p0         <= 1'h0;
                o_descriptor_ack_p1         <= 1'h0;
                o_descriptor_ack_p2         <= 1'h0;
                o_descriptor_ack_p3         <= 1'h0;
                o_descriptor_ack_p4         <= 1'h0;
                o_descriptor_ack_p5         <= 1'h0;
                o_descriptor_ack_p6         <= 1'h0;
                o_descriptor_ack_p7         <= 1'h0;
                o_descriptor_ack_host_ts    <= 1'h0;
                
                ov_tdm_state                   <= IDLE_S;
                if(i_descriptor_wr_host_rc_be == 1'b1)begin
                    ov_descriptor               <= iv_descriptor_host_rc_be;
                    o_descriptor_wr             <= 1'h1;
                    o_descriptor_ack_host_rc_be <= 1'h1;
                end     
                else begin      
                    ov_descriptor               <= 72'h0;
                    o_descriptor_wr             <= 1'h0;
                    o_descriptor_ack_host_rc_be <= 1'h0;
                end
            end
            
            default:begin
                ov_descriptor               <= 72'h0;
                o_descriptor_wr             <= 1'h0;
                o_descriptor_ack_p0         <= 1'h0;
                o_descriptor_ack_p1         <= 1'h0;
                o_descriptor_ack_p2         <= 1'h0;
                o_descriptor_ack_p3         <= 1'h0;
                o_descriptor_ack_p4         <= 1'h0;
                o_descriptor_ack_p5         <= 1'h0;
                o_descriptor_ack_p6         <= 1'h0;
                o_descriptor_ack_p7         <= 1'h0;                
                o_descriptor_ack_host_ts    <= 1'h0;
                o_descriptor_ack_host_rc_be <= 1'h0;
            
                ov_tdm_state                   <= IDLE_S;
            end
        endcase
    end
end
endmodule