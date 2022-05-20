// Copyright (C) 1953-2021 NUDT
// Verilog module name - command_parse_and_encapsulate_frm
// Version: V3.4.0.20220402
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module command_parse_and_encapsulate_frm
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

output reg              o_wr            ;          
output reg  [18:0]      ov_addr         ;       
output reg              o_addr_fixed    ;  
output reg  [31:0]      ov_rdata        ;
//configuration                         
output reg [4:0]        ov_ram_addr     ;   
output     [162:0]      ov_ram_wdata    ;  
output reg              o_ram_wr        ;   
input      [162:0]      iv_ram_rdata    ;  
output reg              o_ram_rd        ;

reg        [18:0]       rv_addr         ;
reg        [151:0]      rv_ram_wdata    ;
wire       [151:0]      wv_ram_rdata    ; 
assign  ov_ram_wdata = o_ram_wr ? {1'b1,16'b0,rv_ram_wdata[148:40],rv_ram_wdata[36:0]}:163'b0;
assign  wv_ram_rdata = {3'b0,iv_ram_rdata[145:37],3'b0,iv_ram_rdata[36:0]};
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin            
        ov_ram_addr           <= 5'b0    ;
        rv_ram_wdata          <= 146'b0  ;
        o_ram_wr              <= 1'b0    ;
        o_ram_rd              <= 1'b0    ;       
        rv_addr               <= 19'b0   ;
    end
    else begin
        if(i_wr)begin//write
            o_ram_rd             <= 1'b0                            ;
            rv_addr              <= 19'b0                           ;
            if((i_addr_fixed == 1'b1) && (iv_addr <= 19'd255))begin
                rv_ram_wdata         <= {rv_ram_wdata[119:0],iv_wdata}  ;
                ov_ram_addr          <= iv_addr[7:3]                   ;
                if(iv_addr[2:0] == 3'd7)begin
                    o_ram_wr              <= 1'b1                   ; 
                end
                else begin
                    o_ram_wr              <= 1'b0                   ; 
                end                
            end
            else begin
                ov_ram_addr      <= 5'b0                            ;
                rv_ram_wdata     <= rv_ram_wdata                    ;
                o_ram_wr         <= 1'b0                            ;
            end                                                     
        end                                                         
        else if(i_rd)begin//read                                    
            o_ram_wr             <= 1'b0                            ;
            if((i_addr_fixed == 1'b1) && (iv_addr <= 19'd255))begin
                ov_ram_addr      <= iv_addr[7:3]                    ;                
                o_ram_rd         <= 1'b1                            ;
                
                rv_addr          <= iv_addr                         ;
            end                                                     
            else begin                                              
                ov_ram_addr      <= 5'b0                            ;                
                o_ram_rd         <= 1'b0                            ;
                
                rv_addr          <= 19'b0                           ;
            end                                                     
        end                                                         
        else begin                                                  
            ov_ram_addr          <= 5'b0                            ; 
            o_ram_wr             <= 1'b0                            ;                
            o_ram_rd             <= 1'b0                            ;
            
            rv_addr              <= 19'b0                           ;
        end        
    end
end

reg  [2:0]   rv_ram_rden;
reg  [18:0]  rv_ram_raddr0;
reg  [18:0]  rv_ram_raddr1;
reg  [18:0]  rv_ram_raddr2;
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        rv_ram_rden   <= 3'b0;
        rv_ram_raddr0 <= 19'b0;
        rv_ram_raddr1 <= 19'b0;
        rv_ram_raddr2 <= 19'b0;
    end
    else begin
        rv_ram_rden   <= {rv_ram_rden[1:0],o_ram_rd};
        rv_ram_raddr0 <= rv_addr;
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
            o_wr                  <= 1'b1                                ;
            ov_addr               <= rv_ram_raddr2                       ;
            o_addr_fixed          <= 1'b1                                ;
            case(rv_ram_raddr2[2:0])
                3'd0:begin
                    ov_rdata      <=   32'b0                             ;
                end                                                      
                3'd1:begin                                               
                    ov_rdata      <=   32'b0                             ;
                end                                                      
                3'd2:begin                                               
                    ov_rdata      <=   32'b0                             ;
                end 
                3'd3:begin
                    ov_rdata      <=   {8'b0,wv_ram_rdata[151:128]}     ;
                end 
                3'd4:begin
                    ov_rdata      <=   wv_ram_rdata[127:96]              ;
                end                                                        
                3'd5:begin                                                 
                    ov_rdata      <=   wv_ram_rdata[95:64]               ;
                end                                                        
                3'd6:begin                                                 
                    ov_rdata      <=   wv_ram_rdata[63:32]               ;
                end                                                        
                3'd7:begin                                                 
                    ov_rdata      <=   wv_ram_rdata[31:0]                ;
                end                                                      
                default:begin                                            
                    ov_rdata      <=   32'b0                             ;
                end
            endcase            
        end
        else begin
            o_wr                  <= 1'b0                                ;
            ov_addr               <= 19'b0                               ;
            o_addr_fixed          <= 1'b0                                ;
            ov_rdata              <= 32'b0                               ;
        end        
    end
end       
endmodule