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

module	  clk_rst_generate_chip(
			clk0,
            clk1,
            clk2,
			clk3,
            clk4,
            clk5,            
			rst_n,
			
			top_time1
);
output  reg     clk0;
output  reg     clk1;
output  reg     clk2;
output  reg     clk3;
output  reg     clk4;
output  reg     clk5;
output  reg     rst_n;
output reg [31:0] top_time1;


initial begin//124.6Mhz
    clk0 = 1'b0;
    forever #4.0000 clk0 = ~clk0;
end

initial begin//125Mhz
    clk1 = 1'b0;
    forever #4.0006  clk1 = ~clk1;
end

initial begin//125.6Mhz
    clk2 = 1'b0;
    forever #4.0003 clk2 = ~clk2;
end

initial begin//124.6Mhz
    clk3 = 1'b0;
    forever #4.0000 clk3 = ~clk3;
end

initial begin//125Mhz
    clk4 = 1'b0;
    forever #3.9997  clk4 = ~clk4;
end

initial begin//125.6Mhz
    clk5 = 1'b0;
    forever #3.9994 clk5 = ~clk5;
end


initial begin//reset
    rst_n = 1'b0;
    #600;
    rst_n = 1'b1;
end

always @(posedge clk0 or negedge rst_n) begin
	if(!rst_n)begin
		top_time1 <= 32'd0;		
	end
	else begin
		top_time1 <= top_time1 + 1'b1;
	end
end

endmodule
