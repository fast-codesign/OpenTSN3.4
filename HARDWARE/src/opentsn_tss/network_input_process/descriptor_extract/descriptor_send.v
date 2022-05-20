// Copyright (C) 1953-2020 NUDT
// Verilog module name - descriptor_send
// Version: DES_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         Descriptor Send
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module descriptor_send(
        i_clk,
        i_rst_n,
        
        i_descriptor_valid,
        iv_descriptor,  
        i_pkt_bufid_wr,
        iv_pkt_bufid,
        o_pkt_bufid_ack,
        
        o_pkt_bufid_wr,
        ov_pkt_bufid,
        o_descriptor_wr,
        ov_descriptor,
        i_descriptor_ack,    

        descriptor_send_state
    );

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
//input
input                   i_descriptor_valid;
input       [71:0]      iv_descriptor;
input                   i_pkt_bufid_wr;
input       [8:0]       iv_pkt_bufid;
output  reg             o_pkt_bufid_ack;
//output
output  reg             o_pkt_bufid_wr;
output  reg [8:0]       ov_pkt_bufid;
output  reg             o_descriptor_wr;
output  reg [71:0]      ov_descriptor;
input                   i_descriptor_ack; 
output  reg [1:0]       descriptor_send_state;

//temp ov_descriptor and ov_pkt for discarding pkt while the fifo_used_findows is over the threshold 
//internal wire&reg
localparam  idle_s          = 2'b00,
            wait_des_ack_s  = 2'b10;
        
always@(posedge i_clk or negedge i_rst_n)
    if(!i_rst_n) begin
        o_pkt_bufid_ack     <= 1'b0;
        o_pkt_bufid_wr      <= 1'b0;
        ov_pkt_bufid        <= 9'b0;        
        o_descriptor_wr     <= 1'b0;
        ov_descriptor       <= 72'b0;
        descriptor_send_state       <= idle_s;
    end
    else begin
        case(descriptor_send_state)
            idle_s:begin
                    if(i_pkt_bufid_wr == 1'b1 && i_descriptor_valid == 1'b1)begin//when descriptor come,pkt_bufid_wr have been already
                        o_pkt_bufid_ack     <= 1'b1;
                        o_pkt_bufid_wr      <= i_pkt_bufid_wr;
                        ov_pkt_bufid        <= iv_pkt_bufid;
                        ov_descriptor[71:9] <= iv_descriptor[71:9];
                        ov_descriptor[8:0]  <= iv_pkt_bufid;
                        o_descriptor_wr     <= 1'b1;
                        descriptor_send_state       <= wait_des_ack_s;
                    end
                    else if(i_pkt_bufid_wr == 1'b0 && i_descriptor_valid == 1'b1)begin
                        o_pkt_bufid_ack     <= 1'b0;
                        o_pkt_bufid_wr      <= 1'b0;
                        ov_pkt_bufid        <= 9'b0;
                        o_descriptor_wr     <= 1'b0;
                        ov_descriptor       <= 72'b0;
                        descriptor_send_state       <= idle_s;  
                    end
                    else begin
                        o_pkt_bufid_ack     <= 1'b0;
                        o_pkt_bufid_wr      <= 1'b0;
                        ov_pkt_bufid        <= 9'b0;
                        o_descriptor_wr     <= 1'b0;
                        ov_descriptor       <= 72'b0;                                       
                        descriptor_send_state       <= idle_s;
                    end
                end
                
            wait_des_ack_s:begin
                o_pkt_bufid_ack     <= 1'b0;
                o_pkt_bufid_wr      <= 1'b0;
                ov_pkt_bufid        <= 9'b0;            
                if(i_descriptor_ack == 1'b1) begin
                    ov_descriptor          <= 72'b0;
                    o_descriptor_wr        <= 1'b0;
                    descriptor_send_state  <= idle_s;
                    end
                else begin
                    ov_descriptor          <= ov_descriptor;
                    o_descriptor_wr        <= o_descriptor_wr;
                    descriptor_send_state  <= wait_des_ack_s;
                    end
                
                end
            default:begin
                o_pkt_bufid_ack     <= 1'b0;
                o_pkt_bufid_wr      <= 1'b0;
                ov_pkt_bufid        <= 9'b0;        
                o_descriptor_wr     <= 1'b0;
                ov_descriptor       <= 72'b0;
                descriptor_send_state       <= idle_s;
                end
        endcase
    end
endmodule