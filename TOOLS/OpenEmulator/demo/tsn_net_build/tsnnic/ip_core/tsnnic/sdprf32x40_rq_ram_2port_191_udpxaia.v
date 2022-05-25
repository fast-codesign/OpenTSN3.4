
// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module  sdprf32x40_rq_ram_2port_191_udpxaia  (
    aclr,
    clock,
    data,
    rdaddress,
    rden,
    wraddress,
    wren,
    q);

    input    aclr;
    input    clock;
    input  [39:0]  data;
    input  [4:0]  rdaddress;
    input    rden;
    input  [4:0]  wraddress;
    input    wren;
    output [39:0]  q;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
    tri0     aclr;
    tri1     clock;
    tri1     rden;
    tri0     wren;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

    wire [39:0] sub_wire0;
    wire [39:0] q = sub_wire0[39:0];

    altera_syncram  altera_syncram_component (
                .aclr0 (aclr),
                .address_a (wraddress),
                .address_b (rdaddress),
                .clock0 (clock),
                .data_a (data),
                .rden_b (rden),
                .wren_a (wren),
                .q_b (sub_wire0),
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
                .data_b ({40{1'b1}}),
                //.eccencbypass (1'b0),
                //.eccencparity (8'b0),
                .eccstatus (),
                .q_a (),
                .rden_a (1'b1),
                //.sclr (1'b0),
                .wren_b (1'b0));
    defparam
        altera_syncram_component.address_aclr_b  = "NONE",
        altera_syncram_component.address_reg_b  = "CLOCK0",
        altera_syncram_component.clock_enable_input_a  = "BYPASS",
        altera_syncram_component.clock_enable_input_b  = "BYPASS",
        altera_syncram_component.clock_enable_output_b  = "BYPASS",
        altera_syncram_component.intended_device_family  = "Arria 10",
        altera_syncram_component.lpm_type  = "altera_syncram",
        altera_syncram_component.numwords_a  = 32,
        altera_syncram_component.numwords_b  = 32,
        altera_syncram_component.operation_mode  = "DUAL_PORT",
        altera_syncram_component.outdata_aclr_b  = "CLEAR0",
       // altera_syncram_component.outdata_sclr_b  = "NONE",
        altera_syncram_component.outdata_reg_b  = "CLOCK0",
        altera_syncram_component.power_up_uninitialized  = "FALSE",
        altera_syncram_component.rdcontrol_reg_b  = "CLOCK0",
        altera_syncram_component.read_during_write_mode_mixed_ports  = "DONT_CARE",
        altera_syncram_component.widthad_a  = 5,
        altera_syncram_component.widthad_b  = 5,
        altera_syncram_component.width_a  = 40,
        altera_syncram_component.width_b  = 40,
        altera_syncram_component.width_byteena_a  = 1;


endmodule


