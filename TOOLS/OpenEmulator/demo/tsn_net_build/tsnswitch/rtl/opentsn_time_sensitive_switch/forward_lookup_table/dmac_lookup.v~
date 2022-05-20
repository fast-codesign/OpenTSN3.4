// Copyright (C) 1953-2022 NUDT
// Verilog module name - dmac_lookup
// Version: V3.4.0.20220225
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         lookup dmac forward table.
///////////////////////////////////////////////////////////////////////////


module dmac_lookup
(
        i_clk,
        i_rst_n,
        
        iv_local_id,
       
        iv_fifo_rdata,
        i_fifo_empty,
		o_fifo_rd,
       
        o_tsmp_lookup_table_key_wr,
        ov_tsmp_lookup_table_key,
        iv_tsmp_lookup_table_outport,
        i_tsmp_lookup_table_outport_wr,
        
        o_dmac_ram_rd,
        ov_dmac_ram_raddr,
        iv_dmac_ram_rdata,        
        
        ov_outport,
        o_entry_hit,
		ov_pkt_type,
		ov_pkt_inport,
        ov_pkt_bufid,
		o_action_req,
        i_action_ack
);
// I/O
// clk & rst  
input               i_clk;
input               i_rst_n;

input       [11:0]  iv_local_id;
//
input       [70:0]  iv_fifo_rdata;
input               i_fifo_empty;
output reg          o_fifo_rd;
//read ram
output reg          o_tsmp_lookup_table_key_wr;
output reg  [47:0]  ov_tsmp_lookup_table_key;
input       [32:0]  iv_tsmp_lookup_table_outport;
input               i_tsmp_lookup_table_outport_wr;

output reg          o_dmac_ram_rd;
output reg  [4:0]   ov_dmac_ram_raddr;
input       [56:0]  iv_dmac_ram_rdata;
//output 
output reg  [8:0]   ov_outport;
output reg          o_entry_hit;
output reg  [2:0]   ov_pkt_type;
output reg  [3:0]   ov_pkt_inport;
output reg  [8:0]   ov_pkt_bufid;
output reg          o_action_req;
input               i_action_ack;
//***************************************************
//          lookup dmac forward table
//***************************************************
// internal reg&wire for state machine 
reg         [3:0]   dlu_state;
localparam  IDLE_S = 4'd0,
            WAIT_FIRST_S = 4'd1,
            WAIT_SECOND_S = 4'd2,
            LOOKUP_TABLE_S = 4'd3,
            RECEIVE_TSMP_RESULT_S = 4'd4,
            WAIT_ACK_S = 4'd5;
