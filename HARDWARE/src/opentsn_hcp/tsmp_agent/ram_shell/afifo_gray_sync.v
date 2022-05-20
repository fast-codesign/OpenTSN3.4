module afifo_gray_sync (
        clk,                    // clock input
        rst_n,                  // active low async reset
        init_n,                 // active low sync. reset
        inc_req_n,              // active high request to advance
        other_addr_g,           // Gray pointer form oppos. I/F
        word_count,             // Local word count output
        empty,                  // Empty status flag
        almost_empty,           // Almost Empty status flag
        half_full,              // Half full status flag
        almost_full,            // Almost full status flag
        full,                   // Full status flag
        error,                  // Error status flag
        this_addr,              // Local RAM address
        this_addr_next,         // Next Local RAM address
        this_addr_g,            // Gray coded pointer to other domain
        next_word_count,        // Look ahead word count
        next_empty_n,           // Look ahead empty flag (active low)
        next_full,              // Look ahead full flag
        next_error,             // Look ahead error flag

        test                    // Scan test control input
        );

parameter DEPTH         =  8;   // RANGE 4 to 16777216
parameter ADDR_WIDTH    =  3;   // RANGE 2 to 24
parameter COUNT_WIDTH   =  4;   // RANGE 3 to 25
parameter AE_LVL        =  2;   // RANGE 1 to DEPTH-1
parameter AF_LVL        =  2;   // RANGE 1 to DEPTH-1
parameter ERR_MODE      =  0;   // RANGE 0 to 1, If FIFO is empty/full and read/write, error is high
parameter SYNC_DEPTH    =  2;   // RANGE 1 to 3
parameter IO_MODE       =  1;   // RANGE 0 to 1, 1 is full, 0 is empty
parameter TST_MODE      =  0;   // RANGE 0 to 1
   

input                                 clk;              // clock input
input                                 rst_n;            // active low async reset
input                                 init_n;           // active low sync. reset
input                                 inc_req_n;        // active high request to advance
input  [COUNT_WIDTH-1 : 0]            other_addr_g;     // Gray pointer form oppos. I/F
output [COUNT_WIDTH-1 : 0]            word_count;       // Local word count output
output                                empty;            // Empty status flag
output                                almost_empty;     // Almost Empty status flag
output                                half_full;        // Half full status flag
output                                almost_full;      // Almost full status flag
output                                full;             // Full status flag
output                                error;            // Error status flag
output [ADDR_WIDTH-1 : 0]             this_addr;        // Local RAM address
output [ADDR_WIDTH-1 : 0]             this_addr_next;   // Next Local RAM address
output [COUNT_WIDTH-1 : 0]            this_addr_g;      // Gray coded pointer to other domain
output [COUNT_WIDTH-1 : 0]            next_word_count;  // Look ahead word count
output                                next_empty_n;     // Look ahead empty flag (active low)
output                                next_full;        // Look ahead full flag
output                                next_error;       // Look ahead error flag

input                                 test;             // Scan test control input

wire [COUNT_WIDTH-1 : 0]              a_empty_vector;   
wire [COUNT_WIDTH-1 : 0]              a_full_vector;    
wire [COUNT_WIDTH-1 : 0]              hlf_full_vector;  
wire [COUNT_WIDTH-1 : 0]              full_count_bus;   
wire [COUNT_WIDTH-1 : 0]              bus_low;          
wire [COUNT_WIDTH-1 : 0]              residual_value_bus;
//wire [COUNT_WIDTH-1 : 0]              offset_residual_bus;
wire [COUNT_WIDTH-1 : 0]              start_value_bus;
//wire [COUNT_WIDTH-1 : 0]              end_value_bus;
wire [COUNT_WIDTH-1 : 0]              start_value_gray_bus;

