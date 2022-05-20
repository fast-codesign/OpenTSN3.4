// Copyright (C) 1953-2020 NUDT
// Verilog module name - reset_top 
// Version: RST_TOP_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//        top of reset
//               
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module reset_top
(
    i_clk,
    i_rst_n,
    
    i_gmii_rxclk_p0,
    i_gmii_rxclk_p1,
    i_gmii_rxclk_p2,
    i_gmii_rxclk_p3,

    i_gmii_rxclk_host,
    
    o_core_rst_n,
    o_gmii_rst_n_p0,
    o_gmii_rst_n_p1,
    o_gmii_rst_n_p2,
    o_gmii_rst_n_p3,

    o_gmii_rst_n_host
);

input                   i_clk;                  
input                   i_rst_n;

input                   i_gmii_rxclk_p0;
input                   i_gmii_rxclk_p1;
input                   i_gmii_rxclk_p2;
input                   i_gmii_rxclk_p3;

input                   i_gmii_rxclk_host;

output                  o_core_rst_n;
output                  o_gmii_rst_n_p0;
output                  o_gmii_rst_n_p1;
output                  o_gmii_rst_n_p2;
output                  o_gmii_rst_n_p3;

output                  o_gmii_rst_n_host;

wire                    w_rst_n_glitch;

reset_glitch reset_glitch_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

.o_rst_n_glitch(w_rst_n_glitch)  
);

reset_sync core_reset_sync(
.i_clk(i_clk),
.i_rst_n(w_rst_n_glitch),

.o_rst_n_sync(o_core_rst_n)   
);

reset_sync gmii_p0_reset_sync(
.i_clk(i_gmii_rxclk_p0),
.i_rst_n(w_rst_n_glitch),

.o_rst_n_sync(o_gmii_rst_n_p0)   
);

reset_sync gmii_p1_reset_sync(
.i_clk(i_gmii_rxclk_p1),
.i_rst_n(w_rst_n_glitch),

.o_rst_n_sync(o_gmii_rst_n_p1)   
);

reset_sync gmii_p2_reset_sync(
.i_clk(i_gmii_rxclk_p2),
.i_rst_n(w_rst_n_glitch),

.o_rst_n_sync(o_gmii_rst_n_p2)   
);

reset_sync gmii_p3_reset_sync(
.i_clk(i_gmii_rxclk_p3),
.i_rst_n(w_rst_n_glitch),

.o_rst_n_sync(o_gmii_rst_n_p3)   
);

reset_sync gmii_host_reset_sync(
.i_clk(i_gmii_rxclk_host),
.i_rst_n(w_rst_n_glitch),

.o_rst_n_sync(o_gmii_rst_n_host)   
);
endmodule