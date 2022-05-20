// Copyright (C) 1953-2022 NUDT
// Verilog module name - interface_switch_2to1
// Version: V3.4.0.20220223
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         select control_interface or network_interface.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module interface_switch_2to1
(
        i_clk,
        i_rst_n,
        
        i_interface_type,
              
        iv_data_ctrl,
        i_data_wr_ctrl,
        iv_data_network,
        i_data_wr_network,        
       
        ov_data,
        o_data_wr 
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
//interface type
input                  i_interface_type;       //0:network_interface; 1:ctrl_interface
//receive pkt
input      [7:0]       iv_data_ctrl;
input                  i_data_wr_ctrl;
input      [7:0]       iv_data_network;
input                  i_data_wr_network;
//send pkt 
output reg [7:0]       ov_data;
output reg             o_data_wr;
////////////////////////////////////////
//        interface_switch            //
////////////////////////////////////////
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)begin
        ov_data <= 8'b0;
        o_data_wr <= 1'b0;
    end
    else begin
        if(i_interface_type == 1'b0)begin //network_interface
            ov_data           <= iv_data_network;
            o_data_wr         <= i_data_wr_network;  
        end
        else begin //ctrl_interface
            ov_data           <= iv_data_ctrl;
            o_data_wr         <= i_data_wr_ctrl;  
        end
    end
end
endmodule