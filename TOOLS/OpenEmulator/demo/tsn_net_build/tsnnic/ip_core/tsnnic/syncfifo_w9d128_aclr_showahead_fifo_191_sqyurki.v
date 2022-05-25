
`timescale 1 ps / 1 ps
// synopsys translate_on
module  syncfifo_w9d128_aclr_showahead_fifo_191_sqyurki  (
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
    input  [8:0]  data;
    input    rdreq;
    input    wrreq;
    output   empty;
    output   full;
    output [8:0]  q;
    output [6:0]  usedw;

    wire  sub_wire0;
    wire  sub_wire1;
    wire [8:0] sub_wire2;
    wire [6:0] sub_wire3;
    wire  empty = sub_wire0;
    wire  full = sub_wire1;
    wire [8:0] q = sub_wire2[8:0];
    wire [6:0] usedw = sub_wire3[6:0];

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
        scfifo_component.lpm_numwords  = 128,
        scfifo_component.lpm_showahead  = "ON",
        scfifo_component.lpm_type  = "scfifo",
        scfifo_component.lpm_width  = 9,
        scfifo_component.lpm_widthu  = 7,
        scfifo_component.overflow_checking  = "ON",
        scfifo_component.underflow_checking  = "ON",
        scfifo_component.use_eab  = "ON";


endmodule


