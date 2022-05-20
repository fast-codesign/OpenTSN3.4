    // Copyright (C) 1953-2020 NUDT
// Verilog module name - tsn_packet_action
// Version: V3.2.0.20210722
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         forward based on the result of the lookup table
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tsn_packet_action
(
       i_clk,
       i_rst_n,
              
       iv_outport,
       i_outport_wr,
       iv_pkt_bufid,
       iv_pkt_type,
       iv_submit_addr,
       iv_inport,
       i_pkt_bufid_wr, 
    
       ov_pkt_bufid_p0,
       ov_pkt_type_p0,
       o_pkt_bufid_wr_p0,
       
       ov_pkt_bufid_p1,
       ov_pkt_type_p1,
       o_pkt_bufid_wr_p1,
       
       ov_pkt_bufid_p2,
       ov_pkt_type_p2,
       o_pkt_bufid_wr_p2,
       
       ov_pkt_bufid_p3,
       ov_pkt_type_p3,
       o_pkt_bufid_wr_p3,
       
       ov_pkt_bufid_p4,
       ov_pkt_type_p4,
       o_pkt_bufid_wr_p4,
       
       ov_pkt_bufid_p5,
       ov_pkt_type_p5,
       o_pkt_bufid_wr_p5,
       
       ov_pkt_bufid_p6,
       ov_pkt_type_p6,
       o_pkt_bufid_wr_p6,
       
       ov_pkt_bufid_p7,
       ov_pkt_type_p7,
       o_pkt_bufid_wr_p7,
       
       ov_pkt_bufid_host,
       ov_pkt_type_host,
       ov_submit_addr_host,
       ov_inport_host,
       o_pkt_bufid_wr_host,
       
       iv_ram_rdata,
       
       ov_pkt_bufid,        
       o_pkt_bufid_wr,      
       ov_pkt_bufid_cnt 
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
// pkt_bufid and pkt_type and outport from lookup_table
input      [8:0]       iv_outport;
input                  i_outport_wr;
input      [8:0]       iv_pkt_bufid;
input      [2:0]       iv_pkt_type;
input      [4:0]       iv_submit_addr;
input      [3:0]       iv_inport;
input                  i_pkt_bufid_wr;
// pkt_bufid and pkt_type to p0
output reg [8:0]       ov_pkt_bufid_p0;
output reg [2:0]       ov_pkt_type_p0;
output reg             o_pkt_bufid_wr_p0;
// pkt_bufid and pkt_type to p1   
output reg [8:0]       ov_pkt_bufid_p1;
output reg [2:0]       ov_pkt_type_p1;
output reg             o_pkt_bufid_wr_p1;
// pkt_bufid and pkt_type to p2    
output reg [8:0]       ov_pkt_bufid_p2;
output reg [2:0]       ov_pkt_type_p2;
output reg             o_pkt_bufid_wr_p2;
// pkt_bufid and pkt_type to p3    
output reg [8:0]       ov_pkt_bufid_p3;
output reg [2:0]       ov_pkt_type_p3;
output reg             o_pkt_bufid_wr_p3;
// pkt_bufid and pkt_type to p4    
output reg [8:0]       ov_pkt_bufid_p4;
output reg [2:0]       ov_pkt_type_p4;
output reg             o_pkt_bufid_wr_p4;
// pkt_bufid and pkt_type to p5    
output reg [8:0]       ov_pkt_bufid_p5;
output reg [2:0]       ov_pkt_type_p5;
output reg             o_pkt_bufid_wr_p5;
// pkt_bufid and pkt_type to p6    
output reg [8:0]       ov_pkt_bufid_p6;
output reg [2:0]       ov_pkt_type_p6;
output reg             o_pkt_bufid_wr_p6;
// pkt_bufid and pkt_type to p7    
output reg [8:0]       ov_pkt_bufid_p7;
output reg [2:0]       ov_pkt_type_p7;
output reg             o_pkt_bufid_wr_p7;
// pkt_bufid and pkt_type to host      
output reg [8:0]       ov_pkt_bufid_host;
output reg [2:0]       ov_pkt_type_host;
output reg [4:0]       ov_submit_addr_host;
output reg [3:0]       ov_inport_host;
output reg             o_pkt_bufid_wr_host;
//read data from RAM
input      [8:0]       iv_ram_rdata;
//forward cnt to pkt_centralize_bufm_memory
output reg [8:0]       ov_pkt_bufid;
output reg             o_pkt_bufid_wr;
output reg [3:0]       ov_pkt_bufid_cnt;

//////////////////////////////////////////////////
//              forward                         //
//////////////////////////////////////////////////
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_pkt_bufid_p0      <= 9'h0;
        ov_pkt_type_p0       <= 2'h0;
        o_pkt_bufid_wr_p0    <= 1'h0;
                            
        ov_pkt_bufid_p1      <= 9'h0;
        ov_pkt_type_p1       <= 2'h0;
        o_pkt_bufid_wr_p1    <= 1'h0;
                             
        ov_pkt_bufid_p2      <= 9'h0;
        ov_pkt_type_p2       <= 2'h0;
        o_pkt_bufid_wr_p2    <= 1'h0;
        
        ov_pkt_bufid_p3      <= 9'h0;
        ov_pkt_type_p3       <= 2'h0;
        o_pkt_bufid_wr_p3    <= 1'h0;
        
        ov_pkt_bufid_p4      <= 9'h0;
        ov_pkt_type_p4       <= 2'h0;
        o_pkt_bufid_wr_p4    <= 1'h0;
        
        ov_pkt_bufid_p5      <= 9'h0;
        ov_pkt_type_p5       <= 2'h0;
        o_pkt_bufid_wr_p5    <= 1'h0;
        
        ov_pkt_bufid_p6      <= 9'h0;
        ov_pkt_type_p6       <= 2'h0;
        o_pkt_bufid_wr_p6    <= 1'h0;
        
        ov_pkt_bufid_p7      <= 9'h0;
        ov_pkt_type_p7       <= 2'h0;
        o_pkt_bufid_wr_p7    <= 1'h0;
                            
        ov_pkt_bufid_host    <= 9'h0;
        ov_pkt_type_host     <= 2'h0;
        ov_submit_addr_host  <= 5'h0;
        ov_inport_host       <= 4'h0;
        o_pkt_bufid_wr_host  <= 1'h0;
                                     
        ov_pkt_bufid         <= 9'h0;
        o_pkt_bufid_wr       <= 1'h0;
        ov_pkt_bufid_cnt     <= 4'h0;
    end                              
    else begin
        if(i_pkt_bufid_wr == 1'b1)begin
            if(i_outport_wr == 1'b1)begin//the pkt_bufid do not need lookup forward table
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
                ov_inport_host       <= iv_inport;
                ov_submit_addr_host  <= iv_submit_addr;
                
                ov_pkt_bufid         <= iv_pkt_bufid;
                o_pkt_bufid_wr       <= 1'b1;
                if(|iv_outport == 1'b0)begin//if outport is all 0,transmit the pkt to host
                    o_pkt_bufid_wr_p0    <= 1'b0;
                    o_pkt_bufid_wr_p1    <= 1'b0;
                    o_pkt_bufid_wr_p2    <= 1'b0;
                    o_pkt_bufid_wr_p3    <= 1'b0;
                    o_pkt_bufid_wr_p4    <= 1'b0;
                    o_pkt_bufid_wr_p5    <= 1'b0;
                    o_pkt_bufid_wr_p6    <= 1'b0;
                    o_pkt_bufid_wr_p7    <= 1'b0;
                    o_pkt_bufid_wr_host  <= 1'b1;
                    ov_pkt_bufid_cnt     <= 4'b1;
                end
                else begin//forword the pkt base on outport
                    o_pkt_bufid_wr_p0    <= iv_outport[0];
                    o_pkt_bufid_wr_p1    <= iv_outport[1];
                    o_pkt_bufid_wr_p2    <= iv_outport[2];
                    o_pkt_bufid_wr_p3    <= iv_outport[3];
                    //o_pkt_bufid_wr_p4    <= iv_outport[4];
                    //o_pkt_bufid_wr_p5    <= iv_outport[5];
                    //o_pkt_bufid_wr_p6    <= iv_outport[6];
                    //o_pkt_bufid_wr_p7    <= iv_outport[7];
                    o_pkt_bufid_wr_host  <= iv_outport[8];
                    ov_pkt_bufid_cnt     <= iv_outport[0] + iv_outport[1] + iv_outport[2] + iv_outport[3] + iv_outport[8];
                   // ov_pkt_bufid_cnt     <= iv_outport[0] + iv_outport[1] + iv_outport[2] + iv_outport[3] + iv_outport[4] + iv_outport[5] + iv_outport[6] + iv_outport[7] + iv_outport[8];                       
                end    
            end
            else begin//the pkt_bufid had lookup forward table
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
                ov_submit_addr_host  <= iv_submit_addr;
                ov_inport_host       <= iv_inport;
                
                ov_pkt_bufid         <= iv_pkt_bufid;
                o_pkt_bufid_wr       <= 1'b1;
                if(|iv_ram_rdata == 1'b0)begin//if result if all 0,transmit the pkt to host
                    o_pkt_bufid_wr_p0    <= 1'b0;
                    o_pkt_bufid_wr_p1    <= 1'b0;
                    o_pkt_bufid_wr_p2    <= 1'b0;
                    o_pkt_bufid_wr_p3    <= 1'b0;
                    o_pkt_bufid_wr_p4    <= 1'b0;
                    o_pkt_bufid_wr_p5    <= 1'b0;
                    o_pkt_bufid_wr_p6    <= 1'b0;
                    o_pkt_bufid_wr_p7    <= 1'b0;
                    o_pkt_bufid_wr_host  <= 1'b1;
                    ov_pkt_bufid_cnt     <= 4'b1;
                end
                else begin//forword the pkt base on result
                    o_pkt_bufid_wr_p0    <= iv_ram_rdata[0];
                    o_pkt_bufid_wr_p1    <= iv_ram_rdata[1];
                    o_pkt_bufid_wr_p2    <= iv_ram_rdata[2];
                    o_pkt_bufid_wr_p3    <= iv_ram_rdata[3];
                   //o_pkt_bufid_wr_p4    <= iv_ram_rdata[4];
                   //o_pkt_bufid_wr_p5    <= iv_ram_rdata[5];
                   //o_pkt_bufid_wr_p6    <= iv_ram_rdata[6];
                   //o_pkt_bufid_wr_p7    <= iv_ram_rdata[7];
                    o_pkt_bufid_wr_host  <= iv_ram_rdata[8];
                    ov_pkt_bufid_cnt     <= iv_ram_rdata[0] + iv_ram_rdata[1] + iv_ram_rdata[2] + iv_ram_rdata[3] + iv_ram_rdata[8]; 
                   //ov_pkt_bufid_cnt     <= iv_ram_rdata[0] + iv_ram_rdata[1] + iv_ram_rdata[2] + iv_ram_rdata[3] + iv_ram_rdata[4] + iv_ram_rdata[5] + iv_ram_rdata[6] + iv_ram_rdata[7] + iv_ram_rdata[8];                       
                end 
            end
        end
        else begin
            ov_pkt_bufid_p0      <= 9'h0;
            ov_pkt_type_p0       <= 2'h0;
            o_pkt_bufid_wr_p0    <= 1'h0;
                                
            ov_pkt_bufid_p1      <= 9'h0;
            ov_pkt_type_p1       <= 2'h0;
            o_pkt_bufid_wr_p1    <= 1'h0;
                                 
            ov_pkt_bufid_p2      <= 9'h0;
            ov_pkt_type_p2       <= 2'h0;
            o_pkt_bufid_wr_p2    <= 1'h0;
            
            ov_pkt_bufid_p3      <= 9'h0;
            ov_pkt_type_p3       <= 2'h0;
            o_pkt_bufid_wr_p3    <= 1'h0;
            
            ov_pkt_bufid_p4      <= 9'h0;
            ov_pkt_type_p4       <= 2'h0;
            o_pkt_bufid_wr_p4    <= 1'h0;
            
            ov_pkt_bufid_p5      <= 9'h0;
            ov_pkt_type_p5       <= 2'h0;
            o_pkt_bufid_wr_p5    <= 1'h0;
            
            ov_pkt_bufid_p6      <= 9'h0;
            ov_pkt_type_p6       <= 2'h0;
            o_pkt_bufid_wr_p6    <= 1'h0;
            
            ov_pkt_bufid_p7      <= 9'h0;
            ov_pkt_type_p7       <= 2'h0;
            o_pkt_bufid_wr_p7    <= 1'h0;
                                
            ov_pkt_bufid_host    <= 9'h0;
            ov_pkt_type_host     <= 2'h0;
            ov_submit_addr_host  <= 5'h0;
            ov_inport_host       <= 4'h0;
            o_pkt_bufid_wr_host  <= 1'h0;
            
            ov_pkt_bufid         <= 9'h0;
            o_pkt_bufid_wr       <= 1'h0;
            ov_pkt_bufid_cnt     <= 4'h0;
        end
    end
end
endmodule