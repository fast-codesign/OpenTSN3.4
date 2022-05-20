// Copyright (C) 1953-2020 NUDT
// Verilog module name - gate_control
// Version: GC_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         use RAM to cahce the gate control list
//         time slot are calculated according to the global clock
//         read the gate control vector according to the time slot 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module gate_control
(
       i_clk,
       i_rst_n, 

       ov_in_gate_ctrl_vector,
       ov_out_gate_ctrl_vector,
       
       iv_ram_rdata,
       ov_ram_raddr,
       o_ram_rd,
       
       i_qbv_or_qch,
       iv_time_slot,
       i_time_slot_switch
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
// gate control vector to network_input_queue and network_output_schedule
output reg [1:0]       ov_in_gate_ctrl_vector; 
output reg [7:0]       ov_out_gate_ctrl_vector; 
// read addr form/to out_RAM
input      [7:0]       iv_ram_rdata;
output reg [9:0]       ov_ram_raddr;
output reg             o_ram_rd;
// qch or qbv 
input                  i_qbv_or_qch;
// time slot 
input      [9:0]       iv_time_slot;
input                  i_time_slot_switch;

//////////////////////////////////////////////////
//          select input gate                   //
//////////////////////////////////////////////////
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_in_gate_ctrl_vector  <= 2'b0;
    end
    else begin
        if(i_qbv_or_qch == 1'b1)begin // qch , switch the slot base on the time_slot
            if(iv_time_slot[0] == 1'b0)begin
                ov_in_gate_ctrl_vector  <= 2'b01;
            end
            else begin
                ov_in_gate_ctrl_vector  <= 2'b10;
            end
        end
        else begin //qbv ,input gate is all open
            ov_in_gate_ctrl_vector  <= 2'b11;
        end
    end
end

//////////////////////////////////////////////////
//              output gate state               //
//////////////////////////////////////////////////
reg         [2:0]      gc_state;
localparam             IDLE_S   = 3'd0,
                       WITE1_S  = 3'd1,
                       WITE2_S  = 3'd2,
                       GATE_S   = 3'd3;

always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        o_ram_rd        <= 1'b0;
        ov_ram_raddr    <= 10'h0;

        ov_out_gate_ctrl_vector <= 8'h0;
        
        gc_state                <= IDLE_S;
    end
    else begin
        case(gc_state)
            IDLE_S:begin//when the time solt switched ,have to read gate control list
                if(i_qbv_or_qch == 1'b0)begin // qbv ,read gate_ctrl_list form ram
                    if(i_time_slot_switch == 1'b1)begin
                        ov_ram_raddr    <= iv_time_slot;
                        o_ram_rd        <= 1'b1;
                            
                        gc_state        <= WITE1_S;
                    end 
                    else begin  
                        o_ram_rd        <= 1'b0;
                        
                        gc_state        <= IDLE_S;
                    end
                end
                else begin// qch
                    gc_state                <= IDLE_S;
                    if(iv_time_slot[0] == 1'b0)begin
                        ov_out_gate_ctrl_vector  <= 8'b11111110;
                    end
                    else begin
                        ov_out_gate_ctrl_vector  <= 8'b11111101;
                    end
                end
            end
            
            WITE1_S:begin//read RAM data have 2 cycle delay   
                o_ram_rd        <= 1'b0;
                gc_state        <= WITE2_S;
            end 
                
            WITE2_S:begin//read RAM data have 2 cycle delay   
                o_ram_rd        <= 1'b0;
                gc_state        <= GATE_S;
            end 
                
            GATE_S:begin//receive ram read data,updata gate_ctrl_vector
                o_ram_rd        <= 1'b0;
                ov_out_gate_ctrl_vector <=iv_ram_rdata;
                
                gc_state        <= IDLE_S;
            end
            
            default:begin
                o_ram_rd        <= 1'b0;
                ov_ram_raddr    <= 10'h0;

                ov_out_gate_ctrl_vector <= 8'h0;
                
                gc_state        <= IDLE_S;
            end
        endcase
    end
end

endmodule