//wire                                  tie_low;
//wire                                  tie_high;
wire [COUNT_WIDTH-1 : 0]              next_count_int;
wire [ADDR_WIDTH-1 : 0]               next_this_addr_int;
wire [COUNT_WIDTH-1 : 0]              next_this_addr_g_int;
wire                                  next_empty_int;
wire                                  next_almost_empty_int;
wire                                  next_half_full_int;
wire                                  next_almost_full_int;
wire                                  next_full_int;

wire                                  next_almost_empty;
wire                                  next_half_full;
wire                                  next_almost_full;
wire                                  error_seen;
wire                                  next_error_int;

wire [COUNT_WIDTH-1 : 0]              count;

wire                                  next_empty;

wire [COUNT_WIDTH-1 : 0]              sync;
wire [COUNT_WIDTH-1 : 0]              other_addr_g_sync;

wire [COUNT_WIDTH-1 : 0]              next_this_addr_g;
wire [COUNT_WIDTH-1 : 0]              other_addr_decoded;

wire                                  advance;
wire [COUNT_WIDTH-1 : 0]              succesive_count;
wire [ADDR_WIDTH-1 : 0]               succesive_addr;

wire [COUNT_WIDTH-1 : 0]              advanced_count;
reg  [COUNT_WIDTH-1 : 0]              next_word_count_int;
wire [ADDR_WIDTH-1 : 0]               next_this_addr;

wire [COUNT_WIDTH : 0]                temp1;

wire [COUNT_WIDTH-1 : 0]              wrd_count_p1;

wire [COUNT_WIDTH-1 : 0]              wr_addr;
wire [COUNT_WIDTH-1 : 0]              rd_addr;

wire                                  at_end;
//wire                                  at_end_n;

reg [COUNT_WIDTH-1 : 0]               count_int;
reg [ADDR_WIDTH-1 : 0]                this_addr_int;
reg [COUNT_WIDTH-1 : 0]               this_addr_g_int;
reg [COUNT_WIDTH-1 : 0]               word_count_int;
 
reg                                   empty_int;
reg                                   almost_empty_int;
reg                                   half_full_int;
reg                                   almost_full_int;
reg                                   full_int;
reg                                   error_int;

