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

module descriptor_send#(parameter from_hcp_or_scp = 2'b01)//{scp,hcp}
(
        i_clk,
        i_rst_n,
        
        i_descriptor_valid,
        iv_descriptor, 
        iv_eth_type,        
        i_pkt_bufid_wr,
        iv_pkt_bufid,
        o_pkt_bufid_ack,
        
        o_pkt_bufid_wr,
        ov_pkt_bufid,
        o_descriptor_wr_to_host,
        o_descriptor_wr_to_hcp,
        o_descriptor_wr_to_network,
        ov_descriptor,
        o_inverse_map_lookup_flag,		
        i_descriptor_ack,    

        descriptor_send_state
    );

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
//input
input                   i_descriptor_valid;
input       [39:0]      iv_descriptor;
input       [15:0]      iv_eth_type;
input                   i_pkt_bufid_wr;
input       [8:0]       iv_pkt_bufid;
output  reg             o_pkt_bufid_ack;
//output
output  reg             o_pkt_bufid_wr;
output  reg [8:0]       ov_pkt_bufid;
output  reg             o_descriptor_wr_to_host;
output  reg             o_descriptor_wr_to_hcp;
output  reg             o_descriptor_wr_to_network;
output  reg [39:0]      ov_descriptor;
output  reg             o_inverse_map_lookup_flag;//1:lookup inverse mapping table;0:not lookup inverse mapping table.
input                   i_descriptor_ack; 
output  reg [1:0]       descriptor_send_state;

//temp ov_descriptor and ov_pkt for discarding pkt while the fifo_used_findows is over the threshold 
//internal wire&reg
reg         [3:0]  rv_cycle_cnt;
localparam  idle_s          = 2'b00,
            delay_transmit_to_host_s = 2'b01,
            delay_transmit_to_network_s = 2'b10,
            wait_des_ack_s  = 2'b11;
        
