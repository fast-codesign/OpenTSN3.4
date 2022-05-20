// Copyright (C) 1953-2020 NUDT
// Verilog module name - queue_gate_control 
// Version: QGC_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         use RAM to cahce the gate control list
//         time slot are calculated according to the global clock
//         read the gate control vector according to the time slot 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module queue_gate_control
(
       i_clk                 ,
       i_rst_n               ,
        
       iv_syn_clk  ,
       
       iv_addr               ,    
       iv_wdata              ,   
       i_addr_fixed          ,
                             ,
       i_wr                  ,       
       i_rd                  , 
       o_wr                  ,
       ov_addr               ,
       o_addr_fixed          ,
       ov_rdata              ,        

       i_qbv_or_qch          ,
       iv_time_slot_length   ,
       iv_schedule_period    ,
       
       ov_in_gate_ctrl_vector,
       ov_out_gate_ctrl_vector
);

// I/O
// clk & rst
input                   i_clk               ;//125Mhz
input                   i_rst_n             ;
                        
input     [63:0]        iv_syn_clk;
                        
input     [18:0]        iv_addr             ;       
input     [31:0]        iv_wdata            ;      
input                   i_addr_fixed        ;   
                                            
input                   i_wr                ;       
input                   i_rd                ; 
output                  o_wr                ;
output    [18:0]        ov_addr             ;
output                  o_addr_fixed        ;
output    [31:0]        ov_rdata            ;   
                        
input                   i_qbv_or_qch        ;
input     [10:0]        iv_time_slot_length ; 
input     [10:0]        iv_schedule_period  ; 
// gate control vector to network_input_queueand network_output_schedule
output     [1:0]       ov_in_gate_ctrl_vector; 
output     [7:0]       ov_out_gate_ctrl_vector; 
// out_RAM form/to gate_control
wire       [7:0]       wv_ram_rdata_b;
wire       [9:0]       wv_ram_raddr_b;
wire                   w_ram_rd_b;

wire      [9:0]        wv_ram_addr_rwp2ram; 
wire      [7:0]        wv_ram_wdata_rwp2ram;
wire                   w_ram_wr_rwp2ram;    
wire      [7:0]        wv_ram_rdata_ram2rwp;
wire                   w_ram_rd_rwp2ram;

wire      [9:0]        wv_time_slot; 
wire                   w_time_slot_switch; 
command_parse_and_encapsulate_qgc command_parse_and_encapsulate_qgc_inst
(
.i_clk                            (i_clk                ),
.i_rst_n                          (i_rst_n              ),

.iv_addr                          (iv_addr              ),                         
.i_addr_fixed                     (i_addr_fixed         ),                   
.iv_wdata                         (iv_wdata             ),                        
.i_wr                             (i_wr                 ),         
.i_rd                             (i_rd                 ),        

.o_wr                             (o_wr                 ),         
.ov_addr                          (ov_addr              ),       
.o_addr_fixed                     (o_addr_fixed         ), 
.ov_rdata                         (ov_rdata             ),

.ov_ram_addr                      (wv_ram_addr_rwp2ram   ),
.ov_ram_wdata                     (wv_ram_wdata_rwp2ram  ),
.o_ram_wr                         (w_ram_wr_rwp2ram      ),
.iv_ram_rdata                     (wv_ram_rdata_ram2rwp  ),
.o_ram_rd                         (w_ram_rd_rwp2ram      )
);
time_slot_calculation time_slot_calculation_inst
(
.i_clk(i_clk),
.i_rst_n(i_rst_n),

.iv_syn_clk(iv_syn_clk),
.iv_time_slot_length(iv_time_slot_length),
.iv_slot_period(iv_schedule_period),

.ov_time_slot      (wv_time_slot),
.o_time_slot_switch(w_time_slot_switch)       
);
  
gate_control gate_control_inst(           
.i_clk                  (i_clk),
.i_rst_n                (i_rst_n),
                      
.ov_in_gate_ctrl_vector (ov_in_gate_ctrl_vector),
.ov_out_gate_ctrl_vector(ov_out_gate_ctrl_vector),
 
.iv_ram_rdata           (wv_ram_rdata_b),
.ov_ram_raddr           (wv_ram_raddr_b),
.o_ram_rd               (w_ram_rd_b),
    
.i_qbv_or_qch           (i_qbv_or_qch),
.iv_time_slot           (wv_time_slot),
.i_time_slot_switch     (w_time_slot_switch)
);

suhddpsram1024x8_rq out_ram_inst(
.aclr                  (!i_rst_n),
                     
.address_a             (wv_ram_addr_rwp2ram),
.address_b             (wv_ram_raddr_b),
                      
.clock                 (i_clk),
                       
.data_a                (wv_ram_wdata_rwp2ram),
.data_b                (8'h0),
                      
.rden_a                (w_ram_rd_rwp2ram),
.rden_b                (w_ram_rd_b),
                     
.wren_a                (w_ram_wr_rwp2ram),
.wren_b                (1'b0),
                       
.q_a                   (wv_ram_rdata_ram2rwp),
.q_b                   (wv_ram_rdata_b)
);
endmodule