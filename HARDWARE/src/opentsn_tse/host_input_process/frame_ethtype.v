// Copyright (C) 1953-2022 NUDT
// Verilog module name - frame_ethtype
// Version: V3.4.0.20220224
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         frame_ethtype
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module frame_ethtype
(
       i_clk,
       i_rst_n,

       i_standardpkt_tsnpkt_flag,
       i_replication_flag,
       iv_tsntag,
       i_hit,      
       iv_data,
       i_data_wr,  
       
       ov_tsntag,
       ov_eth_type,       
       o_hit,             
       ov_data,       
       o_data_wr ,  
       o_replication_flag,       
       o_standardpkt_tsnpkt_flag 
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;

input                  i_standardpkt_tsnpkt_flag;
input                  i_replication_flag;
input      [47:0]      iv_tsntag;
input                  i_hit;
input      [8:0]       iv_data;
input                  i_data_wr;

output reg  [47:0]     ov_tsntag;
output reg  [15:0]     ov_eth_type;
output reg             o_hit;
output reg  [8:0]      ov_data;
output reg             o_data_wr;
output reg             o_replication_flag;
output reg             o_standardpkt_tsnpkt_flag;
//***************************************************
//                delay 14 cycles
//***************************************************
reg            		 r_hit                    ;
reg   [47:0]         rv_tsntag                ;
reg                  r_replication_flag       ;
reg                  r_standardpkt_tsnpkt_flag;

always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        r_hit                       <= 1'h0;
		rv_tsntag                   <= 48'h0;
		r_replication_flag          <= 1'h0;
		r_standardpkt_tsnpkt_flag   <= 1'h0;
    end
    else begin
        if((i_data_wr == 1'b1)&&(iv_data[8] == 1'b1))begin//write a pkt data to register
            r_hit                       <= i_hit                    ;
			rv_tsntag                   <= iv_tsntag                ;
            r_replication_flag          <= i_replication_flag       ;
            r_standardpkt_tsnpkt_flag   <= i_standardpkt_tsnpkt_flag;			
        end
        else begin
            r_hit                       <= r_hit                    ;
			rv_tsntag                   <= rv_tsntag                ;
			r_replication_flag          <= r_replication_flag       ;
			r_standardpkt_tsnpkt_flag   <= r_standardpkt_tsnpkt_flag;
        end
    end
end

reg       [125:0]       rv_data;
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        rv_data   <= 126'h0;
    end
    else begin
        if(i_data_wr == 1'b1)begin//write a pkt data to register
            rv_data     <= {rv_data[116:0],iv_data};      
        end
        else begin
            rv_data     <= {rv_data[116:0],9'b0};
        end
    end
end
//***************************************************
//                delay 14 cycles
//***************************************************
reg         [2:0]       rv_fts_state;
// internal reg&wire
localparam  idle_s      = 3'd0,
			tran_s      = 3'd1;
            
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        ov_data                   <= 9'b0;   
        o_data_wr                 <= 1'b0;   
        ov_eth_type               <= 16'b0;  
        o_standardpkt_tsnpkt_flag <= 1'b0;   
		o_hit                     <= 1'b0;             
		ov_tsntag                 <= 48'b0;           
		o_replication_flag        <= 1'b0;
        rv_fts_state              <= idle_s;  
        end
    else begin
        case(rv_fts_state)
            idle_s:begin
                if(rv_data[125])begin//first cycle
                    ov_eth_type  <= {rv_data[16:9],rv_data[7:0]};                
                    ov_data      <= rv_data[125:117];
                    o_data_wr    <= 1'b1;
                    o_standardpkt_tsnpkt_flag <= r_standardpkt_tsnpkt_flag ; 
					o_hit                     <= r_hit                     ; 
					ov_tsntag                 <= rv_tsntag ;
					o_replication_flag        <= r_replication_flag ;					
                    rv_fts_state              <= tran_s;                      
                end	
				else begin
					ov_data                   <= 9'b0;   
					o_data_wr                 <= 1'b0;   
					ov_eth_type               <= 16'b0;  
					o_standardpkt_tsnpkt_flag <= 1'b0;   
					o_hit                     <= 1'b0;             
					ov_tsntag                 <= 48'b0;           
					o_replication_flag        <= 1'b0;
					rv_fts_state              <= idle_s;
                end
			end		
            tran_s:begin
                ov_data                    <= rv_data[125:117];
                o_data_wr                  <= 1'b1;  
                if(rv_data[125]) begin//last cycle.				
                    rv_fts_state           <= idle_s;
                end              
                else begin
                    rv_fts_state           <= tran_s;
                end
            end
            default:begin
			    ov_data                   <= 9'b0;   
			    o_data_wr                 <= 1'b0;   
			    ov_eth_type               <= 16'b0;  
			    o_standardpkt_tsnpkt_flag <= 1'b0;   
			    o_hit                     <= 1'b0;             
			    ov_tsntag                 <= 48'b0;           
			    o_replication_flag        <= 1'b0;
                rv_fts_state               <= idle_s;              
            end
        endcase
    end
end       
endmodule