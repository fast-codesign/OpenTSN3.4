// Copyright (C) 1953-2021 NUDT
// Verilog module name - control_output_interface 
// Version: V3.2.0.20210722
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         output process of host interface.
//             - receive pkt,and transmit pkt to PHY;
//             - record timestamp for PTP packet;
//             - add preamble of frame and start-of-frame delimiter before transmitting pkt;
//             - control interframe gap that is 12 cycles.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module control_output_interface
(
       i_clk,
       i_rst_n,

       iv_pkt_descriptor,
       i_pkt_descriptor_wr,
              
       iv_pkt_data,
       i_pkt_data_wr,
       
       o_pkt_rd_req,
       o_pkt_last_cycle_rx,
       
       ov_pkt_cnt,
       
       ov_hcp_data,
       o_hcp_data_wr,
       
       ov_eth_data,
       o_eth_data_wr,
       
       hoi_state       
);

// I/O
// clk & rst
input                  i_clk;   
input                  i_rst_n;

input      [13:0]      iv_pkt_descriptor;              
input                  i_pkt_descriptor_wr; 
// receive pkt from PCB  
input      [133:0]     iv_pkt_data;
input                  i_pkt_data_wr;
// request of reading pkt
output                 o_pkt_rd_req;
// finish of tramsmission of pkt
output reg             o_pkt_last_cycle_rx;

output reg [31:0]      ov_pkt_cnt;
// transmit pkt to phy     
output reg [7:0]       ov_hcp_data;
output reg             o_hcp_data_wr;

output reg [7:0]       ov_eth_data;
output reg             o_eth_data_wr;
//***************************************************
//           cache mac_entry_hit and inport 
//***************************************************
reg          r_mac_entry_hit;
reg [3:0]    rv_pkt_inport;
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        r_mac_entry_hit <= 1'b0;
        rv_pkt_inport   <= 4'b0;
    end
    else begin
        if(i_pkt_descriptor_wr)begin
            r_mac_entry_hit <=  iv_pkt_descriptor[13];
			rv_pkt_inport   <=  iv_pkt_descriptor[12:9];
        end
        else begin 
            r_mac_entry_hit <= r_mac_entry_hit; 
            rv_pkt_inport <= rv_pkt_inport; 
        end 
    end
