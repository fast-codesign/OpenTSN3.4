// Copyright (C) 1953-2021 NUDT
// Verilog module name - command_parse_and_encapsulate_tft
// Version: V3.4.0.20220225
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module command_parse_and_encapsulate_tft
(
        i_clk                       ,       
        i_rst_n                     ,      
                                    
        iv_addr                     ,         
        i_addr_fixed                ,        
        iv_wdata                    ,         
        i_wr                        ,      
        i_rd                        ,        
                                    
        o_wr                        ,      
        ov_addr                     ,      
        o_addr_fixed                ,         
        ov_rdata                    ,      
                          
        ov_tsmpforwardram_addr       ,      
        ov_tsmpforwardram_wdata      ,      
        o_tsmpforwardram_wr          ,      
        iv_tsmpforwardram_rdata      ,      
        o_tsmpforwardram_rd          
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

output reg              o_wr              ;
output reg [18:0]       ov_addr           ;
output reg              o_addr_fixed      ;
output reg [31:0]       ov_rdata          ;
//configuration 
output reg [11:0]       ov_tsmpforwardram_addr    ;   
output reg [33:0]       ov_tsmpforwardram_wdata   ;  
output reg              o_tsmpforwardram_wr       ;   
input      [33:0]       iv_tsmpforwardram_rdata   ;  
output reg              o_tsmpforwardram_rd       ; 

reg                     r_raddr_h_or_l            ;   //0:high 32bit; 1:low 32bit.    
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        ov_tsmpforwardram_addr      <= 12'b0  ;
        ov_tsmpforwardram_wdata     <= 34'b0  ;
        o_tsmpforwardram_wr         <= 1'b0   ;
        o_tsmpforwardram_rd         <= 1'b0   ;

        r_raddr_h_or_l              <= 1'b0   ;         
    end
    else begin
        if(i_wr)begin//write
            r_raddr_h_or_l         <= 1'b0   ; 
            if((!i_addr_fixed) && (iv_addr <= 19'd8191))begin//tsmp forward table                       
                if(iv_addr[0] == 1'b0)begin//high 32bit
                    ov_tsmpforwardram_wdata     <= {iv_wdata[31],iv_wdata[0],32'b0}  ;
                    o_tsmpforwardram_wr         <= 1'b0                 ;
                    o_tsmpforwardram_rd         <= 1'b0                 ;
                end
                else begin//low 32bit
                    ov_tsmpforwardram_addr      <= iv_addr[12:1]         ;
                    ov_tsmpforwardram_wdata     <= {ov_tsmpforwardram_wdata[33:32],iv_wdata}   ;
                    o_tsmpforwardram_wr         <= 1'b1            ;
                    o_tsmpforwardram_rd         <= 1'b0            ;                
                end
            end
            else begin
                ov_tsmpforwardram_addr          <= 12'b0  ;
                o_tsmpforwardram_wr             <= 1'b0   ;
                o_tsmpforwardram_rd             <= 1'b0   ;             
            end
        end
        else if(i_rd)begin//read
            r_raddr_h_or_l                  <= iv_addr[0]      ;
            if((!i_addr_fixed) && (iv_addr <= 19'd8191))begin//tsmp forward table                
                ov_tsmpforwardram_addr      <= iv_addr[12:1]   ;
                o_tsmpforwardram_wr         <= 1'b0            ;
                o_tsmpforwardram_rd         <= 1'b1            ;                
            end          
            else begin
                ov_tsmpforwardram_addr      <= 12'b0  ;
                o_tsmpforwardram_wr         <= 1'b0   ;
                o_tsmpforwardram_rd         <= 1'b0   ;
            end
        end
        else begin
            r_raddr_h_or_l              <= 1'b0   ;
            ov_tsmpforwardram_addr      <= 12'b0  ;
            o_tsmpforwardram_wr         <= 1'b0   ;
            o_tsmpforwardram_rd         <= 1'b0   ;
        end        
    end
end

reg  [2:0]  rv_midram_rden;
reg  [12:0] rv_midram_raddr0;
reg  [12:0] rv_midram_raddr1;
reg  [12:0] rv_midram_raddr2;
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        rv_midram_rden   <= 3'b0;
        rv_midram_raddr0 <= 13'b0;
        rv_midram_raddr1 <= 13'b0;
        rv_midram_raddr2 <= 13'b0;
    end
    else begin
        rv_midram_rden   <= {rv_midram_rden[1:0],o_tsmpforwardram_rd};
        rv_midram_raddr0 <= {ov_tsmpforwardram_addr,r_raddr_h_or_l};
        rv_midram_raddr1 <= rv_midram_raddr0;
        rv_midram_raddr2 <= rv_midram_raddr1;        
    end
end
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        o_wr            <= 1'b0 ;
        ov_addr         <= 19'b0;
        o_addr_fixed    <= 1'b0 ;
        ov_rdata        <= 32'b0;
    end
    else begin
        if(rv_midram_rden[2])begin//get data from ram
            o_wr            <= 1'b1;
            ov_addr         <= {6'b0,rv_midram_raddr2};
            o_addr_fixed    <= 1'b0;
            if(!rv_midram_raddr2[0])begin//high 32bit.
                ov_rdata        <= {iv_tsmpforwardram_rdata[33],30'b0,iv_tsmpforwardram_rdata[32]};
            end
            else begin//low 32bit.
                ov_rdata        <= iv_tsmpforwardram_rdata[31:0];
            end
        end           
        else begin
            o_wr            <= 1'b0 ;
            ov_addr         <= 19'b0;
            o_addr_fixed    <= 1'b0 ;
            ov_rdata        <= 32'b0;
        end        
    end
end       
endmodule