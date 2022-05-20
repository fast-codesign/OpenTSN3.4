// Copyright (C) 1953-2020 NUDT
// Verilog module name - pkt_read_control
// Version: PRC_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         receive pkt_bufid,and convert it into read address
//         read pkt data from pkt_centralize_bufm_memory on the basis of read address
//         one network interface have one pkt_read_control 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module pkt_read_control
(
       i_clk,
       i_rst_n,
              
       iv_pkt_bufid,
       i_pkt_bufid_wr,
       o_pkt_bufid_ack,
       
       ov_pkt_bufid,
       o_pkt_bufid_wr,
       i_pkt_bufid_ack, 
       
       ov_pkt_raddr,
       o_pkt_rd,
       i_pkt_raddr_ack,
       
       i_pkt_rd_req,
       i_pkt_tx_finish,
       
       ov_prc_state
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
// pkt_bufid from network_output_schedule                    
input      [8:0]       iv_pkt_bufid;            //the id of pkt cached in the bufm_memory   
input                  i_pkt_bufid_wr;          
output reg             o_pkt_bufid_ack;
// pkt_bufid to PCB in order to release pkt_bufid
output reg [8:0]       ov_pkt_bufid;
output reg             o_pkt_bufid_wr;
input                  i_pkt_bufid_ack; 
// read address to PCB in order to read pkt data       
output reg [15:0]      ov_pkt_raddr;
output reg             o_pkt_rd;
input                  i_pkt_raddr_ack;
// read finish and read request from output_control
input                  i_pkt_rd_req;
input                  i_pkt_tx_finish;

output reg [1:0]       ov_prc_state;      
////////////////////////////////////////
//        caching a pkt_bufid         //
////////////////////////////////////////
// cache a pkt_bufid in order to read data and schedule at the same time
// and did it for receive a pkt_bufid when read pkt data
reg        [9:0]      rv_cache_pkt_bufid;//incldue 1bit valid,and 9bit pkt_bufid

always @(posedge i_clk or negedge i_rst_n)begin
    if(i_rst_n == 1'b0)begin
        rv_cache_pkt_bufid  <= 10'h0;
    end
    else begin
        if(i_pkt_bufid_wr == 1'b1)begin // receive a pkt_bufid
            rv_cache_pkt_bufid  <= {1'b1,iv_pkt_bufid};
        end
        else if(o_pkt_bufid_ack == 1'b1)begin // used a pkt_bufid
            rv_cache_pkt_bufid  <= {1'b0,rv_cache_pkt_bufid[8:0]};
        end
        else begin
            rv_cache_pkt_bufid  <= rv_cache_pkt_bufid;
        end
    end
end

//////////////////////////////////////////////////
//                 state                        //
//////////////////////////////////////////////////
reg        [15:0]       rv_read_base_addr;//save the base address of read pkt data
reg        [3:0]        rv_delay_cycle;

localparam              IDLE_S        = 2'd0,
                        READ_FIRST_S  = 2'd1,
                        READ_S        = 2'd2,
                        ACK_S         = 2'd3;

always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_pkt_raddr        <= 16'h0;
        o_pkt_rd            <= 1'b0;
        rv_read_base_addr   <= 16'h0;
        o_pkt_bufid_ack     <= 1'h0;
        rv_delay_cycle      <= 4'h0;
        
        ov_prc_state           <= IDLE_S;
    end
    else begin
        case(ov_prc_state)
            IDLE_S:begin//convert pkt_bufid to base address,when the register have a valid pkt_bufid
                o_pkt_rd             <= 1'b0;
                rv_delay_cycle       <= 4'h0;
                if(rv_cache_pkt_bufid[9] == 1'b1)begin
                    rv_read_base_addr   <= {rv_cache_pkt_bufid[8:0],7'h0};
                    o_pkt_bufid_ack     <= 1'b1;
                    ov_prc_state           <= READ_FIRST_S;
                end
                else begin
                    rv_read_base_addr   <= rv_read_base_addr;
                    o_pkt_bufid_ack     <= 1'b0;
                    ov_prc_state           <= IDLE_S;
                end
            end
            
            READ_FIRST_S:begin//start read pkt data
                o_pkt_bufid_ack     <= 1'b0;
                ov_pkt_raddr        <= rv_read_base_addr;
                if(i_pkt_rd_req == 1'b1)begin
                    o_pkt_rd            <= 1'b1;
                    ov_prc_state           <= ACK_S;
                end
                else begin
                    o_pkt_rd            <= 1'b0;
                    ov_prc_state           <= READ_FIRST_S;
                end
            end
            
            READ_S:begin//read pkt data 
                if(rv_delay_cycle == 4'h2)begin //delayed 2 cycle,because read pkt from pkt_centralize_bufm_memory have two cycle delays
                    if(i_pkt_tx_finish == 1'b0)begin
                        o_pkt_rd            <= 1'b0;
                        rv_delay_cycle      <= rv_delay_cycle + 4'd1;
                        ov_prc_state           <= READ_S;
                    end
                    else begin
                        o_pkt_rd            <= 1'b0;
                        ov_prc_state           <= IDLE_S;
                    end
                end 
                else if(rv_delay_cycle == 4'h4)begin//delayed 3 cycle,i_pkt_id_req after readed pkt have two cycle delay
                    rv_delay_cycle      <= rv_delay_cycle;
                    if(i_pkt_rd_req == 1'b1)begin
                        ov_pkt_raddr        <= ov_pkt_raddr + 16'h1;
                        o_pkt_rd            <= 1'b1;
                        ov_prc_state           <= ACK_S;
                    end
                    else begin
                        o_pkt_rd            <= 1'b0;
                        ov_prc_state           <= READ_S;
                    end
                end
                else begin
                    o_pkt_rd            <= 1'b0;
                    rv_delay_cycle      <= rv_delay_cycle + 4'd1;
                    ov_prc_state           <= READ_S;
                end
            end
            
            ACK_S:begin//wait ack until pkt send finish
                rv_delay_cycle      <= 4'd0;
                if(i_pkt_raddr_ack == 1'b1)begin
                    o_pkt_rd            <= 1'b0;
                    ov_prc_state           <= READ_S;
                end
                else begin
                    o_pkt_rd            <= 1'b1;
                    ov_prc_state           <= ACK_S;
                end
            end
            
            default:begin
                ov_pkt_raddr        <= 16'h0;
                o_pkt_rd            <= 1'b0;
                rv_read_base_addr   <= 16'h0;
                o_pkt_bufid_ack     <= 1'h0;
                
                ov_prc_state           <= IDLE_S;       
            end
        endcase
    end
end


////////////////////////////////////////
//        release  pkt_bufid          //
////////////////////////////////////////
// after use a pkt_bufid,have to release it to PCB
always @(posedge i_clk or negedge i_rst_n)begin
    if(i_rst_n == 1'b0)begin
        ov_pkt_bufid    <= 9'h0;
        o_pkt_bufid_wr  <= 1'h0;    
    end
    else begin
        if(i_pkt_tx_finish == 1'b1)begin // pkt_bufid had use up
            ov_pkt_bufid    <= rv_read_base_addr[15:7];
            o_pkt_bufid_wr  <= 1'h1;
        end
        else if(i_pkt_bufid_ack == 1'b1)begin // the pkt_bufid had release
            ov_pkt_bufid    <= ov_pkt_bufid;
            o_pkt_bufid_wr  <= 1'h0;
        end
        else begin
            ov_pkt_bufid    <= ov_pkt_bufid;
            o_pkt_bufid_wr  <= o_pkt_bufid_wr;
        end
    end
end

endmodule