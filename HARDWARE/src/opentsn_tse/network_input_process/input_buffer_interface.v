// Copyright (C) 1953-2020 NUDT
// Verilog module name - input_buffer_interface 
// Version: IBI_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         input buffer interface
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module input_buffer_interface(
        i_clk,
        i_rst_n,
        i_pkt_wr,
        iv_pkt,
        i_pkt_bufid_wr,
        iv_pkt_bufid,
        ov_pkt,
        o_pkt_wr,
        ov_pkt_bufadd,
        i_pkt_ack,
        input_buf_interface_state
    );  

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
//input
input                   i_pkt_wr;
input       [133:0]     iv_pkt; 
input                   i_pkt_bufid_wr;
input       [8:0]       iv_pkt_bufid;
//output
output  reg [133:0]     ov_pkt;
output  reg             o_pkt_wr;
output  reg [15:0]      ov_pkt_bufadd;
input                   i_pkt_ack;

output  reg [1:0]       input_buf_interface_state;
//internal wire&reg
reg         reg_pkt_bufid_release;
reg         reg_pkt_bufid_valid;
reg [8:0]   reg_pkt_bufid;
reg         reg_pkt_wr;
reg [133:0] reg_pkt;
localparam  idle_s          = 2'b00,
            tran_pkt_s      = 2'b01,
            wait_ack_s      = 2'b10;        
always@(posedge i_clk or negedge i_rst_n)
    if(!i_rst_n) begin
        reg_pkt_bufid_valid <= 1'b0;
        reg_pkt_bufid       <= 9'b0;
        end
    else begin
        if(i_pkt_bufid_wr == 1'b1)begin
            reg_pkt_bufid_valid <= i_pkt_bufid_wr;
            reg_pkt_bufid       <= iv_pkt_bufid;            
            end
        else if(reg_pkt_bufid_release == 1'b1) begin
            reg_pkt_bufid_valid <= 1'b0;
            reg_pkt_bufid       <= 9'b0;
            end
        else begin
            reg_pkt_bufid_valid <= reg_pkt_bufid_valid;
            reg_pkt_bufid       <= reg_pkt_bufid;
            end     
        end     
always@(posedge i_clk or negedge i_rst_n)
    if(!i_rst_n) begin
        ov_pkt                      <= 134'b0;
        o_pkt_wr                    <= 1'b0;
        ov_pkt_bufadd               <= 16'b0;
        reg_pkt_wr                  <= 1'b0;
        reg_pkt                     <= 134'b0;
        reg_pkt_bufid_release       <= 1'b0;
        input_buf_interface_state               <= idle_s;
        end
    else begin
        case(input_buf_interface_state)
            idle_s:begin
                if(reg_pkt_wr == 1'b1 && reg_pkt[133:132] == 2'b01 && reg_pkt_bufid_valid == 1'b1) begin//head
                    ov_pkt                      <= reg_pkt;
                    ov_pkt_bufadd               <= {reg_pkt_bufid,7'd0};
                    o_pkt_wr                    <= 1'b1;
                    reg_pkt_wr                  <= 1'b0;
                    reg_pkt                     <= 134'b0;
                    reg_pkt_bufid_release       <= 1'b1;                    
                    input_buf_interface_state               <= wait_ack_s;
                    end
                else if(i_pkt_wr == 1'b1 && iv_pkt[133:132] == 2'b01 && reg_pkt_bufid_valid == 1'b1) begin//head
                    ov_pkt                      <= iv_pkt;
                    ov_pkt_bufadd               <= {reg_pkt_bufid,7'd0};
                    o_pkt_wr                    <= 1'b1;
                    reg_pkt_bufid_release       <= 1'b1;                    
                    input_buf_interface_state               <= wait_ack_s;
                    end
                else begin
                    ov_pkt                      <= 134'b0;
                    o_pkt_wr                    <= 1'b0;
                    ov_pkt_bufadd               <= 16'b0;
                    reg_pkt_bufid_release       <= 1'b0;                    
                    input_buf_interface_state               <= idle_s;
                    end
               end
            tran_pkt_s:begin//write the data to PCB
                if(reg_pkt_wr == 1'b1) begin
                    ov_pkt                      <= reg_pkt;                 
                    ov_pkt_bufadd               <= ov_pkt_bufadd + 16'b1;
                    o_pkt_wr                    <= 1'b1;
                    reg_pkt_wr                  <= 1'b0;
                    reg_pkt                     <= 134'b0;
                    input_buf_interface_state               <= wait_ack_s;
                    end
                else if(i_pkt_wr == 1'b1) begin
                    ov_pkt                      <= iv_pkt;
                    ov_pkt_bufadd               <= ov_pkt_bufadd + 16'b1;
                    o_pkt_wr                    <= 1'b1;
                    input_buf_interface_state               <= wait_ack_s;
                    end
                else begin
                    ov_pkt                      <= 134'b0;
                    o_pkt_wr                    <= 1'b0;
                    ov_pkt_bufadd               <= ov_pkt_bufadd;
                    reg_pkt_wr                  <= 1'b0;
                    reg_pkt                     <= 134'b0;
                    input_buf_interface_state               <= tran_pkt_s;
                    end                 
                end
            wait_ack_s:begin//wait the ack signal from PCB
                reg_pkt_bufid_release           <= 1'b0;
                if(i_pkt_wr == 1'b1) begin                  
                    reg_pkt                     <= iv_pkt;
                    reg_pkt_wr                  <= 1'b1;
                    end
                else begin
                    reg_pkt                     <= reg_pkt;
                    reg_pkt_wr                  <= reg_pkt_wr;
                    end
                if(i_pkt_ack == 1'b1) begin
                    ov_pkt                      <= 134'b0;
                    o_pkt_wr                    <= 1'b0;
                    if(ov_pkt[133:132] == 2'b10)begin //tail
                        ov_pkt_bufadd               <= 16'b0;
                        input_buf_interface_state               <= idle_s;
                        end
                    else begin
                        ov_pkt_bufadd               <= ov_pkt_bufadd;
                        input_buf_interface_state               <= tran_pkt_s;
                        end
                    end
                else begin
                    ov_pkt                      <= ov_pkt;
                    ov_pkt_bufadd               <= ov_pkt_bufadd;
                    o_pkt_wr                    <= o_pkt_wr;
                    input_buf_interface_state               <= wait_ack_s;
                    end
                end
            endcase
        end     
endmodule