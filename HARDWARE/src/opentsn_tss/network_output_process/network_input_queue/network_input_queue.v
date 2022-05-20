// Copyright (C) 1953-2020 NUDT
// Verilog module name - network_input_queue
// Version: NIQ_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         select the queue for the pkt_bufid based on the gate ctrl vector
//         pkt_bufid is send to for network_queue_manage caching
//         one network interface have one network_input_queue 
//             - number of queues: 8 
//             - number of network interface: 8
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module network_input_queue
(
       i_clk,
       i_rst_n,
              
       iv_pkt_bufid,
       iv_pkt_type,
       i_pkt_bufid_wr,
       
       i_qbv_or_qch,
       iv_gate_ctrl_vector,
       
       iv_schdule_id,
       i_schdule_id_wr,
       
       ov_queue_data,
       ov_queue_waddr,
       o_queue_wr,
       
       ov_queue_id,
       o_queue_id_wr,
       ov_queue_empty      
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
// pkt_bufid & pkt_type from forward_lookup_table                   
input      [8:0]       iv_pkt_bufid;            //the id of pkt cached in the bufm_memory
input      [2:0]       iv_pkt_type;             //000:TS 001:RC 010:BE 011:PTP 100:NMAC 111:need regroup pkt
input                  i_pkt_bufid_wr;     
// gate_ctrl_vector from queue_gate_control   
input                  i_qbv_or_qch;    
input      [1:0]       iv_gate_ctrl_vector;     //bitmaps on behalf of cqf(0 & 1) queues
// pkt_bufid to QBA    
output reg [8:0]       ov_queue_data;           //caching data to queue bufm_memory
output reg [8:0]       ov_queue_waddr;          //caching address to queue bufm_memory
output reg             o_queue_wr;              //caching wr to queue bufm_memory
// queue state to/from network_output_schedule                       
output reg [2:0]       ov_queue_id;             //the pkt_bufid cached queue in the queue bufm_memory
output reg             o_queue_id_wr;
output     [7:0]       ov_queue_empty;          //bitmaps on behalf of 8 queues

input      [2:0]       iv_schdule_id;           //the scheduled queue in the queue bufm_memory
input                  i_schdule_id_wr;

// the data number in the queue
reg        [8:0]       rv_queue0_count;
reg        [8:0]       rv_queue1_count;
reg        [8:0]       rv_queue2_count;
reg        [8:0]       rv_queue3_count;
reg        [8:0]       rv_queue4_count;
reg        [8:0]       rv_queue5_count;
reg        [8:0]       rv_queue6_count;
reg        [8:0]       rv_queue7_count;

// the last address of 8 queues 
reg        [8:0]       rv_queue0_last_addr;     
reg        [8:0]       rv_queue1_last_addr;
reg        [8:0]       rv_queue2_last_addr;
reg        [8:0]       rv_queue3_last_addr;
reg        [8:0]       rv_queue4_last_addr;
reg        [8:0]       rv_queue5_last_addr;
reg        [8:0]       rv_queue6_last_addr;
reg        [8:0]       rv_queue7_last_addr;

reg        [2:0]       rv_queue;
reg                    r_queue_wr;

always @(posedge i_clk or negedge i_rst_n) begin//the queue count management
    if(i_rst_n == 1'b0)begin
        rv_queue0_count <= 9'h0;
        rv_queue1_count <= 9'h0;
        rv_queue2_count <= 9'h0;
        rv_queue3_count <= 9'h0;
        rv_queue4_count <= 9'h0;
        rv_queue5_count <= 9'h0;
        rv_queue6_count <= 9'h0;
        rv_queue7_count <= 9'h0;
    end
    else begin                  
        case({r_queue_wr,i_schdule_id_wr})
            2'b00:begin  //no write pkt_bufid to network_queue_manage and no read pkt_bufid from network_queue_manage
                rv_queue0_count <= rv_queue0_count;
                rv_queue1_count <= rv_queue1_count;
                rv_queue2_count <= rv_queue2_count;
                rv_queue3_count <= rv_queue3_count;
                rv_queue4_count <= rv_queue4_count;
                rv_queue5_count <= rv_queue5_count;
                rv_queue6_count <= rv_queue6_count;
                rv_queue7_count <= rv_queue7_count;
            end
            
            2'b01:begin//no write pkt_bufid to network_queue_manage and read a pkt_bufid from network_queue_manage
                case(iv_schdule_id)
                    3'd0:rv_queue0_count <= rv_queue0_count - 9'h1;
                    3'd1:rv_queue1_count <= rv_queue1_count - 9'h1;
                    3'd2:rv_queue2_count <= rv_queue2_count - 9'h1;
                    3'd3:rv_queue3_count <= rv_queue3_count - 9'h1;
                    3'd4:rv_queue4_count <= rv_queue4_count - 9'h1;
                    3'd5:rv_queue5_count <= rv_queue5_count - 9'h1;
                    3'd6:rv_queue6_count <= rv_queue6_count - 9'h1;
                    3'd7:rv_queue7_count <= rv_queue7_count - 9'h1;
                    default:begin
                        rv_queue0_count <= rv_queue0_count;
                        rv_queue1_count <= rv_queue1_count;
                        rv_queue2_count <= rv_queue2_count;
                        rv_queue3_count <= rv_queue3_count;
                        rv_queue4_count <= rv_queue4_count;
                        rv_queue5_count <= rv_queue5_count;
                        rv_queue6_count <= rv_queue6_count;
                        rv_queue7_count <= rv_queue7_count;
                    end
                endcase 
            end
            
            2'b10:begin//write a pkt_bufid to network_queue_manage,and no read pkt_bufid from network_queue_manage
                case(rv_queue)
                    3'd0:rv_queue0_count <= rv_queue0_count + 9'h1;
                    3'd1:rv_queue1_count <= rv_queue1_count + 9'h1;
                    3'd2:rv_queue2_count <= rv_queue2_count + 9'h1;
                    3'd3:rv_queue3_count <= rv_queue3_count + 9'h1;
                    3'd4:rv_queue4_count <= rv_queue4_count + 9'h1;
                    3'd5:rv_queue5_count <= rv_queue5_count + 9'h1;
                    3'd6:rv_queue6_count <= rv_queue6_count + 9'h1;
                    3'd7:rv_queue7_count <= rv_queue7_count + 9'h1;
                    default:begin
                        rv_queue0_count <= rv_queue0_count;
                        rv_queue1_count <= rv_queue1_count;
                        rv_queue2_count <= rv_queue2_count;
                        rv_queue3_count <= rv_queue3_count;
                        rv_queue4_count <= rv_queue4_count;
                        rv_queue5_count <= rv_queue5_count;
                        rv_queue6_count <= rv_queue6_count;
                        rv_queue7_count <= rv_queue7_count;
                    end
                endcase 
            end
            
            2'b11:begin//write a pkt_bufid to network_queue_manage,and read a pkt_bufid from network_queue_manage
                case(rv_queue)
                    3'd0:case(iv_schdule_id)
                        3'd1:begin
                            rv_queue0_count <= rv_queue0_count + 9'h1;
                            rv_queue1_count <= rv_queue1_count - 9'h1;
                        end
                        3'd2:begin
                            rv_queue0_count <= rv_queue0_count + 9'h1;
                            rv_queue2_count <= rv_queue2_count - 9'h1;
                        end
                        3'd3:begin
                            rv_queue0_count <= rv_queue0_count + 9'h1;
                            rv_queue3_count <= rv_queue3_count - 9'h1;
                        end
                        3'd4:begin
                            rv_queue0_count <= rv_queue0_count + 9'h1;
                            rv_queue4_count <= rv_queue4_count - 9'h1;
                        end
                        3'd5:begin
                            rv_queue0_count <= rv_queue0_count + 9'h1;
                            rv_queue5_count <= rv_queue5_count - 9'h1;
                        end
                        3'd6:begin
                            rv_queue0_count <= rv_queue0_count + 9'h1;
                            rv_queue6_count <= rv_queue6_count - 9'h1;
                        end
                        3'd7:begin
                            rv_queue0_count <= rv_queue0_count + 9'h1;
                            rv_queue7_count <= rv_queue7_count - 9'h1;
                        end
                        default:begin
                            rv_queue0_count <= rv_queue0_count;
                            rv_queue1_count <= rv_queue1_count;
                            rv_queue2_count <= rv_queue2_count;
                            rv_queue3_count <= rv_queue3_count;
                            rv_queue4_count <= rv_queue4_count;
                            rv_queue5_count <= rv_queue5_count;
                            rv_queue6_count <= rv_queue6_count;
                            rv_queue7_count <= rv_queue7_count;
                        end
                    endcase
                    
                    3'd1:case(iv_schdule_id)
                        3'd0:begin
                            rv_queue1_count <= rv_queue1_count + 9'h1;
                            rv_queue0_count <= rv_queue0_count - 9'h1;
                        end
                        3'd2:begin
                            rv_queue1_count <= rv_queue1_count + 9'h1;
                            rv_queue2_count <= rv_queue2_count - 9'h1;
                        end
                        3'd3:begin
                            rv_queue1_count <= rv_queue1_count + 9'h1;
                            rv_queue3_count <= rv_queue3_count - 9'h1;
                        end
                        3'd4:begin
                            rv_queue1_count <= rv_queue1_count + 9'h1;
                            rv_queue4_count <= rv_queue4_count - 9'h1;
                        end
                        3'd5:begin
                            rv_queue1_count <= rv_queue1_count + 9'h1;
                            rv_queue5_count <= rv_queue5_count - 9'h1;
                        end
                        3'd6:begin
                            rv_queue1_count <= rv_queue1_count + 9'h1;
                            rv_queue6_count <= rv_queue6_count - 9'h1;
                        end
                        3'd7:begin
                            rv_queue1_count <= rv_queue1_count + 9'h1;
                            rv_queue7_count <= rv_queue7_count - 9'h1;
                        end
                        default:begin
                            rv_queue0_count <= rv_queue0_count;
                            rv_queue1_count <= rv_queue1_count;
                            rv_queue2_count <= rv_queue2_count;
                            rv_queue3_count <= rv_queue3_count;
                            rv_queue4_count <= rv_queue4_count;
                            rv_queue5_count <= rv_queue5_count;
                            rv_queue6_count <= rv_queue6_count;
                            rv_queue7_count <= rv_queue7_count;
                        end
                    endcase
                    
                    3'd2:case(iv_schdule_id)
                        3'd0:begin
                            rv_queue2_count <= rv_queue2_count + 9'h1;
                            rv_queue0_count <= rv_queue0_count - 9'h1;
                        end
                        3'd1:begin
                            rv_queue2_count <= rv_queue2_count + 9'h1;
                            rv_queue1_count <= rv_queue1_count - 9'h1;
                        end
                        3'd3:begin
                            rv_queue2_count <= rv_queue2_count + 9'h1;
                            rv_queue3_count <= rv_queue3_count - 9'h1;
                        end
                        3'd4:begin
                            rv_queue2_count <= rv_queue2_count + 9'h1;
                            rv_queue4_count <= rv_queue4_count - 9'h1;
                        end
                        3'd5:begin
                            rv_queue2_count <= rv_queue2_count + 9'h1;
                            rv_queue5_count <= rv_queue5_count - 9'h1;
                        end
                        3'd6:begin
                            rv_queue2_count <= rv_queue2_count + 9'h1;
                            rv_queue6_count <= rv_queue6_count - 9'h1;
                        end
                        3'd7:begin
                            rv_queue2_count <= rv_queue2_count + 9'h1;
                            rv_queue7_count <= rv_queue7_count - 9'h1;
                        end
                        default:begin
                            rv_queue0_count <= rv_queue0_count;
                            rv_queue1_count <= rv_queue1_count;
                            rv_queue2_count <= rv_queue2_count;
                            rv_queue3_count <= rv_queue3_count;
                            rv_queue4_count <= rv_queue4_count;
                            rv_queue5_count <= rv_queue5_count;
                            rv_queue6_count <= rv_queue6_count;
                            rv_queue7_count <= rv_queue7_count;
                        end
                    endcase
                    
                    3'd3:case(iv_schdule_id)
                        3'd0:begin
                            rv_queue3_count <= rv_queue3_count + 9'h1;
                            rv_queue0_count <= rv_queue0_count - 9'h1;
                        end
                        3'd1:begin
                            rv_queue3_count <= rv_queue3_count + 9'h1;
                            rv_queue1_count <= rv_queue1_count - 9'h1;
                        end
                        3'd2:begin
                            rv_queue3_count <= rv_queue3_count + 9'h1;
                            rv_queue2_count <= rv_queue2_count - 9'h1;
                        end
                        3'd4:begin
                            rv_queue3_count <= rv_queue3_count + 9'h1;
                            rv_queue4_count <= rv_queue4_count - 9'h1;
                        end
                        3'd5:begin
                            rv_queue3_count <= rv_queue3_count + 9'h1;
                            rv_queue5_count <= rv_queue5_count - 9'h1;
                        end
                        3'd6:begin
                            rv_queue3_count <= rv_queue3_count + 9'h1;
                            rv_queue6_count <= rv_queue6_count - 9'h1;
                        end
                        3'd7:begin
                            rv_queue3_count <= rv_queue3_count + 9'h1;
                            rv_queue7_count <= rv_queue7_count - 9'h1;
                        end
                        default:begin
                            rv_queue0_count <= rv_queue0_count;
                            rv_queue1_count <= rv_queue1_count;
                            rv_queue2_count <= rv_queue2_count;
                            rv_queue3_count <= rv_queue3_count;
                            rv_queue4_count <= rv_queue4_count;
                            rv_queue5_count <= rv_queue5_count;
                            rv_queue6_count <= rv_queue6_count;
                            rv_queue7_count <= rv_queue7_count;
                        end
                    endcase
                    
                    3'd4:case(iv_schdule_id)
                        3'd0:begin
                            rv_queue4_count <= rv_queue4_count + 9'h1;
                            rv_queue0_count <= rv_queue0_count - 9'h1;
                        end
                        3'd1:begin
                            rv_queue4_count <= rv_queue4_count + 9'h1;
                            rv_queue1_count <= rv_queue1_count - 9'h1;
                        end
                        3'd2:begin
                            rv_queue4_count <= rv_queue4_count + 9'h1;
                            rv_queue2_count <= rv_queue2_count - 9'h1;
                        end
                        3'd3:begin
                            rv_queue4_count <= rv_queue4_count + 9'h1;
                            rv_queue3_count <= rv_queue3_count - 9'h1;
                        end
                        3'd5:begin
                            rv_queue4_count <= rv_queue4_count + 9'h1;
                            rv_queue5_count <= rv_queue5_count - 9'h1;
                        end
                        3'd6:begin
                            rv_queue4_count <= rv_queue4_count + 9'h1;
                            rv_queue6_count <= rv_queue6_count - 9'h1;
                        end
                        3'd7:begin
                            rv_queue4_count <= rv_queue4_count + 9'h1;
                            rv_queue7_count <= rv_queue7_count - 9'h1;
                        end
                        default:begin
                            rv_queue0_count <= rv_queue0_count;
                            rv_queue1_count <= rv_queue1_count;
                            rv_queue2_count <= rv_queue2_count;
                            rv_queue3_count <= rv_queue3_count;
                            rv_queue4_count <= rv_queue4_count;
                            rv_queue5_count <= rv_queue5_count;
                            rv_queue6_count <= rv_queue6_count;
                            rv_queue7_count <= rv_queue7_count;
                        end
                    endcase
                    
                    3'd5:case(iv_schdule_id)
                        3'd0:begin
                            rv_queue5_count <= rv_queue5_count + 9'h1;
                            rv_queue0_count <= rv_queue0_count - 9'h1;
                        end
                        3'd1:begin
                            rv_queue5_count <= rv_queue5_count + 9'h1;
                            rv_queue1_count <= rv_queue1_count - 9'h1;
                        end
                        3'd2:begin
                            rv_queue5_count <= rv_queue5_count + 9'h1;
                            rv_queue2_count <= rv_queue2_count - 9'h1;
                        end
                        3'd3:begin
                            rv_queue5_count <= rv_queue5_count + 9'h1;
                            rv_queue3_count <= rv_queue3_count - 9'h1;
                        end
                        3'd4:begin
                            rv_queue5_count <= rv_queue5_count + 9'h1;
                            rv_queue4_count <= rv_queue4_count - 9'h1;
                        end
                        3'd6:begin
                            rv_queue5_count <= rv_queue5_count + 9'h1;
                            rv_queue6_count <= rv_queue6_count - 9'h1;
                        end
                        3'd7:begin
                            rv_queue5_count <= rv_queue5_count + 9'h1;
                            rv_queue7_count <= rv_queue7_count - 9'h1;
                        end
                        default:begin
                            rv_queue0_count <= rv_queue0_count;
                            rv_queue1_count <= rv_queue1_count;
                            rv_queue2_count <= rv_queue2_count;
                            rv_queue3_count <= rv_queue3_count;
                            rv_queue4_count <= rv_queue4_count;
                            rv_queue5_count <= rv_queue5_count;
                            rv_queue6_count <= rv_queue6_count;
                            rv_queue7_count <= rv_queue7_count;
                        end
                    endcase
                    
                    3'd6:case(iv_schdule_id)
                        3'd0:begin
                            rv_queue6_count <= rv_queue6_count + 9'h1;
                            rv_queue0_count <= rv_queue0_count - 9'h1;
                        end
                        3'd1:begin
                            rv_queue6_count <= rv_queue6_count + 9'h1;
                            rv_queue1_count <= rv_queue1_count - 9'h1;
                        end
                        3'd2:begin
                            rv_queue6_count <= rv_queue6_count + 9'h1;
                            rv_queue2_count <= rv_queue2_count - 9'h1;
                        end
                        3'd3:begin
                            rv_queue6_count <= rv_queue6_count + 9'h1;
                            rv_queue3_count <= rv_queue3_count - 9'h1;
                        end
                        3'd4:begin
                            rv_queue6_count <= rv_queue6_count + 9'h1;
                            rv_queue4_count <= rv_queue4_count - 9'h1;
                        end
                        3'd5:begin
                            rv_queue6_count <= rv_queue6_count + 9'h1;
                            rv_queue5_count <= rv_queue5_count - 9'h1;
                        end
                        3'd7:begin
                            rv_queue6_count <= rv_queue6_count + 9'h1;
                            rv_queue7_count <= rv_queue7_count - 9'h1;
                        end
                        default:begin
                            rv_queue0_count <= rv_queue0_count;
                            rv_queue1_count <= rv_queue1_count;
                            rv_queue2_count <= rv_queue2_count;
                            rv_queue3_count <= rv_queue3_count;
                            rv_queue4_count <= rv_queue4_count;
                            rv_queue5_count <= rv_queue5_count;
                            rv_queue6_count <= rv_queue6_count;
                            rv_queue7_count <= rv_queue7_count;
                        end
                    endcase
                    
                    3'd7:case(iv_schdule_id)
                        3'd0:begin
                            rv_queue7_count <= rv_queue7_count + 9'h1;
                            rv_queue0_count <= rv_queue0_count - 9'h1;
                        end
                        3'd1:begin
                            rv_queue7_count <= rv_queue7_count + 9'h1;
                            rv_queue1_count <= rv_queue1_count - 9'h1;
                        end
                        3'd2:begin
                            rv_queue7_count <= rv_queue7_count + 9'h1;
                            rv_queue2_count <= rv_queue2_count - 9'h1;
                        end
                        3'd3:begin
                            rv_queue7_count <= rv_queue7_count + 9'h1;
                            rv_queue3_count <= rv_queue3_count - 9'h1;
                        end
                        3'd4:begin
                            rv_queue7_count <= rv_queue7_count + 9'h1;
                            rv_queue4_count <= rv_queue4_count - 9'h1;
                        end
                        3'd5:begin
                            rv_queue7_count <= rv_queue7_count + 9'h1;
                            rv_queue5_count <= rv_queue5_count - 9'h1;
                        end
                        3'd6:begin
                            rv_queue7_count <= rv_queue7_count + 9'h1;
                            rv_queue6_count <= rv_queue6_count - 9'h1;
                        end
                        default:begin
                            rv_queue0_count <= rv_queue0_count;
                            rv_queue1_count <= rv_queue1_count;
                            rv_queue2_count <= rv_queue2_count;
                            rv_queue3_count <= rv_queue3_count;
                            rv_queue4_count <= rv_queue4_count;
                            rv_queue5_count <= rv_queue5_count;
                            rv_queue6_count <= rv_queue6_count;
                            rv_queue7_count <= rv_queue7_count;
                        end
                    endcase
                    
                    default:begin
                        rv_queue0_count <= rv_queue0_count;
                        rv_queue1_count <= rv_queue1_count;
                        rv_queue2_count <= rv_queue2_count;
                        rv_queue3_count <= rv_queue3_count;
                        rv_queue4_count <= rv_queue4_count;
                        rv_queue5_count <= rv_queue5_count;
                        rv_queue6_count <= rv_queue6_count;
                        rv_queue7_count <= rv_queue7_count;
                    end
                endcase
            end
            
            default:begin
                rv_queue0_count <= rv_queue0_count;
                rv_queue1_count <= rv_queue1_count;
                rv_queue2_count <= rv_queue2_count;
                rv_queue3_count <= rv_queue3_count;
                rv_queue4_count <= rv_queue4_count;
                rv_queue5_count <= rv_queue5_count;
                rv_queue6_count <= rv_queue6_count;
                rv_queue7_count <= rv_queue7_count;
            end
        endcase 
    end
end

assign  ov_queue_empty[0] = {|rv_queue0_count} ? 1'b0:1'b1;
assign  ov_queue_empty[1] = {|rv_queue1_count} ? 1'b0:1'b1;
assign  ov_queue_empty[2] = {|rv_queue2_count} ? 1'b0:1'b1;
assign  ov_queue_empty[3] = {|rv_queue3_count} ? 1'b0:1'b1;
assign  ov_queue_empty[4] = {|rv_queue4_count} ? 1'b0:1'b1;
assign  ov_queue_empty[5] = {|rv_queue5_count} ? 1'b0:1'b1;
assign  ov_queue_empty[6] = {|rv_queue6_count} ? 1'b0:1'b1;
assign  ov_queue_empty[7] = {|rv_queue7_count} ? 1'b0:1'b1;


//////////////////////////////////////////////////
//              select queue                    //
//////////////////////////////////////////////////

always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        rv_queue         <= 3'h0;
        r_queue_wr       <= 1'h0;
    end
    else begin
        if(i_pkt_bufid_wr == 1'b1)begin
            if(i_qbv_or_qch == 1'b0)begin //qbv
                case(iv_pkt_type)
                3'b000:begin//queue0 
                    r_queue_wr       <= 1'h1;
                    rv_queue         <= 3'h0;                               
                end
                
                3'b001:begin//queue1
                    r_queue_wr       <= 1'h1;
                    rv_queue         <= 3'h1;                               
                end
                
                3'b010:begin//queue2
                    r_queue_wr       <= 1'h1;
                    rv_queue         <= 3'h2;                               
                end
                
                3'b011:begin//queue3
                    r_queue_wr       <= 1'h1;
                    rv_queue         <= 3'h3;                           
                end
                
                3'b100:begin//queue4
                    r_queue_wr       <= 1'h1;
                    rv_queue         <= 3'h4;                               
                end
                
                3'b101:begin//queue5
                    r_queue_wr       <= 1'h1;
                    rv_queue         <= 3'h5;                           
                end
                
                3'b110:begin//queue6
                    r_queue_wr       <= 1'h1;
                    rv_queue         <= 3'h6;                           
                end
                
                3'b111:begin//queue7
                    r_queue_wr       <= 1'h1;
                    rv_queue         <= 3'h7;                           
                end
                
                default:begin
                    rv_queue            <= 3'h0;
                    r_queue_wr       <= 1'h0;                           
                end
                endcase
            end
            else begin // qch
                case(iv_pkt_type)
                3'b000:begin//queue0 
                    if(iv_gate_ctrl_vector == 2'b01)begin
                        r_queue_wr       <= 1'h1;
                        rv_queue         <= 3'h0;                           
                    end
                    else if(iv_gate_ctrl_vector == 2'b10)begin
                        r_queue_wr       <= 1'h1;
                        rv_queue         <= 3'h1;
                    end
                    else begin              
                        r_queue_wr       <= 1'h0;
                    end
                end
                
                3'b001:begin//queue1 
                    if(iv_gate_ctrl_vector == 2'b01)begin
                        r_queue_wr       <= 1'h1;
                        rv_queue         <= 3'h0;                           
                    end
                    else if(iv_gate_ctrl_vector == 2'b10)begin
                        r_queue_wr       <= 1'h1;
                        rv_queue         <= 3'h1;
                    end
                    else begin              
                        r_queue_wr       <= 1'h0;
                    end
                end
                
                3'b010:begin//queue2
                    if(iv_gate_ctrl_vector == 2'b01)begin
                        r_queue_wr       <= 1'h1;
                        rv_queue         <= 3'h0;                           
                    end
                    else if(iv_gate_ctrl_vector == 2'b10)begin
                        r_queue_wr       <= 1'h1;
                        rv_queue         <= 3'h1;
                    end
                    else begin              
                        r_queue_wr       <= 1'h0;
                    end
                end
                
                3'b011:begin//queue3
                    r_queue_wr           <= 1'h1;
                    rv_queue             <= 3'h3;                           
                end
                
                3'b100:begin//queue4
                    r_queue_wr           <= 1'h1;
                    rv_queue             <= 3'h4;                           
                end
                
                3'b101:begin//queue5
                    r_queue_wr           <= 1'h1;
                    rv_queue             <= 3'h5;                               
                end
                
                3'b110:begin//queue6
                    r_queue_wr           <= 1'h1;
                    rv_queue             <= 3'h6;                           
                end
                
                3'b111:begin//queue7
                    r_queue_wr           <= 1'h1;
                    rv_queue             <= 3'h7;                               
                end
                
                default:begin
                    rv_queue            <= 3'h0;
                    r_queue_wr       <= 1'h0;                           
                end
                endcase
            end
            
        end
        else begin
            rv_queue         <= 3'h0;
            r_queue_wr       <= 1'h0;   
        end
    end
end

//////////////////////////////////////////////////
//              cache the pkt_bufid             //
//////////////////////////////////////////////////
reg        [8:0]       rv_bufid_cache;
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        rv_bufid_cache  <= 9'd0;
    end
    else begin
        if(i_pkt_bufid_wr == 1'b1)begin
            rv_bufid_cache  <= iv_pkt_bufid;
        end
        else begin
            rv_bufid_cache  <= rv_bufid_cache;
        end
    end
end

//////////////////////////////////////////////////
//              write to queue                  //
//////////////////////////////////////////////////
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_queue_data       <= 9'h0;
        ov_queue_waddr      <= 9'h0;
        o_queue_wr          <= 1'h0;
        rv_queue0_last_addr <= 9'h0;
        rv_queue1_last_addr <= 9'h0;
        rv_queue2_last_addr <= 9'h0;
        rv_queue3_last_addr <= 9'h0;
        rv_queue4_last_addr <= 9'h0;
        rv_queue5_last_addr <= 9'h0;
        rv_queue6_last_addr <= 9'h0;
        rv_queue7_last_addr <= 9'h0;
        ov_queue_id         <= 3'd0;
        o_queue_id_wr       <= 1'b0;
    end
    else begin
        if(r_queue_wr == 1'b1)begin
            ov_queue_id     <= rv_queue;
            o_queue_id_wr   <= r_queue_wr;
            case(rv_queue)
                3'b000:begin//queue0 
                    rv_queue0_last_addr <= rv_bufid_cache;
                    if(ov_queue_empty[0] == 1'b1)begin   //when the queue was empty
                        ov_queue_waddr  <= rv_bufid_cache; //use pkt_bufid for queue address
                        ov_queue_data   <= 9'h0;//write data is "null(0)"
                        o_queue_wr      <= 1'h1;
                    end
                    else begin                           //when the queue was not empty
                        ov_queue_waddr  <= rv_queue0_last_addr; //use queue last address for queue address
                        ov_queue_data   <= rv_bufid_cache; //write data is "pkt_bufid" and "frag_last"
                        o_queue_wr      <= 1'h1;
                    end
                end
                
                3'b001:begin//queue1 
                    rv_queue1_last_addr <= rv_bufid_cache;
                    if(ov_queue_empty[1] == 1'b1)begin   //when the queue was empty
                        ov_queue_waddr  <= rv_bufid_cache; //use pkt_bufid for queue address
                        ov_queue_data   <= 9'h0;//write data is "null(0)"
                        o_queue_wr      <= 1'h1;
                    end
                    else begin                           //when the queue was not empty
                        ov_queue_waddr  <= rv_queue1_last_addr; //use queue last address for queue address
                        ov_queue_data   <= rv_bufid_cache; //write data is "pkt_bufid" and "frag_last"
                        o_queue_wr      <= 1'h1;
                    end
                end
                    
                3'b010:begin//queue2
                    rv_queue2_last_addr <= rv_bufid_cache;
                    if(ov_queue_empty[2] == 1'b1)begin   //when the queue was empty
                        ov_queue_waddr  <= rv_bufid_cache; //use pkt_bufid for queue address
                        ov_queue_data   <= 9'h0;//write data is "null(0)"
                        o_queue_wr      <= 1'h1;
                    end
                    else begin                           //when the queue was not empty
                        ov_queue_waddr  <= rv_queue2_last_addr; //use queue last address for queue address
                        ov_queue_data   <= rv_bufid_cache; //write data is "pkt_bufid" and "frag_last"
                        o_queue_wr      <= 1'h1;
                    end                             
                end
                
                3'b011:begin//queue3
                    rv_queue3_last_addr <= rv_bufid_cache;
                    if(ov_queue_empty[3] == 1'b1)begin   //when the queue was empty
                        ov_queue_waddr  <= rv_bufid_cache; //use pkt_bufid for queue address
                        ov_queue_data   <= 9'h0;//write data is "null(0)"
                        o_queue_wr      <= 1'h1;
                    end
                    else begin                           //when the queue was not empty
                        ov_queue_waddr  <= rv_queue3_last_addr; //use queue last address for queue address
                        ov_queue_data   <= rv_bufid_cache; //write data is "pkt_bufid" and "frag_last"
                        o_queue_wr      <= 1'h1;
                    end                             
                end
                
                3'b100:begin//queue4
                    rv_queue4_last_addr <= rv_bufid_cache;
                    if(ov_queue_empty[4] == 1'b1)begin   //when the queue was empty
                        ov_queue_waddr  <= rv_bufid_cache; //use pkt_bufid for queue address
                        ov_queue_data   <= 9'h0;//write data is "null(0)"
                        o_queue_wr      <= 1'h1;
                    end
                    else begin                           //when the queue was not empty
                        ov_queue_waddr  <= rv_queue4_last_addr; //use queue last address for queue address
                        ov_queue_data   <= rv_bufid_cache; //write data is "pkt_bufid" and "frag_last"
                        o_queue_wr      <= 1'h1;
                    end                             
                end
                
                3'b101:begin//queue5
                    rv_queue5_last_addr <= rv_bufid_cache;
                    if(ov_queue_empty[5] == 1'b1)begin   //when the queue was empty
                        ov_queue_waddr  <= rv_bufid_cache; //use pkt_bufid for queue address
                        ov_queue_data   <= 9'h0;//write data is "null(0)"
                        o_queue_wr      <= 1'h1;
                    end
                    else begin                           //when the queue was not empty
                        ov_queue_waddr  <= rv_queue5_last_addr; //use queue last address for queue address
                        ov_queue_data   <= rv_bufid_cache; //write data is "pkt_bufid" and "frag_last"
                        o_queue_wr      <= 1'h1;
                    end                             
                end
                
                3'b110:begin//queue6
                    rv_queue6_last_addr <= rv_bufid_cache;
                    if(ov_queue_empty[6] == 1'b1)begin   //when the queue was empty
                        ov_queue_waddr  <= rv_bufid_cache; //use pkt_bufid for queue address
                        ov_queue_data   <= 9'h0;//write data is "null(0)"
                        o_queue_wr      <= 1'h1;
                    end
                    else begin                           //when the queue was not empty
                       ov_queue_waddr   <= rv_queue6_last_addr; //use queue last address for queue address
                       ov_queue_data    <= rv_bufid_cache; //write data is "pkt_bufid" and "frag_last"
                       o_queue_wr       <= 1'h1;
                    end                             
                end
                
                3'b111:begin//queue7
                    rv_queue7_last_addr <= rv_bufid_cache;
                    if(ov_queue_empty[7] == 1'b1)begin   //when the queue was empty
                        ov_queue_waddr  <= rv_bufid_cache; //use pkt_bufid for queue address
                        ov_queue_data   <= 9'h0;//write data is "null(0)"
                        o_queue_wr      <= 1'h1;
                    end
                    else begin                           //when the queue was not empty
                        ov_queue_waddr  <= rv_queue7_last_addr; //use queue last address for queue address
                        ov_queue_data   <= rv_bufid_cache; //write data is "pkt_bufid" and "frag_last"
                        o_queue_wr      <= 1'h1;
                    end                             
                end  
                
                default:begin
                    ov_queue_data       <= 9'h0;
                    ov_queue_waddr      <= 9'h0;
                    o_queue_wr          <= 1'h0;
                    rv_queue0_last_addr <= 9'h0;
                    rv_queue1_last_addr <= 9'h0;
                    rv_queue2_last_addr <= 9'h0;
                    rv_queue3_last_addr <= 9'h0;
                    rv_queue4_last_addr <= 9'h0;
                    rv_queue5_last_addr <= 9'h0;
                    rv_queue6_last_addr <= 9'h0;
                    rv_queue7_last_addr <= 9'h0;                        
                end
            endcase
        end
        else begin
            ov_queue_id         <= ov_queue_id;
            o_queue_id_wr       <= 1'b0;
            ov_queue_data       <= 9'h0;
            ov_queue_waddr      <= 9'h0;
            o_queue_wr          <= 1'h0;
            rv_queue0_last_addr <= rv_queue0_last_addr;
            rv_queue1_last_addr <= rv_queue1_last_addr;
            rv_queue2_last_addr <= rv_queue2_last_addr;
            rv_queue3_last_addr <= rv_queue3_last_addr;
            rv_queue4_last_addr <= rv_queue4_last_addr;
            rv_queue5_last_addr <= rv_queue5_last_addr;
            rv_queue6_last_addr <= rv_queue6_last_addr;
            rv_queue7_last_addr <= rv_queue7_last_addr;
        end
    end
end

endmodule