

`timescale 1 ps / 1 ps
module syncfifo_showahead_aclr_w35d4 (
		input  wire [34:0] data,  //  fifo_input.datain
		input  wire        wrreq, //            .wrreq
		input  wire        rdreq, //            .rdreq
		input  wire        clock, //            .clk
		input  wire        aclr,  //            .aclr
		output wire [34:0] q,     // fifo_output.dataout
		output wire [1:0]  usedw, //            .usedw
		output wire        full,  //            .full
		output wire        empty  //            .empty
	);

	syncfifo_showahead_aclr_w35d4_fifo_191_vo6tksa fifo_0 (
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
