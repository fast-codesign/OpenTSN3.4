module top_read_write_file#(
    parameter PLATFORM = "MODELSIM"
)(
    input clk0,
    input clk1,
    input clk2,	
    input clk3,
    input clk4,
    input clk5,	    
    input rst_n,

    input [31:0] local_clock,
    
    input [3:0] host_r0_id,
    input [3:0] host_r1_id,
    input [3:0] host_r2_id,
    input [3:0] host_r3_id,
    input [3:0] host_r4_id,
    input [3:0] host_r5_id,
    input [3:0] host_r6_id,
    input [3:0] host_r7_id,

    input [3:0] host_wr0_id,
    input [3:0] host_wr1_id,
    input [3:0] host_wr2_id,
    input [3:0] host_wr3_id,
    input [3:0] host_wr4_id,
    input [3:0] host_wr5_id,
    input [3:0] host_wr6_id,
    input [3:0] host_wr7_id,

    input [7:0] RXD_00,
    input RXDV_00,

    input [7:0] RXD_01,
    input RXDV_01,
    
    input [7:0] RXD_02,
    input RXDV_02,
    
    input [7:0] RXD_03,
    input RXDV_03,
    
    input [7:0] RXD_04,
    input RXDV_04,

    input [7:0] RXD_05,
    input RXDV_05,
    
    input [7:0] RXD_06,
    input RXDV_06,
    
    input [7:0] RXD_07,
    input RXDV_07,
    
    
    output wire[7:0] TXD_00,
    output wire TX_EN_00,

    output wire[7:0] TXD_01,
    output wire TX_EN_01,

    output wire[7:0] TXD_02,
    output wire TX_EN_02,

    output wire[7:0] TXD_03,
    output wire TX_EN_03,
    
    output wire[7:0] TXD_04,
    output wire TX_EN_04,
    
    output wire[7:0] TXD_05,
    output wire TX_EN_05,

    output wire[7:0] TXD_06,
    output wire TX_EN_06,

    output wire[7:0] TXD_07,
    output wire TX_EN_07
);
                                      //wire [7:0] r2b00,r2b01,r2b02,r2b03;
                                      // wire temp00,temp01,temp02,temp03;
 //***************************************************
//                  Module Instance
//***************************************************
      read_file_data read_file_inst00(
          
           .clk(clk0),
           .rst_n(rst_n),
           .host_r_id(host_r0_id),
           .local_clock(local_clock),
           .TXD(TXD_00),
           .TX_EN(TX_EN_00)
      );

      read_file_data read_file_inst01(
          
           .clk(clk0),
           .rst_n(rst_n),
           .host_r_id(host_r1_id),
           .local_clock(local_clock),
           .TXD(TXD_01),
           .TX_EN(TX_EN_01)
      );

      read_file_data read_file_inst02(
          
           .clk(clk1),
           .rst_n(rst_n),
           .host_r_id(host_r2_id),
           .local_clock(local_clock),
           .TXD(TXD_02),
           .TX_EN(TX_EN_02)
      );

      read_file_data read_file_inst03(
          
           .clk(clk1),
           .rst_n(rst_n),
           .host_r_id(host_r3_id),
           .local_clock(local_clock),
           .TXD(TXD_03),
           .TX_EN(TX_EN_03)
      );    

      read_file_data read_file_inst04(
          
           .clk(clk2),
           .rst_n(rst_n),
           .host_r_id(host_r4_id),
           .local_clock(local_clock),
           .TXD(TXD_04),
           .TX_EN(TX_EN_04)
      );

      read_file_data read_file_inst05(
          
           .clk(clk3),
           .rst_n(rst_n),
           .host_r_id(host_r5_id),
           .local_clock(local_clock),
           .TXD(TXD_05),
           .TX_EN(TX_EN_05)
      );

      read_file_data read_file_inst06(
          
           .clk(clk4),
           .rst_n(rst_n),
           .host_r_id(host_r6_id),
           .local_clock(local_clock),
           .TXD(TXD_06),
           .TX_EN(TX_EN_06)
      );

      read_file_data read_file_inst07(
          
           .clk(clk5),
           .rst_n(rst_n),
           .host_r_id(host_r7_id),
           .local_clock(local_clock),
           .TXD(TXD_07),
           .TX_EN(TX_EN_07)
      );

     ////////////////////////////
      write_file_data write_file_inst00(
           .clk(clk0),
           .rst_n(rst_n),
           .host_wr_id(host_wr0_id),
           .local_clock(local_clock),
           .RXD(RXD_00),
           .RXDV(RXDV_00)
      );

      write_file_data write_file_inst01(
           .clk(clk0),
           .rst_n(rst_n),
           .host_wr_id(host_wr1_id),
           .local_clock(local_clock),
           .RXD(RXD_01),
           .RXDV(RXDV_01)
      );

      write_file_data write_file_inst02(
           .clk(clk1),
           .rst_n(rst_n),
           .host_wr_id(host_wr2_id),
           .local_clock(local_clock),
           .RXD(RXD_02),
           .RXDV(RXDV_02)
      );

      write_file_data write_file_inst03(
           .clk(clk1),
           .rst_n(rst_n),
           .host_wr_id(host_wr3_id),
           .local_clock(local_clock),
           .RXD(RXD_03),
           .RXDV(RXDV_03)
      );
      
      write_file_data write_file_inst04(
           .clk(clk2),
           .rst_n(rst_n),
           .host_wr_id(host_wr4_id),
           .local_clock(local_clock),
           .RXD(RXD_04),
           .RXDV(RXDV_04)
      );

      write_file_data write_file_inst05(
           .clk(clk3),
           .rst_n(rst_n),
           .host_wr_id(host_wr5_id),
           .local_clock(local_clock),
           .RXD(RXD_05),
           .RXDV(RXDV_05)
      );

      write_file_data write_file_inst06(
           .clk(clk4),
           .rst_n(rst_n),
           .host_wr_id(host_wr6_id),
           .local_clock(local_clock),
           .RXD(RXD_06),
           .RXDV(RXDV_06)
      );

      write_file_data write_file_inst07(
           .clk(clk5),
           .rst_n(rst_n),
           .host_wr_id(host_wr7_id),
           .local_clock(local_clock),
           .RXD(RXD_07),
           .RXDV(RXDV_07)
      );    

endmodule