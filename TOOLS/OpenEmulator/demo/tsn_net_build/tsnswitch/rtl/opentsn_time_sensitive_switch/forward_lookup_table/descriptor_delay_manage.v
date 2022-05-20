// Copyright (C) 1953-2021 NUDT
// Verilog module name - descriptor_delay_manage 
// Version:V3.2.0.20210722
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         send the descriptor delayed
//         avoid reading pkt data before it is written to the bufm
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module descriptor_delay_manage #(parameter delay_cycle = 4'd10)
(
       i_clk,
       i_rst_n,
       
       iv_descriptor,
       i_descriptor_wr,
       o_descriptor_ack,
       
       ov_descriptor,
       o_descriptor_wr,
       i_descriptor_ack
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;

input      [71:0]      iv_descriptor;
input                  i_descriptor_wr;
output                 o_descriptor_ack;

output reg [71:0]      ov_descriptor;
output reg             o_descriptor_wr;
input                  i_descriptor_ack;

reg        [3:0]       rv_descriptor_delay;

assign  o_descriptor_ack = i_descriptor_ack;
//////////////////////////////////////////////////
//                  state                       //
//////////////////////////////////////////////////
reg        [1:0]       ddm_state;
localparam             IDLE_S        = 2'd0,
                       DELAY_S       = 2'd1,
                       ACK_S         = 2'd2;
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_descriptor       <= 72'h0;
        o_descriptor_wr     <= 1'h0;
        rv_descriptor_delay <= 4'd0;
        
        ddm_state           <= IDLE_S;
    end
    else begin
        case(ddm_state)
            IDLE_S:begin//receive descriptor 
                o_descriptor_wr         <= 1'h0;
                rv_descriptor_delay     <= 4'd0;
                if(i_descriptor_wr == 1'b1)begin
                    ov_descriptor       <= iv_descriptor;
                    ddm_state           <= DELAY_S;
                end
                else begin
                    ov_descriptor       <= 72'h0;
                    ddm_state           <= IDLE_S;
                end
            end
            
            DELAY_S:begin//delay cycle base on "delay_cycle"
                if(rv_descriptor_delay < delay_cycle)begin
                    o_descriptor_wr     <= 1'h0;
                    rv_descriptor_delay <= rv_descriptor_delay + 4'd1;
                    ddm_state           <= DELAY_S;
                end
                else begin
                    o_descriptor_wr     <= 1'h1;
                    rv_descriptor_delay <= 4'd0;
                    ddm_state           <= ACK_S;
                end
            end
            
            ACK_S:begin//transmit descriptor and wait ack single
                if(i_descriptor_ack == 1'b1)begin
                    o_descriptor_wr     <= 1'h0;
                    ddm_state           <= IDLE_S;
                end
                else begin
                    o_descriptor_wr     <= 1'h1;
                    ddm_state           <= ACK_S;
                end
            end
            
            default:begin
                ov_descriptor       <= 72'h0;
                o_descriptor_wr     <= 1'h0;
                rv_descriptor_delay <= 4'd0;
                
                ddm_state           <= IDLE_S;
            end
        endcase
    end
end
endmodule