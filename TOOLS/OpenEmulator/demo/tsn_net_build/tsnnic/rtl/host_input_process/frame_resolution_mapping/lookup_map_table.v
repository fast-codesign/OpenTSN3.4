// Copyright (C) 1953-2021 NUDT
// Verilog module name - lookup_map_table
// Version: V3.2.0.20211102
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         packet maps.
///////////////////////////////////////////////////////////////////////////


module lookup_map_table
(
        i_clk,
        i_rst_n,

		i_standardpkt_tsnpkt_flag,	
       
        iv_5tuple_data,
        i_5tuple_data_wr,
        
        iv_identification,
        i_first_fragment,
       
        i_ip_flag,
        i_tcp_or_udp_flag,
       
        o_map_ram_rd,
        ov_map_ram_addr,
        iv_map_ram_rdata,
        o_map_ram_wr,
        ov_map_ram_wdata,

		o_standardpkt_tsnpkt_flag,	
        
        ov_tsntag,
        o_replication_flag,
        o_hit,
        o_lookup_finish_wr
);
// I/O
// clk & rst  
input               i_clk;
input               i_rst_n;
//5tuple & dmac input
input               i_standardpkt_tsnpkt_flag;

input       [103:0] iv_5tuple_data;
input               i_5tuple_data_wr;

input       [15:0]  iv_identification;
input               i_first_fragment;
 
input               i_ip_flag;
input               i_tcp_or_udp_flag; 
//read ram
output reg          o_map_ram_rd;
output reg  [4:0]   ov_map_ram_addr;
input       [162:0] iv_map_ram_rdata;
output reg          o_map_ram_wr;
output reg  [162:0] ov_map_ram_wdata;
//tsntag & bufid output 
output reg          o_standardpkt_tsnpkt_flag;

output reg  [47:0]  ov_tsntag;
output reg          o_replication_flag;
output reg          o_hit;
output reg          o_lookup_finish_wr;
//***************************************************
//          extract five tuple from pkt 
//***************************************************
// internal reg&wire for state machine 
reg         [15:0]  rv_identification;
reg                 r_5tuple_or_identification;
reg         [3:0]   rv_cycle_cnt; 
reg         [103:0] rv_5tuple_data;

reg         [3:0]   lmt_state;
localparam  IDLE_S = 4'd0,
            WAIT_FIRST_S = 4'd1,
            WAIT_SECOND_S = 4'd2,
            FIVE_TUPLE_LOOKUP_TABLE_S = 4'd3,
            IDENTIFICATION_LOOKUP_TABLE_S = 4'd4;
