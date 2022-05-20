// Copyright (C) 1953-2022 NUDT
// Verilog module name - command_parse_and_encapsulate_hcp 
// Version: V3.4.0.20220228
// Created:
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module command_parse_and_encapsulate_hcp
(
        i_clk,
        i_rst_n,
       
        iv_command,
	    i_command_wr,    

        o_hrg_wr,
        ov_hrg_wdata,
        ov_hrg_addr,
        o_hrg_addr_fix,        
        o_hrg_rd,
        i_hrg_wr,
        iv_hrg_raddr,
        i_hrg_addr_fix,
        iv_hrg_rdata,
        
        o_ost_wr,
        ov_ost_wdata,
        ov_ost_addr,
        o_ost_addr_fix,        
        o_ost_rd,
        i_ost_wr,
        iv_ost_raddr,
        i_ost_addr_fix,
        iv_ost_rdata,

        o_cc_wr,
        ov_cc_wdata,
        ov_cc_addr,
        o_cc_addr_fix,        
        o_cc_rd,
        i_cc_wr,
        iv_cc_raddr,
        i_cc_addr_fix,
        iv_cc_rdata, 
        
        o_tft_wr,
        ov_tft_wdata,
        ov_tft_addr,
        o_tft_addr_fix,        
        o_tft_rd,
        i_tft_wr,
        iv_tft_raddr,
        i_tft_addr_fix,
        iv_tft_rdata, 

        o_osm_wr,
        ov_osm_wdata,
        ov_osm_addr,
        o_osm_addr_fix,        
        o_osm_rd,
        i_osm_wr,
        iv_osm_raddr,
        i_osm_addr_fix,
        iv_osm_rdata,        
      
        ov_command,
	    o_command_wr            
);


// I/O
// i_clk & rst
input                  i_clk;
input                  i_rst_n;     
//nmac data
input      [63:0]      iv_command;               
input                  i_command_wr;             

output                 o_hrg_wr;
output     [31:0]      ov_hrg_wdata;
output     [18:0]      ov_hrg_addr;
output                 o_hrg_addr_fix;       
output                 o_hrg_rd;        
input                  i_hrg_wr;
input      [18:0]      iv_hrg_raddr;
input                  i_hrg_addr_fix;
input      [31:0]      iv_hrg_rdata;

output                 o_ost_wr;
output     [31:0]      ov_ost_wdata;
output     [18:0]      ov_ost_addr;
output                 o_ost_addr_fix;       
output                 o_ost_rd;        
input                  i_ost_wr;
input      [18:0]      iv_ost_raddr;
input                  i_ost_addr_fix;
input      [31:0]      iv_ost_rdata;

output                 o_cc_wr;
output     [31:0]      ov_cc_wdata;
output     [18:0]      ov_cc_addr;
output                 o_cc_addr_fix;       
output                 o_cc_rd;        
input                  i_cc_wr;
input      [18:0]      iv_cc_raddr;
input                  i_cc_addr_fix;
input      [31:0]      iv_cc_rdata;

output                 o_tft_wr;
output     [31:0]      ov_tft_wdata;
output     [18:0]      ov_tft_addr;
output                 o_tft_addr_fix;       
output                 o_tft_rd;        
input                  i_tft_wr;
input      [18:0]      iv_tft_raddr;
input                  i_tft_addr_fix;
input      [31:0]      iv_tft_rdata;

output                 o_osm_wr;
output     [31:0]      ov_osm_wdata;
output     [18:0]      ov_osm_addr;
output                 o_osm_addr_fix;       
output                 o_osm_rd;        
input                  i_osm_wr;
input      [18:0]      iv_osm_raddr;
input                  i_osm_addr_fix;
input      [31:0]      iv_osm_rdata;
          
output     [63:0]      ov_command;              
output                 o_command_wr;   
command_parse_hcp command_parse_hcp_inst
(
        .i_clk                 (i_clk           ),
        .i_rst_n               (i_rst_n         ),

        .iv_command            (iv_command      ),
	    .i_command_wr          (i_command_wr    ),    

        .o_hrg_wr          (o_hrg_wr            ),
        .ov_hrg_wdata      (ov_hrg_wdata        ),
        .ov_hrg_addr       (ov_hrg_addr         ),
        .o_hrg_addr_fix    (o_hrg_addr_fix      ),        
        .o_hrg_rd          (o_hrg_rd            ),

        .o_ost_wr          (o_ost_wr            ),
        .ov_ost_wdata      (ov_ost_wdata        ),
        .ov_ost_addr       (ov_ost_addr         ),
        .o_ost_addr_fix    (o_ost_addr_fix      ),        
        .o_ost_rd          (o_ost_rd            ), 

        .o_cc_wr          (o_cc_wr            ),
        .ov_cc_wdata      (ov_cc_wdata        ),
        .ov_cc_addr       (ov_cc_addr         ),
        .o_cc_addr_fix    (o_cc_addr_fix      ),        
        .o_cc_rd          (o_cc_rd            ), 

        .o_tft_wr          (o_tft_wr            ),
        .ov_tft_wdata      (ov_tft_wdata        ),
        .ov_tft_addr       (ov_tft_addr         ),
        .o_tft_addr_fix    (o_tft_addr_fix      ),        
        .o_tft_rd          (o_tft_rd            ), 
        
        .o_osm_wr          (o_osm_wr            ),
        .ov_osm_wdata      (ov_osm_wdata        ),
        .ov_osm_addr       (ov_osm_addr         ),
        .o_osm_addr_fix    (o_osm_addr_fix      ),        
        .o_osm_rd          (o_osm_rd            )         
);
command_encapsulate_hcp command_encapsulate_hcp_inst
(
        .i_clk                         (i_clk           ),
        .i_rst_n                       (i_rst_n         ),   

        .i_hrg_wr                      (i_hrg_wr        ),
        .i_hrg_addr_fix                (i_hrg_addr_fix  ),
        .iv_hrg_raddr                  (iv_hrg_raddr    ),
        .iv_hrg_rdata                  (iv_hrg_rdata    ),
        
        .i_ost_wr                      (i_ost_wr        ),
        .i_ost_addr_fix                (i_ost_addr_fix  ),
        .iv_ost_raddr                  (iv_ost_raddr    ),
        .iv_ost_rdata                  (iv_ost_rdata    ),

        .i_tft_wr                      (i_tft_wr        ),
        .i_tft_addr_fix                (i_tft_addr_fix  ),
        .iv_tft_raddr                  (iv_tft_raddr    ),
        .iv_tft_rdata                  (iv_tft_rdata    ),
        
        .i_cc_wr                      (i_cc_wr        ),
        .i_cc_addr_fix                (i_cc_addr_fix  ),
        .iv_cc_raddr                  (iv_cc_raddr    ),
        .iv_cc_rdata                  (iv_cc_rdata    ),        
        
        .i_osm_wr                      (i_osm_wr        ),
        .i_osm_addr_fix                (i_osm_addr_fix  ),
        .iv_osm_raddr                  (iv_osm_raddr    ),
        .iv_osm_rdata                  (iv_osm_rdata    ),          

        .ov_command                    (ov_command      ),
	    .o_command_wr                  (o_command_wr    )
);   
endmodule
    