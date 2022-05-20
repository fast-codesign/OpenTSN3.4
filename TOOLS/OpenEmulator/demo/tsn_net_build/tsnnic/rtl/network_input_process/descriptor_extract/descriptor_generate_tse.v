// Copyright (C) 1953-2022 NUDT
// Verilog module name - descriptor_generate
// Version: V3.4.0.20220225
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         descriptor extract
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module descriptor_generate_tse #(parameter inport = 4'b0000)
(
        i_clk,
        i_rst_n,
       
        iv_data,
        i_data_wr,
		i_standardpkt_tsnpkt_flag,
        iv_eth_type,
        iv_free_bufid_num,
        iv_hardware_stage,
        iv_hpriority_be_threshold_value,
        iv_rc_threshold_value,
        iv_lpriority_be_threshold_value,
        ov_pkt_discard_cnt,
        
        ov_data,
        o_data_wr,
        o_descriptor_valid,
        ov_descriptor,
        ov_eth_type,
        
        descriptor_extract_state
    );
// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
//input
input       [8:0]       iv_data;
input                   i_data_wr;
input                   i_standardpkt_tsnpkt_flag;
input       [15:0]      iv_eth_type;
input       [8:0]       iv_free_bufid_num;
input       [2:0]       iv_hardware_stage;
input       [8:0]       iv_hpriority_be_threshold_value;
input       [8:0]       iv_rc_threshold_value;
input       [8:0]       iv_lpriority_be_threshold_value;
output  reg [31:0]      ov_pkt_discard_cnt;
//output
output  reg [8:0]       ov_data;
output  reg             o_data_wr;
output  reg             o_descriptor_valid;
output  reg [39:0]      ov_descriptor;
output  reg [15:0]      ov_eth_type;

output  reg [3:0]       descriptor_extract_state;
//internal wire
reg         [3:0]       byte_cnt; 
reg         [2:0]       rv_pkt_type;
localparam  IDLE_S              = 4'd0,
            MAPPED_SENCOND_S    = 4'd1,
            MAPPED_THIRD_S      = 4'd2,
            MAPPED_FOURTH_S     = 4'd3,
            MAPPED_FIFTH_S      = 4'd4,
            MAPPED_OTHER_S      = 4'd5,
            TRAN_STANDARD_S     = 4'd6,
            DISC_S              = 4'd7;
