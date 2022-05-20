// Copyright (C) 1953-2022 NUDT
// Verilog module name - global_registers_management
// Version: V3.4.0.20220225
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module global_registers_management_tse #(parameter tse_ver = 32'h3410)
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
        
        ov_tse_ver               ,
        ov_hardware_stage        ,
        ov_be_threshold_value            , 
        ov_rc_threshold_value            ,
        ov_standardpkt_threshold_value   ,
        o_qbv_or_qch             ,          
        ov_time_slot_length      ,          
        ov_schedule_period                    
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
output      [31:0]      ov_tse_ver                      ;
output reg  [2:0]       ov_hardware_stage               ; 
output reg  [8:0]       ov_be_threshold_value           ; 
output reg  [8:0]       ov_rc_threshold_value           ;
output reg  [8:0]       ov_standardpkt_threshold_value  ;                        
output reg              o_qbv_or_qch          ;
output reg  [10:0]      ov_time_slot_length   ;
output reg  [10:0]      ov_schedule_period    ;
assign  ov_tse_ver = tse_ver;
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin 
        ov_hardware_stage              <= 3'd0    ;
        ov_be_threshold_value          <= 9'b0    ;
        ov_rc_threshold_value          <= 9'b0    ;
        ov_standardpkt_threshold_value <= 9'b0    ;
        o_qbv_or_qch                   <= 1'b1    ;
        ov_time_slot_length            <= 11'd4   ;
        ov_schedule_period             <= 11'd2   ;
                                       
        o_wr                           <= 1'b0    ;
        ov_addr                        <= 19'b0   ;
        o_addr_fixed                   <= 1'b0    ;
        ov_rdata                       <= 32'b0   ;        
    end
    else begin
        if(i_wr)begin//write
            o_wr                  <= 1'b0    ;
            ov_addr               <= 19'b0   ;
            o_addr_fixed          <= 1'b0    ;
            ov_rdata              <= 32'b0   ;   
            if((!i_addr_fixed) && (iv_addr == 19'd0))begin 
                ov_hardware_stage <= iv_wdata[2:0];
            end
            else if(i_addr_fixed && (iv_addr == 19'd0))begin
                ov_rc_threshold_value <= iv_wdata[8:0];
            end
            else if(i_addr_fixed && (iv_addr == 19'd1))begin
                ov_be_threshold_value <= iv_wdata[8:0];
            end
            else if(i_addr_fixed && (iv_addr == 19'd2))begin
                ov_standardpkt_threshold_value <= iv_wdata[8:0];
            end            
            else if(i_addr_fixed && (iv_addr == 19'd3))begin
                o_qbv_or_qch        <= iv_wdata[0]        ;
            end
            else if((i_addr_fixed) && (iv_addr == 19'd4))begin   
                ov_schedule_period  <= iv_wdata[10:0]     ;
            end
            else if((i_addr_fixed) && (iv_addr == 19'd5))begin             
                ov_time_slot_length <= iv_wdata[10:0]     ;
            end           
            else begin
                ov_time_slot_length        <= ov_time_slot_length;   
            end            
        end
        else if(i_rd)begin//read
            if((!i_addr_fixed) && (iv_addr == 19'd0))begin
                o_wr                  <= 1'b1                  ;
                ov_addr               <= iv_addr               ;
                o_addr_fixed          <= i_addr_fixed          ;
                ov_rdata              <= {29'b0,ov_hardware_stage}  ;  
            end
            else if(i_addr_fixed && (iv_addr == 19'd0))begin
                o_wr                  <= 1'b1                        ;
                ov_addr               <= iv_addr                     ;
                o_addr_fixed          <= i_addr_fixed                ;
                ov_rdata              <= {23'b0,ov_rc_threshold_value}  ;  
            end
            else if(i_addr_fixed && (iv_addr == 19'd1))begin
                o_wr                  <= 1'b1                        ;
                ov_addr               <= iv_addr                     ;
                o_addr_fixed          <= i_addr_fixed                ;
                ov_rdata              <= {23'b0,ov_be_threshold_value} ;  
            end
            else if(i_addr_fixed && (iv_addr == 19'd2))begin
                o_wr                  <= 1'b1                        ;
                ov_addr               <= iv_addr                     ;
                o_addr_fixed          <= i_addr_fixed                ;
                ov_rdata              <= {23'b0,ov_standardpkt_threshold_value} ;  
            end
            else if(i_addr_fixed && (iv_addr == 19'd3))begin
                o_wr                  <= 1'b1                        ;
                ov_addr               <= iv_addr                     ;
                o_addr_fixed          <= i_addr_fixed                ;
                ov_rdata              <= {31'b0,o_qbv_or_qch}        ;  
            end 
            else if(i_addr_fixed && (iv_addr == 19'd4))begin
                o_wr                  <= 1'b1                        ;
                ov_addr               <= iv_addr                     ;
                o_addr_fixed          <= i_addr_fixed                ;
                ov_rdata              <= {21'b0,ov_schedule_period}  ;  
            end
            else if(i_addr_fixed && (iv_addr == 19'd5))begin
                o_wr                  <= 1'b1                        ;
                ov_addr               <= iv_addr                     ;
                o_addr_fixed          <= i_addr_fixed                ;
                ov_rdata              <= {21'b0,ov_time_slot_length} ;  
            end             
            else begin
                o_wr                  <= 1'b0    ;
                ov_addr               <= 19'b0   ;
                o_addr_fixed          <= 1'b0    ;
                ov_rdata              <= 32'b0   ;
            end          
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