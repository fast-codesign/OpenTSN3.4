// Copyright (C) 1953-2022 NUDT
// Verilog module name - opensync_protocol_encapsulate
// Version: V3.4.0.20220223
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         opensync_protocol_encapsulate
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module opensync_protocol_encapsulate(
    i_clk,
    i_rst_n,
    
    iv_data,
    i_data_wr,

    iv_local_time,       
    
    ov_data,
    o_data_wr
);
// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
//input
input       [7:0]       iv_data;
input                   i_data_wr;

input       [63:0]      iv_local_time;
//output
output  reg [7:0]       ov_data;
output  reg             o_data_wr;

//***************************************************
//            record receive time
//***************************************************
reg        [63:0]      rv_receive_local_time;
reg                    r_record_time_state;

localparam  RECORD_TIME_S  = 1'd0,
            WAIT_TRANSMIT_FINISH_S     = 1'd1;
            
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_receive_local_time    <= 64'b0;
        r_record_time_state      <= RECORD_TIME_S;
    end
    else begin
        case(r_record_time_state)
            RECORD_TIME_S:begin
                if(i_data_wr)begin//first cycle of pkt.
                    rv_receive_local_time    <= iv_local_time; 
                    r_record_time_state      <= WAIT_TRANSMIT_FINISH_S;                    
                end
                else begin//wait next pkt.
                    r_record_time_state      <= RECORD_TIME_S;
                end
            end
            WAIT_TRANSMIT_FINISH_S:begin
                if(i_data_wr)begin//pkt is receiving.
                    r_record_time_state   <= WAIT_TRANSMIT_FINISH_S;   
                end
                else begin//receive of pkt ends.
                    r_record_time_state   <= RECORD_TIME_S;   
                end
            end
            default:begin
                r_record_time_state      <= RECORD_TIME_S;
            end
        endcase            
    end
end            
//***************************************************
//   add valid of data and delay 8 cycles
//***************************************************
//internal wire
reg         [305:0]     rv_data;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_data <= 306'b0;
    end
    else begin
        if(i_data_wr)begin
            rv_data <= {rv_data[296:0],1'b1,iv_data};
        end
        else begin
            rv_data <= {rv_data[296:0],1'b0,8'b0};
        end
    end
end            
//***************************************************
//                  cycle counts
//***************************************************
reg        [5:0]       rv_cycle_cnt;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_cycle_cnt <= 6'b0;
    end
    else begin
        if(i_data_wr)begin
            if(rv_cycle_cnt == 6'd63)begin
                rv_cycle_cnt <= rv_cycle_cnt;
            end
            else begin
                rv_cycle_cnt <= rv_cycle_cnt + 1'b1;
            end
        end
        else begin
            rv_cycle_cnt <= 6'b0;
        end        
    end
end

//***************************************************
//         opensync protocol encapsulate
//***************************************************
reg      [3:0]      rv_sfe_state;
localparam  IDLE_S                  = 4'd0,
            TRANSMIT_OPENSYNC_S     = 4'd1,
            TRANSMIT_PTP_PCF_S      = 4'd2,
            TRANSMIT_NOT_PTP_PCF_S  = 4'd3;
                        
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        ov_data             <= 8'b0;
        o_data_wr           <= 1'b0;

        rv_sfe_state        <= IDLE_S;
    end
    else begin
        case(rv_sfe_state)
            IDLE_S:begin
                if((rv_cycle_cnt >= 6'd2) && (rv_cycle_cnt <= 6'd13))begin//transmit dmac and smac. 
					o_data_wr           <= 1'b1;          
				    ov_data             <= rv_data[16:9];                
					if(rv_cycle_cnt == 6'd13)begin//judge eth_type
					    if(({rv_data[7:0],iv_data[7:0]} == 16'h88f7) || ({rv_data[7:0],iv_data[7:0]} == 16'h891d))begin//ptp or pcf.
                            rv_sfe_state        <= TRANSMIT_OPENSYNC_S;
                        end
                        else begin
                            rv_sfe_state        <= TRANSMIT_NOT_PTP_PCF_S;
                        end
					end 
                    else begin
					    rv_sfe_state        <= IDLE_S;
					end
                end
				else begin
					o_data_wr           <= 1'h0;          
					ov_data             <= 8'b0;

                    rv_sfe_state        <= IDLE_S;                
                end
            end							
            TRANSMIT_OPENSYNC_S:begin           
            // rv_cycle_cnt  <= rv_cycle_cnt + 1'b1;                               
                o_data_wr           <= 1'b1;
                case(rv_cycle_cnt)
                    6'd14:ov_data    <= 8'hff;
                    6'd15:ov_data    <= 8'h01;
                    6'd16:ov_data    <= 8'h06;
                    6'd17:ov_data    <= 8'h03;
                    6'd18:ov_data    <= 8'h00;
                    6'd19:ov_data    <= 8'h00;
                    6'd20:ov_data    <= 8'h00;
                    6'd21:ov_data    <= 8'h00;
                    6'd22:ov_data    <= 8'h00;
                    6'd23:ov_data    <= 8'h00;
                    6'd24:ov_data    <= 8'h00;
                    6'd25:ov_data    <= 8'h00;
                    6'd26:ov_data    <= rv_receive_local_time[63:56];
                    6'd27:ov_data    <= rv_receive_local_time[55:48];
                    6'd28:ov_data    <= rv_receive_local_time[47:40];
                    6'd29:ov_data    <= rv_receive_local_time[39:32];
                    6'd30:ov_data    <= rv_receive_local_time[31:24];
                    6'd31:ov_data    <= rv_receive_local_time[23:16];
                    6'd32:ov_data    <= rv_receive_local_time[16:8];
                    6'd33:begin
                        ov_data      <= rv_receive_local_time[7:0];
                        rv_sfe_state <= TRANSMIT_PTP_PCF_S;
                    end
                    default:ov_data <= 8'h00;
                endcase 
            end
            TRANSMIT_PTP_PCF_S:begin        
                if(rv_data[305]) begin  //transmit data.
                    o_data_wr           <= 1'b1;
                    ov_data             <= rv_data[304:297];
                    rv_sfe_state        <= TRANSMIT_PTP_PCF_S;
                end
                else begin
                    o_data_wr           <= 1'b0;
                    ov_data             <= 8'b0;
                    rv_sfe_state        <= IDLE_S;
                end
            end    
            TRANSMIT_NOT_PTP_PCF_S:begin
                if(rv_data[17])begin  //transmit data.
                    o_data_wr           <= 1'b1;
                    ov_data             <= rv_data[16:9];
                    rv_sfe_state        <= TRANSMIT_NOT_PTP_PCF_S;
                end
                else begin
                    o_data_wr           <= 1'b0;
                    ov_data             <= 8'b0;
                    rv_sfe_state        <= IDLE_S;
                end
            end 
            default:begin
                ov_data        <= 8'b0;
                o_data_wr      <= 1'b0;
                rv_sfe_state   <= IDLE_S;
            end
        endcase
    end
end    
endmodule