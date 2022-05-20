// Copyright (C) 1953-2020 NUDT
// Verilog module name - address_read 
// Version: ARD_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         Pkt Address Read
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module address_read
    (
        clk_sys,
        reset_n,
        ov_pkt_bufid_p0,
        o_pkt_bufid_wr_p0,
        i_pkt_bufid_ack_p0,
        ov_pkt_bufid_p1,
        o_pkt_bufid_wr_p1,
        i_pkt_bufid_ack_p1,     
        ov_pkt_bufid_p2,
        o_pkt_bufid_wr_p2,
        i_pkt_bufid_ack_p2,
        ov_pkt_bufid_p3,
        o_pkt_bufid_wr_p3,
        i_pkt_bufid_ack_p3,
        ov_pkt_bufid_p4,
        o_pkt_bufid_wr_p4,
        i_pkt_bufid_ack_p4,
        ov_pkt_bufid_p5,
        o_pkt_bufid_wr_p5,
        i_pkt_bufid_ack_p5,     
        ov_pkt_bufid_p6,
        o_pkt_bufid_wr_p6,
        i_pkt_bufid_ack_p6,
        ov_pkt_bufid_p7,
        o_pkt_bufid_wr_p7,
        i_pkt_bufid_ack_p7,
        ov_pkt_bufid_p8,
        o_pkt_bufid_wr_p8,
        i_pkt_bufid_ack_p8,
        o_pkt_bufid_rd,
        iv_pkt_bufid,
        i_pkt_bufid_empty,
        ov_address_read_state
    );
// I/O
// clk & rst
input                   clk_sys;
input                   reset_n;
//send port buffer id   
output  reg [8:0]       ov_pkt_bufid_p0;
output  reg             o_pkt_bufid_wr_p0;
input                   i_pkt_bufid_ack_p0;
output  reg [8:0]       ov_pkt_bufid_p1;
output  reg             o_pkt_bufid_wr_p1;
input                   i_pkt_bufid_ack_p1;     
output  reg [8:0]       ov_pkt_bufid_p2;
output  reg             o_pkt_bufid_wr_p2;
input                   i_pkt_bufid_ack_p2;
output  reg [8:0]       ov_pkt_bufid_p3;
output  reg             o_pkt_bufid_wr_p3;
input                   i_pkt_bufid_ack_p3;
output  reg [8:0]       ov_pkt_bufid_p4;
output  reg             o_pkt_bufid_wr_p4;
input                   i_pkt_bufid_ack_p4;
output  reg [8:0]       ov_pkt_bufid_p5;
output  reg             o_pkt_bufid_wr_p5;
input                   i_pkt_bufid_ack_p5;     
output  reg [8:0]       ov_pkt_bufid_p6;
output  reg             o_pkt_bufid_wr_p6;
input                   i_pkt_bufid_ack_p6;
output  reg [8:0]       ov_pkt_bufid_p7;
output  reg             o_pkt_bufid_wr_p7;
input                   i_pkt_bufid_ack_p7;
output  reg [8:0]       ov_pkt_bufid_p8;
output  reg             o_pkt_bufid_wr_p8;
input                   i_pkt_bufid_ack_p8;
//read pkt bufid from FIFO 
output  reg             o_pkt_bufid_rd;
input       [8:0]       iv_pkt_bufid;
input                   i_pkt_bufid_empty;

output  reg [3:0]       ov_address_read_state;
//internal wire&reg
reg         reg_bufid_ack_p0,reg_bufid_ack_p1,reg_bufid_ack_p2,reg_bufid_ack_p3,reg_bufid_ack_p4,
            reg_bufid_ack_p5,reg_bufid_ack_p6,reg_bufid_ack_p7,reg_bufid_ack_p8;
reg [8:0]   rd_valid;//flag of having read xx port pkt. [0]~[7]: network port 1~7,[8]: host port.
localparam  rd_bufid_ch0_s  = 4'b0000,
            rd_bufid_ch1_s  = 4'b0001,
            rd_bufid_ch2_s  = 4'b0010,
            rd_bufid_ch3_s  = 4'b0011,
            rd_bufid_ch4_s  = 4'b0100,
            rd_bufid_ch5_s  = 4'b0101,
            rd_bufid_ch6_s  = 4'b0110,
            rd_bufid_ch7_s  = 4'b0111,
            rd_bufid_ch8_s  = 4'b1000,
            wait_1s         = 4'b1001,
            initial_s       = 4'b1010;      
