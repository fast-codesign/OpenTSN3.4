// Copyright (C) 1953-2022 NUDT
// Verilog module name - command_parse_and_encapsulate_qgc
// Version: V3.4.0.20220226
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module command_parse_and_encapsulate_qgc
(
        i_clk                    ,                
        i_rst_n                  ,      
           
        iv_addr                  ,         
        i_addr_fixed             ,        
        iv_wdata                 ,         
        i_wr                     ,      
        i_rd                     ,      
           
        o_wr                     ,      
        ov_addr                  ,      
        o_addr_fixed             ,      
        ov_rdata                 ,      
            
        ov_ram_addr              ,      
        ov_ram_wdata             ,      
        o_ram_wr                 ,         
        iv_ram_rdata             ,      
        o_ram_rd                           
);
// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;

input       [18:0]      iv_addr;                         
input                   i_addr_fixed;                   
input       [31:0]      iv_wdata;                        
input                   i_wr;         
input                   i_rd;         

output reg              o_wr                  ;          
output reg  [18:0]      ov_addr               ;       
output reg              o_addr_fixed          ;  
output reg  [31:0]      ov_rdata              ;
//configuration                               
output reg [9:0]        ov_ram_addr           ;   
output reg [7:0]        ov_ram_wdata          ;  
output reg              o_ram_wr              ;   
input      [7:0]        iv_ram_rdata          ;  
output reg              o_ram_rd              ;
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin            
        ov_ram_addr           <= 10'b0   ;
        ov_ram_wdata          <= 8'b0    ;
        o_ram_wr              <= 1'b0    ;
        o_ram_rd              <= 1'b0    ;
    end
    else begin
        if(i_wr)begin//write
            if((i_addr_fixed == 1'b1) && (iv_addr <= 19'd1023))begin
                ov_ram_addr      <= iv_addr[9:0]    ;
                ov_ram_wdata     <= iv_wdata[7:0]   ;
                o_ram_wr         <= 1'b1            ;
                o_ram_rd         <= 1'b0            ;
            end
            else begin
                ov_ram_addr         <= 10'b0              ;
                ov_ram_wdata        <= 8'b0               ;
                o_ram_wr            <= 1'b0               ;
                o_ram_rd            <= 1'b0               ;
            end            
        end
        else if(i_rd)begin//read
            if((i_addr_fixed == 1'b1) && (iv_addr <= 19'd1023))begin
                ov_ram_addr      <= iv_addr[9:0]    ;
                ov_ram_wdata     <= 8'b0            ;
                o_ram_wr         <= 1'b0            ;
                o_ram_rd         <= 1'b1            ;
            end          
            else begin
                ov_ram_addr      <= 10'b0   ;
                ov_ram_wdata     <= 8'b0    ;
                o_ram_wr         <= 1'b0    ;
                o_ram_rd         <= 1'b0    ;
            end
        end
        else begin
            ov_ram_addr           <= 10'b0   ;
            ov_ram_wdata          <= 8'b0    ;
            o_ram_wr              <= 1'b0    ;
            o_ram_rd              <= 1'b0    ;
        end        
    end
end

reg  [2:0]  rv_ram_rden;
reg  [9:0]  rv_ram_raddr0;
reg  [9:0]  rv_ram_raddr1;
reg  [9:0]  rv_ram_raddr2;
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        rv_ram_rden   <= 3'b0;
        rv_ram_raddr0 <= 10'b0;
        rv_ram_raddr1 <= 10'b0;
        rv_ram_raddr2 <= 10'b0;
    end
    else begin
        rv_ram_rden   <= {rv_ram_rden[1:0],o_ram_rd};
        rv_ram_raddr0 <= ov_ram_addr;
        rv_ram_raddr1 <= rv_ram_raddr0;
        rv_ram_raddr2 <= rv_ram_raddr1;        
    end
end

always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        o_wr                  <= 1'b0    ;
        ov_addr               <= 19'b0   ;
        o_addr_fixed          <= 1'b0    ;
        ov_rdata              <= 32'b0   ;
    end
    else begin
        if(rv_ram_rden[2])begin//get data from ram
            o_wr                  <= 1'b1                  ;
            ov_addr               <= {9'b0,rv_ram_raddr2}  ;
            o_addr_fixed          <= 1'b1                  ;
            ov_rdata              <= {24'b0,iv_ram_rdata}  ;         
        end
        else begin
            o_wr                  <= 1'b0    ;
            ov_addr               <= 19'b0   ;
            o_addr_fixed          <= 1'b0    ;
            ov_rdata              <= 32'b0   ;
        end        
    end
end       
endmodule