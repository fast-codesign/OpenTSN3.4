// Copyright (C) 1953-2020 NUDT
// Verilog module name - pkt_write 
// Version: PWR_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         Pkt Write
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module pkt_write(
        clk_sys,
        reset_n,
        iv_pkt_p0,
        i_pkt_wr_p0,
        iv_pkt_wr_bufadd_p0,
        o_pkt_wr_ack_p0,
        iv_pkt_p1,
        i_pkt_wr_p1,
        iv_pkt_wr_bufadd_p1,
        o_pkt_wr_ack_p1,
        iv_pkt_p2,
        i_pkt_wr_p2,
        iv_pkt_wr_bufadd_p2,
        o_pkt_wr_ack_p2,
        iv_pkt_p3,
        i_pkt_wr_p3,
        iv_pkt_wr_bufadd_p3,
        o_pkt_wr_ack_p3,
        iv_pkt_p4,
        i_pkt_wr_p4,
        iv_pkt_wr_bufadd_p4,
        o_pkt_wr_ack_p4,
        iv_pkt_p5,
        i_pkt_wr_p5,
        iv_pkt_wr_bufadd_p5,
        o_pkt_wr_ack_p5,
        iv_pkt_p6,
        i_pkt_wr_p6,
        iv_pkt_wr_bufadd_p6,
        o_pkt_wr_ack_p6,
        iv_pkt_p7,
        i_pkt_wr_p7,
        iv_pkt_wr_bufadd_p7,
        o_pkt_wr_ack_p7,    
        iv_pkt_p8,
        i_pkt_wr_p8,
        iv_pkt_wr_bufadd_p8,
        o_pkt_wr_ack_p8,
        o_pkt,
        o_pkt_wr,
        o_pkt_bufadd,
        ov_pkt_write_state
    );
    
// I/O
// clk & rst
input                   clk_sys;
input                   reset_n;
//receive port pkt
input       [133:0]     iv_pkt_p0;              //receive network interface port0 packet
input                   i_pkt_wr_p0;            //receive network interface port0 write signal
input       [15:0]      iv_pkt_wr_bufadd_p0;    //receive network interface port0 buffer address 
output  reg             o_pkt_wr_ack_p0;        //receive network interface port0 ack 
input       [133:0]     iv_pkt_p1;
input                   i_pkt_wr_p1;
input       [15:0]      iv_pkt_wr_bufadd_p1;
output  reg             o_pkt_wr_ack_p1;
input       [133:0]     iv_pkt_p2;
input                   i_pkt_wr_p2;
input       [15:0]      iv_pkt_wr_bufadd_p2;
output  reg             o_pkt_wr_ack_p2;
input       [133:0]     iv_pkt_p3;
input                   i_pkt_wr_p3;
input       [15:0]      iv_pkt_wr_bufadd_p3;
output  reg             o_pkt_wr_ack_p3;
input       [133:0]     iv_pkt_p4;
input                   i_pkt_wr_p4;
input       [15:0]      iv_pkt_wr_bufadd_p4;
output  reg             o_pkt_wr_ack_p4;
input       [133:0]     iv_pkt_p5;
input                   i_pkt_wr_p5;
input       [15:0]      iv_pkt_wr_bufadd_p5;
output  reg             o_pkt_wr_ack_p5;
input       [133:0]     iv_pkt_p6;
input                   i_pkt_wr_p6;
input       [15:0]      iv_pkt_wr_bufadd_p6;
output  reg             o_pkt_wr_ack_p6;
input       [133:0]     iv_pkt_p7;
input                   i_pkt_wr_p7;
input       [15:0]      iv_pkt_wr_bufadd_p7;
output  reg             o_pkt_wr_ack_p7;    
input       [133:0]     iv_pkt_p8;
input                   i_pkt_wr_p8;
input       [15:0]      iv_pkt_wr_bufadd_p8;
output  reg             o_pkt_wr_ack_p8;
//write pkt to RAM
output  reg [133:0]     o_pkt;
output  reg             o_pkt_wr;
output  reg [15:0]      o_pkt_bufadd;

