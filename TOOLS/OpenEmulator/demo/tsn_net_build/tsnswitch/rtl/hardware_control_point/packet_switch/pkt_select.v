// Copyright (C) 1953-2022 NUDT
// Verilog module name - pkt_select 
// Version: V3.4.1.20220406
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//          
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module pkt_select
(
        i_clk,
        i_rst_n,

        i_data_wr_cpu,
        iv_data_cpu,

        i_data_wr_hcp,
        iv_data_hcp,         

        o_data_wr,
        ov_data      
);

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
// pkt input
input                   i_data_wr_cpu;
input       [7:0]       iv_data_cpu  ;
input                   i_data_wr_hcp;
input       [7:0]       iv_data_hcp  ;
// pkt output
output  reg [7:0]       ov_data               ;
output  reg             o_data_wr             ;

wire                    w_data_wr_cpu         ;
wire        [8:0]       wv_data_cpu           ;
wire                    w_data_wr_hcp         ;
wire        [8:0]       wv_data_hcp           ;

reg                     r_data_fifo_rden_cpu  ; 
wire        [8:0]       wv_data_fifo_rdata_cpu;
wire                    w_data_fifo_empty_cpu ;
                        
reg                     r_data_fifo_rden_hcp  ; 
wire        [8:0]       wv_data_fifo_rdata_hcp;
wire                    w_data_fifo_empty_hcp ; 
head_and_tail_add head_and_tail_add_cpu
(
.i_clk       (i_clk  ),
.i_rst_n     (i_rst_n),

.i_data_wr   (i_data_wr_cpu),
.iv_data     (iv_data_cpu  ),

.ov_data     (wv_data_cpu  ),
.o_data_wr   (w_data_wr_cpu)
);

head_and_tail_add head_and_tail_add_hcp
(
.i_clk       (i_clk  ),
.i_rst_n     (i_rst_n),

.i_data_wr   (i_data_wr_hcp),
.iv_data     (iv_data_hcp  ),

.ov_data     (wv_data_hcp  ),
.o_data_wr   (w_data_wr_hcp)
);
//***************************************************
//               output schedule
//***************************************************
// internal reg&wire for state machine
reg  [6:0]  rv_cycle_cnt;
reg  [3:0]  rv_schedule_state;
reg  [1:0]  rv_scheduled_record;//1:scheduled;0:not scheduled.
localparam  IDLE_S              = 4'd0,
            SCHEDULE_DATA_CPU_S = 4'd1,
            TRANSMIT_DATA_CPU_S = 4'd2,
            SCHEDULE_DATA_HCP_S = 4'd3,
            TRANSMIT_DATA_HCP_S = 4'd4,
            CONTROL_GAP_S       = 4'd5;

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        r_data_fifo_rden_cpu     <= 1'b0;                    
        r_data_fifo_rden_hcp     <= 1'b0;

        ov_data                  <= 8'b0;
        o_data_wr                <= 1'b0;
                         
        rv_scheduled_record      <= 2'b0;
        rv_cycle_cnt             <= 7'b0;
		rv_schedule_state        <= IDLE_S;
    end
    else begin
		case(rv_schedule_state)
			IDLE_S:begin 
                ov_data             <= 8'b0;
                o_data_wr           <= 1'b0; 
                rv_cycle_cnt        <= 7'b0;                
                if(!w_data_fifo_empty_cpu)begin
                    r_data_fifo_rden_cpu <= 1'b1; 
                    rv_schedule_state    <= SCHEDULE_DATA_CPU_S; 
                end
                else if(!w_data_fifo_empty_hcp)begin
                    r_data_fifo_rden_hcp <= 1'b1; 
                    rv_schedule_state    <= SCHEDULE_DATA_HCP_S; 
                end                  
                else begin                  
                    r_data_fifo_rden_cpu     <= 1'b0;                    
                    r_data_fifo_rden_hcp     <= 1'b0;
                                     
                    rv_schedule_state        <= IDLE_S;
                end                
            end            
            SCHEDULE_DATA_CPU_S:begin
                ov_data      <= wv_data_fifo_rdata_cpu[7:0];
                o_data_wr    <= 1'b1;          
                rv_schedule_state <= TRANSMIT_DATA_CPU_S; 
            end
            TRANSMIT_DATA_CPU_S:begin
                ov_data      <= wv_data_fifo_rdata_cpu[7:0];
                o_data_wr    <= 1'b1;          
                if(wv_data_fifo_rdata_cpu[8])begin//last cycle
                    r_data_fifo_rden_cpu  <= 1'b0;
                    rv_schedule_state     <= CONTROL_GAP_S;
                end
                else begin
                    rv_schedule_state <= TRANSMIT_DATA_CPU_S;
                end                
            end
            SCHEDULE_DATA_HCP_S:begin
                ov_data      <= wv_data_fifo_rdata_hcp[7:0];
                o_data_wr    <= 1'b1;          
                rv_schedule_state <= TRANSMIT_DATA_HCP_S; 
            end
            TRANSMIT_DATA_HCP_S:begin
                ov_data      <= wv_data_fifo_rdata_hcp[7:0];
                o_data_wr    <= 1'b1;          
                if(wv_data_fifo_rdata_hcp[8])begin//last cycle
                    r_data_fifo_rden_hcp <= 1'b0;
                    rv_schedule_state    <= CONTROL_GAP_S;
                end
                else begin
                    rv_schedule_state <= TRANSMIT_DATA_HCP_S;
                end                
            end
            CONTROL_GAP_S:begin
                rv_cycle_cnt <= rv_cycle_cnt + 1'b1;
                ov_data      <= 8'b0;
                o_data_wr    <= 1'b0;                
                if(rv_cycle_cnt == 7'd22)begin
                    rv_schedule_state <= IDLE_S;	                
                end
                else begin
                    rv_schedule_state <= CONTROL_GAP_S;	     
                end
            end            
			default:begin               
                ov_data           <= 8'b0;
                o_data_wr         <= 1'b0;                
                rv_schedule_state <= IDLE_S;	
			end
		endcase
    end
end	
   
syncfifo_showahead_aclr_w9d256 cpu_packet_cache_inst(
    .data  (wv_data_cpu           ), 
    .wrreq (w_data_wr_cpu         ),
    .rdreq (r_data_fifo_rden_cpu  ),
    .clock (i_clk                 ),
    .aclr  (!i_rst_n              ), 
    .q     (wv_data_fifo_rdata_cpu),    
    .usedw (                      ),
    .full  (                      ), 
    .empty (w_data_fifo_empty_cpu ) 
);
syncfifo_showahead_aclr_w9d256 hcp_packet_cache_inst(
    .data  (wv_data_hcp           ), 
    .wrreq (w_data_wr_hcp         ),
    .rdreq (r_data_fifo_rden_hcp  ),
    .clock (i_clk                 ),
    .aclr  (!i_rst_n              ), 
    .q     (wv_data_fifo_rdata_hcp),    
    .usedw (                      ),
    .full  (                      ), 
    .empty (w_data_fifo_empty_hcp ) 
);
endmodule