// Copyright (C) 1953-2022 NUDT
// Verilog module name - head_and_tail_add 
// Version: V3.4.1.20220406
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         GMII interface write
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module head_and_tail_add
(
        i_clk,
        i_rst_n,

        i_data_wr,
        iv_data,

        ov_data,
        o_data_wr
);

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
// pkt input
input                   i_data_wr;
input       [7:0]       iv_data;
// fifo wr
output  reg [8:0]       ov_data;
output  reg             o_data_wr;

reg         [1:0]       rv_hta_state;
// internal reg&wire
reg                     r_data_dv;//register data valid
reg         [7:0]       rv_data;//register data
reg                     r_start_flag;//flag of frame head  
wire                    w_last_flag;//flag of frame end 
localparam  start_s     = 2'b00,
            trans_s     = 2'b01;
//delay 1 cycle.
always @(posedge i_clk) begin
        r_data_dv     <= i_data_wr;
        rv_data       <= iv_data;
    end
//end signal judgment
assign w_last_flag = (r_data_dv)&&(~i_data_wr);
 
always@(posedge i_clk or negedge i_rst_n)
    if(!i_rst_n) begin
        ov_data             <= 9'b0;
        o_data_wr           <= 1'b0;
        r_start_flag        <= 1'b0;
        rv_hta_state        <= start_s;
    end
    else begin
        case(rv_hta_state)
            start_s:begin
                if(i_data_wr == 1'b1)begin//to ouput after 1 cycle delay,judge frame's head once more and make sure pkt is not empty.               
                    ov_data             <= 9'b0;
                    o_data_wr           <= 1'b0;                    
                    r_start_flag        <= 1'b1;                    
                    rv_hta_state        <= trans_s;
                end
                else begin                 
                    ov_data             <= 9'b0;
                    o_data_wr           <= 1'b0; 
                    r_start_flag        <= 1'b0;                    
                    rv_hta_state        <= start_s;                       
                end
            end
            trans_s:begin
                r_start_flag          <= 1'b0;//release flag of frame head that can live 1 cycle.
                ov_data[7:0]          <= rv_data;
                o_data_wr             <= r_data_dv;
                if(r_start_flag == 1'b1 && w_last_flag == 1'b0)begin
                    ov_data[8]          <= 1'b1;
                    rv_hta_state        <= trans_s;                 
                end
                else if(w_last_flag == 1'b1) begin
                    ov_data[8]          <= 1'b1;
                    rv_hta_state        <= start_s;
                end
                else begin
                    ov_data[8]          <= 1'b0;
                    rv_hta_state        <= trans_s;
                end       
            end
            default:begin
                ov_data             <= 9'b0;
                o_data_wr           <= 1'b0;
                r_start_flag        <= 1'b0;
                rv_hta_state        <= start_s;             
            end
        endcase
    end
endmodule