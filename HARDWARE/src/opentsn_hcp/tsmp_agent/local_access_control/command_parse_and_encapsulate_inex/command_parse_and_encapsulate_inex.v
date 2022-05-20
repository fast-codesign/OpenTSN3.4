// Copyright (C) 1953-2022 NUDT
// Verilog module name - command_parse_and_encapsulate_inex 
// Version: V3.4.0.20220228
// Created:
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module command_parse_and_encapsulate_inex
(
       i_clk,
       i_rst_n,
       
       iv_command,
	   i_command_wr,    
       
       ov_hcp_command,
	   o_hcp_command_wr,

	   ov_tsstse_command_1  ,
	   o_tsstse_command_wr_1,	   			   
	   ov_tsstse_command_2  ,	   
	   o_tsstse_command_wr_2,	   	   	   
	   ov_tsstse_command_3  ,	   
	   o_tsstse_command_wr_3,	   
	   
       
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
input      [65:0]      iv_command;               
input                  i_command_wr;             

output     [63:0]	   ov_hcp_command;
output    	           o_hcp_command_wr;
          
output     [63:0]	   ov_tsstse_command_1  ;
output    	           o_tsstse_command_wr_1;
                       
output     [63:0]	   ov_tsstse_command_2  ;
output    	           o_tsstse_command_wr_2;
                       
output     [63:0]	   ov_tsstse_command_3  ;
output    	           o_tsstse_command_wr_3;

input      [63:0]      iv_command_from_interior;            
input                  i_command_wr_from_interior;           
input      [63:0]      iv_command_from_external_1;            
input                  i_command_wr_from_external_1;  
input      [63:0]      iv_command_from_external_2;            
input                  i_command_wr_from_external_2;  
input      [63:0]      iv_command_from_external_3;            
input                  i_command_wr_from_external_3;

output     [65:0]	   ov_command;
output     	           o_command_wr;
command_parse_inex command_parse_inex_inst
(
       .i_clk                       (i_clk              ),
       .i_rst_n                     (i_rst_n            ),

       .iv_command                  (iv_command         ),
	   .i_command_wr                (i_command_wr       ),    

       .ov_hcp_command              (ov_hcp_command     ),
	   .o_hcp_command_wr            (o_hcp_command_wr   ),

       .ov_tsstse_command_1         (ov_tsstse_command_1  ),
       .o_tsstse_command_wr_1       (o_tsstse_command_wr_1),
	                                 
       .ov_tsstse_command_2         (ov_tsstse_command_2  ),
       .o_tsstse_command_wr_2       (o_tsstse_command_wr_2),	   
	                                 
       .ov_tsstse_command_3         (ov_tsstse_command_3  ),
       .o_tsstse_command_wr_3       (o_tsstse_command_wr_3)	   
);
command_encapsulate_inex command_encapsulate_inex_inst
(
       .i_clk                           (i_clk                      ),
       .i_rst_n                         (i_rst_n                    ),

       .iv_command_from_interior        (iv_command_from_interior   ),  
	   .i_command_wr_from_interior      (i_command_wr_from_interior ),   
       .iv_command_from_external_1      (iv_command_from_external_1   ),   
       .i_command_wr_from_external_1    (i_command_wr_from_external_1 ), 
       .iv_command_from_external_2      (iv_command_from_external_2   ),   
       .i_command_wr_from_external_2    (i_command_wr_from_external_2 ), 
       .iv_command_from_external_3      (iv_command_from_external_3   ),   
       .i_command_wr_from_external_3    (i_command_wr_from_external_3 ), 	   
	   
       .ov_command                      (ov_command                 ),
       .o_command_wr                    (o_command_wr               )
);    
endmodule
    