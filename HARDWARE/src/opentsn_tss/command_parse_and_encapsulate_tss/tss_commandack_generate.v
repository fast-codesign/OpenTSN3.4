// Copyright (C) 1953-2022 NUDT
// Verilog module name - tss_commandack_generate
// Version: V3.4.0.20220225
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         Command ack generate 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tss_commandack_generate
    (
        i_clk,
        i_rst_n,          
        
        i_wr_ffi_p8,
        iv_addr_ffi_p8,
        i_addr_fixed_ffi_p8,
        iv_rdata_ffi_p8,
        
        i_wr_dex_p8,
        iv_addr_dex_p8,
        i_addr_fixed_dex_p8,
        iv_rdata_dex_p8,
        
        i_wr_ctx_p8,
        iv_addr_ctx_p8,
        i_addr_fixed_ctx_p8,
        iv_rdata_ctx_p8,
        
        i_wr_ffi_p0,
        iv_addr_ffi_p0,
        i_addr_fixed_ffi_p0,
        iv_rdata_ffi_p0,
        
        i_wr_dex_p0,
        iv_addr_dex_p0,
        i_addr_fixed_dex_p0,
        iv_rdata_dex_p0,
        
        i_wr_ctx_p0,
        iv_addr_ctx_p0,
        i_addr_fixed_ctx_p0,
        iv_rdata_ctx_p0,
        
        i_wr_ffi_p1,
        iv_addr_ffi_p1,
        i_addr_fixed_ffi_p1,
        iv_rdata_ffi_p1,
        
        i_wr_dex_p1,
        iv_addr_dex_p1,
        i_addr_fixed_dex_p1,
        iv_rdata_dex_p1,
        
        i_wr_ctx_p1,
        iv_addr_ctx_p1,
        i_addr_fixed_ctx_p1,
        iv_rdata_ctx_p1,
        
        i_wr_ffi_p2,
        iv_addr_ffi_p2,
        i_addr_fixed_ffi_p2,
        iv_rdata_ffi_p2,
        
        i_wr_dex_p2,
        iv_addr_dex_p2,
        i_addr_fixed_dex_p2,
        iv_rdata_dex_p2,
        
        i_wr_ctx_p2,
        iv_addr_ctx_p2,
        i_addr_fixed_ctx_p2,
        iv_rdata_ctx_p2,

        i_wr_ffi_p3,
        iv_addr_ffi_p3,
        i_addr_fixed_ffi_p3,
        iv_rdata_ffi_p3,
        
        i_wr_dex_p3,
        iv_addr_dex_p3,
        i_addr_fixed_dex_p3,
        iv_rdata_dex_p3,
        
        i_wr_ctx_p3,
        iv_addr_ctx_p3,
        i_addr_fixed_ctx_p3,
        iv_rdata_ctx_p3,
        
        i_wr_ffi_p4,
        iv_addr_ffi_p4,
        i_addr_fixed_ffi_p4,
        iv_rdata_ffi_p4,
        
        i_wr_dex_p4,
        iv_addr_dex_p4,
        i_addr_fixed_dex_p4,
        iv_rdata_dex_p4,
        
        i_wr_ctx_p4,
        iv_addr_ctx_p4,
        i_addr_fixed_ctx_p4,
        iv_rdata_ctx_p4,
        
        i_wr_ffi_p5,
        iv_addr_ffi_p5,
        i_addr_fixed_ffi_p5,
        iv_rdata_ffi_p5,
        
        i_wr_dex_p5,
        iv_addr_dex_p5,
        i_addr_fixed_dex_p5,
        iv_rdata_dex_p5,
        
        i_wr_ctx_p5,
        iv_addr_ctx_p5,
        i_addr_fixed_ctx_p5,
        iv_rdata_ctx_p5,
        
        i_wr_ffi_p6,
        iv_addr_ffi_p6,
        i_addr_fixed_ffi_p6,
        iv_rdata_ffi_p6,
        
        i_wr_dex_p6,
        iv_addr_dex_p6,
        i_addr_fixed_dex_p6,
        iv_rdata_dex_p6,
        
        i_wr_ctx_p6,
        iv_addr_ctx_p6,
        i_addr_fixed_ctx_p6,
        iv_rdata_ctx_p6,
        
        i_wr_ffi_p7,
        iv_addr_ffi_p7,
        i_addr_fixed_ffi_p7,
        iv_rdata_ffi_p7,
        
        i_wr_dex_p7,
        iv_addr_dex_p7,
        i_addr_fixed_dex_p7,
        iv_rdata_dex_p7,
        
        i_wr_ctx_p7,
        iv_addr_ctx_p7,
        i_addr_fixed_ctx_p7,
        iv_rdata_ctx_p7,
        
        i_wr_grm,
        iv_addr_grm,
        i_addr_fixed_grm,
        iv_rdata_grm,
        
        i_wr_pcb,
        iv_addr_pcb,
        i_addr_fixed_pcb,
        iv_rdata_pcb,
        
        i_wr_flt,
        iv_addr_flt,
        i_addr_fixed_flt,
        iv_rdata_flt,
        
        i_wr_qgc0,
        iv_addr_qgc0,
        i_addr_fixed_qgc0,
        iv_rdata_qgc0,
        
        i_wr_qgc1,
        iv_addr_qgc1,
        i_addr_fixed_qgc1,
        iv_rdata_qgc1,
        
        i_wr_qgc2,
        iv_addr_qgc2,
        i_addr_fixed_qgc2,
        iv_rdata_qgc2,
        
        i_wr_qgc3,
        iv_addr_qgc3,
        i_addr_fixed_qgc3,
        iv_rdata_qgc3,
        
        i_wr_qgc4,
        iv_addr_qgc4,
        i_addr_fixed_qgc4,
        iv_rdata_qgc4,
        
        i_wr_qgc5,
        iv_addr_qgc5,
        i_addr_fixed_qgc5,
        iv_rdata_qgc5,
        
        i_wr_qgc6,
        iv_addr_qgc6,
        i_addr_fixed_qgc6,
        iv_rdata_qgc6,
        
        i_wr_qgc7,
        iv_addr_qgc7,
        i_addr_fixed_qgc7,
        iv_rdata_qgc7,

        o_command_ack_wr,
        ov_command_ack          
    );

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
//from ffi_p8 
input                   i_wr_ffi_p8;
input        [18:0]     iv_addr_ffi_p8;
input                   i_addr_fixed_ffi_p8;
input        [31:0]     iv_rdata_ffi_p8;
//from dex_p8 
input                   i_wr_dex_p8;
input        [18:0]     iv_addr_dex_p8;
input                   i_addr_fixed_dex_p8;
input        [31:0]     iv_rdata_dex_p8;
//from ctx_p8 
input                   i_wr_ctx_p8;
input        [18:0]     iv_addr_ctx_p8;
input                   i_addr_fixed_ctx_p8;
input        [31:0]     iv_rdata_ctx_p8;
//from ffi_p0 
input                   i_wr_ffi_p0;
input        [18:0]     iv_addr_ffi_p0;
input                   i_addr_fixed_ffi_p0;
input        [31:0]     iv_rdata_ffi_p0;
//from dex_p0 
input                   i_wr_dex_p0;
input        [18:0]     iv_addr_dex_p0;
input                   i_addr_fixed_dex_p0;
input        [31:0]     iv_rdata_dex_p0;
//from ctx_p0 
input                   i_wr_ctx_p0;
input        [18:0]     iv_addr_ctx_p0;
input                   i_addr_fixed_ctx_p0;
input        [31:0]     iv_rdata_ctx_p0;
//from ffi_p1 
input                   i_wr_ffi_p1;
input        [18:0]     iv_addr_ffi_p1;
input                   i_addr_fixed_ffi_p1;
input        [31:0]     iv_rdata_ffi_p1;
//from dex_p1 
input                   i_wr_dex_p1;
input        [18:0]     iv_addr_dex_p1;
input                   i_addr_fixed_dex_p1;
input        [31:0]     iv_rdata_dex_p1;
//from ctx_p1 
input                   i_wr_ctx_p1;
input        [18:0]     iv_addr_ctx_p1;
input                   i_addr_fixed_ctx_p1;
input        [31:0]     iv_rdata_ctx_p1;
//from ffi_p2 
input                   i_wr_ffi_p2;
input        [18:0]     iv_addr_ffi_p2;
input                   i_addr_fixed_ffi_p2;
input        [31:0]     iv_rdata_ffi_p2;
//from dex_p2 
input                   i_wr_dex_p2;
input        [18:0]     iv_addr_dex_p2;
input                   i_addr_fixed_dex_p2;
input        [31:0]     iv_rdata_dex_p2;
//from ctx_p2 
input                   i_wr_ctx_p2;
input        [18:0]     iv_addr_ctx_p2;
input                   i_addr_fixed_ctx_p2;
input        [31:0]     iv_rdata_ctx_p2;
//from ffi_p3 
input                   i_wr_ffi_p3;
input        [18:0]     iv_addr_ffi_p3;
input                   i_addr_fixed_ffi_p3;
input        [31:0]     iv_rdata_ffi_p3;
//from dex_p3 
input                   i_wr_dex_p3;
input        [18:0]     iv_addr_dex_p3;
input                   i_addr_fixed_dex_p3;
input        [31:0]     iv_rdata_dex_p3;
//from ctx_p3 
input                   i_wr_ctx_p3;
input        [18:0]     iv_addr_ctx_p3;
input                   i_addr_fixed_ctx_p3;
input        [31:0]     iv_rdata_ctx_p3;
//from ffi_p4 
input                   i_wr_ffi_p4;
input        [18:0]     iv_addr_ffi_p4;
input                   i_addr_fixed_ffi_p4;
input        [31:0]     iv_rdata_ffi_p4;
//from dex_p4 
input                   i_wr_dex_p4;
input        [18:0]     iv_addr_dex_p4;
input                   i_addr_fixed_dex_p4;
input        [31:0]     iv_rdata_dex_p4;
//from ctx_p4 
input                   i_wr_ctx_p4;
input        [18:0]     iv_addr_ctx_p4;
input                   i_addr_fixed_ctx_p4;
input        [31:0]     iv_rdata_ctx_p4;
//from ffi_p5 
input                   i_wr_ffi_p5;
input        [18:0]     iv_addr_ffi_p5;
input                   i_addr_fixed_ffi_p5;
input        [31:0]     iv_rdata_ffi_p5;
//from dex_p5 
input                   i_wr_dex_p5;
input        [18:0]     iv_addr_dex_p5;
input                   i_addr_fixed_dex_p5;
input        [31:0]     iv_rdata_dex_p5;
//from ctx_p5 
input                   i_wr_ctx_p5;
input        [18:0]     iv_addr_ctx_p5;
input                   i_addr_fixed_ctx_p5;
input        [31:0]     iv_rdata_ctx_p5;
//from ffi_p6 
input                   i_wr_ffi_p6;
input        [18:0]     iv_addr_ffi_p6;
input                   i_addr_fixed_ffi_p6;
input        [31:0]     iv_rdata_ffi_p6;
//from dex_p6 
input                   i_wr_dex_p6;
input        [18:0]     iv_addr_dex_p6;
input                   i_addr_fixed_dex_p6;
input        [31:0]     iv_rdata_dex_p6;
//from ctx_p6 
input                   i_wr_ctx_p6;
input        [18:0]     iv_addr_ctx_p6;
input                   i_addr_fixed_ctx_p6;
input        [31:0]     iv_rdata_ctx_p6;
//from ffi_p7 
input                   i_wr_ffi_p7;
input        [18:0]     iv_addr_ffi_p7;
input                   i_addr_fixed_ffi_p7;
input        [31:0]     iv_rdata_ffi_p7;
//from dex_p7 
input                   i_wr_dex_p7;
input        [18:0]     iv_addr_dex_p7;
input                   i_addr_fixed_dex_p7;
input        [31:0]     iv_rdata_dex_p7;
//from ctx_p7 
input                   i_wr_ctx_p7;
input        [18:0]     iv_addr_ctx_p7;
input                   i_addr_fixed_ctx_p7;
input        [31:0]     iv_rdata_ctx_p7;
//from grm 
input                   i_wr_grm;
input        [18:0]     iv_addr_grm;
input                   i_addr_fixed_grm;
input        [31:0]     iv_rdata_grm;
//from pcb 
input                   i_wr_pcb;
input        [18:0]     iv_addr_pcb;
input                   i_addr_fixed_pcb;
input        [31:0]     iv_rdata_pcb;
//from flt 
input                   i_wr_flt;
input        [18:0]     iv_addr_flt;
input                   i_addr_fixed_flt;
input        [31:0]     iv_rdata_flt;
//from qgc 
input                   i_wr_qgc0;
input        [18:0]     iv_addr_qgc0;
input                   i_addr_fixed_qgc0;
input        [31:0]     iv_rdata_qgc0;

