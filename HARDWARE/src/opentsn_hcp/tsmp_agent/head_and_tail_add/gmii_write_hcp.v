// Copyright (C) 1953-2022 NUDT
// Verilog module name - gmii_write_hcp 
// Version: V3.4.0.20220228
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         GMII interface write
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module gmii_write_hcp
(
        i_gmii_rxclk,
        reset_n,

        i_gmii_dv,
        iv_gmii_rxd,
        i_gmii_er,     

        ov_data,
        o_data_wr,
        i_data_full,
        o_gmii_er,
        o_fifo_overflow_pulse
);

// I/O
// clk & rst
input                   reset_n;
// GMII input
input                   i_gmii_rxclk;
input                   i_gmii_dv;
input       [7:0]       iv_gmii_rxd;
input                   i_gmii_er;
// fifo wr
output  reg [8:0]       ov_data;
output  reg             o_data_wr;
input                   i_data_full;
output                  o_gmii_er;
output  reg             o_fifo_overflow_pulse;
assign                  o_gmii_er = i_gmii_er;
reg         [1:0]       rv_gmii_write_hcp_state;
// internal reg&wire
reg                     r_gmii_dv;//register gmii dv
reg         [7:0]       rv_gmii_rxd;//register gmii rx data
reg                     r_start_flag;//flag of frame head  
wire                    w_last_flag;//flag of frame end 
localparam  start_s     = 2'b00,
            trans_s     = 2'b01,
            full_error_s= 2'b10;
//Gemac_rx_register
always @(posedge i_gmii_rxclk) begin
        r_gmii_dv     <= i_gmii_dv;
        rv_gmii_rxd    <= iv_gmii_rxd;
    end
//end signal judgment
assign w_last_flag = (r_gmii_dv)&&(~i_gmii_dv);
//Gemac_rx_ctrl_state  
always@(posedge i_gmii_rxclk or negedge reset_n)
    if(!reset_n) begin
        ov_data             <= 9'b0;
        o_data_wr           <= 1'b0;
        r_start_flag          <= 1'b0;
        o_fifo_overflow_pulse <= 1'b0;
        rv_gmii_write_hcp_state        <= start_s;
    end
    else begin
        case(rv_gmii_write_hcp_state)
            start_s:begin
                if(i_gmii_dv == 1'b1)begin//to ouput after 1 cycle delay,judge frame's head once more and make sure pkt is not empty.               
                    ov_data             <= 9'b0;
                    o_data_wr           <= 1'b0;                    
                    r_start_flag          <= 1'b1; 
                    o_fifo_overflow_pulse <= 1'b0;                    
                    rv_gmii_write_hcp_state        <= trans_s;
                end
                else begin
                    r_start_flag          <= 1'b0;                    
                    rv_gmii_write_hcp_state        <= start_s;                    
                    if(i_data_full == 1'b1)begin//when the last cycle of front pkt output,fifo is full.
                        o_fifo_overflow_pulse <= 1'b1;
                        ov_data             <= {1'b1,8'b0};
                        o_data_wr           <= 1'b1;                    
                    end
                    else begin
                        o_fifo_overflow_pulse <= 1'b0;
                        ov_data             <= 9'b0;
                        o_data_wr           <= 1'b0;                     
                    end                     
                end
            end
            trans_s:begin
                r_start_flag          <= 1'b0;//release flag of frame head that can live 1 cycle.
                if(i_data_full == 1'b0)begin//when fifo is not full,data can be writed into fifo
                    ov_data[7:0]        <= rv_gmii_rxd;
                    o_data_wr           <= r_gmii_dv;
                    o_fifo_overflow_pulse <= 1'b0;
                    if(r_start_flag == 1'b1 && w_last_flag == 1'b0)begin
                        ov_data[8]          <= 1'b1;
                        rv_gmii_write_hcp_state        <= trans_s;                 
                    end
                    else if(w_last_flag == 1'b1) begin
                        ov_data[8]          <= 1'b1;
                        rv_gmii_write_hcp_state        <= start_s;
                    end
                    else begin
                        ov_data[8]          <= 1'b0;
                        rv_gmii_write_hcp_state        <= trans_s;
                    end
                end         
                else begin                  //when fifo is full,data can not be writed into fifo
                    o_fifo_overflow_pulse <= 1'b1;                
                    if(w_last_flag == 1'b1)begin
                        ov_data             <= {1'b1,rv_gmii_rxd};
                        o_data_wr           <= 1'b1;
                        rv_gmii_write_hcp_state    <= start_s;
                    end
                    else begin
                        ov_data             <= {1'b0,rv_gmii_rxd};
                        o_data_wr           <= 1'b1;
                        rv_gmii_write_hcp_state    <= full_error_s;                    
                    end
                end
            end
            full_error_s:begin
                r_start_flag          <= 1'b0;
                o_fifo_overflow_pulse <= 1'b0;
                if(i_gmii_dv == 1'b1)begin                  
                    ov_data         <= {1'b0,rv_gmii_rxd};
                    o_data_wr       <= 1'b1;
                    rv_gmii_write_hcp_state<= full_error_s;
                end
                else begin//when fifo is full,write last flag to fifo.
                    ov_data             <= {1'b1,rv_gmii_rxd};
                    o_data_wr           <= 1'b1;                
                    rv_gmii_write_hcp_state        <= start_s;
                end                                     
            end
            default:begin
                ov_data             <= 9'b0;
                o_data_wr           <= 1'b0;
                r_start_flag          <= 1'b0;
                o_fifo_overflow_pulse <= 1'b0;
                rv_gmii_write_hcp_state        <= start_s;             
            end
        endcase
    end
endmodule