// Copyright (C) 1953-2021 NUDT
// Verilog module name - dmac_tsntag_distinguish
// Version: V3.2.0.20210722
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         judge whether descriptor is descriptor of standard ethernet packet 
//     or descriptor of tsn packet. 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module dmac_tsntag_distinguish
(
       i_clk,
       i_rst_n,
       
       iv_descriptor,
       i_descriptor_wr,

       ov_tsn_descriptor,
	   o_tsn_descriptor_wr,

       ov_standard_descriptor,
	   o_standard_descriptor_wr
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
// descriptor
input      [71:0]      iv_descriptor;
input                  i_descriptor_wr;

output reg [45:0]      ov_tsn_descriptor;
output reg             o_tsn_descriptor_wr;

output reg [70:0]      ov_standard_descriptor;
output reg             o_standard_descriptor_wr;
//***************************************************
//               judge descriptor
//***************************************************
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_tsn_descriptor       <= 46'h0;
        o_tsn_descriptor_wr     <= 1'h0;
		
        ov_standard_descriptor  <= 71'h0;
        o_standard_descriptor_wr<= 1'b0;
    end                        
    else begin
        if(i_descriptor_wr == 1'b1)begin
            if(iv_descriptor[23] == 1'b1)begin //stanard ethernet pkt
			    ov_tsn_descriptor    <= 46'h0;
                o_tsn_descriptor_wr  <= 1'h0;
				
                ov_standard_descriptor[70:23] <= iv_descriptor[71:24];//dmac
                ov_standard_descriptor[22:19] <= iv_descriptor[22:19];//pkt inport
				ov_standard_descriptor[18]    <= iv_descriptor[18];//lookup en
				ov_standard_descriptor[17:9]  <= iv_descriptor[17:9];//outport                
				ov_standard_descriptor[8:0]   <= iv_descriptor[8:0];//pkt bufid
				o_standard_descriptor_wr      <= 1'b1;   
            end
            else begin//TSN packet
			    ov_tsn_descriptor[45:41] <= 5'b0;//inject addr or submit addr
                ov_tsn_descriptor[40]    <= 1'b0;//reserve
				ov_tsn_descriptor[39:36] <= iv_descriptor[22:19];//pkt inport
				ov_tsn_descriptor[35:33] <= iv_descriptor[71:69];//pkt type
				ov_tsn_descriptor[32:19] <= iv_descriptor[68:55];//flowid
				ov_tsn_descriptor[18]    <= iv_descriptor[18];//lookup en
				ov_tsn_descriptor[17:9]  <= iv_descriptor[17:9];//outport
				ov_tsn_descriptor[8:0]   <= iv_descriptor[8:0];//pkt bufid
				o_tsn_descriptor_wr      <= 1'b1;
				
                ov_standard_descriptor    <= 71'b0;
				o_standard_descriptor_wr  <= 1'b0;  
            end
        end
        else begin
			ov_tsn_descriptor       <= 46'h0;
			o_tsn_descriptor_wr     <= 1'h0;
			
			ov_standard_descriptor  <= 71'h0;
			o_standard_descriptor_wr<= 1'b0;
        end
    end
end
endmodule