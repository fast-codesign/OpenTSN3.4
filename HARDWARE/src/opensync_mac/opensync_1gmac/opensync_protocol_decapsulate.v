// Copyright (C) 1953-2022 NUDT
// Verilog module name - opensync_protocol_decapsulate
// Version: V3.4.0.20220224
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         opensync_frame_decapsulation
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module opensync_protocol_decapsulate(
        i_clk,
        i_rst_n,
       
        iv_data,
        i_data_wr,
        
        ov_receive_time,
        o_cf_update_flag, 
           
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
//output
output  reg [63:0]      ov_receive_time;
output  reg             o_cf_update_flag;

output  reg [7:0]       ov_data;
output  reg             o_data_wr;
//***************************************************
//   add valid of data and delay 15 cycles
//***************************************************
//internal wire
reg         [134:0]     rv_data;
reg         [10:0]      rv_byte_cnt; 
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_data  <= 135'b0;
        rv_byte_cnt  <= 11'b0;
    end
    else begin
        if(i_data_wr)begin
            rv_byte_cnt <= rv_byte_cnt +1'b1;
            rv_data     <= {rv_data[125:0],1'b1,iv_data};
        end
        else begin
            rv_data     <= {rv_data[125:0],1'b0,8'b0};  
            rv_byte_cnt <= 11'b0;           
        end
    end
end            
//***************************************************
//         opensync protocol decapsulate
//***************************************************    
reg         [3:0]       rv_opd_state;
localparam  IDLE_S             = 4'd0,
            EXTRACT_TIME_S     = 4'd1,
            TRAN_PKT_S         = 4'd2; 
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        ov_data             <= 8'b0;
        o_data_wr           <= 1'b0;
        ov_receive_time		<= 64'b0;
		o_cf_update_flag 	<= 1'b0;
        rv_opd_state        <= IDLE_S;
    end
    else begin
        case(rv_opd_state)
            IDLE_S:begin
                ov_receive_time			    <= 48'b0; 
                if(rv_byte_cnt == 11'd15)begin                
                    if(({rv_data[25:18],rv_data[16:9]} == 16'hff01) && (rv_data[7:0] == 8'h06) && (iv_data[7:0] == 8'h03))begin//opensync from m/s clock node to m/s clock node.
                        o_data_wr           <= 1'b0;
						ov_data             <= 8'b0;
						o_cf_update_flag	<= 1'b1;	                        
                        rv_opd_state        <= EXTRACT_TIME_S;
					end 
                    else begin
                        o_data_wr           <= 1'b1;
						ov_data             <= rv_data[133:126];
						o_cf_update_flag	<= 1'b0;																	
                        rv_opd_state        <= TRAN_PKT_S;
					end
                end
				else begin
                    o_data_wr               <= 1'b0;
					ov_data 	            <= 8'b0;										
					o_cf_update_flag		<= 1'b0;
                    rv_opd_state            <= IDLE_S;                
                end
            end							
            EXTRACT_TIME_S:begin
                o_data_wr                   <= 1'b0;
                ov_data                     <= 8'b0;            
                if(rv_byte_cnt  <= 11'd31)begin                
                    ov_receive_time		    <= {rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9],rv_data[7:0],iv_data[7:0]};//receive time;   
                    rv_opd_state            <= EXTRACT_TIME_S;               
                end
                else if(rv_byte_cnt  == 11'd46)begin
                    rv_opd_state            <= TRAN_PKT_S;
                end
                else begin  
                    rv_opd_state            <= EXTRACT_TIME_S;
                end
            end
            TRAN_PKT_S:begin   
                if(rv_data[134]) begin   //transmit data.
                    o_data_wr       <= 1'b1;
                    ov_data         <= rv_data[133:126];
                    rv_opd_state    <= TRAN_PKT_S;
                end
                else begin
                    o_data_wr       <= 1'b0;
                    ov_data         <= 8'b0;
                    rv_opd_state    <= IDLE_S;
                end
            end    
            default:begin
                ov_data             <= 8'b0;
                o_data_wr           <= 1'b0;
                rv_opd_state        <= IDLE_S;
            end
        endcase
    end
end    
endmodule