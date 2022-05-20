// Copyright (C) 1953-2022 NUDT
// Verilog module name - command_parse_and_encapsulate_tse
// Version: V3.4.0.20220225
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         command interface transfer
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module command_parse_and_encapsulate_tse
    (
        i_clk,
        i_rst_n,

        iv_command,   
        i_command_wr,           
        
        ov_addr,
        ov_wdata,
        o_addr_fixed,     
        
        o_wr_stc   ,
        o_rd_stc   ,

        o_wr_ffi_p8,
        o_rd_ffi_p8,
        o_wr_dex_p8,
        o_rd_dex_p8,
        o_wr_ctx_p8,
        o_rd_ctx_p8,
        o_wr_cdc_p8,
        o_rd_cdc_p8,
                   
        o_wr_ffi_p0,
        o_rd_ffi_p0,
        o_wr_dex_p0,
        o_rd_dex_p0,
        o_wr_ctx_p0,
        o_rd_ctx_p0,
        o_wr_cdc_p0,
        o_rd_cdc_p0,
                  
        o_wr_ffi_p1,
        o_rd_ffi_p1,
        o_wr_dex_p1,
        o_rd_dex_p1,
        o_wr_ctx_p1,
        o_rd_ctx_p1,
        o_wr_cdc_p1,
        o_rd_cdc_p1,
                   
        o_wr_ffi_p2,
        o_rd_ffi_p2,
        o_wr_dex_p2,
        o_rd_dex_p2,
        o_wr_ctx_p2,
        o_rd_ctx_p2,
        o_wr_cdc_p2,
        o_rd_cdc_p2,
                  
        o_wr_ffi_p3,
        o_rd_ffi_p3,
        o_wr_frm,
        o_rd_frm,
        o_wr_tic,
        o_rd_tic,
        o_wr_cdc_p3,
        o_rd_cdc_p3,
                  
                 
        o_wr_grm   ,
        o_rd_grm   ,	
        
        o_wr_pcb   ,
        o_rd_pcb   ,
        
        o_wr_qgc0  ,
        o_rd_qgc0  ,
                   
        o_wr_qgc1  ,
        o_rd_qgc1  ,
                   
        o_wr_qgc2  ,
        o_rd_qgc2  ,
                   
        o_wr_fim  ,
        o_rd_fim  ,
                   
        o_wr_cfu   ,
        o_rd_cfu   ,       
        
        i_wr_stc,
        iv_addr_stc,
        i_addr_fixed_stc,
        iv_rdata_stc,

        i_wr_ffi_p8,
        iv_addr_ffi_p8,
        i_addr_fixed_ffi_p8,
        iv_rdata_ffi_p8,

        i_wr_dex_p8,
        iv_addr_dex_p8,
        i_addr_fixed_dex_p8,
        iv_rdata_dex_p8,

        i_wr_ctx_p8,
        iv_addr_ctx_p8,
        i_addr_fixed_ctx_p8,
        iv_rdata_ctx_p8,

        i_wr_cdc_p8,
        iv_addr_cdc_p8,
        i_addr_fixed_cdc_p8,
        iv_rdata_cdc_p8,

        i_wr_ffi_p0,
        iv_addr_ffi_p0,
        i_addr_fixed_ffi_p0,
        iv_rdata_ffi_p0,

        i_wr_dex_p0,
        iv_addr_dex_p0,
        i_addr_fixed_dex_p0,
        iv_rdata_dex_p0,

        i_wr_ctx_p0,
        iv_addr_ctx_p0,
        i_addr_fixed_ctx_p0,
        iv_rdata_ctx_p0,

        i_wr_cdc_p0,
        iv_addr_cdc_p0,
        i_addr_fixed_cdc_p0,
        iv_rdata_cdc_p0,

        i_wr_ffi_p1,
        iv_addr_ffi_p1,
        i_addr_fixed_ffi_p1,
        iv_rdata_ffi_p1,

        i_wr_dex_p1,
        iv_addr_dex_p1,
        i_addr_fixed_dex_p1,
        iv_rdata_dex_p1,

        i_wr_ctx_p1,
        iv_addr_ctx_p1,
        i_addr_fixed_ctx_p1,
        iv_rdata_ctx_p1,

        i_wr_cdc_p1,
        iv_addr_cdc_p1,
        i_addr_fixed_cdc_p1,
        iv_rdata_cdc_p1,

        i_wr_ffi_p2,
        iv_addr_ffi_p2,
        i_addr_fixed_ffi_p2,
        iv_rdata_ffi_p2,

        i_wr_dex_p2,
        iv_addr_dex_p2,
        i_addr_fixed_dex_p2,
        iv_rdata_dex_p2,

        i_wr_ctx_p2,
        iv_addr_ctx_p2,
        i_addr_fixed_ctx_p2,
        iv_rdata_ctx_p2,

        i_wr_cdc_p2,
        iv_addr_cdc_p2,
        i_addr_fixed_cdc_p2,
        iv_rdata_cdc_p2,

        i_wr_ffi_p3,
        iv_addr_ffi_p3,
        i_addr_fixed_ffi_p3,
        iv_rdata_ffi_p3,

        i_wr_frm        ,
        iv_addr_frm     ,       
        i_addr_fixed_frm,       
        iv_rdata_frm    ,       
                        
        i_wr_tic        ,       
        iv_addr_tic     ,       
        i_addr_fixed_tic,       
        iv_rdata_tic    ,       
        
        

        i_wr_cdc_p3,
        iv_addr_cdc_p3,
        i_addr_fixed_cdc_p3,
        iv_rdata_cdc_p3,


        i_wr_grm,
        iv_addr_grm,
        i_addr_fixed_grm,
        iv_rdata_grm,

        i_wr_pcb,
        iv_addr_pcb,
        i_addr_fixed_pcb,
        iv_rdata_pcb,

        i_wr_qgc0,
        iv_addr_qgc0,
        i_addr_fixed_qgc0,
        iv_rdata_qgc0,

        i_wr_qgc1,
        iv_addr_qgc1,
        i_addr_fixed_qgc1,
        iv_rdata_qgc1,

        i_wr_qgc2,
        iv_addr_qgc2,
        i_addr_fixed_qgc2,
        iv_rdata_qgc2,

        i_wr_fim        ,
        iv_addr_fim     ,
        i_addr_fixed_fim,
        iv_rdata_fim    ,

        i_wr_cfu,
        iv_addr_cfu,
        i_addr_fixed_cfu,
        iv_rdata_cfu,

        o_command_ack_wr,
        ov_command_ack          
    );
// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n; 
//receive command           
input       [63:0]      iv_command;   
input                   i_command_wr;           
  
output      [18:0]      ov_addr;
output      [31:0]      ov_wdata;
output                  o_addr_fixed;
//to stc 
output                  o_wr_stc;
output                  o_rd_stc;
//to p8                 
output                  o_wr_ffi_p8;
output                  o_rd_ffi_p8;
output                  o_wr_dex_p8;
output                  o_rd_dex_p8;
output                  o_wr_ctx_p8;
output                  o_rd_ctx_p8;
output                  o_wr_cdc_p8;
output                  o_rd_cdc_p8;
//to p0                 
output                  o_wr_ffi_p0;
output                  o_rd_ffi_p0;
output                  o_wr_dex_p0;
output                  o_rd_dex_p0;
output                  o_wr_ctx_p0;
output                  o_rd_ctx_p0;
output                  o_wr_cdc_p0;
output                  o_rd_cdc_p0;
//to p1                 
output                  o_wr_ffi_p1;
output                  o_rd_ffi_p1;
output                  o_wr_dex_p1;
output                  o_rd_dex_p1;
output                  o_wr_ctx_p1;
output                  o_rd_ctx_p1;
output                  o_wr_cdc_p1;
output                  o_rd_cdc_p1;
//to p2                 
output                  o_wr_ffi_p2;
output                  o_rd_ffi_p2;
output                  o_wr_dex_p2;
output                  o_rd_dex_p2;
output                  o_wr_ctx_p2;
output                  o_rd_ctx_p2;
output                  o_wr_cdc_p2;
output                  o_rd_cdc_p2;
//to p3                 
output                  o_wr_ffi_p3;
output                  o_rd_ffi_p3;
output                  o_wr_frm;
output                  o_rd_frm;
output                  o_wr_tic;
output                  o_rd_tic;
output                  o_wr_cdc_p3;
output                  o_rd_cdc_p3;
            									
