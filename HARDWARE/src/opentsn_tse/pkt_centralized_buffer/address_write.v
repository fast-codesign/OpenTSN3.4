// Copyright (C) 1953-2020 NUDT
// Verilog module name - address_write 
// Version: AWR_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         Write Pkt bufer id
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module address_write(
        clk_sys,
        reset_n,
        o_hardware_initial_finish,
        iv_pkt_bufid_p0,
        i_pkt_bufid_wr_p0,
        o_pkt_bufid_ack_p0,
        iv_pkt_bufid_p1,
        i_pkt_bufid_wr_p1,
        o_pkt_bufid_ack_p1,
        iv_pkt_bufid_p2,
        i_pkt_bufid_wr_p2,
        o_pkt_bufid_ack_p2,
        iv_pkt_bufid_p3,
        i_pkt_bufid_wr_p3,
        o_pkt_bufid_ack_p3,
        iv_pkt_bufid_p4,
        i_pkt_bufid_wr_p4,
        o_pkt_bufid_ack_p4,
        iv_pkt_bufid_p5,
        i_pkt_bufid_wr_p5,
        o_pkt_bufid_ack_p5,
        iv_pkt_bufid_p6,
        i_pkt_bufid_wr_p6,
        o_pkt_bufid_ack_p6,
        iv_pkt_bufid_p7,
        i_pkt_bufid_wr_p7,
        o_pkt_bufid_ack_p7, 
        iv_pkt_bufid_p8,
        i_pkt_bufid_wr_p8,
        o_pkt_bufid_ack_p8,
        o_pkt_bufid_wr,
        o_pkt_bufid,
        i_pkt_bufid_full,
        ov_address_write_state,
        
        rd_outport_num,
        bufid_addr,
        rd_bufid_wr,        
        wr_outport_num,
        wr_bufid_wr
        
    );
// I/O
// clk & rst
input                   clk_sys;
input                   reset_n;
// receive port buffer id
input       [8:0]       iv_pkt_bufid_p0;
input                   i_pkt_bufid_wr_p0;
output  reg             o_pkt_bufid_ack_p0;
input       [8:0]       iv_pkt_bufid_p1;
input                   i_pkt_bufid_wr_p1;
output  reg             o_pkt_bufid_ack_p1;
input       [8:0]       iv_pkt_bufid_p2;
input                   i_pkt_bufid_wr_p2;
output  reg             o_pkt_bufid_ack_p2;
input       [8:0]       iv_pkt_bufid_p3;
input                   i_pkt_bufid_wr_p3;
output  reg             o_pkt_bufid_ack_p3;
input       [8:0]       iv_pkt_bufid_p4;
input                   i_pkt_bufid_wr_p4;
output  reg             o_pkt_bufid_ack_p4;
input       [8:0]       iv_pkt_bufid_p5;
input                   i_pkt_bufid_wr_p5;
output  reg             o_pkt_bufid_ack_p5;
input       [8:0]       iv_pkt_bufid_p6;
input                   i_pkt_bufid_wr_p6;
output  reg             o_pkt_bufid_ack_p6;
input       [8:0]       iv_pkt_bufid_p7;
input                   i_pkt_bufid_wr_p7;
output  reg             o_pkt_bufid_ack_p7; 
input       [8:0]       iv_pkt_bufid_p8;
input                   i_pkt_bufid_wr_p8;
output  reg             o_pkt_bufid_ack_p8;
//write pkt bufid to FIFO
output  reg             o_pkt_bufid_wr;
output  reg [8:0]       o_pkt_bufid;
input                   i_pkt_bufid_full;
output  reg             o_hardware_initial_finish;

output  reg [3:0]       ov_address_write_state;


// ram interface
input       [3:0]   rd_outport_num;
output  reg         rd_bufid_wr;
output  reg [3:0]   wr_outport_num;
output  reg         wr_bufid_wr;
output  reg [8:0]   bufid_addr;

//internal wire&reg
reg [3:0]   outport_reg;
reg [8:0]   bufid_send_cnt;

localparam  wr_bufid_ch0_s  = 4'b0000,
            wr_bufid_ch1_s  = 4'b0001,
            wr_bufid_ch2_s  = 4'b0010,
            wr_bufid_ch3_s  = 4'b0011,
            wr_bufid_ch4_s  = 4'b0100,
            wr_bufid_ch5_s  = 4'b0101,
            wr_bufid_ch6_s  = 4'b0110,
            wr_bufid_ch7_s  = 4'b0111,
            wr_bufid_ch8_s  = 4'b1000,
            initial_s       = 4'b1001,
            wait_for_ram1   = 4'b1010,
            wait_for_ram2   = 4'b1011,
            rd_ram          = 4'b1100;
            
