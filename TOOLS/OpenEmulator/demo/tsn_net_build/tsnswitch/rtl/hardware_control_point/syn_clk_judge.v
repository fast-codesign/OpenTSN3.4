// Copyright (C) 1953-2022 NUDT
// Verilog module name - syn_clk_judge 
// Version: V3.4.0.20220420
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
///////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps
module syn_clk_judge(
input                    i_clk,
input                    i_rst_n,
input        [63:0]      iv_syn_clk,  
input                    i_tsn_or_tte, //1表示1588，0表示6802 
input        [31:0]      iv_syn_clk_cycle,//时钟同步周期6802 
output  reg  [63:0]      ov_syn_clk
);         
reg                      r_syn_cycle_timer;//新增，周期计时，表示第几个时钟周期 
reg       [63:0]         rv_syn_cycle_offset;
 

always@(posedge i_clk or negedge i_rst_n)begin 
    if(!i_rst_n) begin
         r_syn_cycle_timer<=1'b0;
		 rv_syn_cycle_offset<=64'd0;
		 ov_syn_clk  <=64'd0;
    end
    else begin
		if(i_tsn_or_tte==1'b1)begin
            ov_syn_clk<=iv_syn_clk;
		end
		else begin
            if(iv_syn_clk==iv_syn_clk_cycle-32'd8)begin
			    if(r_syn_cycle_timer==1'b0) begin
				    r_syn_cycle_timer   <=1'b1;
                    rv_syn_cycle_offset <= iv_syn_clk_cycle;
					ov_syn_clk          <= iv_syn_clk;
			    end
				else begin
                    rv_syn_cycle_offset <= rv_syn_cycle_offset + iv_syn_clk_cycle;					
				    r_syn_cycle_timer   <= r_syn_cycle_timer;
					ov_syn_clk <= rv_syn_cycle_offset+ iv_syn_clk;
                end																				
            end 
            else begin
				ov_syn_clk <=  rv_syn_cycle_offset +iv_syn_clk;
            end	          					
        end 			
    end       
end
endmodule