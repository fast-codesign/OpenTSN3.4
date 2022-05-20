// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.



// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module  asdprf16x9_rq_ram_2port_150_ay73gla  (
    data,
    rd_aclr,
    rdaddress,
    rdclock,
    rden,
    wraddress,
    wrclock,
    wren,
    q);

    input  [8:0]  data;
    input    rd_aclr;
    input  [3:0]  rdaddress;
    input    rdclock;
    input    rden;
    input  [3:0]  wraddress;
    input    wrclock;
    input    wren;
    output [8:0]  q;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_off
`endif
    tri0     rd_aclr;
    tri1     rden;
    tri1     wrclock;
    tri0     wren;
`ifndef ALTERA_RESERVED_QIS
// synopsys translate_on
`endif

    wire [8:0] sub_wire0;
    wire [8:0] q = sub_wire0[8:0];

    altera_syncram  altera_syncram_component (
                .aclr1 (rd_aclr),
                .address_a (wraddress),
                .address_b (rdaddress),
                .clock0 (wrclock),
                .clock1 (rdclock),
                .data_a (data),
                .rden_b (rden),
                .wren_a (wren),
                .q_b (sub_wire0),
                .aclr0 (1'b0),
                .addressstall_a (1'b0),
                .addressstall_b (1'b0),
                .byteena_a (1'b1),
                .byteena_b (1'b1),
                .clocken0 (1'b1),
                .clocken1 (1'b1),
                .clocken2 (1'b1),
                .clocken3 (1'b1),
                .data_b ({9{1'b1}}),
                .eccstatus (),
                .q_a (),
                .rden_a (1'b1),
                .wren_b (1'b0));
    defparam
        altera_syncram_component.address_aclr_b  = "CLEAR1",
        altera_syncram_component.address_reg_b  = "CLOCK1",
        altera_syncram_component.clock_enable_input_a  = "BYPASS",
        altera_syncram_component.clock_enable_input_b  = "BYPASS",
        altera_syncram_component.clock_enable_output_b  = "BYPASS",
        altera_syncram_component.intended_device_family  = "Arria 10",
        altera_syncram_component.lpm_type  = "altera_syncram",
        altera_syncram_component.numwords_a  = 16,
        altera_syncram_component.numwords_b  = 16,
        altera_syncram_component.operation_mode  = "DUAL_PORT",
        altera_syncram_component.outdata_aclr_b  = "NONE",
        altera_syncram_component.outdata_reg_b  = "CLOCK1",
        altera_syncram_component.power_up_uninitialized  = "FALSE",
        altera_syncram_component.rdcontrol_reg_b  = "CLOCK1",
        altera_syncram_component.widthad_a  = 4,
        altera_syncram_component.widthad_b  = 4,
        altera_syncram_component.width_a  = 9,
        altera_syncram_component.width_b  = 9,
        altera_syncram_component.width_byteena_a  = 1;


endmodule


