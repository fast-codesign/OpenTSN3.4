// Copyright (C) 1953-2020 NUDT
// Verilog module name - sync_control_module
// Version: SCM_V1.0.0_20211202
// Created:
//         by - fenglin 
//         at - 12.2021
////////////////////////////////////////////////////////////////////////////
// Description:
//         sync_control_module
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module sync_control_module(
    i_clk,
    i_rst_n,
    
    iv_app_data,
    i_app_data_wr,
    
    iv_clock_ts,
    i_clock_ts_wr,
           
    ov_sync_data,
    o_sync_data_wr,
    
    o_sim_ctrl,
    ov_scm_state
);
// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
//input
input       [7:0]       iv_app_data;
input                   i_app_data_wr;

input                   i_clock_ts_wr;
input       [47:0]      iv_clock_ts;

//output
output  reg [7:0]       ov_sync_data;
output  reg             o_sync_data_wr;
output  reg             o_sim_ctrl;

output  reg [3:0]       ov_scm_state;
//internal wire
reg         [3:0]       byte_cnt; 
reg         [5:0]       appdata_cnt; 
reg         [47:0]      reg_sync_pit;
reg         [47:0]      reg_app_pit;


localparam  IDLE_S      = 4'd0,
            TRAN_S      = 4'd1;

always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        reg_app_pit   <= 48'b0;
        appdata_cnt   <= 6'b0;
    end
    else begin
        if(i_app_data_wr)begin
            appdata_cnt <= appdata_cnt + 1'b1; 
            reg_app_pit <= {reg_app_pit[39:0],iv_app_data};
        end
        else begin
            reg_app_pit <= reg_app_pit;
            appdata_cnt <= 6'b0; 
        end
    end
end
 
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        o_sim_ctrl   <= 1'b0;
    end
    else begin
        if(appdata_cnt==4'd14)begin
            if(iv_clock_ts>reg_app_pit)begin			
				if(iv_clock_ts - reg_app_pit>48'd20000)begin//more than offset
					o_sim_ctrl <=  1'b1; 
				end
				else begin
					o_sim_ctrl <=  1'b0;             
				end
			end
			else begin
				if(reg_app_pit - iv_clock_ts >48'd20000)begin//more than offset
					o_sim_ctrl <=  1'b1; 
				end
				else begin
					o_sim_ctrl <=  1'b0;             
				end
			end
        end
        else begin
            o_sim_ctrl <=  o_sim_ctrl;  
        end
    end 
end
  
 
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        reg_sync_pit   <= 48'b0;
        ov_sync_data   <= 8'b0;
        o_sync_data_wr <= 1'b0;
        byte_cnt       <= 4'b0;
        ov_scm_state   <= IDLE_S;
    end
    else begin
        case(ov_scm_state)
            IDLE_S:begin
                if(i_clock_ts_wr == 1'b1)begin//enable                 
					reg_sync_pit   <= iv_clock_ts;
                    byte_cnt       <= byte_cnt + 1'b1;
                    ov_sync_data   <= iv_clock_ts[47:40];
                    o_sync_data_wr <= 1'b1;
                    ov_scm_state   <= TRAN_S;
				end
				else begin
                    reg_sync_pit   <= reg_sync_pit;
                    ov_sync_data   <= 8'b0;
                    o_sync_data_wr <= 1'b0;
                    byte_cnt       <= 4'b0;
                    ov_scm_state   <= IDLE_S;                
                end
            end							
            TRAN_S:begin           
                byte_cnt  <= byte_cnt + 1'b1;
                if(byte_cnt < 4'd6) begin                                 
                    o_sync_data_wr     <= 1'b1;
                    case(byte_cnt)
                        4'd1:ov_sync_data <= reg_sync_pit[39:32];
                        4'd2:ov_sync_data <= reg_sync_pit[31:24];
                        4'd3:ov_sync_data <= reg_sync_pit[23:16];
                        4'd4:ov_sync_data <= reg_sync_pit[15:8];
                        4'd5:ov_sync_data <= reg_sync_pit[7:0]; 
                        default:ov_sync_data <= ov_sync_data;
					endcase
                    ov_scm_state        <= TRAN_S;    
                end
                else begin//invalid
                    o_sync_data_wr      <= 1'b0;
                    ov_sync_data        <= 8'b0;
                    ov_scm_state        <= IDLE_S;
                end
            end
            default:begin
                o_sync_data_wr <= 1'b0;
                ov_sync_data   <= 8'b0;
                byte_cnt       <= 4'b0;
                ov_scm_state   <= IDLE_S;
            end
        endcase
    end
end    
endmodule