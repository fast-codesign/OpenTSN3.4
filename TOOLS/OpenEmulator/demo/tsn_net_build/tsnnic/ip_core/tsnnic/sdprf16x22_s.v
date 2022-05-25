// sdprf16x22_s.v
`timescale 1 ps / 1 ps
module sdprf16x22_s (
		input  wire [21:0] data,      //  ram_input.datain
		input  wire [3:0]  wraddress, //           .wraddress
		input  wire [3:0]  rdaddress, //           .rdaddress
		input  wire        wren,      //           .wren
		input  wire        clock,     //           .clock
		input  wire        rden,      //           .rden
		input  wire        aclr,      //           .aclr
		output wire [21:0] q          // ram_output.dataout
	);

	sdprf16x22_s_ram_2port_191_3eqrjoa ram_2port_0 (
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