//to grm                
output                  o_wr_grm;
output                  o_rd_grm;	
//to pcb                
output                  o_wr_pcb;
output                  o_rd_pcb;
//to qgc                
output                  o_wr_qgc0;
output                  o_rd_qgc0;
                        
output                  o_wr_qgc1;
output                  o_rd_qgc1;
                        
output                  o_wr_qgc2;
output                  o_rd_qgc2;
                        
output                  o_wr_fim;
output                  o_rd_fim;
                        
                                                
output                  o_wr_cfu;
output                  o_rd_cfu;
//from stc 
input                   i_wr_stc;
input        [18:0]     iv_addr_stc;
input                   i_addr_fixed_stc;
input        [31:0]     iv_rdata_stc;
//from ffi_p8 
input                   i_wr_ffi_p8;
input        [18:0]     iv_addr_ffi_p8;
input                   i_addr_fixed_ffi_p8;
input        [31:0]     iv_rdata_ffi_p8;
//from dex_p8 
input                   i_wr_dex_p8;
input        [18:0]     iv_addr_dex_p8;
input                   i_addr_fixed_dex_p8;
input        [31:0]     iv_rdata_dex_p8;
//from ctx_p8 
input                   i_wr_ctx_p8;
input        [18:0]     iv_addr_ctx_p8;
input                   i_addr_fixed_ctx_p8;
input        [31:0]     iv_rdata_ctx_p8;
//from cdc_p8 
input                   i_wr_cdc_p8;
input        [18:0]     iv_addr_cdc_p8;
input                   i_addr_fixed_cdc_p8;
input        [31:0]     iv_rdata_cdc_p8;
//from ffi_p0 
input                   i_wr_ffi_p0;
input        [18:0]     iv_addr_ffi_p0;
input                   i_addr_fixed_ffi_p0;
input        [31:0]     iv_rdata_ffi_p0;
//from dex_p0 
input                   i_wr_dex_p0;
input        [18:0]     iv_addr_dex_p0;
input                   i_addr_fixed_dex_p0;
input        [31:0]     iv_rdata_dex_p0;
//from ctx_p0 
input                   i_wr_ctx_p0;
input        [18:0]     iv_addr_ctx_p0;
input                   i_addr_fixed_ctx_p0;
input        [31:0]     iv_rdata_ctx_p0;
//from cdc_p0 
input                   i_wr_cdc_p0;
input        [18:0]     iv_addr_cdc_p0;
input                   i_addr_fixed_cdc_p0;
input        [31:0]     iv_rdata_cdc_p0;
//from ffi_p1 
input                   i_wr_ffi_p1;
input        [18:0]     iv_addr_ffi_p1;
input                   i_addr_fixed_ffi_p1;
input        [31:0]     iv_rdata_ffi_p1;
//from dex_p1 
input                   i_wr_dex_p1;
input        [18:0]     iv_addr_dex_p1;
input                   i_addr_fixed_dex_p1;
input        [31:0]     iv_rdata_dex_p1;
//from ctx_p1 
input                   i_wr_ctx_p1;
input        [18:0]     iv_addr_ctx_p1;
input                   i_addr_fixed_ctx_p1;
input        [31:0]     iv_rdata_ctx_p1;
//from cdc_p1 
input                   i_wr_cdc_p1;
input        [18:0]     iv_addr_cdc_p1;
input                   i_addr_fixed_cdc_p1;
input        [31:0]     iv_rdata_cdc_p1;
//from ffi_p2 
input                   i_wr_ffi_p2;
input        [18:0]     iv_addr_ffi_p2;
input                   i_addr_fixed_ffi_p2;
input        [31:0]     iv_rdata_ffi_p2;
//from dex_p2 
input                   i_wr_dex_p2;
input        [18:0]     iv_addr_dex_p2;
input                   i_addr_fixed_dex_p2;
input        [31:0]     iv_rdata_dex_p2;
//from ctx_p2 
input                   i_wr_ctx_p2;
input        [18:0]     iv_addr_ctx_p2;
input                   i_addr_fixed_ctx_p2;
input        [31:0]     iv_rdata_ctx_p2;
//from cdc_p2 
input                   i_wr_cdc_p2;
input        [18:0]     iv_addr_cdc_p2;
input                   i_addr_fixed_cdc_p2;
input        [31:0]     iv_rdata_cdc_p2;
//from ffi_p3 
input                   i_wr_ffi_p3;
input        [18:0]     iv_addr_ffi_p3;
input                   i_addr_fixed_ffi_p3;
input        [31:0]     iv_rdata_ffi_p3;
//from dex_p3 
input                   i_wr_frm        ;
input        [18:0]     iv_addr_frm     ;
input                   i_addr_fixed_frm;
input        [31:0]     iv_rdata_frm    ;
//from ctx_p3           
input                   i_wr_tic        ;
input        [18:0]     iv_addr_tic     ;
input                   i_addr_fixed_tic;
input        [31:0]     iv_rdata_tic    ;