always @(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n)begin
        ov_tsmp_lookup_table_key   <= 48'd0;
        o_tsmp_lookup_table_key_wr <= 1'b0;
        
        ov_dmac_ram_raddr <= 5'd0;
        o_dmac_ram_rd <= 1'b0;        
		
		o_fifo_rd <= 1'b0;

        ov_outport <= 9'b0;
		o_entry_hit <= 1'b0;
		ov_pkt_type <= 3'b0;
		ov_pkt_inport <= 4'b0;
		ov_pkt_bufid <= 9'b0;
        o_action_req <= 1'b0;

        dlu_state <= IDLE_S;
    end
    else begin
        case(dlu_state)
            IDLE_S:begin
                if(!i_fifo_empty)begin
					if(iv_fifo_rdata[18])begin//need to lookup table
                        if(iv_fifo_rdata[70:47] == 24'h662662)begin//tsmp packet
                            //if(iv_fifo_rdata[34:25] == iv_local_id[11:2])begin//tsmp_mid = local_mid
                            //    ov_pkt_bufid  <= iv_fifo_rdata[8:0];
                            //    ov_pkt_inport <= iv_fifo_rdata[22:19];
                            //    ov_pkt_type   <= 3'd6;
                            //    o_entry_hit   <= 1'b1;
                            //    ov_outport    <= 9'h100;//ctrl port
                            //    o_fifo_rd     <= 1'b1;
                            //
                            //    ov_tsmp_lookup_table_key   <= 48'b0;
                            //    o_tsmp_lookup_table_key_wr <= 1'b0;
                            //    ov_dmac_ram_raddr <= 5'd0;
                            //    o_dmac_ram_rd     <= 1'b0; 
                            //    
                            //    o_action_req      <= 1'b1; 
                            //    dlu_state         <= WAIT_ACK_S;                                 
                            //end
                            //else begin
                                ov_pkt_bufid <= 9'b0;
                                ov_pkt_inport <= 4'b0;
                                ov_pkt_type <= 3'b0;
                                o_entry_hit <= 1'b0;
                                ov_outport <= 9'b0;
                                o_fifo_rd  <= 1'b0;

                                ov_tsmp_lookup_table_key   <= iv_fifo_rdata[70:23];//mac address
                                o_tsmp_lookup_table_key_wr <= 1'b1;
                                ov_dmac_ram_raddr          <= 5'd0;
                                o_dmac_ram_rd              <= 1'b0; 
                                                           
                                o_action_req               <= 1'b0;
                                dlu_state                  <= RECEIVE_TSMP_RESULT_S;                                
                            //end
                        end
                        else begin// not tsmp packet.
                            ov_pkt_bufid  <= 9'b0;
                            ov_pkt_inport <= 4'b0;
                            ov_pkt_type   <= 3'b0;
                            o_entry_hit   <= 1'b0;
                            ov_outport    <= 9'b0;
                            o_fifo_rd     <= 1'b0;
                        
                            ov_tsmp_lookup_table_key   <= 48'b0;
                            o_tsmp_lookup_table_key_wr <= 1'b0;
                            ov_dmac_ram_raddr          <= 5'd0;
                            o_dmac_ram_rd              <= 1'b1;
                            
                            o_action_req <= 1'b0;
                            dlu_state    <= WAIT_FIRST_S;
                        end
                    end
                    else begin//not need to lookup table
                        ov_pkt_bufid  <= iv_fifo_rdata[8:0];
                        ov_pkt_inport <= iv_fifo_rdata[22:19];
                        ov_pkt_type   <= 3'd6;
                        o_entry_hit   <= 1'b1;
                        ov_outport    <= iv_fifo_rdata[17:9];
                        o_fifo_rd     <= 1'b1;
                        ov_tsmp_lookup_table_key    <= 48'd0;
                        o_tsmp_lookup_table_key_wr  <= 1'b0;
                        ov_dmac_ram_raddr <= 5'd0;
                        o_dmac_ram_rd     <= 1'b0;
                        
						o_action_req      <= 1'b1;
						dlu_state         <= WAIT_ACK_S;                
                    end
                end
                else begin
                    ov_pkt_bufid  <= 9'b0;
                    ov_pkt_inport <= 4'b0;
                    ov_pkt_type   <= 3'b0;
                    o_entry_hit   <= 1'b0;
                    ov_outport    <= 9'b0;
                    o_fifo_rd     <= 1'b0;
                    
                    ov_tsmp_lookup_table_key    <= 48'd0;
                    o_tsmp_lookup_table_key_wr  <= 1'b0;
                    ov_dmac_ram_raddr <= 5'd0;
                    o_dmac_ram_rd     <= 1'b0;
                    
                    o_action_req      <= 1'b0;
                    dlu_state         <= IDLE_S;                
                end
            end
            WAIT_FIRST_S:begin//get data of reading ram after 2 cycles. 
                ov_tsmp_lookup_table_key       <= 48'd0;
                o_tsmp_lookup_table_key_wr     <= 1'b0;
                
                o_dmac_ram_rd     <= 1'b1;
                ov_dmac_ram_raddr <= ov_dmac_ram_raddr + 1'b1;                
                dlu_state         <= WAIT_SECOND_S;
			end
			WAIT_SECOND_S:begin 
                ov_tsmp_lookup_table_key       <= 48'd0;
                o_tsmp_lookup_table_key_wr     <= 1'b0;
                
                o_dmac_ram_rd <= 1'b1;
                ov_dmac_ram_raddr <= ov_dmac_ram_raddr + 1'b1;                
                dlu_state <= LOOKUP_TABLE_S;
			end
			LOOKUP_TABLE_S:begin
				if(iv_dmac_ram_rdata[47:0] != 48'b0)begin//table entry is valid
					if(iv_dmac_ram_rdata[47:0] == iv_fifo_rdata[70:23])begin//match entry
						o_dmac_ram_rd <= 1'b0;
						ov_dmac_ram_raddr <= 5'b0;
						
                        o_fifo_rd <= 1'b1;

						ov_outport <= iv_dmac_ram_rdata[56:48];
						o_entry_hit <= 1'b1;
						ov_pkt_type <= 3'd6;
						ov_pkt_inport <= iv_fifo_rdata[22:19];
						ov_pkt_bufid <= iv_fifo_rdata[8:0];
						o_action_req <= 1'b1;
                        
						dlu_state <= WAIT_ACK_S;	                    
					end                   
					else begin//not match entry
						if(ov_dmac_ram_raddr == 5'h01)begin//not match all entries.
							o_dmac_ram_rd <= 1'b0;
							ov_dmac_ram_raddr <= 5'b0;
                            
							o_fifo_rd <= 1'b1;

							ov_outport <= ~{9'd1 << iv_fifo_rdata[22:19]};
							o_entry_hit <= 1'b0;
							ov_pkt_type <= 3'd6;
							ov_pkt_inport <= iv_fifo_rdata[22:19];
							ov_pkt_bufid <= iv_fifo_rdata[8:0];
							o_action_req <= 1'b1;
                            
							dlu_state <= WAIT_ACK_S;                          
						end
						else begin
							o_dmac_ram_rd <= 1'b1;
							ov_dmac_ram_raddr <= ov_dmac_ram_raddr + 1'b1;
							
							o_fifo_rd <= 1'b0;

							ov_outport <= 9'b0;
							o_entry_hit <= 1'b0;
							ov_pkt_type <= 3'b0;
							ov_pkt_inport <= 4'b0;
							ov_pkt_bufid <= 9'b0;
							o_action_req <= 1'b0;
							dlu_state <= LOOKUP_TABLE_S;                      
						end        
					end
                end
                else begin//table entry is invalid
					o_dmac_ram_rd <= 1'b0;
					ov_dmac_ram_raddr <= 5'b0;
					
					o_fifo_rd <= 1'b1;

					ov_outport <= ~{9'd1 << iv_fifo_rdata[22:19]};
					o_entry_hit <= 1'b0;
					ov_pkt_type <= 3'd6;
					ov_pkt_inport <= iv_fifo_rdata[22:19];
					ov_pkt_bufid <= iv_fifo_rdata[8:0];
					o_action_req <= 1'b1;
					
					dlu_state <= WAIT_ACK_S;  
                end				
			end
            RECEIVE_TSMP_RESULT_S:begin
                ov_tsmp_lookup_table_key   <= 48'b0;
                o_tsmp_lookup_table_key_wr <= 1'b0;            
                if(i_tsmp_lookup_table_outport_wr)begin
                    o_fifo_rd <= 1'b1;

                    ov_outport  <= {iv_tsmp_lookup_table_outport[32],iv_tsmp_lookup_table_outport[7:0]};
                    o_entry_hit <= 1'b1;
                    ov_pkt_type <= 3'd6;
                    ov_pkt_inport <= iv_fifo_rdata[22:19];
                    ov_pkt_bufid <= iv_fifo_rdata[8:0];
                    o_action_req <= 1'b1;
                    
                    dlu_state <= WAIT_ACK_S;                
                end
                else begin
                    dlu_state <= RECEIVE_TSMP_RESULT_S;
                end
            end
            WAIT_ACK_S:begin
			    o_fifo_rd <= 1'b0;
                if(i_action_ack)begin
					ov_outport <= 9'b0;
					o_entry_hit <= 1'b0;
					ov_pkt_type <= 3'b0;
					ov_pkt_inport <= 4'b0;
					ov_pkt_bufid <= 9'b0;
					o_action_req <= 1'b0;
                    dlu_state <= IDLE_S;                      
                end
                else begin
                    dlu_state <= WAIT_ACK_S;   
                end
            end
            default:begin
                ov_tsmp_lookup_table_key <= 48'd0;
                o_tsmp_lookup_table_key_wr <= 1'b0;
                ov_dmac_ram_raddr <= 5'd0;
                o_dmac_ram_rd <= 1'b0;
                
				ov_outport <= 9'b0;
				o_entry_hit <= 1'b0;
				ov_pkt_type <= 3'b0;
				ov_pkt_inport <= 4'b0;
				ov_pkt_bufid <= 9'b0;
				o_action_req <= 1'b0;
                
                dlu_state <= IDLE_S;            
            end
        endcase
    end
end
endmodule           
