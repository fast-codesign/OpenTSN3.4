// Copyright (C) 1953-2020 NUDT
// Verilog module name - virtual_queue_manage
// Version: VQM_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         the queue management
//         read pkt_bufid from network_queue_manage
//         send pkt_bufid to network_tx
//             - number of queues: 8 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module virtual_queue_manage
(
       i_clk,
       i_rst_n,
              
       iv_pkt_bufid,
       iv_pkt_next_bufid,
       iv_queue_id,
       i_queue_id_wr,
       iv_queue_empty,
       
       ov_queue_raddr,
       o_queue_rd,
       iv_rd_queue_data,
       i_rd_queue_data_wr,
       
       ov_pkt_bufid,
       o_pkt_bufid_wr,

       iv_schdule_queue,
       i_schdule_queue_wr,
       
       ov_schdule_id,  
       o_schdule_id_wr
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
// pkt_bufid & queue_id from network_input_queue              
input      [8:0]       iv_pkt_bufid;            //the id of pkt cached in the bufm_memory  
input      [8:0]       iv_pkt_next_bufid;
input      [2:0]       iv_queue_id;             //the pkt_bufid cached queue in the queue bufm_memory
input                  i_queue_id_wr;
input      [7:0]       iv_queue_empty;          //bitmaps on behalf of 8 queues 
// pkt_bufid from network_queue_manage   
output reg [8:0]       ov_queue_raddr;          //read address to queue bufm_memory
output reg             o_queue_rd;              //read signal to queue bufm_memory
input      [8:0]       iv_rd_queue_data;            //read data from queue bufm_memory
input                  i_rd_queue_data_wr;
// pkt_bufid to network_tx                      
output     [8:0]       ov_pkt_bufid;            //the pkt_bufid cached queue in the queue bufm_memory
output                 o_pkt_bufid_wr;

// schedule queue from output_schedule_control
input      [2:0]       iv_schdule_queue;       
input                  i_schdule_queue_wr;
 
// schedule queue id to network_input_queue
output     [2:0]       ov_schdule_id;      
output                 o_schdule_id_wr; 

assign   ov_pkt_bufid   = i_rd_queue_data_wr? ov_queue_raddr:9'h0;
assign   o_pkt_bufid_wr = i_rd_queue_data_wr;

assign   ov_schdule_id   = iv_schdule_queue;
assign   o_schdule_id_wr = i_rd_queue_data_wr;

//////////////////////////////////////////////
//          queue management                //
//////////////////////////////////////////////
//queue management,includingqueue first address                   
reg        [8:0]       rv_queue0_first_addr;
reg        [8:0]       rv_queue1_first_addr;
reg        [8:0]       rv_queue2_first_addr;
reg        [8:0]       rv_queue3_first_addr;
reg        [8:0]       rv_queue4_first_addr;
reg        [8:0]       rv_queue5_first_addr;
reg        [8:0]       rv_queue6_first_addr;
reg        [8:0]       rv_queue7_first_addr;

reg     [7:0]   rv_empty_delay;
always @(posedge i_clk) begin
    rv_empty_delay     <= iv_queue_empty;           
end

//////////////////////////////////////////////
//      updata queue frrst address          //
//////////////////////////////////////////////

reg     [9:0]   rv_pkt_bufid_delay;
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        rv_pkt_bufid_delay     <= 10'd0;  
    end
    else if(o_pkt_bufid_wr == 1'b1)begin
        rv_pkt_bufid_delay     <= {1'b1,ov_pkt_bufid};    
    end
    else begin
        rv_pkt_bufid_delay     <= {10'd0};  
    end
            
end

always @(posedge i_clk or negedge i_rst_n) begin //the queue first address management
    if(i_rst_n == 1'b0)begin
        rv_queue0_first_addr    <= 9'h0;
        rv_queue1_first_addr    <= 9'h0;
        rv_queue2_first_addr    <= 9'h0;
        rv_queue3_first_addr    <= 9'h0;
        rv_queue4_first_addr    <= 9'h0;
        rv_queue5_first_addr    <= 9'h0;
        rv_queue6_first_addr    <= 9'h0;
        rv_queue7_first_addr    <= 9'h0;
    end
    else begin
        if(rv_empty_delay[0] == 1'b1)begin//queue0 was empty,use pkt_bufid for queue first address
            if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd0))begin
                rv_queue0_first_addr    <= iv_pkt_bufid;
            end
            else begin
                rv_queue0_first_addr    <= rv_queue0_first_addr;
            end
        end
        else begin//queue0 was not empty,queue first address remain unchange
            if((i_rd_queue_data_wr == 1'b1)&&(iv_schdule_queue == 3'd0))begin
                //if read queue and write queue is same clock,and the queue count is one
                //read next bufid is 0(null),but write a new bufid to the address
                //so used the new bufid as the next bufid
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd0)&&(ov_pkt_bufid == iv_pkt_bufid))begin
                    rv_queue0_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue0_first_addr    <= iv_rd_queue_data;
                end
            end
            else begin
                //if read next bufid is 0(null),but next cycle write a new bufid to the address
                //because queue empty have one cycle delay,so cache the bufid one cycle 
                //so used the new bufid as the next bufid
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd0)&&(rv_pkt_bufid_delay[8:0] == iv_pkt_bufid) && (rv_pkt_bufid_delay[9] == 1'b1))begin
                    rv_queue0_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue0_first_addr    <= rv_queue0_first_addr;
                end
            end
        end
        
        if(rv_empty_delay[1] == 1'b1)begin//queue1 was empty,use pkt_bufid for queue first address
            if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd1))begin
                rv_queue1_first_addr    <= iv_pkt_bufid;
            end
            else begin
                rv_queue1_first_addr    <= rv_queue1_first_addr;
            end
        end
        else begin//queue1 was not empty,queue first address remain unchange
            if((i_rd_queue_data_wr == 1'b1)&&(iv_schdule_queue == 3'd1))begin
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd1)&&(ov_pkt_bufid == iv_pkt_bufid))begin
                    rv_queue1_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue1_first_addr    <= iv_rd_queue_data;
                end
            end
            else begin
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd1)&&(rv_pkt_bufid_delay[8:0] == iv_pkt_bufid) && (rv_pkt_bufid_delay[9] == 1'b1))begin
                    rv_queue1_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue1_first_addr    <= rv_queue1_first_addr;
                end
            end
        end
        
        if(rv_empty_delay[2] == 1'b1)begin//queue2 was empty,use pkt_bufid for queue first address
            if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd2))begin
                rv_queue2_first_addr    <= iv_pkt_bufid;
            end
            else begin
                rv_queue2_first_addr    <= rv_queue2_first_addr;
            end
        end
        else begin//queue2 was not empty,queue first address remain unchange
            if((i_rd_queue_data_wr == 1'b1)&&(iv_schdule_queue == 3'd2))begin
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd2)&&(ov_pkt_bufid == iv_pkt_bufid))begin
                    rv_queue2_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue2_first_addr    <= iv_rd_queue_data;
                end
            end
            else begin
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd2)&&(rv_pkt_bufid_delay[8:0] == iv_pkt_bufid) && (rv_pkt_bufid_delay[9] == 1'b1))begin
                    rv_queue2_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue2_first_addr    <= rv_queue2_first_addr;
                end
            end
        end
        
        if(rv_empty_delay[3] == 1'b1)begin//queue3 was empty,use pkt_bufid for queue first address
            if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd3))begin
                rv_queue3_first_addr    <= iv_pkt_bufid;
            end
            else begin
                rv_queue3_first_addr    <= rv_queue3_first_addr;
            end
        end
        else begin//queue3 was not empty,queue first address remain unchange
            if((i_rd_queue_data_wr == 1'b1)&&(iv_schdule_queue == 3'd3))begin
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd3)&&(ov_pkt_bufid == iv_pkt_bufid))begin
                    rv_queue3_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue3_first_addr    <= iv_rd_queue_data;
                end
            end
            else begin
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd3)&&(rv_pkt_bufid_delay[8:0] == iv_pkt_bufid) && (rv_pkt_bufid_delay[9] == 1'b1))begin
                    rv_queue3_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue3_first_addr    <= rv_queue3_first_addr;
                end
            end
        end
        
        if(rv_empty_delay[4] == 1'b1)begin//queue4 was empty,use pkt_bufid for queue first address
            if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd4))begin
                rv_queue4_first_addr    <= iv_pkt_bufid;
            end
            else begin
                rv_queue4_first_addr    <= rv_queue4_first_addr;
            end
        end
        else begin//queue4 was not empty,queue first address remain unchange
            if((i_rd_queue_data_wr == 1'b1)&&(iv_schdule_queue == 3'd4))begin
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd4)&&(ov_pkt_bufid == iv_pkt_bufid))begin
                    rv_queue4_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue4_first_addr    <= iv_rd_queue_data;
                end
            end
            else begin
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd4)&&(rv_pkt_bufid_delay[8:0] == iv_pkt_bufid) && (rv_pkt_bufid_delay[9] == 1'b1))begin
                    rv_queue4_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue4_first_addr    <= rv_queue4_first_addr;
                end
            end
        end
        
        if(rv_empty_delay[5] == 1'b1)begin//queue5 was empty,use pkt_bufid for queue first address
            if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd5))begin
                rv_queue5_first_addr    <= iv_pkt_bufid;
            end
            else begin
                rv_queue5_first_addr    <= rv_queue5_first_addr;
            end
        end
        else begin//queue5 was not empty,queue first address remain unchange
            if((i_rd_queue_data_wr == 1'b1)&&(iv_schdule_queue == 3'd5))begin
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd5)&&(ov_pkt_bufid == iv_pkt_bufid))begin
                    rv_queue5_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue5_first_addr    <= iv_rd_queue_data;
                end
            end
            else begin
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd5)&&(rv_pkt_bufid_delay[8:0] == iv_pkt_bufid) && (rv_pkt_bufid_delay[9] == 1'b1))begin
                    rv_queue5_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue5_first_addr    <= rv_queue5_first_addr;
                end
            end
        end
        
        if(rv_empty_delay[6] == 1'b1)begin//queue6 was empty,use pkt_bufid for queue first address
            if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd6))begin
                rv_queue6_first_addr    <= iv_pkt_bufid;
            end
            else begin
                rv_queue6_first_addr    <= rv_queue6_first_addr;
            end
        end
        else begin//queue6 was not empty,queue first address remain unchange
            if((i_rd_queue_data_wr == 1'b1)&&(iv_schdule_queue == 3'd6))begin
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd6)&&(ov_pkt_bufid == iv_pkt_bufid))begin
                    rv_queue6_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue6_first_addr    <= iv_rd_queue_data;
                end
            end
            else begin
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd6)&&(rv_pkt_bufid_delay[8:0] == iv_pkt_bufid) && (rv_pkt_bufid_delay[9] == 1'b1))begin
                    rv_queue6_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue6_first_addr    <= rv_queue6_first_addr;
                end
            end
        end
        
        if(rv_empty_delay[7] == 1'b1)begin//queue7 was empty,use pkt_bufid for queue first address
            if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd7))begin
                rv_queue7_first_addr    <= iv_pkt_bufid;
            end
            else begin
                rv_queue7_first_addr    <= rv_queue7_first_addr;
            end
        end
        else begin//queue7 was not empty,queue first address remain unchange
            if((i_rd_queue_data_wr == 1'b1)&&(iv_schdule_queue == 3'd7))begin
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd7)&&(ov_pkt_bufid == iv_pkt_bufid))begin
                    rv_queue7_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue7_first_addr    <= iv_rd_queue_data;
                end
            end
            else begin
                if((i_queue_id_wr == 1'b1)&&(iv_queue_id == 3'd7)&&(rv_pkt_bufid_delay[8:0] == iv_pkt_bufid) && (rv_pkt_bufid_delay[9] == 1'b1))begin
                    rv_queue7_first_addr    <= iv_pkt_next_bufid;
                end
                else begin
                    rv_queue7_first_addr    <= rv_queue7_first_addr;
                end
            end
        end
    end
end
//////////////////////////////////////////////////
//                read address                  //
//////////////////////////////////////////////////
//read the queue base on the cache queue_frist_address
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_queue_raddr      <= 9'h0;
        o_queue_rd          <= 1'h0;
    end
    else begin                  
        if(i_schdule_queue_wr == 1'b1)begin
            o_queue_rd      <= 1'h1;
            case(iv_schdule_queue)
                3'd0:begin
                    ov_queue_raddr     <= rv_queue0_first_addr;
                end
                3'd1:begin
                    ov_queue_raddr      <= rv_queue1_first_addr;
                end
                3'd2:begin
                    ov_queue_raddr      <= rv_queue2_first_addr;
                end
                3'd3:begin
                    ov_queue_raddr      <= rv_queue3_first_addr;
                end
                3'd4:begin
                    ov_queue_raddr      <= rv_queue4_first_addr;
                end
                3'd5:begin
                    ov_queue_raddr      <= rv_queue5_first_addr;
                end
                3'd6:begin
                    ov_queue_raddr      <= rv_queue6_first_addr;
                end
                3'd7:begin
                    ov_queue_raddr      <= rv_queue7_first_addr;
                end 
                default:begin
                    ov_queue_raddr      <= ov_queue_raddr;
                end
            endcase
        end
        else begin
            o_queue_rd          <= 1'h0;
        end         
    end
end

endmodule