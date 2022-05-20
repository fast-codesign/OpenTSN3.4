// Copyright (C) 1953-2020 NUDT
// Verilog module name - network_output_schedule
// Version: NOS_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         select the queue to be schdule first based on gate_ctrl_vector
//         read pkt_bufid from network_queue_manage
//         send pkt_bufid to Network_TX
//         one network interface have one network_output_schedule 
//             - number of queues: 8 
//             - number of network interface: 8
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module network_output_schedule
(
       i_clk,
       i_rst_n,
              
       iv_pkt_bufid,
       iv_pkt_next_bufid,
       iv_queue_id,
       i_queue_id_wr,
       iv_queue_empty,
       
       ov_schdule_id,
       o_schdule_id_wr,
       
       iv_gate_ctrl_vector,
       
       ov_queue_raddr,
       o_queue_rd,
       iv_rd_queue_data,
       i_rd_queue_data_wr,
       
       ov_pkt_bufid,
       o_pkt_bufid_wr,
       
       i_pkt_bufid_ack,
       ov_osc_state       
);

// I/O
// clk & rst
input                  i_clk;                   //125Mhz
input                  i_rst_n;
// pkt_bufid & queue_id from network_input_queue                     
input      [8:0]       iv_pkt_bufid;            //the id of pkt cached in the bufm_memory   
input      [8:0]       iv_pkt_next_bufid;
input      [2:0]       iv_queue_id;             //the pkt_bufid cached queue in the queue bufm_memory
input                  i_queue_id_wr;
input      [7:0]       iv_queue_empty;          //bitmaps on behalf of 8 queues 

output     [2:0]       ov_schdule_id;      
output                 o_schdule_id_wr; 
// gate_ctrl_vector from queue_gate_control             
input      [7:0]       iv_gate_ctrl_vector;     //bitmaps on behalf of 8 queues
// pkt_bufid from network_queue_manage   
output     [8:0]       ov_queue_raddr;          //read address to queue bufm_memory
output                 o_queue_rd;              //read signal to queue bufm_memory
input      [8:0]       iv_rd_queue_data;            //read data from queue bufm_memory
input                  i_rd_queue_data_wr;
// pkt_bufid to/from network_tx                      
output     [8:0]       ov_pkt_bufid;            //the pkt_bufid cached queue in the queue bufm_memory
output                 o_pkt_bufid_wr;
input                  i_pkt_bufid_ack;         //network_tx receive pkt_bufid and retuen get signal

output     [1:0]       ov_osc_state;   

// schedule queue message  
wire       [2:0]       wv_schdule_queue_osc2vqm;
wire                   w_schdule_queue_wr_osc2vqm; 

virtual_queue_manage virtual_queue_manage_inst(
.i_clk                 (i_clk),
.i_rst_n               (i_rst_n),
                       
.iv_pkt_bufid          (iv_pkt_bufid),
.iv_pkt_next_bufid     (iv_pkt_next_bufid),
.iv_queue_id           (iv_queue_id),
.i_queue_id_wr         (i_queue_id_wr),
.iv_queue_empty        (iv_queue_empty),
                      
.ov_queue_raddr        (ov_queue_raddr),
.o_queue_rd            (o_queue_rd),
.iv_rd_queue_data      (iv_rd_queue_data),
.i_rd_queue_data_wr    (i_rd_queue_data_wr),
                      
.ov_pkt_bufid          (ov_pkt_bufid),
.o_pkt_bufid_wr        (o_pkt_bufid_wr),

.iv_schdule_queue      (wv_schdule_queue_osc2vqm),
.i_schdule_queue_wr    (w_schdule_queue_wr_osc2vqm),

.ov_schdule_id         (ov_schdule_id),
.o_schdule_id_wr       (o_schdule_id_wr)
);

output_schedule_control output_schedule_control_inst(
.i_clk                 (i_clk),
.i_rst_n               (i_rst_n),
                       
.iv_gate_ctrl_vector   (iv_gate_ctrl_vector),
                       
.i_pkt_bufid_ack       (i_pkt_bufid_ack),
                       
.iv_queue_empty        (iv_queue_empty),

.ov_schdule_queue      (wv_schdule_queue_osc2vqm),
.o_schdule_queue_wr    (w_schdule_queue_wr_osc2vqm),
.ov_osc_state          (ov_osc_state)
);
endmodule