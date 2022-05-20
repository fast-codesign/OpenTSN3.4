// Copyright (C) 1953-2022 NUDT
// Verilog module name - controller_output_schedule
// Version: V3.4.0.20220301
// Created:
//         by - fenglin
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module controller_output_schedule
(
        i_clk              ,
        i_rst_n            ,
       
	    i_fifo_empty_nma   ,
        o_fifo_rden_nma    ,
        iv_fifo_rdata_nma  ,
        
	    i_fifo_empty_osp   ,
        o_fifo_rden_osp    ,
        iv_fifo_rdata_osp  ,

	    i_fifo_empty_tfp   ,
        o_fifo_rden_tfp    ,
        iv_fifo_rdata_tfp  ,          

	    i_fifo_empty_pop   ,
        o_fifo_rden_pop    ,
        iv_fifo_rdata_pop  ,  

        ov_data            ,
        o_data_wr
); 
// I/O
// clk & rst
input                  i_clk            ;
input                  i_rst_n          ; 
// pkt input
input                  i_fifo_empty_nma ;
output reg      	   o_fifo_rden_nma  ;
input	   [8:0] 	   iv_fifo_rdata_nma;
                       
input                  i_fifo_empty_osp ;
output reg      	   o_fifo_rden_osp  ;
input	   [8:0] 	   iv_fifo_rdata_osp;
                       
input                  i_fifo_empty_tfp ;
output reg      	   o_fifo_rden_tfp  ;
input	   [8:0] 	   iv_fifo_rdata_tfp;
                       
input                  i_fifo_empty_pop ;
output reg      	   o_fifo_rden_pop  ;
input	   [8:0] 	   iv_fifo_rdata_pop;

output reg [8:0]	   ov_data          ;
output reg	           o_data_wr        ;

//***************************************************
//               output schedule
//***************************************************
// internal reg&wire for state machine
reg  [3:0]  rv_cos_state;
reg  [3:0]  rv_scheduled_record;//1:scheduled;0:not scheduled.
reg  [6:0]  rv_cycle_cnt;
localparam  IDLE_S         = 4'd0,
            SCHEDULE_NMA_S = 4'd1,
            TRANSMIT_NMA_S = 4'd2,
            SCHEDULE_OSP_S = 4'd3,
            TRANSMIT_OSP_S = 4'd4,
            SCHEDULE_PIP_S = 4'd5,
            TRANSMIT_PIP_S = 4'd6,
            SCHEDULE_POP_S = 4'd7,
            TRANSMIT_POP_S = 4'd8,
            CONTROL_GAP_S  = 4'd9;

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        o_fifo_rden_nma     <= 1'b0;                    
        o_fifo_rden_osp     <= 1'b0;
        o_fifo_rden_tfp     <= 1'b0;
        o_fifo_rden_pop     <= 1'b0;
        ov_data             <= 9'b0;
        o_data_wr           <= 1'b0;
                         
        rv_cycle_cnt        <= 7'b0;
        rv_scheduled_record <= 4'b0;
		rv_cos_state        <= IDLE_S;
    end
    else begin
		case(rv_cos_state)
			IDLE_S:begin 
                ov_data             <= 9'b0;
                o_data_wr           <= 1'b0; 
                rv_cycle_cnt        <= 7'b0;                
                if(!i_fifo_empty_nma)begin
                    o_fifo_rden_nma <= 1'b1; 
                    rv_cos_state    <= SCHEDULE_NMA_S; 
                end
                else if(!i_fifo_empty_osp)begin
                    o_fifo_rden_osp <= 1'b1; 
                    rv_cos_state    <= SCHEDULE_OSP_S; 
                end   
                else if(!i_fifo_empty_tfp)begin
                    o_fifo_rden_tfp <= 1'b1; 
                    rv_cos_state    <= SCHEDULE_PIP_S; 
                end
                else if(!i_fifo_empty_pop)begin
                    o_fifo_rden_pop <= 1'b1; 
                    rv_cos_state    <= SCHEDULE_POP_S; 
                end                
                else begin                  
                    o_fifo_rden_nma     <= 1'b0;                    
                    o_fifo_rden_osp     <= 1'b0;
                    o_fifo_rden_tfp     <= 1'b0;
                    o_fifo_rden_pop     <= 1'b0;
                                     
                    rv_cos_state        <= IDLE_S;
                end                
            end            
            SCHEDULE_NMA_S:begin
                ov_data      <= iv_fifo_rdata_nma;
                o_data_wr    <= 1'b1;          
                rv_cos_state <= TRANSMIT_NMA_S; 
            end
            TRANSMIT_NMA_S:begin
                ov_data      <= iv_fifo_rdata_nma;
                o_data_wr    <= 1'b1;          
                if(iv_fifo_rdata_nma[8])begin//last cycle
                    o_fifo_rden_nma     <= 1'b0; 
                    rv_cos_state        <= CONTROL_GAP_S;
                end
                else begin
                    rv_cos_state <= TRANSMIT_NMA_S;
                end                
            end
            SCHEDULE_OSP_S:begin
                ov_data      <= iv_fifo_rdata_osp;
                o_data_wr    <= 1'b1;          
                rv_cos_state <= TRANSMIT_OSP_S; 
            end
            TRANSMIT_OSP_S:begin
                ov_data      <= iv_fifo_rdata_osp;
                o_data_wr    <= 1'b1;          
                if(iv_fifo_rdata_osp[8])begin//last cycle
                    o_fifo_rden_osp  <= 1'b0;
                    rv_cos_state     <= CONTROL_GAP_S;
                end
                else begin
                    rv_cos_state <= TRANSMIT_OSP_S;
                end                
            end
            SCHEDULE_PIP_S:begin
                ov_data      <= iv_fifo_rdata_tfp;
                o_data_wr    <= 1'b1;          
                rv_cos_state <= TRANSMIT_PIP_S; 
            end
            TRANSMIT_PIP_S:begin
                ov_data      <= iv_fifo_rdata_tfp;
                o_data_wr    <= 1'b1;          
                if(iv_fifo_rdata_tfp[8])begin//last cycle
                    o_fifo_rden_tfp     <= 1'b0;
                    rv_cos_state        <= CONTROL_GAP_S;
                end
                else begin
                    rv_cos_state <= TRANSMIT_PIP_S;
                end                
            end
            SCHEDULE_POP_S:begin
                ov_data      <= iv_fifo_rdata_pop;
                o_data_wr    <= 1'b1;          
                rv_cos_state <= TRANSMIT_POP_S; 
            end
            TRANSMIT_POP_S:begin
                ov_data      <= iv_fifo_rdata_pop;
                o_data_wr    <= 1'b1;          
                if(iv_fifo_rdata_pop[8])begin//last cycle
                    o_fifo_rden_pop     <= 1'b0;
                    rv_cos_state        <= CONTROL_GAP_S;
                end
                else begin
                    rv_cos_state <= TRANSMIT_POP_S;
                end                
            end
            CONTROL_GAP_S:begin
                rv_cycle_cnt <= rv_cycle_cnt + 1'b1;
                ov_data      <= 9'b0;
                o_data_wr    <= 1'b0;                
                if(rv_cycle_cnt == 7'd22)begin
                    rv_cos_state <= IDLE_S;	                
                end
                else begin
                    rv_cos_state <= CONTROL_GAP_S;	     
                end
            end            
			default:begin               
                ov_data      <= 9'b0;
                o_data_wr    <= 1'b0;                
                rv_cos_state <= IDLE_S;	
			end
		endcase
    end
end	
endmodule