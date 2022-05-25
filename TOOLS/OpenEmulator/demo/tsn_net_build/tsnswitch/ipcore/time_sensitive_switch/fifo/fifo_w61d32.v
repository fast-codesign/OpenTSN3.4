

`timescale 1 ps / 1 ps
module fifo_w61d32 (
		input  wire [60:0] data,  //  fifo_input.datain
		input  wire        wrreq, //            .wrreq
		input  wire        rdreq, //            .rdreq
		input  wire        clock, //            .clk
		input  wire        aclr,  //            .aclr
		output wire [60:0] q,     // fifo_output.dataout
		output wire [4:0]  usedw, //            .usedw
		output wire        full,  //            .full
		output wire        empty  //            .empty
	);

	fifo_w61d32_fifo_191_wgu76ka fifo_0 (
		.data  (data),  //  fifo_input.datain
		.wrreq (wrreq), //            .wrreq
		.rdreq (rdreq), //            .rdreq
		.clock (clock), //            .clk
		.aclr  (aclr),  //            .aclr
		.q     (q),     // fifo_output.dataout
		.usedw (usedw), //            .usedw
		.full  (full),  //            .full
		.empty (empty)  //            .empty
	);

endmodule
