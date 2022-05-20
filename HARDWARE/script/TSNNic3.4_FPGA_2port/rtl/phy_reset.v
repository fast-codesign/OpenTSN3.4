// Copyright (C) 1953-2020 NUDT
// Verilog module name - phy_reset
// Version: PST.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module phy_reset
(
        clk ,
        reset,
        
        init_done,
        autoneg_success,
        
        phy_reset_over
);

input       clk ;
input       reset ;

input       init_done;
input       autoneg_success;

output     phy_reset_over ; 

reg     phy_reset_over;


reg [1:0]   cur_state;
parameter   idle = 2'h0 ;
parameter   auto = 2'h1 ;
parameter   rese= 2'h2 ;
parameter   done = 2'h3 ;

reg [31:0]   reset_counter ;

always@(posedge clk or negedge reset)
    if( ~ reset)begin 
        cur_state <= idle ;
        phy_reset_over <= 1'b0 ;
        reset_counter <= 10'd0 ;
    end
    else    begin 
        case(cur_state)
            idle:
            begin 
                if(init_done)begin 
                    cur_state <= auto ;
                    phy_reset_over <= 1'b1 ;
                    reset_counter <= 22'd0 ;
                end
                else    begin 
                    cur_state <= idle ;
                    phy_reset_over <= 1'b1 ;
                    reset_counter <= 22'd0 ;
                end
            end
            auto:
            begin 
                if(reset_counter == 32'h23C34600)begin 
                    if(autoneg_success)
                       cur_state <= done ;
                    else
                       cur_state <= rese ;
                    reset_counter <= 32'd0 ;
                end
                else    begin
                    cur_state <= auto ;
                           reset_counter <= reset_counter + 10'd1 ;
                    end
            end
            rese:
            begin 
                if(reset_counter == 32'h0ff)begin 
                    cur_state <= idle ;
                    phy_reset_over <= 1'b1 ;
                    reset_counter <= 10'd0 ;
                end
                else    begin
                    cur_state <= rese ;
                    phy_reset_over <= 1'b0 ;
                    reset_counter <= reset_counter + 10'd1 ;
                end
            end
            done:
            begin 
                if(autoneg_success)
                  cur_state <= done ;
                else
                  cur_state <= idle ;
                phy_reset_over <= 1'b1 ;
                reset_counter <= 22'd0 ;
            end
        endcase
    end


endmodule
