// Copyright (C) 1953-2020 NUDT
// Verilog module name - top_clock 
// Version: tsn_chip_V1.0
// Created:
//         by - li lijunshuai (1145331404@qq.com)
//         at - 06.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//		  top of top_clock of chip
//				 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

`define   WITE            5             //帧间距

module	  clk_rst_generate(
           
            sync_clk,
            rst_n,
			
			top_time
);

output  reg     sync_clk;
output  reg     rst_n;

output reg [31:0] top_time;


initial begin//125Mhz
	#5;
    sync_clk = 1'b0;
    forever #4  sync_clk = ~sync_clk;
end

initial begin//reset
    rst_n = 1'b0;
    #500;
    rst_n = 1'b1;
end

always @(posedge sync_clk or negedge rst_n) begin
	if(!rst_n)begin
		top_time <= 32'd0;		
	end
	else begin
		top_time <= top_time + 1'b1;
	end
end

endmodule