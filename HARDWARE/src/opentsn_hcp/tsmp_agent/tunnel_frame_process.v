// Copyright (C) 1953-2022 NUDT
// Verilog module name - tunnel_frame_process
// Version: V3.4.0.20220301
// Created:
//         by - fenglin
////////////////////////////////////////////////////////////////////////////
// Description:
//         - encapsulate frame and transmit to opentsn controller,
//         - decapsulate frame from opentsn controller.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tunnel_frame_process
(
       i_clk,
       i_rst_n,
       
       iv_hcp_mac,
       iv_controller_mac,
       
       iv_data,
	   i_data_wr,
       i_encapsulated_flag,
	   
	   ov_data,
	   o_data_wr   
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;  
// dmac and smac of tsmp frame from controller
input      [47:0]      iv_hcp_mac;
input      [47:0]      iv_controller_mac;
// pkt input
input	   [8:0]	   iv_data;
input	         	   i_data_wr;
input                  i_encapsulated_flag;
// pkt output
output reg [8:0]	   ov_data;
output reg	           o_data_wr;

reg        [143:0]     rv_data;

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_data <= 144'b0;
    end
    else begin
        if(i_data_wr)begin
            rv_data <= {rv_data[135:0],iv_data};
        end
        else begin
            rv_data <= {rv_data[135:0],9'b0};
        end
    end
end

reg    [2:0]  rv_tfp_state;
reg    [3:0]  rv_cycle_cnt;
localparam  IDLE_S               = 3'd0,
            TRANS_TSMP_HEAD_S    = 3'd1,
            TRANS_ONE_CYCLE_S    = 3'd2,
            TRANS_REC_DATA_S     = 3'd3,
            DISCARD_TSMP_HEAD_S  = 3'd4, 
            TRANS_DECAPSULATED_1ST_DATA_S    = 3'd5,
            TRANS_DECAPSULATED_NOT1ST_DATA_S = 3'd6;              
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        ov_data       <= 9'b0;
		o_data_wr     <= 1'b0;
        rv_cycle_cnt  <= 4'b0;
		rv_tfp_state  <= IDLE_S;
    end
    else begin
		case(rv_tfp_state)
			IDLE_S:begin  
                if((i_data_wr == 1'b1) && (iv_data[8] == 1'b1))begin
                    if(!i_encapsulated_flag)begin//need to encapsulate ,then transmit to opentsn controller.
                        rv_cycle_cnt <= 4'b1;
                        ov_data      <= {1'b1,iv_controller_mac[47:40]};
                        o_data_wr    <= 1'b1;
                        rv_tfp_state <= TRANS_TSMP_HEAD_S;
                    end
                    else begin//from opentsn controller,and need to decapsulate.
                        rv_cycle_cnt  <= 4'b1;
                        ov_data       <= 9'b0;
                        o_data_wr     <= 1'b0;
                        rv_tfp_state  <= DISCARD_TSMP_HEAD_S;                 
                    end                                                
                end
                else begin
                    rv_cycle_cnt <= 4'b0;
                    ov_data      <= 9'b0;
                    o_data_wr    <= 1'b0;
                    rv_tfp_state <= IDLE_S;                
                end
            end
            TRANS_TSMP_HEAD_S:begin
                rv_cycle_cnt  <= rv_cycle_cnt + 1'b1;
                o_data_wr     <= 1'b1;
                case(rv_cycle_cnt)
                    4'd1:begin
                        ov_data <= {1'b0,iv_controller_mac[39:32]};
                    end
                    4'd2:begin
                        ov_data <= {1'b0,iv_controller_mac[31:24]};
                    end
                    4'd3:begin
                        ov_data <= {1'b0,iv_controller_mac[23:16]};
                    end 
                    4'd4:begin
                        ov_data <= {1'b0,iv_controller_mac[15:8]};
                    end
                    4'd5:begin
                        ov_data <= {1'b0,iv_controller_mac[7:0]};
                    end
                    4'd6:begin
                        ov_data <= {1'b0,iv_hcp_mac[47:40]};
                    end
                    4'd7:begin
                        ov_data <= {1'b0,iv_hcp_mac[39:32]};
                    end
                    4'd8:begin
                        ov_data <= {1'b0,iv_hcp_mac[31:24]};
                    end
                    4'd9:begin
                        ov_data <= {1'b0,iv_hcp_mac[23:16]};
                    end 
                    4'd10:begin
                        ov_data <= {1'b0,iv_hcp_mac[15:8]};
                    end
                    4'd11:begin
                        ov_data <= {1'b0,iv_hcp_mac[7:0]};
                    end
                    4'd12:begin
                        ov_data <= {1'b0,8'hff};
                    end
                    4'd13:begin
                        ov_data <= {1'b0,8'h01};
                    end
                    4'd14:begin
                        ov_data <= {1'b0,8'h04};
                    end
                    4'd15:begin
                        ov_data      <= {1'b0,8'h01};
                        rv_tfp_state <= TRANS_ONE_CYCLE_S;
                    end
                    default:begin
                        ov_data      <= ov_data;
                    end
                endcase                    					             
			end
            TRANS_ONE_CYCLE_S:begin
                ov_data   <= {1'b0,rv_data[142:135]};
                rv_tfp_state <= TRANS_REC_DATA_S;                
            end         
            TRANS_REC_DATA_S:begin
                if(rv_data[143] == 1'b1)begin//last cycle
                    ov_data <= {1'b1,rv_data[142:135]};
                    rv_tfp_state <= IDLE_S;                   
                end
                else begin
                    ov_data <= {1'b0,rv_data[142:135]};
                    rv_tfp_state <= TRANS_REC_DATA_S;  
                end                
            end
            DISCARD_TSMP_HEAD_S:begin
                rv_cycle_cnt  <= rv_cycle_cnt + 1'b1;
                ov_data       <= 9'b0;
                o_data_wr     <= 1'b0;
                if(rv_cycle_cnt == 4'hf)begin
                    rv_tfp_state  <= TRANS_DECAPSULATED_1ST_DATA_S;                  
                end
                else begin
                    rv_tfp_state  <= DISCARD_TSMP_HEAD_S;
                end
            
            end
            TRANS_DECAPSULATED_1ST_DATA_S:begin
                ov_data       <= {1'b1,iv_data[7:0]};
                o_data_wr     <= 1'b1;            
                rv_tfp_state  <= TRANS_DECAPSULATED_NOT1ST_DATA_S;
            end
            TRANS_DECAPSULATED_NOT1ST_DATA_S:begin
                ov_data       <= iv_data;
                o_data_wr     <= i_data_wr;            
                if(i_data_wr && iv_data[8])begin
                    rv_tfp_state  <= IDLE_S;  
                end
                else begin
                    rv_tfp_state  <= TRANS_DECAPSULATED_NOT1ST_DATA_S;  
                end                
            end
			default:begin
                ov_data <= 9'b0;
                o_data_wr <= 1'b0;
                rv_tfp_state <= IDLE_S;	
			end
		endcase
   end
end	
endmodule