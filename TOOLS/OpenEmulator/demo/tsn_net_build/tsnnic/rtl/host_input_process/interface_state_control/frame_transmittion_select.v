// Copyright (C) 1953-2022 NUDT
// Verilog module name - frame_transmittion_select
// Version: V3.4.0.20220224
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         frame_transmittion_select
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module frame_transmittion_select
(
        i_clk,
        i_rst_n,

        i_rc_rxenable    ,
        i_st_rxenable    ,
        i_hardware_initial_finish,
        
        iv_data,
        i_data_wr,  

        ov_data,
        o_data_wr,
        ov_eth_type,
		o_standardpkt_tsnpkt_flag,

        ov_pkt_cnt
);

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
//configuration
input                   i_rc_rxenable    ;
input                   i_st_rxenable    ;
input                   i_hardware_initial_finish;
// fifo read
input       [8:0]       iv_data;
input                   i_data_wr;
// data output
output  reg [8:0]       ov_data;
output  reg             o_data_wr;
output  reg [15:0]      ov_eth_type;
output  reg             o_standardpkt_tsnpkt_flag;

output  reg [31:0]      ov_pkt_cnt;
//***************************************************
//                delay 14 cycles
//***************************************************
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
            tsn_s       = 3'd1,			
            standard_s  = 3'd2,
			tran_s      = 3'd3,
			discard_s   = 3'd4;
            
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        ov_data                   <= 9'b0;
        o_data_wr                 <= 1'b0;
        ov_eth_type               <= 16'b0;
        o_standardpkt_tsnpkt_flag <= 1'b0;
        ov_pkt_cnt                <= 32'b0;
        rv_fts_state              <= idle_s;
        end
    else begin
        case(rv_fts_state)
            idle_s:begin
                if(rv_data[125])begin//first cycle
                    ov_eth_type  <= {rv_data[16:9],rv_data[7:0]};                
                    if(!i_hardware_initial_finish)begin//initial bufid stage
                        ov_data                   <= 9'b0;
                        o_data_wr                 <= 1'b0;
						o_standardpkt_tsnpkt_flag <= 1'b0;						
                        rv_fts_state              <= discard_s;
                    end                   
                    else begin
                        if((!i_rc_rxenable) && (!i_st_rxenable))begin//configure stage
                            if({rv_data[16:9],rv_data[7:0]} == 16'h1800)begin                            
                                ov_data                   <= 9'b0;
                                o_data_wr                 <= 1'b0;
                                o_standardpkt_tsnpkt_flag <= 1'b0;						
                                rv_fts_state              <= discard_s;                              
                            end
                            else begin
                                ov_data                   <= rv_data[125:117];
                                o_data_wr                 <= 1'b1;
                                o_standardpkt_tsnpkt_flag <= 1'b1;						
                                ov_pkt_cnt                <= ov_pkt_cnt + 1'b1;
                                rv_fts_state              <= tran_s;                      
                            end
                        end
                        else if(i_rc_rxenable && (!i_st_rxenable))begin//configure finish
                            if(({rv_data[16:9],rv_data[7:0]} == 16'h1800)&&(rv_data[124:122] <= 3'h2))begin
                                ov_data                   <= 9'b0;
                                o_data_wr                 <= 1'b0;
                                o_standardpkt_tsnpkt_flag <= 1'b0;						
                                rv_fts_state              <= discard_s; 
                            end
                            else begin
                                ov_data                    <= rv_data[125:117];
                                o_data_wr                  <= 1'b1;					
                                ov_pkt_cnt                 <= ov_pkt_cnt + 1'b1;
                                rv_fts_state               <= tran_s; 
                                if({rv_data[16:9],rv_data[7:0]} == 16'h1800)begin
                                    o_standardpkt_tsnpkt_flag  <= 1'b0;
                                end
                                else begin
                                    o_standardpkt_tsnpkt_flag  <= 1'b1;
                                end                            
                            end
                        end
                        else if(i_rc_rxenable && i_st_rxenable)begin//initial sync finish
                            ov_data                    <= rv_data[125:117];
                            o_data_wr                  <= 1'b1;						
                            ov_pkt_cnt                 <= ov_pkt_cnt + 1'b1;
                            rv_fts_state               <= tran_s;
                            if({rv_data[16:9],rv_data[7:0]} == 16'h1800)begin
                                o_standardpkt_tsnpkt_flag  <= 1'b0;
                            end
                            else begin
                                o_standardpkt_tsnpkt_flag  <= 1'b1;
                            end 
                        end
                        else begin
                            ov_data                    <= 9'b0;
                            o_data_wr                  <= 1'b0;
                            o_standardpkt_tsnpkt_flag  <= 1'b0;						
                            rv_fts_state               <= discard_s;
                        end
                    end
                end		
				else begin
                	ov_data                   <= 9'b0;
			        o_data_wr                 <= 1'b0;
                    ov_eth_type               <= 16'b0;
                    o_standardpkt_tsnpkt_flag <= 1'b0;
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
            discard_s:begin
                ov_data                    <= 9'b0;
                o_data_wr                  <= 1'b0;  
                if(rv_data[125]) begin//last cycle.				
                    rv_fts_state           <= idle_s;
                end              
                else begin
                    rv_fts_state           <= discard_s;
                end            
            end
            default:begin
                ov_data                    <= 9'b0;
                o_data_wr                  <= 1'b0;
				o_standardpkt_tsnpkt_flag  <= 1'b0;
                rv_fts_state               <= idle_s;              
            end
        endcase
    end
end       
endmodule