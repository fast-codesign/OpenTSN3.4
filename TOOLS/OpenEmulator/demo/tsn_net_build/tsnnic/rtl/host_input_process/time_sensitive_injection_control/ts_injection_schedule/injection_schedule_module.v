// Copyright (C) 1953-2020 NUDT
// Verilog module name - injection_schedule_module 
// Version: ISM_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         schedule descriptor of time-sensitive packet
//             - use a true dual port ram to cache injection slot table; 
//             - schedule descriptor of time-sensitive packet 
//               according to injection slot table and time slot.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module injection_schedule_module
(
       i_clk,
       i_rst_n,
       iv_hardware_stage,
       
       iv_time_slot,
       i_time_slot_switch,
       
       iv_injection_slot_table_wdata,
       i_injection_slot_table_wr,
       iv_injection_slot_table_addr,       
       ov_injection_slot_table_rdata,
       i_injection_slot_table_rd,
       
       i_ts_injection_addr_ack,
       ov_ts_injection_addr,
       o_ts_injection_addr_wr,

       ism_state       
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;  
//configuration finish and time synchronization finish
input      [2:0]       iv_hardware_stage; 
// writting/reading data to ram
input      [15:0]      iv_injection_slot_table_wdata;
input                  i_injection_slot_table_wr;
input      [9:0]       iv_injection_slot_table_addr;
output     [15:0]      ov_injection_slot_table_rdata;
input                  i_injection_slot_table_rd;
// current time slot
input      [9:0]       iv_time_slot;
input                  i_time_slot_switch;
// result of schedule
output reg [4:0]       ov_ts_injection_addr;
output reg             o_ts_injection_addr_wr;
// TIM get ts_injection_addr 
input                  i_ts_injection_addr_ack;  

//***************************************************
//   schedule descriptor of time-sensitive packet
//***************************************************
// internal reg&wire for state machine
wire       [15:0]      wv_ram_portb_rdata;
reg                    r_ram_portb_rd;
reg        [9:0]       rv_ram_portb_addr;

output reg        [2:0]       ism_state;
localparam  WAIT_CFG_FINISH_S = 3'd0,
            PORTB_IDLE_S = 3'd1,
            PORTB_WAIT_FIRST_S = 3'd2,
            PORTB_WAIT_SECOND_S = 3'd3, 
            PORTB_GET_DATA_S = 3'd4,
            PORTB_WAIT_SCHEDULE_S = 3'd5,
            PORTB_WAIT_ACK_S = 3'd6,
            WAIT_NEXT_SLOT_S = 3'd7;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_ram_portb_addr <= 10'b0;
        r_ram_portb_rd <= 1'b0;
        
        o_ts_injection_addr_wr <= 1'b0;
        ov_ts_injection_addr <= 5'b0;
        ism_state <= WAIT_CFG_FINISH_S;
    end
    else begin
        case(ism_state)
            WAIT_CFG_FINISH_S:begin
                if(iv_hardware_stage == 2'd3)begin//configuration finish and time synchronization finish.
                   ism_state <= PORTB_IDLE_S; 
                end
                else begin
                   ism_state <= WAIT_CFG_FINISH_S; 
                end
            end
            PORTB_IDLE_S:begin
                ov_ts_injection_addr <= 5'b0;
                o_ts_injection_addr_wr <= 1'b0;
                
                rv_ram_portb_addr <= rv_ram_portb_addr;//rv_ram_portb_addr need add 1 after each schedule;injection_slot_table_raddr can't asset 0 in IDLE_S.
                r_ram_portb_rd <= 1'b1;
                
                ism_state <= PORTB_WAIT_FIRST_S;
            end
            PORTB_WAIT_FIRST_S:begin  //get data after 2 cycles
                r_ram_portb_rd <= 1'b1;
                rv_ram_portb_addr <= rv_ram_portb_addr;
                
                ism_state <= PORTB_WAIT_SECOND_S;
            end
            PORTB_WAIT_SECOND_S:begin
                r_ram_portb_rd <= 1'b1;
                rv_ram_portb_addr <= rv_ram_portb_addr;
                
                ism_state <= PORTB_GET_DATA_S;
            end
            PORTB_GET_DATA_S:begin
                r_ram_portb_rd <= 1'b0;
                if(wv_ram_portb_rdata[15] == 1'b1)begin  //the entry is valid.
                    rv_ram_portb_addr <= rv_ram_portb_addr + 1'b1;//next address of reading entry from ram.
                    if(wv_ram_portb_rdata[14:5] == iv_time_slot)begin//time slot in the entry is current time slot;output ts_injection_addr in the entry. 
                        ov_ts_injection_addr <= wv_ram_portb_rdata[4:0];
                        o_ts_injection_addr_wr <= 1'b1;
                        
                        ism_state <= PORTB_WAIT_ACK_S;
                    end
                    else begin//time slot in the entry isn't current time slot;wait until time slot in the entry is current time slot. 
                        ism_state <= PORTB_WAIT_SCHEDULE_S;                 
                    end
                end
                else begin //the entry is invalid;read the first entry of injection slot table.
                    rv_ram_portb_addr <= 5'b0;  //read the first entry of injection slot table.
                    ism_state <= WAIT_NEXT_SLOT_S;//when injection table is only a valid entry,in order to avoid the problem of scheduling the entry repeatly in a time slot. 
                end
            end
            PORTB_WAIT_SCHEDULE_S:begin//wait until time slot in the entry is current time slot. 
                if(wv_ram_portb_rdata[14:5] == iv_time_slot)begin
                    ov_ts_injection_addr <= wv_ram_portb_rdata[4:0];
                    o_ts_injection_addr_wr <= 1'b1;
                        
                    ism_state <= PORTB_WAIT_ACK_S;
                end
                else begin
                    ism_state <= PORTB_WAIT_SCHEDULE_S;                 
                end
            end 
            PORTB_WAIT_ACK_S:begin//start next schedule after ts_injection_management_module get the ts injection address
                if(i_ts_injection_addr_ack == 1'b1)begin
                    ov_ts_injection_addr <= 5'd0;
                    o_ts_injection_addr_wr <= 1'b0;
                    ism_state <= PORTB_IDLE_S;
                end
                else begin
                    ism_state <= PORTB_WAIT_ACK_S;                  
                end         
            end
            WAIT_NEXT_SLOT_S:begin
                if(i_time_slot_switch)begin
                    ism_state <= PORTB_IDLE_S;
                end
                else begin
                    ism_state <= WAIT_NEXT_SLOT_S;
                end
            end
            default:begin
                ov_ts_injection_addr <= 5'b0;
                o_ts_injection_addr_wr <= 1'b0;
        
                r_ram_portb_rd <= 1'b0;
        
                ism_state <= PORTB_IDLE_S;
            end
        endcase
   end
end 
suhddpsram1024x16_rq injection_slot_table_buffer
(      
        .aclr(!i_rst_n),                         //asynchronous reset(high active)
        
        .address_a(iv_injection_slot_table_addr),//port A: address
        .address_b(rv_ram_portb_addr),           //port B: address
        
        .clock(i_clk),                           //port A & B: clock
        
        .data_a(iv_injection_slot_table_wdata),  //port A: data input
        .data_b(16'b0),                          //port B: data input
        
        .rden_a(i_injection_slot_table_rd),      //port A: read enable(high active)
        .rden_b(r_ram_portb_rd),                 //port B: read enable(high active)
        
        .wren_a(i_injection_slot_table_wr),      //port A: write enable(high active)
        .wren_b(1'b0),                           //port B: write enable(high active)
        
        .q_a(ov_injection_slot_table_rdata),     //port A: data output
        .q_b(wv_ram_portb_rdata)                 //port B: data output

);                       
endmodule