// Copyright (C) 1953-2022 NUDT
// Verilog module name - opensync_receive_pit_record
// Version: V3.4.0.20220223
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         opensync receive pit record.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module opensync_receive_pit_record
(
        i_clk,
        i_rst_n,
        
        iv_syn_clk,
        iv_local_time,
              
        iv_data,
        i_data_wr,
       
        ov_data,
        o_data_wr 
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
//receive time
input      [63:0]      iv_syn_clk;
input      [63:0]      iv_local_time;
//receive pkt
input      [7:0]       iv_data;
input                  i_data_wr;
//send pkt 
output reg [7:0]       ov_data;
output reg             o_data_wr;
//***************************************************
//            record receive time
//***************************************************
reg        [63:0]      rv_receive_syn_clk;
reg        [63:0]      rv_receive_local_time;

reg                    r_record_time_state;

localparam  RECORD_TIME_S  = 1'd0,
            WAIT_TRANSMIT_FINISH_S     = 1'd1;
            
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_receive_syn_clk       <= 64'b0;
        rv_receive_local_time    <= 64'b0;
        r_record_time_state      <= RECORD_TIME_S;
    end
    else begin
        case(r_record_time_state)
            RECORD_TIME_S:begin
                if(i_data_wr)begin//first cycle of pkt.
                    rv_receive_syn_clk       <= iv_syn_clk;
                    rv_receive_local_time    <= iv_local_time; 
                    r_record_time_state      <= WAIT_TRANSMIT_FINISH_S;                    
                end
                else begin//wait pkt.
                    r_record_time_state      <= RECORD_TIME_S;
                end
            end
            WAIT_TRANSMIT_FINISH_S:begin
                if(i_data_wr)begin//pkt is receiving.
                    r_record_time_state      <= WAIT_TRANSMIT_FINISH_S;   
                end
                else begin//receive of pkt ends.
                    r_record_time_state      <= RECORD_TIME_S;   
                end
            end
            default:r_record_time_state      <= RECORD_TIME_S;
        endcase            
    end
end
//***************************************************
//      add valid of data and delay 8 cycles
//***************************************************
reg        [143:0]      rv_data;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_data         <= 144'b0;
    end
    else begin
        if(i_data_wr)begin
            rv_data     <= {rv_data[134:0],1'b1,iv_data};
        end
        else begin
            rv_data     <= {rv_data[134:0],1'b0,8'b0};
        end        
    end
end
//***************************************************
//                  cycle counts
//***************************************************
reg        [5:0]       rv_byte_cnt;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_byte_cnt <= 6'b0;
    end
    else begin
        if(i_data_wr)begin
            if(rv_byte_cnt == 6'd63)begin
                rv_byte_cnt <= rv_byte_cnt;
            end
            else begin
                rv_byte_cnt <= rv_byte_cnt + 1'b1;
            end
        end
        else begin
            rv_byte_cnt <= 6'b0;
        end        
    end
end
//***************************************************
//       receive pit record in ctrl interface
//***************************************************
reg       [63:0]              rv_receive_time;
reg       [63:0]              rv_correct_time;
reg       [2:0]               rv_pkt_process_state;
localparam      IDLE_S                     = 3'd0,
                DISTINGUISH_PKT_S          = 3'd1,
                TRANSMIT_PKT_S             = 3'd2,
                EXTRACT_RECEIVE_TIME_S     = 3'd3,
                CALCULATE_TIME_S           = 3'd4,
                TRANSMIT_TIME_S            = 3'd5;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)begin
        ov_data              <= 8'b0;
        o_data_wr            <= 1'b0; 
        rv_receive_time      <= 64'b0;
        rv_correct_time      <= 64'b0;
        rv_pkt_process_state <= IDLE_S;        
    end
    else begin
        case(rv_pkt_process_state)
            IDLE_S:begin
                rv_receive_time      <= 64'b0;
                rv_correct_time      <= 64'b0;
                if(rv_data[143])begin//transmit first cycle.
                    ov_data              <= rv_data[142:135];
                    o_data_wr            <= 1'b1;
                    if(({rv_data[34:27],rv_data[25:18]} == 16'hff01) && (rv_data[16:9] == 8'h06) && (rv_data[7:0] == 8'h03))begin//opensync from m/s clock node to m/s clock node.
                        rv_pkt_process_state <= CALCULATE_TIME_S;
                    end
                    else begin
                        rv_pkt_process_state <= TRANSMIT_PKT_S;
                    end                
                end
                else begin
                    ov_data              <= 8'b0;
                    o_data_wr            <= 1'b0;
                    rv_pkt_process_state <= IDLE_S;                      
                end
            end
            /*DISTINGUISH_PKT_S:begin
                ov_data              <= rv_data[142:135];
                o_data_wr            <= 1'b1;  
                if(rv_byte_cnt == 6'd15)begin
                    if(({rv_data[25:18],rv_data[16:9]} == 16'hff01) && (rv_data[7:0] == 8'h06) && (iv_data[7:0] == 8'h03))begin//opensync from m/s clock node to m/s clock node.
                        rv_pkt_process_state <= CALCULATE_TIME_S;
                    end
                    else begin
                        rv_pkt_process_state <= TRANSMIT_PKT_S;
                    end
                end
                else begin
                    rv_pkt_process_state <= DISTINGUISH_PKT_S;
                end
            end*/
            CALCULATE_TIME_S:begin
                ov_data              <= rv_data[142:135];
                o_data_wr            <= 1'b1;
                if(rv_byte_cnt == 6'd31)begin
                    rv_pkt_process_state     <= TRANSMIT_TIME_S;
                    rv_correct_time      <= rv_receive_syn_clk - (rv_receive_local_time - {rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9],rv_data[7:0],iv_data[7:0]}); 
                    //if(rv_receive_local_time > {rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9],rv_data[7:0],iv_data[7:0]})begin
                    //    rv_correct_time      <= rv_receive_syn_clk - (rv_receive_local_time - {rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9],rv_data[7:0],iv_data[7:0]});       
                    //end
                    //else begin
                    //    rv_correct_time      <= rv_receive_syn_clk - (rv_receive_local_time - {rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9],rv_data[7:0],iv_data[7:0]});
                    //end                    
                end
                else begin
                    rv_pkt_process_state <= CALCULATE_TIME_S;                      
                end            
            end 
            TRANSMIT_TIME_S:begin 
                o_data_wr             <= 1'b1;              
                if(rv_byte_cnt  == 6'd32)begin
                    ov_data           <= rv_correct_time[63:56];
                end
                else if(rv_byte_cnt  == 6'd33)begin
                    ov_data           <= rv_correct_time[55:48];
                end
                else if(rv_byte_cnt  == 6'd34)begin
                    ov_data           <= rv_correct_time[47:40];
                end
                else if(rv_byte_cnt  == 6'd35)begin
                    ov_data           <= rv_correct_time[39:32];
                end                
                else if(rv_byte_cnt  == 6'd36)begin
                    ov_data           <= rv_correct_time[31:24];
                end
                else if(rv_byte_cnt  == 6'd37)begin
                    ov_data           <= rv_correct_time[23:16];
                end 
                else if(rv_byte_cnt  == 6'd38)begin
                    ov_data           <= rv_correct_time[15:8];
                end
                else if(rv_byte_cnt  == 6'd39)begin
                    ov_data               <= rv_correct_time[7:0];
                    rv_pkt_process_state  <= TRANSMIT_PKT_S; 
                end
                else begin
                    ov_data               <= rv_data[142:135];
                end                 
            end
            TRANSMIT_PKT_S:begin
                if(rv_data[143])begin//transmit data.
                    ov_data              <= rv_data[142:135];
                    o_data_wr            <= 1'b1;
                    rv_pkt_process_state <= TRANSMIT_PKT_S;                    
                end
                else begin
                    ov_data              <= 8'b0;
                    o_data_wr            <= 1'b0;
                    rv_pkt_process_state <= IDLE_S;                      
                end            
            end
            default:begin
                rv_pkt_process_state <= IDLE_S;  
            end
        endcase
    end
end
endmodule