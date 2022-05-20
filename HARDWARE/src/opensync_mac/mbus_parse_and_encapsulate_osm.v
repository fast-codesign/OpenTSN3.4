// Copyright (C) 1953-2022 NUDT
// Verilog module name - mbus_parse_and_encapsulate_osm 
// Version: V3.4.0.20220226
// Created:
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module mbus_parse_and_encapsulate_osm
(
        i_clk,
        i_rst_n,

        i_wr,
        iv_wdata,
        iv_addr,
        i_addr_fixed,        
        i_rd,
       
        o_wr, 
        ov_rdata,
        ov_raddr,
        o_addr_fixed,
        
        o_tsn_or_tte,
        iv_rxasyncfifo_overflow_cnt,
        iv_rxasyncfifo_underflow_cnt,
        iv_txasyncfifo_overflow_cnt,
        iv_txasyncfifo_underflow_cnt,
        iv_inpkt_cnt_p0,
        iv_outpkt_cnt_p0,
        iv_inpkt_cnt_p1,
        iv_outpkt_cnt_p1,
        iv_inpkt_cnt_p2,
        iv_outpkt_cnt_p2,
        iv_inpkt_cnt_p3,
        iv_outpkt_cnt_p3,
        iv_inpkt_cnt_p4,
        iv_outpkt_cnt_p4,
        iv_inpkt_cnt_p5,
        iv_outpkt_cnt_p5,
        iv_inpkt_cnt_p6,
        iv_outpkt_cnt_p6,
        iv_inpkt_cnt_p7,
        iv_outpkt_cnt_p7   
);
// I/O
// i_clk & rst
input                  i_clk;
input                  i_rst_n;

input                  i_wr;
input      [31:0]      iv_wdata;
input      [18:0]      iv_addr; 
input                  i_addr_fixed;        
input                  i_rd;
output reg             o_wr; 
output reg [31:0]      ov_rdata;  
output reg [18:0]      ov_raddr;
output reg             o_addr_fixed;

output reg             o_tsn_or_tte;
input      [31:0]      iv_rxasyncfifo_overflow_cnt;
input      [31:0]      iv_rxasyncfifo_underflow_cnt;
input      [31:0]      iv_txasyncfifo_overflow_cnt;
input      [31:0]      iv_txasyncfifo_underflow_cnt;
input      [31:0]      iv_inpkt_cnt_p0;
input      [31:0]      iv_outpkt_cnt_p0;
input      [31:0]      iv_inpkt_cnt_p1;
input      [31:0]      iv_outpkt_cnt_p1;
input      [31:0]      iv_inpkt_cnt_p2;
input      [31:0]      iv_outpkt_cnt_p2;
input      [31:0]      iv_inpkt_cnt_p3;
input      [31:0]      iv_outpkt_cnt_p3;
input      [31:0]      iv_inpkt_cnt_p4;
input      [31:0]      iv_outpkt_cnt_p4;
input      [31:0]      iv_inpkt_cnt_p5;
input      [31:0]      iv_outpkt_cnt_p5;
input      [31:0]      iv_inpkt_cnt_p6;
input      [31:0]      iv_outpkt_cnt_p6;
input      [31:0]      iv_inpkt_cnt_p7;
input      [31:0]      iv_outpkt_cnt_p7;
//***************************************************
//               command parse
//***************************************************
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin       
        o_wr              <= 1'b0;
        ov_rdata          <= 32'b0;
        ov_raddr          <= 19'b0;
        o_addr_fixed      <= 1'b0;

        o_tsn_or_tte      <= 1'b1;         
    end
    else begin
        if(i_wr)begin
            o_wr          <= 1'b0;
            ov_rdata      <= 32'b0;
            ov_raddr      <= 19'b0;
            if((!i_addr_fixed) && (iv_addr == 19'd0))begin
                o_tsn_or_tte       <= iv_wdata[0];
            end            
            else begin
                o_tsn_or_tte       <= o_tsn_or_tte; 
            end
        end      
        else if(i_rd)begin
            if((!i_addr_fixed) && (iv_addr == 19'd0))begin
                o_wr          <= 1'b1;
                ov_rdata      <= {31'b0,o_tsn_or_tte};
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd1))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_rxasyncfifo_overflow_cnt;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd2))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_rxasyncfifo_underflow_cnt;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd3))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_txasyncfifo_overflow_cnt;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd4))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_txasyncfifo_underflow_cnt;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd5))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_inpkt_cnt_p0;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd6))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_outpkt_cnt_p0;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd7))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_inpkt_cnt_p1;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end 
            else if((!i_addr_fixed) && (iv_addr == 19'd8))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_outpkt_cnt_p1;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd9))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_inpkt_cnt_p2;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd10))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_outpkt_cnt_p2;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd11))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_inpkt_cnt_p3;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd12))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_outpkt_cnt_p3;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd13))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_inpkt_cnt_p4;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd14))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_outpkt_cnt_p4;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd15))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_inpkt_cnt_p5;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd16))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_outpkt_cnt_p5;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd17))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_inpkt_cnt_p6;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd18))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_outpkt_cnt_p6;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end 
            else if((!i_addr_fixed) && (iv_addr == 19'd19))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_inpkt_cnt_p7;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd20))begin
                o_wr          <= 1'b1;
                ov_rdata      <= iv_outpkt_cnt_p7;
                ov_raddr      <= iv_addr;
                o_addr_fixed  <= i_addr_fixed;
            end             
            else begin
                o_wr          <= 1'b0;
                ov_rdata      <= 32'b0;
                ov_raddr      <= 19'b0;
                o_addr_fixed  <= 1'b0;
            end            
        end
        else begin               
            o_wr                        <= 1'b0;
            ov_rdata                    <= 32'b0;
            ov_raddr                    <= 19'b0;
            o_addr_fixed                <= 1'b0;          
        end
    end
end    
endmodule
    