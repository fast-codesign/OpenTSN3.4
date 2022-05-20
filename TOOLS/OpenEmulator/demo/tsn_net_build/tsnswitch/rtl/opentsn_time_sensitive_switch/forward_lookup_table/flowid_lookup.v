// Copyright (C) 1953-2020 NUDT
// Verilog module name - flowid_lookup
// Version: V3.2.0.20210722
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         determine whether a table lookup is required
//         extract flow_id from descriptor,and complete the table
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module flowid_lookup
(
       i_clk,
       i_rst_n,
       
       iv_descriptor,
       i_descriptor_wr,
       
       ov_ram_raddr,
       o_ram_rd,

       ov_outport,
       o_outport_wr,
       ov_pkt_bufid,
       ov_pkt_type,
       ov_submit_addr,
       ov_inport,
       o_pkt_bufid_wr 
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
// descriptor from p0
input      [45:0]      iv_descriptor;
input                  i_descriptor_wr;
// read addr to RAM
output reg [13:0]      ov_ram_raddr;
output reg             o_ram_rd;
// pkt_bufid and pkt_type and outport to forword
output reg [8:0]       ov_outport;
output reg             o_outport_wr;
output reg [8:0]       ov_pkt_bufid;
output reg [2:0]       ov_pkt_type;
output reg [4:0]       ov_submit_addr;
output reg [3:0]       ov_inport;
output reg             o_pkt_bufid_wr;

//////////////////////////////////////////////////
//      extract flow_id and lookup table        //
//////////////////////////////////////////////////
reg        [8:0]       rv_outport_delay1;
reg                    r_outport_wr_delay1;
reg        [8:0]       rv_pkt_bufid_delay1;
reg        [2:0]       rv_pkt_type_delay1;
reg        [4:0]       rv_submit_addr_delay1;
reg        [3:0]       rv_inport_delay1;
reg                    r_pkt_bufid_wr_delay1;
           
reg        [8:0]       rv_outport_delay2;
reg                    r_outport_wr_delay2;
reg        [8:0]       rv_pkt_bufid_delay2;
reg        [2:0]       rv_pkt_type_delay2;
reg        [4:0]       rv_submit_addr_delay2;
reg        [3:0]       rv_inport_delay2;
reg                    r_pkt_bufid_wr_delay2;

always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        rv_outport_delay1       <= 8'h0;
        r_outport_wr_delay1     <= 1'h0;
        rv_pkt_bufid_delay1     <= 9'h0;
        rv_pkt_type_delay1      <= 3'h0;
        rv_submit_addr_delay1   <= 5'h0;
        rv_inport_delay1        <= 4'h0;
        r_pkt_bufid_wr_delay1   <= 1'h0;
        
        ov_ram_raddr            <= 14'h0;
        o_ram_rd                <= 1'h0;
    end                        
    else begin
        if(i_descriptor_wr == 1'b1)begin
            if(iv_descriptor[18] == 1'b1)begin //lookup_en == 1,need lookup table
                ov_ram_raddr            <= iv_descriptor[32:19];//flow_id
                o_ram_rd                <= 1'h1;
                
                rv_outport_delay1       <= 9'h0;
                r_outport_wr_delay1     <= 1'h0;
                rv_pkt_bufid_delay1     <= iv_descriptor[8:0];//pkt_bufid
                rv_pkt_type_delay1      <= iv_descriptor[35:33];//pkt_type
                rv_submit_addr_delay1   <= iv_descriptor[45:41];//submit_addr
                rv_inport_delay1        <= iv_descriptor[39:36];//inport
                r_pkt_bufid_wr_delay1   <= 1'h1;    
            end
            else begin                    //lookup_en == 0,do not need lookup table
                ov_ram_raddr            <= 14'h0;
                o_ram_rd                <= 1'h0;
                
                rv_outport_delay1       <= iv_descriptor[17:9];//outport
                r_outport_wr_delay1     <= 1'h1;
                rv_pkt_bufid_delay1     <= iv_descriptor[8:0];//pkt_bufid
                rv_pkt_type_delay1      <= iv_descriptor[35:33];//pkt_type
                rv_submit_addr_delay1   <= iv_descriptor[45:41];//submit_addr
                rv_inport_delay1        <= iv_descriptor[39:36];//inport
                r_pkt_bufid_wr_delay1   <= 1'h1;
            end
        end
        else begin
            rv_outport_delay1       <= 9'h0;
            r_outport_wr_delay1     <= 1'h0;
            rv_pkt_bufid_delay1     <= 9'h0;
            rv_pkt_type_delay1      <= 3'h0;
            rv_submit_addr_delay1   <= 5'h0;
            rv_inport_delay1        <= 4'h0;
            r_pkt_bufid_wr_delay1   <= 1'h0;
            
            ov_ram_raddr            <= 14'h0;
            o_ram_rd                <= 1'h0;
        end
    end
end

always @(posedge i_clk) begin// this signal have to delay 2 cycle,beacuse of the read ram data had wait two cycle
    rv_outport_delay2     <= rv_outport_delay1;     
    r_outport_wr_delay2   <= r_outport_wr_delay1;  
    rv_pkt_bufid_delay2   <= rv_pkt_bufid_delay1;   
    rv_pkt_type_delay2    <= rv_pkt_type_delay1;    
    rv_submit_addr_delay2 <= rv_submit_addr_delay1;
    rv_inport_delay2      <= rv_inport_delay1;
    r_pkt_bufid_wr_delay2 <= r_pkt_bufid_wr_delay1; 
    
    ov_outport            <= rv_outport_delay2;     
    o_outport_wr          <= r_outport_wr_delay2;  
    ov_pkt_bufid          <= rv_pkt_bufid_delay2;   
    ov_pkt_type           <= rv_pkt_type_delay2;    
    ov_submit_addr        <= rv_submit_addr_delay2;
    ov_inport             <= rv_inport_delay2;
    o_pkt_bufid_wr        <= r_pkt_bufid_wr_delay2;         
end

endmodule