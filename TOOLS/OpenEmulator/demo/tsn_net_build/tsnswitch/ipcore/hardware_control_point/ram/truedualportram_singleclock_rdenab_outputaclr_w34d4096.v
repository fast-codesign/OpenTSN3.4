

`timescale 1 ps / 1 ps
module truedualportram_singleclock_rdenab_outputaclr_w34d4096 (
		input  wire [33:0] data_a,    //  ram_input.datain_a
		input  wire [33:0] data_b,    //           .datain_b
		input  wire [11:0] address_a, //           .address_a
		input  wire [11:0] address_b, //           .address_b
		input  wire        wren_a,    //           .wren_a
		input  wire        wren_b,    //           .wren_b
		input  wire        clock,     //           .clock
		input  wire        rden_a,    //           .rden_a
		input  wire        rden_b,    //           .rden_b
		input  wire        aclr,      //           .aclr
		output wire [33:0] q_a,       // ram_output.dataout_a
		output wire [33:0] q_b        //           .dataout_b
	);

	truedualportram_singleclock_rdenab_outputaclr_w34d4096_ram_2port_191_ewxmrhi ram_2port_0 (
		.data_a    (data_a),    //  ram_input.datain_a
		.data_b    (data_b),    //           .datain_b
		.address_a (address_a), //           .address_a
		.address_b (address_b), //           .address_b
		.wren_a    (wren_a),    //           .wren_a
		.wren_b    (wren_b),    //           .wren_b
		.clock     (clock),     //           .clock
		.rden_a    (rden_a),    //           .rden_a
		.rden_b    (rden_b),    //           .rden_b
		.aclr      (aclr),      //           .aclr
		.q_a       (q_a),       // ram_output.dataout_a
		.q_b       (q_b)        //           .dataout_b
	);

endmodule
