module TSN_FPGA_4port#(parameter tsn_chip_version = 64'h0003020220220311)(
    input  wire       FPGA_SYS_CLK,//125Mhz
    input  wire       FPGA_SYS_RST_N,
    //Extenal PHY
    output wire       PHY_RST_N,
    output wire       PHY_MDC,
    inout  wire       PHY_MDIO,
    input  wire       PHY_MDINT,
    //SGMII
    input  wire       SGMII_REFCLK,
    input  wire [3:0] SGMII_RXD,
    output wire [3:0] SGMII_TXD,   
    output reg  [63:0]ov_tsn_chip_version, 

    input  wire       i_data_wr_from_cpu  ,
    input  wire [7:0] iv_data_from_cpu    ,
    output wire [7:0] ov_data_to_cpu      ,
    output wire       o_data_wr_to_cpu    ,    
    //GPIO
    input  wire [2:0] CARD_ID,//当前子卡的ID号，由载板插座的pin脚提供
    input  wire [2:0] MB_ID,//载板ID号，由载板插座的pin脚提供
    output wire [3:0] LED,
    output wire [9:0] RSV_IO,//载板插座上的保留功能IO
    output wire [4:0] DEBUG_LED
);

wire		rst_n;
wire		clk_50M;
wire		clk_125M;
//0
wire [ 4:0] reg_addr_link0;
wire [15:0] reg_data_out_link0;
wire        reg_rd_link0;
wire [15:0] reg_data_in_link0;
wire        reg_wr_link0;
wire        reg_busy_link0;
//wire        led_an_link0;
wire        led_link_link0;
wire        gmii_rx_dv_link0;
wire [ 7:0] gmii_rxd_link0;
wire        gmii_rx_er_link0;
wire        gmii_tx_en_link0;
wire [ 7:0] gmii_txd_link0;
wire        gmii_tx_er_link0;

//1
wire [ 4:0] reg_addr_link1;
wire [15:0] reg_data_out_link1;
wire        reg_rd_link1;
wire [15:0] reg_data_in_link1;
wire        reg_wr_link1;
wire        reg_busy_link1;
//wire        led_an_link1;
wire        led_link_link1;
wire        gmii_rx_dv_link1;
wire [ 7:0] gmii_rxd_link1;
wire        gmii_rx_er_link1;
wire        gmii_tx_en_link1;
wire [ 7:0] gmii_txd_link1;
wire        gmii_tx_er_link1;

//2
wire [ 4:0] reg_addr_link2;
wire [15:0] reg_data_out_link2;
wire        reg_rd_link2;
wire [15:0] reg_data_in_link2;
wire        reg_wr_link2;
wire        reg_busy_link2;
//wire        led_an_link2;
wire        led_link_link2;
wire        gmii_rx_dv_link2;
wire [ 7:0] gmii_rxd_link2;
wire        gmii_rx_er_link2;
wire        gmii_tx_en_link2;
wire [ 7:0] gmii_txd_link2;
wire        gmii_tx_er_link2;

//3
wire [ 4:0] reg_addr_link3;
wire [15:0] reg_data_out_link3;
wire        reg_rd_link3;
wire [15:0] reg_data_in_link3;
wire        reg_wr_link3;
wire        reg_busy_link3;
//wire        led_an_link2;
wire        led_link_link3;
wire        gmii_rx_dv_link3;
wire [ 7:0] gmii_rxd_link3;
wire        gmii_rx_er_link3;
wire        gmii_tx_en_link3;
wire [ 7:0] gmii_txd_link3;
wire        gmii_tx_er_link3;

//0
wire [ 7:0] ov_gmii_txd_p0;
wire        o_gmii_tx_en_p0;
wire        o_gmii_tx_er_p0;
wire        o_gmii_tx_clk_p0;
wire        PCS_tx_clk_inst0;
wire        PCS_rx_clk_inst0;

//1
wire [ 7:0] ov_gmii_txd_p1;
wire        o_gmii_tx_en_p1;
wire        o_gmii_tx_er_p1;
wire        o_gmii_tx_clk_p1;
wire        PCS_tx_clk_inst1;
wire        PCS_rx_clk_inst1;

//2
wire [ 7:0] ov_gmii_txd_p2;
wire        o_gmii_tx_en_p2;
wire        o_gmii_tx_er_p2;
wire        o_gmii_tx_clk_p2;
wire        PCS_tx_clk_inst2;
wire        PCS_rx_clk_inst2;

//3
wire [ 7:0] ov_gmii_txd_p3;
wire        o_gmii_tx_en_p3;
wire        o_gmii_tx_er_p3;
wire        o_gmii_tx_clk_p3;
wire        PCS_tx_clk_inst3;
wire        PCS_rx_clk_link3;