always @(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n)begin
        ov_map_ram_addr <= 5'd0;
        o_map_ram_rd <= 1'b0;
        o_map_ram_wr <= 1'b0;
        ov_map_ram_wdata <= 147'b0;

        o_standardpkt_tsnpkt_flag <= 1'b0;

        ov_tsntag <= 48'b0;
        o_replication_flag <= 1'b0;
        o_hit <= 1'b0;
        o_lookup_finish_wr <= 1'b0;
        
        rv_identification <= 16'b0;
        r_5tuple_or_identification <= 1'b0;
        rv_5tuple_data <= 104'd0;
        rv_cycle_cnt <= 4'b0;
        lmt_state <= IDLE_S;
    end
    else begin
        case(lmt_state)
            IDLE_S:begin
                rv_cycle_cnt <= 4'b0;
                o_map_ram_wr <= 1'b0;
                ov_map_ram_wdata <= 147'b0;
                if(i_5tuple_data_wr == 1'b1)begin
                    rv_identification <= iv_identification;

                    o_standardpkt_tsnpkt_flag <= i_standardpkt_tsnpkt_flag;
                    if((i_tcp_or_udp_flag ==1'b1)&&(i_first_fragment))begin//TCP packet or UDP packet && the packet is first frag. 
                        ov_map_ram_addr <= 5'd0;
                        o_map_ram_rd <= 1'b1;
                        
                        rv_5tuple_data <= iv_5tuple_data;
                        r_5tuple_or_identification <= 1'b0;//key is 5tuple.
                        
                        ov_tsntag <= 48'b0;
                        o_replication_flag <=1'b0;
                        o_hit <= 1'b0;
                        o_lookup_finish_wr <= 1'b0;
                        
                        lmt_state <= WAIT_FIRST_S;
                    end
                    else if((i_ip_flag ==1'b1)&&(!i_first_fragment))begin
                        ov_map_ram_addr <= 5'd0;
                        o_map_ram_rd <= 1'b1;
                        
                        r_5tuple_or_identification <= 1'b1;//key is identification.
                        ov_tsntag <= 48'b0;
                        o_replication_flag <= 1'b0;
                        o_hit <= 1'b0;
                        o_lookup_finish_wr <= 1'b0;
                        
                        lmt_state <= WAIT_FIRST_S;                    
                    end
                    else begin//not TCP neither UDP
                        ov_map_ram_addr <=5'd0;
                        o_map_ram_rd <=1'b0;

                        ov_tsntag <= 48'b0;
                        o_replication_flag <= 1'b0;
                        o_hit <= 1'b0;
                        o_lookup_finish_wr <= 1'b1;
                        
                        rv_5tuple_data <= 104'd0;
                        r_5tuple_or_identification <= 1'b0;
                        
                        lmt_state <= IDLE_S;
                    end
                end
                else begin
                    ov_map_ram_addr <=5'd0;
                    o_map_ram_rd <=1'b0;

                    o_standardpkt_tsnpkt_flag <= 1'b0;

                    ov_tsntag <= 48'b0;
                    o_replication_flag <= 1'b0;
                    o_hit <= 1'b0;
                    o_lookup_finish_wr <= 1'b0;
                    
                    rv_5tuple_data <= 104'd0;
                    r_5tuple_or_identification <= 1'b0;
                    
                    lmt_state <= IDLE_S;                
                end
            end
            WAIT_FIRST_S:begin//get data of reading ram after 2 cycles. 
                o_map_ram_rd <= 1'b1;
                ov_map_ram_addr <= ov_map_ram_addr + 1'b1;
                lmt_state <= WAIT_SECOND_S;
			end
			WAIT_SECOND_S:begin 
                o_map_ram_rd <= 1'b1;
                ov_map_ram_addr <= ov_map_ram_addr + 1'b1;
                if(r_5tuple_or_identification)begin
                    lmt_state <= IDENTIFICATION_LOOKUP_TABLE_S;
                end
                else begin
                    lmt_state <= FIVE_TUPLE_LOOKUP_TABLE_S;
                end
			end
			FIVE_TUPLE_LOOKUP_TABLE_S:begin
				if(iv_map_ram_rdata[162] == 1'b1)begin//table entry is valid
					if((rv_5tuple_data==iv_map_ram_rdata[140:37])&&(iv_map_ram_rdata[145:141]==5'b11111))begin//match entry
						o_map_ram_rd <= 1'b0;
						
                        ov_tsntag <= {iv_map_ram_rdata[36:34],2'b0,iv_map_ram_rdata[33:6],5'b0,iv_map_ram_rdata[4:0],5'b0};
                        o_replication_flag <= iv_map_ram_rdata[5];
                        o_hit <= 1'b1;
                        o_lookup_finish_wr <= 1'b1;
                        //update identification of entry,not revise entry_valid,5-tuple and result of entry.
                        o_map_ram_wr <= 1'b1;
                        ov_map_ram_addr <= ov_map_ram_addr - 5'd2;//data is getted after 2 cycles
                        ov_map_ram_wdata <= {iv_map_ram_rdata[162],rv_identification,iv_map_ram_rdata[145:0]};//entry_valid,identification,5tuple,result.                        
						lmt_state <= IDLE_S;	                    
					end
					else begin//not match entry
						if(ov_map_ram_addr == 5'h01)begin//not match all entries.
							o_map_ram_rd <= 1'b0;
							ov_map_ram_addr <= 5'b0;
                            
                            ov_tsntag <= 48'b0;
                            o_replication_flag <= 1'd0;//BE type
                            o_hit <= 1'b0;
                            o_lookup_finish_wr <= 1'b1;
                            
							lmt_state <= IDLE_S;                          
						end
						else begin
							o_map_ram_rd <= 1'b1;
							ov_map_ram_addr <= ov_map_ram_addr + 1'b1;
							
                            ov_tsntag <= 48'b0;
                            o_replication_flag <= 1'b0;
                            o_hit <= 1'b0;
                            o_lookup_finish_wr <= 1'b0;
							lmt_state <= FIVE_TUPLE_LOOKUP_TABLE_S;                      
						end        
					end
                end
                else begin//table entry is invalid
					o_map_ram_rd <= 1'b0;
					ov_map_ram_addr <= 5'b0;
					
                    ov_tsntag <= 48'b0;
                    o_replication_flag <= 1'd0;
                    o_hit <= 1'b0;
                    o_lookup_finish_wr <= 1'b1;
					lmt_state <= IDLE_S;  
                end				
			end
            IDENTIFICATION_LOOKUP_TABLE_S:begin
				if(iv_map_ram_rdata[162] == 1'b1)begin//table entry is valid
					if(iv_map_ram_rdata[161:146] == rv_identification)begin//match entry
						o_map_ram_rd <= 1'b0;
						
                         ov_tsntag <= {iv_map_ram_rdata[36:34],2'b0,iv_map_ram_rdata[33:6],5'b0,iv_map_ram_rdata[4:0],5'b0};
                        o_replication_flag <= iv_map_ram_rdata[5];
                        o_hit <= 1'b1;
                        o_lookup_finish_wr <= 1'b1;
                        //not need update entry.
                        o_map_ram_wr <= 1'b0;
                        ov_map_ram_addr <= 5'd0;
                        ov_map_ram_wdata <= 147'b0;                   
						lmt_state <= IDLE_S;	                    
					end
					else begin//not match entry
						if(ov_map_ram_addr == 5'h01)begin//not match all entries.
							o_map_ram_rd <= 1'b0;
                            o_map_ram_wr <= 1'b0;
                            ov_map_ram_addr <= 5'd0;
                            ov_map_ram_wdata <= 147'b0; 
                            
                            ov_tsntag <= 48'b0;
                            o_replication_flag <= 1'd0;
                            o_hit <= 1'b0;
                            o_lookup_finish_wr <= 1'b1;
                            
							lmt_state <= IDLE_S;                          
						end
						else begin
							o_map_ram_rd <= 1'b1;
							ov_map_ram_addr <= ov_map_ram_addr + 1'b1;
                            
                            o_map_ram_wr <= 1'b0;
                            ov_map_ram_wdata <= 147'b0; 
							
                            ov_tsntag <= 47'b0;
                            o_replication_flag <= 1'b0;
                            o_hit <= 1'b0;
                            o_lookup_finish_wr <= 1'b0;
							lmt_state <= IDENTIFICATION_LOOKUP_TABLE_S;                      
						end        
					end
                end
                else begin//table entry is invalid
					o_map_ram_rd <= 1'b0;
					ov_map_ram_addr <= 5'b0;
					
                    ov_tsntag <= 48'b0;
                    o_replication_flag <= 1'd0;
                    o_hit <= 1'b0;
                    o_lookup_finish_wr <= 1'b1;
					lmt_state <= IDLE_S;  
                end	            
            end
            default:begin
                ov_map_ram_addr <= 5'd0;
                o_map_ram_rd <= 1'b0;
                o_map_ram_wr <= 1'b0;
                ov_map_ram_wdata <= 147'b0;                 

                ov_tsntag <= 48'b0;
                o_replication_flag <= 1'b0;
                o_hit <= 1'b0;
                o_lookup_finish_wr <= 1'b0;
             
                rv_5tuple_data <= 104'd0;
                
                lmt_state <= IDLE_S;            
            end
        endcase
    end
end
endmodule           