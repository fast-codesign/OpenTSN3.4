
`timescale 1 ps / 1 ps
// synopsys translate_on
module  truedualportram_sclock_outputaclr_w60d32_ram_2port_191_vw5faqa  (
    aclr,
    address_a,
    address_b,
    clock,
    data_a,
    data_b,
    rden_a,
    rden_b,
    wren_a,
    wren_b,
    q_a,
    q_b);

    input    aclr;
    input  [4:0]  address_a;
    input  [4:0]  address_b;
    input    clock;
    input  [59:0]  data_a;
    input  [59:0]  data_b;
    input    rden_a;
    input    rden_b;
    input    wren_a;
    input    wren_b;
    output [59:0]  q_a;
    output [59:0]  q_b;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
    tri0     aclr;
    tri1     clock;
    tri1     rden_a;
    tri1     rden_b;
    tri0     wren_a;
    tri0     wren_b;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

    wire [59:0] sub_wire0;
    wire [59:0] sub_wire1;
    wire [59:0] q_a = sub_wire0[59:0];
    wire [59:0] q_b = sub_wire1[59:0];

    altera_syncram  altera_syncram_component (
                .aclr0 (aclr),
                .address_a (address_a),
                .address_b (address_b),
                .clock0 (clock),
                .data_a (data_a),
                .data_b (data_b),
                .rden_a (rden_a),
                .rden_b (rden_b),
                .wren_a (wren_a),
                .wren_b (wren_b),
                .q_a (sub_wire0),
                .q_b (sub_wire1),
                .aclr1 (1'b0),
                //.address2_a (1'b1),
                //.address2_b (1'b1),
                .addressstall_a (1'b0),
                .addressstall_b (1'b0),
                .byteena_a (1'b1),
                .byteena_b (1'b1),
                .clock1 (1'b1),
                .clocken0 (1'b1),
                .clocken1 (1'b1),
                .clocken2 (1'b1),
                .clocken3 (1'b1),
                //.eccencbypass (1'b0),
                //.eccencparity (8'b0),
                .eccstatus ());
                //.sclr (1'b0));
    defparam
        altera_syncram_component.address_reg_b  = "CLOCK0",
        altera_syncram_component.clock_enable_input_a  = "BYPASS",
        altera_syncram_component.clock_enable_input_b  = "BYPASS",
        altera_syncram_component.clock_enable_output_a  = "BYPASS",
        altera_syncram_component.clock_enable_output_b  = "BYPASS",
        altera_syncram_component.indata_reg_b  = "CLOCK0",
        altera_syncram_component.intended_device_family  = "Arria 10",
        altera_syncram_component.lpm_type  = "altera_syncram",
        altera_syncram_component.numwords_a  = 32,
        altera_syncram_component.numwords_b  = 32,
        altera_syncram_component.operation_mode  = "BIDIR_DUAL_PORT",
        altera_syncram_component.outdata_aclr_a  = "CLEAR0",
        //altera_syncram_component.outdata_sclr_a  = "NONE",
        altera_syncram_component.outdata_aclr_b  = "CLEAR0",
        //altera_syncram_component.outdata_sclr_b  = "NONE",
        altera_syncram_component.outdata_reg_a  = "CLOCK0",
        altera_syncram_component.outdata_reg_b  = "CLOCK0",
        altera_syncram_component.power_up_uninitialized  = "FALSE",
        altera_syncram_component.read_during_write_mode_mixed_ports  = "DONT_CARE",
        altera_syncram_component.read_during_write_mode_port_a  = "NEW_DATA_NO_NBE_READ",
        altera_syncram_component.read_during_write_mode_port_b  = "NEW_DATA_NO_NBE_READ",
        altera_syncram_component.widthad_a  = 5,
        altera_syncram_component.widthad_b  = 5,
        altera_syncram_component.width_a  = 60,
        altera_syncram_component.width_b  = 60,
        altera_syncram_component.width_byteena_a  = 1,
        altera_syncram_component.width_byteena_b  = 1;


endmodule


