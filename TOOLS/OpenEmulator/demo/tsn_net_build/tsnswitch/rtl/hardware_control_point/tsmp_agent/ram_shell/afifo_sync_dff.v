module afifo_sync_dff (
    clk_d,
    rst_d_n,
    init_d_n,
    data_s,
    test,
    data_d
    );

parameter WIDTH        = 1;  // RANGE 1 to 1024
parameter F_SYNC_TYPE  = 2;  // RANGE 0 to 4
parameter TST_MODE     = 0;  // RANGE 0 to 1
parameter VERIF_EN     = 1;  // RANGE 0 to 4


input                   clk_d;      // clock input from destination domain
input                   rst_d_n;    // active low asynchronous reset from destination domain
input                   init_d_n;   // active low synchronous reset from destination domain
input  [WIDTH-1:0]      data_s;     // data to be synchronized from source domain
input                   test;       // test input
output [WIDTH-1:0]      data_d;     // data synchronized to destination domain


reg    [WIDTH-1:0]      sample_nsyncf;
reg    [WIDTH-1:0]      sample_syncf;
reg    [WIDTH-1:0]      sample_syncm1;
reg    [WIDTH-1:0]      sample_syncm2;
reg    [WIDTH-1:0]      sample_syncl;
reg    [WIDTH-1:0]      test_hold;

wire   [WIDTH-1:0]      tst_mode_selected;
wire   [WIDTH-1:0]      f_sync_type_is_0_data;
wire   [WIDTH-1:0]      next_sample_syncf;
wire   [WIDTH-1:0]      next_sample_syncm1;
wire   [WIDTH-1:0]      next_sample_syncm2;
wire   [WIDTH-1:0]      next_sample_syncl;


  assign tst_mode_selected  = (TST_MODE == 1) ? test_hold : data_s;
  assign f_sync_type_is_0_data  = (test == 1'b1) ? tst_mode_selected : data_s;

  assign next_sample_syncf  = (test == 1'b0) ? data_s : tst_mode_selected;
  assign next_sample_syncm1 = ((F_SYNC_TYPE & 7) == 1) ? sample_nsyncf : sample_syncf;
  assign next_sample_syncm2 = sample_syncm1;
  assign next_sample_syncl  = ((F_SYNC_TYPE & 7) == 3) ? sample_syncm1 : 
                              ((F_SYNC_TYPE & 7) == 4) ? sample_syncm2 : next_sample_syncm1;


  always @ (negedge clk_d or negedge rst_d_n) begin : PROC_negedge_registers
    if (rst_d_n == 1'b0) begin
      sample_nsyncf    <= {WIDTH{1'b0}};
      test_hold        <= {WIDTH{1'b0}};
    end else if (init_d_n == 1'b0) begin
      sample_nsyncf    <= {WIDTH{1'b0}};
      test_hold        <= {WIDTH{1'b0}};
    end else begin
      sample_nsyncf    <= data_s;
      test_hold        <= data_s;
    end
  end


  always @ (posedge clk_d or negedge rst_d_n) begin : PROC_posedge_registers
    if (rst_d_n == 1'b0) begin
      sample_syncf     <= {WIDTH{1'b0}};
      sample_syncm1    <= {WIDTH{1'b0}};
      sample_syncm2    <= {WIDTH{1'b0}};
      sample_syncl     <= {WIDTH{1'b0}};
    end else if (init_d_n == 1'b0) begin
      sample_syncf     <= {WIDTH{1'b0}};
      sample_syncm1    <= {WIDTH{1'b0}};
      sample_syncm2    <= {WIDTH{1'b0}};
      sample_syncl     <= {WIDTH{1'b0}};
    end else begin
      sample_syncf     <= next_sample_syncf;
      sample_syncm1    <= next_sample_syncm1;
      sample_syncm2    <= next_sample_syncm2;
      sample_syncl     <= next_sample_syncl;
    end
  end

  assign data_d = ((F_SYNC_TYPE & 7) == 0) ? f_sync_type_is_0_data : sample_syncl;

endmodule
