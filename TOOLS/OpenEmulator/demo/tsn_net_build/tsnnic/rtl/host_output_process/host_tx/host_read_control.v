// Copyright (C) 1953-2020 NUDT
// Verilog module name - host_read_control 
// Version: HRC_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         - transfer the bufid of pkt to base address of reading pkt from ram;
//         - read pkt from ram;
//         - free bufid of pkt.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module host_read_control
(
       i_clk,
       i_rst_n,
              
       iv_pkt_descriptor,
       i_pkt_descriptor_wr,
       o_pkt_descriptor_ready,
       
       ov_pkt_bufid,
       o_pkt_bufid_wr,
       i_pkt_bufid_ack, 
       
       ov_pkt_raddr,
       o_pkt_rd,
       i_pkt_raddr_ack,
       
       i_pkt_rd_req,
       i_pkt_last_cycle_rx,
       i_pkt_rx_valid,
       ov_pkt_inport,
       
       bufid_state,
       pkt_read_state,
       ov_debug_cnt
);

// I/O
// clk & rst
input                  i_clk;                    
input                  i_rst_n;
// receive pkt bufid from HOS(Host Output Schedule)                    
input      [60:0]      iv_pkt_descriptor;              
input                  i_pkt_descriptor_wr; 
output reg             o_pkt_descriptor_ready;          
// output pkt bufid to PCB to free pkt bufid
output reg [8:0]       ov_pkt_bufid;
output reg             o_pkt_bufid_wr;
input                  i_pkt_bufid_ack; 
// read address to PCB to read pkt data       
output reg [15:0]      ov_pkt_raddr;
output reg             o_pkt_rd;
input                  i_pkt_raddr_ack;

input                  i_pkt_rd_req;
input                  i_pkt_last_cycle_rx;
input                  i_pkt_rx_valid;
output reg [3:0]       ov_pkt_inport;
//***************************************************
//                 read pkt 
//***************************************************
reg                     r_read_first;
reg        [3:0]        rv_delay_cycle;

