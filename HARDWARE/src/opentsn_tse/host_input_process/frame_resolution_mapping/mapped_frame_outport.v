// Copyright (C) 1953-2021 NUDT
// Verilog module name - mapped_frame_outport
// Version: V3.2.2.20211102
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         descriptor extract
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module mapped_frame_outport
(
        i_clk,
        i_rst_n,
            
        iv_tsntag,
        i_replication_flag,
        i_hit,
        i_lookup_finish_wr,
		i_standardpkt_tsnpkt_flag,	

        i_fifo_empty,
        o_fifo_rd,
        iv_fifo_rdata,

		o_standardpkt_tsnpkt_flag,	
        o_replication_flag,
        ov_tsntag,
        ov_pkt_type,
        o_hit,        
        ov_data,
        o_data_wr
    );
// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
//input
input       [47:0]      iv_tsntag;
input                   i_replication_flag;
input                   i_hit;
input                   i_lookup_finish_wr; 

input                   i_standardpkt_tsnpkt_flag;

input                   i_fifo_empty;
output reg              o_fifo_rd;
input       [8:0]       iv_fifo_rdata;
//output 
output reg              o_standardpkt_tsnpkt_flag;

output reg  [47:0]      ov_tsntag;
output reg  [2:0]       ov_pkt_type;
output reg              o_hit;
output reg  [8:0]       ov_data;
output reg              o_data_wr;
output reg              o_replication_flag;

reg         [49:0]      rv_lookup_table_result;
reg                     rv_ts_pktflag;
reg         [1:0]       rv_mfo_state;
localparam  IDLE_S      = 2'd0,
            TRANS_FIRST_CYCLE_S     = 2'd1,
            TRANS_NOT_FIRST_CYCLE_S = 2'd2;
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        rv_lookup_table_result <= 50'b0;
        rv_ts_pktflag       <= 1'b0;
        
        o_fifo_rd           <= 1'b0;

        o_standardpkt_tsnpkt_flag <= 1'b0;
        
        ov_tsntag           <= 48'b0;
        ov_pkt_type         <= 3'b0;
        o_hit               <= 1'b0;
        ov_data             <= 9'b0;
        o_data_wr           <= 1'b0;
        
        rv_mfo_state        <= IDLE_S;
    end
    else begin
        case(rv_mfo_state)
            IDLE_S:begin 
                o_standardpkt_tsnpkt_flag <= 1'b0;
        
                ov_tsntag           <= 48'b0;
                ov_pkt_type         <= 3'b0;
                o_hit               <= 1'b0;
                ov_data             <= 9'b0;
                o_replication_flag  <= 1'b0;
                o_data_wr           <= 1'b0;  
                if(i_lookup_finish_wr)begin
                    rv_lookup_table_result <= {i_hit,i_replication_flag,iv_tsntag};//lookup table result need to output with pkt together.
                    rv_ts_pktflag <= i_standardpkt_tsnpkt_flag;//standardpkt_tsnpkt_flag and timestamps need to output with pkt together.

                    o_fifo_rd     <= 1'b1;
                    rv_mfo_state  <= TRANS_FIRST_CYCLE_S;                    
                end
                else begin                    
                    rv_lookup_table_result <= 50'b0;
                    rv_ts_pktflag          <= 1'b0;
                    
                    o_fifo_rd              <= 1'b0;
                    rv_mfo_state           <= IDLE_S;
                end
            end
            TRANS_FIRST_CYCLE_S:begin
        
                ov_tsntag      <= rv_lookup_table_result[47:0];
                ov_pkt_type         <= rv_lookup_table_result[47:45];
                o_hit               <= rv_lookup_table_result[49];
                o_replication_flag  <= rv_lookup_table_result[48];
                if(rv_lookup_table_result[49])begin//hit
                    o_standardpkt_tsnpkt_flag <= 1'b0;
                end
                else begin
                    o_standardpkt_tsnpkt_flag <= rv_ts_pktflag;
                end
                ov_data             <= iv_fifo_rdata;
                o_data_wr           <= 1'b1;

                o_fifo_rd           <= 1'b1;                
                rv_mfo_state        <= TRANS_NOT_FIRST_CYCLE_S;                
            end
            TRANS_NOT_FIRST_CYCLE_S:begin
                o_standardpkt_tsnpkt_flag <= o_standardpkt_tsnpkt_flag;
        
                ov_tsntag           <= ov_tsntag;
                ov_pkt_type         <= ov_pkt_type;
                o_hit               <= o_hit;
                o_replication_flag  <= o_replication_flag;
                ov_data             <= iv_fifo_rdata;
                o_data_wr           <= 1'b1; 
                if(iv_fifo_rdata[8])begin//last cycle of pkt
                    o_fifo_rd           <= 1'b0; 
                    rv_mfo_state        <= IDLE_S;                 
                end
                else begin
                    o_fifo_rd           <= 1'b1; 
                    rv_mfo_state        <= TRANS_NOT_FIRST_CYCLE_S;                
                end
               
            end            
            default:begin
                rv_lookup_table_result <= 50'b0;
                rv_ts_pktflag       <= 1'b0;                
                o_fifo_rd           <= 1'b0;
                o_standardpkt_tsnpkt_flag <= 1'b0;
                o_replication_flag  <= 1'b0;         
                ov_tsntag           <= 48'b0;
                ov_pkt_type         <= 3'b0;
                o_hit               <= 1'b0;
                ov_data             <= 9'b0;
                o_data_wr           <= 1'b0;
                
                rv_mfo_state        <= IDLE_S;
            end
        endcase
    end
end    
endmodule