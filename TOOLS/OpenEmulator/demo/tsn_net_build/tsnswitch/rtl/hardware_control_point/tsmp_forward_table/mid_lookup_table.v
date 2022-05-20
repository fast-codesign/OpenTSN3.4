// Copyright (C) 1953-2022 NUDT
// Verilog module name - mid_lookup_table
// Version: V3.4.0.20220401
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module mid_lookup_table
(
       i_clk,
       i_rst_n,
       
       iv_hcp_mid                   ,
       
        i_tsmp_lookup_table_key_wr       ,
        iv_tsmp_lookup_table_key         ,
        ov_tsmp_lookup_table_outport     ,
        o_tsmp_lookup_table_outport_wr   ,

        ov_ram_raddr,
        o_ram_rd,
        iv_ram_rdata		
);

// I/O
// clk & rst
input                     i_clk;                   //125Mhz
input                     i_rst_n;

input         [11:0]      iv_hcp_mid;

input                     i_tsmp_lookup_table_key_wr       ;
input         [47:0]      iv_tsmp_lookup_table_key         ;
output reg    [32:0]      ov_tsmp_lookup_table_outport     ;
output reg                o_tsmp_lookup_table_outport_wr   ;

output reg    [11:0]      ov_ram_raddr;
output reg                o_ram_rd;
input         [33:0]      iv_ram_rdata;

reg           [11:0]      rv_hcp_mid  ;
reg           [3:0]       rv_mlt_state;
localparam            INIT_S                = 4'd0,
                      IDLE_S                = 4'd1,
                      WAIT_FIRST_S          = 4'd2,
                      WAIT_SECOND_S         = 4'd3,
                      GTE_DATA_S            = 4'd4;
                      
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_tsmp_lookup_table_outport       <= 33'h0;
        o_tsmp_lookup_table_outport_wr     <= 1'h0;		
        ov_ram_raddr         <= 12'h0;
        o_ram_rd             <= 1'h0;
        rv_mlt_state         <= INIT_S;
    end                        
    else begin
	    case(rv_mlt_state)
            INIT_S:begin
                if(i_tsmp_lookup_table_key_wr)begin
                    ov_tsmp_lookup_table_outport     <= {1'b1,32'b0};
                    o_tsmp_lookup_table_outport_wr   <= 1'b1;        
                    ov_ram_raddr                     <= 12'h0;
                    o_ram_rd                         <= 1'b0;
                    rv_mlt_state                     <= IDLE_S;
                end
                else begin
                    ov_tsmp_lookup_table_outport    <= 33'h0;
                    o_tsmp_lookup_table_outport_wr  <= 1'h0;
                    ov_ram_raddr                    <= 12'h0;
                    o_ram_rd                        <= 1'b0;
                    rv_mlt_state                    <= INIT_S;
                end	                
			end
            IDLE_S:begin
                if(i_tsmp_lookup_table_key_wr)begin
                    if(iv_hcp_mid==iv_tsmp_lookup_table_key[23:12])begin
                        ov_tsmp_lookup_table_outport     <= {1'b1,32'b0};
                        o_tsmp_lookup_table_outport_wr   <= 1'b1;        
                        ov_ram_raddr                     <= 12'h0;
                        o_ram_rd                         <= 1'b0; 
                        rv_mlt_state                    <= IDLE_S;
                    end
                    else begin                                                                   
                        ov_tsmp_lookup_table_outport    <= 33'h0;
                        o_tsmp_lookup_table_outport_wr  <= 1'h0;
                        ov_ram_raddr                    <= iv_tsmp_lookup_table_key[23:12];
                        o_ram_rd                        <= 1'b1;
                        rv_mlt_state                    <= WAIT_FIRST_S;                        
                    end                        
                end
                else begin
                    ov_tsmp_lookup_table_outport    <= 33'h0;
                    o_tsmp_lookup_table_outport_wr  <= 1'h0;
                    ov_ram_raddr                    <= 12'h0;
                    o_ram_rd                        <= 1'b0;
                    rv_mlt_state                    <= IDLE_S;
                end	                
			end
			WAIT_FIRST_S:begin
				ov_ram_raddr     <= 12'h0;
				o_ram_rd         <= 1'b0;
				rv_mlt_state     <= WAIT_SECOND_S;			
			end
			WAIT_SECOND_S:begin
				ov_ram_raddr     <= 12'h0;
				o_ram_rd         <= 1'b0;
				rv_mlt_state     <= GTE_DATA_S;			
			end		
			GTE_DATA_S:begin
                ov_tsmp_lookup_table_outport       <= iv_ram_rdata[32:0];
                o_tsmp_lookup_table_outport_wr     <= 1'b1;
                rv_mlt_state                       <= IDLE_S;              
			end
            default:begin
				ov_tsmp_lookup_table_outport       <= 33'h0;
				o_tsmp_lookup_table_outport_wr     <= 1'h0;
				
				ov_ram_raddr     <= 12'h0;
				o_ram_rd         <= 1'h0;
				rv_mlt_state        <= IDLE_S;
            end
        endcase
    end
end	
endmodule