// Copyright (C) 1953-2022 NUDT
// Verilog module name - interface_switch_1to2
// Version: V3.4.0.20220223
// Created:
//         by - fenglin 
//         at - 02.2022
////////////////////////////////////////////////////////////////////////////
// Description:
//         select control_interface or network_interface.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module interface_switch_1to2
(
        i_clk,
        i_rst_n,
        
        i_interface_type,
              
        iv_data,
        i_data_wr,
       
        ov_data_ctrl,
        o_data_wr_ctrl,
        ov_data_network,
        o_data_wr_network   
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
//interface type
input                  i_interface_type;       //0:network_interface; 1:ctrl_interface
//receive pkt
input      [7:0]       iv_data;
input                  i_data_wr;
//send pkt 
output reg [7:0]       ov_data_ctrl;
output reg             o_data_wr_ctrl;
output reg [7:0]       ov_data_network;
output reg             o_data_wr_network;
////////////////////////////////////////
//        interface_switch            //
////////////////////////////////////////
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)begin
        ov_data_ctrl <= 8'b0;
        o_data_wr_ctrl <= 1'b0;
        
        ov_data_network <= 8'b0;
        o_data_wr_network <= 1'b0;        
    end
    else begin
        if(i_interface_type == 1'b0)begin //network_interface
            ov_data_ctrl <= 8'b0;
            o_data_wr_ctrl <= 1'b0;
            
            ov_data_network <= iv_data;
            o_data_wr_network <= i_data_wr;  
        end
        else begin //ctrl_interface
            ov_data_ctrl <= iv_data;
            o_data_wr_ctrl <= i_data_wr;
            
            ov_data_network <= 8'b0;
            o_data_wr_network <= 1'b0; 
        end
    end
end
endmodule