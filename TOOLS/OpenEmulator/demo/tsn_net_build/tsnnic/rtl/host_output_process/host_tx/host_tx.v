// Copyright (C) 1953-2020 NUDT
// Verilog module name - host_tx 
// Version: HTX_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         transmit pkt to phy.
//            - top module.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module host_tx
(
       i_clk,
       i_rst_n,
                    
       iv_pkt_descriptor,
       i_dmac_replace_flag,	   
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

       o_pkt_output_pulse,  
       o_fifo_overflow_pulse,       
       
       ov_gmii_txd,
       o_gmii_tx_en   
);

// I/O
// clk & rst
input                  i_clk;                    
input                  i_rst_n;

output                 o_pkt_descriptor_ready;
// pkt_bufid from HOS(Host Output Schedule)                  
input      [60:0]      iv_pkt_descriptor;  
input                  i_dmac_replace_flag;          
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

output                 o_pkt_output_pulse;
output                 o_fifo_overflow_pulse;
// send pkt data from gmii     
output     [7:0]       ov_gmii_txd;
output                 o_gmii_tx_en;

//output               o_pkt_last_cycle_rx; 
// read requst signal and send data finish signal  
wire                   w_pkt_rd_req;


wire   w_pkt_descriptor_ready;
wire   w_pkt_last_cycle_rx;
assign o_pkt_descriptor_ready = w_pkt_last_cycle_rx || w_pkt_descriptor_ready;
host_read_control host_read_control_inst(
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

.bufid_state           (),
.pkt_read_state        ()
);

host_output_interface host_output_interface_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),
                   
.iv_pkt_descriptor     (iv_pkt_descriptor),
.i_dmac_replace_flag   (i_dmac_replace_flag),
.i_pkt_descriptor_wr   (i_pkt_descriptor_wr),
                   
.iv_pkt_data           (iv_pkt_data),
.i_pkt_data_wr         (i_pkt_data_wr),

.o_pkt_output_pulse    (o_pkt_output_pulse),
                      
.o_pkt_rd_req          (w_pkt_rd_req),
.o_pkt_last_cycle_rx   (w_pkt_last_cycle_rx),
                        
.ov_data               (ov_gmii_txd),
.o_data_wr             (o_gmii_tx_en),
                        
.i_timer_rst           (1'b0),
.iv_syned_global_time  (48'b0)
);

endmodule