reg        [8:0]        rv_pkt_bufid;    
output reg [2:0]        pkt_read_state;
localparam              PKT_READ_IDLE_S = 3'd0,
                        READ_FIRST_S = 3'd1,
                        READ_PKT_S   = 3'd2,
                        WAIT_PKT_ACK_S = 3'd3,
                        WAIT_PKT_RX_S= 3'd4,
                        WAIT_CYCLE_S = 3'd5;
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_pkt_raddr <= 16'h0;
        o_pkt_rd     <= 1'b0;
        rv_pkt_bufid <= 9'd0;
        ov_pkt_inport <= 4'b0;
        
        r_read_first <= 1'b0;
        rv_delay_cycle <= 4'b0;
        
        pkt_read_state <= PKT_READ_IDLE_S;
    end
    else begin
        case(pkt_read_state)
            PKT_READ_IDLE_S:begin 
                rv_delay_cycle <= 4'b0;
                if((i_pkt_descriptor_wr == 1'b1) && (iv_pkt_descriptor[12:9] != 4'hf))begin
                    rv_pkt_bufid <= iv_pkt_descriptor[8:0];
                    ov_pkt_inport <= iv_pkt_descriptor[12:9];
                    pkt_read_state <= READ_FIRST_S;
                end
                else begin
                    ov_pkt_inport <= ov_pkt_inport;
                    ov_pkt_raddr <= 16'h0;
                    o_pkt_rd     <= 1'b0;
                    rv_pkt_bufid <= rv_pkt_bufid;
                    pkt_read_state <= PKT_READ_IDLE_S;
                end                
            end
            READ_FIRST_S:begin//start read pkt data from PCB
                if(i_pkt_rd_req == 1'b1)begin
                    ov_pkt_raddr <= {rv_pkt_bufid,7'b0};// << 12'd7;
                    o_pkt_rd <= 1'b1;
                    
                    r_read_first <= 1'b1;
                    
                    pkt_read_state <= WAIT_PKT_ACK_S;
                end
                else begin
                    o_pkt_rd <= 1'b0;
                    
                    r_read_first <= 1'b0;
                    
                    pkt_read_state <= READ_FIRST_S;             
                end
            end
            READ_PKT_S:begin
                if(r_read_first == 1'b0)begin            
                    if(i_pkt_last_cycle_rx == 1'b1)begin//the last cycle read out,one pkt read finish
                        pkt_read_state <= PKT_READ_IDLE_S;
                    end
                    else begin
                        if(i_pkt_rd_req == 1'b1)begin//read the next cycle data
                            ov_pkt_raddr <= ov_pkt_raddr + 16'b1;
                            o_pkt_rd     <= 1'b1;
                            pkt_read_state <= WAIT_PKT_ACK_S;
                        end
                        else begin
                            o_pkt_rd     <= 1'b0;
                            pkt_read_state <= READ_PKT_S;
                        end
                    end
                end
                else begin
                    if(rv_delay_cycle == 4'd9)begin//wait 9 cycles to read second cycle of pkt after ack of the first cycle is high;in order to avoid that read is faster than write.
                        ov_pkt_raddr <= ov_pkt_raddr + 16'b1;
                        o_pkt_rd     <= 1'b1;
                        
                        r_read_first <= 1'b0;
                         
                        rv_delay_cycle <= 4'd0;
                        pkt_read_state <= WAIT_PKT_ACK_S;                    
                    end
                    else begin
                        rv_delay_cycle <= rv_delay_cycle + 1'b1;
                        o_pkt_rd     <= 1'b0;
                        pkt_read_state <= READ_PKT_S;                    
                    end
                end
            end
            WAIT_PKT_ACK_S:begin//wait ack signal from PCB,and start read next cycle data
                rv_delay_cycle <= 4'b0;
                if(i_pkt_raddr_ack == 1'b1)begin
                    o_pkt_rd    <=  1'b0;
                    pkt_read_state <= WAIT_PKT_RX_S;
                end
                else begin
                    pkt_read_state <= WAIT_PKT_ACK_S;
                end
            end 
            WAIT_PKT_RX_S:begin//wait the pkt from PCB
                rv_delay_cycle <= rv_delay_cycle + 1'b1;
                if(i_pkt_rx_valid == 1'b1)begin
                    pkt_read_state  <= WAIT_CYCLE_S;
                end
                else begin
                    pkt_read_state  <= WAIT_PKT_RX_S;
                end
            end 
            WAIT_CYCLE_S:begin//get the true state of i_pkt_rd_req after a cycle.
                rv_delay_cycle <= rv_delay_cycle + 1'b1;
                if(i_pkt_last_cycle_rx == 1'b1)begin
                    pkt_read_state  <= PKT_READ_IDLE_S;
                end
                else begin
                    pkt_read_state  <= READ_PKT_S;
                end
            end         
            default:begin
                ov_pkt_raddr <= 16'h0;
                o_pkt_rd     <= 1'b0;
                rv_pkt_bufid <= 9'd0;
        
                pkt_read_state <= PKT_READ_IDLE_S;      
            end
        endcase
    end
end
//***************************************************
//                 free pkt bufid 
//***************************************************  
output reg         [1:0]        bufid_state/*synthesis noprune*/;
reg    r_bufid_free_flag;
reg    [8:0] rv_bufid_free;
localparam              BUFID_IDLE_S = 2'd0,
                        WAIT_BUFID_ACK_S = 2'd1,
                        WAIT_BUFID_ACK_1_S = 2'd2;
always @(posedge i_clk or negedge i_rst_n)begin
    if(i_rst_n == 1'b0)begin
        ov_pkt_bufid <= 9'd0;
        o_pkt_bufid_wr <= 1'b0;
        o_pkt_descriptor_ready <= 1'b0;
        r_bufid_free_flag <= 1'b0;
        rv_bufid_free <= 9'b0;
        bufid_state <= BUFID_IDLE_S;        
    end
    else begin
        case(bufid_state)
            BUFID_IDLE_S:begin
                o_pkt_descriptor_ready <= 1'b0;
                if((i_pkt_descriptor_wr == 1'b1) && (iv_pkt_descriptor[12:9] == 4'hf))begin 
                    r_bufid_free_flag <= 1'b0;
                    rv_bufid_free <= 9'b0;              
                    ov_pkt_bufid <= iv_pkt_descriptor[8:0];
                    o_pkt_bufid_wr <= 1'b1;
                    bufid_state <= WAIT_BUFID_ACK_1_S;              
                end
                else if(r_bufid_free_flag == 1'b1)begin 
                    r_bufid_free_flag <= 1'b0;
                    rv_bufid_free <= 9'b0;                   
                    ov_pkt_bufid <= rv_bufid_free;
                    o_pkt_bufid_wr <= 1'b1;
                    bufid_state <= WAIT_BUFID_ACK_1_S;
                end                
                else if(i_pkt_last_cycle_rx == 1'b1)begin 
                    r_bufid_free_flag <= 1'b0;
                    rv_bufid_free <= 9'b0;                   
                    ov_pkt_bufid <= rv_pkt_bufid;
                    o_pkt_bufid_wr <= 1'b1;
                    bufid_state <= WAIT_BUFID_ACK_S;
                end
                else begin 
                    r_bufid_free_flag <= 1'b0;
                    rv_bufid_free <= 9'b0;                
                    ov_pkt_bufid <= 9'd0;
                    o_pkt_bufid_wr <= 1'b0;
                    bufid_state <= BUFID_IDLE_S;                
                end                
            end
            WAIT_BUFID_ACK_S:begin
                if(i_pkt_bufid_ack == 1'b1)begin  
                    o_pkt_bufid_wr  <= 1'b0;
                    bufid_state <= BUFID_IDLE_S;    
                end
                else begin
                    o_pkt_bufid_wr  <= 1'b1;
                    bufid_state <= WAIT_BUFID_ACK_S;    
                end

                if((i_pkt_descriptor_wr == 1'b1) && (iv_pkt_descriptor[12:9] == 4'hf))begin 
                    r_bufid_free_flag <= 1'b1;
                    rv_bufid_free <= iv_pkt_descriptor[8:0];            
                end            
                else begin 
                    r_bufid_free_flag <= r_bufid_free_flag;
                    rv_bufid_free <= rv_bufid_free; 
                end            
            end
            WAIT_BUFID_ACK_1_S:begin
                if(i_pkt_bufid_ack == 1'b1)begin
                    o_pkt_descriptor_ready <= 1'b1;                
                    o_pkt_bufid_wr  <= 1'b0;
                    bufid_state <= BUFID_IDLE_S;    
                end
                else begin
                    o_pkt_descriptor_ready <= 1'b0; 
                    o_pkt_bufid_wr  <= 1'b1;
                    bufid_state <= WAIT_BUFID_ACK_1_S;  
                end
            end
            default:begin
                r_bufid_free_flag <= 1'b0;
                rv_bufid_free <= 9'b0;
                ov_pkt_bufid <= 9'd0;
                o_pkt_bufid_wr <= 1'b0;
                bufid_state <= BUFID_IDLE_S;            
            end
        endcase
    end
end
output reg [15:0] ov_debug_cnt; 
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        ov_debug_cnt <= 16'b0;
    end
    else begin
        if(i_pkt_descriptor_wr)begin
            ov_debug_cnt <= ov_debug_cnt + 1'b1;
        end
        else begin
            ov_debug_cnt <= ov_debug_cnt;
        end
    end
end	  
endmodule