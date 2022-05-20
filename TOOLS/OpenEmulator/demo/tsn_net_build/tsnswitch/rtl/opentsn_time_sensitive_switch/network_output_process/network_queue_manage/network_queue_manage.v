// Copyright (C) 1953-2020 NUDT
// Verilog module name - network_queue_manage
// Version: NQM_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         use RAM to cahce the queue
//         queue manage
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module network_queue_manage
(
       i_clk,
       i_rst_n,
              
       iv_queue_wdata, 
       iv_queue_waddr, 
       i_queue_wr,
       
       iv_queue_raddr, 
       i_queue_rd,
       
       ov_queue_rdata,
       o_queue_rdata_valid
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
// write from network_input_queue
input      [8:0]       iv_queue_wdata;
input      [8:0]       iv_queue_waddr; 
input                  i_queue_wr;
// read from network_output_schedule
input      [8:0]       iv_queue_raddr; 
input                  i_queue_rd;
// read data to network_output_schedule
output reg [8:0]       ov_queue_rdata;
output reg             o_queue_rdata_valid;
    
////////////////////////////////////////
//              state                 //
////////////////////////////////////////
reg                    r_ram_rd;
wire    [8:0]          r_ram_rdata;
reg     [1:0]          nqm_state;
localparam             IDLE_S    = 2'd0,
                       READ_S    = 2'd1,
                       WAIT0_S   = 2'd2,
                       WAIT1_S   = 2'd3;

always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_queue_rdata <= 9'b0;
        o_queue_rdata_valid <= 1'b0;
        r_ram_rd <= 1'b0;
        nqm_state           <= IDLE_S;
    end
    else begin
        case(nqm_state)
            IDLE_S:begin
                o_queue_rdata_valid<= 1'b0;
                if(i_queue_rd == 1'b1)begin
                    r_ram_rd           <= 1'b1;
                    
                    nqm_state          <= READ_S;
                end
                else begin
                    r_ram_rd           <= 1'b0;
                    
                    nqm_state          <= IDLE_S;
                end
            end
            
            READ_S:begin//start read data from RAM
                r_ram_rd           <= 1'b0;
                if((i_queue_wr == 1'b1) && (iv_queue_waddr == iv_queue_raddr))begin
                //if write address and read address is one address
                //used the write data as the read data
                    ov_queue_rdata     <= iv_queue_wdata;
                    o_queue_rdata_valid<= 1'b1;
                    
                    nqm_state          <= IDLE_S;
                end
                else begin
                    o_queue_rdata_valid<= 1'b0;
                    nqm_state          <= WAIT0_S;
                end
            end
        
            WAIT0_S:begin//read data from RAM delay
                r_ram_rd            <= 1'b0;
                if((i_queue_wr == 1'b1) && (iv_queue_waddr == iv_queue_raddr))begin
                //if write address and read address is one address
                //used the write data as the read data
                    ov_queue_rdata     <= iv_queue_wdata;
                    o_queue_rdata_valid<= 1'b1;
                    
                    nqm_state          <= IDLE_S;
                end
                else begin
                    o_queue_rdata_valid<= 1'b0;
                    nqm_state          <= WAIT1_S;
                end
            end
            
            WAIT1_S:begin//read data from RAM delay
                r_ram_rd            <= 1'b0;
                o_queue_rdata_valid <= 1'b1;
                if((i_queue_wr == 1'b1) && (iv_queue_waddr == iv_queue_raddr))begin
                //if write address and read address is one address
                //used the write data as the read data
                    ov_queue_rdata     <= iv_queue_wdata;
                end
                else begin
                    ov_queue_rdata     <= r_ram_rdata;
                end
                nqm_state           <= IDLE_S;
            end
        
            default:begin
                r_ram_rd            <= 1'b0;
                o_queue_rdata_valid <= 1'b0;
                nqm_state           <= IDLE_S;
            end
        endcase
    end
end
sdprf512x9_s sdprf512x9_s_inst(
.aclr         (!i_rst_n),
             
.rdaddress    (iv_queue_raddr),
.wraddress    (iv_queue_waddr),
             
.clock        (i_clk),
             
.data         (iv_queue_wdata),
              
.rden         (r_ram_rd),
             
.wren         (i_queue_wr),
             
.q            (r_ram_rdata)
);

endmodule