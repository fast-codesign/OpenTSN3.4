// Copyright (C) 1953-2022 NUDT
// Verilog module name - opensync_protocol
// Version: V3.4.0.20220228
// Created:
//         by - fenglin
////////////////////////////////////////////////////////////////////////////
// Description:
//
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module opensync_protocol
(
       i_clk,
       i_rst_n,
       
       iv_hcp_mac,
       iv_controller_mac,
       
       iv_data,
	   i_data_wr,
	   
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
// pkt output
output reg [8:0]	   ov_data;
output reg	           o_data_wr;
///////////////////////////////////////////
//           delay 32 cycle
//////////////////////////////////////////
reg        [287:0]     rv_data;

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_data <= 288'b0;
    end
    else begin
        if(i_data_wr)begin
            rv_data <= {rv_data[278:0],iv_data};
        end
        else begin
            rv_data <= {rv_data[278:0],9'b0};
        end
    end
end
///////////////////////////////////////////
//           pkt process
//////////////////////////////////////////
reg    [2:0]  osp_state;
reg    [3:0]  rv_cycle_cnt;
localparam  IDLE_S                     = 3'd0,
            PROCESS_FROM_CONTROLLER_S  = 3'd1,
            PROCESS_FROM_NODE_S        = 3'd2,
            TRANS_DATA_S               = 3'd3,
            DISCARD_DATA_S             = 3'd4;  
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        ov_data       <= 9'b0;
		o_data_wr     <= 1'b0;
        rv_cycle_cnt  <= 4'b0;
		osp_state     <= IDLE_S;
    end
    else begin
		case(osp_state)
			IDLE_S:begin
				if(rv_data[287])begin//cache 32 cycles data.
                    if(rv_data[151:144] == 8'h01)begin//opensync from controller
                        ov_data       <= {1'b1,iv_data[7:0]};
                        o_data_wr     <= i_data_wr; 
                        rv_cycle_cnt  <= rv_cycle_cnt + 1'b1;
                        osp_state     <= PROCESS_FROM_CONTROLLER_S;                        
                    end
                    else if(rv_data[151:144] == 8'h03)begin//opensync from m/s node.
                        ov_data       <= {1'b1,iv_controller_mac[47:40]};
                        o_data_wr     <= i_data_wr;
                        rv_cycle_cnt  <= rv_cycle_cnt + 1'b1;
                        osp_state     <= PROCESS_FROM_NODE_S;                          
                    end
                    else begin
                        ov_data       <= 9'b0;
                        o_data_wr     <= 1'b0;
                        rv_cycle_cnt  <= 4'b0;
                        osp_state     <= DISCARD_DATA_S;                        
                    end
                end
                else begin
                    rv_cycle_cnt <= 4'b0;
                    ov_data      <= 9'b0;
		            o_data_wr    <= 1'b0;
                    osp_state    <= IDLE_S;                
                end
            end
            PROCESS_FROM_CONTROLLER_S:begin
                rv_cycle_cnt <= rv_cycle_cnt + 1'b1;
                o_data_wr    <= 1'b1;
                if(rv_cycle_cnt <= 4'd11)begin
                    ov_data  <= {1'b0,iv_data[7:0]};
                end
                else if(rv_cycle_cnt == 4'd12)begin
                    ov_data  <= {1'b0,8'hff};
                end
                else if(rv_cycle_cnt == 4'd13)begin
                    ov_data  <= {1'b0,8'h01};
                end
                else if(rv_cycle_cnt == 4'd14)begin
                    ov_data  <= {1'b0,8'h06};
                end 
                else begin//if(rv_cycle_cnt == 4'd15)begin
                    ov_data     <= {1'b0,8'h03};//opensynnc to m/s node.
                    osp_state   <= TRANS_DATA_S; 
                end                                    					             
			end
            PROCESS_FROM_NODE_S:begin
                rv_cycle_cnt <= rv_cycle_cnt + 1'b1;
                o_data_wr    <= 1'b1;
                case(rv_cycle_cnt)
                    4'd1:ov_data  <= {1'b0,iv_controller_mac[39:32]};
                    4'd2:ov_data  <= {1'b0,iv_controller_mac[31:24]};
                    4'd3:ov_data  <= {1'b0,iv_controller_mac[23:16]};
                    4'd4:ov_data  <= {1'b0,iv_controller_mac[15:8]};
                    4'd5:ov_data  <= {1'b0,iv_controller_mac[7:0]};
                    4'd6:ov_data  <= {1'b0,iv_hcp_mac[47:40]};
                    4'd7:ov_data  <= {1'b0,iv_hcp_mac[39:32]};
                    4'd8:ov_data  <= {1'b0,iv_hcp_mac[31:24]};
                    4'd9:ov_data  <= {1'b0,iv_hcp_mac[23:16]};
                    4'd10:ov_data  <= {1'b0,iv_hcp_mac[15:8]};
                    4'd11:ov_data  <= {1'b0,iv_hcp_mac[7:0]};
                    4'd12:ov_data  <= rv_data[287:279];
                    4'd13:ov_data  <= rv_data[287:279];
                    4'd14:ov_data  <= rv_data[287:279];
                    4'd15:ov_data  <= {1'b0,8'h02};
                    default:ov_data  <= rv_data[287:279];
                endcase
                if(rv_cycle_cnt == 4'd15)begin
                    osp_state   <= TRANS_DATA_S;
                end
                else begin
                    osp_state   <= PROCESS_FROM_NODE_S; 
                end                                    					             
			end            
            TRANS_DATA_S:begin
                ov_data         <= rv_data[287:279];
		        o_data_wr       <= 1'b1;
                if(rv_data[287])begin//last cycle
                    osp_state   <= IDLE_S;                   
                end
                else begin
                    osp_state   <= TRANS_DATA_S;  
                end                
            end
            DISCARD_DATA_S:begin
                ov_data         <= 9'b0;
                o_data_wr       <= 1'b0;
                if(rv_data[287])begin//last cycle
                    osp_state   <= IDLE_S;                   
                end
                else begin
                    osp_state   <= DISCARD_DATA_S;  
                end                
            end
			default:begin
                ov_data <= 9'b0;
                o_data_wr <= 1'b0;
                osp_state <= IDLE_S;	
			end
		endcase
   end
end	
endmodule