end
//***************************************************
//                 cache pkt 
//***************************************************
//use two registers cache pkt
reg        [133:0]     rv_data1;
reg                    r_data1_write_flag;
reg                    r_data1_empty;
reg        [133:0]     rv_data2;
reg                    r_data2_write_flag;
reg                    r_data2_empty;
assign o_pkt_rd_req = r_data1_empty || r_data2_empty;
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        rv_data1 <= 134'b0;
        r_data1_write_flag <= 1'b0;
        rv_data2 <= 134'b0;
        r_data2_write_flag <= 1'b0;
    end
    else begin
        if(i_pkt_data_wr == 1'b1)begin
			if((iv_pkt_data[133:132] == 2'b01)&&((iv_pkt_data[31:16] != 16'h1800)&&(iv_pkt_data[31:16] != 16'h98f7)&&(iv_pkt_data[31:16] != 16'hff01)))begin
				if(r_data1_empty == 1'b1)begin
					rv_data1[133:128] <= iv_pkt_data[133:128];
					rv_data1[127:80]  <= {iv_pkt_data[127:85],r_mac_entry_hit,rv_pkt_inport};
					rv_data1[79:0]    <= iv_pkt_data[79:0];
					r_data1_write_flag <= 1'b1;
				end
				else if(r_data2_empty == 1'b1)begin
					rv_data2[133:128] <= iv_pkt_data[133:128];
					rv_data2[127:80]  <= {iv_pkt_data[127:85],r_mac_entry_hit,rv_pkt_inport};
					rv_data2[79:0]    <= iv_pkt_data[79:0];
					r_data2_write_flag <= 1'b1;         
				end
				else begin
					r_data1_write_flag <= 1'b0; 
					r_data2_write_flag <= 1'b0;             
				end
            end
            else begin
				if(r_data1_empty == 1'b1)begin
					rv_data1  <= iv_pkt_data;
					r_data1_write_flag <= 1'b1;
				end
				else if(r_data2_empty == 1'b1)begin
					rv_data2   <= iv_pkt_data;
					r_data2_write_flag <= 1'b1;         
				end
				else begin
					r_data1_write_flag <= 1'b0; 
					r_data2_write_flag <= 1'b0;             
				end
            end			
        end
        else begin 
            r_data1_write_flag <= 1'b0; 
            r_data2_write_flag <= 1'b0; 
        end 
    end
end
//***************************************************
//         receive the last cycle of pkt 
//***************************************************
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        o_pkt_last_cycle_rx <= 1'b0;
    end
    else begin  
        if((iv_pkt_data[133:132] == 2'b10)&&(i_pkt_data_wr == 1'b1))begin
            o_pkt_last_cycle_rx <= 1'b1;
        end
        else begin
            o_pkt_last_cycle_rx <= 1'b0;
        end
    end
end

//***************************************************
//                 transmit pkt 
//***************************************************
reg                     r_data1_read_flag;
reg                     r_data2_read_flag;
reg        [1:0]        r_tran_reg;
reg                     r_eth_flag;//1:eth data;0:not eth data

reg        [10:0]       rv_send_pkt_cnt;
reg        [3:0]        rv_trans_pkt_cnt;
reg        [4:0]        rv_interframe_gap_cnt;
reg        [18:0]       rv_receive_timestamp;
reg        [63:0]       rv_transparent_timestamp;
reg        [47:0]       rv_global_timestamp;
output reg [3:0]        hoi_state;
localparam  IDLE_S                    = 4'd0,
            TRANS_DATA1_S             = 4'd1,
            TRANS_DATA2_S             = 4'd2,
            TRANS_INTERFRAME_GAP_S    = 4'd3;
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_hcp_data              <= 8'b0;
        o_hcp_data_wr            <= 1'b0;
        ov_eth_data              <= 8'b0;
        o_eth_data_wr            <= 1'b0;
        r_eth_flag               <= 1'b0;
        rv_trans_pkt_cnt         <= 4'd0;
        rv_send_pkt_cnt          <= 11'd0;
        r_data1_read_flag        <= 1'b0;  
        r_data2_read_flag        <= 1'b0;          
        rv_interframe_gap_cnt    <= 5'd0;
        rv_receive_timestamp     <= 19'b0;
        rv_transparent_timestamp <= 64'b0;
        rv_global_timestamp      <= 48'b0;
        ov_pkt_cnt               <= 32'b0;
        r_tran_reg               <= 2'b0;
        hoi_state                <= IDLE_S;
    end
    else begin
        case(hoi_state)
            IDLE_S:begin
                rv_interframe_gap_cnt <= 5'd0;
                if((r_data1_empty == 1'b0) && (r_data2_empty == 1'b0))begin
                    if(rv_data1[133:132] == 2'b01)begin
                        if((rv_data1[31:16] == 16'hff01)||(rv_data1[31:16] == 16'h88f7)||(rv_data1[31:16] == 16'h891d)||(rv_data1[31:16] == 16'h1800))begin
                            ov_hcp_data      <= rv_data1[127:120];    //first byte of frame.
                            o_hcp_data_wr    <= 1'b1;
                            r_eth_flag       <= 1'b0;//not eth data
                            rv_trans_pkt_cnt <= 4'd1;
                        end
                        else begin
                            ov_eth_data      <= rv_data1[127:120];    //first byte of frame.
                            o_eth_data_wr    <= 1'b1;
                            r_eth_flag       <= 1'b1;//eth data
                            rv_trans_pkt_cnt <= 4'd1;                        
                        end
                        rv_send_pkt_cnt <= 11'd1;
                        ov_pkt_cnt <= ov_pkt_cnt + 1'b1;                        
                        hoi_state <= TRANS_DATA1_S;
                        r_tran_reg <=2'd1;
                    end
                    else if(rv_data2[133:132] == 2'b01)begin
                        if((rv_data2[31:16] == 16'hff01)||(rv_data2[31:16] == 16'h88f7)||(rv_data2[31:16] == 16'h891d)||(rv_data2[31:16] == 16'h1800))begin
                            ov_hcp_data      <= rv_data2[127:120];    //first byte of frame.
                            o_hcp_data_wr    <= 1'b1;
                            r_eth_flag       <= 1'b0;//not eth data.
                            rv_trans_pkt_cnt <= 4'd1;
                        end
                        else begin
                            ov_eth_data      <= rv_data2[127:120];    //first byte of frame.
                            o_eth_data_wr    <= 1'b1;
                            r_eth_flag       <= 1'b1;//eth data
                            rv_trans_pkt_cnt <= 4'd1;                        
                        end
                        rv_send_pkt_cnt <= 11'd1; 
                        ov_pkt_cnt <= ov_pkt_cnt + 1'b1;                        
                        hoi_state <= TRANS_DATA2_S;
                        r_tran_reg <=2'd2;
                    end
                    else begin
                        ov_hcp_data      <= 8'h0;
                        o_hcp_data_wr    <= 1'b0;
                        ov_eth_data      <= 8'b0;
                        o_eth_data_wr    <= 1'b0; 
                        r_eth_flag       <= 1'b0;                   
                        rv_send_pkt_cnt  <= 11'd0;
                        rv_trans_pkt_cnt <= 4'd0;                    
                        hoi_state        <= IDLE_S;
                    end
                end
                else begin
                    ov_hcp_data      <= 8'h0;
                    o_hcp_data_wr    <= 1'b0;
                    ov_eth_data      <= 8'b0;
                    o_eth_data_wr    <= 1'b0; 
                    r_eth_flag       <= 1'b0;                   
                    rv_send_pkt_cnt  <= 11'd0;
                    rv_trans_pkt_cnt <= 4'd0;                    
                    hoi_state        <= IDLE_S;                
                end
            end             
            TRANS_DATA1_S:begin 
                rv_trans_pkt_cnt <= rv_trans_pkt_cnt + 4'd1;
                if(!r_eth_flag)begin
                    case(rv_trans_pkt_cnt)
                        4'h0:ov_hcp_data <= rv_data1[127:120];
                        4'h1:ov_hcp_data <= rv_data1[119:112];
                        4'h2:ov_hcp_data <= rv_data1[111:104];
                        4'h3:ov_hcp_data <= rv_data1[103:96];
                        4'h4:ov_hcp_data <= rv_data1[95:88];                    
                        4'h5:ov_hcp_data <= rv_data1[87:80];
                        4'h6:ov_hcp_data <= rv_data1[79:72];
                        4'h7:ov_hcp_data <= rv_data1[71:64];
                        4'h8:ov_hcp_data <= rv_data1[63:56];
                        4'h9:ov_hcp_data <= rv_data1[55:48];
                        4'ha:ov_hcp_data <= rv_data1[47:40];
                        4'hb:ov_hcp_data <= rv_data1[39:32];
                        4'hc:ov_hcp_data <= rv_data1[31:24];                    
                        4'hd:ov_hcp_data <= rv_data1[23:16];
                        4'he:ov_hcp_data <= rv_data1[15:8]; 
                        4'hf:ov_hcp_data <= rv_data1[7:0];                      
                    endcase
                end
                else begin
                    case(rv_trans_pkt_cnt)
                        4'h0:ov_eth_data <= rv_data1[127:120];
                        4'h1:ov_eth_data <= rv_data1[119:112];
                        4'h2:ov_eth_data <= rv_data1[111:104];
                        4'h3:ov_eth_data <= rv_data1[103:96];
                        4'h4:ov_eth_data <= rv_data1[95:88];                    
                        4'h5:ov_eth_data <= rv_data1[87:80];
                        4'h6:ov_eth_data <= rv_data1[79:72];
                        4'h7:ov_eth_data <= rv_data1[71:64];
                        4'h8:ov_eth_data <= rv_data1[63:56];
                        4'h9:ov_eth_data <= rv_data1[55:48];
                        4'ha:ov_eth_data <= rv_data1[47:40];
                        4'hb:ov_eth_data <= rv_data1[39:32];
                        4'hc:ov_eth_data <= rv_data1[31:24];                    
                        4'hd:ov_eth_data <= rv_data1[23:16];
                        4'he:ov_eth_data <= rv_data1[15:8]; 
                        4'hf:ov_eth_data <= rv_data1[7:0];                      
                    endcase                
                end
                if(rv_data1[133:132]==2'b10)begin
                    if(rv_data1[131:128] + rv_trans_pkt_cnt == 4'hf)begin
                        hoi_state <= TRANS_INTERFRAME_GAP_S;
                        r_data1_read_flag <= 1'b1;  
                        r_data2_read_flag <= 1'b0;
                    end
                    else begin
                        r_data1_read_flag <= 1'b0;  
                        r_data2_read_flag <= 1'b0;                  
                        hoi_state <= TRANS_DATA1_S;
                    end
                end
                else begin
                    if(rv_trans_pkt_cnt == 4'hf)begin
                        r_data1_read_flag <= 1'b1;  
                        r_data2_read_flag <= 1'b0;  
                        hoi_state <= TRANS_DATA2_S;
                    end
                    else begin
                        r_data1_read_flag <= 1'b0;  
                        r_data2_read_flag <= 1'b0;  
                        hoi_state <= TRANS_DATA1_S;
                    end
                end
            end         
            TRANS_DATA2_S:begin 
                rv_trans_pkt_cnt <= rv_trans_pkt_cnt + 4'd1;
                if(!r_eth_flag)begin
                    case(rv_trans_pkt_cnt)
                        4'h0:ov_hcp_data <= rv_data2[127:120];
                        4'h1:ov_hcp_data <= rv_data2[119:112];
                        4'h2:ov_hcp_data <= rv_data2[111:104];
                        4'h3:ov_hcp_data <= rv_data2[103:96];
                        4'h4:ov_hcp_data <= rv_data2[95:88];                    
                        4'h5:ov_hcp_data <= rv_data2[87:80];
                        4'h6:ov_hcp_data <= rv_data2[79:72];
                        4'h7:ov_hcp_data <= rv_data2[71:64];
                        4'h8:ov_hcp_data <= rv_data2[63:56];
                        4'h9:ov_hcp_data <= rv_data2[55:48];
                        4'ha:ov_hcp_data <= rv_data2[47:40];
                        4'hb:ov_hcp_data <= rv_data2[39:32];
                        4'hc:ov_hcp_data <= rv_data2[31:24];                    
                        4'hd:ov_hcp_data <= rv_data2[23:16];
                        4'he:ov_hcp_data <= rv_data2[15:8]; 
                        4'hf:ov_hcp_data <= rv_data2[7:0];              
                    endcase
                end
                else begin
                    case(rv_trans_pkt_cnt)
                        4'h0:ov_eth_data <= rv_data2[127:120];
                        4'h1:ov_eth_data <= rv_data2[119:112];
                        4'h2:ov_eth_data <= rv_data2[111:104];
                        4'h3:ov_eth_data <= rv_data2[103:96];
                        4'h4:ov_eth_data <= rv_data2[95:88];                    
                        4'h5:ov_eth_data <= rv_data2[87:80];
                        4'h6:ov_eth_data <= rv_data2[79:72];
                        4'h7:ov_eth_data <= rv_data2[71:64];
                        4'h8:ov_eth_data <= rv_data2[63:56];
                        4'h9:ov_eth_data <= rv_data2[55:48];
                        4'ha:ov_eth_data <= rv_data2[47:40];
                        4'hb:ov_eth_data <= rv_data2[39:32];
                        4'hc:ov_eth_data <= rv_data2[31:24];                    
                        4'hd:ov_eth_data <= rv_data2[23:16];
                        4'he:ov_eth_data <= rv_data2[15:8]; 
                        4'hf:ov_eth_data <= rv_data2[7:0];              
                    endcase
                end                
                if(rv_data2[133:132]==2'b10)begin
                    if(rv_data2[131:128] + rv_trans_pkt_cnt == 4'hf)begin
                        r_data1_read_flag <= 1'b0;  
                        r_data2_read_flag <= 1'b1;  
                        hoi_state <= TRANS_INTERFRAME_GAP_S;
                    end
                    else begin
                        r_data1_read_flag <= 1'b0;  
                        r_data2_read_flag <= 1'b0;
                        hoi_state <= TRANS_DATA2_S;
                    end
                end
                else begin
                    if(rv_trans_pkt_cnt == 4'hf)begin
                        r_data1_read_flag <= 1'b0;  
                        r_data2_read_flag <= 1'b1;
                        hoi_state <= TRANS_DATA1_S;
                    end
                    else begin
                        r_data1_read_flag <= 1'b0;  
                        r_data2_read_flag <= 1'b0;
                        hoi_state <= TRANS_DATA2_S;
                    end
                end
            end      
            TRANS_INTERFRAME_GAP_S:begin//transmit interframe gap(12 bytes) + 4B CRC
                r_data1_read_flag <= 1'b0;  
                r_data2_read_flag <= 1'b0;
                if(!r_eth_flag)begin
                    o_hcp_data_wr   <= 1'b0;
                end
                else begin
                    o_eth_data_wr   <= 1'b0;
                end
                rv_interframe_gap_cnt <= rv_interframe_gap_cnt + 1'd1;
                if(rv_interframe_gap_cnt <= 5'd22)begin
                    hoi_state <= TRANS_INTERFRAME_GAP_S;
                end
                else begin
                    hoi_state <= IDLE_S;
                end
            end         
            default:begin
                o_hcp_data_wr             <= 1'b0;
                o_eth_data_wr         <= 1'b0;
                r_data1_read_flag     <= 1'b0;  
                r_data2_read_flag     <= 1'b0;              
                rv_trans_pkt_cnt      <= 4'h0;
                rv_interframe_gap_cnt <= 5'd0;
                hoi_state             <= IDLE_S;
            end
        endcase
    end
end
//***************************************************
//       judge whether reg1 & reg2 is empty 
//***************************************************
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        r_data1_empty <= 1'b1; 
        r_data2_empty <= 1'b1;      
    end
    else begin
        if(r_data1_write_flag == 1'b1 && r_data1_read_flag == 1'b1)begin
            r_data1_empty <= r_data1_empty;
        end
        else if(r_data1_write_flag == 1'b1 && r_data1_read_flag == 1'b0)begin
            r_data1_empty <= 1'b0;
        end 
        else if(r_data1_write_flag == 1'b0 && r_data1_read_flag == 1'b1)begin
            r_data1_empty <= 1'b1;
        end         
        else if(r_data1_write_flag == 1'b0 && r_data1_read_flag == 1'b0)begin
            r_data1_empty <= r_data1_empty;
        end 
        
        if(r_data2_write_flag == 1'b1 && r_data2_read_flag == 1'b1)begin
            r_data2_empty <= r_data2_empty;
        end
        else if(r_data2_write_flag == 1'b1 && r_data2_read_flag == 1'b0)begin
            r_data2_empty <= 1'b0;
        end 
        else if(r_data2_write_flag == 1'b0 && r_data2_read_flag == 1'b1)begin
            r_data2_empty <= 1'b1;
        end         
        else if(r_data2_write_flag == 1'b0 && r_data2_read_flag == 1'b0)begin
            r_data2_empty <= r_data2_empty;
        end         
    end
end 
endmodule