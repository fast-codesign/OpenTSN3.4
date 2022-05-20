// Copyright (C) 1953-2021 NUDT
// Verilog module name - control_output_queue 
// Version: V3.2.0.20210722
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         control bufid of pkt transmitted to host to input queue
//             - write bufid of ts packet to ram of TIM; 
//             - write bufid of not ts packet to queue.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module control_output_queue
(
       i_clk,
       i_rst_n,
       
       i_fifo_empty,
       o_fifo_rd,
       iv_fifo_rdata,
       
       ov_descriptor,
       o_descriptor_wr,
       i_descriptor_ready
);
// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;  
//fifo signal
input                  i_fifo_empty;
output reg             o_fifo_rd;
input          [13:0]  iv_fifo_rdata;
//descriptor output
output reg     [13:0]  ov_descriptor;
output reg             o_descriptor_wr;
input                  i_descriptor_ready;
//***************************************************
//               fifo read 
//***************************************************
reg         [1:0]   coq_state;
localparam  IDLE_S = 2'd0,
            OUTPUT_DESCRIPTOR_S = 2'd1,
            TRANSMIT_WAIT_S = 2'd2;   
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        o_fifo_rd <= 1'b0;    
        
        ov_descriptor <= 14'b0;
        o_descriptor_wr <= 1'b0;
        coq_state <= IDLE_S;
    end
    else begin
        case(coq_state)
            IDLE_S:begin
                ov_descriptor <= 14'b0;
                o_descriptor_wr <= 1'b0;
                if(!i_fifo_empty)begin
                    o_fifo_rd <= 1'b1;
                    coq_state <= OUTPUT_DESCRIPTOR_S;                    
                end
                else begin
                    o_fifo_rd <= 1'b0; 
                    coq_state <= IDLE_S;                         
                end
            end
            OUTPUT_DESCRIPTOR_S:begin
                o_fifo_rd <= 1'b0;
                ov_descriptor <= iv_fifo_rdata;
                o_descriptor_wr <= 1'b1; 
                coq_state <= TRANSMIT_WAIT_S;                 
            end
            TRANSMIT_WAIT_S:begin
                ov_descriptor <= 14'b0;
                o_descriptor_wr <= 1'b0;
                if(i_descriptor_ready)begin               
                    coq_state <= IDLE_S; 
                end
                else begin
                    coq_state <= TRANSMIT_WAIT_S; 
                end                
            end
            default:begin
                o_fifo_rd <= 1'b0;
                ov_descriptor <= 14'b0;
                o_descriptor_wr <= 1'b0;
                coq_state <= IDLE_S; 
            end
        endcase
    end
end 
endmodule