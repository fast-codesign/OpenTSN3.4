// Copyright (C) 1953-2020 NUDT
// Verilog module name - output_schedule_control
// Version: OSC_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         select the queue for priority scheduling accprding to the gate ctrl vector
//             - number of queues: 8 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module output_schedule_control
(
       i_clk,
       i_rst_n,
              
       iv_gate_ctrl_vector,
       
       i_pkt_bufid_ack,
       
       iv_queue_empty,
           
       ov_schdule_queue,
       o_schdule_queue_wr,
       
       ov_osc_state
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
// gate_ctrl_vector from queue_gate_control              
input      [7:0]       iv_gate_ctrl_vector;     //bitmaps on behalf of 8 queues
// pkt_bufid to/from network_tx    
input                  i_pkt_bufid_ack;         //network_tx receive pkt_bufid and retuen get signal
// queue empty signal form virtual_queue_manage
input      [7:0]       iv_queue_empty;          //bitmaps on behalf of 8 queues 
// schedule queue to virtual_queue_manage
output reg [2:0]       ov_schdule_queue;       
output reg             o_schdule_queue_wr; 

output reg [1:0]       ov_osc_state;

//////////////////////////////////////////////////
//                  state                       //
//////////////////////////////////////////////////
localparam            IDLE_S    = 2'd0,
                      ACK_S     = 2'd1;

always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_schdule_queue    <= 3'h0;
        o_schdule_queue_wr  <= 1'h0;
        ov_osc_state           <= IDLE_S;
    end
    else begin                  
        case(ov_osc_state)
            IDLE_S:begin// select the queue based on gate control vector
                if((iv_gate_ctrl_vector[0] == 1'b1)&&(iv_queue_empty[0] == 1'b0))begin
                    ov_schdule_queue    <= 3'h0;
                    o_schdule_queue_wr  <= 1'h1;
                    ov_osc_state           <= ACK_S;
                end
                else if((iv_gate_ctrl_vector[1] == 1'b1)&&(iv_queue_empty[1] == 1'b0))begin
                    ov_schdule_queue    <= 3'h1;
                    o_schdule_queue_wr  <= 1'h1;
                    ov_osc_state           <= ACK_S;
                end
                else if((iv_gate_ctrl_vector[2] == 1'b1)&&(iv_queue_empty[2] == 1'b0))begin
                    ov_schdule_queue    <= 3'h2;
                    o_schdule_queue_wr  <= 1'h1;
                    ov_osc_state           <= ACK_S;
                end
                else if((iv_gate_ctrl_vector[3] == 1'b1)&&(iv_queue_empty[3] == 1'b0))begin
                    ov_schdule_queue    <= 3'h3;
                    o_schdule_queue_wr  <= 1'h1;
                    ov_osc_state           <= ACK_S;
                end
                else if((iv_gate_ctrl_vector[4] == 1'b1)&&(iv_queue_empty[4] == 1'b0))begin
                    ov_schdule_queue    <= 3'h4;
                    o_schdule_queue_wr  <= 1'h1;
                    ov_osc_state           <= ACK_S;
                end
                else if((iv_gate_ctrl_vector[5] == 1'b1)&&(iv_queue_empty[5] == 1'b0))begin
                    ov_schdule_queue    <= 3'h5;
                    o_schdule_queue_wr  <= 1'h1;
                    ov_osc_state           <= ACK_S;
                end
                else if((iv_gate_ctrl_vector[6] == 1'b1)&&(iv_queue_empty[6] == 1'b0))begin
                    ov_schdule_queue    <= 3'h6;
                    o_schdule_queue_wr  <= 1'h1;
                    ov_osc_state           <= ACK_S;
                end
                else if((iv_gate_ctrl_vector[7] == 1'b1)&&(iv_queue_empty[7] == 1'b0))begin
                    ov_schdule_queue    <= 3'h7;
                    o_schdule_queue_wr  <= 1'h1;
                    ov_osc_state           <= ACK_S;
                end
                else begin
                    o_schdule_queue_wr  <= 1'h0;
                    ov_osc_state           <= IDLE_S;
                end 
            end

            ACK_S:begin// wait for output module ack
                if(i_pkt_bufid_ack == 1'b1)begin
                    o_schdule_queue_wr  <= 1'h0;
                    ov_osc_state           <= IDLE_S;
                end
                else begin
                    o_schdule_queue_wr  <= 1'h0;
                    ov_osc_state           <= ACK_S;
                end
            end 
            
            default:begin
                ov_schdule_queue    <= 3'h0;
                o_schdule_queue_wr  <= 1'h0;
                
                ov_osc_state           <= IDLE_S;
            end
        endcase 
    end
end
endmodule