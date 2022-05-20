// Copyright (C) 1953-2022 NUDT
// Verilog module name - address_dispatch
// Version: V3.4.0.20220301
// Created:
//         by - fenglin
////////////////////////////////////////////////////////////////////////////
// Description:
//         - encapsulate ARP request frame、PTP frame、NMAC report frame to tsmp frame;
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module address_dispatch
(
       i_clk,
       i_rst_n,
       
       iv_data,
	   i_data_wr,
	   
	   ov_hcp_mid,
       ov_tsnlight_mid
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;  
// pkt input
input	   [8:0]	   iv_data;
input	         	   i_data_wr;
// pkt output
output reg [11:0]	   ov_hcp_mid;
output reg [11:0]	   ov_tsnlight_mid;

reg    [1:0]  rv_adi_state;
reg    [6:0]  rv_byte_cnt;
localparam  IDLE_S           = 2'd0,
            EXTRACT_MAC_S    = 2'd1,
            DISCARD_DATA_S   = 2'd2;            
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_byte_cnt     <= 7'b0;
        ov_hcp_mid      <= 12'h0;
        ov_tsnlight_mid <= 12'h0;
		rv_adi_state    <= IDLE_S;
    end
    else begin
		case(rv_adi_state)
			IDLE_S:begin 
				if(i_data_wr && iv_data[8])begin
                    rv_byte_cnt    <= 7'd1;
                    rv_adi_state   <= EXTRACT_MAC_S;                   
                end
                else begin
                    rv_byte_cnt    <= 7'b0;
                    rv_adi_state   <= IDLE_S;                
                end
            end
            EXTRACT_MAC_S:begin
                rv_byte_cnt <= rv_byte_cnt + 1'b1;
                if(rv_byte_cnt == 7'd17)begin
                    ov_tsnlight_mid[11:4] <= iv_data[7:0];
                end
                else if(rv_byte_cnt == 7'd18)begin
                    ov_tsnlight_mid[3:0] <= iv_data[7:4];
                    ov_hcp_mid[11:8]     <= iv_data[3:0];
                end  
                else if(rv_byte_cnt == 7'd19)begin
                    ov_hcp_mid[7:0] <= iv_data[7:0];
                    rv_adi_state     <= DISCARD_DATA_S;
                end                 
                else begin
                    rv_adi_state     <= EXTRACT_MAC_S;   
                end                                                    
            end           
            DISCARD_DATA_S:begin               
                if(i_data_wr && iv_data[8])begin//last cycle
                    rv_adi_state <= IDLE_S;                   
                end
                else begin
                    rv_adi_state <= DISCARD_DATA_S;  
                end                
            end
			default:begin
                rv_adi_state <= IDLE_S;	
			end
		endcase
   end
end	
endmodule