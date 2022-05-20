// Copyright (C) 1953-2022 NUDT
// Verilog module name - command_parse_and_encapsulate_ost 
// Version: V3.4.0.20220226
// Created:
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module command_parse_and_encapsulate_ost
#(
  parameter ost_ver   = 8'h34,
  parameter osm_ver   = 8'h34
)
(
        i_clk  ,
        i_rst_n,
        
        i_tsn_or_tte,

        i_stc_wr,
        iv_stc_wdata,
        iv_stc_addr,
        i_stc_addr_fixed,        
        i_stc_rd,
       
        o_stc_wr, 
        ov_stc_rdata,
        ov_stc_raddr,
        o_stc_addr_fixed,
        
        ov_os_cid              ,
        ov_syn_clock_set       ,
        ov_reference_pit       ,
        o_syn_clock_set_wr     ,
        ov_syn_clock_cycle     ,
        ov_phase_cor           ,
        o_phase_cor_wr         ,
        ov_frequency_cor       ,
        o_frequency_cor_wr       
);
// I/O
// i_clk & rst
input                  i_clk       ;
input                  i_rst_n     ;

input                  i_tsn_or_tte;//0:as6802;1:ptp

input                  i_stc_wr    ;
input      [31:0]      iv_stc_wdata;
input      [18:0]      iv_stc_addr ; 
input                  i_stc_addr_fixed;        
input                  i_stc_rd    ;
output reg             o_stc_wr    ; 
output reg [31:0]      ov_stc_rdata;  
output reg [18:0]      ov_stc_raddr;
output reg             o_stc_addr_fixed;  

