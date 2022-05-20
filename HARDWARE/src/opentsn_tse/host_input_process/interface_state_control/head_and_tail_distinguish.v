// Copyright (C) 1953-2020 NUDT
// Verilog module name - head_and_tail_distinguish 
// Version: V3.4.0,20220224
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         GMII interface write
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module head_and_tail_distinguish
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
// data input
input                   i_data_wr;
input       [7:0]       iv_data;
// data output
output  reg [8:0]       ov_data;
output  reg             o_data_wr;

reg         [1:0]       rv_htd_state;
// internal reg&wire
reg                     rv_data_wr;//register gmii dv
reg         [7:0]       rv_data;//register gmii rx data
reg                     r_start_flag;//flag of frame head  
wire                    r_last_flag;//flag of frame end 
localparam  start_s     = 2'b00,
            trans_s     = 2'b01,
            full_error_s= 2'b10;
//Gemac_rx_register
always @(posedge i_clk) begin
        rv_data_wr     <= i_data_wr;
        rv_data        <= iv_data;
    end
//end signal judgment
assign r_last_flag = (rv_data_wr)&&(~i_data_wr);
//Gemac_rx_ctrl_state  
always@(posedge i_clk or negedge i_rst_n)
    if(!i_rst_n) begin
        ov_data             <= 9'b0;
        o_data_wr           <= 1'b0;
        r_start_flag        <= 1'b0;
        rv_htd_state        <= start_s;
    end
    else begin
        case(rv_htd_state)
            start_s:begin
                if(i_data_wr == 1'b1)begin//to ouput after 1 cycle delay,judge frame's head once more and make sure pkt is not empty.               
                    ov_data             <= 9'b0;
                    o_data_wr           <= 1'b0;                    
                    r_start_flag        <= 1'b1;                 
                    rv_htd_state        <= trans_s;
                end
                else begin
                    ov_data             <= 9'b0;
                    o_data_wr           <= 1'b0; 
                    
                    r_start_flag        <= 1'b0;                    
                    rv_htd_state        <= start_s;                                                  
                end
            end
            trans_s:begin
                r_start_flag        <= 1'b0;//release flag of frame head that can live 1 cycle.
                ov_data[7:0]        <= rv_data;
                o_data_wr           <= rv_data_wr;
                if(r_start_flag == 1'b1 && r_last_flag == 1'b0)begin
                    ov_data[8]          <= 1'b1;
                    rv_htd_state        <= trans_s;                 
                end
                else if(r_last_flag == 1'b1) begin
                    ov_data[8]          <= 1'b1;
                    rv_htd_state        <= start_s;
                end
                else begin
                    ov_data[8]          <= 1'b0;
                    rv_htd_state        <= trans_s;
                end
            end
            default:begin
                ov_data             <= 9'b0;
                o_data_wr           <= 1'b0;
                r_start_flag        <= 1'b0;
                rv_htd_state        <= start_s;             
            end
        endcase
    end
endmodule