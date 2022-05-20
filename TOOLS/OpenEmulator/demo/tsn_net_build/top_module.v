// Copyright (C) 1953-2020 NUDT
// Verilog module name - top_module 
// Version: top_module_V1.0
// Created:
//         by - Jintao Peng
//         at - 06.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         top_module.
///////////////////////////////////////////////////////////////////////////

module top_module#(
    parameter PLATFORM = "MODELSIM"
)(
);    
     wire clk_out0;
	 wire clk_out1;
	 wire clk_out2;
     wire clk_out3;
	 wire clk_out4;
	 wire clk_out5;     
	 wire sync_clk;
     wire rst_n_out;	 
     wire [31:0] top_time2local_clock;

	 wire [7:0] chip1p0_txd;
     wire [7:0] chip1p1_txd;
     wire [7:0] chip1p2_txd;
     wire [7:0] chip1p3_txd;
	 wire [7:0] chip1p4_txd;
     wire [7:0] chip1p5_txd;
     wire [7:0] chip1p6_txd;
     wire [7:0] chip1p7_txd;	 
	 wire chip1p0_txd_en;
     wire chip1p1_txd_en;
     wire chip1p2_txd_en;
     wire chip1p3_txd_en;
	 wire chip1p4_txd_en;
     wire chip1p5_txd_en;
     wire chip1p6_txd_en;
     wire chip1p7_txd_en;	 
	 
	 wire [7:0] chip1p0_rxd;
     wire [7:0] chip1p1_rxd;
     wire [7:0] chip1p2_rxd;
     wire [7:0] chip1p3_rxd;
	 wire [7:0] chip1p4_rxd;
     wire [7:0] chip1p5_rxd;
     wire [7:0] chip1p6_rxd;
     wire [7:0] chip1p7_rxd;
	 
	 wire chip1p0_rxd_en;
     wire chip1p1_rxd_en;
     wire chip1p2_rxd_en;
     wire chip1p3_rxd_en;
	 wire chip1p4_rxd_en;
     wire chip1p5_rxd_en;
     wire chip1p6_rxd_en;
     wire chip1p7_rxd_en;	 
     
     wire w_clk0;
     wire w_clk1;
     wire w_clk2;
     wire w_clk3;
     wire w_clk4;
     wire w_clk5;
     
     wire [7:0] tsp8_txd ; 
	 wire tsp8_txd_en	 ;	 
     wire [7:0] tsp8_rxd ; 
	 wire tsp8_rxd_en	 ;
	 
	 wire w_sim_ctrl     ;
     wire w_sync_clk     ;  
	 wire w_sync_time_wr ;
	 wire [47:0] wv_sync_time ; 
	 
	 
	 
	 