always@(posedge i_clk or negedge i_rst_n)
    if(!i_rst_n) begin
        ov_data             <= 9'b0;
        o_data_wr           <= 1'b0;
        o_descriptor_valid  <= 1'b0;
        ov_descriptor       <= 40'b0;
        byte_cnt            <= 4'b0;
		rv_pkt_type         <= 3'b0;
        ov_eth_type         <= 16'b0;
        ov_pkt_discard_cnt             <= 32'b0;
        descriptor_extract_state        <= IDLE_S;
        end
    else begin
        case(descriptor_extract_state)
            IDLE_S:begin
                if((i_data_wr == 1'b1) && (iv_data[8] == 1'b1))begin//head
                    ov_data             <= iv_data;
                    ov_descriptor       <= {9'b0,iv_data[7:5],iv_data[2:0],5'b0};  
                    o_descriptor_valid  <= 1'b0;
					if(iv_eth_type != 16'h1800)begin//standard ethernet pkt
                        if(iv_eth_type == 16'hff01)begin//tsmp
                            rv_pkt_type              <= 3'd6;
                            if(iv_free_bufid_num <=  iv_hpriority_be_threshold_value) begin
                            //discard pkt when bufid under threshold or bufid is used up
                                o_data_wr                       <= 1'h0;
                                ov_pkt_discard_cnt              <= ov_pkt_discard_cnt + 1'b1;
                                descriptor_extract_state        <= DISC_S;
                            end 
                            else begin
                                o_data_wr                <= 1'h1;
                                byte_cnt                 <= 4'b1;
                                descriptor_extract_state <= TRAN_STANDARD_S;
                            end
                        end
                        else if((iv_eth_type == 16'h88f7)||(iv_eth_type == 16'h891d))begin//ptp,pcf
                            rv_pkt_type                <= 3'd6;
                            if(iv_free_bufid_num <=  iv_hpriority_be_threshold_value) begin
                            //discard pkt when bufid under threshold or bufid is used up
                                o_data_wr                       <= 1'h0;
                                ov_pkt_discard_cnt              <= ov_pkt_discard_cnt + 1'b1;
                                descriptor_extract_state        <= DISC_S;
                            end 
                            else begin
                                o_data_wr                <= 1'h1;
                                byte_cnt                 <= 4'b1;
                                descriptor_extract_state <= TRAN_STANDARD_S;
                            end                       
                        end
                        else begin 
                            rv_pkt_type         <= 3'd6;
                            if((iv_free_bufid_num <=  iv_lpriority_be_threshold_value) || (iv_free_bufid_num == 9'h0)) begin
                            //discard pkt when bufid under threshold or bufid is used up
                                o_data_wr                       <= 1'h0;
                                ov_pkt_discard_cnt              <= ov_pkt_discard_cnt + 1'b1;
                                descriptor_extract_state        <= DISC_S;
                            end 
                            else begin
                                o_data_wr           <= 1'h1;
                                byte_cnt            <= 4'b1;
                                descriptor_extract_state <= TRAN_STANDARD_S;
                            end
                        end
					end
					else begin
                        rv_pkt_type         <= iv_data[7:5];
                        case(iv_data[7:5])
                            3'd3:begin//RC
                                if((iv_free_bufid_num <= iv_rc_threshold_value) || (iv_free_bufid_num == 9'h0))begin
                                //discard pkt when bufid under threshold or bufid is used up
                                    o_data_wr                   <= 1'h0;
                                    ov_pkt_discard_cnt          <= ov_pkt_discard_cnt + 1'b1;
                                    descriptor_extract_state    <= DISC_S;
                                end
                                else begin
                                    o_data_wr                   <= 1'h1;
                                    descriptor_extract_state    <= MAPPED_SENCOND_S;
                                end
                            end
                            3'd6:begin//BE
                                if((iv_free_bufid_num <= iv_rc_threshold_value) || (iv_free_bufid_num <= iv_hpriority_be_threshold_value) || (iv_free_bufid_num == 9'h0))begin
                                //discard pkt when bufid under threshold or bufid is used up
                                    o_data_wr                   <= 1'h0;
                                    ov_pkt_discard_cnt          <= ov_pkt_discard_cnt + 1'b1;
                                    descriptor_extract_state    <= DISC_S;
                                end
                                else begin
                                    o_data_wr                   <= 1'h1;
                                    descriptor_extract_state    <= MAPPED_SENCOND_S;
                                end
                            end
                            
                            default:begin
                                if(iv_free_bufid_num == 9'h0)begin
                                    o_data_wr                   <= 1'h0;
                                    ov_pkt_discard_cnt          <= ov_pkt_discard_cnt + 1'b1;
                                    descriptor_extract_state    <= DISC_S;
                                end
                                else begin
                                    o_data_wr                   <= 1'h1;
                                    descriptor_extract_state    <= MAPPED_SENCOND_S;
                                end
                            end
                        endcase				
					end
				end
				else begin
					ov_descriptor             <= 40'b0;
					ov_data                   <= 9'b0;
					o_data_wr                 <= 1'b0;
					rv_pkt_type               <= 3'b0;
					descriptor_extract_state  <= IDLE_S;
				end
			end
            TRAN_STANDARD_S:begin           //standard ethernet type
                ov_data         <= iv_data;
                o_data_wr       <= i_data_wr;
                //state judge
                if(i_data_wr == 1'b1 && iv_data[8] ==  1'b1)begin//tail
                    descriptor_extract_state    <= IDLE_S;
                end
                else if(i_data_wr == 1'b1 && iv_data[8] ==  1'b0)begin//middle
                    descriptor_extract_state    <= TRAN_STANDARD_S;
                end
                else begin//invalid
                    descriptor_extract_state    <= IDLE_S;
                end
                //send descriptor
                if(byte_cnt < 4'd13) begin
                    byte_cnt                <= byte_cnt + 1'b1; 
                    ov_descriptor           <= {9'b0,rv_pkt_type,28'b0};                   
                    o_descriptor_valid      <= 1'b0;
                end
                else if(byte_cnt == 4'd13)begin
                    ov_eth_type         <= iv_eth_type;
                    o_descriptor_valid  <= 1'b1;
                    byte_cnt            <= byte_cnt + 1'b1;
                end
                else if(byte_cnt == 4'd14)begin
                    ov_descriptor           <= 40'b0;    
                    o_descriptor_valid      <= 1'b0;
                    ov_eth_type             <= 16'h0;
                    byte_cnt                <= byte_cnt;
                end
                else begin                              
                    byte_cnt <= byte_cnt + 1'b1;
                end
            end
            MAPPED_SENCOND_S:begin          //mapped ethernet type
                ov_data                 <= iv_data;
                o_data_wr               <= i_data_wr;
                if(i_data_wr == 1'b1 && iv_data[8] == 1'b0) begin   //middle
                    ov_descriptor           <= {ov_descriptor[39:24],iv_data[7:0],ov_descriptor[16:0]};	
                    descriptor_extract_state            <= MAPPED_THIRD_S;
                end
                else begin
                    ov_descriptor                       <= 40'b0;
                    descriptor_extract_state            <= IDLE_S;
                end
            end
            MAPPED_THIRD_S:begin
                ov_data                      <= iv_data;
                o_data_wr                    <= i_data_wr;
                if(i_data_wr == 1'b1 && iv_data[8] == 1'b0) begin   //middle
                    ov_descriptor            <= {ov_descriptor[39:17],iv_data[7:0],ov_descriptor[8:0]};	
                    descriptor_extract_state <= MAPPED_FOURTH_S;
                end
                else begin
                    ov_descriptor            <= 72'b0;
                    descriptor_extract_state <= IDLE_S;
                end
            end
            MAPPED_FOURTH_S:begin
                o_data_wr                    <= i_data_wr;
                if(i_data_wr == 1'b1 && iv_data[8] == 1'b0) begin   //middle
                    ov_data                  <= iv_data;
					ov_descriptor            <= {ov_descriptor[39:9],iv_data[7:0],ov_descriptor[0]};		
                    descriptor_extract_state <= MAPPED_FIFTH_S;
                end
                else begin
                    ov_data                  <= 9'b0;
					ov_descriptor            <= 72'b0;
                    descriptor_extract_state <= IDLE_S;
                end
            end
            MAPPED_FIFTH_S:begin
                o_data_wr                    <= i_data_wr;
                if(i_data_wr == 1'b1 && iv_data[8] == 1'b0) begin   //middle
                    ov_data                  <= iv_data;
					ov_descriptor            <={ov_descriptor[39:1],iv_data[7]};
                    o_descriptor_valid       <= 1'b1;
                    ov_eth_type         <= iv_eth_type;
                    descriptor_extract_state <= MAPPED_OTHER_S;
                end
                else begin
                    ov_data                 <= 9'b0;
                    ov_descriptor           <= 40'b0;
                    descriptor_extract_state            <= IDLE_S;
                end
            end		
            MAPPED_OTHER_S:begin
                ov_data             <= iv_data;
                o_data_wr           <= i_data_wr;
                ov_descriptor       <= 40'b0;
                o_descriptor_valid  <= 1'b0;
                if(i_data_wr == 1'b1 && iv_data[8] == 1'b1) begin//tail
                    descriptor_extract_state            <= IDLE_S;
                end
                else if(i_data_wr == 1'b1 && iv_data[8] == 1'b0)begin//middle
                    descriptor_extract_state            <= MAPPED_OTHER_S;
                end
                else begin
                    descriptor_extract_state            <= IDLE_S;
                end
            end
   
            DISC_S:begin
                ov_data                         <= 9'h0;
                o_data_wr                       <= 1'h0;
                ov_descriptor                   <= 40'b0;
                o_descriptor_valid              <= 1'b0;
                if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin
                    descriptor_extract_state        <= IDLE_S;
                end
                else begin
                    descriptor_extract_state        <= DISC_S;
                end
            end

            default:begin
                ov_data             <= 9'b0;
                o_data_wr           <= 1'b0;
                o_descriptor_valid  <= 1'b0;
                ov_descriptor       <= 40'b0;
                byte_cnt            <= 4'b0;
                descriptor_extract_state        <= IDLE_S;
            end
        endcase
    end
endmodule