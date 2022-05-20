// Copyright (C) 1953-2021 NUDT
// Verilog module name - command_parse_and_encapsulate_flt
// Version: V3.4.0.20220225
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module command_parse_and_encapsulate_flt
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
                          
        ov_tsnforwardram_addr       ,      
        ov_tsnforwardram_wdata      ,      
        o_tsnforwardram_wr          ,      
        iv_tsnforwardram_rdata      ,      
        o_tsnforwardram_rd          ,

        ov_dmacforwardram_addr      ,
        ov_dmacforwardram_wdata     ,
        o_dmacforwardram_wr         ,
        iv_dmacforwardram_rdata     ,
        o_dmacforwardram_rd              
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
output reg [13:0]       ov_tsnforwardram_addr    ;   
output reg [8:0]        ov_tsnforwardram_wdata   ;  
output reg              o_tsnforwardram_wr       ;   
input      [8:0]        iv_tsnforwardram_rdata   ;  
output reg              o_tsnforwardram_rd       ;

output reg [4:0]        ov_dmacforwardram_addr    ;   
output reg [56:0]       ov_dmacforwardram_wdata   ;  
output reg              o_dmacforwardram_wr       ;   
input      [56:0]       iv_dmacforwardram_rdata   ;  
output reg              o_dmacforwardram_rd       ;  
reg                     r_dmacforwardram_addr_high_or_low    ;         
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        ov_tsnforwardram_addr      <= 14'b0  ;
        ov_tsnforwardram_wdata     <= 9'b0   ;
        o_tsnforwardram_wr         <= 1'b0   ;
        o_tsnforwardram_rd         <= 1'b0   ;
        
        ov_dmacforwardram_addr      <= 5'b0    ;
        ov_dmacforwardram_wdata     <= 57'b0   ;
        o_dmacforwardram_wr         <= 1'b0    ;
        o_dmacforwardram_rd         <= 1'b0    ;
        r_dmacforwardram_addr_high_or_low <= 1'b0;      
    end
    else begin
        if(i_wr)begin//write
            if(i_addr_fixed && (iv_addr <= 19'd16383))begin//tsn forward table
                ov_dmacforwardram_addr     <= 5'b0            ;
                o_dmacforwardram_wr        <= 1'b0            ;
                o_dmacforwardram_rd        <= 1'b0            ;  
                       
                ov_tsnforwardram_addr      <= iv_addr[13:0]   ;
                ov_tsnforwardram_wdata     <= iv_wdata[8:0]   ;
                o_tsnforwardram_wr         <= 1'b1            ;
                o_tsnforwardram_rd         <= 1'b0            ;
            end
            else if((!i_addr_fixed) && ((iv_addr >= 19'd16384)&&(iv_addr <= 19'd16447)))begin//mac forward table
                ov_dmacforwardram_addr     <= iv_addr[5:1]                                   ;
                ov_dmacforwardram_wdata    <= {ov_dmacforwardram_wdata[24:0],iv_wdata[31:0]} ;
                o_dmacforwardram_wr        <= iv_addr[0]                                     ;
                o_dmacforwardram_rd        <= 1'b0                                           ;  
                                                                                              
                ov_tsnforwardram_addr      <= 14'b0                                          ;
                o_tsnforwardram_wr         <= 1'b0                                           ;
                o_tsnforwardram_rd         <= 1'b0                                           ;            
            end
            else begin
                ov_tsnforwardram_addr      <= 14'b0  ;
                o_tsnforwardram_wr         <= 1'b0   ;
                o_tsnforwardram_rd         <= 1'b0   ;
                
                ov_dmacforwardram_addr      <= 5'b0    ;
                o_dmacforwardram_wr         <= 1'b0    ;
                o_dmacforwardram_rd         <= 1'b0    ;                
            end
        end
        else if(i_rd)begin//read
            if(i_addr_fixed && (iv_addr <= 19'd16383))begin//tsn forward table
                ov_tsnforwardram_addr      <= iv_addr[13:0]   ;
                o_tsnforwardram_wr         <= 1'b0            ;
                o_tsnforwardram_rd         <= 1'b1            ;
                
                ov_dmacforwardram_addr     <= 5'b0            ;
                o_dmacforwardram_wr        <= 1'b0            ;
                o_dmacforwardram_rd        <= 1'b0            ;                   
            end
            else if((!i_addr_fixed) && ((iv_addr >= 19'd16384)&&(iv_addr <= 19'd16447)))begin//mac forward table
                ov_dmacforwardram_addr     <= iv_addr[5:1]                                   ;
                r_dmacforwardram_addr_high_or_low <= iv_addr[0]; 
                o_dmacforwardram_wr        <= 1'b0                                           ;
                o_dmacforwardram_rd        <= 1'b1                                           ;  
                                                                                              
                ov_tsnforwardram_addr      <= 14'b0                                          ;
                o_tsnforwardram_wr         <= 1'b0                                           ;
                o_tsnforwardram_rd         <= 1'b0                                           ;            
            end            
            else begin
                ov_dmacforwardram_addr     <= 5'b0                                           ;
                o_dmacforwardram_wr        <= 1'b0                                           ;
                o_dmacforwardram_rd        <= 1'b0                                           ;
                
                ov_tsnforwardram_addr      <= 14'b0  ;
                o_tsnforwardram_wr         <= 1'b0   ;
                o_tsnforwardram_rd         <= 1'b0   ;
            end
        end
        else begin
            ov_dmacforwardram_addr     <= 5'b0                                           ;
            o_dmacforwardram_wr        <= 1'b0                                           ;
            o_dmacforwardram_rd        <= 1'b0                                           ;
            
            ov_tsnforwardram_addr      <= 14'b0  ;
            o_tsnforwardram_wr         <= 1'b0   ;
            o_tsnforwardram_rd         <= 1'b0   ;
        end        
    end
end

reg  [2:0]  rv_flowidram_rden;
reg  [13:0] rv_flowidram_raddr0;
reg  [13:0] rv_flowidram_raddr1;
reg  [13:0] rv_flowidram_raddr2;
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        rv_flowidram_rden   <= 3'b0;
        rv_flowidram_raddr0 <= 14'b0;
        rv_flowidram_raddr1 <= 14'b0;
        rv_flowidram_raddr2 <= 14'b0;
    end
    else begin
        rv_flowidram_rden   <= {rv_flowidram_rden[1:0],o_tsnforwardram_rd};
        rv_flowidram_raddr0 <= ov_tsnforwardram_addr;
        rv_flowidram_raddr1 <= rv_flowidram_raddr0;
        rv_flowidram_raddr2 <= rv_flowidram_raddr1;        
    end
end

reg  [2:0]  rv_dmacram_rden;
reg  [5:0]  rv_dmacram_raddr0;
reg  [5:0]  rv_dmacram_raddr1;
reg  [5:0]  rv_dmacram_raddr2;
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        rv_dmacram_rden   <= 3'b0;
        rv_dmacram_raddr0 <= 6'b0;
        rv_dmacram_raddr1 <= 6'b0;
        rv_dmacram_raddr2 <= 6'b0;
    end
    else begin
        rv_dmacram_rden   <= {rv_dmacram_rden[1:0],o_dmacforwardram_rd};
        rv_dmacram_raddr0 <= {ov_dmacforwardram_addr,r_dmacforwardram_addr_high_or_low};
        rv_dmacram_raddr1 <= rv_dmacram_raddr0;
        rv_dmacram_raddr2 <= rv_dmacram_raddr1;        
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
        if(rv_flowidram_rden[2])begin//get data from ram
            o_wr            <= 1'b1;
            ov_addr         <= {5'b0,rv_flowidram_raddr2};
            o_addr_fixed    <= 1'b1;
            ov_rdata        <= {23'b0,iv_tsnforwardram_rdata};
        end           
        else if(rv_dmacram_rden[2])begin
            o_wr            <= 1'b1;
            ov_addr         <= {4'b0,1'b1,8'b0,rv_dmacram_raddr2};
            o_addr_fixed    <= 1'b0;
            if(rv_dmacram_raddr2[0])begin
                ov_rdata    <= iv_dmacforwardram_rdata[31:0];
            end
            else begin//high 25bit
                ov_rdata    <= {7'b0,iv_dmacforwardram_rdata[56:32]};
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