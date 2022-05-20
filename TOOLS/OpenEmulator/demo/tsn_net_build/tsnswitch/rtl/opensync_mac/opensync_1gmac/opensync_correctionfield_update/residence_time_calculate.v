// Copyright (C) 1953-2022 NUDT
// Verilog module name - residence_time_calculate
// Version: V3.4.0.20220224
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         residence time calculate
///////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module residence_time_calculate
(
        i_clk,
        i_rst_n,
              
        iv_data,
        i_data_wr,
       
        iv_receive_time,
        i_cf_update_flag,
        iv_local_time,
        i_tsn_or_tte,   
            
        ov_data,
        o_data_wr       
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;

input      [7:0]       iv_data;
input                  i_data_wr;

input      [63:0]      iv_receive_time;
input                  i_cf_update_flag; 
input      [63:0]      iv_local_time;
input                  i_tsn_or_tte;
// send pkt    
output reg [7:0]       ov_data;
output reg             o_data_wr;
//***************************************************
//   add valid of data and delay 8 cycles
//***************************************************
reg       [71:0]       rv_data;
reg       [10:0]       rv_byte_cnt;
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        rv_data   <= 72'h0;
    end
    else begin
        if(i_data_wr == 1'b1)begin//write a pkt data to register
            rv_byte_cnt <= rv_byte_cnt + 1'b1;
            rv_data     <= {rv_data[62:0],1'b1,iv_data};      
        end
        else begin
            rv_byte_cnt <= 11'b0;
            rv_data     <= {rv_data[62:0],1'b0,8'b0};
        end
    end
end
//***************************************************
//        opensync correctionfield update
//***************************************************  
reg        [63:0]       rv_correctionfield_clock;
reg        [3:0]        rv_cf_update_state; 
reg        [63:0]       rv_debug_time;  
     
localparam              IDLE_S          = 3'd0,
                        UPDATE_PTP_CF_S = 3'd1,
                        UPDATE_PCF_CF_S = 3'd2,
                        TRANS_PKT_S     = 3'd3;   
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        o_data_wr                   <= 1'b0;
        ov_data                     <= 8'h0;   
        rv_correctionfield_clock    <= 64'h0;
        rv_cf_update_state          <= IDLE_S;
        
        rv_debug_time               <= 64'b0;
    end
    else begin
        case(rv_cf_update_state)
            IDLE_S: begin
				rv_correctionfield_clock <= 64'h0;               
				if(rv_data[71])begin
					o_data_wr    <= 1'b1;
					ov_data      <= rv_data[70:63];
                    if(i_cf_update_flag)begin
                        if(i_tsn_or_tte)begin//tsn
					        rv_cf_update_state <= UPDATE_PTP_CF_S;
                        end
                        else begin//tte
                            rv_cf_update_state <= UPDATE_PCF_CF_S;
                        end
                    end
                    else begin
                        rv_cf_update_state <= TRANS_PKT_S;
                    end
			    end
				else begin
					o_data_wr    <= 1'b0;
				    ov_data      <= 8'h0;
					rv_cf_update_state <= IDLE_S;
				end
			end              
            UPDATE_PTP_CF_S:begin//updata calculates clock of ptp 
                o_data_wr    <= 1'b1;
				if(rv_byte_cnt < 11'd30)begin
				    ov_data  <= rv_data[70:63];
                    if(rv_byte_cnt == 11'd29)begin
                        rv_correctionfield_clock[63:16] <= {rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9]} + (iv_local_time - iv_receive_time);//{rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9],rv_data[7:0],iv_data[7:0]} + (iv_local_time - iv_receive_time);
                        rv_correctionfield_clock[15:0]  <= {rv_data[7:0],iv_data[7:0]};
                        //if(iv_local_time > iv_receive_time)begin
                        //    rv_correctionfield_clock[63:16] <= {rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9]} + (iv_local_time - iv_receive_time);//{rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9],rv_data[7:0],iv_data[7:0]} + (iv_local_time - iv_receive_time);
                        //    rv_correctionfield_clock[15:0]  <= {rv_data[7:0],iv_data[7:0]};
                        //end
                        //else begin
                        //    rv_correctionfield_clock[63:16] <= {rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9]} + (iv_local_time + 65'h1_0000_0000_0000_0000 - iv_receive_time);//{rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9],rv_data[7:0],iv_data[7:0]} + (iv_local_time + 65'h1_0000_0000_0000_0000 - iv_receive_time);
                        //    rv_correctionfield_clock[15:0]  <= {rv_data[7:0],iv_data[7:0]};
                        //end                        
                    end
                    else begin
                        rv_correctionfield_clock <= rv_correctionfield_clock;
                    end                    
				end
				else if(rv_byte_cnt <= 11'd37)begin
                    case(rv_byte_cnt)                           
                        11'd30:ov_data    <= rv_correctionfield_clock  [63:56];
                        11'd31:ov_data    <= rv_correctionfield_clock  [55:48];
                        11'd32:ov_data    <= rv_correctionfield_clock  [47:40];
                        11'd33:ov_data    <= rv_correctionfield_clock  [39:32];
                        11'd34:ov_data    <= rv_correctionfield_clock  [31:24];
                        11'd35:ov_data    <= rv_correctionfield_clock  [23:16];
                        11'd36:ov_data    <= rv_correctionfield_clock  [15:8];
                        11'd37:ov_data    <= rv_correctionfield_clock  [7:0];
                        default:ov_data   <= rv_data[70:63];					
                    endcase
			    end
                else begin
                    ov_data                 <= rv_data[70:63];
                    rv_cf_update_state <= TRANS_PKT_S;
                end
            end
            UPDATE_PCF_CF_S:begin//updata calculates clock of ptp 
                o_data_wr    <= 1'b1;
				if(rv_byte_cnt < 11'd42)begin
				    ov_data  <= rv_data[70:63];
                    if(rv_byte_cnt == 11'd41)begin
                        rv_correctionfield_clock[63:16] <= {rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9]} + (iv_local_time - iv_receive_time);//{rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9],rv_data[7:0],iv_data[7:0]} + (iv_local_time - iv_receive_time);
                        rv_correctionfield_clock[15:0]  <= {rv_data[7:0],iv_data[7:0]};
                        //if(iv_local_time > iv_receive_time)begin
                        //    rv_correctionfield_clock[63:16] <= {rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9]} + (iv_local_time - iv_receive_time);//{rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9],rv_data[7:0],iv_data[7:0]} + (iv_local_time - iv_receive_time);
                        //    rv_correctionfield_clock[15:0]  <= {rv_data[7:0],iv_data[7:0]};
                        //end
                        //else begin
                        //    rv_correctionfield_clock[63:16] <= {rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9]} + (iv_local_time + 65'h1_0000_0000_0000_0000 - iv_receive_time);//{rv_data[61:54],rv_data[52:45],rv_data[43:36],rv_data[34:27],rv_data[25:18],rv_data[16:9],rv_data[7:0],iv_data[7:0]} + (iv_local_time + 65'h1_0000_0000_0000_0000 - iv_receive_time);
                        //    rv_correctionfield_clock[15:0]  <= {rv_data[7:0],iv_data[7:0]};
                        //end                        
                    end
                    else begin
                        rv_correctionfield_clock <= rv_correctionfield_clock;
                    end                    
				end
				else if(rv_byte_cnt <= 11'd49)begin
                    case(rv_byte_cnt)                           
                        11'd42:ov_data    <= rv_correctionfield_clock  [63:56];
                        11'd43:ov_data    <= rv_correctionfield_clock  [55:48];
                        11'd44:ov_data    <= rv_correctionfield_clock  [47:40];
                        11'd45:ov_data    <= rv_correctionfield_clock  [39:32];
                        11'd46:ov_data    <= rv_correctionfield_clock  [31:24];
                        11'd47:ov_data    <= rv_correctionfield_clock  [23:16];
                        11'd48:ov_data    <= rv_correctionfield_clock  [15:8];
                        11'd49:ov_data    <= rv_correctionfield_clock  [7:0];
                        default:ov_data   <= rv_data[70:63];					
                    endcase
			    end
                else begin
                    ov_data            <= rv_data[70:63];
                    rv_cf_update_state <= TRANS_PKT_S;
                end
            end            
			TRANS_PKT_S:begin
			    if(rv_data[71] == 1'b1)begin
                    ov_data      <= rv_data[70:63];
			        o_data_wr    <= 1'b1;
				end
				else begin
                    ov_data      <= 8'b0;
			        o_data_wr    <= 1'b0;
				    rv_cf_update_state <= IDLE_S;
				end
			end
            default:begin
				o_data_wr                     <= 1'b0;
	            rv_byte_cnt                   <= 11'h0;
				ov_data                       <= 8'h0;
				rv_correctionfield_clock      <= 64'h0;
                rv_cf_update_state            <= IDLE_S;
            end
        endcase
    end
end
endmodule 