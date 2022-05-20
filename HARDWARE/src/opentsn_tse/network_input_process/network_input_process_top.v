// Copyright (C) 1953-2021 NUDT
// Verilog module name - network_input_process_top  
// Version: V3.3.0.20211130
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         Network input process top module
//         include 3 GMII network interface
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module network_input_process_top  
    (
        i_clk,
        i_rst_n,
        
        i_gmii_dv_p0,
        iv_gmii_rxd_p0,

        i_gmii_dv_p1,
        iv_gmii_rxd_p1,

        iv_addr,                          
        i_addr_fixed,                    
        iv_wdata,                         
        i_wr_isc_p0,          
        i_rd_isc_p0,          
        i_wr_dex_p0,                         
        i_rd_dex_p0,                         
        
        o_wr_isc_p0,          
        ov_addr_isc_p0,       
        o_addr_fixed_isc_p0,  
        ov_rdata_isc_p0, 

        o_wr_dex_p0,          
        ov_addr_dex_p0,       
        o_addr_fixed_dex_p0,  
        ov_rdata_dex_p0,  

        i_wr_isc_p1,          
        i_rd_isc_p1,          
        i_wr_dex_p1,                         
        i_rd_dex_p1,                         
        
        o_wr_isc_p1,          
        ov_addr_isc_p1,       
        o_addr_fixed_isc_p1,  
        ov_rdata_isc_p1, 

        o_wr_dex_p1,          
        ov_addr_dex_p1,       
        o_addr_fixed_dex_p1,  
        ov_rdata_dex_p1,  
        
        i_hardware_initial_finish,
        i_rc_rxenable        ,  
        i_st_rxenable        ,
        //network interface port 1 receive pkt buffer id signal 
        i_pkt_bufid_wr_p0,
        iv_pkt_bufid_p0,
        o_pkt_bufid_ack_p0,
        //network interface port 2 receive pkt buffer id signal         
        i_pkt_bufid_wr_p1,
        iv_pkt_bufid_p1,
        o_pkt_bufid_ack_p1,          
        //network interface port 1 send descriptor signal
        o_descriptor_wr_p0tohost,
        o_descriptor_wr_p0tonetwork,
        ov_descriptor_p0,
        o_inverse_map_lookup_flag_p0,	///	
        i_descriptor_ack_hosttop0,
        i_descriptor_ack_networktop0,
        //network interface port 2 send descriptor signal           
        o_descriptor_wr_p1tohost,
        o_descriptor_wr_p1tohcp,
        ov_descriptor_p1,
        o_inverse_map_lookup_flag_p1,
        i_descriptor_ack_hosttop1,
        i_descriptor_ack_hcptop1,        
        
        //network interface port 1 send 134bits pkt signal
        ov_pkt_p0,
        o_pkt_wr_p0,
        ov_pkt_bufadd_p0,
        i_pkt_ack_p0,
        //network interface port 2 send 134bits pkt signal
        ov_pkt_p1,
        o_pkt_wr_p1,
        ov_pkt_bufadd_p1,
        i_pkt_ack_p1,   
        
        iv_free_bufid_num,
        iv_hpriority_be_threshold_value,
        iv_rc_threshold_value,
        iv_lpriority_be_threshold_value,
        
        o_port0_inpkt_pulse,          
        o_port0_discard_pkt_pulse,
        o_port1_inpkt_pulse,            
        o_port1_discard_pkt_pulse,           

        o_fifo_underflow_pulse_p0,
        o_fifo_overflow_pulse_p0, 
        o_fifo_underflow_pulse_p1,
        o_fifo_overflow_pulse_p1, 
           
        o_gmii_fifo_full_p0,            
        o_gmii_fifo_empty_p0,           
        
        o_gmii_fifo_full_p1,            
        o_gmii_fifo_empty_p1  
    );

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;

                                                                   
input                   i_gmii_dv_p0;                              
input       [7:0]       iv_gmii_rxd_p0;                            
input                   i_gmii_dv_p1;                              
input       [7:0]       iv_gmii_rxd_p1;                    
                                                             