//from cdc_p3 
input                   i_wr_cdc_p3;
input        [18:0]     iv_addr_cdc_p3;
input                   i_addr_fixed_cdc_p3;
input        [31:0]     iv_rdata_cdc_p3;
//from grm 
input                   i_wr_grm;
input        [18:0]     iv_addr_grm;
input                   i_addr_fixed_grm;
input        [31:0]     iv_rdata_grm;
//from pcb 
input                   i_wr_pcb;
input        [18:0]     iv_addr_pcb;
input                   i_addr_fixed_pcb;
input        [31:0]     iv_rdata_pcb;
//from qgc 
input                   i_wr_qgc0;
input        [18:0]     iv_addr_qgc0;
input                   i_addr_fixed_qgc0;
input        [31:0]     iv_rdata_qgc0;

input                   i_wr_qgc1;
input        [18:0]     iv_addr_qgc1;
input                   i_addr_fixed_qgc1;
input        [31:0]     iv_rdata_qgc1;

input                   i_wr_qgc2;
input        [18:0]     iv_addr_qgc2;
input                   i_addr_fixed_qgc2;
input        [31:0]     iv_rdata_qgc2;

input                   i_wr_fim        ;
input        [18:0]     iv_addr_fim     ;
input                   i_addr_fixed_fim;
input        [31:0]     iv_rdata_fim    ;

input                   i_wr_cfu;
input        [18:0]     iv_addr_cfu;
input                   i_addr_fixed_cfu;
input        [31:0]     iv_rdata_cfu;
 
