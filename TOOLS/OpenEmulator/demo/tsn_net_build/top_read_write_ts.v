module top_read_write_ts#(
    parameter PLATFORM = "MODELSIM"
)(
    input clk,
    input rst_n,

    input [31:0] local_clock,
    
    input [3:0] host_r8_id,

    input [3:0] host_wr8_id,
    
    input [7:0] RXD_08,
    input RXDV_08,


    output wire[7:0] TXD_08,
    output wire TX_EN_08

);
                                      //wire [7:0] r2b00,r2b01,r2b02,r2b03;
                                      // wire temp00,temp01,temp02,temp03;
 //***************************************************
//                  Module Instance
//***************************************************
 
     read_file_ts  read_file_inst08(
          
           .clk(clk),
           .rst_n(rst_n),
           .host_r_id(host_r8_id),
           .local_clock(local_clock),
           .TXD(TXD_08),
           .TX_EN(TX_EN_08)
      );

     ////////////////////////////
 
    write_file_ts write_file_inst08(
           .clk(clk),
           .rst_n(rst_n),
           .host_wr_id(host_wr8_id),
           .local_clock(local_clock),
           .RXD(RXD_08),
           .RXDV(RXDV_08)
      );      

endmodule