input       [18:0]      iv_addr;                             
input                   i_addr_fixed;                        
input       [31:0]      iv_wdata;                          
input                   i_wr_isc_p0;                          
input                   i_rd_isc_p0;                        
input                   i_wr_dex_p0;                        
input                   i_rd_dex_p0;                        
                                                           
output                  o_wr_isc_p0        ;                 
output     [18:0]       ov_addr_isc_p0     ;                
output                  o_addr_fixed_isc_p0;                
output     [31:0]       ov_rdata_isc_p0    ;             
                                                          
output                  o_wr_dex_p0        ;             
output     [18:0]       ov_addr_dex_p0     ;                  
output                  o_addr_fixed_dex_p0;                  
output     [31:0]       ov_rdata_dex_p0    ;   

input                   i_wr_isc_p1;       
input                   i_rd_isc_p1;       
input                   i_wr_dex_p1;          
input                   i_rd_dex_p1;         
                              
output                  o_wr_isc_p1;     
output     [18:0]       ov_addr_isc_p1;  
output                  o_addr_fixed_isc_p1;
output     [31:0]       ov_rdata_isc_p1;
                          
output                  o_wr_dex_p1;         
output     [18:0]       ov_addr_dex_p1;      
output                  o_addr_fixed_dex_p1; 
output     [31:0]       ov_rdata_dex_p1;  
                                    
input                   i_hardware_initial_finish;                     
input                   i_rc_rxenable                   ;
input                   i_st_rxenable                   ;              
//pkt bufid input                                         
input                   i_pkt_bufid_wr_p0;                
input       [8:0]       iv_pkt_bufid_p0;                 
output                  o_pkt_bufid_ack_p0;
input                   i_pkt_bufid_wr_p1;
input       [8:0]       iv_pkt_bufid_p1;
output                  o_pkt_bufid_ack_p1;
//descriptor output
output                  o_descriptor_wr_p0tohost;
output                  o_descriptor_wr_p0tonetwork;
output      [39:0]      ov_descriptor_p0;
output                  o_inverse_map_lookup_flag_p0;///
input                   i_descriptor_ack_hosttop0;
input                   i_descriptor_ack_networktop0;
output                  o_descriptor_wr_p1tohost;
output                  o_descriptor_wr_p1tohcp;
output      [39:0]      ov_descriptor_p1;
output                  o_inverse_map_lookup_flag_p1;
input                   i_descriptor_ack_hosttop1;
input                   i_descriptor_ack_hcptop1;
//user data output
output      [133:0]     ov_pkt_p0;
output                  o_pkt_wr_p0;
output      [15:0]      ov_pkt_bufadd_p0;
input                   i_pkt_ack_p0; 
output      [133:0]     ov_pkt_p1;
output                  o_pkt_wr_p1;
output      [15:0]      ov_pkt_bufadd_p1;
input                   i_pkt_ack_p1; 

input       [8:0]       iv_free_bufid_num;
input        [8:0]      iv_hpriority_be_threshold_value;
input        [8:0]      iv_rc_threshold_value;
input        [8:0]      iv_lpriority_be_threshold_value;

output                  o_port0_inpkt_pulse;            
output                  o_port0_discard_pkt_pulse;      
output                  o_port1_inpkt_pulse;            
output                  o_port1_discard_pkt_pulse;       

output                  o_fifo_underflow_pulse_p0;
output                  o_fifo_overflow_pulse_p0; 
output                  o_fifo_underflow_pulse_p1;
output                  o_fifo_overflow_pulse_p1; 
      
output                  o_gmii_fifo_full_p0;            
output                  o_gmii_fifo_empty_p0;           
         