output reg [11:0]      ov_os_cid             ; 
output reg [63:0]      ov_syn_clock_set      ;
output reg [31:0]      ov_reference_pit      ;
output reg             o_syn_clock_set_wr    ;
output reg [31:0]      ov_syn_clock_cycle    ;
output reg [31:0]      ov_phase_cor          ;
output reg             o_phase_cor_wr        ;
output reg [31:0]      ov_frequency_cor      ;
output reg             o_frequency_cor_wr    ;
//***************************************************
//               command parse
//***************************************************
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin       
        o_stc_wr              <= 1'b0 ;
        ov_stc_rdata          <= 32'b0;
        ov_stc_raddr          <= 19'b0;
        o_stc_addr_fixed      <= 1'b0 ;
        
        ov_os_cid             <= 12'b0;
        ov_syn_clock_set      <= 64'b0;
        ov_reference_pit      <= 32'b0;
        o_syn_clock_set_wr    <= 1'b0 ;
        ov_syn_clock_cycle    <= 32'h0;//32'h0
        ov_phase_cor          <= 32'b0;
        o_phase_cor_wr        <= 1'b0 ;     
        ov_frequency_cor      <= {8'h8,24'h0};      
        o_frequency_cor_wr    <= 1'b0 ;    
    end
    else begin
        if(i_stc_wr)begin
            o_stc_wr          <= 1'b0;
            ov_stc_rdata      <= 32'b0;
            ov_stc_raddr      <= 19'b0;
            if((!i_stc_addr_fixed) && (iv_stc_addr == 19'd1))begin
                ov_os_cid                     <= iv_stc_wdata[11:0];
            end
            else if((!i_stc_addr_fixed) && (iv_stc_addr == 19'd2))begin
                ov_syn_clock_set[63:32]       <= iv_stc_wdata;
                o_syn_clock_set_wr            <= 1'b0; 
            end
            else if((!i_stc_addr_fixed) && (iv_stc_addr == 19'd3))begin
                ov_syn_clock_set[31:0]        <= iv_stc_wdata;
                o_syn_clock_set_wr            <= 1'b0;             
            end
            else if((!i_stc_addr_fixed) && (iv_stc_addr == 19'd4))begin
                ov_reference_pit              <= iv_stc_wdata;
                o_syn_clock_set_wr            <= 1'b1;             
            end
            else if((!i_stc_addr_fixed) && (iv_stc_addr == 19'd5))begin
                ov_syn_clock_cycle            <= iv_stc_wdata;
                o_syn_clock_set_wr            <= 1'b0;             
            end
            else if((!i_stc_addr_fixed) && (iv_stc_addr == 19'd6))begin
                ov_phase_cor                 <= iv_stc_wdata;
                o_phase_cor_wr               <= 1'b1;
                o_syn_clock_set_wr           <= 1'b0;                
            end
            else if((!i_stc_addr_fixed) && (iv_stc_addr == 19'd7))begin
                ov_frequency_cor                <= iv_stc_wdata;      
                o_frequency_cor_wr              <= 1'b1; 
                o_phase_cor_wr                  <= 1'b0;
                o_syn_clock_set_wr              <= 1'b0;             
            end                        
            else begin
                o_frequency_cor_wr              <= 1'b0; 
                o_phase_cor_wr                  <= 1'b0;
                o_syn_clock_set_wr              <= 1'b0;  
            end
        end      
        else if(i_stc_rd)begin
            if((!i_stc_addr_fixed) && (iv_stc_addr == 19'd0))begin
                o_stc_wr          <= 1'b1;
                ov_stc_rdata      <= {i_tsn_or_tte,15'b0,ost_ver,osm_ver} ;
                ov_stc_raddr      <= iv_stc_addr;
                o_stc_addr_fixed  <= i_stc_addr_fixed;            
            end
            else if((!i_stc_addr_fixed) && (iv_stc_addr == 19'd1))begin
                o_stc_wr          <= 1'b1;
                ov_stc_rdata      <= {20'b0,ov_os_cid};
                ov_stc_raddr      <= iv_stc_addr;
                o_stc_addr_fixed  <= i_stc_addr_fixed;            
            end
            else if((!i_stc_addr_fixed) && (iv_stc_addr == 19'd2))begin
                o_stc_wr          <= 1'b1;
                ov_stc_rdata      <= ov_syn_clock_set[63:32];
                ov_stc_raddr      <= iv_stc_addr;
                o_stc_addr_fixed  <= i_stc_addr_fixed;
            end
            else if((!i_stc_addr_fixed) && (iv_stc_addr == 19'd3))begin
                o_stc_wr          <= 1'b1;
                ov_stc_rdata      <= ov_syn_clock_set[31:0];
                ov_stc_raddr      <= iv_stc_addr;
                o_stc_addr_fixed  <= i_stc_addr_fixed;
            end
            else if((!i_stc_addr_fixed) && (iv_stc_addr == 19'd4))begin
                o_stc_wr          <= 1'b1;
                ov_stc_rdata      <= ov_reference_pit;
                ov_stc_raddr      <= iv_stc_addr;
                o_stc_addr_fixed  <= i_stc_addr_fixed;
            end
            else if((!i_stc_addr_fixed) && (iv_stc_addr == 19'd5))begin
                o_stc_wr          <= 1'b1;
                ov_stc_rdata      <= ov_syn_clock_cycle;
                ov_stc_raddr      <= iv_stc_addr;
                o_stc_addr_fixed  <= i_stc_addr_fixed;
            end
            else if((!i_stc_addr_fixed) && (iv_stc_addr == 19'd6))begin
                o_stc_wr          <= 1'b1;
                ov_stc_rdata      <= ov_phase_cor;
                ov_stc_raddr      <= iv_stc_addr;
                o_stc_addr_fixed  <= i_stc_addr_fixed;
            end
            else if((!i_stc_addr_fixed) && (iv_stc_addr == 19'd7))begin
                o_stc_wr          <= 1'b1;
                ov_stc_rdata      <= ov_frequency_cor;
                ov_stc_raddr      <= iv_stc_addr;
                o_stc_addr_fixed  <= i_stc_addr_fixed;
            end           
            else begin
                o_stc_wr          <= 1'b0;
                ov_stc_rdata      <= 32'b0;
                ov_stc_raddr      <= 19'b0;
                o_stc_addr_fixed  <= 1'b0;
            end            
        end
        else begin
            o_frequency_cor_wr              <= 1'b0; 
            o_phase_cor_wr                  <= 1'b0;
            o_syn_clock_set_wr              <= 1'b0;    
                
            o_stc_wr                        <= 1'b0;
            ov_stc_rdata                    <= 32'b0;
            ov_stc_raddr                    <= 19'b0;
            o_stc_addr_fixed                <= 1'b0;          
        end
    end
end    
endmodule
    