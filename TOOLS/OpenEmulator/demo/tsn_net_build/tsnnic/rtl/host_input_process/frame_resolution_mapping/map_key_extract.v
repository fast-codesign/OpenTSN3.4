// Copyright (C) 1953-2021 NUDT
// Verilog module name - map_key_extract
// Version: V3.2.3.20211102
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         extract five tuples of packet.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module map_key_extract
(
        i_clk,
        i_rst_n,
       
        iv_data,
        i_data_wr, 
		i_standardpkt_tsnpkt_flag,	

		o_standardpkt_tsnpkt_flag,	
        
        ov_5tuple_data,
        o_5tuple_data_wr,
       
        ov_identification,
        o_first_fragment,
        
        o_ip_flag,
        o_tcp_or_udp_flag    
);  
// I/O
// clk & rst  
input                i_clk;
input                i_rst_n;
//pkt input
input        [8:0]   iv_data;
input                i_data_wr;
input                i_standardpkt_tsnpkt_flag;

output reg           o_standardpkt_tsnpkt_flag;
//five tuple
output reg   [103:0] ov_5tuple_data;
output reg           o_5tuple_data_wr;

output reg   [15:0]  ov_identification;
output reg           o_first_fragment;
//dmac
output reg           o_ip_flag;
output reg           o_tcp_or_udp_flag;
//***************************************************
//          extract five tuple from pkt 
//***************************************************
// internal reg&wire for state machine
reg         [12:0]     rv_frag_offset;

reg         [11:0]     rv_cycle_cnt;
reg         [15:0]     rv_eth_type;
reg         [3:0]      fte_state;
localparam  IDLE_S              = 4'd0,
            EXTRACT_DMAC_S      = 4'd1,
            JUDGE_ETHTYPE_S     = 4'd2,
            EXTRACT_FRAG_INFO_S        = 4'd3,
            JUDGE_IPPROTOCOL_S  = 4'd4,
            EXTRACT_SIP_S       = 4'd5,
            EXTRACT_DIP_S       = 4'd6,
            EXTRACT_SPORT_S     = 4'd7,
            EXTRACT_DPORT_S     = 4'd8,
            DELAY_TRANSMIT_S    = 4'd9,
            WAIT_LAST_CYCLE_S   = 4'd10;