output                  o_gmii_fifo_full_p1;            
output                  o_gmii_fifo_empty_p1;           

wire                    i_descriptor_ack_p0;
wire                    i_descriptor_ack_p1;

assign    i_descriptor_ack_p0 = i_descriptor_ack_hosttop0 || i_descriptor_ack_networktop0;
assign    i_descriptor_ack_p1 = i_descriptor_ack_hosttop1 || i_descriptor_ack_hcptop1;
network_input_process #(.inport(4'b0000),.from_hcp_or_scp(2'b01)) network_input_process_connecting_with_hcp//the network port connect with hcp
    (
        .i_clk                    (i_clk            ),
        .i_rst_n                  (i_rst_n          ),        

        .i_gmii_rx_dv             (i_gmii_dv_p0     ),
        .iv_gmii_rxd              (iv_gmii_rxd_p0   ),

        .iv_addr                  (iv_addr          ),                         
        .i_addr_fixed             (i_addr_fixed     ),                   
        .iv_wdata                 (iv_wdata         ),                        
        .i_wr_isc                 (i_wr_isc_p0         ),         
        .i_rd_isc                 (i_rd_isc_p0         ),         
        .i_wr_dex                 (i_wr_dex_p0         ),                        
        .i_rd_dex                 (i_rd_dex_p0         ), 
                                                                                  
        .o_wr_isc                 (o_wr_isc_p0         ),         
        .ov_addr_isc              (ov_addr_isc_p0      ),      
        .o_addr_fixed_isc         (o_addr_fixed_isc_p0 ), 
        .ov_rdata_isc             (ov_rdata_isc_p0     ), 
                                                      
        .o_wr_dex                 (o_wr_dex_p0         ),                     
        .ov_addr_dex              (ov_addr_dex_p0      ),                  
        .o_addr_fixed_dex         (o_addr_fixed_dex_p0 ),             
        .ov_rdata_dex             (ov_rdata_dex_p0     ),                 

        .i_hardware_initial_finish      (i_hardware_initial_finish       ),
        .i_rc_rxenable                   (i_rc_rxenable                 ),
        .i_st_rxenable                   (i_st_rxenable                 ),
        
        .i_pkt_bufid_wr                 (i_pkt_bufid_wr_p0               ),
        .iv_pkt_bufid                   (iv_pkt_bufid_p0                 ),
        .o_pkt_bufid_ack                (o_pkt_bufid_ack_p0              ),

        .o_descriptor_wr_to_host        (o_descriptor_wr_p0tohost        ),
        .o_descriptor_wr_to_hcp         (),
        .o_descriptor_wr_to_network     (o_descriptor_wr_p0tonetwork     ),  
        .ov_descriptor                  (ov_descriptor_p0                ),
        .o_inverse_map_lookup_flag      (o_inverse_map_lookup_flag_p0    ),		
        .i_descriptor_ack               (i_descriptor_ack_p0             ),

        .ov_pkt                         (ov_pkt_p0                       ),
        .o_pkt_wr                       (o_pkt_wr_p0                     ),
        .ov_pkt_bufadd                  (ov_pkt_bufadd_p0                ),
        .i_pkt_ack                      (i_pkt_ack_p0                    ),
                                                                         
        .iv_free_bufid_num              (iv_free_bufid_num      ),
        .iv_hpriority_be_threshold_value(iv_hpriority_be_threshold_value ),
        .iv_rc_threshold_value          (iv_rc_threshold_value           ),
        .iv_lpriority_be_threshold_value(iv_lpriority_be_threshold_value ),
                                                                           
        .o_inpkt_pulse                  (o_port0_inpkt_pulse             ),              
        .o_discard_pkt_pulse            (o_port0_discard_pkt_pulse       ),
        .o_fifo_underflow_pulse         (o_fifo_underflow_pulse_p0       ),
        .o_fifo_overflow_pulse          (o_fifo_overflow_pulse_p0        ),
                                                                         
        .o_gmii_fifo_full               (o_gmii_fifo_full_p0             ),            
        .o_gmii_fifo_empty              (o_gmii_fifo_empty_p0            )
    );
    
