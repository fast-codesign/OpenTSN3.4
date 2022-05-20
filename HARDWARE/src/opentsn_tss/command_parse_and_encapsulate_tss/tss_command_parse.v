// Copyright (C) 1953-2021 NUDT
// Verilog module name - tss_command_parse
// Version: V3.3.0.20211124
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         Command Parse
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tss_command_parse
    (
        i_clk,
        i_rst_n,
        
        iv_command  ,   
        i_command_wr,           
        
        ov_addr     ,
        ov_wdata    ,
        o_addr_fixed,

        o_wr_ffi_p8,
        o_rd_ffi_p8,
        o_wr_dex_p8,
        o_rd_dex_p8,
                   
        o_wr_ffi_p0,
        o_rd_ffi_p0,
        o_wr_dex_p0,
        o_rd_dex_p0,
                  
        o_wr_ffi_p1,
        o_rd_ffi_p1,
        o_wr_dex_p1,
        o_rd_dex_p1,
                   
        o_wr_ffi_p2,
        o_rd_ffi_p2,
        o_wr_dex_p2,
        o_rd_dex_p2,
                  
        o_wr_ffi_p3,
        o_rd_ffi_p3,
        o_wr_dex_p3,
        o_rd_dex_p3,
                   
        o_wr_ffi_p4,
        o_rd_ffi_p4,
        o_wr_dex_p4,
        o_rd_dex_p4,
               
        o_wr_ffi_p5,
        o_rd_ffi_p5,
        o_wr_dex_p5,
        o_rd_dex_p5,
                 
        o_wr_ffi_p6,
        o_rd_ffi_p6,
        o_wr_dex_p6,
        o_rd_dex_p6,
                  
        o_wr_ffi_p7,
        o_rd_ffi_p7,
        o_wr_dex_p7,
        o_rd_dex_p7,
    
        o_wr_grm   ,
        o_rd_grm   ,	
        
        o_wr_flt   ,
        o_rd_flt   ,
        
        o_wr_pcb   ,
        o_rd_pcb   ,
        
        o_wr_qgc0  ,
        o_rd_qgc0  ,
                   
        o_wr_qgc1  ,
        o_rd_qgc1  ,
                   
        o_wr_qgc2  ,
        o_rd_qgc2  ,
                   
        o_wr_qgc3  ,
        o_rd_qgc3  ,
                   
        o_wr_qgc4  ,
        o_rd_qgc4  ,
                   
        o_wr_qgc5  ,
        o_rd_qgc5  ,
                   
        o_wr_qgc6  ,
        o_rd_qgc6  ,
        
        o_wr_qgc7  ,
        o_rd_qgc7       
    );

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
           
input       [63:0]      iv_command;   
input                   i_command_wr;           
  
output  reg [18:0]      ov_addr;
output  reg [31:0]      ov_wdata;
output  reg             o_addr_fixed;
//to p8
output  reg             o_wr_ffi_p8;
output  reg             o_rd_ffi_p8;
output  reg             o_wr_dex_p8;
output  reg             o_rd_dex_p8;
//to p0
output  reg             o_wr_ffi_p0;
output  reg             o_rd_ffi_p0;
output  reg             o_wr_dex_p0;
output  reg             o_rd_dex_p0;
//to p1
output  reg             o_wr_ffi_p1;
output  reg             o_rd_ffi_p1;
output  reg             o_wr_dex_p1;
output  reg             o_rd_dex_p1;
//to p2
output  reg             o_wr_ffi_p2;
output  reg             o_rd_ffi_p2;
output  reg             o_wr_dex_p2;
output  reg             o_rd_dex_p2;
//to p3
output  reg             o_wr_ffi_p3;
output  reg             o_rd_ffi_p3;
output  reg             o_wr_dex_p3;
output  reg             o_rd_dex_p3;
//to p4
output  reg             o_wr_ffi_p4;
output  reg             o_rd_ffi_p4;
output  reg             o_wr_dex_p4;
output  reg             o_rd_dex_p4;
//to p5
output  reg             o_wr_ffi_p5;
output  reg             o_rd_ffi_p5;
output  reg             o_wr_dex_p5;
output  reg             o_rd_dex_p5;
//to p6
output  reg             o_wr_ffi_p6;
output  reg             o_rd_ffi_p6;
output  reg             o_wr_dex_p6;
output  reg             o_rd_dex_p6;
//to p7
output  reg             o_wr_ffi_p7;
output  reg             o_rd_ffi_p7;
output  reg             o_wr_dex_p7;
output  reg             o_rd_dex_p7;								
//to grm 
output  reg             o_wr_grm;
output  reg             o_rd_grm;	
//to flt 
output  reg             o_wr_flt;
output  reg             o_rd_flt;
//to pcb 
output  reg             o_wr_pcb;
output  reg             o_rd_pcb;
//to qgc 
output  reg             o_wr_qgc0;
output  reg             o_rd_qgc0;

