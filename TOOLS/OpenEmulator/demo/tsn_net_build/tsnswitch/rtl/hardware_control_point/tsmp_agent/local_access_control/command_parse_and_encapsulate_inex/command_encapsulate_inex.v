// Copyright (C) 1953-2022 NUDT
// Verilog module name - command_encapsulate_inex 
// Version: V3.4.0.20220228
// Created:
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module command_encapsulate_inex
(
       i_clk,
       i_rst_n,
       
       iv_command_from_interior,  
	   i_command_wr_from_interior,   
       iv_command_from_external_1  ,   
       i_command_wr_from_external_1, 
	   iv_command_from_external_2  ,   
       i_command_wr_from_external_2, 
	   iv_command_from_external_3  ,   
       i_command_wr_from_external_3, 

       ov_command,
       o_command_wr
);
// I/O
// i_clk & rst
input                  i_clk;
input                  i_rst_n; 
//nmac data
input      [63:0]      iv_command_from_interior;            
input                  i_command_wr_from_interior;           
input      [63:0]      iv_command_from_external_1;            
input                  i_command_wr_from_external_1;  
input      [63:0]      iv_command_from_external_2;            
input                  i_command_wr_from_external_2;  
input      [63:0]      iv_command_from_external_3;            
input                  i_command_wr_from_external_3;  

output reg [65:0]	   ov_command;
output reg	           o_command_wr;
//////////////////////////////////////////////////
//                  state                       //
//////////////////////////////////////////////////
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_command         <= 66'b0;
        o_command_wr       <= 1'b0;     
    end
    else begin
        if(i_command_wr_from_external_3)begin
            ov_command          <= {iv_command_from_external_3[63:62],2'b11,iv_command_from_external_3[61:0]};
            o_command_wr        <= 1'b1;  
        end
        else if(i_command_wr_from_external_2)begin
            ov_command          <= {iv_command_from_external_2[63:62],2'b10,iv_command_from_external_2[61:0]};
            o_command_wr        <= 1'b1;  
        end      
        else if(i_command_wr_from_external_1)begin
            ov_command          <= {iv_command_from_external_1[63:62],2'b01,iv_command_from_external_1[61:0]};
            o_command_wr        <= 1'b1;  
        end      
        else if(i_command_wr_from_interior)begin
            ov_command          <= {iv_command_from_interior[63:62],2'b00,iv_command_from_interior[61:0]};
            o_command_wr        <= 1'b1;  
        end        
        else begin
            ov_command         <= 66'b0;
            o_command_wr       <= 1'b0;         
        end
    end
end    
endmodule
    