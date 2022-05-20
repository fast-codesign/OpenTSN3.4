// Copyright (C) 1953-2020 NUDT
// Verilog module name - tsntag_process
// Version: V3.4.0.20220404
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tsntag_process
(
       i_clk,
       i_rst_n,

       i_standardpkt_tsnpkt_flag,
       i_replication_flag,
       iv_tsntag,
       iv_pkt_type,
       i_hit,      
       iv_data,
       i_data_wr,  
       
       ov_tsntag,
       ov_pkt_type,       
       o_hit,             
       ov_data,       
       o_data_wr ,  
       o_replication_flag,       
       o_standardpkt_tsnpkt_flag         
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
// receive pkt data from pkt_centralize_bufm_memory
input                  i_standardpkt_tsnpkt_flag;
input                  i_replication_flag;
input      [47:0]      iv_tsntag;
input      [2:0]       iv_pkt_type;
input                  i_hit;
input      [8:0]       iv_data;
input                  i_data_wr;

output reg  [47:0]     ov_tsntag;
output reg  [2:0]      ov_pkt_type;
output reg             o_hit;
output reg  [8:0]      ov_data;
output reg             o_data_wr;
output reg             o_replication_flag;
output reg             o_standardpkt_tsnpkt_flag;

//***************************************************
//               cache tsntag 
//***************************************************
reg      [47:0] rv_tsntag;
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        rv_tsntag <= 48'b0;
    end
    else begin  
        if(i_data_wr)begin
            rv_tsntag <= iv_tsntag;
        end
        else begin
            rv_tsntag <= rv_tsntag;
        end
    end
end
////////////////////////////////////////
//        save pkt data in register   //
////////////////////////////////////////
reg        [11:0]        rv_pkt_cycle_cnt; 

reg        [3:0]        ttp_state;         
localparam              IDLE_S             = 3'd0,
                        TSNTAG_TM_S        = 3'd1,
                        TRANS_FIRST_DATA_S = 3'd2;

always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_tsntag<= 48'b0;
        ov_pkt_type<= 3'b0;
        rv_pkt_cycle_cnt <= 12'b0;
        o_hit<= 1'b0;
        ov_data<= 9'b0;
        o_data_wr<= 1'b0;
        o_replication_flag <= 1'b0; 
        o_standardpkt_tsnpkt_flag<= 1'b0; 
        ttp_state <= IDLE_S;
    end
    else begin
        case(ttp_state)
            IDLE_S:begin        
                if((i_data_wr== 1'b1)&&(iv_data[8] == 1'b1))begin//first byte
                    if(i_hit)begin
                        ov_tsntag <= iv_tsntag;
                        ov_pkt_type <= iv_pkt_type;
                        o_hit  <= i_hit; 
                        ov_data <= {iv_data[8],iv_tsntag[47:40]}; 
                        o_data_wr<= i_data_wr;
                        o_replication_flag <= i_replication_flag; 
                        o_standardpkt_tsnpkt_flag<= i_standardpkt_tsnpkt_flag; 
                        ttp_state <= TSNTAG_TM_S;
                    end
                    else begin
                        ov_tsntag <= iv_tsntag;
                        ov_pkt_type <= iv_pkt_type;
                        o_hit  <= i_hit; 
                        ov_data <= iv_data; 
                        o_data_wr<= i_data_wr;
                        o_replication_flag <= i_replication_flag; 
                        o_standardpkt_tsnpkt_flag<= i_standardpkt_tsnpkt_flag; 
                        ttp_state <= TRANS_FIRST_DATA_S;
                    end
                end           
                else begin
                    ov_tsntag<= 48'b0;
                    ov_pkt_type<= 3'b0;
                    o_hit<= 1'b0;
                    ov_data<= 9'b0;
                    o_data_wr<= 1'b0;
                    o_replication_flag <= 1'b0; 
                    o_standardpkt_tsnpkt_flag<= 1'b0; 
                    ttp_state <= IDLE_S;                 
                end
            end
            TSNTAG_TM_S:begin
                if(i_data_wr)begin
                    rv_pkt_cycle_cnt  <= rv_pkt_cycle_cnt+ 1'b1;
                    o_data_wr<= i_data_wr;
                    if(rv_pkt_cycle_cnt==12'd0)begin
                        ov_data <= {iv_data[8],rv_tsntag[39:32]};
                    end
                    else if(rv_pkt_cycle_cnt==12'd1)begin
                        ov_data <= {iv_data[8],rv_tsntag[31:24]};
                    end
                    else if(rv_pkt_cycle_cnt==12'd2)begin
                        ov_data <= {iv_data[8],rv_tsntag[23:16]};
                    end
                    else if(rv_pkt_cycle_cnt==12'd3)begin
                        ov_data <= {iv_data[8],rv_tsntag[15:8]};
                    end
                    else if(rv_pkt_cycle_cnt==12'd4)begin
                        ov_data <= {iv_data[8],rv_tsntag[7:0]};
                    end					
					else if (rv_pkt_cycle_cnt==12'd11)begin//first
						ov_data <= {1'b0,8'h18};
					end
					else if (rv_pkt_cycle_cnt==12'd12)begin//first
						ov_data <= {1'b0,8'h00};
					end					
                    else begin 
                        ov_data <= iv_data;
                    end
                    ttp_state <= TSNTAG_TM_S;           
                end
                else begin
                    rv_pkt_cycle_cnt  <= 12'b0;
                    ov_data<= 9'b0;
                    o_data_wr<= 1'b0;
                    ttp_state <= IDLE_S;
                end       
            end
            TRANS_FIRST_DATA_S:begin
                if(i_data_wr)begin
                    o_data_wr<= i_data_wr;
                    ov_data <= iv_data;
                    ttp_state <= TRANS_FIRST_DATA_S;           
                end
                else begin
                    rv_pkt_cycle_cnt  <= 12'b0;
                    ov_data<= 9'b0;
                    o_data_wr<= 1'b0;
                    ttp_state <= IDLE_S;
                end            
            end            
            default:begin
                rv_pkt_cycle_cnt  <= 12'b0;
                ov_data<= 9'b0;
                o_data_wr<= 1'b0;
                ttp_state <= IDLE_S;            
            end            
        endcase    

     end
end
endmodule