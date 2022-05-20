// Copyright (C) 1953-2022 NUDT
// Verilog module name - clock_domain_cross
// Version: V3.4.0.20220223
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         the internet clock field of the chip is switched to the external PHY clock field
//         send pkt data from gmii
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module clock_domain_cross
(
       i_wr_clk,
       i_wr_rst_n,
       
       i_rd_clk,
       i_rd_rst_n,
              
       iv_data,
       i_data_wr,
       
       o_fifo_overflow_pulse,
       
       ov_data,
       o_data_wr  
);

// I/O
// clk & rst
input                  i_wr_clk;                   //125Mhz
input                  i_wr_rst_n;

input                  i_rd_clk;
input                  i_rd_rst_n;
// receive pkt data from pkt_centralize_bufm_memory
input      [7:0]       iv_data;
input                  i_data_wr;
// send pkt data from gmii     
output reg [7:0]       ov_data;
output reg             o_data_wr;

output reg             o_fifo_overflow_pulse;
//fifo
wire       [7:0]       wv_rd_data;
reg                    w_rd;
wire                   w_rdempty;
////////////////////////////////////////
//        fifo overflow               //
////////////////////////////////////////
wire      fifo_wrfull;
reg       [1:0]        fifo_wr_state;  
localparam             OVERFLOW_JUDGE_S  = 2'd0,
                       OVERFLOW_ERROR_S  = 2'd1;
always @(posedge i_wr_clk or negedge i_wr_rst_n) begin
    if(!i_wr_rst_n)begin
        o_fifo_overflow_pulse <= 1'b0;
        fifo_wr_state <= OVERFLOW_JUDGE_S;
    end
    else begin
        case(fifo_wr_state)
            OVERFLOW_JUDGE_S:begin
                if((fifo_wrfull == 1'b1) && (i_data_wr == 1'b1))begin 
                    o_fifo_overflow_pulse <= 1'b1;            
                    fifo_wr_state <= OVERFLOW_ERROR_S;
                end
                else begin
                    o_fifo_overflow_pulse <= 1'b0;
                    fifo_wr_state <= OVERFLOW_JUDGE_S;
                end
            end
            OVERFLOW_ERROR_S:begin
                o_fifo_overflow_pulse <= 1'b0;    
                if(i_data_wr == 1'b0)begin   
                    fifo_wr_state <= OVERFLOW_JUDGE_S;            
                end
                else begin
                    fifo_wr_state <= OVERFLOW_ERROR_S;   
                end
            end
            default:begin
                o_fifo_overflow_pulse <= 1'b0;
                fifo_wr_state <= OVERFLOW_JUDGE_S;            
            end
        endcase
    end
end
////////////////////////////////////////
//        read data from fifo         //
////////////////////////////////////////
reg        [2:0]       ccd_state;  
localparam             IDLE_S   = 3'd0,
                       DELAY_S  = 3'd1,
                       WAIT1_S  = 3'd2,
                       WAIT2_S  = 3'd3,
                       READ_S   = 3'd4;
always @(posedge i_rd_clk or negedge i_rd_rst_n) begin
    if(i_rd_rst_n == 1'b0)begin
        ov_data     <= 8'h0;
        o_data_wr    <= 1'b0;
        w_rd            <= 1'b0;
        ccd_state       <= IDLE_S;
    end
    else begin
        case(ccd_state)
            IDLE_S:begin
                w_rd         <= 1'b0;
                ov_data  <= 8'd0;
                o_data_wr <= 1'b0;
                if(w_rdempty == 1'b0)begin
                    ccd_state       <= DELAY_S;
                end
                else begin
                    ccd_state       <= IDLE_S;
                end
            end
            DELAY_S:begin
                ccd_state       <= WAIT1_S;            
            end            
            WAIT1_S:begin
                w_rd         <= 1'b1;
                ov_data  <= 8'd0;
                o_data_wr <= 1'b0;
                ccd_state       <= WAIT2_S;
            end
            
            WAIT2_S:begin
                w_rd         <= 1'b1;
                ov_data  <= 8'd0;
                o_data_wr <= 1'b0;
                ccd_state       <= READ_S;
            end
            
            READ_S:begin
                w_rd         <= 1'b1;
                ov_data  <= wv_rd_data;
                o_data_wr <= w_rd;
                if(w_rdempty == 1'b1)begin
                    ccd_state       <= IDLE_S;
                end
                else begin
                    ccd_state       <= READ_S;
                end
            end
        endcase
    end
end

ASFIFO_8_16  ASFIFO_8_16_inst
(        
    .wr_aclr(~i_wr_rst_n),                                         //Reset the all signal
    .rd_aclr(~i_rd_rst_n),
    .data(iv_data),                                         //The Inport of data 
    .rdreq(w_rd),                                           //active-high
    .wrclk(i_wr_clk),                                          //ASYNC WriteClk(), SYNC use wrclk
    .rdclk(i_rd_clk),                                         //ASYNC WriteClk(), SYNC use wrclk  
    .wrreq(i_data_wr),                                          //active-high
    .q(wv_rd_data),                                             //The output of data
    .wrfull(fifo_wrfull),                                           //Write domain full 
    .wralfull(),                                        //Write domain almost-full
    .wrempty(),                                     //Write domain empty
    .wralempty(),                                       //Write domain almost-full  
    .rdfull(),                                          //Read domain full
    .rdalfull(),                                        //Read domain almost-full   
    .rdempty(w_rdempty),                                        //Read domain empty
    .rdalempty(),                                       //Read domain almost-empty
    .wrusedw(),                                     //Write-usedword
    .rdusedw()          
    );
endmodule