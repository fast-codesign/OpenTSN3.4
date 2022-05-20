// Copyright (C) 1953-2020 NUDT
// Verilog module name - sgmii_config 
// Version: sgmii_config_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
//               
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module  sgmii_config (
        clk             ,
        reset           ,
        reg_data_out    ,   
        reg_rd          ,   
        reg_data_in     ,
        reg_wr          ,   
        reg_busy        ,   
        reg_addr        ,

        led_link        ,
        led_an
);
input               clk             ;
input               reset           ;
input   [15:0]      reg_data_out    ;   
output              reg_rd          ;   
output  [15:0]      reg_data_in     ;
output              reg_wr          ;   
input               reg_busy        ;   
output  [4:0]       reg_addr        ;

input               led_link        ;
input               led_an          ;

////////////////////////////////////////////

reg                 reg_rd      ;
reg     [15:0]      reg_data_in ;
reg                 reg_wr      ;
reg     [4:0]       reg_addr    ;

reg     [3:0]       cur_state   ;
localparam  idle                = 4'd0 ,
            pcs_autoneg_timer0  = 4'd1 ,
            pcs_autoneg_timer1  = 4'd2 ,
            sgmii_autoneg       = 4'd3 ,
            sgmii_autoneg_en    = 4'd4 ,
            sgmii_reset         = 4'd5 ,
            wait_sgmii_reseted  = 4'd6 ,
            config_done         = 4'd7;

////////////////////////////////////////////

always@(posedge clk or negedge reset)
    if( ~ reset)begin
        reg_rd      <= 1'b0  ;
        reg_data_in <= 16'd0 ;
        reg_wr      <= 1'b0  ;
        reg_addr    <= 5'd0  ;
        cur_state   <= idle  ;
    end
    else    begin 
        case(cur_state)
            idle    : begin 
                if( reg_busy)begin
                    reg_wr      <= 1'b0 ;
                    reg_data_in <= 16'h0000 ;
                    reg_addr[4:0]   <= 5'h00 ;
                    cur_state   <= pcs_autoneg_timer0 ;
                end
                else    begin 
                    reg_rd      <= 1'b0  ;
                    reg_data_in <= 16'd0 ;
                    reg_wr      <= 1'b0  ;
                    reg_addr[4:0]   <= 5'd0  ;
                    cur_state   <= idle  ;
                end
            end
            pcs_autoneg_timer0: begin 
                if(reg_busy)begin 
                    reg_wr      <= 1'b1 ;
                    reg_data_in <= 16'h0d40 ;//link_timer0
                    reg_addr[4:0]   <= 5'h12 ;//0x12
                    cur_state   <= pcs_autoneg_timer0 ;
                end
                else    begin 
                    reg_rd      <= 1'b0  ;
                    reg_data_in <= 16'h0000 ;
                    reg_wr      <= 1'b0  ;
                    reg_addr[4:0]   <= 5'h00  ;
                    cur_state   <= pcs_autoneg_timer1 ;
                end
            end
            pcs_autoneg_timer1: begin 
                if(reg_busy)begin 
                    reg_rd      <= 1'b0  ;
                    reg_data_in <= 16'h0003 ;//link_timer1
                    reg_wr      <= 1'b1  ;
                    reg_addr[4:0]   <= 5'h13  ;//0x13
                    cur_state   <= pcs_autoneg_timer1 ;
                end
                else    begin 
                    reg_wr      <= 1'b0 ;
                    reg_data_in <= 16'h0000 ;
                    reg_addr[4:0]   <= 5'h00 ;
                    cur_state   <= sgmii_autoneg ;
                end
            end
            sgmii_autoneg: begin 
                if(reg_busy)begin 
                    reg_rd      <= 1'b0  ;
                    reg_data_in <= 16'h0003 ;//if_mode
                    reg_wr      <= 1'b1  ;
                    reg_addr[4:0]   <= 5'h14  ;//0x14
                    cur_state   <= sgmii_autoneg ;
                end
                else    begin 
                    
                    reg_wr      <= 1'b0 ;
                    reg_data_in <= 16'h0000 ;
                    reg_addr[4:0]   <= 5'h00 ;
                    cur_state   <= sgmii_autoneg_en ;
                end
            end
            sgmii_autoneg_en: begin 
                if(reg_busy)begin 
                    reg_rd      <= 1'b0  ;
                    reg_data_in <= 16'h1140 ;//control
                    reg_wr      <= 1'b1  ;
                    reg_addr[4:0]   <= 5'h00  ;//0x00
                    cur_state   <= sgmii_autoneg_en ;
                end
                else    begin 
                    
                    reg_wr      <= 1'b0 ;
                    reg_data_in <= 16'h0000 ;
                    reg_addr[4:0]   <= 5'h00 ;
                    cur_state   <= sgmii_reset ;
                    
                end
            end
            
            sgmii_reset: begin 
                if(reg_busy)begin 
                    reg_rd      <= 1'b0  ;
                    reg_data_in <= 16'h_9140 ;//control
                    reg_wr      <= 1'b1  ;
                    reg_addr[4:0]   <= 5'h00  ;//0x00
                    cur_state   <= sgmii_reset ;
                end
                else    begin 
                    
                    reg_wr      <= 1'b0 ;
                    reg_data_in <= 16'h0000 ;
                    reg_addr[4:0]   <= 5'h00 ;
                    cur_state   <= wait_sgmii_reseted ;
                end 
            end
            wait_sgmii_reseted: begin 
                if(reg_busy)begin 
                    reg_rd      <= 1'b1  ;
                    reg_data_in <= 16'h0000 ; 
                    reg_wr      <= 1'b0  ;
                    reg_addr[4:0]   <= 5'h00  ;
                    cur_state   <= wait_sgmii_reseted ;
                end
                else    begin 
                    reg_wr      <= 1'b0 ;
                    reg_data_in <= 16'h0000 ;
                    reg_addr[4:0]   <= 5'h00 ;
                    if(reg_data_out == 16'h1140)
                        cur_state   <= config_done ;
                    else
                        cur_state   <= wait_sgmii_reseted ;
                end 
            end
            
            config_done: begin
            
                    reg_rd      <= 1'b1  ;
                    reg_data_in <= 16'd0 ;
                    reg_wr      <= 1'b0  ;
                    reg_addr[4:0]   <= 5'h00 ;
            if(reg_data_out == 16'h0040)
                    cur_state   <=idle   ;
            else
               cur_state    <=  config_done  ;
            end
            default: ;
        endcase
    end

////////////////////////////////////////////

endmodule
/*
sgmii_config  #(
    .CHANNEL(1)
)sgmii_config_inst(
    .clk            (SYS2MGMT_clk),
    .reset          (~SYS2CORE_rst_n),
    .reg_data_out   (reg_data_out), 
    .reg_rd         (reg_rd),   
    .reg_data_in    (reg_data_in),
    .reg_wr         (reg_wr),   
    .reg_busy       (reg_busy), 
    .reg_addr       (reg_addr),
    .led_link       (),
    .led_an         ()
);
*/