network_input_process #(.inport(4'b0001),.from_hcp_or_scp(2'b10)) network_input_process_connecting_with_scp//the network port connect with scp
    (
        .i_clk                  (i_clk          ),
        .i_rst_n                (i_rst_n        ),

        .i_gmii_rx_dv           (i_gmii_dv_p1   ),
        .iv_gmii_rxd            (iv_gmii_rxd_p1 ),
        
        .iv_addr                (iv_addr        ),                         
        .i_addr_fixed           (i_addr_fixed   ),                   
        .iv_wdata               (iv_wdata       ),                        
        .i_wr_isc               (i_wr_isc_p1    ),         
        .i_rd_isc               (i_rd_isc_p1    ),         
        .i_wr_dex               (i_wr_dex_p1    ),                        
        .i_rd_dex               (i_rd_dex_p1    ), 
                                                             
        .o_wr_isc               (o_wr_isc_p1        ),         
        .ov_addr_isc            (ov_addr_isc_p1     ),      
        .o_addr_fixed_isc       (o_addr_fixed_isc_p1), 
        .ov_rdata_isc           (ov_rdata_isc_p1    ), 
                                                                        
        .o_wr_dex               (o_wr_dex_p1         ),                     
        .ov_addr_dex            (ov_addr_dex_p1      ),                  
        .o_addr_fixed_dex       (o_addr_fixed_dex_p1 ),             
        .ov_rdata_dex           (ov_rdata_dex_p1     ), 
                                                                    
        .i_hardware_initial_finish   (i_hardware_initial_finish     ),
        .i_rc_rxenable                   (i_rc_rxenable                 ),
        .i_st_rxenable                   (i_st_rxenable                 ),      
                                                                    
        .i_pkt_bufid_wr              (i_pkt_bufid_wr_p1             ),
        .iv_pkt_bufid                (iv_pkt_bufid_p1               ),
        .o_pkt_bufid_ack             (o_pkt_bufid_ack_p1            ),
                                                                    
        .o_descriptor_wr_to_host     (o_descriptor_wr_p1tohost      ),
        .o_descriptor_wr_to_hcp      (o_descriptor_wr_p1tohcp       ),
        .o_descriptor_wr_to_network  (                              ),  
        .ov_descriptor               (ov_descriptor_p1              ),
        .o_inverse_map_lookup_flag   (o_inverse_map_lookup_flag_p1  ),		
        .i_descriptor_ack            (i_descriptor_ack_p1           ),
                                                                    
        .ov_pkt                      (ov_pkt_p1                     ),
        .o_pkt_wr                    (o_pkt_wr_p1                   ),
        .ov_pkt_bufadd               (ov_pkt_bufadd_p1              ),
        .i_pkt_ack                   (i_pkt_ack_p1                  ),
        
        .iv_free_bufid_num               (iv_free_bufid_num              ),
        .iv_hpriority_be_threshold_value (iv_hpriority_be_threshold_value),
        .iv_rc_threshold_value           (iv_rc_threshold_value          ),
        .iv_lpriority_be_threshold_value (iv_lpriority_be_threshold_value),
        
        .o_inpkt_pulse                   (o_port1_inpkt_pulse           ),              
        .o_discard_pkt_pulse             (o_port1_discard_pkt_pulse     ),
        .o_fifo_underflow_pulse          (o_fifo_underflow_pulse_p1     ),
        .o_fifo_overflow_pulse           (o_fifo_overflow_pulse_p1      ),        
                                                                        
        .o_gmii_fifo_full                (o_gmii_fifo_full_p1           ),            
        .o_gmii_fifo_empty               (o_gmii_fifo_empty_p1          )
    );
endmodule