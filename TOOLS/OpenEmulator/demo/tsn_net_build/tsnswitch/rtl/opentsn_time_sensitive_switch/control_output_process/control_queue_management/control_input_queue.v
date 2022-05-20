// Copyright (C) 1953-2021 NUDT
// Verilog module name - control_input_queue 
// Version: V3.2.0.20210722
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         control bufid of pkt transmitted to host to input queue
//             - write bufid of ts packet to ram of TIM; 
//             - write bufid of not ts packet to queue.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module control_input_queue
(
        i_clk,
        i_rst_n,
       
        iv_pkt_type_ctrl,
	    iv_pkt_bufid_ctrl,
        i_mac_entry_hit_ctrl,
        iv_pkt_inport_ctrl,
        i_pkt_bufid_wr_ctrl,
        
        ov_fifo_wdata,
        o_fifo_wr
);
// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;  
//tsntag & bufid input from host_port
input          [2:0]   iv_pkt_type_ctrl;
input          [8:0]   iv_pkt_bufid_ctrl;
input                  i_mac_entry_hit_ctrl;
input          [3:0]   iv_pkt_inport_ctrl;
input                  i_pkt_bufid_wr_ctrl;
//tsntag & bufid output
output reg     [13:0]  ov_fifo_wdata;
output reg             o_fifo_wr;
//***************************************************
//          control bufid to input queue 
//***************************************************
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        ov_fifo_wdata <= 14'b0;
        o_fifo_wr <= 1'b0;      
    end
    else begin
		if(i_pkt_bufid_wr_ctrl)begin
			ov_fifo_wdata <= {i_mac_entry_hit_ctrl,iv_pkt_inport_ctrl,iv_pkt_bufid_ctrl};
			o_fifo_wr <= 1'b1;                   
		end
		else begin
			ov_fifo_wdata <= 57'b0;
			o_fifo_wr <= 1'b0; 
        end           
    end
end 
endmodule