// Copyright (C) 1953-2021 NUDT
// Verilog module name - command_parse_and_encapsulate_fim
// Version: V3.3.0.20211126
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module command_parse_and_encapsulate_fim
(
        i_clk                   ,       
        i_rst_n                 ,      
                     
        iv_addr                 ,         
        i_addr_fixed            ,        
        iv_wdata                ,         
        i_wr_fim                ,      
        i_rd_fim                ,      
             
        o_wr_fim                ,      
        ov_addr_fim             ,      
        o_addr_fixed_fim        ,      
        ov_rdata_fim            ,      
                         
        ov_inversemap_ram_wdata    ,
        ov_inversemap_ram_wr       ,
        ov_inversemap_ram_addr     ,
        iv_inversemap_ram_rdata    ,
        ov_inversemap_ram_rd               
);

// I/O
// clk & rst
input                   i_clk                          ;
input                   i_rst_n                        ;
                                                       
input       [18:0]      iv_addr                        ;                    
input                   i_addr_fixed                   ;        
input       [31:0]      iv_wdata                       ;         
input                   i_wr_fim                       ;
input                   i_rd_fim                       ;

output reg              o_wr_fim                       ;
output reg  [18:0]      ov_addr_fim                    ;
output reg              o_addr_fixed_fim               ;
output reg  [31:0]      ov_rdata_fim                   ;
//configuration                                        
output reg  [59:0]	    ov_inversemap_ram_wdata        ;
output reg  	        ov_inversemap_ram_wr           ;
output reg  [7:0]	    ov_inversemap_ram_addr         ;
input       [59:0]      iv_inversemap_ram_rdata        ;
output reg              ov_inversemap_ram_rd           ; 
//read,write    
reg         [8:0]       rv_ram_raddr;
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        ov_inversemap_ram_wdata     <= 60'b0  ;
        ov_inversemap_ram_wr        <= 1'b0   ;
        ov_inversemap_ram_addr      <= 8'b0   ;
        ov_inversemap_ram_rd        <= 1'b0   ;
        
        rv_ram_raddr                <= 9'b0   ;
    end
    else begin
        if(i_wr_fim)begin//write
            rv_ram_raddr                <= 9'b0   ;
            if(i_addr_fixed && (iv_addr <= 19'd63))begin
                ov_inversemap_ram_wdata     <= {ov_inversemap_ram_wdata[31:0],iv_wdata}    ;
                ov_inversemap_ram_wr        <= iv_addr[0]                               ;
                ov_inversemap_ram_addr      <= iv_addr[8:1]                             ;
                ov_inversemap_ram_rd        <= 1'b0                                     ;
            end
            else begin
                ov_inversemap_ram_wr        <= 1'b0   ;
                ov_inversemap_ram_addr      <= 8'b0   ;
                ov_inversemap_ram_rd        <= 1'b0   ;       
            end
        end
        else if(i_rd_fim)begin//read
            if(i_addr_fixed && (iv_addr <= 19'd63))begin
                ov_inversemap_ram_wr        <= 1'b0                                     ;
                ov_inversemap_ram_addr      <= iv_addr[8:1]                             ;
                ov_inversemap_ram_rd        <= 1'b1                                     ;
                rv_ram_raddr                <= iv_addr[8:0]                             ;
            end           
            else begin
                ov_inversemap_ram_wr        <= 1'b0   ;
                ov_inversemap_ram_addr      <= 8'b0   ;
                ov_inversemap_ram_rd        <= 1'b0   ; 
                rv_ram_raddr                <= 9'b0   ;
            end
        end
        else begin
            ov_inversemap_ram_wr        <= 1'b0   ;
            ov_inversemap_ram_addr      <= 8'b0   ;
            ov_inversemap_ram_rd        <= 1'b0   ;

            rv_ram_raddr                <= 9'b0   ;            
        end        
    end
end
//get data   
reg  [2:0] rv_ram_rden;
reg  [8:0] rv_ram_raddr0;
reg  [8:0] rv_ram_raddr1;
reg  [8:0] rv_ram_raddr2;
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        rv_ram_rden   <= 3'b0;
        rv_ram_raddr0 <= 9'b0;
        rv_ram_raddr1 <= 9'b0;
        rv_ram_raddr2 <= 9'b0;
    end
    else begin
        rv_ram_rden   <= {rv_ram_rden[1:0],ov_inversemap_ram_rd};
        rv_ram_raddr0 <= rv_ram_raddr;
        rv_ram_raddr1 <= rv_ram_raddr0;
        rv_ram_raddr2 <= rv_ram_raddr1;        
    end
end

always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        o_wr_fim           <= 1'b0;
        ov_addr_fim        <= 19'b0;
        o_addr_fixed_fim   <= 1'b0;
        ov_rdata_fim       <= 32'b0;
    end
    else begin
        if(rv_ram_rden[2])begin//get data from ram
            if(rv_ram_raddr2[0] == 1'b0)begin//high
                o_wr_fim           <= 1'b1;
                ov_addr_fim        <= {10'b0,rv_ram_raddr2};
                o_addr_fixed_fim   <= 1'b1;
                ov_rdata_fim       <= {4'b0,iv_inversemap_ram_rdata[59:32]};
            end           
            else begin//low
                o_wr_fim           <= 1'b1;
                ov_addr_fim        <= {10'b0,rv_ram_raddr2};
                o_addr_fixed_fim   <= 1'b1;
                ov_rdata_fim       <= iv_inversemap_ram_rdata[31:0];
            end
        end
        else begin
            o_wr_fim           <= 1'b0;
            ov_addr_fim        <= 19'b0;
            o_addr_fixed_fim   <= 1'b0;
            ov_rdata_fim       <= 32'b0;
        end        
    end
end       
endmodule