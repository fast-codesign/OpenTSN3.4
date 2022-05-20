// ****************************************************************************
// Copyright        :   NUDT.
// ============================================================================
// FILE NAME        :   AYSNFIFO.v
// CREATE DATE      :   2019-2-9 
// AUTHOR           :   xiongzhiting
// AUTHOR'S EMAIL   :   
// AUTHOR'S TEL     :   
// ============================================================================
// RELEASE  HISTORY     -------------------------------------------------------
// VERSION          DATE                AUTHOR              DESCRIPTION
// WM0.0            2019-2-98           xiongzhiting        Support the scfifo and dcfifo
// ============================================================================
// KEYWORDS         :   FIFO
// ----------------------------------------------------------------------------
// PURPOSE          :   FIFO with configurable data width and fifo depth
// ----------------------------------------------------------------------------
// ============================================================================
// REUSE ISSUES
// Reset Strategy   :   Async clear,active high
// Clock Domains    :   clk
// Critical TiminG  :   N/A
// Instantiations   :   N/A
// Synthesizable    :   N/A
// Others           :   N/A
// ****************************************************************************
module afifo_top
#(parameter
    ShowHead                    = 1,                //1<->Showhead,0<->Normal
    DataWidth                   = 32,               //This is data width
    DataDepth                   = 4,                //for ASYNC,DataDepth must be 2^n (n>=1). for SYNC,DataDepth is a positive number(>=1), RANGE 4 to 16777216
    RAMAddWidth                 = 2,                //RAM address width
    WriteALEmpty                = 1,                //Write-almost-empty, RANGE 1 to DEPTH-1
    WriteALFull                 = 2,                //Write-almost-full, RANGE 1 to DEPTH-1
    ReadALEmpty                 = 1,                //Read-almost-empty, RANGE 1 to DEPTH-1
    ReadALFull                  = 2                 //Read-almost-full, RANGE 1 to DEPTH-1  
   )(
    input                       rd_aclr,            //Reset the all read signal
    input                       wr_aclr,            //Reset the all write signal
    input   [DataWidth-1:0]     data,               //The Inport of data 
    input                       rdclk,              //ASYNC ReadClk
    input                       rdreq,              //active-high
    input                       wrclk,              //ASYNC WriteClk, SYNC use wrclk
    input                       wrreq,              //active-high
    output  [DataWidth-1:0]     q,                  //The output of data
    output                      wrfull,             //Write domain full 
    output                      wralfull,           //Write domain almost-full
    output                      wrempty,            //Write domain empty
    output                      wralempty,          //Write domain almost-full  
    output                      rdfull,             //Read domain full
    output                      rdalfull,           //Read domain almost-full   
    output                      rdempty,            //Read domain empty
    output                      rdalempty,          //Read domain almost-empty
    output  [RAMAddWidth-1:0]   wrusedw,            //Write-usedword
    output  [RAMAddWidth-1:0]   rdusedw,            //Read-usedword
    //RAM control
    output                      Reset,              //The signal of reset, active high
    output                      wrclock,            //ASYNC WriteClk, SYNC use wrclk
    output                      rdclock,            //ASYNC ReadClk
    output  [DataWidth-1:0]     RamData,            //RAM input data
    output                      RamRdreq,           //RAM read request
    output                      RamWrreq,           //RAM write request
    output  [RAMAddWidth-1:0]   rdaddress,          //RAM read address
    output  [RAMAddWidth-1:0]   wraddress,          //RAM write address
    input   [DataWidth-1:0]     Ram_q               //RAM output data
   );
    wire    [RAMAddWidth-1:0]   wr_addr;            // Ram write address
    wire    [RAMAddWidth-1:0]   rd_addr;            // Ram read address
    wire    [RAMAddWidth-1:0]   rd_addr_next;       // Ram read address
    wire                        we_n;
    wire                        re_n;
    wire                        rd_empty;           // Empty signal
    wire    [RAMAddWidth:0]     wr_usedw;           //Write-usedword
    wire    [RAMAddWidth:0]     rd_usedw;           //Read-usedword
    assign  wrusedw             = wr_usedw[RAMAddWidth-1:0];    //change the width
    assign  rdusedw             = rd_usedw[RAMAddWidth-1:0];    //change the width  
    //--------------------
    //ASYNCFIFO control
    //--------------------
    afifo#( 
        .DEPTH                  (DataDepth          ),      // RANGE 4 to 16777216
        .ADDR_WIDTH             (RAMAddWidth        ),      // RANGE 2 to 24
        .COUNT_WIDTH            (RAMAddWidth + 1    ),      // RANGE 3 to 25
        .PUSH_AE_LVL            (WriteALEmpty       ),      // RANGE 1 to DEPTH-1
        .PUSH_AF_LVL            (WriteALFull        ),      // RANGE 1 to DEPTH-1
        .POP_AE_LVL             (ReadALEmpty        ),      // RANGE 1 to DEPTH-1
        .POP_AF_LVL             (ReadALFull         ),      // RANGE 1 to DEPTH-1
        .ERR_MODE               (0                  ),      // RANGE 0 to 1
        .PUSH_SYNC              (2                  ),      // RANGE 1 to 3
        .POP_SYNC               (2                  ),      // RANGE 1 to 3
        .TST_MODE               (0                  )       // RANGE 0 to 1     
    )
    u_afifo(
        .clk_push               (wrclk              ),      // Push domain clk input
        .rst_push_n             (~wr_aclr           ),      // Push domain active low async reset
        .init_push_n            (1'b1               ),      // Push domain active low sync reset
        .push_req_n             (~wrreq             ),      // Push domain active high push reqest
        .push_empty             (wrempty            ),      // Push domain Empty status flag
        .push_ae                (wralempty          ),      // Push domain Almost Empty status flag
        .push_hf                (                   ),      // Push domain Half full status flag
        .push_af                (wralfull           ),      // Push domain Almost full status flag
        .push_full              (wrfull             ),      // Push domain Full status flag
        .push_error             (                   ),      // Push domain Error status flag
        .push_word_count        (wr_usedw           ),      // Push domain word count
        .we_n                   (we_n               ),      // Push domain active low RAM write enable
        .wr_addr                (wr_addr            ),      // Push domain RAM write address

        .clk_pop                (rdclk              ),      // Pop domain clk input
        .rst_pop_n              (~rd_aclr           ),      // Pop domain active low async reset
        .init_pop_n             (1'b1               ),      // Pop domain active low sync reset
        .pop_req_n              (~rdreq             ),      // Pop domain active high pop request
        .pop_empty              (rd_empty           ),      // Pop domain Empty status flag
        .pop_ae                 (rdalempty          ),      // Pop domain Almost Empty status flag
        .pop_hf                 (                   ),      // Pop domain Half full status flag
        .pop_af                 (rdalfull           ),      // Pop domain Almost full status flag
        .pop_full               (rdfull             ),      // Pop domain Full status flag
        .pop_error              (                   ),      // Pop domain Error status flag
        .pop_word_count         (rd_usedw           ),      // Pop domain word count
        .re_n                   (re_n               ),      // Pop domain RAM read enable
        .rd_addr                (rd_addr            ),      // Pop domain RAM read address
        .rd_addr_next           (rd_addr_next       ),      // Pop domain RAM read the next address
        .test                   (1'b0               )       // Scan test control input
    );
    
    // ASYNCFIFO rdempty
    reg     Empty_reg;                                      //The reg is used delay the status signal.
    always@(posedge rdclk or posedge rd_aclr)
        if(rd_aclr)begin
          Empty_reg <= 1'b0;                                //clean signal
        end  
        else begin
          Empty_reg <= rd_empty;                            //delay the Empty_wire 1 cycle
        end

    assign  rdempty             = ShowHead ? (rd_empty | Empty_reg): rd_empty;
    
    //--------------------
    //ASYNCFIFO data
    //--------------------
    assign  Reset               = rd_aclr;                  // Reset signal, active high
    assign  wrclock             = wrclk;                    // Write clock
    assign  rdclock             = rdclk;                    // Read clock   
    assign  RamData             = data;                     // Ram input data
    assign  q                   = Ram_q;                    // Ram output data
    assign  RamWrreq            = ~we_n;                    // Ram write signal
    // Ram write signal
    assign  RamRdreq            = ShowHead ? ~rd_empty : ~re_n;
    // Ram write address
    assign  wraddress           = wr_addr;                  
    // Ram read address
    assign  rdaddress           = ShowHead ? rd_addr_next : rd_addr;
    
endmodule
   
   

   
 