module afifo (
        clk_push,               // Push domain clk input    
        rst_push_n,             // Push domain active low async reset   
        init_push_n,            // Push domain active low sync reset
        push_req_n,             // Push domain active high push reqest
        push_empty,             // Push domain Empty status flag
        push_ae,                // Push domain Almost Empty status flag
        push_hf,                // Push domain Half full status flag
        push_af,                // Push domain Almost full status flag
        push_full,              // Push domain Full status flag
        push_error,             // Push domain Error status flag
        push_word_count,        // Push domain word count
        we_n,                   // Push domain active low RAM write enable
        wr_addr,                // Push domain RAM write address

        clk_pop,                // Pop domain clk input
        rst_pop_n,              // Pop domain active low async reset
        init_pop_n,             // Pop domain active low sync reset
        pop_req_n,              // Pop domain active high pop request
        pop_empty,              // Pop domain Empty status flag
        pop_ae,                 // Pop domain Almost Empty status flag
        pop_hf,                 // Pop domain Half full status flag
        pop_af,                 // Pop domain Almost full status flag
        pop_full,               // Pop domain Full status flag
        pop_error,              // Pop domain Error status flag
        pop_word_count,         // Pop domain word count
        re_n,                   // Pop domain RAM read enable
        rd_addr,                // Pop domain RAM read address
        rd_addr_next,           // Pop domain RAM read the next address
        test                    // Scan test control input
        );

parameter DEPTH         =  8;   // RANGE 4 to 16777216
parameter ADDR_WIDTH    =  3;   // RANGE 2 to 24
parameter COUNT_WIDTH   =  4;   // RANGE 3 to 25
parameter PUSH_AE_LVL   =  2;   // RANGE 1 to DEPTH-1
parameter PUSH_AF_LVL   =  2;   // RANGE 1 to DEPTH-1
parameter POP_AE_LVL    =  2;   // RANGE 1 to DEPTH-1
parameter POP_AF_LVL    =  2;   // RANGE 1 to DEPTH-1
parameter ERR_MODE      =  0;   // RANGE 0 to 1
parameter PUSH_SYNC     =  2;   // RANGE 1 to 3
parameter POP_SYNC      =  2;   // RANGE 1 to 3
parameter TST_MODE      =  0;   // RANGE 0 to 1
   
   

input                           clk_push;       // Push domain clk input
input                           rst_push_n;     // Push domain active low async reset
input                           init_push_n;    // Push domain active low sync reset
input                           push_req_n;     // Push domain active high push reqest
output                          push_empty;     // Push domain Empty status flag
output                          push_ae;        // Push domain Almost Empty status flag
output                          push_hf;        // Push domain Half full status flag
output                          push_af;        // Push domain Almost full status flag
output                          push_full;      // Push domain Full status flag
output                          push_error;     // Push domain Error status flag
output [COUNT_WIDTH-1 : 0]      push_word_count;// Push domain word count
output                          we_n;           // Push domain active low RAM write enable
output [ADDR_WIDTH-1 : 0]       wr_addr;        // Push domain RAM write address

input                           clk_pop;        // Pop domain clk input
input                           rst_pop_n;      // Pop domain active low async reset
input                           init_pop_n;     // Pop domain active low sync reset
input                           pop_req_n;      // Pop domain active high pop request
output                          pop_empty;      // Pop domain Empty status flag
output                          pop_ae;         // Pop domain Almost Empty status flag
output                          pop_hf;         // Pop domain Half full status flag
output                          pop_af;         // Pop domain Almost full status flag
output                          pop_full;       // Pop domain Full status flag
output                          pop_error;      // Pop domain Error status flag
output [COUNT_WIDTH-1 : 0]      pop_word_count; // Pop domain word count
output                          re_n;           // Pop domain RAM read enable
output [ADDR_WIDTH-1 : 0]       rd_addr;        // Pop domain RAM read address
output [ADDR_WIDTH-1 : 0]       rd_addr_next;   // Pop domain RAM read the next address
input                           test;           // Scan test control input

wire [COUNT_WIDTH-1 : 0]        push_addr_g;    // Push domain the address gray

wire [COUNT_WIDTH-1 : 0]        pop_addr_g;     // Pop domain the address gray

    assign we_n = push_full | push_req_n;           // RAM write
    assign re_n = pop_empty | pop_req_n;            // RAM read
// The write domian FIFO control
afifo_gray_sync                                 
 #(DEPTH, ADDR_WIDTH, COUNT_WIDTH, PUSH_AE_LVL,
    PUSH_AF_LVL, ERR_MODE, PUSH_SYNC, 1, TST_MODE) U_PUSH_FIFOFCTL(
    .clk                        (clk_push),
    .rst_n                      (rst_push_n),
    .init_n                     (init_push_n),
    .inc_req_n                  (push_req_n),
    .other_addr_g               (pop_addr_g),
    .word_count                 (push_word_count),
    .empty                      (push_empty),
    .almost_empty               (push_ae),
    .half_full                  (push_hf),
    .almost_full                (push_af),
    .full                       (push_full),
    .error                      (push_error),
    .this_addr                  (wr_addr),
    .this_addr_next             (),
    .this_addr_g                (push_addr_g),
    .next_word_count            (),
    .next_empty_n               (),
    .next_full                  (),
    .next_error                 (),
    .test                       (test)
);
// The read domain FIFO control
afifo_gray_sync
 #(DEPTH, ADDR_WIDTH, COUNT_WIDTH, POP_AE_LVL,
    POP_AF_LVL, ERR_MODE, POP_SYNC, 0, TST_MODE) U_POP_FIFOFCTL(
    .clk                        (clk_pop),
    .rst_n                      (rst_pop_n),
    .init_n                     (init_pop_n),
    .inc_req_n                  (pop_req_n),
    .other_addr_g               (push_addr_g),
    .word_count                 (pop_word_count),
    .empty                      (pop_empty),
    .almost_empty               (pop_ae),
    .half_full                  (pop_hf),
    .almost_full                (pop_af),
    .full                       (pop_full),
    .error                      (pop_error),
    .this_addr                  (rd_addr),
    .this_addr_next             (rd_addr_next),
    .this_addr_g                (pop_addr_g),
    .next_word_count            (),
    .next_empty_n               (),
    .next_full                  (),
    .next_error                 (),
    .test                       (test)
 );

endmodule
