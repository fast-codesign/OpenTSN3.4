// Copyright (C) 1953-2021 NUDT
// Verilog module name - standard_packet_action
// Version: V3.2.0.20210722
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         judge outport of standard ethernet packet
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module standard_packet_action
(
        i_clk,
        i_rst_n,
              
        iv_outport,
		i_mac_entry_hit,
        iv_pkt_bufid,
        iv_pkt_type,
        iv_pkt_inport,
        i_action_req,
        o_action_ack,	   
    
        ov_pkt_bufid_p0,
        ov_pkt_type_p0,
        o_pkt_bufid_req_p0,
		i_pkt_bufid_ack_p0,
        
        ov_pkt_bufid_p1,
        ov_pkt_type_p1,
        o_pkt_bufid_req_p1,
		i_pkt_bufid_ack_p1,
        
        ov_pkt_bufid_p2,
        ov_pkt_type_p2,
        o_pkt_bufid_req_p2,
		i_pkt_bufid_ack_p2,
        
        ov_pkt_bufid_p3,
        ov_pkt_type_p3,
        o_pkt_bufid_req_p3,
		i_pkt_bufid_ack_p3,
        
        ov_pkt_bufid_p4,
        ov_pkt_type_p4,
        o_pkt_bufid_req_p4,
		i_pkt_bufid_ack_p4,
        
        ov_pkt_bufid_p5,
        ov_pkt_type_p5,
        o_pkt_bufid_req_p5,
		i_pkt_bufid_ack_p5,
        
        ov_pkt_bufid_p6,
        ov_pkt_type_p6,
        o_pkt_bufid_req_p6,
		i_pkt_bufid_ack_p6,
        
        ov_pkt_bufid_p7,
        ov_pkt_type_p7,
        o_pkt_bufid_req_p7,
		i_pkt_bufid_ack_p7,
        
        ov_pkt_bufid_host,
        ov_pkt_type_host,
        ov_pkt_inport_host,
		o_mac_entry_hit_host,
        o_pkt_bufid_req_host,
		i_pkt_bufid_ack_host,
        
        ov_pkt_bufid,        
        o_pkt_bufid_req,
        i_pkt_bufid_ack, 		
        ov_pkt_bufid_cnt 
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
// pkt_bufid and pkt_type and outport from lookup_table
input      [8:0]       iv_outport;
input                  i_mac_entry_hit;
input      [8:0]       iv_pkt_bufid;
input      [2:0]       iv_pkt_type;
input      [3:0]       iv_pkt_inport;
input                  i_action_req;
output reg             o_action_ack;
// pkt_bufid and pkt_type to p0
output reg [8:0]       ov_pkt_bufid_p0;
output reg [2:0]       ov_pkt_type_p0;
output reg             o_pkt_bufid_req_p0;
input                  i_pkt_bufid_ack_p0;
// pkt_bufid and pkt_type to p1   
output reg [8:0]       ov_pkt_bufid_p1;
output reg [2:0]       ov_pkt_type_p1;
output reg             o_pkt_bufid_req_p1;
input                  i_pkt_bufid_ack_p1;
// pkt_bufid and pkt_type to p2    
output reg [8:0]       ov_pkt_bufid_p2;
output reg [2:0]       ov_pkt_type_p2;
output reg             o_pkt_bufid_req_p2;
input                  i_pkt_bufid_ack_p2;
// pkt_bufid and pkt_type to p3    
output reg [8:0]       ov_pkt_bufid_p3;
output reg [2:0]       ov_pkt_type_p3;
output reg             o_pkt_bufid_req_p3;
input                  i_pkt_bufid_ack_p3;
// pkt_bufid and pkt_type to p4    
output reg [8:0]       ov_pkt_bufid_p4;
output reg [2:0]       ov_pkt_type_p4;
output reg             o_pkt_bufid_req_p4;
input                  i_pkt_bufid_ack_p4;
// pkt_bufid and pkt_type to p5    
output reg [8:0]       ov_pkt_bufid_p5;
output reg [2:0]       ov_pkt_type_p5;
output reg             o_pkt_bufid_req_p5;
input                  i_pkt_bufid_ack_p5;
// pkt_bufid and pkt_type to p6    
output reg [8:0]       ov_pkt_bufid_p6;
output reg [2:0]       ov_pkt_type_p6;
output reg             o_pkt_bufid_req_p6;
input                  i_pkt_bufid_ack_p6;
// pkt_bufid and pkt_type to p7    
output reg [8:0]       ov_pkt_bufid_p7;
output reg [2:0]       ov_pkt_type_p7;
output reg             o_pkt_bufid_req_p7;
input                  i_pkt_bufid_ack_p7;
// pkt_bufid and pkt_type to host      
output reg [8:0]       ov_pkt_bufid_host;
output reg [2:0]       ov_pkt_type_host;
output reg             o_mac_entry_hit_host;
output reg [3:0]       ov_pkt_inport_host;
output reg             o_pkt_bufid_req_host;
input                  i_pkt_bufid_ack_host;
//forward cnt to pkt_centralize_bufm_memory
output reg [8:0]       ov_pkt_bufid;
output reg             o_pkt_bufid_req;
input                  i_pkt_bufid_ack;
output reg [3:0]       ov_pkt_bufid_cnt;
//***************************************************
//                    forward
//***************************************************
reg         spa_state;
localparam  IDLE_S = 2'd0,
            WAIT_ACK_S = 2'd1;
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
	    o_action_ack <= 1'b0;
		
        ov_pkt_bufid_p0      <= 9'h0;
        ov_pkt_type_p0       <= 3'h0;
        o_pkt_bufid_req_p0   <= 1'h0;
                            
        ov_pkt_bufid_p1      <= 9'h0;
        ov_pkt_type_p1       <= 3'h0;
        o_pkt_bufid_req_p1   <= 1'h0;
                             
        ov_pkt_bufid_p2      <= 9'h0;
        ov_pkt_type_p2       <= 3'h0;
        o_pkt_bufid_req_p2   <= 1'h0;
        
        ov_pkt_bufid_p3      <= 9'h0;
        ov_pkt_type_p3       <= 3'h0;
        o_pkt_bufid_req_p3   <= 1'h0;
        
        ov_pkt_bufid_p4      <= 9'h0;
        ov_pkt_type_p4       <= 3'h0;
        o_pkt_bufid_req_p4   <= 1'h0;
        
        ov_pkt_bufid_p5      <= 9'h0;
        ov_pkt_type_p5       <= 3'h0;
        o_pkt_bufid_req_p5   <= 1'h0;
        
        ov_pkt_bufid_p6      <= 9'h0;
        ov_pkt_type_p6       <= 3'h0;
        o_pkt_bufid_req_p6   <= 1'h0;
        
        ov_pkt_bufid_p7      <= 9'h0;
        ov_pkt_type_p7       <= 3'h0;
        o_pkt_bufid_req_p7   <= 1'h0;
                            
        ov_pkt_bufid_host    <= 9'h0;
        ov_pkt_type_host     <= 3'h0;
        o_mac_entry_hit_host <= 1'h0;
        ov_pkt_inport_host   <= 4'h0;
        o_pkt_bufid_req_host <= 1'h0;
                                     
        ov_pkt_bufid         <= 9'h0;
        o_pkt_bufid_req      <= 1'h0;
        ov_pkt_bufid_cnt     <= 4'h0;
		
		spa_state <= IDLE_S;
    end                              
    else begin
	    case(spa_state)
		    IDLE_S:begin
				if(i_action_req == 1'b1)begin
					ov_pkt_bufid_p0      <= iv_pkt_bufid;
					ov_pkt_type_p0       <= iv_pkt_type;

					ov_pkt_bufid_p1      <= iv_pkt_bufid;
					ov_pkt_type_p1       <= iv_pkt_type;

					ov_pkt_bufid_p2      <= iv_pkt_bufid;
					ov_pkt_type_p2       <= iv_pkt_type;

					ov_pkt_bufid_p3      <= iv_pkt_bufid;
					ov_pkt_type_p3       <= iv_pkt_type;

					ov_pkt_bufid_p4      <= iv_pkt_bufid;
					ov_pkt_type_p4       <= iv_pkt_type;

					ov_pkt_bufid_p5      <= iv_pkt_bufid;
					ov_pkt_type_p5       <= iv_pkt_type;

					ov_pkt_bufid_p6      <= iv_pkt_bufid;
					ov_pkt_type_p6       <= iv_pkt_type;

					ov_pkt_bufid_p7      <= iv_pkt_bufid;
					ov_pkt_type_p7       <= iv_pkt_type;

					ov_pkt_bufid_host    <= iv_pkt_bufid;
					ov_pkt_type_host     <= iv_pkt_type;
					o_mac_entry_hit_host <= i_mac_entry_hit;
					ov_pkt_inport_host   <= iv_pkt_inport;
					
					ov_pkt_bufid         <= iv_pkt_bufid;
					o_pkt_bufid_req      <= 1'b1;
					
					o_action_ack <= 1'b1;
					spa_state <= WAIT_ACK_S;
					if(|iv_outport == 1'b0)begin//if result is 0,transmit the pkt to host
						o_pkt_bufid_req_p0    <= 1'b0;
						o_pkt_bufid_req_p1    <= 1'b0;
						o_pkt_bufid_req_p2    <= 1'b0;
						o_pkt_bufid_req_p3    <= 1'b0;
						o_pkt_bufid_req_p4    <= 1'b0;
						o_pkt_bufid_req_p5    <= 1'b0;
						o_pkt_bufid_req_p6    <= 1'b0;
						o_pkt_bufid_req_p7    <= 1'b0;
						o_pkt_bufid_req_host  <= 1'b1;
						ov_pkt_bufid_cnt      <= 4'b1;
					end
					else begin//forword the pkt base on result
						o_pkt_bufid_req_p0    <= iv_outport[0];
						o_pkt_bufid_req_p1    <= iv_outport[1];
						o_pkt_bufid_req_p2    <= iv_outport[2];
						o_pkt_bufid_req_p3    <= iv_outport[3];
						//o_pkt_bufid_req_p4    <= iv_outport[4];
						//o_pkt_bufid_req_p5    <= iv_outport[5];
						//o_pkt_bufid_req_p6    <= iv_outport[6];
						//o_pkt_bufid_req_p7    <= iv_outport[7];
						o_pkt_bufid_req_host  <= iv_outport[8];
						ov_pkt_bufid_cnt     <= iv_outport[0] + iv_outport[1] + iv_outport[2] + iv_outport[3] + iv_outport[8];
                        //ov_pkt_bufid_cnt     <= iv_outport[0] + iv_outport[1] + iv_outport[2] + iv_outport[3] + iv_outport[4] + iv_outport[5] + iv_outport[6] + iv_outport[7] + iv_outport[8];
					end 
				end
				else begin
					ov_pkt_bufid_p0      <= 9'h0;
					ov_pkt_type_p0       <= 3'h0;
					o_pkt_bufid_req_p0   <= 1'h0;
										
					ov_pkt_bufid_p1      <= 9'h0;
					ov_pkt_type_p1       <= 3'h0;
					o_pkt_bufid_req_p1   <= 1'h0;
										 
					ov_pkt_bufid_p2      <= 9'h0;
					ov_pkt_type_p2       <= 3'h0;
					o_pkt_bufid_req_p2   <= 1'h0;
					
					ov_pkt_bufid_p3      <= 9'h0;
					ov_pkt_type_p3       <= 3'h0;
					o_pkt_bufid_req_p3   <= 1'h0;
					
					ov_pkt_bufid_p4      <= 9'h0;
					ov_pkt_type_p4       <= 3'h0;
					o_pkt_bufid_req_p4    <= 1'h0;
					
					ov_pkt_bufid_p5      <= 9'h0;
					ov_pkt_type_p5       <= 3'h0;
					o_pkt_bufid_req_p5   <= 1'h0;
					
					ov_pkt_bufid_p6      <= 9'h0;
					ov_pkt_type_p6       <= 3'h0;
					o_pkt_bufid_req_p6   <= 1'h0;
					
					ov_pkt_bufid_p7      <= 9'h0;
					ov_pkt_type_p7       <= 3'h0;
					o_pkt_bufid_req_p7   <= 1'h0;
										
					ov_pkt_bufid_host    <= 9'h0;
					ov_pkt_type_host     <= 3'h0;
					o_mac_entry_hit_host <= 1'h0;
					ov_pkt_inport_host   <= 4'h0;
					o_pkt_bufid_req_host <= 1'h0;
					
					ov_pkt_bufid         <= 9'h0;
					o_pkt_bufid_req      <= 1'h0;
					ov_pkt_bufid_cnt     <= 4'h0;
					
					o_action_ack <= 1'b0;
					spa_state <= IDLE_S;
				end
			end
			WAIT_ACK_S:begin
			    o_action_ack <= 1'b0;
			    if(i_pkt_bufid_ack_p0|i_pkt_bufid_ack_p1|i_pkt_bufid_ack_p2|i_pkt_bufid_ack_p3|i_pkt_bufid_ack_p4|i_pkt_bufid_ack_p5|i_pkt_bufid_ack_p6|i_pkt_bufid_ack_p7|i_pkt_bufid_ack_host|i_pkt_bufid_ack)begin
					ov_pkt_bufid_p0      <= 9'h0;
					ov_pkt_type_p0       <= 3'h0;
					o_pkt_bufid_req_p0   <= 1'h0;
										
					ov_pkt_bufid_p1      <= 9'h0;
					ov_pkt_type_p1       <= 3'h0;
					o_pkt_bufid_req_p1   <= 1'h0;
										 
					ov_pkt_bufid_p2      <= 9'h0;
					ov_pkt_type_p2       <= 3'h0;
					o_pkt_bufid_req_p2   <= 1'h0;
					
					ov_pkt_bufid_p3      <= 9'h0;
					ov_pkt_type_p3       <= 3'h0;
					o_pkt_bufid_req_p3   <= 1'h0;
					
					ov_pkt_bufid_p4      <= 9'h0;
					ov_pkt_type_p4       <= 3'h0;
					o_pkt_bufid_req_p4    <= 1'h0;
					
					ov_pkt_bufid_p5      <= 9'h0;
					ov_pkt_type_p5       <= 3'h0;
					o_pkt_bufid_req_p5   <= 1'h0;
					
					ov_pkt_bufid_p6      <= 9'h0;
					ov_pkt_type_p6       <= 3'h0;
					o_pkt_bufid_req_p6   <= 1'h0;
					
					ov_pkt_bufid_p7      <= 9'h0;
					ov_pkt_type_p7       <= 3'h0;
					o_pkt_bufid_req_p7   <= 1'h0;
										
					ov_pkt_bufid_host    <= 9'h0;
					ov_pkt_type_host     <= 3'h0;
					o_mac_entry_hit_host <= 1'h0;
					ov_pkt_inport_host   <= 4'h0;
					o_pkt_bufid_req_host <= 1'h0;
					
					ov_pkt_bufid         <= 9'h0;
					o_pkt_bufid_req      <= 1'h0;
					ov_pkt_bufid_cnt     <= 4'h0;
                    
					spa_state <= IDLE_S;					
				end
				else begin
				    spa_state <= WAIT_ACK_S;
				end
			end
			default:begin
			    spa_state <= IDLE_S;	
			end
	    endcase
    end
end
endmodule