always@(posedge i_clk or negedge i_rst_n)
    if(!i_rst_n) begin
        o_pkt_bufid_ack     <= 1'b0;
        o_pkt_bufid_wr      <= 1'b0;
        ov_pkt_bufid        <= 9'b0;        
        o_descriptor_wr_to_host <= 1'b0;
        o_descriptor_wr_to_hcp <= 1'b0;
        o_descriptor_wr_to_network <= 1'b0;
        ov_descriptor       <= 40'b0;
        o_inverse_map_lookup_flag <= 1'b0;		
        rv_cycle_cnt <= 4'b0;
        descriptor_send_state       <= idle_s;
    end
    else begin
        case(descriptor_send_state)
            idle_s:begin
                    rv_cycle_cnt <= 4'b0;
                    if(i_pkt_bufid_wr == 1'b1 && i_descriptor_valid == 1'b1)begin//when descriptor come,pkt_bufid_wr have been already
                        o_pkt_bufid_wr      <= i_pkt_bufid_wr;
                        ov_pkt_bufid        <= iv_pkt_bufid;
                        ov_descriptor[30:0] <= iv_descriptor[31:0];
                        ov_descriptor[39:31]  <= iv_pkt_bufid;
                        if(iv_eth_type == 16'h1800)begin
                            o_inverse_map_lookup_flag <= 1'b1;
                        end
                        else begin
                            o_inverse_map_lookup_flag <= 1'b0;
                        end                     												
                        if((iv_eth_type == 16'h891d)||(iv_eth_type == 16'h88f7) || (iv_eth_type == 16'hff01))begin
                            o_descriptor_wr_to_host <= 1'b0;
                            o_descriptor_wr_to_hcp <= 1'b0;
                            o_descriptor_wr_to_network <= 1'b0;
                            o_pkt_bufid_ack <= 1'b1;
                            descriptor_send_state <= delay_transmit_to_network_s;
                        end
                        else begin
                            o_descriptor_wr_to_host <= 1'b0;
                            o_descriptor_wr_to_hcp <= 1'b0;
                            o_descriptor_wr_to_network <= 1'b0;
                            o_pkt_bufid_ack <= 1'b1;
                            descriptor_send_state <= delay_transmit_to_host_s;
                        end                        
                    end
                    else if(i_pkt_bufid_wr == 1'b0 && i_descriptor_valid == 1'b1)begin
                        o_pkt_bufid_ack     <= 1'b0;
                        o_pkt_bufid_wr      <= 1'b0;
                        ov_pkt_bufid        <= 9'b0;
                        o_descriptor_wr_to_host <= 1'b0;
                        o_descriptor_wr_to_hcp <= 1'b0;
                        o_descriptor_wr_to_network <= 1'b0;
                        ov_descriptor       <= 40'b0;
                        descriptor_send_state       <= idle_s;  
                    end
                    else begin
                        o_pkt_bufid_ack     <= 1'b0;
                        o_pkt_bufid_wr      <= 1'b0;
                        ov_pkt_bufid        <= 9'b0;
                        o_descriptor_wr_to_host <= 1'b0;
                        o_descriptor_wr_to_hcp <= 1'b0;
                        o_descriptor_wr_to_network <= 1'b0;
                        ov_descriptor       <= 40'b0;                                       
                        descriptor_send_state       <= idle_s;
                    end
                end
            delay_transmit_to_host_s:begin
                o_pkt_bufid_wr  <= 1'b0;
                ov_pkt_bufid    <= 9'b0;   
                o_pkt_bufid_ack <= 1'b0;
                rv_cycle_cnt <= rv_cycle_cnt + 4'b1;
                if(rv_cycle_cnt == 4'hf)begin
                    o_descriptor_wr_to_host <= 1'b1;
                    o_descriptor_wr_to_hcp  <= 1'b0;
                    o_descriptor_wr_to_network <= 1'b0;                
                    descriptor_send_state   <= wait_des_ack_s;
                end
                else begin
                    descriptor_send_state   <= delay_transmit_to_host_s;
                end
            end
            delay_transmit_to_network_s:begin
                o_pkt_bufid_wr      <= 1'b0;
                ov_pkt_bufid        <= 9'b0;   
                o_pkt_bufid_ack <= 1'b0;
                rv_cycle_cnt <= rv_cycle_cnt + 4'b1;
                if(rv_cycle_cnt == 4'hf)begin
                    o_descriptor_wr_to_host <= 1'b0;
                    o_descriptor_wr_to_hcp <= ~from_hcp_or_scp[0];
                    o_descriptor_wr_to_network <= ~from_hcp_or_scp[1];              
                    descriptor_send_state       <= wait_des_ack_s;
                end
                else begin
                    descriptor_send_state       <= delay_transmit_to_network_s;
                end
            end              
            wait_des_ack_s:begin
                o_pkt_bufid_ack     <= 1'b0;
                o_pkt_bufid_wr      <= 1'b0;
                ov_pkt_bufid        <= 9'b0;            
                if(i_descriptor_ack == 1'b1) begin
                    ov_descriptor       <= 40'b0;
                    o_descriptor_wr_to_host <= 1'b0;
                    o_descriptor_wr_to_hcp <= 1'b0;
                    o_descriptor_wr_to_network <= 1'b0;
                    descriptor_send_state       <= idle_s;
                end
                else begin
                    ov_descriptor <= ov_descriptor;
                    descriptor_send_state <= wait_des_ack_s;
                end
                
            end
            default:begin
                o_pkt_bufid_ack     <= 1'b0;
                o_pkt_bufid_wr      <= 1'b0;
                ov_pkt_bufid        <= 9'b0;        
                o_descriptor_wr_to_host <= 1'b0;
                o_descriptor_wr_to_hcp <= 1'b0;
                o_descriptor_wr_to_network <= 1'b0;
                ov_descriptor       <= 40'b0;
                descriptor_send_state <= idle_s;
                end
        endcase
    end
endmodule