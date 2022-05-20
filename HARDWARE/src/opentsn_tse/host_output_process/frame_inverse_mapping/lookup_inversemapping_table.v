// Copyright (C) 1953-2020 NUDT
// Verilog module name - lookup_inversemap_table
// Version: lookup_inversemap_table_V1.0
// Created:
//         by - peng jintao 
//         at - 11.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         look up regroup mapping table
//             - sequential search
//             - get dmac and outport of packet; 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module lookup_inversemapping_table
(
       i_clk,
       i_rst_n,
       
	   iv_descriptor,
	   i_descriptor_wr,
       o_descriptor_ready,
       
       iv_inversemap_ram_rdata,
       o_inversemap_ram_rd,
       ov_inversemap_ram_raddr,
	   
	   ov_dmac,
	   ov_bufid,
	   o_dmac_replace_flag, 
       o_lookup_table_match_flag,
       o_descriptor_wr,
       i_descriptor_ready
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;  
// pkt input
input       [21:0]     iv_descriptor;
input                  i_descriptor_wr;
output                 o_descriptor_ready;
//read ram 
input       [59:0]	   iv_inversemap_ram_rdata;
output reg  	       o_inversemap_ram_rd;
output reg  [7:0]	   ov_inversemap_ram_raddr;
//result of look up table
output reg  [47:0]	   ov_dmac;
output reg  [8:0]	   ov_bufid;
output reg       	   o_dmac_replace_flag;//1:dmac replace tsntag;0:not need to replace tsntag.
output reg             o_lookup_table_match_flag;
output reg             o_descriptor_wr;
input                  i_descriptor_ready;

assign o_descriptor_ready = i_descriptor_ready;
//***************************************************
//           lookup table-sequential search
//***************************************************
reg         [11:0]      rv_flowid;
reg         [8:0]       rv_bufid;

reg		    [2:0]	    lrt_state;
localparam			    IDLE_S = 3'd0,
					    WAIT_FIRST_S = 3'd1,
						WAIT_SECOND_S = 3'd2,
						GET_DATA_S = 3'd3;
always @(posedge i_clk or negedge i_rst_n) begin
	if(i_rst_n == 1'b0)begin
	    o_inversemap_ram_rd <= 1'b0;
	    ov_inversemap_ram_raddr <= 8'b0;

        rv_flowid <= 12'b0;
        rv_bufid <= 9'b0;
        ov_dmac <= 48'b0;
        ov_bufid <= 9'b0;
        o_dmac_replace_flag <= 1'b0;		
        o_lookup_table_match_flag <= 1'b0; 
        o_descriptor_wr <= 1'b0;
        
		lrt_state <= IDLE_S;
	end
	else begin
		case(lrt_state)
			IDLE_S:begin                 
                if(i_descriptor_wr == 1'b1)begin
                    if(iv_descriptor[21] == 1'b1)begin//need to lookup table.
                        o_inversemap_ram_rd <= 1'b1;
                        ov_inversemap_ram_raddr <= 8'b0;

                        rv_flowid <= iv_descriptor[20:9]; 
                        rv_bufid <= iv_descriptor[8:0];
                
                        ov_dmac <= 48'b0;
                        ov_bufid <= 9'b0;
                        o_descriptor_wr <= 1'b0;
                        o_lookup_table_match_flag <= 1'b0;                           
                        o_dmac_replace_flag <= 1'b0;                        
                        lrt_state <= WAIT_FIRST_S; 
                    end
                    else begin
                        o_inversemap_ram_rd <= 1'b0;
                        ov_inversemap_ram_raddr <= 8'b0;

                        rv_flowid <= 12'b0;
                        rv_bufid <= 9'b0; 

                        ov_dmac <= 48'b0;
                        ov_bufid <= iv_descriptor[8:0];
                        o_dmac_replace_flag <= 1'b0; 
                        o_descriptor_wr <= 1'b1;
                        o_lookup_table_match_flag <= 1'b1;                          
                        lrt_state <= IDLE_S;                     
                    end                                   
                end
                else begin
                    o_inversemap_ram_rd <= 1'b0;
                    ov_inversemap_ram_raddr <= 8'b0;

                    rv_flowid <= 12'b0;   
                    rv_bufid <= 9'b0;   
                    ov_dmac <= 48'b0;
                    ov_bufid <= 9'b0;
                    o_descriptor_wr <= 1'b0;
                    o_lookup_table_match_flag <= 1'b0;                           
                    o_dmac_replace_flag <= 1'b0;					
                    lrt_state <= IDLE_S;  	
                end
            end
			WAIT_FIRST_S:begin//get data of reading ram after 2 cycles. 
                o_inversemap_ram_rd <= 1'b1;
                ov_inversemap_ram_raddr <= ov_inversemap_ram_raddr + 1'b1;
                lrt_state <= WAIT_SECOND_S;
			end
			WAIT_SECOND_S:begin 
                o_inversemap_ram_rd <= 1'b1;
                ov_inversemap_ram_raddr <= ov_inversemap_ram_raddr + 1'b1;
                lrt_state <= GET_DATA_S;
			end
			GET_DATA_S:begin
				if(iv_inversemap_ram_rdata != 60'b0)begin//table entry is valid
					if(iv_inversemap_ram_rdata[59:48] == rv_flowid)begin//match entry
						o_inversemap_ram_rd <= 1'b0;
						ov_inversemap_ram_raddr <= 8'b0;
						
                        ov_dmac <= iv_inversemap_ram_rdata[47:0];
                        ov_bufid <= rv_bufid;
						o_lookup_table_match_flag <= 1'b1; 
                        o_dmac_replace_flag <= 1'b1;                         
						o_descriptor_wr <= 1'b1;
						lrt_state <= IDLE_S;	                    
					end
					else begin//not match entry
						if(ov_inversemap_ram_raddr == 8'h01)begin//not match all entries.
							o_inversemap_ram_rd <= 1'b0;
							ov_inversemap_ram_raddr <= 8'b0;
							
                            ov_dmac <= 48'b0;
                            ov_bufid <= rv_bufid;
						    o_lookup_table_match_flag <= 1'b0; 
                            o_dmac_replace_flag <= 1'b0;                             
						    o_descriptor_wr <= 1'b1;
							lrt_state <= IDLE_S;                          
						end
						else begin
							o_inversemap_ram_rd <= 1'b1;
							ov_inversemap_ram_raddr <= ov_inversemap_ram_raddr + 1'b1;
							
                            ov_dmac <= 48'b0;
						    o_lookup_table_match_flag <= 1'b0; 
                            o_dmac_replace_flag <= 1'b0;                             
						    o_descriptor_wr <= 1'b0;
							lrt_state <= GET_DATA_S;                      
						end        
					end
                end
                else begin//table entry is invalid
					o_inversemap_ram_rd <= 1'b0;
					ov_inversemap_ram_raddr <= 8'b0;
					
                    ov_dmac <= 48'b0;
                    ov_bufid <= rv_bufid;
					o_lookup_table_match_flag <= 1'b0;  
                    o_dmac_replace_flag <= 1'b0;                     
					o_descriptor_wr <= 1'b1;                    
					lrt_state <= IDLE_S;  
                end				
			end           
			default:begin		
				lrt_state <= IDLE_S;		
			end
		endcase
	end
end
endmodule