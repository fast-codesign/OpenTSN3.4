
`timescale 1 ps / 1 ps
module sdprf32x40_rq (
		input  wire [39:0] data,      //  ram_input.datain
		input  wire [4:0]  wraddress, //           .wraddress
		input  wire [4:0]  rdaddress, //           .rdaddress
		input  wire        wren,      //           .wren
		input  wire        clock,     //           .clock
		input  wire        rden,      //           .rden
		input  wire        aclr,      //           .aclr
		output wire [39:0] q          // ram_output.dataout
	);

	sdprf32x40_rq_ram_2port_191_udpxaia ram_2port_0 (
		.data      (data),      //  ram_input.datain
		.wraddress (wraddress), //           .wraddress
		.rdaddress (rdaddress), //           .rdaddress
		.wren      (wren),      //           .wren
		.clock     (clock),     //           .clock
		.rden      (rden),      //           .rden
		.aclr      (aclr),      //           .aclr
		.q         (q)          // ram_output.dataout
	);

endmodule