always@(posedge clk_sys or negedge reset_n)     
    if(!reset_n) begin
        ov_pkt_bufid_p0     <= 9'b0;
        o_pkt_bufid_wr_p0   <= 1'b0;
        ov_pkt_bufid_p1     <= 9'b0;
        o_pkt_bufid_wr_p1   <= 1'b0;        
        ov_pkt_bufid_p2     <= 9'b0;
        o_pkt_bufid_wr_p2   <= 1'b0;
        ov_pkt_bufid_p3     <= 9'b0;
        o_pkt_bufid_wr_p3   <= 1'b0;
        ov_pkt_bufid_p4     <= 9'b0;
        o_pkt_bufid_wr_p4   <= 1'b0;
        ov_pkt_bufid_p5     <= 9'b0;
        o_pkt_bufid_wr_p5   <= 1'b0;        
        ov_pkt_bufid_p6     <= 9'b0;
        o_pkt_bufid_wr_p6   <= 1'b0;
        ov_pkt_bufid_p7     <= 9'b0;
        o_pkt_bufid_wr_p7   <= 1'b0;
        ov_pkt_bufid_p8     <= 9'b0;
        o_pkt_bufid_wr_p8   <= 1'b0;
        o_pkt_bufid_rd      <= 1'b0;
        rd_valid            <= 9'b0;
        reg_bufid_ack_p0    <= 1'b0;
        reg_bufid_ack_p1    <= 1'b0;
        reg_bufid_ack_p2    <= 1'b0;
        reg_bufid_ack_p3    <= 1'b0;
        reg_bufid_ack_p4    <= 1'b0;
        reg_bufid_ack_p5    <= 1'b0;
        reg_bufid_ack_p6    <= 1'b0;
        reg_bufid_ack_p7    <= 1'b0;
        reg_bufid_ack_p8    <= 1'b0;
        ov_address_read_state       <= initial_s;
        end
    else begin
        case(ov_address_read_state)
            initial_s:begin
                ov_pkt_bufid_p0     <= 9'd0;
                o_pkt_bufid_wr_p0   <= 1'b1;
                ov_pkt_bufid_p1     <= 9'd1;
                o_pkt_bufid_wr_p1   <= 1'b1;
                ov_pkt_bufid_p2     <= 9'd2;
                o_pkt_bufid_wr_p2   <= 1'b1;
                ov_pkt_bufid_p3     <= 9'd3;
                o_pkt_bufid_wr_p3   <= 1'b1;
                ov_pkt_bufid_p4     <= 9'd4;
                o_pkt_bufid_wr_p4   <= 1'b1;
                ov_pkt_bufid_p5     <= 9'd5;
                o_pkt_bufid_wr_p5   <= 1'b1;
                ov_pkt_bufid_p6     <= 9'd6;
                o_pkt_bufid_wr_p6   <= 1'b1;
                ov_pkt_bufid_p7     <= 9'd7;
                o_pkt_bufid_wr_p7   <= 1'b1;
                ov_pkt_bufid_p8     <= 9'd8;
                o_pkt_bufid_wr_p8   <= 1'b1;
                ov_address_read_state       <= rd_bufid_ch0_s;
                end
            rd_bufid_ch0_s:begin
                //ack0
                if((i_pkt_bufid_ack_p0 == 1'b1 || reg_bufid_ack_p0 == 1'b1)) begin
                    ov_pkt_bufid_p0     <= 9'b0;//release firstly when ack
                    o_pkt_bufid_wr_p0   <= 1'b0;
                    if(i_pkt_bufid_empty != 1'b1)begin
                        reg_bufid_ack_p0    <= 1'b0;
                        o_pkt_bufid_rd      <= 1'b1;//read FIFO once.
                        rd_valid[0]         <= 1'b1;//record of read
                        ov_address_read_state       <= wait_1s;
                        end
                    else begin
                        reg_bufid_ack_p0    <= 1'b1;
                        o_pkt_bufid_rd      <= 1'b0;//read FIFO once.
                        rd_valid[0]         <= 1'b0;//record of read
                        ov_address_read_state       <= rd_bufid_ch1_s;
                        end
                    end
                else begin
                    reg_bufid_ack_p0    <= reg_bufid_ack_p0;
                    o_pkt_bufid_rd      <= 1'b0;
                    rd_valid[0]         <= 1'b0;
                    ov_pkt_bufid_p0     <= ov_pkt_bufid_p0;
                    o_pkt_bufid_wr_p0   <= o_pkt_bufid_wr_p0;
                    ov_address_read_state       <= rd_bufid_ch1_s;
                    end
                //ack1
                if(i_pkt_bufid_ack_p1 == 1'b1) begin
                    reg_bufid_ack_p1    <= 1'b1;
                    ov_pkt_bufid_p1     <= 9'b0;
                    o_pkt_bufid_wr_p1   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p1    <= reg_bufid_ack_p1;
                    ov_pkt_bufid_p1     <= ov_pkt_bufid_p1;
                    o_pkt_bufid_wr_p1   <= o_pkt_bufid_wr_p1;               
                    end         
                //ack2
                if(i_pkt_bufid_ack_p2 == 1'b1) begin
                    reg_bufid_ack_p2    <= 1'b1;
                    ov_pkt_bufid_p2     <= 9'b0;
                    o_pkt_bufid_wr_p2   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p2    <= reg_bufid_ack_p2;
                    ov_pkt_bufid_p2     <= ov_pkt_bufid_p2;
                    o_pkt_bufid_wr_p2   <= o_pkt_bufid_wr_p2;
                    end
                //ack3
                if(i_pkt_bufid_ack_p3 == 1'b1) begin
                    reg_bufid_ack_p3    <= 1'b1;
                    ov_pkt_bufid_p3     <= 9'b0;
                    o_pkt_bufid_wr_p3   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p3    <= reg_bufid_ack_p3;
                    ov_pkt_bufid_p3     <= ov_pkt_bufid_p3;
                    o_pkt_bufid_wr_p3   <= o_pkt_bufid_wr_p3;
                    end
                //ack4  
                if(i_pkt_bufid_ack_p4 == 1'b1) begin
                    reg_bufid_ack_p4    <= 1'b1;
                    ov_pkt_bufid_p4     <= 9'b0;
                    o_pkt_bufid_wr_p4   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p4    <= reg_bufid_ack_p4;
                    ov_pkt_bufid_p4     <= ov_pkt_bufid_p4;
                    o_pkt_bufid_wr_p4   <= o_pkt_bufid_wr_p4;
                    end
                //ack5
                if(i_pkt_bufid_ack_p5 == 1'b1) begin
                    reg_bufid_ack_p5    <= 1'b1;
                    ov_pkt_bufid_p5     <= 9'b0;
                    o_pkt_bufid_wr_p5   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p5    <= reg_bufid_ack_p5;
                    ov_pkt_bufid_p5     <= ov_pkt_bufid_p5;
                    o_pkt_bufid_wr_p5   <= o_pkt_bufid_wr_p5;
                    end
                //ack6  
                if(i_pkt_bufid_ack_p6 == 1'b1) begin
                    reg_bufid_ack_p6    <= 1'b1;
                    ov_pkt_bufid_p6     <= 9'b0;
                    o_pkt_bufid_wr_p6   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p6    <= reg_bufid_ack_p6;
                    ov_pkt_bufid_p6     <= ov_pkt_bufid_p6;
                    o_pkt_bufid_wr_p6   <= o_pkt_bufid_wr_p6;
                    end
                //ack7  
                if(i_pkt_bufid_ack_p7 == 1'b1) begin
                    reg_bufid_ack_p7    <= 1'b1;
                    ov_pkt_bufid_p7     <= 9'b0;
                    o_pkt_bufid_wr_p7   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p7    <= reg_bufid_ack_p7;
                    ov_pkt_bufid_p7     <= ov_pkt_bufid_p7;
                    o_pkt_bufid_wr_p7   <= o_pkt_bufid_wr_p7;
                    end
                //ack8              
                if(rd_valid[8])begin
                    ov_pkt_bufid_p8     <= iv_pkt_bufid;//FIFO is in showhead mode and FIFO is based on RAM(outport with register),so data will delay 1 cycle.
                    o_pkt_bufid_wr_p8   <= 1'b1;
                    rd_valid[8]         <= 1'b0;                
                    end
                else if(i_pkt_bufid_ack_p8 == 1'b1) begin
                    reg_bufid_ack_p8    <= 1'b1;
                    ov_pkt_bufid_p8     <= 9'b0;
                    o_pkt_bufid_wr_p8   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p8    <= reg_bufid_ack_p8;
                    ov_pkt_bufid_p8     <= ov_pkt_bufid_p8;
                    o_pkt_bufid_wr_p8   <= o_pkt_bufid_wr_p8;
                    end
                end
                
            rd_bufid_ch1_s:begin
                //ack0
                if(rd_valid[0])begin
                    ov_pkt_bufid_p0     <= iv_pkt_bufid;//FIFO is in showhead mode.
                    o_pkt_bufid_wr_p0   <= 1'b1;
                    rd_valid[0]         <= 1'b0;                
                    end
                else if(i_pkt_bufid_ack_p0 == 1'b1) begin
                    reg_bufid_ack_p0    <= 1'b1;
                    ov_pkt_bufid_p0     <= 9'b0;
                    o_pkt_bufid_wr_p0   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p0    <= reg_bufid_ack_p0;
                    ov_pkt_bufid_p0     <= ov_pkt_bufid_p0;
                    o_pkt_bufid_wr_p0   <= o_pkt_bufid_wr_p0;               
                    end
                //ack1
                if((i_pkt_bufid_ack_p1 == 1'b1 ||reg_bufid_ack_p1 == 1'b1)) begin
                    ov_pkt_bufid_p1     <= 9'b0;//release firstly when ack
                    o_pkt_bufid_wr_p1   <= 1'b0;
                    if(i_pkt_bufid_empty != 1'b1)begin
                        reg_bufid_ack_p1    <= 1'b0;
                        o_pkt_bufid_rd      <= 1'b1;//read FIFO once.
                        rd_valid[1]         <= 1'b1;//record of read
                        ov_address_read_state       <= wait_1s;
                        end
                    else begin
                        reg_bufid_ack_p1    <= 1'b1;
                        o_pkt_bufid_rd      <= 1'b0;//read FIFO once.
                        rd_valid[1]         <= 1'b0;//record of read
                        ov_address_read_state       <= rd_bufid_ch2_s;
                        end
                    end
                else begin
                    reg_bufid_ack_p1    <= reg_bufid_ack_p1;                
                    o_pkt_bufid_rd      <= 1'b0;
                    rd_valid[1]         <= 1'b0;
                    ov_pkt_bufid_p1     <= ov_pkt_bufid_p1;
                    o_pkt_bufid_wr_p1   <= o_pkt_bufid_wr_p1;
                    ov_address_read_state       <= rd_bufid_ch2_s;                  
                    end 
                //ack2
                if(i_pkt_bufid_ack_p2 == 1'b1) begin
                    reg_bufid_ack_p2    <= 1'b1;
                    ov_pkt_bufid_p2     <= 9'b0;
                    o_pkt_bufid_wr_p2   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p2    <= reg_bufid_ack_p2;
                    ov_pkt_bufid_p2     <= ov_pkt_bufid_p2;
                    o_pkt_bufid_wr_p2   <= o_pkt_bufid_wr_p2;
                    end
                //ack3
                if(i_pkt_bufid_ack_p3 == 1'b1) begin
                    reg_bufid_ack_p3    <= 1'b1;
                    ov_pkt_bufid_p3     <= 9'b0;
                    o_pkt_bufid_wr_p3   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p3    <= reg_bufid_ack_p3;
                    ov_pkt_bufid_p3     <= ov_pkt_bufid_p3;
                    o_pkt_bufid_wr_p3   <= o_pkt_bufid_wr_p3;
                    end
                //ack4  
                if(i_pkt_bufid_ack_p4 == 1'b1) begin
                    reg_bufid_ack_p4    <= 1'b1;
                    ov_pkt_bufid_p4     <= 9'b0;
                    o_pkt_bufid_wr_p4   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p4    <= reg_bufid_ack_p4;
                    ov_pkt_bufid_p4     <= ov_pkt_bufid_p4;
                    o_pkt_bufid_wr_p4   <= o_pkt_bufid_wr_p4;
                    end
                //ack5
                if(i_pkt_bufid_ack_p5 == 1'b1) begin
                    reg_bufid_ack_p5    <= 1'b1;
                    ov_pkt_bufid_p5     <= 9'b0;
                    o_pkt_bufid_wr_p5   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p5    <= reg_bufid_ack_p5;
                    ov_pkt_bufid_p5     <= ov_pkt_bufid_p5;
                    o_pkt_bufid_wr_p5   <= o_pkt_bufid_wr_p5;
                    end
                //ack6  
                if(i_pkt_bufid_ack_p6 == 1'b1) begin
                    reg_bufid_ack_p6    <= 1'b1;
                    ov_pkt_bufid_p6     <= 9'b0;
                    o_pkt_bufid_wr_p6   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p6    <= reg_bufid_ack_p6;
                    ov_pkt_bufid_p6     <= ov_pkt_bufid_p6;
                    o_pkt_bufid_wr_p6   <= o_pkt_bufid_wr_p6;
                    end
                //ack7  
                if(i_pkt_bufid_ack_p7 == 1'b1) begin
                    reg_bufid_ack_p7    <= 1'b1;
                    ov_pkt_bufid_p7     <= 9'b0;
                    o_pkt_bufid_wr_p7   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p7    <= reg_bufid_ack_p7;
                    ov_pkt_bufid_p7     <= ov_pkt_bufid_p7;
                    o_pkt_bufid_wr_p7   <= o_pkt_bufid_wr_p7;
                    end
                //ack8  
                if(i_pkt_bufid_ack_p8 == 1'b1) begin
                    reg_bufid_ack_p8    <= 1'b1;
                    ov_pkt_bufid_p8     <= 9'b0;
                    o_pkt_bufid_wr_p8   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p8    <= reg_bufid_ack_p8;
                    ov_pkt_bufid_p8     <= ov_pkt_bufid_p8;
                    o_pkt_bufid_wr_p8   <= o_pkt_bufid_wr_p8;
                    end 
                end
                
            rd_bufid_ch2_s:begin
                //ack0
                if(i_pkt_bufid_ack_p0 == 1'b1) begin
                    reg_bufid_ack_p0    <= 1'b1;
                    ov_pkt_bufid_p0     <= 9'b0;
                    o_pkt_bufid_wr_p0   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p0    <= reg_bufid_ack_p0;
                    ov_pkt_bufid_p0     <= ov_pkt_bufid_p0;
                    o_pkt_bufid_wr_p0   <= o_pkt_bufid_wr_p0;               
                    end 
                //ack1
                if(rd_valid[1])begin
                    ov_pkt_bufid_p1     <= iv_pkt_bufid;//FIFO is in showhead mode.
                    o_pkt_bufid_wr_p1   <= 1'b1;
                    rd_valid[1]         <= 1'b0;                
                    end             
                else if(i_pkt_bufid_ack_p1 == 1'b1) begin
                    reg_bufid_ack_p1    <= 1'b1;
                    ov_pkt_bufid_p1     <= 9'b0;
                    o_pkt_bufid_wr_p1   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p1    <= reg_bufid_ack_p1;
                    ov_pkt_bufid_p1     <= ov_pkt_bufid_p1;
                    o_pkt_bufid_wr_p1   <= o_pkt_bufid_wr_p1;               
                    end
                //ack2
                if((i_pkt_bufid_ack_p2 == 1'b1 || reg_bufid_ack_p2 == 1'b1)) begin
                    ov_pkt_bufid_p2     <= 9'b0;//release firstly when ack
                    o_pkt_bufid_wr_p2   <= 1'b0;
                    if(i_pkt_bufid_empty != 1'b1)begin
                        reg_bufid_ack_p2    <= 1'b0;
                        o_pkt_bufid_rd      <= 1'b1;//read FIFO once.
                        rd_valid[2]         <= 1'b1;//record of read
                        ov_address_read_state       <= wait_1s;
                        end
                    else begin
                        reg_bufid_ack_p2    <= 1'b1;
                        o_pkt_bufid_rd      <= 1'b0;//read FIFO once.
                        rd_valid[2]         <= 1'b0;//record of read
                        ov_address_read_state       <= rd_bufid_ch3_s;
                        end
                    end
                else begin
                    reg_bufid_ack_p2    <= reg_bufid_ack_p2;
                    o_pkt_bufid_rd      <= 1'b0;
                    rd_valid[2]         <= 1'b0;
                    ov_pkt_bufid_p2     <= ov_pkt_bufid_p2;
                    o_pkt_bufid_wr_p2   <= o_pkt_bufid_wr_p2;
                    ov_address_read_state       <= rd_bufid_ch3_s;                  
                    end
                //ack3
                if(i_pkt_bufid_ack_p3 == 1'b1) begin
                    reg_bufid_ack_p3    <= 1'b1;
                    ov_pkt_bufid_p3     <= 9'b0;
                    o_pkt_bufid_wr_p3   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p3    <= reg_bufid_ack_p3;
                    ov_pkt_bufid_p3     <= ov_pkt_bufid_p3;
                    o_pkt_bufid_wr_p3   <= o_pkt_bufid_wr_p3;
                    end
                //ack4  
                if(i_pkt_bufid_ack_p4 == 1'b1) begin
                    reg_bufid_ack_p4    <= 1'b1;
                    ov_pkt_bufid_p4     <= 9'b0;
                    o_pkt_bufid_wr_p4   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p4    <= reg_bufid_ack_p4;
                    ov_pkt_bufid_p4     <= ov_pkt_bufid_p4;
                    o_pkt_bufid_wr_p4   <= o_pkt_bufid_wr_p4;
                    end
                //ack5
                if(i_pkt_bufid_ack_p5 == 1'b1) begin
                    reg_bufid_ack_p5    <= 1'b1;
                    ov_pkt_bufid_p5     <= 9'b0;
                    o_pkt_bufid_wr_p5   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p5    <= reg_bufid_ack_p5;
                    ov_pkt_bufid_p5     <= ov_pkt_bufid_p5;
                    o_pkt_bufid_wr_p5   <= o_pkt_bufid_wr_p5;
                    end
                //ack6  
                if(i_pkt_bufid_ack_p6 == 1'b1) begin
                    reg_bufid_ack_p6    <= 1'b1;
                    ov_pkt_bufid_p6     <= 9'b0;
                    o_pkt_bufid_wr_p6   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p6    <= reg_bufid_ack_p6;
                    ov_pkt_bufid_p6     <= ov_pkt_bufid_p6;
                    o_pkt_bufid_wr_p6   <= o_pkt_bufid_wr_p6;
                    end
                //ack7  
                if(i_pkt_bufid_ack_p7 == 1'b1) begin
                    reg_bufid_ack_p7    <= 1'b1;
                    ov_pkt_bufid_p7     <= 9'b0;
                    o_pkt_bufid_wr_p7   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p7    <= reg_bufid_ack_p7;
                    ov_pkt_bufid_p7     <= ov_pkt_bufid_p7;
                    o_pkt_bufid_wr_p7   <= o_pkt_bufid_wr_p7;
                    end
                //ack8  
                if(i_pkt_bufid_ack_p8 == 1'b1) begin
                    reg_bufid_ack_p8    <= 1'b1;
                    ov_pkt_bufid_p8     <= 9'b0;
                    o_pkt_bufid_wr_p8   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p8    <= reg_bufid_ack_p8;
                    ov_pkt_bufid_p8     <= ov_pkt_bufid_p8;
                    o_pkt_bufid_wr_p8   <= o_pkt_bufid_wr_p8;
                    end                 
                end
                
            rd_bufid_ch3_s:begin
                //ack0
                if(i_pkt_bufid_ack_p0 == 1'b1) begin
                    reg_bufid_ack_p0    <= 1'b1;
                    ov_pkt_bufid_p0     <= 9'b0;
                    o_pkt_bufid_wr_p0   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p0    <= reg_bufid_ack_p0;
                    ov_pkt_bufid_p0     <= ov_pkt_bufid_p0;
                    o_pkt_bufid_wr_p0   <= o_pkt_bufid_wr_p0;               
                    end
                //ack1
                if(i_pkt_bufid_ack_p1 == 1'b1) begin
                    reg_bufid_ack_p1    <= 1'b1;
                    ov_pkt_bufid_p1     <= 9'b0;
                    o_pkt_bufid_wr_p1   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p1    <= reg_bufid_ack_p1;
                    ov_pkt_bufid_p1     <= ov_pkt_bufid_p1;
                    o_pkt_bufid_wr_p1   <= o_pkt_bufid_wr_p1;               
                    end
                //ack2
                if(rd_valid[2])begin
                    ov_pkt_bufid_p2     <= iv_pkt_bufid;//FIFO is in showhead mode.
                    o_pkt_bufid_wr_p2   <= 1'b1;
                    rd_valid[2]         <= 1'b0;                
                    end
                else if(i_pkt_bufid_ack_p2 == 1'b1) begin
                    reg_bufid_ack_p2    <= 1'b1;
                    ov_pkt_bufid_p2     <= 9'b0;
                    o_pkt_bufid_wr_p2   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p2    <= reg_bufid_ack_p2;
                    ov_pkt_bufid_p2     <= ov_pkt_bufid_p2;
                    o_pkt_bufid_wr_p2   <= o_pkt_bufid_wr_p2;
                    end
                //ack3      
                if((i_pkt_bufid_ack_p3 == 1'b1 ||reg_bufid_ack_p3 == 1'b1)) begin
                    ov_pkt_bufid_p3     <= 9'b0;//release firstly when ack
                    o_pkt_bufid_wr_p3   <= 1'b0;
                    if(i_pkt_bufid_empty != 1'b1)begin
                        reg_bufid_ack_p3    <= 1'b0;
                        o_pkt_bufid_rd      <= 1'b1;//read FIFO once.
                        rd_valid[3]         <= 1'b1;//record of read
                        ov_address_read_state       <= wait_1s;
                        end
                    else begin
                        reg_bufid_ack_p3    <= 1'b1;
                        o_pkt_bufid_rd      <= 1'b0;//read FIFO once.
                        rd_valid[3]         <= 1'b0;//record of read
                        ov_address_read_state       <= rd_bufid_ch4_s;
                        end
                    end
                else begin
                    reg_bufid_ack_p3    <= reg_bufid_ack_p3;
                    o_pkt_bufid_rd      <= 1'b0;
                    rd_valid[3]         <= 1'b0;
                    ov_pkt_bufid_p3     <= ov_pkt_bufid_p3;
                    o_pkt_bufid_wr_p3   <= o_pkt_bufid_wr_p3;
                    ov_address_read_state       <= rd_bufid_ch4_s;                  
                    end
                //ack4  
                if(i_pkt_bufid_ack_p4 == 1'b1) begin
                    reg_bufid_ack_p4    <= 1'b1;
                    ov_pkt_bufid_p4     <= 9'b0;
                    o_pkt_bufid_wr_p4   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p4    <= reg_bufid_ack_p4;
                    ov_pkt_bufid_p4     <= ov_pkt_bufid_p4;
                    o_pkt_bufid_wr_p4   <= o_pkt_bufid_wr_p4;
                    end
                //ack5
                if(i_pkt_bufid_ack_p5 == 1'b1) begin
                    reg_bufid_ack_p5    <= 1'b1;
                    ov_pkt_bufid_p5     <= 9'b0;
                    o_pkt_bufid_wr_p5   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p5    <= reg_bufid_ack_p5;
                    ov_pkt_bufid_p5     <= ov_pkt_bufid_p5;
                    o_pkt_bufid_wr_p5   <= o_pkt_bufid_wr_p5;
                    end
                //ack6  
                if(i_pkt_bufid_ack_p6 == 1'b1) begin
                    reg_bufid_ack_p6    <= 1'b1;
                    ov_pkt_bufid_p6     <= 9'b0;
                    o_pkt_bufid_wr_p6   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p6    <= reg_bufid_ack_p6;
                    ov_pkt_bufid_p6     <= ov_pkt_bufid_p6;
                    o_pkt_bufid_wr_p6   <= o_pkt_bufid_wr_p6;
                    end
                //ack7  
                if(i_pkt_bufid_ack_p7 == 1'b1) begin
                    reg_bufid_ack_p7    <= 1'b1;
                    ov_pkt_bufid_p7     <= 9'b0;
                    o_pkt_bufid_wr_p7   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p7    <= reg_bufid_ack_p7;
                    ov_pkt_bufid_p7     <= ov_pkt_bufid_p7;
                    o_pkt_bufid_wr_p7   <= o_pkt_bufid_wr_p7;
                    end
                //ack8  
                if(i_pkt_bufid_ack_p8 == 1'b1) begin
                    reg_bufid_ack_p8    <= 1'b1;
                    ov_pkt_bufid_p8     <= 9'b0;
                    o_pkt_bufid_wr_p8   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p8    <= reg_bufid_ack_p8;
                    ov_pkt_bufid_p8     <= ov_pkt_bufid_p8;
                    o_pkt_bufid_wr_p8   <= o_pkt_bufid_wr_p8;
                    end                 
                end
                
            rd_bufid_ch4_s:begin
                //ack0
                if(i_pkt_bufid_ack_p0 == 1'b1) begin
                    reg_bufid_ack_p0    <= 1'b1;
                    ov_pkt_bufid_p0     <= 9'b0;
                    o_pkt_bufid_wr_p0   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p0    <= reg_bufid_ack_p0;
                    ov_pkt_bufid_p0     <= ov_pkt_bufid_p0;
                    o_pkt_bufid_wr_p0   <= o_pkt_bufid_wr_p0;               
                    end
                //ack1
                if(i_pkt_bufid_ack_p1 == 1'b1) begin
                    reg_bufid_ack_p1    <= 1'b1;
                    ov_pkt_bufid_p1     <= 9'b0;
                    o_pkt_bufid_wr_p1   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p1    <= reg_bufid_ack_p1;
                    ov_pkt_bufid_p1     <= ov_pkt_bufid_p1;
                    o_pkt_bufid_wr_p1   <= o_pkt_bufid_wr_p1;               
                    end
                //ack2
                if(i_pkt_bufid_ack_p2 == 1'b1) begin
                    reg_bufid_ack_p2    <= 1'b1;
                    ov_pkt_bufid_p2     <= 9'b0;
                    o_pkt_bufid_wr_p2   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p2    <= reg_bufid_ack_p2;
                    ov_pkt_bufid_p2     <= ov_pkt_bufid_p2;
                    o_pkt_bufid_wr_p2   <= o_pkt_bufid_wr_p2;
                    end
                //ack3
                if(rd_valid[3])begin
                    ov_pkt_bufid_p3     <= iv_pkt_bufid;//FIFO is in showhead mode and FIFO is based on RAM(outport with register),so data will delay 1 cycle.
                    o_pkt_bufid_wr_p3   <= 1'b1;
                    rd_valid[3]         <= 1'b0;                
                    end
                else if(i_pkt_bufid_ack_p3 == 1'b1) begin
                    reg_bufid_ack_p3    <= 1'b1;
                    ov_pkt_bufid_p3     <= 9'b0;
                    o_pkt_bufid_wr_p3   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p3    <= reg_bufid_ack_p3;
                    ov_pkt_bufid_p3     <= ov_pkt_bufid_p3;
                    o_pkt_bufid_wr_p3   <= o_pkt_bufid_wr_p3;               
                    end
                //ack4
                if((i_pkt_bufid_ack_p4 == 1'b1 ||reg_bufid_ack_p4 == 1'b1)) begin
                    ov_pkt_bufid_p4     <= 9'b0;//release firstly when ack
                    o_pkt_bufid_wr_p4   <= 1'b0;
                    if(i_pkt_bufid_empty != 1'b1)begin
                        reg_bufid_ack_p4    <= 1'b0;
                        o_pkt_bufid_rd      <= 1'b1;//read FIFO once.
                        rd_valid[4]         <= 1'b1;//record of read
                        ov_address_read_state       <= wait_1s;
                        end
                    else begin
                        reg_bufid_ack_p4    <= 1'b1;
                        o_pkt_bufid_rd      <= 1'b0;//read FIFO once.
                        rd_valid[4]         <= 1'b0;//record of read
                        ov_address_read_state       <= rd_bufid_ch5_s;
                        end
                    end
                else begin
                    reg_bufid_ack_p4    <= reg_bufid_ack_p4;
                    o_pkt_bufid_rd      <= 1'b0;
                    rd_valid[4]         <= 1'b0;
                    ov_pkt_bufid_p4     <= ov_pkt_bufid_p4;
                    o_pkt_bufid_wr_p4   <= o_pkt_bufid_wr_p4;
                    ov_address_read_state       <= rd_bufid_ch5_s;
                    end
                //ack5
                if(i_pkt_bufid_ack_p5 == 1'b1) begin
                    reg_bufid_ack_p5    <= 1'b1;
                    ov_pkt_bufid_p5     <= 9'b0;
                    o_pkt_bufid_wr_p5   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p5    <= reg_bufid_ack_p5;
                    ov_pkt_bufid_p5     <= ov_pkt_bufid_p5;
                    o_pkt_bufid_wr_p5   <= o_pkt_bufid_wr_p5;
                    end
                //ack6  
                if(i_pkt_bufid_ack_p6 == 1'b1) begin
                    reg_bufid_ack_p6    <= 1'b1;
                    ov_pkt_bufid_p6     <= 9'b0;
                    o_pkt_bufid_wr_p6   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p6    <= reg_bufid_ack_p6;
                    ov_pkt_bufid_p6     <= ov_pkt_bufid_p6;
                    o_pkt_bufid_wr_p6   <= o_pkt_bufid_wr_p6;
                    end
                //ack7  
                if(i_pkt_bufid_ack_p7 == 1'b1) begin
                    reg_bufid_ack_p7    <= 1'b1;
                    ov_pkt_bufid_p7     <= 9'b0;
                    o_pkt_bufid_wr_p7   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p7    <= reg_bufid_ack_p7;
                    ov_pkt_bufid_p7     <= ov_pkt_bufid_p7;
                    o_pkt_bufid_wr_p7   <= o_pkt_bufid_wr_p7;
                    end
                //ack8  
                if(i_pkt_bufid_ack_p8 == 1'b1) begin
                    reg_bufid_ack_p8    <= 1'b1;
                    ov_pkt_bufid_p8     <= 9'b0;
                    o_pkt_bufid_wr_p8   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p8    <= reg_bufid_ack_p8;
                    ov_pkt_bufid_p8     <= ov_pkt_bufid_p8;
                    o_pkt_bufid_wr_p8   <= o_pkt_bufid_wr_p8;
                    end                 
                end
                
            rd_bufid_ch5_s:begin
                //ack0
                if(i_pkt_bufid_ack_p0 == 1'b1) begin
                    reg_bufid_ack_p0    <= 1'b1;
                    ov_pkt_bufid_p0     <= 9'b0;
                    o_pkt_bufid_wr_p0   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p0    <= reg_bufid_ack_p0;
                    ov_pkt_bufid_p0     <= ov_pkt_bufid_p0;
                    o_pkt_bufid_wr_p0   <= o_pkt_bufid_wr_p0;               
                    end
                //ack1
                if(i_pkt_bufid_ack_p1 == 1'b1) begin
                    reg_bufid_ack_p1    <= 1'b1;
                    ov_pkt_bufid_p1     <= 9'b0;
                    o_pkt_bufid_wr_p1   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p1    <= reg_bufid_ack_p1;
                    ov_pkt_bufid_p1     <= ov_pkt_bufid_p1;
                    o_pkt_bufid_wr_p1   <= o_pkt_bufid_wr_p1;               
                    end
                //ack2
                if(i_pkt_bufid_ack_p2 == 1'b1) begin
                    reg_bufid_ack_p2    <= 1'b1;
                    ov_pkt_bufid_p2     <= 9'b0;
                    o_pkt_bufid_wr_p2   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p2    <= reg_bufid_ack_p2;
                    ov_pkt_bufid_p2     <= ov_pkt_bufid_p2;
                    o_pkt_bufid_wr_p2   <= o_pkt_bufid_wr_p2;
                    end
                //ack3              
                if(i_pkt_bufid_ack_p3 == 1'b1) begin
                    reg_bufid_ack_p3    <= 1'b1;
                    ov_pkt_bufid_p3     <= 9'b0;
                    o_pkt_bufid_wr_p3   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p3    <= reg_bufid_ack_p3;
                    ov_pkt_bufid_p3     <= ov_pkt_bufid_p3;
                    o_pkt_bufid_wr_p3   <= o_pkt_bufid_wr_p3;
                    end
                //ack4
                if(rd_valid[4])begin
                    ov_pkt_bufid_p4     <= iv_pkt_bufid;//FIFO is in showhead mode and FIFO is based on RAM(outport with register),so data will delay 1 cycle.
                    o_pkt_bufid_wr_p4   <= 1'b1;
                    rd_valid[4]         <= 1'b0;                
                    end
                else if(i_pkt_bufid_ack_p4 == 1'b1) begin
                    reg_bufid_ack_p4    <= 1'b1;
                    ov_pkt_bufid_p4     <= 9'b0;
                    o_pkt_bufid_wr_p4   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p4    <= reg_bufid_ack_p4;
                    ov_pkt_bufid_p4     <= ov_pkt_bufid_p4;
                    o_pkt_bufid_wr_p4   <= o_pkt_bufid_wr_p4;               
                    end
                //ack5
                if((i_pkt_bufid_ack_p5 == 1'b1 ||reg_bufid_ack_p5 == 1'b1)) begin
                    ov_pkt_bufid_p5     <= 9'b0;//release firstly when ack
                    o_pkt_bufid_wr_p5   <= 1'b0;
                    if(i_pkt_bufid_empty != 1'b1)begin
                        reg_bufid_ack_p5    <= 1'b0;
                        o_pkt_bufid_rd      <= 1'b1;//read FIFO once.
                        rd_valid[5]         <= 1'b1;//record of read
                        ov_address_read_state       <= wait_1s;
                        end
                    else begin
                        reg_bufid_ack_p5    <= 1'b1;
                        o_pkt_bufid_rd      <= 1'b0;//read FIFO once.
                        rd_valid[5]         <= 1'b0;//record of read
                        ov_address_read_state       <= rd_bufid_ch6_s;
                        end
                    end
                else begin
                    reg_bufid_ack_p5    <= reg_bufid_ack_p5;
                    o_pkt_bufid_rd      <= 1'b0;
                    rd_valid[5]         <= 1'b0;
                    ov_pkt_bufid_p5     <= ov_pkt_bufid_p5;
                    o_pkt_bufid_wr_p5   <= o_pkt_bufid_wr_p5;
                    ov_address_read_state       <= rd_bufid_ch6_s;                  
                    end
                //ack6  
                if(i_pkt_bufid_ack_p6 == 1'b1) begin
                    reg_bufid_ack_p6    <= 1'b1;
                    ov_pkt_bufid_p6     <= 9'b0;
                    o_pkt_bufid_wr_p6   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p6    <= reg_bufid_ack_p6;
                    ov_pkt_bufid_p6     <= ov_pkt_bufid_p6;
                    o_pkt_bufid_wr_p6   <= o_pkt_bufid_wr_p6;
                    end
                //ack7  
                if(i_pkt_bufid_ack_p7 == 1'b1) begin
                    reg_bufid_ack_p7    <= 1'b1;
                    ov_pkt_bufid_p7     <= 9'b0;
                    o_pkt_bufid_wr_p7   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p7    <= reg_bufid_ack_p7;
                    ov_pkt_bufid_p7     <= ov_pkt_bufid_p7;
                    o_pkt_bufid_wr_p7   <= o_pkt_bufid_wr_p7;
                    end
                //ack8  
                if(i_pkt_bufid_ack_p8 == 1'b1) begin
                    reg_bufid_ack_p8    <= 1'b1;
                    ov_pkt_bufid_p8     <= 9'b0;
                    o_pkt_bufid_wr_p8   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p8    <= reg_bufid_ack_p8;
                    ov_pkt_bufid_p8     <= ov_pkt_bufid_p8;
                    o_pkt_bufid_wr_p8   <= o_pkt_bufid_wr_p8;
                    end                 
                end
                
            rd_bufid_ch6_s:begin
                //ack0
                if(i_pkt_bufid_ack_p0 == 1'b1) begin
                    reg_bufid_ack_p0    <= 1'b1;
                    ov_pkt_bufid_p0     <= 9'b0;
                    o_pkt_bufid_wr_p0   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p0    <= reg_bufid_ack_p0;
                    ov_pkt_bufid_p0     <= ov_pkt_bufid_p0;
                    o_pkt_bufid_wr_p0   <= o_pkt_bufid_wr_p0;               
                    end
                //ack1
                if(i_pkt_bufid_ack_p1 == 1'b1) begin
                    reg_bufid_ack_p1    <= 1'b1;
                    ov_pkt_bufid_p1     <= 9'b0;
                    o_pkt_bufid_wr_p1   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p1    <= reg_bufid_ack_p1;
                    ov_pkt_bufid_p1     <= ov_pkt_bufid_p1;
                    o_pkt_bufid_wr_p1   <= o_pkt_bufid_wr_p1;               
                    end
                //ack2
                if(i_pkt_bufid_ack_p2 == 1'b1) begin
                    reg_bufid_ack_p2    <= 1'b1;
                    ov_pkt_bufid_p2     <= 9'b0;
                    o_pkt_bufid_wr_p2   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p2    <= reg_bufid_ack_p2;
                    ov_pkt_bufid_p2     <= ov_pkt_bufid_p2;
                    o_pkt_bufid_wr_p2   <= o_pkt_bufid_wr_p2;
                    end
                //ack3
                if(i_pkt_bufid_ack_p3 == 1'b1) begin
                    reg_bufid_ack_p3    <= 1'b1;
                    ov_pkt_bufid_p3     <= 9'b0;
                    o_pkt_bufid_wr_p3   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p3    <= reg_bufid_ack_p3;
                    ov_pkt_bufid_p3     <= ov_pkt_bufid_p3;
                    o_pkt_bufid_wr_p3   <= o_pkt_bufid_wr_p3;
                    end
                //ack4
                if(i_pkt_bufid_ack_p4 == 1'b1) begin
                    reg_bufid_ack_p4    <= 1'b1;
                    ov_pkt_bufid_p4     <= 9'b0;
                    o_pkt_bufid_wr_p4   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p4    <= reg_bufid_ack_p4;
                    ov_pkt_bufid_p4     <= ov_pkt_bufid_p4;
                    o_pkt_bufid_wr_p4   <= o_pkt_bufid_wr_p4;
                    end
                //ack5
                if(rd_valid[5])begin
                    ov_pkt_bufid_p5     <= iv_pkt_bufid;//FIFO is in showhead mode and FIFO is based on RAM(outport with register),so data will delay 1 cycle.
                    o_pkt_bufid_wr_p5   <= 1'b1;
                    rd_valid[5]         <= 1'b0;                
                    end
                else if(i_pkt_bufid_ack_p5 == 1'b1) begin
                    reg_bufid_ack_p5    <= 1'b1;
                    ov_pkt_bufid_p5     <= 9'b0;
                    o_pkt_bufid_wr_p5   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p5    <= reg_bufid_ack_p5;
                    ov_pkt_bufid_p5     <= ov_pkt_bufid_p5;
                    o_pkt_bufid_wr_p5   <= o_pkt_bufid_wr_p5;               
                    end
                //ack6      
                if((i_pkt_bufid_ack_p6 == 1'b1 ||reg_bufid_ack_p6 == 1'b1)) begin
                    ov_pkt_bufid_p6     <= 9'b0;//release firstly when ack
                    o_pkt_bufid_wr_p6   <= 1'b0;
                    if(i_pkt_bufid_empty != 1'b1)begin
                        reg_bufid_ack_p6    <= 1'b0;
                        o_pkt_bufid_rd      <= 1'b1;//read FIFO once.
                        rd_valid[6]         <= 1'b1;//record of read
                        ov_address_read_state       <= wait_1s;
                        end
                    else begin
                        reg_bufid_ack_p6    <= 1'b1;
                        o_pkt_bufid_rd      <= 1'b0;//read FIFO once.
                        rd_valid[6]         <= 1'b0;//record of read
                        ov_address_read_state       <= rd_bufid_ch7_s;
                        end
                    end
                else begin
                    reg_bufid_ack_p6    <= reg_bufid_ack_p6;                
                    o_pkt_bufid_rd      <= 1'b0;
                    rd_valid[6]         <= 1'b0;
                    ov_pkt_bufid_p6     <= ov_pkt_bufid_p6;
                    o_pkt_bufid_wr_p6   <= o_pkt_bufid_wr_p6;
                    ov_address_read_state       <= rd_bufid_ch7_s;                  
                    end
                //ack7  
                if(i_pkt_bufid_ack_p7 == 1'b1) begin
                    reg_bufid_ack_p7    <= 1'b1;
                    ov_pkt_bufid_p7     <= 9'b0;
                    o_pkt_bufid_wr_p7   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p7    <= reg_bufid_ack_p7;
                    ov_pkt_bufid_p7     <= ov_pkt_bufid_p7;
                    o_pkt_bufid_wr_p7   <= o_pkt_bufid_wr_p7;
                    end
                //ack8  
                if(i_pkt_bufid_ack_p8 == 1'b1) begin
                    reg_bufid_ack_p8    <= 1'b1;
                    ov_pkt_bufid_p8     <= 9'b0;
                    o_pkt_bufid_wr_p8   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p8    <= reg_bufid_ack_p8;
                    ov_pkt_bufid_p8     <= ov_pkt_bufid_p8;
                    o_pkt_bufid_wr_p8   <= o_pkt_bufid_wr_p8;
                    end                 
                end
                
            rd_bufid_ch7_s:begin
                //ack0
                if(i_pkt_bufid_ack_p0 == 1'b1) begin
                    reg_bufid_ack_p0    <= 1'b1;
                    ov_pkt_bufid_p0     <= 9'b0;
                    o_pkt_bufid_wr_p0   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p0    <= reg_bufid_ack_p0;
                    ov_pkt_bufid_p0     <= ov_pkt_bufid_p0;
                    o_pkt_bufid_wr_p0   <= o_pkt_bufid_wr_p0;               
                    end
                //ack1
                if(i_pkt_bufid_ack_p1 == 1'b1) begin
                    reg_bufid_ack_p1    <= 1'b1;
                    ov_pkt_bufid_p1     <= 9'b0;
                    o_pkt_bufid_wr_p1   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p1    <= reg_bufid_ack_p1;
                    ov_pkt_bufid_p1     <= ov_pkt_bufid_p1;
                    o_pkt_bufid_wr_p1   <= o_pkt_bufid_wr_p1;               
                    end
                //ack2
                if(i_pkt_bufid_ack_p2 == 1'b1) begin
                    reg_bufid_ack_p2    <= 1'b1;
                    ov_pkt_bufid_p2     <= 9'b0;
                    o_pkt_bufid_wr_p2   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p2    <= reg_bufid_ack_p2;
                    ov_pkt_bufid_p2     <= ov_pkt_bufid_p2;
                    o_pkt_bufid_wr_p2   <= o_pkt_bufid_wr_p2;
                    end
                //ack3
                if(i_pkt_bufid_ack_p3 == 1'b1) begin
                    reg_bufid_ack_p3    <= 1'b1;
                    ov_pkt_bufid_p3     <= 9'b0;
                    o_pkt_bufid_wr_p3   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p3    <= reg_bufid_ack_p3;
                    ov_pkt_bufid_p3     <= ov_pkt_bufid_p3;
                    o_pkt_bufid_wr_p3   <= o_pkt_bufid_wr_p3;
                    end
                //ack4  
                if(i_pkt_bufid_ack_p4 == 1'b1) begin
                    reg_bufid_ack_p4    <= 1'b1;
                    ov_pkt_bufid_p4     <= 9'b0;
                    o_pkt_bufid_wr_p4   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p4    <= reg_bufid_ack_p4;
                    ov_pkt_bufid_p4     <= ov_pkt_bufid_p4;
                    o_pkt_bufid_wr_p4   <= o_pkt_bufid_wr_p4;
                    end
                //ack5
                if(i_pkt_bufid_ack_p5 == 1'b1) begin
                    reg_bufid_ack_p5    <= 1'b1;
                    ov_pkt_bufid_p5     <= 9'b0;
                    o_pkt_bufid_wr_p5   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p5    <= reg_bufid_ack_p5;
                    ov_pkt_bufid_p5     <= ov_pkt_bufid_p5;
                    o_pkt_bufid_wr_p5   <= o_pkt_bufid_wr_p5;
                    end
                //ack6
                if(rd_valid[6])begin
                    ov_pkt_bufid_p6     <= iv_pkt_bufid;//FIFO is in showhead mode and FIFO is based on RAM(outport with register),so data will delay 1 cycle.
                    o_pkt_bufid_wr_p6   <= 1'b1;
                    rd_valid[6]         <= 1'b0;                
                    end
                else if(i_pkt_bufid_ack_p6 == 1'b1) begin
                    reg_bufid_ack_p6    <= 1'b1;
                    ov_pkt_bufid_p6     <= 9'b0;
                    o_pkt_bufid_wr_p6   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p6    <= reg_bufid_ack_p6;
                    ov_pkt_bufid_p6     <= ov_pkt_bufid_p6;
                    o_pkt_bufid_wr_p6   <= o_pkt_bufid_wr_p6;               
                    end             
                //ack7  
                if((i_pkt_bufid_ack_p7 == 1'b1 ||reg_bufid_ack_p7 == 1'b1)) begin
                    ov_pkt_bufid_p7     <= 9'b0;//release firstly when ack
                    o_pkt_bufid_wr_p7   <= 1'b0;
                    if(i_pkt_bufid_empty != 1'b1)begin
                        reg_bufid_ack_p7    <= 1'b0;
                        o_pkt_bufid_rd      <= 1'b1;//read FIFO once.
                        rd_valid[7]         <= 1'b1;//record of read
                        ov_address_read_state       <= wait_1s;
                        end
                    else begin
                        reg_bufid_ack_p7    <= 1'b1;
                        o_pkt_bufid_rd      <= 1'b0;//read FIFO once.
                        rd_valid[7]         <= 1'b0;//record of read
                        ov_address_read_state       <= rd_bufid_ch8_s;
                        end
                    end
                else begin
                    reg_bufid_ack_p7    <= reg_bufid_ack_p7;                
                    o_pkt_bufid_rd      <= 1'b0;
                    rd_valid[7]         <= 1'b0;
                    ov_pkt_bufid_p7     <= ov_pkt_bufid_p7;
                    o_pkt_bufid_wr_p7   <= o_pkt_bufid_wr_p7;
                    ov_address_read_state       <= rd_bufid_ch8_s;                  
                    end
                //ack8  
                if(i_pkt_bufid_ack_p8 == 1'b1) begin
                    reg_bufid_ack_p8    <= 1'b1;
                    ov_pkt_bufid_p8     <= 9'b0;
                    o_pkt_bufid_wr_p8   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p8    <= reg_bufid_ack_p8;
                    ov_pkt_bufid_p8     <= ov_pkt_bufid_p8;
                    o_pkt_bufid_wr_p8   <= o_pkt_bufid_wr_p8;
                    end                 
                end
                
            rd_bufid_ch8_s:begin
                //ack0
                if(i_pkt_bufid_ack_p0 == 1'b1) begin
                    reg_bufid_ack_p0    <= 1'b1;
                    ov_pkt_bufid_p0     <= 9'b0;
                    o_pkt_bufid_wr_p0   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p0    <= reg_bufid_ack_p0;
                    ov_pkt_bufid_p0     <= ov_pkt_bufid_p0;
                    o_pkt_bufid_wr_p0   <= o_pkt_bufid_wr_p0;               
                    end
                //ack1
                if(i_pkt_bufid_ack_p1 == 1'b1) begin
                    reg_bufid_ack_p1    <= 1'b1;
                    ov_pkt_bufid_p1     <= 9'b0;
                    o_pkt_bufid_wr_p1   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p1    <= reg_bufid_ack_p1;
                    ov_pkt_bufid_p1     <= ov_pkt_bufid_p1;
                    o_pkt_bufid_wr_p1   <= o_pkt_bufid_wr_p1;               
                    end
                //ack2
                if(i_pkt_bufid_ack_p2 == 1'b1) begin
                    reg_bufid_ack_p2    <= 1'b1;
                    ov_pkt_bufid_p2     <= 9'b0;
                    o_pkt_bufid_wr_p2   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p2    <= reg_bufid_ack_p2;
                    ov_pkt_bufid_p2     <= ov_pkt_bufid_p2;
                    o_pkt_bufid_wr_p2   <= o_pkt_bufid_wr_p2;
                    end
                //ack3
                if(i_pkt_bufid_ack_p3 == 1'b1) begin
                    reg_bufid_ack_p3    <= 1'b1;
                    ov_pkt_bufid_p3     <= 9'b0;
                    o_pkt_bufid_wr_p3   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p3    <= reg_bufid_ack_p3;
                    ov_pkt_bufid_p3     <= ov_pkt_bufid_p3;
                    o_pkt_bufid_wr_p3   <= o_pkt_bufid_wr_p3;
                    end
                //ack4  
                if(i_pkt_bufid_ack_p4 == 1'b1) begin
                    reg_bufid_ack_p4    <= 1'b1;
                    ov_pkt_bufid_p4     <= 9'b0;
                    o_pkt_bufid_wr_p4   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p4    <= reg_bufid_ack_p4;
                    ov_pkt_bufid_p4     <= ov_pkt_bufid_p4;
                    o_pkt_bufid_wr_p4   <= o_pkt_bufid_wr_p4;
                    end
                //ack5
                if(i_pkt_bufid_ack_p5 == 1'b1) begin
                    reg_bufid_ack_p5    <= 1'b1;
                    ov_pkt_bufid_p5     <= 9'b0;
                    o_pkt_bufid_wr_p5   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p5    <= reg_bufid_ack_p5;
                    ov_pkt_bufid_p5     <= ov_pkt_bufid_p5;
                    o_pkt_bufid_wr_p5   <= o_pkt_bufid_wr_p5;
                    end
                //ack6
                if(i_pkt_bufid_ack_p6 == 1'b1) begin
                    reg_bufid_ack_p6    <= 1'b1;
                    ov_pkt_bufid_p6     <= 9'b0;
                    o_pkt_bufid_wr_p6   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p6    <= reg_bufid_ack_p6;
                    ov_pkt_bufid_p6     <= ov_pkt_bufid_p6;
                    o_pkt_bufid_wr_p6   <= o_pkt_bufid_wr_p6;
                    end         
                //ack7
                if(rd_valid[7])begin
                    ov_pkt_bufid_p7     <= iv_pkt_bufid;//FIFO is in showhead mode and FIFO is based on RAM(outport with register),so data will delay 1 cycle.
                    o_pkt_bufid_wr_p7   <= 1'b1;
                    rd_valid[7]         <= 1'b0;                
                    end
                else if(i_pkt_bufid_ack_p7 == 1'b1) begin
                    reg_bufid_ack_p7    <= 1'b1;
                    ov_pkt_bufid_p7     <= 9'b0;
                    o_pkt_bufid_wr_p7   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p7    <= reg_bufid_ack_p7;
                    ov_pkt_bufid_p7     <= ov_pkt_bufid_p7;
                    o_pkt_bufid_wr_p7   <= o_pkt_bufid_wr_p7;               
                    end
                //ack8  
                if((i_pkt_bufid_ack_p8 == 1'b1 ||reg_bufid_ack_p8 == 1'b1)) begin
                    ov_pkt_bufid_p8     <= 9'b0;//release firstly when ack
                    o_pkt_bufid_wr_p8   <= 1'b0;
                    if(i_pkt_bufid_empty != 1'b1)begin
                        reg_bufid_ack_p8    <= 1'b0;
                        o_pkt_bufid_rd      <= 1'b1;//read FIFO once.
                        rd_valid[8]         <= 1'b1;//record of read
                        ov_address_read_state       <= wait_1s;
                        end
                    else begin
                        reg_bufid_ack_p8    <= 1'b1;
                        o_pkt_bufid_rd      <= 1'b0;//read FIFO once.
                        rd_valid[8]         <= 1'b0;//record of read
                        ov_address_read_state       <= rd_bufid_ch0_s;
                        end
                    end
                else begin
                    reg_bufid_ack_p8    <= reg_bufid_ack_p8;                
                    o_pkt_bufid_rd      <= 1'b0;
                    rd_valid[8]         <= 1'b0;
                    ov_pkt_bufid_p8     <= ov_pkt_bufid_p8;
                    o_pkt_bufid_wr_p8   <= o_pkt_bufid_wr_p8;
                    ov_address_read_state       <= rd_bufid_ch0_s;                  
                    end                 
                end
                
            wait_1s:begin
                o_pkt_bufid_rd      <= 1'b0;//read FIFO once.
                if(rd_valid[0] == 1'b1) begin
                    ov_address_read_state       <= rd_bufid_ch1_s;
                    end
                else if(rd_valid[1] == 1'b1) begin
                    ov_address_read_state       <= rd_bufid_ch2_s;
                    end
                else if(rd_valid[2] == 1'b1) begin
                    ov_address_read_state       <= rd_bufid_ch3_s;
                    end
                else if(rd_valid[3] == 1'b1) begin
                    ov_address_read_state       <= rd_bufid_ch4_s;
                    end
                else if(rd_valid[4] == 1'b1) begin
                    ov_address_read_state       <= rd_bufid_ch5_s;
                    end
                else if(rd_valid[5] == 1'b1) begin
                    ov_address_read_state       <= rd_bufid_ch6_s;
                    end 
                else if(rd_valid[6] == 1'b1) begin
                    ov_address_read_state       <= rd_bufid_ch7_s;
                    end 
                else if(rd_valid[7] == 1'b1) begin
                    ov_address_read_state       <= rd_bufid_ch8_s;
                    end 
                else if(rd_valid[8] == 1'b1) begin
                    ov_address_read_state       <= rd_bufid_ch0_s;
                    end
                else begin
                    ov_address_read_state       <= rd_bufid_ch0_s;
                    end
                
                if(i_pkt_bufid_ack_p0 == 1'b1)begin
                    reg_bufid_ack_p0    <= 1'b1;
                    ov_pkt_bufid_p0     <= 9'b0;
                    o_pkt_bufid_wr_p0   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p0    <= reg_bufid_ack_p0;
                    ov_pkt_bufid_p0     <= ov_pkt_bufid_p0;
                    o_pkt_bufid_wr_p0   <= o_pkt_bufid_wr_p0;
                end
                
                if(i_pkt_bufid_ack_p1 == 1'b1)begin
                    reg_bufid_ack_p1    <= 1'b1;
                    ov_pkt_bufid_p1     <= 9'b0;
                    o_pkt_bufid_wr_p1   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p1    <= reg_bufid_ack_p1;
                    ov_pkt_bufid_p1     <= ov_pkt_bufid_p1;
                    o_pkt_bufid_wr_p1   <= o_pkt_bufid_wr_p1;
                end
                
                if(i_pkt_bufid_ack_p2 == 1'b1)begin
                    reg_bufid_ack_p2    <= 1'b1;
                    ov_pkt_bufid_p2     <= 9'b0;
                    o_pkt_bufid_wr_p2   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p2    <= reg_bufid_ack_p2;
                    ov_pkt_bufid_p2     <= ov_pkt_bufid_p2;
                    o_pkt_bufid_wr_p2   <= o_pkt_bufid_wr_p2;
                end
                
                if(i_pkt_bufid_ack_p3 == 1'b1)begin
                    reg_bufid_ack_p3    <= 1'b1;
                    ov_pkt_bufid_p3     <= 9'b0;
                    o_pkt_bufid_wr_p3   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p3    <= reg_bufid_ack_p3;
                    ov_pkt_bufid_p3     <= ov_pkt_bufid_p3;
                    o_pkt_bufid_wr_p3   <= o_pkt_bufid_wr_p3;
                end
                
                if(i_pkt_bufid_ack_p4 == 1'b1)begin
                    reg_bufid_ack_p4    <= 1'b1;
                    ov_pkt_bufid_p4     <= 9'b0;
                    o_pkt_bufid_wr_p4   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p4    <= reg_bufid_ack_p4;
                    ov_pkt_bufid_p4     <= ov_pkt_bufid_p4;
                    o_pkt_bufid_wr_p4   <= o_pkt_bufid_wr_p4;
                end
                
                if(i_pkt_bufid_ack_p5 == 1'b1)begin
                    reg_bufid_ack_p5    <= 1'b1;
                    ov_pkt_bufid_p5     <= 9'b0;
                    o_pkt_bufid_wr_p5   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p5    <= reg_bufid_ack_p5;
                    ov_pkt_bufid_p5     <= ov_pkt_bufid_p5;
                    o_pkt_bufid_wr_p5   <= o_pkt_bufid_wr_p5;
                end
                
                if(i_pkt_bufid_ack_p6 == 1'b1)begin
                    reg_bufid_ack_p6    <= 1'b1;
                    ov_pkt_bufid_p6     <= 9'b0;
                    o_pkt_bufid_wr_p6   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p6    <= reg_bufid_ack_p6;
                    ov_pkt_bufid_p6     <= ov_pkt_bufid_p6;
                    o_pkt_bufid_wr_p6   <= o_pkt_bufid_wr_p6;
                end
                
                if(i_pkt_bufid_ack_p7 == 1'b1)begin
                    reg_bufid_ack_p7    <= 1'b1;
                    ov_pkt_bufid_p7     <= 9'b0;
                    o_pkt_bufid_wr_p7   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p7    <= reg_bufid_ack_p7;
                    ov_pkt_bufid_p7     <= ov_pkt_bufid_p7;
                    o_pkt_bufid_wr_p7   <= o_pkt_bufid_wr_p7;
                end
                
                if(i_pkt_bufid_ack_p8 == 1'b1)begin
                    reg_bufid_ack_p8    <= 1'b1;
                    ov_pkt_bufid_p8     <= 9'b0;
                    o_pkt_bufid_wr_p8   <= 1'b0;
                    end
                else begin
                    reg_bufid_ack_p8    <= reg_bufid_ack_p8;
                    ov_pkt_bufid_p8     <= ov_pkt_bufid_p8;
                    o_pkt_bufid_wr_p8   <= o_pkt_bufid_wr_p8;
                end
                
            end
                
            default:begin
                ov_pkt_bufid_p0     <= 9'b0;
                o_pkt_bufid_wr_p0   <= 1'b0;
                ov_pkt_bufid_p1     <= 9'b0;
                o_pkt_bufid_wr_p1   <= 1'b0;        
                ov_pkt_bufid_p2     <= 9'b0;
                o_pkt_bufid_wr_p2   <= 1'b0;
                ov_pkt_bufid_p3     <= 9'b0;
                o_pkt_bufid_wr_p3   <= 1'b0;
                ov_pkt_bufid_p4     <= 9'b0;
                o_pkt_bufid_wr_p4   <= 1'b0;
                ov_pkt_bufid_p5     <= 9'b0;
                o_pkt_bufid_wr_p5   <= 1'b0;        
                ov_pkt_bufid_p6     <= 9'b0;
                o_pkt_bufid_wr_p6   <= 1'b0;
                ov_pkt_bufid_p7     <= 9'b0;
                o_pkt_bufid_wr_p7   <= 1'b0;
                ov_pkt_bufid_p8     <= 9'b0;
                o_pkt_bufid_wr_p8   <= 1'b0;
                o_pkt_bufid_rd      <= 1'b0;
                rd_valid            <= 9'b0;
                reg_bufid_ack_p0    <= 1'b0;
                reg_bufid_ack_p1    <= 1'b0;
                reg_bufid_ack_p2    <= 1'b0;
                reg_bufid_ack_p3    <= 1'b0;
                reg_bufid_ack_p4    <= 1'b0;
                reg_bufid_ack_p5    <= 1'b0;
                reg_bufid_ack_p6    <= 1'b0;
                reg_bufid_ack_p7    <= 1'b0;
                reg_bufid_ack_p8    <= 1'b0;        
                ov_address_read_state       <= rd_bufid_ch0_s;
                end             
            endcase
        end
    
endmodule
