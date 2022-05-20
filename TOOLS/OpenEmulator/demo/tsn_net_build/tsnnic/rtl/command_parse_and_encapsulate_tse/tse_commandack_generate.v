// Copyright (C) 1953-2022 NUDT
// Verilog module name - tse_commandack_generate
// Version: V3.4.0.20220225
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         Command ack generate 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tse_commandack_generate
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
        
        i_wr_frm,
        iv_addr_frm,
        i_addr_fixed_frm,
        iv_rdata_frm,
        
        i_wr_tic,
        iv_addr_tic,
        i_addr_fixed_tic,
        iv_rdata_tic,
        
        i_wr_grm,
        iv_addr_grm,
        i_addr_fixed_grm,
        iv_rdata_grm,
        
        i_wr_pcb,
        iv_addr_pcb,
        i_addr_fixed_pcb,
        iv_rdata_pcb,
        
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
        
        i_wr_fim,
        iv_addr_fim,
        i_addr_fixed_fim,
        iv_rdata_fim,       

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
input                   i_wr_frm;
input        [18:0]     iv_addr_frm;
input                   i_addr_fixed_frm;
input        [31:0]     iv_rdata_frm;
//from ctx_p3 
input                   i_wr_tic;
input        [18:0]     iv_addr_tic;
input                   i_addr_fixed_tic;
input        [31:0]     iv_rdata_tic;

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

input                   i_wr_fim;
input        [18:0]     iv_addr_fim;
input                   i_addr_fixed_fim;
input        [31:0]     iv_rdata_fim;

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
        else if(i_wr_frm == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_frm;
            ov_command_ack[57:51]       <= 7'd33;//mid
            ov_command_ack[50:32]       <= iv_addr_frm;//maddr
            ov_command_ack[31:0]        <= iv_rdata_frm;//rd data
            o_command_ack_wr            <= 1'b1;           
        end
        else if(i_wr_tic == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_tic;
            ov_command_ack[57:51]       <= 7'd34;//mid
            ov_command_ack[50:32]       <= iv_addr_tic;//maddr
            ov_command_ack[31:0]        <= iv_rdata_tic;//rd data
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
        else if(i_wr_fim == 1'b1)begin
            ov_command_ack[61]          <= i_addr_fixed_fim;
            ov_command_ack[57:51]       <= 7'd35;//mid
            ov_command_ack[50:32]       <= iv_addr_fim;//maddr
            ov_command_ack[31:0]        <= iv_rdata_fim;//rd data
            o_command_ack_wr            <= 1'b1;           
        end       
        else begin
            ov_command_ack              <= 64'b0;
            o_command_ack_wr            <= 1'b0;           
        end          
    end
end    
endmodule