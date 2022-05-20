// Copyright (C) 1953-2020 NUDT
// Verilog module name - configurable_topology_control 
// Version: configurable_topology_control_V1.0
// Created:
//         by - Jintao Peng
//         at - 06.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         control of configurable topology 
///////////////////////////////////////////////////////////////////////////
`timescale 1ns/1ps

module configurable_topology_control
(
       i_clk0,
	   i_clk1,
	   i_clk2,
       i_clk3,
	   i_clk4,
	   i_clk5,       
       i_rst_n,
    
//TSN_SW1 
	   i_gmii_rx_clk_p0_chip0,
	   i_gmii_rx_dv_p0_chip0,
	   iv_gmii_rxd_p0_chip0,
	   i_gmii_rx_er_p0_chip0,
	   
	   i_gmii_rx_clk_p1_chip0,
	   i_gmii_rx_dv_p1_chip0,
	   iv_gmii_rxd_p1_chip0,
	   i_gmii_rx_er_p1_chip0,
	   
	   i_gmii_tx_in_clk_p0_chip0,
	   ov_gmii_txd_p0_chip0,
	   o_gmii_tx_en_p0_chip0,
	   o_gmii_tx_er_p0_chip0,
	   o_gmii_tx_out_clk_p0_chip0,
		
	   i_gmii_tx_in_clk_p1_chip0,
	   ov_gmii_txd_p1_chip0,
	   o_gmii_tx_en_p1_chip0,
	   o_gmii_tx_er_p1_chip0,
	   o_gmii_tx_out_clk_p1_chip0,
			                     
//TSN_SW2
	   i_gmii_rx_clk_p0_chip1,
	   i_gmii_rx_dv_p0_chip1,
	   iv_gmii_rxd_p0_chip1,
	   i_gmii_rx_er_p0_chip1,
	   
	   i_gmii_rx_clk_p1_chip1,
	   i_gmii_rx_dv_p1_chip1,
	   iv_gmii_rxd_p1_chip1,
	   i_gmii_rx_er_p1_chip1,
	   
	   i_gmii_tx_in_clk_p0_chip1,
	   ov_gmii_txd_p0_chip1,
	   o_gmii_tx_en_p0_chip1,
	   o_gmii_tx_er_p0_chip1,
	   o_gmii_tx_out_clk_p0_chip1,
	   
	   i_gmii_tx_in_clk_p1_chip1,
	   ov_gmii_txd_p1_chip1,
	   o_gmii_tx_en_p1_chip1,
	   o_gmii_tx_er_p1_chip1,
	   o_gmii_tx_out_clk_p1_chip1,	  
	   
//TSN_NIC1   
	   i_gmii_rx_clk_host_chip2,
	   i_gmii_rx_dv_host_chip2,
	   iv_gmii_rxd_host_chip2,
	   i_gmii_rx_er_host_chip2,	
		
       i_gmii_tx_in_clk_host_chip2,
	   ov_gmii_txd_host_chip2,
	   o_gmii_tx_en_host_chip2,
	   o_gmii_tx_er_host_chip2,
	   o_gmii_tx_out_clk_host_chip2,

//TSN_NIC2   
	   i_gmii_rx_clk_host_chip3,
	   i_gmii_rx_dv_host_chip3,
	   iv_gmii_rxd_host_chip3,
	   i_gmii_rx_er_host_chip3,	
		
       i_gmii_tx_in_clk_host_chip3,
	   ov_gmii_txd_host_chip3,
	   o_gmii_tx_en_host_chip3,
	   o_gmii_tx_er_host_chip3,
	   o_gmii_tx_out_clk_host_chip3,     

//TSN_NIC3   
	   i_gmii_rx_clk_host_chip4,
	   i_gmii_rx_dv_host_chip4,
	   iv_gmii_rxd_host_chip4,
	   i_gmii_rx_er_host_chip4,	
		
       i_gmii_tx_in_clk_host_chip4,
	   ov_gmii_txd_host_chip4,
	   o_gmii_tx_en_host_chip4,
	   o_gmii_tx_er_host_chip4,
	   o_gmii_tx_out_clk_host_chip4, 

//TSN_NIC4   
	   i_gmii_rx_clk_host_chip5,
	   i_gmii_rx_dv_host_chip5,
	   iv_gmii_rxd_host_chip5,
	   i_gmii_rx_er_host_chip5,	
		
       i_gmii_tx_in_clk_host_chip5,
	   ov_gmii_txd_host_chip5,
	   o_gmii_tx_en_host_chip5,
	   o_gmii_tx_er_host_chip5,
	   o_gmii_tx_out_clk_host_chip5       
       
);
input                   i_clk0;	
input                   i_clk1; 
input                   i_clk2;			
input                   i_clk3;	
input                   i_clk4; 
input                   i_clk5;		 
input                   i_rst_n;
//TSN_sw1	
input                   i_gmii_tx_in_clk_p0_chip0;
output      [7:0] 	    ov_gmii_txd_p0_chip0;
output      		    o_gmii_tx_en_p0_chip0;
output      		    o_gmii_tx_er_p0_chip0;
output      		    o_gmii_tx_out_clk_p0_chip0;

input                   i_gmii_tx_in_clk_p1_chip0;
output      [7:0] 	    ov_gmii_txd_p1_chip0;
output      		    o_gmii_tx_en_p1_chip0;
output      		    o_gmii_tx_er_p1_chip0;
output      		    o_gmii_tx_out_clk_p1_chip0;

input				    i_gmii_rx_clk_p0_chip0;
input					i_gmii_rx_dv_p0_chip0;
input		[7:0]		iv_gmii_rxd_p0_chip0;
input					i_gmii_rx_er_p0_chip0;

input				    i_gmii_rx_clk_p1_chip0;
input					i_gmii_rx_dv_p1_chip0;
input		[7:0]		iv_gmii_rxd_p1_chip0;
input					i_gmii_rx_er_p1_chip0;

//TSN_sw1	
input                   i_gmii_tx_in_clk_p0_chip1;
output      [7:0] 	    ov_gmii_txd_p0_chip1;
output      		    o_gmii_tx_en_p0_chip1;
output      		    o_gmii_tx_er_p0_chip1;
output      		    o_gmii_tx_out_clk_p0_chip1;

input                   i_gmii_tx_in_clk_p1_chip1;
output      [7:0] 	    ov_gmii_txd_p1_chip1;
output      		    o_gmii_tx_en_p1_chip1;
output      		    o_gmii_tx_er_p1_chip1;
output      		    o_gmii_tx_out_clk_p1_chip1;

input				    i_gmii_rx_clk_p0_chip1;
input					i_gmii_rx_dv_p0_chip1;
input		[7:0]		iv_gmii_rxd_p0_chip1;
input					i_gmii_rx_er_p0_chip1;

input				    i_gmii_rx_clk_p1_chip1;
input					i_gmii_rx_dv_p1_chip1;
input		[7:0]		iv_gmii_rxd_p1_chip1;
input					i_gmii_rx_er_p1_chip1;

//TSN_nic1	
input                   i_gmii_tx_in_clk_host_chip2;
output      [7:0] 	    ov_gmii_txd_host_chip2;
output      		    o_gmii_tx_en_host_chip2;
output      		    o_gmii_tx_er_host_chip2;
output      		    o_gmii_tx_out_clk_host_chip2;

input					i_gmii_rx_clk_host_chip2;
input					i_gmii_rx_dv_host_chip2;
input	    [7:0]		iv_gmii_rxd_host_chip2;
input					i_gmii_rx_er_host_chip2;

//TSN_nic2	
input                   i_gmii_tx_in_clk_host_chip3;
output      [7:0] 	    ov_gmii_txd_host_chip3;
output      		    o_gmii_tx_en_host_chip3;
output      		    o_gmii_tx_er_host_chip3;
output      		    o_gmii_tx_out_clk_host_chip3;

input					i_gmii_rx_clk_host_chip3;
input					i_gmii_rx_dv_host_chip3;
input	    [7:0]		iv_gmii_rxd_host_chip3;
input					i_gmii_rx_er_host_chip3;

//TSN_nic3	
input                   i_gmii_tx_in_clk_host_chip4;
output      [7:0] 	    ov_gmii_txd_host_chip4;
output      		    o_gmii_tx_en_host_chip4;
output      		    o_gmii_tx_er_host_chip4;
output      		    o_gmii_tx_out_clk_host_chip4;

input					i_gmii_rx_clk_host_chip4;
input					i_gmii_rx_dv_host_chip4;
input	    [7:0]		iv_gmii_rxd_host_chip4;
input					i_gmii_rx_er_host_chip4;

//TSN_nic4	
input                   i_gmii_tx_in_clk_host_chip5;
output      [7:0] 	    ov_gmii_txd_host_chip5;
output      		    o_gmii_tx_en_host_chip5;
output      		    o_gmii_tx_er_host_chip5;
output      		    o_gmii_tx_out_clk_host_chip5;

input					i_gmii_rx_clk_host_chip5;
input					i_gmii_rx_dv_host_chip5;
input	    [7:0]		iv_gmii_rxd_host_chip5;
input					i_gmii_rx_er_host_chip5;

//TSN_switsh1_P0-TSNNic1
wire				    w_gmii_rx_clk_swp0_2_nic1;
wire				    w_gmii_rx_dv_swp0_2_nic1 ;
wire		[7:0]	    wv_gmii_rxd_swp0_2_nic1  ; 
wire				    w_gmii_rx_er_swp0_2_nic1 ;

wire        [7:0] 	    wv_gmii_txd_swp0_2_nic1  ;
wire      		        w_gmii_tx_en_swp0_2_nic1 ;
wire      		        w_gmii_tx_er_swp0_2_nic1 ;
wire      		        w_gmii_tx_out_swp0_2_nic1;
//TSN_switsh1_P1-TSNNic2
wire				    w_gmii_rx_clk_swp1_2_nic2;
wire				    w_gmii_rx_dv_swp1_2_nic2 ;
wire		[7:0]	    wv_gmii_rxd_swp1_2_nic2  ; 
wire				    w_gmii_rx_er_swp1_2_nic2 ;

wire        [7:0] 	    wv_gmii_txd_swp1_2_nic2  ;
wire      		        w_gmii_tx_en_swp1_2_nic2 ;
wire      		        w_gmii_tx_er_swp1_2_nic2 ;
wire      		        w_gmii_tx_out_swp1_2_nic2;

//TSN_switsh2_P0-TSNNic3
wire				    w_gmii_rx_clk_swp0_2_nic3;
wire				    w_gmii_rx_dv_swp0_2_nic3 ;
wire		[7:0]	    wv_gmii_rxd_swp0_2_nic3  ; 
wire				    w_gmii_rx_er_swp0_2_nic3 ;

wire        [7:0] 	    wv_gmii_txd_swp0_2_nic3  ;
wire      		        w_gmii_tx_en_swp0_2_nic3 ;
wire      		        w_gmii_tx_er_swp0_2_nic3 ;
wire      		        w_gmii_tx_out_swp0_2_nic3;
//TSN_switsh2_P1-TSNNic4
wire				    w_gmii_rx_clk_swp1_2_nic4;
wire				    w_gmii_rx_dv_swp1_2_nic4 ;
wire		[7:0]	    wv_gmii_rxd_swp1_2_nic4  ; 
wire				    w_gmii_rx_er_swp1_2_nic4 ;

wire        [7:0] 	    wv_gmii_txd_swp1_2_nic4  ;
wire      		        w_gmii_tx_en_swp1_2_nic4 ;
wire      		        w_gmii_tx_er_swp1_2_nic4 ;
wire      		        w_gmii_tx_out_swp1_2_nic4;

//TSN_switsh2_P3-TSN_switsh1_P3
wire				    w_gmii_rx_clk_swp3_2_swp3;
wire				    w_gmii_rx_dv_swp3_2_swp3 ;
wire		[7:0]	    wv_gmii_rxd_swp3_2_swp3  ; 
wire				    w_gmii_rx_er_swp3_2_swp3 ;

wire        [7:0] 	    wv_gmii_txd_swp3_2_swp3  ;
wire      		        w_gmii_tx_en_swp3_2_swp3 ;
wire      		        w_gmii_tx_er_swp3_2_swp3 ;
wire      		        w_gmii_tx_out_swp3_2_swp3;

	   
tsnswitch tsnswitch_inst1(
.i_clk		        (i_clk0),
.i_hard_rst_n		(i_rst_n),                          
.i_button_rst_n		(i_rst_n),                          
.i_et_resetc_rst_n	(i_rst_n),  

.i_gmii_rxclk_p0	(w_gmii_rx_clk_swp0_2_nic1),
.i_gmii_dv_p0		(w_gmii_rx_dv_swp0_2_nic1 ),      
.iv_gmii_rxd_p0		(wv_gmii_rxd_swp0_2_nic1  ),       
.i_gmii_er_p0		(w_gmii_rx_er_swp0_2_nic1 ),                        
                                                        
.ov_gmii_txd_p0		(wv_gmii_txd_swp0_2_nic1  ),             
.o_gmii_tx_en_p0	(w_gmii_tx_en_swp0_2_nic1 ),                                 
.o_gmii_tx_er_p0	(w_gmii_tx_er_swp0_2_nic1 ),           
.o_gmii_tx_clk_p0	(w_gmii_tx_out_swp0_2_nic1),      
                                                       
.i_gmii_rxclk_p1	(w_gmii_rx_clk_swp1_2_nic2),//      
.i_gmii_dv_p1		(w_gmii_rx_dv_swp1_2_nic2 ),      
.iv_gmii_rxd_p1		(wv_gmii_rxd_swp1_2_nic2  ),       
.i_gmii_er_p1		(w_gmii_rx_er_swp1_2_nic2 ),  
                     
.ov_gmii_txd_p1		(wv_gmii_txd_swp1_2_nic2  ),       
.o_gmii_tx_en_p1	(w_gmii_tx_en_swp1_2_nic2 ),       
.o_gmii_tx_er_p1	(w_gmii_tx_er_swp1_2_nic2 ),       
.o_gmii_tx_clk_p1	(w_gmii_tx_out_swp1_2_nic2),

.i_gmii_rxclk_p2	(i_gmii_rx_clk_p0_chip0     ),
.i_gmii_dv_p2		(i_gmii_rx_dv_p0_chip0      ),      
.iv_gmii_rxd_p2		(iv_gmii_rxd_p0_chip0       ),       
.i_gmii_er_p2		(i_gmii_rx_er_p0_chip0      ),                        
                                                        
.ov_gmii_txd_p2		(ov_gmii_txd_p0_chip0		),             
.o_gmii_tx_en_p2	(o_gmii_tx_en_p0_chip0		),                                 
.o_gmii_tx_er_p2	(o_gmii_tx_er_p0_chip0		),           
.o_gmii_tx_clk_p2	(o_gmii_tx_out_clk_p0_chip0 ),      
                                                       
.i_gmii_rxclk_p3	( i_clk1 ),//      
.i_gmii_dv_p3		( w_gmii_rx_dv_swp3_2_swp3  ),      
.iv_gmii_rxd_p3		( wv_gmii_rxd_swp3_2_swp3   ),       
.i_gmii_er_p3		( w_gmii_rx_er_swp3_2_swp3  ),  
                     
.ov_gmii_txd_p3		( wv_gmii_txd_swp3_2_swp3    ),       
.o_gmii_tx_en_p3	( w_gmii_tx_en_swp3_2_swp3   ),       
.o_gmii_tx_er_p3	( w_gmii_tx_er_swp3_2_swp3   ),       
.o_gmii_tx_clk_p3	( w_gmii_tx_out_swp3_2_swp3  ),

.i_gmii_rxclk_from_cpu(i_gmii_rx_clk_p1_chip0    ), 
.i_gmii_rx_dv_from_cpu(i_gmii_rx_dv_p1_chip0     ), 
.iv_gmii_rxd_from_cpu (iv_gmii_rxd_p1_chip0      ), 
.i_gmii_rx_er_from_cpu(i_gmii_rx_er_p1_chip0     ),

.ov_gmii_txd_to_cpu   (ov_gmii_txd_p1_chip0       ), 
.o_gmii_tx_en_to_cpu  (o_gmii_tx_en_p1_chip0      ), 
.o_gmii_txclk_to_cpu  (o_gmii_tx_out_clk_p1_chip0 ), 
.o_gmii_tx_er_to_cpu  (o_gmii_tx_er_p1_chip0      )

);

tsnswitch tsnswitch_inst2(
.i_clk				(i_clk1),
.i_hard_rst_n		(i_rst_n),                          
.i_button_rst_n		(i_rst_n),                          
.i_et_resetc_rst_n	(i_rst_n),  

.i_gmii_rxclk_p0	(w_gmii_rx_clk_swp0_2_nic3 ),
.i_gmii_dv_p0		(w_gmii_rx_dv_swp0_2_nic3  ),      
.iv_gmii_rxd_p0		(wv_gmii_rxd_swp0_2_nic3   ),       
.i_gmii_er_p0		(w_gmii_rx_er_swp0_2_nic3  ),                        
                                                        
.ov_gmii_txd_p0		(wv_gmii_txd_swp0_2_nic3   ),             
.o_gmii_tx_en_p0	(w_gmii_tx_en_swp0_2_nic3  ),                                 
.o_gmii_tx_er_p0	(w_gmii_tx_er_swp0_2_nic3  ),           
.o_gmii_tx_clk_p0	(w_gmii_tx_out_swp0_2_nic3 ),      
                                                       
.i_gmii_rxclk_p1	(w_gmii_rx_clk_swp1_2_nic4 ),//      
.i_gmii_dv_p1		(w_gmii_rx_dv_swp1_2_nic4  ),      
.iv_gmii_rxd_p1		(wv_gmii_rxd_swp1_2_nic4   ),       
.i_gmii_er_p1		(w_gmii_rx_er_swp1_2_nic4  ),  
                     
.ov_gmii_txd_p1		(wv_gmii_txd_swp1_2_nic4    ),       
.o_gmii_tx_en_p1	(w_gmii_tx_en_swp1_2_nic4   ),       
.o_gmii_tx_er_p1	(w_gmii_tx_er_swp1_2_nic4   ),       
.o_gmii_tx_clk_p1	(w_gmii_tx_out_swp1_2_nic4  ),

.i_gmii_rxclk_p2	(i_gmii_rx_clk_p0_chip1     ),
.i_gmii_dv_p2		(i_gmii_rx_dv_p0_chip1      ),      
.iv_gmii_rxd_p2		(iv_gmii_rxd_p0_chip1       ),       
.i_gmii_er_p2		(i_gmii_rx_er_p0_chip1      ),                        
                                                                                  
.ov_gmii_txd_p2		(ov_gmii_txd_p0_chip1		 ),             
.o_gmii_tx_en_p2	(o_gmii_tx_en_p0_chip1		 ),                                 
.o_gmii_tx_er_p2	(o_gmii_tx_er_p0_chip1		 ),           
.o_gmii_tx_clk_p2	(o_gmii_tx_out_clk_p0_chip1 ),      
                                                       
.i_gmii_rxclk_p3	(w_gmii_tx_out_swp3_2_swp3), //       
.i_gmii_dv_p3		(w_gmii_tx_en_swp3_2_swp3 ),        
.iv_gmii_rxd_p3		(wv_gmii_txd_swp3_2_swp3  ),          
.i_gmii_er_p3		(w_gmii_tx_er_swp3_2_swp3 ),        
                              
.ov_gmii_txd_p3		(wv_gmii_rxd_swp3_2_swp3  ),          
.o_gmii_tx_en_p3	(w_gmii_rx_dv_swp3_2_swp3  ),         
.o_gmii_tx_er_p3	(w_gmii_rx_er_swp3_2_swp3  ),         
.o_gmii_tx_clk_p3	(w_gmii_rx_clk_swp3_2_swp3  ),      

.i_gmii_rxclk_from_cpu(i_gmii_rx_clk_p1_chip1      ), 
.i_gmii_rx_dv_from_cpu(i_gmii_rx_dv_p1_chip1       ), 
.iv_gmii_rxd_from_cpu (iv_gmii_rxd_p1_chip1        ), 
.i_gmii_rx_er_from_cpu(i_gmii_rx_er_p1_chip1       ),
                       
.ov_gmii_txd_to_cpu   (ov_gmii_txd_p1_chip1        ), 
.o_gmii_tx_en_to_cpu  (o_gmii_tx_en_p1_chip1       ), 
.o_gmii_txclk_to_cpu  (o_gmii_tx_out_clk_p1_chip1  ), 
.o_gmii_tx_er_to_cpu  (o_gmii_tx_er_p1_chip1       )
);

tsnnic tsnnic_inst1(
.i_clk			(i_clk2),
.i_hard_rst_n		(i_rst_n),
.i_button_rst_n		(i_rst_n),
.i_et_resetc_rst_n	(i_rst_n),

.i_gmii_rxclk_p1	(i_clk0    ),
.i_gmii_dv_p1		(w_gmii_tx_en_swp0_2_nic1    ),       
.iv_gmii_rxd_p1		(wv_gmii_txd_swp0_2_nic1    ),         
.i_gmii_er_p1		(w_gmii_tx_er_swp0_2_nic1    ),                         
                                
.ov_gmii_txd_p1		(wv_gmii_rxd_swp0_2_nic1    ),               
.o_gmii_tx_en_p1	(w_gmii_rx_dv_swp0_2_nic1    ),                                  
.o_gmii_tx_er_p1	(w_gmii_rx_er_swp0_2_nic1    ),            
.o_gmii_tx_clk_p1	(w_gmii_rx_clk_swp0_2_nic1    ),      
                                                       
.i_gmii_rxclk_p3	(i_gmii_rx_clk_host_chip2       ),
.i_gmii_dv_p3		(i_gmii_rx_dv_host_chip2        ),
.iv_gmii_rxd_p3		(iv_gmii_rxd_host_chip2         ),
.i_gmii_er_p3		(i_gmii_rx_er_host_chip2        ),
     
.ov_gmii_txd_p3		(ov_gmii_txd_host_chip2         ),       
.o_gmii_tx_en_p3	(o_gmii_tx_en_host_chip2        ),       
.o_gmii_tx_er_p3	(o_gmii_tx_er_host_chip2        ),       
.o_gmii_tx_clk_p3	(o_gmii_tx_out_clk_host_chip2   )
);

tsnnic tsnnic_inst2(
.i_clk			(i_clk3),
.i_hard_rst_n		(i_rst_n),
.i_button_rst_n		(i_rst_n),
.i_et_resetc_rst_n	(i_rst_n),

.i_gmii_rxclk_p1	(i_clk0  ),  
.i_gmii_dv_p1		(w_gmii_tx_en_swp1_2_nic2  ),       
.iv_gmii_rxd_p1		(wv_gmii_txd_swp1_2_nic2  ),         
.i_gmii_er_p1		(w_gmii_tx_er_swp1_2_nic2  ),                         
                               
.ov_gmii_txd_p1		(wv_gmii_rxd_swp1_2_nic2 	),               
.o_gmii_tx_en_p1	(w_gmii_rx_dv_swp1_2_nic2 	),                                  
.o_gmii_tx_er_p1	(w_gmii_rx_er_swp1_2_nic2 	),            
.o_gmii_tx_clk_p1	(w_gmii_rx_clk_swp1_2_nic2 ),      
                                                       
.i_gmii_rxclk_p3	(i_gmii_rx_clk_host_chip3     ),
.i_gmii_dv_p3		(i_gmii_rx_dv_host_chip3      ),
.iv_gmii_rxd_p3		(iv_gmii_rxd_host_chip3       ),
.i_gmii_er_p3		(i_gmii_rx_er_host_chip3      ),
                     
.ov_gmii_txd_p3		(ov_gmii_txd_host_chip3       ),       
.o_gmii_tx_en_p3	(o_gmii_tx_en_host_chip3      ),       
.o_gmii_tx_er_p3	(o_gmii_tx_er_host_chip3      ),       
.o_gmii_tx_clk_p3	(o_gmii_tx_out_clk_host_chip3 )
);

tsnnic tsnnic_inst3(
.i_clk			(i_clk4),
.i_hard_rst_n		(i_rst_n),
.i_button_rst_n		(i_rst_n),
.i_et_resetc_rst_n	(i_rst_n),

.i_gmii_rxclk_p1	(i_clk1 ),  
.i_gmii_dv_p1		(w_gmii_tx_en_swp0_2_nic3  ),       
.iv_gmii_rxd_p1		(wv_gmii_txd_swp0_2_nic3   ),         
.i_gmii_er_p1		(w_gmii_tx_er_swp0_2_nic3  ),                         
                                     
.ov_gmii_txd_p1		(wv_gmii_rxd_swp0_2_nic3 	),               
.o_gmii_tx_en_p1	(w_gmii_rx_dv_swp0_2_nic3 	),                                  
.o_gmii_tx_er_p1	(w_gmii_rx_er_swp0_2_nic3 	),            
.o_gmii_tx_clk_p1	(w_gmii_rx_clk_swp0_2_nic3  ),      
                                                       
.i_gmii_rxclk_p3	(i_gmii_rx_clk_host_chip4     ),
.i_gmii_dv_p3		(i_gmii_rx_dv_host_chip4      ),
.iv_gmii_rxd_p3		(iv_gmii_rxd_host_chip4       ),
.i_gmii_er_p3		(i_gmii_rx_er_host_chip4      ),
                     
.ov_gmii_txd_p3		(ov_gmii_txd_host_chip4       ),       
.o_gmii_tx_en_p3	(o_gmii_tx_en_host_chip4      ),       
.o_gmii_tx_er_p3	(o_gmii_tx_er_host_chip4      ),       
.o_gmii_tx_clk_p3	(o_gmii_tx_out_clk_host_chip4 )
);

tsnnic tsnnic_inst4(
.i_clk			(i_clk5),
.i_hard_rst_n		(i_rst_n),
.i_button_rst_n		(i_rst_n),
.i_et_resetc_rst_n	(i_rst_n),

.i_gmii_rxclk_p1	(i_clk1  ),   
.i_gmii_dv_p1		(w_gmii_tx_en_swp1_2_nic4  ),       
.iv_gmii_rxd_p1		(wv_gmii_txd_swp1_2_nic4  ),         
.i_gmii_er_p1		(w_gmii_tx_er_swp1_2_nic4  ),                         
                               
.ov_gmii_txd_p1		(wv_gmii_rxd_swp1_2_nic4 	),               
.o_gmii_tx_en_p1	(w_gmii_rx_dv_swp1_2_nic4 	),                                  
.o_gmii_tx_er_p1	(w_gmii_rx_er_swp1_2_nic4 	),            
.o_gmii_tx_clk_p1	(w_gmii_rx_clk_swp1_2_nic4  ),      
                                                       
.i_gmii_rxclk_p3	(i_gmii_rx_clk_host_chip5     ),
.i_gmii_dv_p3		(i_gmii_rx_dv_host_chip5      ),
.iv_gmii_rxd_p3		(iv_gmii_rxd_host_chip5       ),
.i_gmii_er_p3		(i_gmii_rx_er_host_chip5      ),
                     
.ov_gmii_txd_p3		(ov_gmii_txd_host_chip5       ),       
.o_gmii_tx_en_p3	(o_gmii_tx_en_host_chip5      ),       
.o_gmii_tx_er_p3	(o_gmii_tx_er_host_chip5      ),       
.o_gmii_tx_clk_p3	(o_gmii_tx_out_clk_host_chip5 )
);


endmodule
