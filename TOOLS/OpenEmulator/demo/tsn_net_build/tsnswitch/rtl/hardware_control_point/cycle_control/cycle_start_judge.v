// Copyright (C) 1953-2022 NUDT
// Verilog module name - cycle_start_judge 
// Version: V3.4.0.20220420
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
///////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps
module cycle_start_judge(
input                 i_clk,
input                 i_rst_n,
input     [31:0]      iv_cycle_length, 
input     [63:0]      iv_oper_base, 
input     [63:0]      iv_syn_clk,              
output    reg         o_cycle_start
);         
 
reg       [63:0]      rv_cycle_start_time;
reg       [1:0]       next_state;
parameter  CYCLE_IDLE=2'b00;
parameter  SET_CYCLE_STATE_TIME=2'b01;
parameter  START_CYCLE=2'b10;

always@(posedge i_clk or negedge i_rst_n)begin 
    if(!i_rst_n) begin
         o_cycle_start<= 1'b0;
		 rv_cycle_start_time <= 64'd0;
         next_state<=CYCLE_IDLE;
    end
    else begin
         case(next_state)
            CYCLE_IDLE:begin
			    o_cycle_start<=1'b0;
                rv_cycle_start_time<=iv_oper_base;
                next_state<=SET_CYCLE_STATE_TIME;
            end
            SET_CYCLE_STATE_TIME:begin 
                o_cycle_start<=1'b0;			
                if(rv_cycle_start_time<iv_syn_clk)begin                  		
                    rv_cycle_start_time<=rv_cycle_start_time+iv_cycle_length;
					next_state<=START_CYCLE; 
                end
                else begin
                    rv_cycle_start_time <= rv_cycle_start_time;
                    next_state <= SET_CYCLE_STATE_TIME; 
                end    
            end                               
            START_CYCLE:begin
				o_cycle_start<=1'b1;  
				next_state<=SET_CYCLE_STATE_TIME;
            end
            default:begin
				o_cycle_start     <= 1'h0;
				next_state        <= CYCLE_IDLE;	
		    end
        endcase
    end
end
endmodule