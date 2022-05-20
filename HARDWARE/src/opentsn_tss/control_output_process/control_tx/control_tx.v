// Copyright (C) 1953-2022 NUDT
// Verilog module name - control_tx 
// Version: V3.4.0.20220225
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         transmit pkt to phy.
//            - top module.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module control_tx
(
       i_clk,
       i_rst_n,
              
       iv_pkt_descriptor,
       i_pkt_descriptor_wr,
       o_pkt_descriptor_ready,
       
       ov_pkt_bufid,
       o_pkt_bufid_wr,
       i_pkt_bufid_ack, 
       
       ov_pkt_raddr,
       o_pkt_rd,
       i_pkt_raddr_ack,
       
       iv_pkt_data,
       i_pkt_data_wr,  
       
       ov_hcp_data    ,
       o_hcp_data_wr  ,
       
       ov_eth_data   ,
       o_eth_data_wr ,
       
       hoi_state,
       bufid_state,
       pkt_read_state,
       
       ov_debug_ts_cnt,
       ov_debug_cnt       
);

// I/O
// clk & rst
input                  i_clk;                    
input                  i_rst_n;

output                 o_pkt_descriptor_ready;
// pkt_bufid from HOS(Host Output Schedule)                  
input      [13:0]      iv_pkt_descriptor;            
input                  i_pkt_descriptor_wr;         
// pkt_bufid to PCB in order to release pkt_bufid
output     [8:0]       ov_pkt_bufid;
output                 o_pkt_bufid_wr;
input                  i_pkt_bufid_ack; 
// read address to PCB in order to read pkt data       
output     [15:0]      ov_pkt_raddr;
output                 o_pkt_rd;
input                  i_pkt_raddr_ack;
// receive pkt data from PCB 
input      [133:0]     iv_pkt_data;
input                  i_pkt_data_wr;
// send pkt data from gmii     
output     [7:0]       ov_hcp_data;
output                 o_hcp_data_wr;

output     [7:0]       ov_eth_data  ;
output                 o_eth_data_wr;
// local timer rst signal
output     [3:0]        hoi_state;
output     [1:0]        bufid_state;
output     [2:0]        pkt_read_state;
// read requst signal and send data finish signal  
wire                   w_pkt_rd_req;

wire       [31:0]      wv_pkt_cnt;

wire   w_pkt_descriptor_ready;
wire   w_pkt_last_cycle_rx;
assign o_pkt_descriptor_ready = w_pkt_last_cycle_rx || w_pkt_descriptor_ready;
control_read_control control_read_control_inst(
.i_clk                 (i_clk),
.i_rst_n               (i_rst_n),
                       
.iv_pkt_descriptor     (iv_pkt_descriptor),
.i_pkt_descriptor_wr   (i_pkt_descriptor_wr),
.o_pkt_descriptor_ready(w_pkt_descriptor_ready),
                       
.ov_pkt_bufid          (ov_pkt_bufid),
.o_pkt_bufid_wr        (o_pkt_bufid_wr),
.i_pkt_bufid_ack       (i_pkt_bufid_ack),
                       
.ov_pkt_raddr          (ov_pkt_raddr),
.o_pkt_rd              (o_pkt_rd),
.i_pkt_raddr_ack       (i_pkt_raddr_ack),
                       
.i_pkt_rd_req          (w_pkt_rd_req),
.i_pkt_last_cycle_rx   (w_pkt_last_cycle_rx),
.i_pkt_rx_valid        (i_pkt_data_wr),
.ov_pkt_inport         (),

.bufid_state           (bufid_state),
.pkt_read_state        (pkt_read_state)
);

control_output_interface control_output_interface_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
                   
.iv_pkt_descriptor     (iv_pkt_descriptor),
.i_pkt_descriptor_wr   (i_pkt_descriptor_wr),
                   
.iv_pkt_data(iv_pkt_data),
.i_pkt_data_wr(i_pkt_data_wr),

.ov_pkt_cnt(wv_pkt_cnt),
                      
.o_pkt_rd_req(w_pkt_rd_req),
.o_pkt_last_cycle_rx(w_pkt_last_cycle_rx),
                      
.ov_hcp_data  (ov_hcp_data),
.o_hcp_data_wr(o_hcp_data_wr),

.ov_eth_data  (ov_eth_data),
.o_eth_data_wr(o_eth_data_wr),

.hoi_state(hoi_state)
);
output reg [15:0] ov_debug_ts_cnt; 
output reg [15:0] ov_debug_cnt; 
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        ov_debug_ts_cnt <= 16'b0;
    end
    else begin
        if(i_pkt_data_wr && (iv_pkt_data[133:128] == 6'b01_0000) && (iv_pkt_data[127:125] <= 3'h2))begin
            ov_debug_ts_cnt <= ov_debug_ts_cnt + 1'b1;
        end
        else begin
            ov_debug_ts_cnt <= ov_debug_ts_cnt;
        end
    end
end

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        ov_debug_cnt <= 16'b0;
    end
    else begin
        if(i_pkt_bufid_ack)begin
            ov_debug_cnt <= ov_debug_cnt + 1'b1;
        end
        else begin
            ov_debug_cnt <= ov_debug_cnt;
        end
    end
end		
endmodule