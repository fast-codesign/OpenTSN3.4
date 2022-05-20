// Copyright (C) 1953-2020 NUDT
// Verilog module name - pkt_read 
// Version: PRD_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         Pkt read
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module pkt_read(
        clk_sys,
        reset_n,
        iv_pkt_rd_bufadd_p0,
        i_pkt_rd_p0,
        o_pkt_rd_ack_p0,
        ov_pkt_p0,
        o_pkt_wr_p0,
        iv_pkt_rd_bufadd_p1,
        i_pkt_rd_p1,
        o_pkt_rd_ack_p1,
        ov_pkt_p1,
        o_pkt_wr_p1,
        iv_pkt_rd_bufadd_p2,
        i_pkt_rd_p2,
        o_pkt_rd_ack_p2,
        ov_pkt_p2,
        o_pkt_wr_p2,
        iv_pkt_rd_bufadd_p3,
        i_pkt_rd_p3,
        o_pkt_rd_ack_p3,
        ov_pkt_p3,
        o_pkt_wr_p3,
        iv_pkt_rd_bufadd_p4,
        i_pkt_rd_p4,
        o_pkt_rd_ack_p4,
        ov_pkt_p4,
        o_pkt_wr_p4,
        iv_pkt_rd_bufadd_p5,
        i_pkt_rd_p5,
        o_pkt_rd_ack_p5,
        ov_pkt_p5,
        o_pkt_wr_p5,
        iv_pkt_rd_bufadd_p6,
        i_pkt_rd_p6,
        o_pkt_rd_ack_p6,
        ov_pkt_p6,
        o_pkt_wr_p6,
        iv_pkt_rd_bufadd_p7,
        i_pkt_rd_p7,
        o_pkt_rd_ack_p7,
        ov_pkt_p7,
        o_pkt_wr_p7,
        iv_pkt_rd_bufadd_p8,
        i_pkt_rd_p8,
        o_pkt_rd_ack_p8,
        ov_pkt_p8,
        o_pkt_wr_p8,
        o_pkt_bufadd,
        o_pkt_rd,
        i_pkt,
        ov_pcb_pkt_read_state
);
// I/O
// clk & rst
input                   clk_sys;
input                   reset_n;
//send port pkt
input       [15:0]      iv_pkt_rd_bufadd_p0;    //send network interface port0 buffer address 
input                   i_pkt_rd_p0;
output  reg             o_pkt_rd_ack_p0;
output  reg [133:0]     ov_pkt_p0;
output  reg             o_pkt_wr_p0;
input       [15:0]      iv_pkt_rd_bufadd_p1;
input                   i_pkt_rd_p1;
output  reg             o_pkt_rd_ack_p1;
output  reg [133:0]     ov_pkt_p1;
output  reg             o_pkt_wr_p1;
input       [15:0]      iv_pkt_rd_bufadd_p2;
input                   i_pkt_rd_p2;
output  reg             o_pkt_rd_ack_p2;
output  reg [133:0]     ov_pkt_p2;
output  reg             o_pkt_wr_p2;
input       [15:0]      iv_pkt_rd_bufadd_p3;
input                   i_pkt_rd_p3;
output  reg             o_pkt_rd_ack_p3;
output  reg [133:0]     ov_pkt_p3;
output  reg             o_pkt_wr_p3;
input       [15:0]      iv_pkt_rd_bufadd_p4;
input                   i_pkt_rd_p4;
output  reg             o_pkt_rd_ack_p4;
output  reg [133:0]     ov_pkt_p4;
output  reg             o_pkt_wr_p4;
input       [15:0]      iv_pkt_rd_bufadd_p5;
input                   i_pkt_rd_p5;
output  reg             o_pkt_rd_ack_p5;
output  reg [133:0]     ov_pkt_p5;
output  reg             o_pkt_wr_p5;
input       [15:0]      iv_pkt_rd_bufadd_p6;
input                   i_pkt_rd_p6;
output  reg             o_pkt_rd_ack_p6;
output  reg [133:0]     ov_pkt_p6;
output  reg             o_pkt_wr_p6;
input       [15:0]      iv_pkt_rd_bufadd_p7;
input                   i_pkt_rd_p7;
output  reg             o_pkt_rd_ack_p7;
output  reg [133:0]     ov_pkt_p7;
output  reg             o_pkt_wr_p7;
input       [15:0]      iv_pkt_rd_bufadd_p8;
input                   i_pkt_rd_p8;
output  reg             o_pkt_rd_ack_p8;
output  reg [133:0]     ov_pkt_p8;
output  reg             o_pkt_wr_p8;
//read pkt from RAM 
output  reg [15:0]      o_pkt_bufadd;
output  reg             o_pkt_rd;
input       [133:0]     i_pkt;

