
`timescale 1 ps / 1 ps
// synopsys translate_on
module  syncfifo_showahead_aclr_w35d4_fifo_191_vo6tksa  (
    aclr,
    clock,
    data,
    rdreq,
    wrreq,
    empty,
    full,
    q,
    usedw);

    input    aclr;
    input    clock;
    input  [34:0]  data;
    input    rdreq;
    input    wrreq;
    output   empty;
    output   full;
    output [34:0]  q;
    output [1:0]  usedw;

    wire  sub_wire0;
    wire  sub_wire1;
    wire [34:0] sub_wire2;
    wire [1:0] sub_wire3;
    wire  empty = sub_wire0;
    wire  full = sub_wire1;
    wire [34:0] q = sub_wire2[34:0];
    wire [1:0] usedw = sub_wire3[1:0];

    scfifo  scfifo_component (
                .aclr (aclr),
                .clock (clock),
                .data (data),
                .rdreq (rdreq),
                .wrreq (wrreq),
                .empty (sub_wire0),
                .full (sub_wire1),
                .q (sub_wire2),
                .usedw (sub_wire3),
                .almost_empty (),
                .almost_full (),
                .eccstatus (),
                .sclr ());
    defparam
        scfifo_component.add_ram_output_register  = "OFF",
        scfifo_component.enable_ecc  = "FALSE",
        scfifo_component.intended_device_family  = "Arria 10",
        scfifo_component.lpm_numwords  = 4,
        scfifo_component.lpm_showahead  = "ON",
        scfifo_component.lpm_type  = "scfifo",
        scfifo_component.lpm_width  = 35,
        scfifo_component.lpm_widthu  = 2,
        scfifo_component.overflow_checking  = "ON",
        scfifo_component.underflow_checking  = "ON",
        scfifo_component.use_eab  = "ON";


endmodule


