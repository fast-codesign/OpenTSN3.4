// Copyright (C) 1953-2022 NUDT
// Verilog module name - opensync_correctionfield_update
// Version: V3.4.0.20220224
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         opensync correctionfield update
///////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module opensync_correctionfield_update
(
        i_clk,
        i_rst_n,
        
        iv_addr,                         
        i_addr_fixed,                   
        iv_wdata,                        
        i_wr,         
        i_rd,         
        
        o_wr,          
        ov_addr,       
        o_addr_fixed,  
        ov_rdata,
        
        i_tsn_or_tte,
              
        iv_data,
        i_data_wr,
        
        iv_receive_time,
        i_cf_update_flag,       
        iv_local_time,      
            
        ov_data,
        o_data_wr       
);

// I/O
// clk & rst
input                   i_clk;                   //125Mhz
input                   i_rst_n;
//cmd
input       [18:0]      iv_addr;                         
input                   i_addr_fixed;                   
input       [31:0]      iv_wdata;                        
input                   i_wr;         
input                   i_rd;         

output                  o_wr;          
output     [18:0]       ov_addr;       
output                  o_addr_fixed;  
output     [31:0]       ov_rdata;

input                   i_tsn_or_tte;
//local time
input      [63:0]       iv_receive_time;
input      [63:0]       iv_local_time;

input                   i_cf_update_flag; 
//receive data
input      [7:0]        iv_data;
input                   i_data_wr;
// send pkt    
output     [7:0]        ov_data;
output                  o_data_wr;


wire                    w_tsn_or_tte_cpe2rtc;
command_parse_and_encapsulate_cfu command_parse_and_encapsulate_cfu_inst
(
        .i_clk            (i_clk                ),
        .i_rst_n          (i_rst_n              ),
                                                
        .iv_addr          (iv_addr              ),                         
        .i_addr_fixed     (i_addr_fixed         ),                   
        .iv_wdata         (iv_wdata             ),                        
        .i_wr             (i_wr                 ),         
        .i_rd             (i_rd                 ),         
                                                
        .o_wr             (o_wr                 ),          
        .ov_addr          (ov_addr              ),       
        .o_addr_fixed     (o_addr_fixed         ),  
        .ov_rdata         (ov_rdata             ),
                                    
        .o_tsn_or_tte     (w_tsn_or_tte_cpe2rtc )        
);
residence_time_calculate residence_time_calculate_inst
(
        .i_clk                (i_clk                  ),
        .i_rst_n              (i_rst_n                ),
                                                      
        .iv_data              (iv_data                ),
        .i_data_wr            (i_data_wr              ),
                                                      
        .iv_receive_time      (iv_receive_time        ),
        .i_cf_update_flag     (i_cf_update_flag       ),
        .iv_local_time        (iv_local_time          ),
        .i_tsn_or_tte         (i_tsn_or_tte           ),//(w_tsn_or_tte_cpe2rtc   ),      
                                                      
        .ov_data              (ov_data                ),
        .o_data_wr            (o_data_wr              )       
);
endmodule 