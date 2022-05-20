// Copyright (C) 1953-2020 NUDT
// Verilog module name - reset_clk_pulse
// Version: RCP_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         judge whether reset valid and clock inputs.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module reset_clock_check #(parameter led_on_time = 32'd62_500_000)
(
       i_clk,
       i_rst_n,
       
       o_reset_clk_pulse   
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n; 

output reg             o_reset_clk_pulse; 

reg                    r_reset_valid_flag;
reg                    r_reset_test;
//reset valid
always@(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        r_reset_test <= 1'b1;
        r_reset_valid_flag <= 1'b0;
    end
    else begin
        r_reset_test <= 1'b0;
        if(r_reset_test)begin
            r_reset_valid_flag <= 1'b1;
        end
        else begin
            r_reset_valid_flag <= r_reset_valid_flag;
        end
    end
end
//output pulse
reg    [31:0]          rv_time_cnt;
reg                    rst_clk_state;
localparam  RESET_CHECK_S = 1'b0,
            CLOCK_CHECK_S = 1'b1;
always@(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        rv_time_cnt <= 32'b0;
        o_reset_clk_pulse <= 1'b1;
        rst_clk_state <= RESET_CHECK_S;
    end
    else begin
        case(rst_clk_state)
            RESET_CHECK_S:begin
                rv_time_cnt <= 32'b0;
                if(r_reset_valid_flag == 1'b1)begin
                    o_reset_clk_pulse <= 1'b0;
                    rst_clk_state <= CLOCK_CHECK_S;
                end
                else begin
                    o_reset_clk_pulse <= 1'b1;
                    rst_clk_state <= RESET_CHECK_S;
                end
            end
            CLOCK_CHECK_S:begin
                rst_clk_state <= CLOCK_CHECK_S;
                if(rv_time_cnt == (led_on_time - 1'b1))begin
                    rv_time_cnt <= 32'b0;
                    o_reset_clk_pulse <= ~o_reset_clk_pulse;
                end
                else begin
                    rv_time_cnt <= rv_time_cnt + 1'b1;
                    o_reset_clk_pulse <= o_reset_clk_pulse;
                end
            end
            default:begin
                rv_time_cnt <= 32'b0;
                o_reset_clk_pulse <= 1'b1;
                rst_clk_state <= RESET_CHECK_S;
            end            
        endcase 
    end        
end
endmodule