output                  o_command_ack_wr;
output       [63:0]     ov_command_ack; 
tse_command_parse tse_command_parse(
.i_clk        (i_clk       ),
.i_rst_n      (i_rst_n     ),

.iv_command   (iv_command  ),   
.i_command_wr (i_command_wr),           

.ov_addr      (ov_addr     ),
.ov_wdata     (ov_wdata    ),
.o_addr_fixed (o_addr_fixed),

.o_wr_ffi_p8  (o_wr_ffi_p8  ),
.o_rd_ffi_p8  (o_rd_ffi_p8  ),
.o_wr_dex_p8  (o_wr_dex_p8  ),
.o_rd_dex_p8  (o_rd_dex_p8  ),

.o_wr_ffi_p0  (o_wr_ffi_p0  ),
.o_rd_ffi_p0  (o_rd_ffi_p0  ),
.o_wr_dex_p0  (o_wr_dex_p0  ),
.o_rd_dex_p0  (o_rd_dex_p0  ),

.o_wr_ffi_p1  (o_wr_ffi_p1  ),
.o_rd_ffi_p1  (o_rd_ffi_p1  ),
.o_wr_dex_p1  (o_wr_dex_p1  ),
.o_rd_dex_p1  (o_rd_dex_p1  ),

.o_wr_ffi_p2  (o_wr_ffi_p2  ),
.o_rd_ffi_p2  (o_rd_ffi_p2  ),
.o_wr_dex_p2  (o_wr_dex_p2  ),
.o_rd_dex_p2  (o_rd_dex_p2  ),

.o_wr_ffi_p3  (o_wr_ffi_p3  ),
.o_rd_ffi_p3  (o_rd_ffi_p3  ),
.o_wr_frm     (o_wr_frm ),
.o_rd_frm     (o_rd_frm ),
.o_wr_tic     (o_wr_tic ),
.o_rd_tic     (o_rd_tic ),

.o_wr_grm     (o_wr_grm     ),
.o_rd_grm     (o_rd_grm     ),

.o_wr_pcb     (o_wr_pcb     ),
.o_rd_pcb     (o_rd_pcb     ),

.o_wr_qgc0    (o_wr_qgc0    ),
.o_rd_qgc0    (o_rd_qgc0    ),

.o_wr_qgc1    (o_wr_qgc1    ),
.o_rd_qgc1    (o_rd_qgc1    ),

.o_wr_qgc2    (o_wr_qgc2    ),
.o_rd_qgc2    (o_rd_qgc2    ),

.o_wr_fim     (o_wr_fim    ),
.o_rd_fim     (o_rd_fim    )
); 
tse_commandack_generate tse_commandack_generate_inst(
.i_clk(i_clk),
.i_rst_n(i_rst_n),          

.o_command_ack_wr                           (o_command_ack_wr),
.ov_command_ack                             (ov_command_ack),

.i_wr_ffi_p8                                (i_wr_ffi_p8             ),
.iv_addr_ffi_p8                             (iv_addr_ffi_p8          ),
.i_addr_fixed_ffi_p8                        (i_addr_fixed_ffi_p8     ),
.iv_rdata_ffi_p8                            (iv_rdata_ffi_p8         ),

.i_wr_dex_p8                                (i_wr_dex_p8             ),
.iv_addr_dex_p8                             (iv_addr_dex_p8          ),
.i_addr_fixed_dex_p8                        (i_addr_fixed_dex_p8     ),
.iv_rdata_dex_p8                            (iv_rdata_dex_p8         ),

.i_wr_ctx_p8                                (i_wr_ctx_p8             ),
.iv_addr_ctx_p8                             (iv_addr_ctx_p8          ),
.i_addr_fixed_ctx_p8                        (i_addr_fixed_ctx_p8     ),
.iv_rdata_ctx_p8                            (iv_rdata_ctx_p8         ),

.i_wr_ffi_p0                                (i_wr_ffi_p0             ),
.iv_addr_ffi_p0                             (iv_addr_ffi_p0          ),
.i_addr_fixed_ffi_p0                        (i_addr_fixed_ffi_p0     ),
.iv_rdata_ffi_p0                            (iv_rdata_ffi_p0         ),

.i_wr_dex_p0                                (i_wr_dex_p0             ),
.iv_addr_dex_p0                             (iv_addr_dex_p0          ),
.i_addr_fixed_dex_p0                        (i_addr_fixed_dex_p0     ),
.iv_rdata_dex_p0                            (iv_rdata_dex_p0         ),

.i_wr_ctx_p0                                (i_wr_ctx_p0             ),
.iv_addr_ctx_p0                             (iv_addr_ctx_p0          ),
.i_addr_fixed_ctx_p0                        (i_addr_fixed_ctx_p0     ),
.iv_rdata_ctx_p0                            (iv_rdata_ctx_p0         ),

.i_wr_ffi_p1                                (i_wr_ffi_p1             ),
.iv_addr_ffi_p1                             (iv_addr_ffi_p1          ),
.i_addr_fixed_ffi_p1                        (i_addr_fixed_ffi_p1     ),
.iv_rdata_ffi_p1                            (iv_rdata_ffi_p1         ),

.i_wr_dex_p1                                (i_wr_dex_p1             ),
.iv_addr_dex_p1                             (iv_addr_dex_p1          ),
.i_addr_fixed_dex_p1                        (i_addr_fixed_dex_p1     ),
.iv_rdata_dex_p1                            (iv_rdata_dex_p1         ),

.i_wr_ctx_p1                                (i_wr_ctx_p1             ),
.iv_addr_ctx_p1                             (iv_addr_ctx_p1          ),
.i_addr_fixed_ctx_p1                        (i_addr_fixed_ctx_p1     ),
.iv_rdata_ctx_p1                            (iv_rdata_ctx_p1         ),

.i_wr_ffi_p2                                (i_wr_ffi_p2             ),
.iv_addr_ffi_p2                             (iv_addr_ffi_p2          ),
.i_addr_fixed_ffi_p2                        (i_addr_fixed_ffi_p2     ),
.iv_rdata_ffi_p2                            (iv_rdata_ffi_p2         ),

.i_wr_dex_p2                                (i_wr_dex_p2             ),
.iv_addr_dex_p2                             (iv_addr_dex_p2          ),
.i_addr_fixed_dex_p2                        (i_addr_fixed_dex_p2     ),
.iv_rdata_dex_p2                            (iv_rdata_dex_p2         ),

.i_wr_ctx_p2                                (i_wr_ctx_p2             ),
.iv_addr_ctx_p2                             (iv_addr_ctx_p2          ),
.i_addr_fixed_ctx_p2                        (i_addr_fixed_ctx_p2     ),
.iv_rdata_ctx_p2                            (iv_rdata_ctx_p2         ),

.i_wr_ffi_p3                                (i_wr_ffi_p3             ),
.iv_addr_ffi_p3                             (iv_addr_ffi_p3          ),
.i_addr_fixed_ffi_p3                        (i_addr_fixed_ffi_p3     ),
.iv_rdata_ffi_p3                            (iv_rdata_ffi_p3         ),

.i_wr_frm                                   (i_wr_frm            ),
.iv_addr_frm                                (iv_addr_frm         ),
.i_addr_fixed_frm                           (i_addr_fixed_frm    ),
.iv_rdata_frm                               (iv_rdata_frm        ),
                                             
.i_wr_tic                                   (i_wr_tic            ),
.iv_addr_tic                                (iv_addr_tic         ),
.i_addr_fixed_tic                           (i_addr_fixed_tic    ),
.iv_rdata_tic                               (iv_rdata_tic        ),

.i_wr_grm                                   (i_wr_grm                ),
.iv_addr_grm                                (iv_addr_grm             ),
.i_addr_fixed_grm                           (i_addr_fixed_grm        ),
.iv_rdata_grm                               (iv_rdata_grm            ),

.i_wr_pcb                                   (i_wr_pcb                ),
.iv_addr_pcb                                (iv_addr_pcb             ),
.i_addr_fixed_pcb                           (i_addr_fixed_pcb        ),
.iv_rdata_pcb                               (iv_rdata_pcb            ),

.i_wr_qgc0                                  (i_wr_qgc0               ),
.iv_addr_qgc0                               (iv_addr_qgc0            ),
.i_addr_fixed_qgc0                          (i_addr_fixed_qgc0       ),
.iv_rdata_qgc0                              (iv_rdata_qgc0           ),

.i_wr_qgc1                                  (i_wr_qgc1               ),
.iv_addr_qgc1                               (iv_addr_qgc1            ),
.i_addr_fixed_qgc1                          (i_addr_fixed_qgc1       ),
.iv_rdata_qgc1                              (iv_rdata_qgc1           ),

.i_wr_qgc2                                  (i_wr_qgc2               ),
.iv_addr_qgc2                               (iv_addr_qgc2            ),
.i_addr_fixed_qgc2                          (i_addr_fixed_qgc2       ),
.iv_rdata_qgc2                              (iv_rdata_qgc2           ),

.i_wr_fim                                   (i_wr_fim                ),
.iv_addr_fim                                (iv_addr_fim             ),
.i_addr_fixed_fim                           (i_addr_fixed_fim        ),
.iv_rdata_fim                               (iv_rdata_fim            )
);    
endmodule