reg [COUNT_WIDTH-1 : 0]               this_addr_g_ltch;


  assign a_empty_vector        = AE_LVL;                            // All most empty
  assign hlf_full_vector       = ((DEPTH  +  1)/ 2);                // All most full
  assign a_full_vector         = (DEPTH  - AF_LVL);                 // Half full
  assign full_count_bus        = DEPTH;                             // Full
  assign bus_low               = {COUNT_WIDTH{1'b0}};               // Empty
  assign residual_value_bus    = ((1 << COUNT_WIDTH) - ((DEPTH == (1 << (COUNT_WIDTH - 1)))? (DEPTH * 2) : 
                                 ((DEPTH + 2) - (DEPTH & 1))));     
//  assign offset_residual_bus   = ((((((1 << COUNT_WIDTH) - ((DEPTH == (1 << (COUNT_WIDTH - 1)))? (DEPTH * 2) : 
//                                 ((DEPTH + 2) - (DEPTH & 1)))))/2))); 
  assign start_value_bus       = (((((1 << COUNT_WIDTH) - ((DEPTH == (1 << (COUNT_WIDTH - 1)))? (DEPTH * 2) : 
                                 ((DEPTH + 2) - (DEPTH & 1)))))/2));
//  assign end_value_bus         = (((1 << COUNT_WIDTH) -  1 - (((((1 << COUNT_WIDTH) - ((DEPTH == (1 << (COUNT_WIDTH - 1)))? (DEPTH * 2) : 
//                                 ((DEPTH + 2) - (DEPTH & 1)))))/2))));
  assign start_value_gray_bus  = (start_value_bus  ^ (start_value_bus >> 1));
 
//  assign tie_low               = 1'b0;
//  assign tie_high              = 1'b1;

  assign next_almost_empty     = (next_word_count_int <= a_empty_vector) ? 1'b1 : 1'b0;     // Next status signal
  assign next_half_full        = (next_word_count_int >= hlf_full_vector) ? 1'b1 : 1'b0;    // Next status signal
  assign next_almost_full      = (next_word_count_int >= a_full_vector) ? 1'b1 : 1'b0;      // Next status signal
  assign next_empty            = (next_word_count_int == bus_low) ? 1'b1 : 1'b0;            // Next status signal
  assign next_full_int         = (next_word_count_int == full_count_bus) ? 1'b1 : 1'b0;     // Next status signal

  assign error_seen            = !inc_req_n && at_end;                                      // If FIFO is full and read/write, error is high
  assign next_error_int        = (ERR_MODE == 0) ? (error_seen || error_int) : error_seen;  // 1 is Holding the error signal, 0 isn't

  assign next_count_int        = advanced_count ^ start_value_bus;                          // Next counter value
  assign next_this_addr_int    = next_this_addr;                                            // Next address value
  assign this_addr_next        = next_this_addr;                                            // Next address value
  assign next_this_addr_g_int  = next_this_addr_g ^ start_value_gray_bus;                   // Next address value with gray
  assign next_empty_int        = ~next_empty;                                               // The empty signal, active low
  assign next_almost_empty_int = ~next_almost_empty;                                        // The almost-empty, active low
  assign next_half_full_int    = next_half_full;                                            // The next half full signal
  assign next_almost_full_int  = next_almost_full;                                          // The next almost-full signal
// Restore the signal or counter
  always @ (posedge clk or negedge rst_n) begin
     if (!rst_n) begin
       count_int <= {COUNT_WIDTH{1'b0}};
       this_addr_int <= {ADDR_WIDTH{1'b0}};
       this_addr_g_int <= {COUNT_WIDTH{1'b0}};
       word_count_int <= {COUNT_WIDTH{1'b0}};
       empty_int <= 1'b0;
       almost_empty_int <= 1'b0;
       half_full_int <= 1'b0;
       almost_full_int <= 1'b0;
       full_int <= 1'b0;
       error_int <= 1'b0;
     end else if (!init_n) begin
       count_int <= {COUNT_WIDTH{1'b0}};
       this_addr_int <= {ADDR_WIDTH{1'b0}};
       this_addr_g_int <= {COUNT_WIDTH{1'b0}};
       word_count_int <= {COUNT_WIDTH{1'b0}};
       empty_int <= 1'b0;
       almost_empty_int <= 1'b0;
       half_full_int <= 1'b0;
       almost_full_int <= 1'b0;
       full_int <= 1'b0;
       error_int <= 1'b0;
     end else begin
       count_int <= next_count_int ;
       this_addr_int <= next_this_addr_int ;
       this_addr_g_int <= next_this_addr_g_int ;
       word_count_int <= next_word_count_int ;
       empty_int <= next_empty_int;
       almost_empty_int <= next_almost_empty_int;
       half_full_int <= next_half_full_int;
       almost_full_int <= next_almost_full_int;
       full_int <= next_full_int;
       error_int <= next_error_int;
     end
    end
//The RAM address
  assign this_addr          = ((1<<COUNT_WIDTH) != (DEPTH*2)) ?
                              this_addr_int :
                              count;
//The gray address with synchroniz
  assign other_addr_g_sync  = sync ^ start_value_gray_bus;
//The counter address
  assign count              = count_int ^ start_value_bus;
  assign word_count         = word_count_int;
//The status signal
  assign empty              = ~empty_int;
  assign almost_empty       = ~almost_empty_int;
  assign half_full          = half_full_int;
  assign almost_full        = almost_full_int;
  assign full               = full_int;
  assign error              = error_int;
//The full or empty signal
  assign at_end             = (IO_MODE == 1) ? full_int : ~empty_int;
//  assign at_end_n           = (IO_MODE == 1) ? ~full_int : empty_int;
//The next signal
  assign next_word_count    = init_n ? next_word_count_int : ({(COUNT_WIDTH-1){1'b0}});
  assign next_empty_n       = ~next_empty && init_n;
  assign next_full          = next_full_int && init_n;
  assign next_error         = next_error_int && init_n;

// Clock synchronizer
  afifo_sync_dff
   #(COUNT_WIDTH, SYNC_DEPTH, TST_MODE, 1) U_sync(
    .clk_d(clk),
    .rst_d_n(rst_n),
    .init_d_n(init_n),
    .data_s(other_addr_g),
    .test(test),
    .data_d(sync) );

//binary change to gray 
  function [COUNT_WIDTH-1:0] func_bin2gray ;
    input [COUNT_WIDTH-1:0]             B;
    begin 
      func_bin2gray  = B ^ { 1'b0, B[COUNT_WIDTH-1 : 1] }; 
    end
  endfunction

  assign next_this_addr_g = func_bin2gray (advanced_count);

//gray change to binary
  function [COUNT_WIDTH-1:0] func_gray2bin ;
    input [COUNT_WIDTH-1:0]             G;
    reg   [COUNT_WIDTH-1:0]             b;
    reg   [31:0]                i;
    begin 
      b = {G[COUNT_WIDTH-1], {COUNT_WIDTH-1{1'b0}}};
      for (i=0 ; i<(COUNT_WIDTH-1) ; i=i+1) begin
        b [COUNT_WIDTH - 2 - i] = G[COUNT_WIDTH - 2 - i] ^ b [COUNT_WIDTH - 1 - i];
      end
      func_gray2bin  = b; 
    end
  endfunction

  assign other_addr_decoded = func_gray2bin (other_addr_g_sync);
// Read/Write protect
  assign advance            = ~inc_req_n && ~at_end;                        
//The address computer
  assign succesive_count = ((((1 << COUNT_WIDTH) - DEPTH) == DEPTH) || (this_addr_int != ((DEPTH == (1 << (COUNT_WIDTH - 1)))? (DEPTH * 2) : 
                           ((DEPTH + 2) - (DEPTH & 1)))-1))? count+1 : start_value_bus;
  assign succesive_addr  = ((((1 << COUNT_WIDTH) - DEPTH) == DEPTH) || (this_addr_int != ((DEPTH == (1 << (COUNT_WIDTH - 1)))? (DEPTH * 2) : 
                           ((DEPTH + 2) - (DEPTH & 1)))-1))? this_addr_int+1 : {ADDR_WIDTH{1'b0}};
//The address send
  assign advanced_count = (advance == 1'b1)? succesive_count : count;
  assign next_this_addr = (advance == 1'b1)? succesive_addr : this_addr_int;
//The usedword computer
  assign temp1              = wr_addr - rd_addr;
  assign wrd_count_p1       = temp1[COUNT_WIDTH-1 : 0];

  always @(wrd_count_p1 or residual_value_bus or rd_addr or wr_addr) begin
    if ((1<<COUNT_WIDTH) != (DEPTH*2)) begin
      if (rd_addr > wr_addr)
        next_word_count_int = wrd_count_p1 - residual_value_bus;
      else
        next_word_count_int = wrd_count_p1;
    end else begin
      next_word_count_int = wrd_count_p1;
    end
  end
//The read and write RAM address
  assign rd_addr        = (IO_MODE == 1) ? other_addr_decoded : advanced_count;
  assign wr_addr        = (IO_MODE == 1) ? advanced_count : other_addr_decoded;
//Gray coded pointer to other domain
  assign this_addr_g = ((TST_MODE == 2) ?
                        ((test == 1'b1) ? this_addr_g_ltch : this_addr_g_int) :
                        this_addr_g_int);
   always @(clk or this_addr_g_int) begin : PROC_scan_capture_hold_latch
    if (clk == 1'b0)
      this_addr_g_ltch <= this_addr_g_int;
   end

endmodule
