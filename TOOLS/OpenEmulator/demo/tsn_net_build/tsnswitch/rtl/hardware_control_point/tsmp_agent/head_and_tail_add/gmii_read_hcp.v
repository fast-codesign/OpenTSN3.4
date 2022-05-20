// Copyright (C) 1953-2020 NUDT
// Verilog module name - gmii_read_hcp
// Version: GRD_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         GMII interface Read
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module gmii_read_hcp
(
        i_clk,
        i_rst_n,
        
        iv_data,
        o_data_rd,
        i_data_empty,
        iv_timer,     

        ov_data,
        o_data_wr,
        ov_rec_ts,

        o_pkt_valid_pulse,
        o_fifo_underflow_pulse
);

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
// fifo read
output  reg             o_data_rd;
input       [8:0]       iv_data;
input                   i_data_empty;
//timer
input       [18:0]      iv_timer;
// data output
output  reg [8:0]       ov_data;
output  reg             o_data_wr;
output  reg [18:0]      ov_rec_ts;

output  reg             o_pkt_valid_pulse;// receiced pkt's count pulse signal
output  reg             o_fifo_underflow_pulse;
reg         [1:0]       rv_delay_cycle;
reg         [2:0]       gmii_read_hcp_state;
// internal reg&wire
localparam  idle_s      = 3'd0,
            head_s      = 3'd1,
            tran_s      = 3'd2,
            discard_s   = 3'd3,
            rdempty_error_s = 3'd4;
            
always@(posedge i_clk or negedge i_rst_n)
    if(!i_rst_n) begin
        ov_data         <= 9'b0;
        o_data_wr       <= 1'b0;
        ov_rec_ts       <= 19'b0;
        o_data_rd       <= 1'b0;
        rv_delay_cycle     <= 2'b0;
        o_pkt_valid_pulse   <= 1'b0;
        o_fifo_underflow_pulse <= 1'b0;
        gmii_read_hcp_state <= idle_s;
        end
    else begin
        case(gmii_read_hcp_state)
            idle_s:begin
                ov_data             <= 9'b0;
                o_data_wr           <= 1'b0;
                o_pkt_valid_pulse   <= 1'b0;
                o_fifo_underflow_pulse <= 1'b0;
                if(i_data_empty == 1'b0)begin
                    if(rv_delay_cycle == 2'h3)begin 
                        o_data_rd <= 1'b1;
                        rv_delay_cycle <= 2'h0;
                        gmii_read_hcp_state <= head_s;
                    end
                    else if(rv_delay_cycle == 2'h2)begin
                        o_data_rd <= 1'b1;//FIFO in show head mode
                        rv_delay_cycle <= rv_delay_cycle + 1'b1;
                        gmii_read_hcp_state <= idle_s;
                    end
                    else begin
                        o_data_rd           <= 1'b0;
                        rv_delay_cycle <= rv_delay_cycle + 1'b1;
                        gmii_read_hcp_state <= idle_s;
                    end                    
                    end
                else begin
                    o_data_rd       <= 1'b0;    
                    rv_delay_cycle     <= 2'h0;                    
                    gmii_read_hcp_state <= idle_s;
                    end
                end
            head_s:begin
                o_fifo_underflow_pulse <= 1'b0;
                if(iv_data[8] == 1'b1 && i_data_empty == 1'b0) begin//judge frame head,and make sure pkt body is not empty.
                    ov_data             <= iv_data;
                    o_data_wr           <= 1'b1;
                    ov_rec_ts           <= iv_timer;
                    o_data_rd           <= 1'b1;
                    gmii_read_hcp_state     <= tran_s;
                end
                else begin
                    ov_rec_ts           <= 19'b0;
                    ov_data             <= 9'b0;
                    o_data_wr           <= 1'b0;
                    o_data_rd           <= 1'b0;                    
                    gmii_read_hcp_state     <= idle_s;
                end
            end
            tran_s:begin
                ov_rec_ts           <= 19'b0;
                if(iv_data[8] == 1'b0 && i_data_empty == 1'b0) begin//middle
                    ov_data             <= iv_data;
                    o_data_wr           <= 1'b1;                    
                    o_data_rd           <= 1'b1;
                    gmii_read_hcp_state     <= tran_s;
                    end
                else if(iv_data[8] == 1'b1) begin//tail
                    ov_data             <= iv_data;
                    o_pkt_valid_pulse   <= 1'b1;
                    o_data_wr           <= 1'b1;
                    o_data_rd           <= 1'b0;                    
                    gmii_read_hcp_state     <= idle_s;
                    end
                else if(i_data_empty == 1'b1)begin
                    ov_data             <= {1'b1,8'b0};
                    o_data_wr           <= 1'b1;
                    o_data_rd           <= 1'b1;
                    o_fifo_underflow_pulse <= 1'b1;
                    gmii_read_hcp_state     <= rdempty_error_s;
                    end                    
                else begin
                    ov_data             <= 9'b0;
                    o_data_wr           <= 1'b0;
                    o_data_rd           <= 1'b0;
                    gmii_read_hcp_state     <= idle_s;
                    end
                end
            discard_s:begin
                if(iv_data[8] == 1'b1) begin//tail
                    ov_data             <= 9'b0;
                    o_data_wr           <= 1'b0;
                    o_data_rd           <= 1'b0;                    
                    gmii_read_hcp_state     <= idle_s;
                    end
                else begin
                    ov_data             <= 9'b0;
                    o_data_wr           <= 1'b0;
                    o_data_rd           <= 1'b1;
                    gmii_read_hcp_state     <= discard_s;
                    end             
                end
            rdempty_error_s:begin
                ov_data <= 9'b0;
                o_data_wr <= 1'b0;
                o_fifo_underflow_pulse <= 1'b0;
                if(iv_data[8] == 1'b1)begin
                    o_data_rd <= 1'b0;                  
                    gmii_read_hcp_state <= idle_s;
                end
                else begin
                    o_data_rd <= 1'b1;
                    gmii_read_hcp_state <= rdempty_error_s;
                end             
            end
            default:begin
                ov_data             <= 9'b0;
                o_data_wr           <= 1'b0;
                ov_rec_ts           <= 19'b0;
                o_data_rd           <= 1'b0;
                gmii_read_hcp_state     <= idle_s;              
                end
            endcase
        end
        
endmodule