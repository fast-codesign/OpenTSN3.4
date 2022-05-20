// Copyright (C) 1953-2020 NUDT
// Verilog module name - led_on_time
// Version: LOT_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         time of led that is on.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
module led_on_time #(parameter led_on_time = 32'd62_500_000)
(
       i_clk,
       i_rst_n,
       
       i_pulse,
       o_led   
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n; 
//port type
input                  i_pulse;
output reg             o_led;//low active.

reg    [31:0]          rv_time_cnt;

reg                    led_state;
localparam    IDLE_S = 1'b0,  
              LED_ON_S = 1'b1;     
always@(posedge i_clk or negedge i_rst_n) begin
    if (!i_rst_n) begin
        o_led <= 1'b1;
        rv_time_cnt <= 32'b0;
        led_state <= IDLE_S;
    end
    else begin
        case(led_state)
            IDLE_S:begin
                if(i_pulse)begin
                    o_led <= 1'b0;
                    rv_time_cnt <= 32'b0;
                    led_state <= LED_ON_S;
                end
                else begin
                    o_led <= 1'b1;
                    rv_time_cnt <= 32'b0; 
                    led_state <= IDLE_S; 
                end
            end
            LED_ON_S:begin
                if(rv_time_cnt == (led_on_time - 1'b1))begin
                    o_led <= 1'b1;
                    rv_time_cnt <= 32'b0;
                    led_state <= IDLE_S;
                end
                else begin
                    o_led <= 1'b0;
                    rv_time_cnt <= rv_time_cnt + 1'b1;
                    led_state <= LED_ON_S; 
                end
            end
            default:begin
                o_led <= 1'b1;
                rv_time_cnt <= 32'b0; 
                led_state <= IDLE_S; 
            end
        endcase            
    end
end
endmodule