output  reg [3:0]       ov_pcb_pkt_read_state;

//internal wire&reg
reg [8:0]   rd_valid;//flag of having read xx port pkt. [0]~[7]: network port 1~7,[8]: host port.
localparam  rd_pkt_ch0_s    = 4'b0000,
            rd_pkt_ch1_s    = 4'b0001,
            rd_pkt_ch2_s    = 4'b0010,
            rd_pkt_ch3_s    = 4'b0011,
            rd_pkt_ch4_s    = 4'b0100,
            rd_pkt_ch5_s    = 4'b0101,
            rd_pkt_ch6_s    = 4'b0110,
            rd_pkt_ch7_s    = 4'b0111,
            rd_pkt_ch8_s    = 4'b1000;

always@(posedge clk_sys or negedge reset_n)
    if(!reset_n) begin
        o_pkt_rd_ack_p0     <= 1'b0;
        ov_pkt_p0           <= 134'b0;
        o_pkt_wr_p0         <= 1'b0;
        o_pkt_rd_ack_p1     <= 1'b0;
        ov_pkt_p1           <= 134'b0;
        o_pkt_wr_p1         <= 1'b0;
        o_pkt_rd_ack_p2     <= 1'b0;
        ov_pkt_p2           <= 134'b0;
        o_pkt_wr_p2         <= 1'b0;
        o_pkt_rd_ack_p3     <= 1'b0;
        ov_pkt_p3           <= 134'b0;
        o_pkt_wr_p3         <= 1'b0;
        o_pkt_rd_ack_p4     <= 1'b0;
        ov_pkt_p4           <= 134'b0;
        o_pkt_wr_p4         <= 1'b0;
        o_pkt_rd_ack_p5     <= 1'b0;
        ov_pkt_p5           <= 134'b0;
        o_pkt_wr_p5         <= 1'b0;
        o_pkt_rd_ack_p6     <= 1'b0;
        ov_pkt_p6           <= 134'b0;
        o_pkt_wr_p6         <= 1'b0;
        o_pkt_rd_ack_p7     <= 1'b0;
        ov_pkt_p7           <= 134'b0;
        o_pkt_wr_p7         <= 1'b0;
        o_pkt_rd_ack_p8     <= 1'b0;
        ov_pkt_p8           <= 134'b0;
        o_pkt_wr_p8         <= 1'b0;
        o_pkt_bufadd        <= 16'b0;
        o_pkt_rd            <= 1'b0;
        ov_pcb_pkt_read_state       <= rd_pkt_ch0_s;
        rd_valid            <= 9'b0;
        end
    else begin
        case(ov_pcb_pkt_read_state)
            rd_pkt_ch0_s:begin
                o_pkt_rd_ack_p8     <= 1'b0;
                ov_pkt_p5           <= 134'b0;
                o_pkt_wr_p5         <= 1'b0;
                if (i_pkt_rd_p0 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_rd_bufadd_p0;
                    o_pkt_rd        <= 1'b1;
                    o_pkt_rd_ack_p0 <= 1'b1;
                    rd_valid[0]     <= 1'b1;
                    end
                else begin
                    o_pkt_rd        <= 1'b0;
                    o_pkt_bufadd    <= 16'b0;
                    o_pkt_rd_ack_p0 <= 1'b0;
                    rd_valid[0]     <= 1'b0;
                    end
                if (rd_valid[6] == 1'b1) begin
                    ov_pkt_p6       <= i_pkt;
                    o_pkt_wr_p6     <= 1'b1;
                    rd_valid[6]     <= 1'b0;
                    end
                else begin
                    o_pkt_wr_p6     <= o_pkt_wr_p6;
                    ov_pkt_p6       <= ov_pkt_p6;
                    rd_valid[6]     <= rd_valid[6];
                    end                 
                ov_pcb_pkt_read_state       <= rd_pkt_ch1_s;
                end
            rd_pkt_ch1_s:begin
                o_pkt_rd_ack_p0     <= 1'b0;
                o_pkt_wr_p6         <= 1'b0;
                ov_pkt_p6           <= 134'b0;
                if (i_pkt_rd_p1 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_rd_bufadd_p1;
                    o_pkt_rd        <= 1'b1;
                    o_pkt_rd_ack_p1 <= 1'b1;
                    rd_valid[1]     <= 1'b1;
                    end
                else begin
                    o_pkt_rd        <= 1'b0;
                    o_pkt_bufadd    <= 16'b0;
                    o_pkt_rd_ack_p1 <= 1'b0;
                    rd_valid[1]     <= 1'b0;
                    end
                if (rd_valid[7] == 1'b1) begin
                    ov_pkt_p7       <= i_pkt;
                    o_pkt_wr_p7     <= 1'b1;
                    rd_valid[7]     <= 1'b0;
                    end
                else begin
                    o_pkt_wr_p7     <= o_pkt_wr_p7;
                    ov_pkt_p7       <= ov_pkt_p7;
                    rd_valid[7]     <= rd_valid[7];
                    end                 
                ov_pcb_pkt_read_state       <= rd_pkt_ch2_s;
                end
            rd_pkt_ch2_s:begin
                o_pkt_rd_ack_p1     <= 1'b0;
                o_pkt_wr_p7         <= 1'b0;
                ov_pkt_p7           <= 134'b0;
                if (i_pkt_rd_p2 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_rd_bufadd_p2;
                    o_pkt_rd        <= 1'b1;
                    o_pkt_rd_ack_p2 <= 1'b1;
                    rd_valid[2]     <= 1'b1;
                    end
                else begin
                    o_pkt_rd        <= 1'b0;
                    o_pkt_bufadd    <= 16'b0;
                    o_pkt_rd_ack_p2 <= 1'b0;
                    rd_valid[2]     <= 1'b0;
                    end
                if (rd_valid[8] == 1'b1) begin
                    ov_pkt_p8       <= i_pkt;
                    o_pkt_wr_p8     <= 1'b1;
                    rd_valid[8]     <= 1'b0;
                    end
                else begin
                    o_pkt_wr_p8     <= o_pkt_wr_p8;
                    ov_pkt_p8       <= ov_pkt_p8;
                    rd_valid[8]     <= rd_valid[8];
                    end                 
                ov_pcb_pkt_read_state       <= rd_pkt_ch3_s;
                end
            rd_pkt_ch3_s:begin
                o_pkt_rd_ack_p2     <= 1'b0;
                o_pkt_wr_p8         <= 1'b0;
                ov_pkt_p8           <= 134'b0;
                if (i_pkt_rd_p3 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_rd_bufadd_p3;
                    o_pkt_rd        <= 1'b1;
                    o_pkt_rd_ack_p3 <= 1'b1;
                    rd_valid[3]     <= 1'b1;
                    end
                else begin
                    o_pkt_rd        <= 1'b0;
                    o_pkt_bufadd    <= 16'b0;
                    o_pkt_rd_ack_p3 <= 1'b0;
                    rd_valid[3]     <= 1'b0;
                    end
                if (rd_valid[0] == 1'b1) begin
                    ov_pkt_p0       <= i_pkt;
                    o_pkt_wr_p0     <= 1'b1;
                    rd_valid[0]     <= 1'b0;
                    end
                else begin
                    o_pkt_wr_p0     <= o_pkt_wr_p0;
                    ov_pkt_p0       <= ov_pkt_p0;
                    rd_valid[0]     <= rd_valid[0];
                    end                 
                ov_pcb_pkt_read_state       <= rd_pkt_ch4_s;
                end
            rd_pkt_ch4_s:begin
                o_pkt_rd_ack_p3     <= 1'b0;
                o_pkt_wr_p0         <= 1'b0;
                ov_pkt_p0           <= 134'b0;
                if (i_pkt_rd_p4 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_rd_bufadd_p4;
                    o_pkt_rd        <= 1'b1;
                    o_pkt_rd_ack_p4 <= 1'b1;
                    rd_valid[4]     <= 1'b1;
                    end
                else begin
                    o_pkt_rd        <= 1'b0;
                    o_pkt_bufadd    <= 16'b0;
                    o_pkt_rd_ack_p4 <= 1'b0;
                    rd_valid[4]     <= 1'b0;
                    end
                if (rd_valid[1] == 1'b1) begin
                    ov_pkt_p1       <= i_pkt;
                    o_pkt_wr_p1     <= 1'b1;
                    rd_valid[1]     <= 1'b0;
                    end
                else begin
                    o_pkt_wr_p1     <= o_pkt_wr_p1;
                    ov_pkt_p1       <= ov_pkt_p1;
                    rd_valid[1]     <= rd_valid[1];
                    end                 
                ov_pcb_pkt_read_state       <= rd_pkt_ch5_s;
                end 
            rd_pkt_ch5_s:begin
                o_pkt_rd_ack_p4     <= 1'b0;
                o_pkt_wr_p1         <= 1'b0;
                ov_pkt_p1           <= 134'b0;
                if (i_pkt_rd_p5 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_rd_bufadd_p5;
                    o_pkt_rd        <= 1'b1;
                    o_pkt_rd_ack_p5 <= 1'b1;
                    rd_valid[5]     <= 1'b1;
                    end
                else begin
                    o_pkt_rd        <= 1'b0;
                    o_pkt_bufadd    <= 16'b0;
                    o_pkt_rd_ack_p5 <= 1'b0;
                    rd_valid[5]     <= 1'b0;
                    end
                if (rd_valid[2] == 1'b1) begin
                    ov_pkt_p2       <= i_pkt;
                    o_pkt_wr_p2     <= 1'b1;
                    rd_valid[2]     <= 1'b0;
                    end
                else begin
                    o_pkt_wr_p2     <= o_pkt_wr_p2;
                    ov_pkt_p2       <= ov_pkt_p2;
                    rd_valid[2]     <= rd_valid[2];
                    end                 
                ov_pcb_pkt_read_state       <= rd_pkt_ch6_s;
                end 
            rd_pkt_ch6_s:begin
                o_pkt_rd_ack_p5     <= 1'b0;
                o_pkt_wr_p2         <= 1'b0;
                ov_pkt_p2           <= 134'b0;
                if (i_pkt_rd_p6 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_rd_bufadd_p6;
                    o_pkt_rd        <= 1'b1;
                    o_pkt_rd_ack_p6 <= 1'b1;
                    rd_valid[6]     <= 1'b1;
                    end
                else begin
                    o_pkt_rd        <= 1'b0;
                    o_pkt_bufadd    <= 16'b0;
                    o_pkt_rd_ack_p6 <= 1'b0;
                    rd_valid[6]     <= 1'b0;
                    end
                if (rd_valid[3] == 1'b1) begin
                    ov_pkt_p3       <= i_pkt;
                    o_pkt_wr_p3     <= 1'b1;
                    rd_valid[3]     <= 1'b0;
                    end
                else begin
                    o_pkt_wr_p3     <= o_pkt_wr_p3;
                    ov_pkt_p3       <= ov_pkt_p3;
                    rd_valid[3]     <= rd_valid[3];
                    end                 
                ov_pcb_pkt_read_state       <= rd_pkt_ch7_s;
                end
            rd_pkt_ch7_s:begin
                o_pkt_rd_ack_p6     <= 1'b0;
                o_pkt_wr_p3         <= 1'b0;
                ov_pkt_p3           <= 134'b0;
                if (i_pkt_rd_p7 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_rd_bufadd_p7;
                    o_pkt_rd        <= 1'b1;
                    o_pkt_rd_ack_p7 <= 1'b1;
                    rd_valid[7]     <= 1'b1;
                    end
                else begin
                    o_pkt_rd        <= 1'b0;
                    o_pkt_bufadd    <= 16'b0;
                    o_pkt_rd_ack_p7 <= 1'b0;
                    rd_valid[7]     <= 1'b0;
                    end
                if (rd_valid[4] == 1'b1) begin
                    ov_pkt_p4       <= i_pkt;
                    o_pkt_wr_p4     <= 1'b1;
                    rd_valid[4]     <= 1'b0;
                    end
                else begin
                    o_pkt_wr_p4     <= o_pkt_wr_p4;
                    ov_pkt_p4       <= ov_pkt_p4;
                    rd_valid[4]     <= rd_valid[4];
                    end                 
                ov_pcb_pkt_read_state       <= rd_pkt_ch8_s;
                end
            rd_pkt_ch8_s:begin
                o_pkt_rd_ack_p7     <= 1'b0;
                o_pkt_wr_p4         <= 1'b0;
                ov_pkt_p4           <= 134'b0;
                if (i_pkt_rd_p8 == 1'b1) begin
                    o_pkt_bufadd    <= iv_pkt_rd_bufadd_p8;
                    o_pkt_rd        <= 1'b1;
                    o_pkt_rd_ack_p8 <= 1'b1;
                    rd_valid[8]     <= 1'b1;
                    end
                else begin
                    o_pkt_rd        <= 1'b0;
                    o_pkt_bufadd    <= 16'b0;
                    o_pkt_rd_ack_p8 <= 1'b0;
                    rd_valid[8]     <= 1'b0;
                    end
                if (rd_valid[5] == 1'b1) begin
                    ov_pkt_p5       <= i_pkt;
                    o_pkt_wr_p5     <= 1'b1;
                    rd_valid[5]     <= 1'b0;
                    end
                else begin
                    o_pkt_wr_p5     <= o_pkt_wr_p5;
                    ov_pkt_p5       <= ov_pkt_p5;
                    rd_valid[5]     <= rd_valid[5];
                    end                 
                ov_pcb_pkt_read_state       <= rd_pkt_ch0_s;
                end
            default:begin
                o_pkt_rd_ack_p0     <= 1'b0;
                ov_pkt_p0           <= 134'b0;
                o_pkt_wr_p0         <= 1'b0;
                o_pkt_rd_ack_p1     <= 1'b0;
                ov_pkt_p1           <= 134'b0;
                o_pkt_wr_p1         <= 1'b0;
                o_pkt_rd_ack_p2     <= 1'b0;
                ov_pkt_p2           <= 134'b0;
                o_pkt_wr_p2         <= 1'b0;
                o_pkt_rd_ack_p3     <= 1'b0;
                ov_pkt_p3           <= 134'b0;
                o_pkt_wr_p3         <= 1'b0;
                o_pkt_rd_ack_p4     <= 1'b0;
                ov_pkt_p4           <= 134'b0;
                o_pkt_wr_p4         <= 1'b0;
                o_pkt_rd_ack_p5     <= 1'b0;
                ov_pkt_p5           <= 134'b0;
                o_pkt_wr_p5         <= 1'b0;
                o_pkt_rd_ack_p6     <= 1'b0;
                ov_pkt_p6           <= 134'b0;
                o_pkt_wr_p6         <= 1'b0;
                o_pkt_rd_ack_p7     <= 1'b0;
                ov_pkt_p7           <= 134'b0;
                o_pkt_wr_p7         <= 1'b0;
                o_pkt_rd_ack_p8     <= 1'b0;
                ov_pkt_p8           <= 134'b0;
                o_pkt_wr_p8         <= 1'b0;
                o_pkt_bufadd        <= 16'b0;
                o_pkt_rd            <= 1'b0;
                ov_pcb_pkt_read_state       <= rd_pkt_ch0_s;
                rd_valid            <= 9'b0;
                end
            endcase
        end

endmodule