wire         Smi_link;
wire         Smi_mdc;
reg          Smi_mdi; 
wire         Smi_mdo;
wire [1:0]   Smi_sel;
wire         init_done_link;

assign PHY_MDC = Smi_mdc;
assign PHY_MDIO = (Smi_link & (Smi_sel == 2'd0))? Smi_mdo : 1'bz;
assign Smi_sel = 1'b0;
//******************************
//  Device identification
//*****************************

always @(posedge clk_125M or negedge rst_n) begin
    if(!rst_n) begin
        ov_tsn_chip_version <= 64'h0;
    end
    else begin
        ov_tsn_chip_version <= tsn_chip_version;
    end
end

assign DEBUG_LED[1] = 1'b0;
assign DEBUG_LED[0] = 1'b0;

always @(*)
    if(~FPGA_SYS_RST_N)
        Smi_mdi = 1'b0;
    else  if(~Smi_link)begin
        case(Smi_sel)
            2'b00 : Smi_mdi = PHY_MDIO ;
            default: Smi_mdi = 1'b1 ;
        endcase
    end
    else
      Smi_mdi = 1'b1;

clk125M_50M125M clk125M_50M125M_inst(
	.rst      (!FPGA_SYS_RST_N),      //   reset.reset
	.refclk   (FPGA_SYS_CLK),   //  refclk.clk
	.locked   (rst_n),   //  locked.export
	.outclk_0 (clk_50M), // outclk0.clk
	.outclk_1 (clk_125M)  // outclk1.clk
);

extern_phy_config extern_phy_config_inst(
    .clk_100m	  (clk_50M)	,
    .rst_n		  (rst_n),
    .smi_mdi     ( Smi_mdi ),
    .smi_mdc     ( Smi_mdc ), 
    .smi_mdo     ( Smi_mdo ),
    .smi_link    ( Smi_link),
    .init_done   (init_done_link )
);

phy_reset phy_reset_inst(
    .clk              (clk_50M),
    .reset            (rst_n),
    .init_done        (init_done_link),
    .autoneg_success  ((&LED)),                  
    .phy_reset_over   (PHY_RST_N)
);

tsnswitch tsnswitch0_inst(
	.i_clk(clk_125M),
		   
    .i_hard_rst_n		(rst_n    ),                          
    .i_button_rst_n		(rst_n    ),                          
    .i_et_resetc_rst_n	(rst_n    ),  
		   
	.ov_gmii_txd_p0(ov_gmii_txd_p0),
	.o_gmii_tx_en_p0(o_gmii_tx_en_p0),
	.o_gmii_tx_er_p0(o_gmii_tx_er_p0),
	.o_gmii_tx_clk_p0(o_gmii_tx_clk_p0),

	.ov_gmii_txd_p1(ov_gmii_txd_p1),
	.o_gmii_tx_en_p1(o_gmii_tx_en_p1),
	.o_gmii_tx_er_p1(o_gmii_tx_er_p1),
	.o_gmii_tx_clk_p1(o_gmii_tx_clk_p1),
    
	.ov_gmii_txd_p2(ov_gmii_txd_p2),
	.o_gmii_tx_en_p2(o_gmii_tx_en_p2),
	.o_gmii_tx_er_p2(o_gmii_tx_er_p2),
	.o_gmii_tx_clk_p2(o_gmii_tx_clk_p2),
	
	.ov_gmii_txd_p3(ov_gmii_txd_p3),
	.o_gmii_tx_en_p3(o_gmii_tx_en_p3),
	.o_gmii_tx_er_p3(o_gmii_tx_er_p3),
	.o_gmii_tx_clk_p3(o_gmii_tx_clk_p3),    
		   
	.i_gmii_rxclk_p0(PCS_rx_clk_inst0),
	.i_gmii_dv_p0(gmii_rx_dv_link0),
	.iv_gmii_rxd_p0(gmii_rxd_link0),
	.i_gmii_er_p0(gmii_rx_er_link0),
		   
	.i_gmii_rxclk_p1(PCS_rx_clk_inst1),
	.i_gmii_dv_p1(gmii_rx_dv_link1),
	.iv_gmii_rxd_p1(gmii_rxd_link1),
	.i_gmii_er_p1(gmii_rx_er_link1),
    
	.i_gmii_rxclk_p2(PCS_rx_clk_inst2),
	.i_gmii_dv_p2(gmii_rx_dv_link2),
	.iv_gmii_rxd_p2(gmii_rxd_link2),
	.i_gmii_er_p2(gmii_tx_er_link2), 

	.i_gmii_rxclk_p3(PCS_rx_clk_link3),
	.i_gmii_dv_p3(gmii_rx_dv_link3),
	.iv_gmii_rxd_p3(gmii_rxd_link3),
	.i_gmii_er_p3(gmii_tx_er_link3),

   .i_gmii_rxclk_from_cpu(clk_125M)  ,
   .i_gmii_rx_dv_from_cpu(1'b0) ,
   .iv_gmii_rxd_from_cpu (8'b0)  ,
   .i_gmii_rx_er_from_cpu(1'b0)  ,
   .ov_gmii_txd_to_cpu  (ov_data_to_cpu    ) ,
   .o_gmii_tx_en_to_cpu (o_data_wr_to_cpu  ) ,
   .o_gmii_txclk_to_cpu (  )  ,
   .o_gmii_tx_er_to_cpu (  )  ,

	.o_cycle_start(RSV_IO[9]),
	.ov_hardware_stage (DEBUG_LED[4:2])  
);

port_passthrough port_passthrough_inst0(
	.gmii_rxclk(o_gmii_tx_clk_p0),
	.gmii_txclk(PCS_tx_clk_inst0),
	.rst_n(rst_n),
		
	.gmii_rx_en(o_gmii_tx_en_p0),
	.gmii_rx_er(o_gmii_tx_er_p0),
	.gmii_rxd(ov_gmii_txd_p0),
		
	.gmii_tx_en(gmii_tx_en_link0),
	.gmii_tx_er(gmii_tx_er_link0),
	.gmii_txd(gmii_txd_link0)
);

sgmii_config sgmii_config_inst0(
	.clk(clk_50M),
	.reset(rst_n),
	
	.reg_data_out(reg_data_out_link0),
	.reg_rd(reg_rd_link0),
	.reg_data_in(reg_data_in_link0),
	.reg_wr(reg_wr_link0),
	.reg_busy(reg_busy_link0),
	.reg_addr(reg_addr_link0),

	.led_link(led_link_link0),
	.led_an(LED[0])
);

port_passthrough port_passthrough_inst1(
	.gmii_rxclk(o_gmii_tx_clk_p1),
	.gmii_txclk(PCS_tx_clk_inst1),
	.rst_n(rst_n),
		
	.gmii_rx_en(o_gmii_tx_en_p1),
	.gmii_rx_er(o_gmii_tx_er_p1),
	.gmii_rxd(ov_gmii_txd_p1),
		
	.gmii_tx_en(gmii_tx_en_link1),
	.gmii_tx_er(gmii_tx_er_link1),
	.gmii_txd(gmii_txd_link1)
);

sgmii_config sgmii_config_inst1(
	.clk(clk_50M),
	.reset(rst_n),
	
	.reg_data_out(reg_data_out_link1),
	.reg_rd(reg_rd_link1),
	.reg_data_in(reg_data_in_link1),
	.reg_wr(reg_wr_link1),
	.reg_busy(reg_busy_link1),
	.reg_addr(reg_addr_link1),

	.led_link(led_link_link1),
	.led_an(LED[1])
);


port_passthrough port_passthrough_inst2(
	.gmii_rxclk(o_gmii_tx_clk_p2),
	.gmii_txclk(PCS_tx_clk_inst2),
	.rst_n(rst_n),
		
	.gmii_rx_en(o_gmii_tx_en_p2),
	.gmii_rx_er(o_gmii_tx_er_p2),
	.gmii_rxd(ov_gmii_txd_p2),
		
	.gmii_tx_en(gmii_tx_en_link2),
	.gmii_tx_er(gmii_tx_er_link2),
	.gmii_txd(gmii_txd_link2)
);

sgmii_config sgmii_config_inst2(
	.clk(clk_50M),
	.reset(rst_n),
	
	.reg_data_out(reg_data_out_link2),
	.reg_rd(reg_rd_link2),
	.reg_data_in(reg_data_in_link2),
	.reg_wr(reg_wr_link2),
	.reg_busy(reg_busy_link2),
	.reg_addr(reg_addr_link2),

	.led_link(led_link_link2),
	.led_an(LED[2])
);

port_passthrough port_passthrough_inst3(
	.gmii_rxclk(o_gmii_tx_clk_p3),
	.gmii_txclk(PCS_tx_clk_inst3),
	.rst_n(rst_n),
		
	.gmii_rx_en(o_gmii_tx_en_p3),
	.gmii_rx_er(o_gmii_tx_er_p3),
	.gmii_rxd(ov_gmii_txd_p3),
		
	.gmii_tx_en(gmii_tx_en_link3),
	.gmii_tx_er(gmii_tx_er_link3),
	.gmii_txd(gmii_txd_link3)
);
sgmii_config sgmii_config_inst3(
	.clk(clk_50M),
	.reset(rst_n),
	
	.reg_data_out(reg_data_out_link3),
	.reg_rd(reg_rd_link3),
	.reg_data_in(reg_data_in_link3),
	.reg_wr(reg_wr_link3),
	.reg_busy(reg_busy_link3),
	.reg_addr(reg_addr_link3),

	.led_link(led_link_link3),
	.led_an(LED[3])
);


sgmii_pcs_share sgmii_pcs_share_inst(
    .clk            (clk_50M),            // control_port_clock_connection.clk
    .reset          (!rst_n),          //              reset_connection.reset
    .ref_clk        (SGMII_REFCLK),        //  pcs_ref_clk_clock_connection.clk
        
    .rxp_0            (SGMII_RXD[0]),            //             serial_connection.rxp_0
    .txp_0            (SGMII_TXD[0]),            //                              .txp_0
    .reg_addr_0       (reg_addr_link0),       //                  control_port.address
    .reg_data_out_0   (reg_data_out_link0),   //                              .readdata
    .reg_rd_0         (reg_rd_link0),         //                              .read
    .reg_data_in_0    (reg_data_in_link0),    //                              .writedata
    .reg_wr_0         (reg_wr_link0),         //                              .write
    .reg_busy_0       (reg_busy_link0),       //                              .waitrequest
    .tx_clk_0         (PCS_tx_clk_inst0),         // pcs_transmit_clock_connection.clk
    .rx_clk_0         (PCS_rx_clk_inst0),         //  pcs_receive_clock_connection.clk
    .reset_tx_clk_0   (1'b0),   // pcs_transmit_reset_connection.reset
    .reset_rx_clk_0   (1'b0),   //  pcs_receive_reset_connection.reset
    .gmii_rx_dv_0     (gmii_rx_dv_link0),     //               gmii_connection.gmii_rx_dv
    .gmii_rx_d_0      (gmii_rxd_link0),      //                              .gmii_rx_d
    .gmii_rx_err_0    (gmii_rx_er_link0),    //                              .gmii_rx_err
    .gmii_tx_en_0     (gmii_tx_en_link0),     //                              .gmii_tx_en
    .gmii_tx_d_0      (gmii_txd_link0),      //                              .gmii_tx_d
    .gmii_tx_err_0    (gmii_tx_er_link0),    //                              .gmii_tx_err
    .led_crs_0        (),        //         status_led_connection.crs
    .led_link_0       (led_link_link0),       //                              .link
    .led_panel_link_0 (), //                              .panel_link
    .led_col_0        (),        //                              .col
    .led_an_0         (LED[0]),         //                              .an
    .led_char_err_0   (),   //                              .char_err
    .led_disp_err_0   (),   //                              .disp_err
    .rx_recovclkout_0 (),  //     serdes_control_connection.export
    
    .rxp_1            (SGMII_RXD[1]),            //             serial_connection.rxp_1
    .txp_1            (SGMII_TXD[1]),            //                              .txp_1
    .reg_addr_1       (reg_addr_link1),       //                  control_port.address
    .reg_data_out_1   (reg_data_out_link1),   //                              .readdata
    .reg_rd_1         (reg_rd_link1),         //                              .read
    .reg_data_in_1    (reg_data_in_link1),    //                              .writedata
    .reg_wr_1         (reg_wr_link1),         //                              .write
    .reg_busy_1       (reg_busy_link1),       //                              .waitrequest
    .tx_clk_1         (PCS_tx_clk_inst1),         // pcs_transmit_clock_connection.clk
    .rx_clk_1         (PCS_rx_clk_inst1),         //  pcs_receive_clock_connection.clk
    .reset_tx_clk_1   (1'b0),   // pcs_transmit_reset_connection.reset
    .reset_rx_clk_1   (1'b0),   //  pcs_receive_reset_connection.reset
    .gmii_rx_dv_1     (gmii_rx_dv_link1),     //               gmii_connection.gmii_rx_dv
    .gmii_rx_d_1      (gmii_rxd_link1),      //                              .gmii_rx_d
    .gmii_rx_err_1    (gmii_rx_er_link1),    //                              .gmii_rx_err
    .gmii_tx_en_1     (gmii_tx_en_link1),     //                              .gmii_tx_en
    .gmii_tx_d_1      (gmii_txd_link1),      //                              .gmii_tx_d
    .gmii_tx_err_1    (gmii_tx_er_link1),    //                              .gmii_tx_err
    .led_crs_1        (),        //         status_led_connection.crs
    .led_link_1       (led_link_link1),       //                              .link
    .led_panel_link_1 (), //                              .panel_link
    .led_col_1        (),        //                              .col
    .led_an_1         (LED[1]),         //                              .an
    .led_char_err_1   (),   //                              .char_err
    .led_disp_err_1   (),   //                              .disp_err
    .rx_recovclkout_1 (),  //     serdes_control_connection.export

    .rxp_2            (SGMII_RXD[2]),            //             serial_connection.rxp_2
    .txp_2            (SGMII_TXD[2]),            //                              .txp_2
    .reg_addr_2       (reg_addr_link2),       //                  control_port.address
    .reg_data_out_2   (reg_data_out_link2),   //                              .readdata
    .reg_rd_2         (reg_rd_link2),         //                              .read
    .reg_data_in_2    (reg_data_in_link2),    //                              .writedata
    .reg_wr_2         (reg_wr_link2),         //                              .write
    .reg_busy_2       (reg_busy_link2),       //                              .waitrequest
    .tx_clk_2         (PCS_tx_clk_inst2),         // pcs_transmit_clock_connection.clk
    .rx_clk_2         (PCS_rx_clk_inst2),         //  pcs_receive_clock_connection.clk
    .reset_tx_clk_2   (1'b0),   // pcs_transmit_reset_connection.reset
    .reset_rx_clk_2   (1'b0),   //  pcs_receive_reset_connection.reset
    .gmii_rx_dv_2     (gmii_rx_dv_link2),     //               gmii_connection.gmii_rx_dv
    .gmii_rx_d_2      (gmii_rxd_link2),      //                              .gmii_rx_d
    .gmii_rx_err_2    (gmii_rx_er_link2),    //                              .gmii_rx_err
    .gmii_tx_en_2     (gmii_tx_en_link2),     //                              .gmii_tx_en
    .gmii_tx_d_2      (gmii_txd_link2),      //                              .gmii_tx_d
    .gmii_tx_err_2    (gmii_tx_er_link2),    //                              .gmii_tx_err
    .led_crs_2        (),        //         status_led_connection.crs
    .led_link_2       (led_link_link2),       //                              .link
    .led_panel_link_2 (), //                              .panel_link
    .led_col_2        (),        //                              .col
    .led_an_2         (LED[2]),         //                              .an
    .led_char_err_2   (),   //                              .char_err
    .led_disp_err_2   (),   //                              .disp_err
    .rx_recovclkout_2 (),  //     serdes_control_connection.export
    
    .rxp_3            (SGMII_RXD[3]),            //             serial_connection.rxp_3
    .txp_3            (SGMII_TXD[3]),            //                              .txp_3
    .reg_addr_3       (reg_addr_link3),       //                  control_port.address
    .reg_data_out_3   (reg_data_out_link3),   //                              .readdata
    .reg_rd_3         (reg_rd_link3),         //                              .read
    .reg_data_in_3    (reg_data_in_link3),    //                              .writedata
    .reg_wr_3         (reg_wr_link3),         //                              .write
    .reg_busy_3       (reg_busy_link3),       //                              .waitrequest
    .tx_clk_3         (PCS_tx_clk_inst3),         // pcs_transmit_clock_connection.clk
    .rx_clk_3         (PCS_rx_clk_link3),         //  pcs_receive_clock_connection.clk
    .reset_tx_clk_3   (1'b0),   // pcs_transmit_reset_connection.reset
    .reset_rx_clk_3   (1'b0),   //  pcs_receive_reset_connection.reset
    .gmii_rx_dv_3     (gmii_rx_dv_link3),     //               gmii_connection.gmii_rx_dv
    .gmii_rx_d_3      (gmii_rxd_link3),      //                              .gmii_rx_d
    .gmii_rx_err_3    (gmii_rx_er_link3),    //                              .gmii_rx_err
    .gmii_tx_en_3     (gmii_tx_en_link3),     //                              .gmii_tx_en
    .gmii_tx_d_3      (gmii_txd_link3),      //                              .gmii_tx_d
    .gmii_tx_err_3    (gmii_tx_er_link3),    //                              .gmii_tx_err
    .led_crs_3        (),        //         status_led_connection.crs
    .led_link_3       (led_link_link3),       //                              .link
    .led_panel_link_3 (), //                              .panel_link
    .led_col_3        (),        //                              .col
    .led_an_3         (LED[3]),         //                              .an
    .led_char_err_3   (),   //                              .char_err
    .led_disp_err_3   (),   //                              .disp_err
    .rx_recovclkout_3 ()  //     serdes_control_connection.export    
);

endmodule