output  reg             o_wr_qgc1;
output  reg             o_rd_qgc1;

output  reg             o_wr_qgc2;
output  reg             o_rd_qgc2;

output  reg             o_wr_qgc3;
output  reg             o_rd_qgc3;

output  reg             o_wr_qgc4;
output  reg             o_rd_qgc4;

output  reg             o_wr_qgc5;
output  reg             o_rd_qgc5;

output  reg             o_wr_qgc6;
output  reg             o_rd_qgc6;

output  reg             o_wr_qgc7;
output  reg             o_rd_qgc7;
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
		ov_addr                   <= 19'b0;
        ov_wdata                  <= 32'b0;
        o_addr_fixed              <= 1'b0;

        o_wr_ffi_p8               <= 1'b0;
        o_rd_ffi_p8               <= 1'b0;
        o_wr_dex_p8               <= 1'b0;
        o_rd_dex_p8               <= 1'b0;
               
        o_wr_ffi_p0               <= 1'b0;
        o_rd_ffi_p0               <= 1'b0;
        o_wr_dex_p0               <= 1'b0;
        o_rd_dex_p0               <= 1'b0;
                 
        o_wr_ffi_p1               <= 1'b0;
        o_rd_ffi_p1               <= 1'b0;
        o_wr_dex_p1               <= 1'b0;
        o_rd_dex_p1               <= 1'b0;
              
        o_wr_ffi_p2               <= 1'b0;
        o_rd_ffi_p2               <= 1'b0;
        o_wr_dex_p2               <= 1'b0;
        o_rd_dex_p2               <= 1'b0;
               
        o_wr_ffi_p3               <= 1'b0;
        o_rd_ffi_p3               <= 1'b0;
        o_wr_dex_p3               <= 1'b0;
        o_rd_dex_p3               <= 1'b0;
                
        o_wr_ffi_p4               <= 1'b0;
        o_rd_ffi_p4               <= 1'b0;
        o_wr_dex_p4               <= 1'b0;
        o_rd_dex_p4               <= 1'b0;
               
        o_wr_ffi_p5               <= 1'b0;
        o_rd_ffi_p5               <= 1'b0;
        o_wr_dex_p5               <= 1'b0;
        o_rd_dex_p5               <= 1'b0;
              
        o_wr_ffi_p6               <= 1'b0;
        o_rd_ffi_p6               <= 1'b0;
        o_wr_dex_p6               <= 1'b0;
        o_rd_dex_p6               <= 1'b0;
                    
        o_wr_ffi_p7               <= 1'b0;
        o_rd_ffi_p7               <= 1'b0;
        o_wr_dex_p7               <= 1'b0;
        o_rd_dex_p7               <= 1'b0;

        o_wr_grm                  <= 1'b0 ;
        o_rd_grm                  <= 1'b0 ;
        o_wr_flt                  <= 1'b0 ;
        o_rd_flt                  <= 1'b0 ;
        o_wr_pcb                  <= 1'b0 ;
        o_rd_pcb                  <= 1'b0 ;
        o_wr_qgc0                 <= 1'b0 ;
        o_rd_qgc0                 <= 1'b0 ;
        o_wr_qgc1                 <= 1'b0 ;
        o_rd_qgc1                 <= 1'b0 ;
        o_wr_qgc2                 <= 1'b0 ;
        o_rd_qgc2                 <= 1'b0 ;
        o_wr_qgc3                 <= 1'b0 ;
        o_rd_qgc3                 <= 1'b0 ;
        o_wr_qgc4                 <= 1'b0 ;
        o_rd_qgc4                 <= 1'b0 ;
        o_wr_qgc5                 <= 1'b0 ;
        o_rd_qgc5                 <= 1'b0 ;
        o_wr_qgc6                 <= 1'b0 ;
        o_rd_qgc6                 <= 1'b0 ;
        o_wr_qgc7                 <= 1'b0 ;
        o_rd_qgc7                 <= 1'b0 ;        
	end
    else begin
        if(i_command_wr == 1'b1)begin
            ov_addr          <= iv_command[50:32];
            ov_wdata         <= iv_command[31:0];
            o_addr_fixed     <= iv_command[61];            
            if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd0))begin//ffi of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_ffi_p8            <= 1'b1;
                    o_rd_ffi_p8            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_ffi_p8            <= 1'b0;
                    o_rd_ffi_p8            <= 1'b1;
                end
                else begin
                    o_wr_ffi_p8            <= 1'b0;
                    o_rd_ffi_p8            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd1))begin//dex of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_dex_p8            <= 1'b1;
                    o_rd_dex_p8            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_dex_p8            <= 1'b0;
                    o_rd_dex_p8            <= 1'b1;
                end
                else begin
                    o_wr_dex_p8            <= 1'b0;
                    o_rd_dex_p8            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd8))begin//ffi of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_ffi_p0            <= 1'b1;
                    o_rd_ffi_p0            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_ffi_p0            <= 1'b0;
                    o_rd_ffi_p0            <= 1'b1;
                end
                else begin
                    o_wr_ffi_p0            <= 1'b0;
                    o_rd_ffi_p0            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd9))begin//dex of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_dex_p0            <= 1'b1;
                    o_rd_dex_p0            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_dex_p0            <= 1'b0;
                    o_rd_dex_p0            <= 1'b1;
                end
                else begin
                    o_wr_dex_p0            <= 1'b0;
                    o_rd_dex_p0            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd16))begin//ffi of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_ffi_p1            <= 1'b1;
                    o_rd_ffi_p1            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_ffi_p1            <= 1'b0;
                    o_rd_ffi_p1            <= 1'b1;
                end
                else begin
                    o_wr_ffi_p1            <= 1'b0;
                    o_rd_ffi_p1            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd17))begin//dex of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_dex_p1            <= 1'b1;
                    o_rd_dex_p1            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_dex_p1            <= 1'b0;
                    o_rd_dex_p1            <= 1'b1;
                end
                else begin
                    o_wr_dex_p1            <= 1'b0;
                    o_rd_dex_p1            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd24))begin//ffi of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_ffi_p2            <= 1'b1;
                    o_rd_ffi_p2            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_ffi_p2            <= 1'b0;
                    o_rd_ffi_p2            <= 1'b1;
                end
                else begin
                    o_wr_ffi_p2            <= 1'b0;
                    o_rd_ffi_p2            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd25))begin//dex of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_dex_p2            <= 1'b1;
                    o_rd_dex_p2            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_dex_p2            <= 1'b0;
                    o_rd_dex_p2            <= 1'b1;
                end
                else begin
                    o_wr_dex_p2            <= 1'b0;
                    o_rd_dex_p2            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd32))begin//ffi of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_ffi_p3            <= 1'b1;
                    o_rd_ffi_p3            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_ffi_p3            <= 1'b0;
                    o_rd_ffi_p3            <= 1'b1;
                end
                else begin
                    o_wr_ffi_p3            <= 1'b0;
                    o_rd_ffi_p3            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd33))begin//dex of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_dex_p3            <= 1'b1;
                    o_rd_dex_p3            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_dex_p3            <= 1'b0;
                    o_rd_dex_p3            <= 1'b1;
                end
                else begin
                    o_wr_dex_p3            <= 1'b0;
                    o_rd_dex_p3            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd40))begin//ffi of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_ffi_p4            <= 1'b1;
                    o_rd_ffi_p4            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_ffi_p4            <= 1'b0;
                    o_rd_ffi_p4            <= 1'b1;
                end
                else begin
                    o_wr_ffi_p4            <= 1'b0;
                    o_rd_ffi_p4            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd41))begin//dex of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_dex_p4            <= 1'b1;
                    o_rd_dex_p4            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_dex_p4            <= 1'b0;
                    o_rd_dex_p4            <= 1'b1;
                end
                else begin
                    o_wr_dex_p4            <= 1'b0;
                    o_rd_dex_p4            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd48))begin//ffi of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_ffi_p5            <= 1'b1;
                    o_rd_ffi_p5            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_ffi_p5            <= 1'b0;
                    o_rd_ffi_p5            <= 1'b1;
                end
                else begin
                    o_wr_ffi_p5            <= 1'b0;
                    o_rd_ffi_p5            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd49))begin//dex of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_dex_p5            <= 1'b1;
                    o_rd_dex_p5            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_dex_p5            <= 1'b0;
                    o_rd_dex_p5            <= 1'b1;
                end
                else begin
                    o_wr_dex_p5            <= 1'b0;
                    o_rd_dex_p5            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd56))begin//ffi of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_ffi_p6            <= 1'b1;
                    o_rd_ffi_p6            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_ffi_p6            <= 1'b0;
                    o_rd_ffi_p6            <= 1'b1;
                end
                else begin
                    o_wr_ffi_p6            <= 1'b0;
                    o_rd_ffi_p6            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd57))begin//dex of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_dex_p6            <= 1'b1;
                    o_rd_dex_p6            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_dex_p6            <= 1'b0;
                    o_rd_dex_p6            <= 1'b1;
                end
                else begin
                    o_wr_dex_p6            <= 1'b0;
                    o_rd_dex_p6            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd64))begin//ffi of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_ffi_p7            <= 1'b1;
                    o_rd_ffi_p7            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_ffi_p7            <= 1'b0;
                    o_rd_ffi_p7            <= 1'b1;
                end
                else begin
                    o_wr_ffi_p7            <= 1'b0;
                    o_rd_ffi_p7            <= 1'b0;
                end                    
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd65))begin//dex of ctrl port
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_dex_p7            <= 1'b1;
                    o_rd_dex_p7            <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_dex_p7            <= 1'b0;
                    o_rd_dex_p7            <= 1'b1;
                end
                else begin
                    o_wr_dex_p7            <= 1'b0;
                    o_rd_dex_p7            <= 1'b0;
                end                    
            end            
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd121))begin//pcb
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_pcb             <= 1'b0;
                    o_rd_pcb             <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_pcb             <= 1'b0;
                    o_rd_pcb             <= 1'b1;
                end
                else begin
                    o_wr_pcb             <= 1'b0;
                    o_rd_pcb             <= 1'b0;
                end                                   
            end
            else if(((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd122))||((iv_command[61] == 1'h0) && (iv_command[57:51] == 7'd122)))begin//grm
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_grm             <= 1'b1;
                    o_rd_grm             <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_grm             <= 1'b0;
                    o_rd_grm             <= 1'b1;
                end
                else begin
                    o_wr_grm             <= 1'b0;
                    o_rd_grm             <= 1'b0;
                end                                   
            end            
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd120))begin//flowid forward table of forward lookup table.
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_flt             <= 1'b1;
                    o_rd_flt             <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_flt             <= 1'b0;
                    o_rd_flt             <= 1'b1;
                end
                else begin
                    o_wr_flt             <= 1'b0;
                    o_rd_flt             <= 1'b0;
                end                    
            end
            
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd11))begin//gqc_p0
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_qgc0             <= 1'b1;
                    o_rd_qgc0             <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_qgc0             <= 1'b0;
                    o_rd_qgc0             <= 1'b1;
                end
                else begin
                    o_wr_qgc0             <= 1'b0;
                    o_rd_qgc0             <= 1'b0;
                end                                     
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd19))begin//gqc_p1
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_qgc1             <= 1'b1;
                    o_rd_qgc1             <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_qgc1             <= 1'b0;
                    o_rd_qgc1             <= 1'b1;
                end
                else begin
                    o_wr_qgc1             <= 1'b0;
                    o_rd_qgc1             <= 1'b0;
                end           
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd27))begin//gqc_p2
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_qgc2             <= 1'b1;
                    o_rd_qgc2             <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_qgc2             <= 1'b0;
                    o_rd_qgc2             <= 1'b1;
                end
                else begin
                    o_wr_qgc2             <= 1'b0;
                    o_rd_qgc2             <= 1'b0;
                end          
            end 
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd35))begin//gqc_p3
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_qgc3             <= 1'b1;
                    o_rd_qgc3             <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_qgc3             <= 1'b0;
                    o_rd_qgc3             <= 1'b1;
                end
                else begin
                    o_wr_qgc3             <= 1'b0;
                    o_rd_qgc3             <= 1'b0;
                end                
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd43))begin//gqc_p4
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_qgc4             <= 1'b1;
                    o_rd_qgc4             <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_qgc4             <= 1'b0;
                    o_rd_qgc4             <= 1'b1;
                end
                else begin
                    o_wr_qgc4             <= 1'b0;
                    o_rd_qgc4             <= 1'b0;
                end                
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd51))begin//gqc_p5
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_qgc5             <= 1'b1;
                    o_rd_qgc5             <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_qgc5             <= 1'b0;
                    o_rd_qgc5             <= 1'b1;
                end
                else begin
                    o_wr_qgc5             <= 1'b0;
                    o_rd_qgc5             <= 1'b0;
                end
            end 
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd59))begin//gqc_p6
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_qgc6             <= 1'b1;
                    o_rd_qgc6             <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_qgc6             <= 1'b0;
                    o_rd_qgc6             <= 1'b1;
                end
                else begin
                    o_wr_qgc6             <= 1'b0;
                    o_rd_qgc6             <= 1'b0;
                end             
            end
            else if((iv_command[61] == 1'h1) && (iv_command[57:51] == 7'd67))begin//gqc_p7
                if(iv_command[63:62] == 2'b00)begin//write
                    o_wr_qgc7             <= 1'b1;
                    o_rd_qgc7             <= 1'b0;
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_wr_qgc7             <= 1'b0;
                    o_rd_qgc7             <= 1'b1;
                end
                else begin
                    o_wr_qgc7             <= 1'b0;
                    o_rd_qgc7             <= 1'b0;
                end     
            end            
            else begin
                o_wr_ffi_p8               <= 1'b0;
                o_rd_ffi_p8               <= 1'b0;
                o_wr_dex_p8               <= 1'b0;
                o_rd_dex_p8               <= 1'b0;
                       
                o_wr_ffi_p0               <= 1'b0;
                o_rd_ffi_p0               <= 1'b0;
                o_wr_dex_p0               <= 1'b0;
                o_rd_dex_p0               <= 1'b0;
                         
                o_wr_ffi_p1               <= 1'b0;
                o_rd_ffi_p1               <= 1'b0;
                o_wr_dex_p1               <= 1'b0;
                o_rd_dex_p1               <= 1'b0;
                      
                o_wr_ffi_p2               <= 1'b0;
                o_rd_ffi_p2               <= 1'b0;
                o_wr_dex_p2               <= 1'b0;
                o_rd_dex_p2               <= 1'b0;
                       
                o_wr_ffi_p3               <= 1'b0;
                o_rd_ffi_p3               <= 1'b0;
                o_wr_dex_p3               <= 1'b0;
                o_rd_dex_p3               <= 1'b0;
                        
                o_wr_ffi_p4               <= 1'b0;
                o_rd_ffi_p4               <= 1'b0;
                o_wr_dex_p4               <= 1'b0;
                o_rd_dex_p4               <= 1'b0;
                       
                o_wr_ffi_p5               <= 1'b0;
                o_rd_ffi_p5               <= 1'b0;
                o_wr_dex_p5               <= 1'b0;
                o_rd_dex_p5               <= 1'b0;
                      
                o_wr_ffi_p6               <= 1'b0;
                o_rd_ffi_p6               <= 1'b0;
                o_wr_dex_p6               <= 1'b0;
                o_rd_dex_p6               <= 1'b0;
                            
                o_wr_ffi_p7               <= 1'b0;
                o_rd_ffi_p7               <= 1'b0;
                o_wr_dex_p7               <= 1'b0;
                o_rd_dex_p7               <= 1'b0;

                o_wr_grm                  <= 1'b0 ;
                o_rd_grm                  <= 1'b0 ;
                o_wr_flt                  <= 1'b0 ;
                o_rd_flt                  <= 1'b0 ;
                o_wr_pcb                  <= 1'b0 ;
                o_rd_pcb                  <= 1'b0 ;
                o_wr_qgc0                 <= 1'b0 ;
                o_rd_qgc0                 <= 1'b0 ;
                o_wr_qgc1                 <= 1'b0 ;
                o_rd_qgc1                 <= 1'b0 ;
                o_wr_qgc2                 <= 1'b0 ;
                o_rd_qgc2                 <= 1'b0 ;
                o_wr_qgc3                 <= 1'b0 ;
                o_rd_qgc3                 <= 1'b0 ;
                o_wr_qgc4                 <= 1'b0 ;
                o_rd_qgc4                 <= 1'b0 ;
                o_wr_qgc5                 <= 1'b0 ;
                o_rd_qgc5                 <= 1'b0 ;
                o_wr_qgc6                 <= 1'b0 ;
                o_rd_qgc6                 <= 1'b0 ;
                o_wr_qgc7                 <= 1'b0 ;
                o_rd_qgc7                 <= 1'b0 ;         
            end                
        end
        else begin
            ov_addr                   <= 19'b0;
            ov_wdata                  <= 32'b0;
        
            o_wr_ffi_p8               <= 1'b0;
            o_rd_ffi_p8               <= 1'b0;
            o_wr_dex_p8               <= 1'b0;
            o_rd_dex_p8               <= 1'b0;
                   
            o_wr_ffi_p0               <= 1'b0;
            o_rd_ffi_p0               <= 1'b0;
            o_wr_dex_p0               <= 1'b0;
            o_rd_dex_p0               <= 1'b0;
                     
            o_wr_ffi_p1               <= 1'b0;
            o_rd_ffi_p1               <= 1'b0;
            o_wr_dex_p1               <= 1'b0;
            o_rd_dex_p1               <= 1'b0;
                  
            o_wr_ffi_p2               <= 1'b0;
            o_rd_ffi_p2               <= 1'b0;
            o_wr_dex_p2               <= 1'b0;
            o_rd_dex_p2               <= 1'b0;
                   
            o_wr_ffi_p3               <= 1'b0;
            o_rd_ffi_p3               <= 1'b0;
            o_wr_dex_p3               <= 1'b0;
            o_rd_dex_p3               <= 1'b0;
                    
            o_wr_ffi_p4               <= 1'b0;
            o_rd_ffi_p4               <= 1'b0;
            o_wr_dex_p4               <= 1'b0;
            o_rd_dex_p4               <= 1'b0;
                   
            o_wr_ffi_p5               <= 1'b0;
            o_rd_ffi_p5               <= 1'b0;
            o_wr_dex_p5               <= 1'b0;
            o_rd_dex_p5               <= 1'b0;
                  
            o_wr_ffi_p6               <= 1'b0;
            o_rd_ffi_p6               <= 1'b0;
            o_wr_dex_p6               <= 1'b0;
            o_rd_dex_p6               <= 1'b0;
                        
            o_wr_ffi_p7               <= 1'b0;
            o_rd_ffi_p7               <= 1'b0;
            o_wr_dex_p7               <= 1'b0;
            o_rd_dex_p7               <= 1'b0;

            o_wr_grm                  <= 1'b0 ;
            o_rd_grm                  <= 1'b0 ;
            o_wr_flt                  <= 1'b0 ;
            o_rd_flt                  <= 1'b0 ;
            o_wr_pcb                  <= 1'b0 ;
            o_rd_pcb                  <= 1'b0 ;
            o_wr_qgc0                 <= 1'b0 ;
            o_rd_qgc0                 <= 1'b0 ;
            o_wr_qgc1                 <= 1'b0 ;
            o_rd_qgc1                 <= 1'b0 ;
            o_wr_qgc2                 <= 1'b0 ;
            o_rd_qgc2                 <= 1'b0 ;
            o_wr_qgc3                 <= 1'b0 ;
            o_rd_qgc3                 <= 1'b0 ;
            o_wr_qgc4                 <= 1'b0 ;
            o_rd_qgc4                 <= 1'b0 ;
            o_wr_qgc5                 <= 1'b0 ;
            o_rd_qgc5                 <= 1'b0 ;
            o_wr_qgc6                 <= 1'b0 ;
            o_rd_qgc6                 <= 1'b0 ;
            o_wr_qgc7                 <= 1'b0 ;
            o_rd_qgc7                 <= 1'b0 ;                        
        end
    end
end    
endmodule