always@(posedge i_clk or negedge i_rst_n)begin 
    if(!i_rst_n) begin 
        o_standardpkt_tsnpkt_flag <= 1'b0;
     
        ov_5tuple_data <= 104'b0;
        o_5tuple_data_wr <= 1'b0;
        
        rv_frag_offset <= 13'b0;
        o_first_fragment <= 1'b0;
        ov_identification <= 16'b0;

        o_ip_flag <= 1'b0;
        o_tcp_or_udp_flag <= 1'b0;
        
        rv_cycle_cnt <= 12'b0;
        rv_eth_type <= 16'b0;
        fte_state <= IDLE_S;
    end
    else begin
        case(fte_state)
            IDLE_S:begin
                ov_5tuple_data <= 104'b0;
                o_5tuple_data_wr <= 1'b0;
                rv_frag_offset <= 13'b0;
                o_first_fragment <= 1'b0;
                ov_identification <= 16'b0;
                
                o_ip_flag <= 1'b0;
                o_tcp_or_udp_flag <= 1'b0; 
                rv_eth_type <= 16'b0;                
                if(i_data_wr && iv_data[8])begin
                    o_standardpkt_tsnpkt_flag <= i_standardpkt_tsnpkt_flag;                
                
                    rv_cycle_cnt<= rv_cycle_cnt+ 1'b1;
                    fte_state <= EXTRACT_DMAC_S; 
                end
                else begin
                    rv_cycle_cnt <= 12'b0;
                    fte_state <= IDLE_S;              
                end
            end
            EXTRACT_DMAC_S:begin
                rv_cycle_cnt<= rv_cycle_cnt+ 1'b1;
                if(rv_cycle_cnt == 12'd5)begin
                    fte_state <= JUDGE_ETHTYPE_S;   
                end
                else begin
                    fte_state <= EXTRACT_DMAC_S;                   
                end
            end
            JUDGE_ETHTYPE_S:begin
                rv_cycle_cnt<= rv_cycle_cnt+ 1'b1;
                if(rv_cycle_cnt == 12'd12)begin
                    rv_eth_type <= {iv_data[7:0],8'b0};
                end
                else if(rv_cycle_cnt == 12'd13)begin
                    rv_eth_type <= {rv_eth_type[15:8],iv_data[7:0]};
                end
                else if(rv_cycle_cnt == 12'd14)begin
                    if(rv_eth_type == 16'h0800)begin
                        o_ip_flag <= 1'b1;
                        fte_state <= EXTRACT_FRAG_INFO_S; 
                    end
                    else begin
                        o_ip_flag <= 1'b0;
                        fte_state <= DELAY_TRANSMIT_S;
                    end
                end
                else begin
                    rv_eth_type <= rv_eth_type;
                end
            end
            EXTRACT_FRAG_INFO_S:begin
                rv_cycle_cnt<= rv_cycle_cnt+ 1'b1;
                if(rv_cycle_cnt == 12'd18)begin
                    ov_identification[15:8]  <= iv_data[7:0];     
                end
                else if(rv_cycle_cnt == 12'd19)begin
                    ov_identification[7:0]  <= iv_data[7:0]; 
                end
                else if(rv_cycle_cnt == 12'd20)begin
                    ov_identification  <= ov_identification;
                    rv_frag_offset[12:8] <= iv_data[4:0];                    
                end
                else if(rv_cycle_cnt == 12'd21)begin
                    rv_frag_offset[7:0] <= iv_data[7:0];
                    fte_state <= JUDGE_IPPROTOCOL_S; 
                    if({rv_frag_offset[12:8],iv_data[7:0]} == 13'b0)begin//frag_offset == 13'b0,the packet is first frag.
                        o_first_fragment <= 1'b1;
                    end
                    else begin
                        o_first_fragment <= 1'b0;
                    end                   
                end
                else begin
                    fte_state <= EXTRACT_FRAG_INFO_S;
                end                
            end
            JUDGE_IPPROTOCOL_S:begin
                rv_cycle_cnt<= rv_cycle_cnt+ 1'b1;
                if(rv_cycle_cnt < 12'd23)begin
                    fte_state <= JUDGE_IPPROTOCOL_S;
                end
                else if((rv_cycle_cnt == 12'd23)&&((iv_data[7:0] == 8'h6)||(iv_data[7:0] == 8'h11)))begin//ip protocol
                    o_tcp_or_udp_flag <= 1'b1;
                    ov_5tuple_data[103:96] <= iv_data[7:0];
                    fte_state <= EXTRACT_SIP_S;
                end
                else begin
                    o_tcp_or_udp_flag <= 1'b0;
                    fte_state <= DELAY_TRANSMIT_S;
                end            
            end
            EXTRACT_SIP_S:begin
                rv_cycle_cnt<= rv_cycle_cnt+ 1'b1;
                if(rv_cycle_cnt == 12'd26)begin
                    ov_5tuple_data[95:88]  <= iv_data[7:0];
                end
                else if(rv_cycle_cnt == 12'd27)begin
                    ov_5tuple_data[87:80]  <= iv_data[7:0];
                end
                else if(rv_cycle_cnt == 12'd28)begin
                    ov_5tuple_data[79:72]  <= iv_data[7:0];
                end
                else if(rv_cycle_cnt == 12'd29)begin
                    ov_5tuple_data[71:64]  <= iv_data[7:0];
                    fte_state <= EXTRACT_DIP_S;
                end                
                else begin
                    fte_state <= EXTRACT_SIP_S;
                end 
            end
            EXTRACT_DIP_S:begin
                rv_cycle_cnt<= rv_cycle_cnt+ 1'b1;
                if(rv_cycle_cnt == 12'd30)begin
                    ov_5tuple_data[63:56]  <= iv_data[7:0];	
                end
                else if(rv_cycle_cnt == 12'd31)begin
                    ov_5tuple_data[55:48]  <= iv_data[7:0];	
                end
                else if(rv_cycle_cnt == 12'd32)begin
                    ov_5tuple_data[47:40]  <= iv_data[7:0];
                end
                else if(rv_cycle_cnt == 12'd33)begin
                    ov_5tuple_data[39:32]  <= iv_data[7:0];
                    fte_state <= EXTRACT_SPORT_S;
                end                
                else begin
                    fte_state <= EXTRACT_DIP_S;
                end 
            end
            EXTRACT_SPORT_S:begin
                rv_cycle_cnt<= rv_cycle_cnt+ 1'b1;
                if(rv_cycle_cnt == 12'd34)begin
                    ov_5tuple_data[31:24]  <= iv_data[7:0];
                end
                else if(rv_cycle_cnt == 12'd35)begin
                    ov_5tuple_data[23:16]  <= iv_data[7:0];
                    fte_state <= EXTRACT_DPORT_S;
                end                
                else begin
                    fte_state <= EXTRACT_SPORT_S;
                end 
            end
            EXTRACT_DPORT_S:begin
                rv_cycle_cnt<= rv_cycle_cnt+ 1'b1;
                if(rv_cycle_cnt == 12'd36)begin
                    ov_5tuple_data[15:8]  <= iv_data[7:0];	
                end
                else if(rv_cycle_cnt == 12'd37)begin
                    ov_5tuple_data[7:0]  <= iv_data[7:0];
                    o_5tuple_data_wr     <= 1'b1;
                    fte_state            <= WAIT_LAST_CYCLE_S;
                end                
                else begin
                    fte_state <= EXTRACT_DPORT_S;
                end 
            end
            DELAY_TRANSMIT_S:begin
                rv_cycle_cnt <= rv_cycle_cnt+ 1'b1;
                if(rv_cycle_cnt == 12'd37)begin
                    o_5tuple_data_wr     <= 1'b1;
                    fte_state            <= WAIT_LAST_CYCLE_S;
                end                
                else begin
                    fte_state            <= DELAY_TRANSMIT_S;
                end 
            end
            WAIT_LAST_CYCLE_S:begin
                ov_5tuple_data <= 104'b0;
                o_5tuple_data_wr <= 1'b0;

                o_tcp_or_udp_flag <= 1'b0;
                
                rv_cycle_cnt <= 12'b0;
                rv_eth_type <= 16'b0;            
                if(i_data_wr && iv_data[8])begin
                    fte_state            <= IDLE_S;
                end                
                else begin
                    fte_state            <= WAIT_LAST_CYCLE_S;
                end             
            end
            default:begin
                ov_5tuple_data <= 104'b0;
                o_5tuple_data_wr <= 1'b0;

                o_tcp_or_udp_flag <= 1'b0;
                
                rv_cycle_cnt <= 12'b0;
                rv_eth_type <= 16'b0;
                fte_state <= IDLE_S;
            end
        endcase            
    end
end
endmodule