//***************************************************
//                  Module Instance
//***************************************************
top_read_write_ts top_read_write_ts_inst(
.clk  		(sync_clk_out),
.rst_n      (rst_n_out),

.local_clock(top_time2local_clock),
.host_r8_id (4'd8),
.host_wr8_id(4'd8),

/////////RX
.RXD_08  	(tsp8_txd   ),
.RXDV_08 	(tsp8_txd_en),

/////////TX
.TXD_08  	(tsp8_rxd   ),
.TX_EN_08	(tsp8_rxd_en)
);
clk_rst_generate clk_rst_generate_inst(
.sync_clk		(sync_clk_out),
.rst_n   		(rst_n_out),
.top_time		(top_time2local_clock)
);
sync_clock_control sync_clock_control_inst(
.i_sync_clk  	(sync_clk_out),
.i_sim_ctrl		(w_sim_ctrl ),
.o_sync_clk		(w_sync_clk )
);
ts_clock_control ts_clock_control_inst(
.i_clk         (sync_clk_out),
.i_rst_n       (rst_n_out),
.i_sync_clk    (w_sync_clk),
.o_sync_time_wr(w_sync_time_wr),
.ov_sync_time  (wv_sync_time  )
);

sync_control_module sync_control_module_inst(
.i_clk         (sync_clk_out),
.i_rst_n       (rst_n_out),
.iv_app_data   (tsp8_rxd),
.i_app_data_wr (tsp8_rxd_en),
.iv_clock_ts   (wv_sync_time  ),
.i_clock_ts_wr (w_sync_time_wr),

.ov_sync_data  (tsp8_txd),
.o_sync_data_wr(tsp8_txd_en),
.o_sim_ctrl    (w_sim_ctrl),
.ov_scm_state  ()
);

top_read_write_file top_read_write_file_inst(
.clk0  (clk_out0),
.clk1  (clk_out1),
.clk2  (clk_out2),
.clk3  (clk_out3),
.clk4  (clk_out4),
.clk5  (clk_out5),
.rst_n(rst_n_out),

.local_clock(top_time2local_clock),

.host_r0_id(4'd0),
.host_r1_id(4'd1),
.host_r2_id(4'd2),
.host_r3_id(4'd3),
.host_r4_id(4'd4),
.host_r5_id(4'd5),
.host_r6_id(4'd6),
.host_r7_id(4'd7),

.host_wr0_id(4'd0),
.host_wr1_id(4'd1),
.host_wr2_id(4'd2),
.host_wr3_id(4'd3),
.host_wr4_id(4'd4),
.host_wr5_id(4'd5),
.host_wr6_id(4'd6),
.host_wr7_id(4'd7),

/////////RX
.RXD_00(chip1p0_txd),
.RXDV_00(chip1p0_txd_en),

.RXD_01(chip1p1_txd),
.RXDV_01(chip1p1_txd_en),

.RXD_02(chip1p2_txd),
.RXDV_02(chip1p2_txd_en),

.RXD_03(chip1p3_txd),
.RXDV_03(chip1p3_txd_en),

.RXD_04(chip1p4_txd),
.RXDV_04(chip1p4_txd_en),

.RXD_05(chip1p5_txd),
.RXDV_05(chip1p5_txd_en),

.RXD_06(chip1p6_txd),
.RXDV_06(chip1p6_txd_en),

.RXD_07(chip1p7_txd),
.RXDV_07(chip1p7_txd_en),
/////////TX
.TXD_00(chip1p0_rxd),
.TX_EN_00(chip1p0_rxd_en),

.TXD_01(chip1p1_rxd),
.TX_EN_01(chip1p1_rxd_en),

.TXD_02(chip1p2_rxd),
.TX_EN_02(chip1p2_rxd_en),

.TXD_03(chip1p3_rxd),
.TX_EN_03(chip1p3_rxd_en),

.TXD_04(chip1p4_rxd),
.TX_EN_04(chip1p4_rxd_en),

.TXD_05(chip1p5_rxd),
.TX_EN_05(chip1p5_rxd_en),

.TXD_06(chip1p6_rxd),
.TX_EN_06(chip1p6_rxd_en),

.TXD_07(chip1p7_rxd),
.TX_EN_07(chip1p7_rxd_en)
);


clk_rst_generate_chip clk_rst_generate_chip_inst(
.clk0(w_clk0),
.clk1(w_clk1),
.clk2(w_clk2),
.clk3(w_clk3),
.clk4(w_clk4),
.clk5(w_clk5),
.rst_n(),
.top_time1()
);

chip_clock_control chip_clock_control_inst(
.i_clk0  	(w_clk0),
.i_clk1  	(w_clk1),
.i_clk2  	(w_clk2),
.i_clk3  	(w_clk3),
.i_clk4  	(w_clk4),
.i_clk5  	(w_clk5),
.i_sim_ctrl (w_sim_ctrl ),

.o_clk0		(clk_out0 ),
.o_clk1		(clk_out1 ),
.o_clk2		(clk_out2 ),
.o_clk3		(clk_out3 ),
.o_clk4		(clk_out4 ),
.o_clk5		(clk_out5 )
);

configurable_topology_control configurable_topology_control_inst(
.i_clk0(clk_out0),
.i_clk1(clk_out1),
.i_clk2(clk_out2),
.i_clk3(clk_out3),
.i_clk4(clk_out4),
.i_clk5(clk_out5),
.i_rst_n(rst_n_out),

////////TSN_SW1//////////
.i_gmii_rx_clk_p0_chip0(clk_out0),
.i_gmii_rx_dv_p0_chip0 (chip1p0_rxd_en),  
.iv_gmii_rxd_p0_chip0  (chip1p0_rxd),
.i_gmii_rx_er_p0_chip0 (1'b0),

.i_gmii_rx_clk_p1_chip0(clk_out0),
.i_gmii_rx_dv_p1_chip0 (chip1p1_rxd_en),
.iv_gmii_rxd_p1_chip0  (chip1p1_rxd),
.i_gmii_rx_er_p1_chip0 (1'b0),

.i_gmii_tx_in_clk_p0_chip0 (clk_out0),
.ov_gmii_txd_p0_chip0  	   (chip1p0_txd),
.o_gmii_tx_en_p0_chip0     (chip1p0_txd_en),
.o_gmii_tx_er_p0_chip0     (),
.o_gmii_tx_out_clk_p0_chip0(),   

.i_gmii_tx_in_clk_p1_chip0 (clk_out0),
.ov_gmii_txd_p1_chip0      (chip1p1_txd),
.o_gmii_tx_en_p1_chip0     (chip1p1_txd_en),
.o_gmii_tx_er_p1_chip0     (),
.o_gmii_tx_out_clk_p1_chip0(),  

////////TSN_SW2//////////
.i_gmii_rx_clk_p0_chip1(clk_out1),
.i_gmii_rx_dv_p0_chip1 (chip1p2_rxd_en),  
.iv_gmii_rxd_p0_chip1  (chip1p2_rxd),
.i_gmii_rx_er_p0_chip1 (1'b0),

.i_gmii_rx_clk_p1_chip1(clk_out1),
.i_gmii_rx_dv_p1_chip1 (chip1p3_rxd_en),
.iv_gmii_rxd_p1_chip1  (chip1p3_rxd),
.i_gmii_rx_er_p1_chip1 (1'b0),

.i_gmii_tx_in_clk_p0_chip1 (clk_out1),
.ov_gmii_txd_p0_chip1  	   (chip1p2_txd),
.o_gmii_tx_en_p0_chip1     (chip1p2_txd_en),
.o_gmii_tx_er_p0_chip1     (),
.o_gmii_tx_out_clk_p0_chip1(),   

.i_gmii_tx_in_clk_p1_chip1 (clk_out1),
.ov_gmii_txd_p1_chip1      (chip1p3_txd),
.o_gmii_tx_en_p1_chip1     (chip1p3_txd_en),
.o_gmii_tx_er_p1_chip1     (),
.o_gmii_tx_out_clk_p1_chip1(),    

////////TSN_NIC1//////////
.i_gmii_rx_clk_host_chip2	(clk_out2),
.i_gmii_rx_dv_host_chip2	(chip1p4_rxd_en),
.iv_gmii_rxd_host_chip2		(chip1p4_rxd),
.i_gmii_rx_er_host_chip2	(1'b0),    

.i_gmii_tx_in_clk_host_chip2(clk_out2),
.ov_gmii_txd_host_chip2		(chip1p4_txd),
.o_gmii_tx_en_host_chip2	(chip1p4_txd_en),
.o_gmii_tx_er_host_chip2	(),
.o_gmii_tx_out_clk_host_chip2(),

////////TSN_NIC2//////////
.i_gmii_rx_clk_host_chip3	(clk_out3),
.i_gmii_rx_dv_host_chip3	(chip1p5_rxd_en),
.iv_gmii_rxd_host_chip3		(chip1p5_rxd),
.i_gmii_rx_er_host_chip3	(1'b0),	  

.i_gmii_tx_in_clk_host_chip3(clk_out3),
.ov_gmii_txd_host_chip3		(chip1p5_txd),
.o_gmii_tx_en_host_chip3	(chip1p5_txd_en),
.o_gmii_tx_er_host_chip3	(),
.o_gmii_tx_out_clk_host_chip3(),

////////TSN_NIC3//////////
.i_gmii_rx_clk_host_chip4	(clk_out4),
.i_gmii_rx_dv_host_chip4	(chip1p6_rxd_en),
.iv_gmii_rxd_host_chip4		(chip1p6_rxd),
.i_gmii_rx_er_host_chip4	(1'b0),    

.i_gmii_tx_in_clk_host_chip4(clk_out4),
.ov_gmii_txd_host_chip4		(chip1p6_txd),
.o_gmii_tx_en_host_chip4	(chip1p6_txd_en),
.o_gmii_tx_er_host_chip4	(),
.o_gmii_tx_out_clk_host_chip4(),

////////TSN_NIC4//////////
.i_gmii_rx_clk_host_chip5	(clk_out5),
.i_gmii_rx_dv_host_chip5	(chip1p7_rxd_en),
.iv_gmii_rxd_host_chip5		(chip1p7_rxd),
.i_gmii_rx_er_host_chip5	(1'b0),	  

.i_gmii_tx_in_clk_host_chip5(clk_out5),
.ov_gmii_txd_host_chip5		(chip1p7_txd),
.o_gmii_tx_en_host_chip5	(chip1p7_txd_en),
.o_gmii_tx_er_host_chip5	(),
.o_gmii_tx_out_clk_host_chip5()
);
endmodule