input                   i_wr_qgc1;
input        [18:0]     iv_addr_qgc1;
input                   i_addr_fixed_qgc1;
input        [31:0]     iv_rdata_qgc1;

input                   i_wr_qgc2;
input        [18:0]     iv_addr_qgc2;
input                   i_addr_fixed_qgc2;
input        [31:0]     iv_rdata_qgc2;

input                   i_wr_qgc3;
input        [18:0]     iv_addr_qgc3;
input                   i_addr_fixed_qgc3;
input        [31:0]     iv_rdata_qgc3;

input                   i_wr_qgc4;
input        [18:0]     iv_addr_qgc4;
input                   i_addr_fixed_qgc4;
input        [31:0]     iv_rdata_qgc4;

input                   i_wr_qgc5;
input        [18:0]     iv_addr_qgc5;
input                   i_addr_fixed_qgc5;
input        [31:0]     iv_rdata_qgc5;

input                   i_wr_qgc6;
input        [18:0]     iv_addr_qgc6;
input                   i_addr_fixed_qgc6;
input        [31:0]     iv_rdata_qgc6;

input                   i_wr_qgc7;
input        [18:0]     iv_addr_qgc7;
input                   i_addr_fixed_qgc7;
input        [31:0]     iv_rdata_qgc7;

output  reg             o_command_ack_wr;
output  reg  [63:0]     ov_command_ack; 
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        o_command_ack_wr     <= 1'b0;
        ov_command_ack       <= 64'b0;      
	end
    else begin
        ov_command_ack[63:62]       <= 2'h3;
        ov_command_ack[60:58]       <= 3'b0;//sw_id,end_id
        if(i_wr_ffi_p8 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ffi_p8;
            ov_command_ack[57:51]       <= 7'd0;//mid
            ov_command_ack[50:32]       <= iv_addr_ffi_p8;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ffi_p8;//rd data
            o_command_ack_wr            <= 1'b1;            
        end        
        else if(i_wr_dex_p8 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_dex_p8;
            ov_command_ack[57:51]       <= 7'd1;//mid
            ov_command_ack[50:32]       <= iv_addr_dex_p8;//maddr
            ov_command_ack[31:0]        <= iv_rdata_dex_p8;//rd data
            o_command_ack_wr            <= 1'b1;           
        end
        else if(i_wr_ctx_p8 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ctx_p8;
            ov_command_ack[57:51]       <= 7'd4;//mid
            ov_command_ack[50:32]       <= iv_addr_ctx_p8;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ctx_p8;//rd data
            o_command_ack_wr            <= 1'b1;           
        end

        else if(i_wr_ffi_p0 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ffi_p0;
            ov_command_ack[57:51]       <= 7'd8;//mid
            ov_command_ack[50:32]       <= iv_addr_ffi_p0;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ffi_p0;//rd data
            o_command_ack_wr            <= 1'b1;            
        end        
        else if(i_wr_dex_p0 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_dex_p0;
            ov_command_ack[57:51]       <= 7'd9;//mid
            ov_command_ack[50:32]       <= iv_addr_dex_p0;//maddr
            ov_command_ack[31:0]        <= iv_rdata_dex_p0;//rd data
            o_command_ack_wr            <= 1'b1;           
        end
        else if(i_wr_ctx_p0 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ctx_p0;
            ov_command_ack[57:51]       <= 7'd12;//mid
            ov_command_ack[50:32]       <= iv_addr_ctx_p0;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ctx_p0;//rd data
            o_command_ack_wr            <= 1'b1;           
        end

        else if(i_wr_ffi_p1 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ffi_p1;
            ov_command_ack[57:51]       <= 7'd16;//mid
            ov_command_ack[50:32]       <= iv_addr_ffi_p1;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ffi_p1;//rd data
            o_command_ack_wr            <= 1'b1;            
        end        
        else if(i_wr_dex_p1 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_dex_p1;
            ov_command_ack[57:51]       <= 7'd17;//mid
            ov_command_ack[50:32]       <= iv_addr_dex_p1;//maddr
            ov_command_ack[31:0]        <= iv_rdata_dex_p1;//rd data
            o_command_ack_wr            <= 1'b1;           
        end
        else if(i_wr_ctx_p1 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ctx_p1;
            ov_command_ack[57:51]       <= 7'd20;//mid
            ov_command_ack[50:32]       <= iv_addr_ctx_p1;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ctx_p1;//rd data
            o_command_ack_wr            <= 1'b1;           
        end

        else if(i_wr_ffi_p2 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ffi_p2;
            ov_command_ack[57:51]       <= 7'd24;//mid
            ov_command_ack[50:32]       <= iv_addr_ffi_p2;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ffi_p2;//rd data
            o_command_ack_wr            <= 1'b1;            
        end        
        else if(i_wr_dex_p2 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_dex_p2;
            ov_command_ack[57:51]       <= 7'd25;//mid
            ov_command_ack[50:32]       <= iv_addr_dex_p2;//maddr
            ov_command_ack[31:0]        <= iv_rdata_dex_p2;//rd data
            o_command_ack_wr            <= 1'b1;           
        end
        else if(i_wr_ctx_p2 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ctx_p2;
            ov_command_ack[57:51]       <= 7'd28;//mid
            ov_command_ack[50:32]       <= iv_addr_ctx_p2;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ctx_p2;//rd data
            o_command_ack_wr            <= 1'b1;           
        end

        else if(i_wr_ffi_p3 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ffi_p3;
            ov_command_ack[57:51]       <= 7'd32;//mid
            ov_command_ack[50:32]       <= iv_addr_ffi_p3;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ffi_p3;//rd data
            o_command_ack_wr            <= 1'b1;            
        end        
        else if(i_wr_dex_p3 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_dex_p3;
            ov_command_ack[57:51]       <= 7'd33;//mid
            ov_command_ack[50:32]       <= iv_addr_dex_p3;//maddr
            ov_command_ack[31:0]        <= iv_rdata_dex_p3;//rd data
            o_command_ack_wr            <= 1'b1;           
        end
        else if(i_wr_ctx_p3 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ctx_p3;
            ov_command_ack[57:51]       <= 7'd36;//mid
            ov_command_ack[50:32]       <= iv_addr_ctx_p3;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ctx_p3;//rd data
            o_command_ack_wr            <= 1'b1;           
        end

        else if(i_wr_ffi_p4 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ffi_p4;
            ov_command_ack[57:51]       <= 7'd40;//mid
            ov_command_ack[50:32]       <= iv_addr_ffi_p4;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ffi_p4;//rd data
            o_command_ack_wr            <= 1'b1;            
        end        
        else if(i_wr_dex_p4 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_dex_p4;
            ov_command_ack[57:51]       <= 7'd41;//mid
            ov_command_ack[50:32]       <= iv_addr_dex_p4;//maddr
            ov_command_ack[31:0]        <= iv_rdata_dex_p4;//rd data
            o_command_ack_wr            <= 1'b1;           
        end
        else if(i_wr_ctx_p4 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ctx_p4;
            ov_command_ack[57:51]       <= 7'd44;//mid
            ov_command_ack[50:32]       <= iv_addr_ctx_p4;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ctx_p4;//rd data
            o_command_ack_wr            <= 1'b1;           
        end

        else if(i_wr_ffi_p5 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ffi_p5;
            ov_command_ack[57:51]       <= 7'd48;//mid
            ov_command_ack[50:32]       <= iv_addr_ffi_p5;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ffi_p5;//rd data
            o_command_ack_wr            <= 1'b1;            
        end        
        else if(i_wr_dex_p5 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_dex_p5;
            ov_command_ack[57:51]       <= 7'd49;//mid
            ov_command_ack[50:32]       <= iv_addr_dex_p5;//maddr
            ov_command_ack[31:0]        <= iv_rdata_dex_p5;//rd data
            o_command_ack_wr            <= 1'b1;           
        end
        else if(i_wr_ctx_p5 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ctx_p5;
            ov_command_ack[57:51]       <= 7'd52;//mid
            ov_command_ack[50:32]       <= iv_addr_ctx_p5;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ctx_p5;//rd data
            o_command_ack_wr            <= 1'b1;           
        end

        else if(i_wr_ffi_p6 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ffi_p6;
            ov_command_ack[57:51]       <= 7'd56;//mid
            ov_command_ack[50:32]       <= iv_addr_ffi_p6;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ffi_p6;//rd data
            o_command_ack_wr            <= 1'b1;            
        end        
        else if(i_wr_dex_p6 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_dex_p6;
            ov_command_ack[57:51]       <= 7'd57;//mid
            ov_command_ack[50:32]       <= iv_addr_dex_p6;//maddr
            ov_command_ack[31:0]        <= iv_rdata_dex_p6;//rd data
            o_command_ack_wr            <= 1'b1;           
        end
        else if(i_wr_ctx_p6 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ctx_p6;
            ov_command_ack[57:51]       <= 7'd60;//mid
            ov_command_ack[50:32]       <= iv_addr_ctx_p6;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ctx_p6;//rd data
            o_command_ack_wr            <= 1'b1;           
        end 

        else if(i_wr_ffi_p7 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ffi_p7;
            ov_command_ack[57:51]       <= 7'd64;//mid
            ov_command_ack[50:32]       <= iv_addr_ffi_p7;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ffi_p7;//rd data
            o_command_ack_wr            <= 1'b1;            
        end        
        else if(i_wr_dex_p7 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_dex_p7;
            ov_command_ack[57:51]       <= 7'd65;//mid
            ov_command_ack[50:32]       <= iv_addr_dex_p7;//maddr
            ov_command_ack[31:0]        <= iv_rdata_dex_p7;//rd data
            o_command_ack_wr            <= 1'b1;           
        end
        else if(i_wr_ctx_p7 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_ctx_p7;
            ov_command_ack[57:51]       <= 7'd68;//mid
            ov_command_ack[50:32]       <= iv_addr_ctx_p7;//maddr
            ov_command_ack[31:0]        <= iv_rdata_ctx_p7;//rd data
            o_command_ack_wr            <= 1'b1;           
        end

        else if(i_wr_grm == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_grm;
            ov_command_ack[57:51]       <= 7'd122;//mid
            ov_command_ack[50:32]       <= iv_addr_grm;//maddr
            ov_command_ack[31:0]        <= iv_rdata_grm;//rd data
            o_command_ack_wr            <= 1'b1;           
        end 
        else if(i_wr_pcb == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_pcb;
            ov_command_ack[57:51]       <= 7'd121;//mid
            ov_command_ack[50:32]       <= iv_addr_pcb;//maddr
            ov_command_ack[31:0]        <= iv_rdata_pcb;//rd data
            o_command_ack_wr            <= 1'b1;           
        end
        else if(i_wr_flt == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_flt;
            ov_command_ack[57:51]       <= 7'd120;//mid
            ov_command_ack[50:32]       <= iv_addr_flt;//maddr
            ov_command_ack[31:0]        <= iv_rdata_flt;//rd data
            o_command_ack_wr            <= 1'b1;           
        end         
        else if(i_wr_qgc0 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_qgc0;
            ov_command_ack[57:51]       <= 7'd11;//mid
            ov_command_ack[50:32]       <= iv_addr_qgc0;//maddr
            ov_command_ack[31:0]        <= iv_rdata_qgc0;//rd data
            o_command_ack_wr            <= 1'b1;           
        end
        else if(i_wr_qgc1 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_qgc1;
            ov_command_ack[57:51]       <= 7'd19;//mid
            ov_command_ack[50:32]       <= iv_addr_qgc1;//maddr
            ov_command_ack[31:0]        <= iv_rdata_qgc1;//rd data
            o_command_ack_wr            <= 1'b1;           
        end
        else if(i_wr_qgc2 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_qgc2;
            ov_command_ack[57:51]       <= 7'd27;//mid
            ov_command_ack[50:32]       <= iv_addr_qgc2;//maddr
            ov_command_ack[31:0]        <= iv_rdata_qgc2;//rd data
            o_command_ack_wr            <= 1'b1;           
        end
        else if(i_wr_qgc3 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_qgc3;
            ov_command_ack[57:51]       <= 7'd35;//mid
            ov_command_ack[50:32]       <= iv_addr_qgc3;//maddr
            ov_command_ack[31:0]        <= iv_rdata_qgc3;//rd data
            o_command_ack_wr            <= 1'b1;           
        end 
        else if(i_wr_qgc4 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_qgc4;
            ov_command_ack[57:51]       <= 7'd43;//mid
            ov_command_ack[50:32]       <= iv_addr_qgc4;//maddr
            ov_command_ack[31:0]        <= iv_rdata_qgc4;//rd data
            o_command_ack_wr            <= 1'b1;           
        end 
        else if(i_wr_qgc5 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_qgc5;
            ov_command_ack[57:51]       <= 7'd51;//mid
            ov_command_ack[50:32]       <= iv_addr_qgc5;//maddr
            ov_command_ack[31:0]        <= iv_rdata_qgc5;//rd data
            o_command_ack_wr            <= 1'b1;           
        end 
        else if(i_wr_qgc6 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_qgc6;
            ov_command_ack[57:51]       <= 7'd59;//mid
            ov_command_ack[50:32]       <= iv_addr_qgc6;//maddr
            ov_command_ack[31:0]        <= iv_rdata_qgc6;//rd data
            o_command_ack_wr            <= 1'b1;           
        end 
        else if(i_wr_qgc7 == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_qgc7;
            ov_command_ack[57:51]       <= 7'd67;//mid
            ov_command_ack[50:32]       <= iv_addr_qgc7;//maddr
            ov_command_ack[31:0]        <= iv_rdata_qgc7;//rd data
            o_command_ack_wr            <= 1'b1;           
        end        
        else begin
            ov_command_ack              <= 64'b0;
            o_command_ack_wr            <= 1'b0;           
        end          
    end
end    
endmodule