// Copyright (C) 1953-2022 NUDT
// Verilog module name - command_parse_and_encapsulate_cc 
// Version: V3.4.0.20220226
// Created:
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module command_parse_and_encapsulate_cc
(
        i_clk  ,
        i_rst_n,

        i_wr_cc,
        iv_wdata_cc,
        iv_addr_cc,
        i_addr_fixed_cc,        
        i_rd_cc,
       
        o_wr_cc, 
        ov_rdata_cc,
        ov_raddr_cc,
        o_addr_fixed_cc,
        
        ov_cycle_length, 
        ov_oper_base		
);
// I/O
// i_clk & rst
input                  i_clk       ;
input                  i_rst_n     ;

input                  i_wr_cc    ;
input      [31:0]      iv_wdata_cc;
input      [18:0]      iv_addr_cc ; 
input                  i_addr_fixed_cc;        
input                  i_rd_cc    ;
output reg             o_wr_cc    ; 
output reg [31:0]      ov_rdata_cc;  
output reg [18:0]      ov_raddr_cc;
output reg             o_addr_fixed_cc;  

output reg [31:0]      ov_cycle_length             ; 
output reg [63:0]      ov_oper_base                ;
//***************************************************
//               command parse
//***************************************************
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin       
        o_wr_cc              <= 1'b0 ;
        ov_rdata_cc          <= 32'b0;
        ov_raddr_cc          <= 19'b0;
        o_addr_fixed_cc      <= 1'b0 ;
        
        ov_cycle_length       <= 32'd100000;  
		ov_oper_base          <= 64'd60000000000; 
    end
    else begin
        if(i_wr_cc)begin
            o_wr_cc          <= 1'b0;
            ov_rdata_cc      <= 32'b0;
            ov_raddr_cc      <= 19'b0;
            if((!i_addr_fixed_cc) && (iv_addr_cc == 19'd2))begin
                ov_cycle_length              <= iv_wdata_cc;
            end
            else if ((!i_addr_fixed_cc) && (iv_addr_cc == 19'd1))begin		
                ov_oper_base[31:0]                 <=	iv_wdata_cc;
            end				
            else if ((!i_addr_fixed_cc) && (iv_addr_cc == 19'd0))begin		
                ov_oper_base[63:32]                <=	iv_wdata_cc;
            end  			
            else begin
                ov_cycle_length              <= ov_cycle_length; 
				ov_oper_base                 <= ov_oper_base;
            end
        end      
        else if(i_rd_cc)begin
            if((!i_addr_fixed_cc) && (iv_addr_cc == 19'd2))begin
                o_wr_cc          <= 1'b1;
                ov_rdata_cc      <= ov_cycle_length;
                ov_raddr_cc      <= iv_addr_cc;
                o_addr_fixed_cc  <= i_addr_fixed_cc;            
            end
			else if((!i_addr_fixed_cc) && (iv_addr_cc == 19'd1))begin
                o_wr_cc          <= 1'b1;
                ov_rdata_cc      <= ov_oper_base[31:0];
                ov_raddr_cc      <= iv_addr_cc;
                o_addr_fixed_cc  <= i_addr_fixed_cc;
			end
			else if((!i_addr_fixed_cc) && (iv_addr_cc == 19'd0))begin
                o_wr_cc          <= 1'b1;
                ov_rdata_cc      <= ov_oper_base[63:32];
                ov_raddr_cc      <= iv_addr_cc;
                o_addr_fixed_cc  <= i_addr_fixed_cc;
			end
            else begin
                o_wr_cc          <= 1'b0;
                ov_rdata_cc      <= 32'b0;
                ov_raddr_cc      <= 19'b0;
                o_addr_fixed_cc  <= 1'b0;
            end            
        end
        else begin
            ov_cycle_length             <= ov_cycle_length; 
            ov_oper_base                <= ov_oper_base;   
            o_wr_cc                     <= 1'b0;
            ov_rdata_cc                 <= 32'b0;
            ov_raddr_cc                 <= 19'b0;
            o_addr_fixed_cc             <= 1'b0;          
        end
    end
end    
endmodule
    