// Copyright (C) 1953-2021 NUDT
// Verilog module name - command_parse_and_encapsulate_pcb
// Version: V3.3.0.20211126
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module command_parse_and_encapsulate_pcb
(
        i_clk                 ,
        i_rst_n               ,
                              ,
        iv_free_pkt_bufid_num ,
                 
        iv_addr               ,
        i_addr_fixed          ,
        iv_wdata              ,
        i_wr_pcb              ,
        i_rd_pcb              ,
                     
        o_wr_pcb              ,
        ov_addr_pcb           ,
        o_addr_fixed_pcb      ,
        ov_rdata_pcb        
);

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;

input       [8:0]       iv_free_pkt_bufid_num;

input       [18:0]      iv_addr;                         
input                   i_addr_fixed;                   
input       [31:0]      iv_wdata;                        
input                   i_wr_pcb;         
input                   i_rd_pcb;         

output reg              o_wr_pcb;          
output reg  [18:0]      ov_addr_pcb;       
output reg              o_addr_fixed_pcb;  
output reg  [31:0]      ov_rdata_pcb;
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        o_wr_pcb           <= 1'b0;
        ov_addr_pcb        <= 19'b0;
        o_addr_fixed_pcb   <= 1'b0;
        ov_rdata_pcb       <= 32'b0;
    end
    else begin
        if(i_rd_pcb)begin//read
            if((i_addr_fixed == 1'b1) && (iv_addr == 19'd0))begin
                o_wr_pcb           <= 1'b1;
                ov_addr_pcb        <= iv_addr;
                o_addr_fixed_pcb   <= 1'b1;
                ov_rdata_pcb       <= {23'b0,iv_free_pkt_bufid_num};
            end            
            else begin
                o_wr_pcb           <= 1'b0;
                ov_addr_pcb        <= 19'b0;
                o_addr_fixed_pcb   <= 1'b0;
                ov_rdata_pcb       <= 32'b0;
            end
        end
        else begin
            o_wr_pcb           <= 1'b0;
            ov_addr_pcb        <= 19'b0;
            o_addr_fixed_pcb   <= 1'b0;
            ov_rdata_pcb       <= 32'b0;
        end        
    end
end       
endmodule