always@(posedge clk_sys or negedge reset_n)
    if(!reset_n) begin
    // RAM interface
        bufid_addr              <= 9'b0;
        rd_bufid_wr             <= 1'b0;
        wr_outport_num          <= 1'b0;        
        wr_bufid_wr             <= 1'b0;
    // outport bufid ack
        o_pkt_bufid_ack_p0      <= 1'b0;
        o_pkt_bufid_ack_p1      <= 1'b0;
        o_pkt_bufid_ack_p2      <= 1'b0;
        o_pkt_bufid_ack_p3      <= 1'b0;
        o_pkt_bufid_ack_p4      <= 1'b0;
        o_pkt_bufid_ack_p5      <= 1'b0;
        o_pkt_bufid_ack_p6      <= 1'b0;
        o_pkt_bufid_ack_p7      <= 1'b0;    
        o_pkt_bufid_ack_p8      <= 1'b0;
        o_hardware_initial_finish <= 1'b0;
        ov_address_write_state  <= initial_s;
    //internal
        bufid_send_cnt          <= 9'd9;
        outport_reg             <= 4'b0;
    // FIFO interface
        o_pkt_bufid_wr          <= 1'b0;
        o_pkt_bufid             <= 9'b0;
        end
    else begin
        case(ov_address_write_state)
            initial_s:begin
                o_pkt_bufid         <= bufid_send_cnt;
                o_pkt_bufid_wr      <= 1'b1;
                if(bufid_send_cnt < 9'd511) begin
                    bufid_send_cnt      <= bufid_send_cnt + 9'd1;
                    o_hardware_initial_finish    <= 1'b0;
                    ov_address_write_state      <= initial_s;
                    end
                else begin
                    bufid_send_cnt      <=  bufid_send_cnt;
                    o_hardware_initial_finish    <=  1'b1;
                    ov_address_write_state      <=  wr_bufid_ch0_s;                 
                end
            end
            
            wr_bufid_ch0_s:begin
                o_pkt_bufid_wr      <= 1'b0;
                outport_reg         <= 4'd0;
                wr_bufid_wr         <= 1'b0;
                if(i_pkt_bufid_wr_p0 == 1'b1) begin
                    o_pkt_bufid_ack_p0  <= 1'b1;
                    bufid_addr          <= iv_pkt_bufid_p0;
                    rd_bufid_wr         <= i_pkt_bufid_wr_p0;
                    ov_address_write_state      <= wait_for_ram1;
                end
                else begin
                    o_pkt_bufid_ack_p0  <= 1'b0;
                    bufid_addr          <= 9'b0;
                    rd_bufid_wr         <= 1'b0;
                    ov_address_write_state      <= wr_bufid_ch1_s;                  
                end 
            end
            
            wr_bufid_ch1_s:begin
                o_pkt_bufid_wr      <= 1'b0;
                outport_reg         <= 4'd1;
                wr_bufid_wr         <= 1'b0;
                if(i_pkt_bufid_wr_p1 == 1'b1) begin
                    o_pkt_bufid_ack_p1  <= 1'b1;
                    bufid_addr          <= iv_pkt_bufid_p1;
                    rd_bufid_wr         <= i_pkt_bufid_wr_p1;
                    ov_address_write_state      <= wait_for_ram1;
                end
                else begin
                    o_pkt_bufid_ack_p1  <= 1'b0;
                    bufid_addr          <= 9'b0;
                    rd_bufid_wr         <= 1'b0;
                    ov_address_write_state      <= wr_bufid_ch8_s;                    
                end
            end
            
            wr_bufid_ch2_s:begin
                o_pkt_bufid_wr      <= 1'b0;
                outport_reg         <= 4'd2;
                wr_bufid_wr         <= 1'b0;                
                if(i_pkt_bufid_wr_p2 == 1'b1) begin
                    o_pkt_bufid_ack_p2  <= 1'b1;
                    bufid_addr          <= iv_pkt_bufid_p2;
                    rd_bufid_wr         <= i_pkt_bufid_wr_p2;
                    ov_address_write_state      <= wait_for_ram1;                   
                end
                else begin
                    o_pkt_bufid_ack_p2  <= 1'b0;
                    bufid_addr          <= 9'b0;
                    rd_bufid_wr         <= 1'b0;
                    ov_address_write_state      <= wr_bufid_ch3_s;                      
                end
            end
            
            wr_bufid_ch3_s:begin
                o_pkt_bufid_wr      <= 1'b0;
                outport_reg         <= 4'd3;
                wr_bufid_wr         <= 1'b0;
                if(i_pkt_bufid_wr_p3 == 1'b1) begin
                    o_pkt_bufid_ack_p3  <= 1'b1;
                    bufid_addr          <= iv_pkt_bufid_p3;
                    rd_bufid_wr         <= i_pkt_bufid_wr_p3;
                    ov_address_write_state      <= wait_for_ram1;                   
                end
                else begin
                    o_pkt_bufid_ack_p3  <= 1'b0;
                    bufid_addr          <= 9'b0;
                    rd_bufid_wr         <= 1'b0;
                    ov_address_write_state      <= wr_bufid_ch4_s;                 
                end
            end
            
            wr_bufid_ch4_s:begin
                o_pkt_bufid_wr      <= 1'b0;
                outport_reg         <= 4'd4;
                wr_bufid_wr         <= 1'b0;
                if(i_pkt_bufid_wr_p4 == 1'b1) begin
                    o_pkt_bufid_ack_p4  <= 1'b1;
                    bufid_addr          <= iv_pkt_bufid_p4;
                    rd_bufid_wr         <= i_pkt_bufid_wr_p4;
                    ov_address_write_state      <= wait_for_ram1;                   
                end
                else begin
                    o_pkt_bufid_ack_p4  <= 1'b0;
                    bufid_addr          <= 9'b0;
                    rd_bufid_wr         <= 1'b0;
                    ov_address_write_state      <= wr_bufid_ch5_s;                      
                end
            end
            
            wr_bufid_ch5_s:begin
                o_pkt_bufid_wr      <= 1'b0;
                outport_reg         <= 4'd5;
                wr_bufid_wr         <= 1'b0;
                if(i_pkt_bufid_wr_p5 == 1'b1) begin
                    o_pkt_bufid_ack_p5  <= 1'b1;
                    bufid_addr          <= iv_pkt_bufid_p5;
                    rd_bufid_wr         <= i_pkt_bufid_wr_p5;
                    ov_address_write_state      <= wait_for_ram1;                   
                end
                else begin
                    o_pkt_bufid_ack_p5  <= 1'b0;
                    bufid_addr          <= 9'b0;
                    rd_bufid_wr         <= 1'b0;
                    ov_address_write_state      <= wr_bufid_ch6_s;                  
                end
            end
            
            wr_bufid_ch6_s:begin
                o_pkt_bufid_wr      <= 1'b0;
                outport_reg         <= 4'd6;
                wr_bufid_wr         <= 1'b0;
                if(i_pkt_bufid_wr_p6 == 1'b1) begin
                    o_pkt_bufid_ack_p6  <= 1'b1;
                    bufid_addr          <= iv_pkt_bufid_p6;
                    rd_bufid_wr         <= i_pkt_bufid_wr_p6;
                    ov_address_write_state      <= wait_for_ram1;                   
                end
                else begin
                    o_pkt_bufid_ack_p6  <= 1'b0;
                    bufid_addr          <= 9'b0;
                    rd_bufid_wr         <= 1'b0;
                    ov_address_write_state      <= wr_bufid_ch7_s;                      
                end
            end
            
            wr_bufid_ch7_s:begin
                o_pkt_bufid_wr      <= 1'b0;
                outport_reg         <= 4'd7;
                wr_bufid_wr         <= 1'b0;
                if(i_pkt_bufid_wr_p7 == 1'b1) begin
                    o_pkt_bufid_ack_p7  <= 1'b1;
                    bufid_addr          <= iv_pkt_bufid_p7;
                    rd_bufid_wr         <= i_pkt_bufid_wr_p7;
                    ov_address_write_state      <= wait_for_ram1;                   
                end
                else begin
                    o_pkt_bufid_ack_p7  <= 1'b0;
                    bufid_addr          <= 9'b0;
                    rd_bufid_wr         <= 1'b0;
                    ov_address_write_state      <= wr_bufid_ch8_s;                      
                end
            end
            
            wr_bufid_ch8_s:begin
                o_pkt_bufid_wr      <= 1'b0;
                outport_reg         <= 4'd8;
                wr_bufid_wr         <= 1'b0;
                if(i_pkt_bufid_wr_p8 == 1'b1) begin
                    o_pkt_bufid_ack_p8  <= 1'b1;
                    bufid_addr          <= iv_pkt_bufid_p8;
                    rd_bufid_wr         <= i_pkt_bufid_wr_p8;
                    ov_address_write_state      <= wait_for_ram1;                   
                end
                else begin
                    o_pkt_bufid_ack_p8  <= 1'b0;
                    bufid_addr          <= 9'b0;
                    rd_bufid_wr         <= 1'b0;
                    ov_address_write_state      <= wr_bufid_ch0_s;                  
                end
            end
            
            wait_for_ram1:begin
                o_pkt_bufid_ack_p0      <= 1'b0;
                o_pkt_bufid_ack_p1      <= 1'b0;
                o_pkt_bufid_ack_p2      <= 1'b0;
                o_pkt_bufid_ack_p3      <= 1'b0;
                o_pkt_bufid_ack_p4      <= 1'b0;
                o_pkt_bufid_ack_p5      <= 1'b0;
                o_pkt_bufid_ack_p6      <= 1'b0;
                o_pkt_bufid_ack_p7      <= 1'b0;    
                o_pkt_bufid_ack_p8      <= 1'b0;    
                rd_bufid_wr             <= 1'b0;
                ov_address_write_state      <=  wait_for_ram2;  
            end
            wait_for_ram2:begin
                ov_address_write_state      <=  rd_ram;
            end
            rd_ram: begin
                if (rd_outport_num > 4'd1) begin
                    wr_outport_num <= rd_outport_num- 4'd1;
                    bufid_addr     <= bufid_addr;
                    wr_bufid_wr    <= 1'b1;
                end
                else begin
                    wr_outport_num <= wr_outport_num;
                    bufid_addr     <= bufid_addr;
                    wr_bufid_wr    <= 1'b0;
                    if(i_pkt_bufid_full == 1) begin
                        o_pkt_bufid_wr <= 1'b0;
                        o_pkt_bufid    <= 9'b0;
                    end
                    else begin
                        o_pkt_bufid_wr <= 1'b1;
                        o_pkt_bufid    <= bufid_addr;
                    end
                end
                case(outport_reg) 
                    4'd0: ov_address_write_state <= wr_bufid_ch1_s;
                    4'd1: ov_address_write_state <= wr_bufid_ch8_s;//ov_address_write_state <= wr_bufid_ch2_s;
                    4'd2: ov_address_write_state <= wr_bufid_ch3_s;
                    4'd3: ov_address_write_state <= wr_bufid_ch4_s;
                    4'd4: ov_address_write_state <= wr_bufid_ch5_s;
                    4'd5: ov_address_write_state <= wr_bufid_ch6_s;
                    4'd6: ov_address_write_state <= wr_bufid_ch7_s;
                    4'd7: ov_address_write_state <= wr_bufid_ch8_s;
                    4'd8: ov_address_write_state <= wr_bufid_ch0_s;
                    default: ov_address_write_state <= wr_bufid_ch0_s;
                endcase
            end
            
            default:begin
                o_pkt_bufid_ack_p0      <= 1'b0;
                o_pkt_bufid_ack_p1      <= 1'b0;
                o_pkt_bufid_ack_p2      <= 1'b0;
                o_pkt_bufid_ack_p3      <= 1'b0;
                o_pkt_bufid_ack_p4      <= 1'b0;
                o_pkt_bufid_ack_p5      <= 1'b0;
                o_pkt_bufid_ack_p6      <= 1'b0;
                o_pkt_bufid_ack_p7      <= 1'b0;    
                o_pkt_bufid_ack_p8      <= 1'b0;
                o_pkt_bufid_wr          <= 1'b0;
                o_pkt_bufid             <= 9'b0;
                bufid_send_cnt          <= 9'd9;
                outport_reg             <= 4'b0;
                bufid_addr              <= 9'b0;
                rd_bufid_wr             <= 1'b0;
                wr_outport_num          <= 1'b0;        
                wr_bufid_wr             <= 1'b0;
                ov_address_write_state          <= wr_bufid_ch0_s;              
                end
            
            
        endcase
    end
    
endmodule

