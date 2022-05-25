

`timescale 1 ps / 1 ps
module simpledualportram_drwclock_outputaclr_w8d16 (
		input  wire [7:0] data,      //  ram_input.datain
		input  wire [3:0] wraddress, //           .wraddress
		input  wire [3:0] rdaddress, //           .rdaddress
		input  wire       wren,      //           .wren
		input  wire       wrclock,   //           .wrclock
		input  wire       rdclock,   //           .rdclock
		input  wire       rden,      //           .rden
		input  wire       rd_aclr,   //           .rd_aclr
		output wire [7:0] q          // ram_output.dataout
	);

	simpledualportram_drwclock_outputaclr_w8d16_ram_2port_191_jrxaipq ram_2port_0 (
		.data      (data),      //  ram_input.datain
		.wraddress (wraddress), //           .wraddress
		.rdaddress (rdaddress), //           .rdaddress
		.wren      (wren),      //           .wren
		.wrclock   (wrclock),   //           .wrclock
		.rdclock   (rdclock),   //           .rdclock
		.rden      (rden),      //           .rden
		.rd_aclr   (rd_aclr),   //           .rd_aclr
		.q         (q)          // ram_output.dataout
	);

endmodule