output  reg [3:0]       ov_pkt_write_state;

//internal wire&reg
localparam  wr_pkt_ch0_s    = 4'b0000,
            wr_pkt_ch1_s    = 4'b0001,
            wr_pkt_ch2_s    = 4'b0010,
            wr_pkt_ch3_s    = 4'b0011,
            wr_pkt_ch4_s    = 4'b0100,          
            wr_pkt_ch5_s    = 4'b0101,
            wr_pkt_ch6_s    = 4'b0110,
            wr_pkt_ch7_s    = 4'b0111,
            wr_pkt_ch8_s    = 4'b1000;
always@(posedge clk_sys or negedge reset_n)
    if(!reset_n) begin
        o_pkt_wr_ack_p0     <= 1'b0;
        o_pkt_wr_ack_p1     <= 1'b0;
        o_pkt_wr_ack_p2     <= 1'b0;
        o_pkt_wr_ack_p3     <= 1'b0;
        o_pkt_wr_ack_p4     <= 1'b0;
        o_pkt_wr_ack_p5     <= 1'b0;
        o_pkt_wr_ack_p6     <= 1'b0;
        o_pkt_wr_ack_p7     <= 1'b0;    
        o_pkt_wr_ack_p8     <= 1'b0;
        o_pkt               <= 134'b0;
        o_pkt_wr            <= 1'b0;
        o_pkt_bufadd        <= 16'b0;
        ov_pkt_write_state      <= wr_pkt_ch0_s;
        end
    else begin
        case(ov_pkt_write_state)
            wr_pkt_ch0_s:begin
                o_pkt_wr_ack_p8 <= 1'b0;
                if(i_pkt_wr_p0 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_wr_bufadd_p0;
                    o_pkt_wr        <= 1'b1;
                    o_pkt           <= iv_pkt_p0;
                    o_pkt_wr_ack_p0 <= 1'b1;
                    end
                else begin
                    o_pkt_wr        <= 1'b0;
                    o_pkt           <= 134'b0;
                    o_pkt_bufadd    <= 16'b0;
                    end
                ov_pkt_write_state  <= wr_pkt_ch1_s;
                end
            wr_pkt_ch1_s:begin
                o_pkt_wr_ack_p0 <= 1'b0;
                if(i_pkt_wr_p1 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_wr_bufadd_p1;
                    o_pkt_wr        <= 1'b1;
                    o_pkt           <= iv_pkt_p1;
                    o_pkt_wr_ack_p1 <= 1'b1;
                    end
                else begin
                    o_pkt_wr        <= 1'b0;
                    o_pkt           <= 134'b0;
                    o_pkt_bufadd    <= 16'b0;
                    end
                ov_pkt_write_state  <= wr_pkt_ch2_s;
                end
            wr_pkt_ch2_s:begin
                o_pkt_wr_ack_p1 <= 1'b0;
                if(i_pkt_wr_p2 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_wr_bufadd_p2;
                    o_pkt_wr        <= 1'b1;
                    o_pkt           <= iv_pkt_p2;
                    o_pkt_wr_ack_p2 <= 1'b1;
                    end
                else begin
                    o_pkt_wr        <= 1'b0;
                    o_pkt           <= 134'b0;
                    o_pkt_bufadd    <= 16'b0;
                    end
                ov_pkt_write_state  <= wr_pkt_ch3_s;
                end
            wr_pkt_ch3_s:begin
                o_pkt_wr_ack_p2 <= 1'b0;
                if(i_pkt_wr_p3 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_wr_bufadd_p3;
                    o_pkt_wr        <= 1'b1;
                    o_pkt           <= iv_pkt_p3;
                    o_pkt_wr_ack_p3 <= 1'b1;
                    end
                else begin
                    o_pkt_wr        <= 1'b0;
                    o_pkt           <= 134'b0;
                    o_pkt_bufadd    <= 16'b0;
                    end
                ov_pkt_write_state  <= wr_pkt_ch4_s;
                end
            wr_pkt_ch4_s:begin
                o_pkt_wr_ack_p3 <= 1'b0;
                if(i_pkt_wr_p4 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_wr_bufadd_p4;
                    o_pkt_wr        <= 1'b1;
                    o_pkt           <= iv_pkt_p4;
                    o_pkt_wr_ack_p4 <= 1'b1;
                    end
                else begin
                    o_pkt_wr        <= 1'b0;
                    o_pkt           <= 134'b0;
                    o_pkt_bufadd    <= 16'b0;
                    end
                ov_pkt_write_state  <= wr_pkt_ch5_s;
                end
            wr_pkt_ch5_s:begin
                o_pkt_wr_ack_p4 <= 1'b0;
                if(i_pkt_wr_p5 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_wr_bufadd_p5;
                    o_pkt_wr        <= 1'b1;
                    o_pkt           <= iv_pkt_p5;
                    o_pkt_wr_ack_p5 <= 1'b1;
                    end
                else begin
                    o_pkt_wr        <= 1'b0;
                    o_pkt           <= 134'b0;
                    o_pkt_bufadd    <= 16'b0;
                    end
                ov_pkt_write_state  <= wr_pkt_ch6_s;
                end
            wr_pkt_ch6_s:begin
                o_pkt_wr_ack_p5 <= 1'b0;
                if(i_pkt_wr_p6 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_wr_bufadd_p6;
                    o_pkt_wr        <= 1'b1;
                    o_pkt           <= iv_pkt_p6;
                    o_pkt_wr_ack_p6 <= 1'b1;
                    end
                else begin
                    o_pkt_wr        <= 1'b0;
                    o_pkt           <= 134'b0;
                    o_pkt_bufadd    <= 16'b0;
                    end
                ov_pkt_write_state  <= wr_pkt_ch7_s;
                end
            wr_pkt_ch7_s:begin
                o_pkt_wr_ack_p6 <= 1'b0;
                if(i_pkt_wr_p7 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_wr_bufadd_p7;
                    o_pkt_wr        <= 1'b1;
                    o_pkt           <= iv_pkt_p7;
                    o_pkt_wr_ack_p7 <= 1'b1;
                    end
                else begin
                    o_pkt_wr        <= 1'b0;
                    o_pkt           <= 134'b0;
                    o_pkt_bufadd    <= 16'b0;
                    end
                ov_pkt_write_state  <= wr_pkt_ch8_s;
                end
            wr_pkt_ch8_s:begin
                o_pkt_wr_ack_p7 <= 1'b0;
                if(i_pkt_wr_p8 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_wr_bufadd_p8;
                    o_pkt_wr        <= 1'b1;
                    o_pkt           <= iv_pkt_p8;
                    o_pkt_wr_ack_p8 <= 1'b1;
                    end
                else begin
                    o_pkt_wr        <= 1'b0;
                    o_pkt           <= 134'b0;
                    o_pkt_bufadd    <= 16'b0;
                    end
                ov_pkt_write_state  <= wr_pkt_ch0_s;
                end     
            default:begin
                o_pkt_wr_ack_p0     <= 1'b0;
                o_pkt_wr_ack_p1     <= 1'b0;
                o_pkt_wr_ack_p2     <= 1'b0;
                o_pkt_wr_ack_p3     <= 1'b0;
                o_pkt_wr_ack_p4     <= 1'b0;
                o_pkt_wr_ack_p5     <= 1'b0;
                o_pkt_wr_ack_p6     <= 1'b0;
                o_pkt_wr_ack_p7     <= 1'b0;    
                o_pkt_wr_ack_p8     <= 1'b0;
                o_pkt               <= 134'b0;
                o_pkt_wr            <= 1'b0;
                o_pkt_bufadd        <= 16'b0;
                ov_pkt_write_state      <= wr_pkt_ch0_s;
                end
            endcase
        end
        
endmodule