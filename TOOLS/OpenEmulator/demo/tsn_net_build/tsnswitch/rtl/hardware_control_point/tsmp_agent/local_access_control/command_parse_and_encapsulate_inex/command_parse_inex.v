// Copyright (C) 1953-2022 NUDT
// Verilog module name - command_parse_inex 
// Version: V3.4.0.20220228
// Created:
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module command_parse_inex
(
       i_clk,
       i_rst_n,
       
       iv_command,
	   i_command_wr,    
       
       ov_hcp_command,
	   o_hcp_command_wr,

       ov_tsstse_command_1,
       o_tsstse_command_wr_1,
	   
       ov_tsstse_command_2,
       o_tsstse_command_wr_2,

       ov_tsstse_command_3,
       o_tsstse_command_wr_3	   
);


// I/O
// i_clk & rst
input                  i_clk;
input                  i_rst_n;
       
//nmac data
input      [65:0]      iv_command;               // input nmac data
input                  i_command_wr;             // nmac writer signals

output reg [63:0]	   ov_hcp_command;
output reg	           o_hcp_command_wr;

output reg [63:0]	   ov_tsstse_command_1   ;
output reg	           o_tsstse_command_wr_1 ;
                                             
output reg [63:0]	   ov_tsstse_command_2   ;
output reg	           o_tsstse_command_wr_2 ;
                                             
output reg [63:0]	   ov_tsstse_command_3   ;
output reg	           o_tsstse_command_wr_3 ;
//////////////////////////////////////////////////
//                  state                       //
//////////////////////////////////////////////////
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_hcp_command         <= 64'b0;
        o_hcp_command_wr       <= 1'b0;
		
		ov_tsstse_command_1    <= 64'b0;
        o_tsstse_command_wr_1  <= 1'b0;  
				
		ov_tsstse_command_2    <= 64'b0;
        o_tsstse_command_wr_2  <= 1'b0;  
		
		ov_tsstse_command_3    <= 64'b0;
        o_tsstse_command_wr_3  <= 1'b0;        
    end
    else begin
        if(i_command_wr && (iv_command[63:62] == 2'b11))begin//tss or tse
            ov_hcp_command         <= 64'b0;
            o_hcp_command_wr       <= 1'b0;
			
			ov_tsstse_command_1    <= 64'b0;
			o_tsstse_command_wr_1  <= 1'b0;  
					
			ov_tsstse_command_2    <= 64'b0;
			o_tsstse_command_wr_2  <= 1'b0; 			
            
            ov_tsstse_command_3    <= {iv_command[65:64],iv_command[61:0]};
            o_tsstse_command_wr_3  <= 1'b1;
        end
        else if(i_command_wr && (iv_command[63:62] == 2'b10))begin//hcp
            ov_hcp_command         <= 64'b0;
            o_hcp_command_wr       <= 1'b0;
			
			ov_tsstse_command_1    <= 64'b0;
			o_tsstse_command_wr_1  <= 1'b0;  
					
			ov_tsstse_command_2    <= {iv_command[65:64],iv_command[61:0]};
			o_tsstse_command_wr_2  <= 1'b1;			
            
            ov_tsstse_command_3    <= 64'b0;
            o_tsstse_command_wr_3  <= 1'b0; 
        end   
        else if(i_command_wr && (iv_command[63:62] == 2'b01))begin//hcp
            ov_hcp_command         <= 64'b0;
            o_hcp_command_wr       <= 1'b0;
			
			ov_tsstse_command_1    <= {iv_command[65:64],iv_command[61:0]};
			o_tsstse_command_wr_1  <= 1'b1;			 
					
			ov_tsstse_command_2    <= 64'b0;
			o_tsstse_command_wr_2  <= 1'b0; 
            
            ov_tsstse_command_3    <= 64'b0;
            o_tsstse_command_wr_3  <= 1'b0; 
        end   
        else if(i_command_wr && (iv_command[63:62] == 2'b00))begin//hcp
            ov_hcp_command         <= {iv_command[65:64],iv_command[61:0]};
            o_hcp_command_wr       <= 1'b1;  
			
			ov_tsstse_command_1    <= 64'b0;
			o_tsstse_command_wr_1  <= 1'b0; 
					
			ov_tsstse_command_2    <= 64'b0;
			o_tsstse_command_wr_2  <= 1'b0; 
            
            ov_tsstse_command_3    <= 64'b0;
            o_tsstse_command_wr_3  <= 1'b0; 
        end        
        else begin
            ov_hcp_command         <= 64'b0;
            o_hcp_command_wr        <= 1'b0;
            
			ov_tsstse_command_1    <= 64'b0;
			o_tsstse_command_wr_1  <= 1'b0; 
					
			ov_tsstse_command_2    <= 64'b0;
			o_tsstse_command_wr_2  <= 1'b0; 
            
            ov_tsstse_command_3    <= 64'b0;
            o_tsstse_command_wr_3  <= 1'b0;       
        end
    end
end    
endmodule
    