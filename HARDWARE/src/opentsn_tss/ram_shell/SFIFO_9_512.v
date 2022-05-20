// Copyright (C) 1953-2020 NUDT
// Verilog module name - SFIFO_9_512 
// Version: SFIFO_9_512_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         SYNC FIFO with 9 bits data width and 512 fifo depth
//             - xxx: xxx
///////////////////////////////////////////////////////////////////////////
module SFIFO_9_512
(
    aclr,                                           //Reset the all signal(active high)
    data,                                           //The Inport of data 
    rdreq,                                          //active-high
    clk,                                            //ASYNC WriteClk, SYNC use wrclk
    wrreq,                                          //active-high
    q,                                              //The output of data
    wrfull,                                         //Write domain full 
    wralfull,                                       //Write domain almost-full
    wrempty,                                        //Write domain empty
    wralempty,                                      //Write domain almost-full  
    rdfull,                                         //Read domain full
    rdalfull,                                       //Read domain almost-full   
    rdempty,                                        //Read domain empty
    rdalempty,                                      //Read domain almost-empty
    wrusedw,                                        //Write-usedword
    rdusedw                                         //Read-usedword
);
    parameter   ShowHead        =   1;              //1<->Showhead,0<->Normal
    parameter   DataWidth       =   9;              //This is data width
    parameter   DataDepth       =   512;            //for ASYNC,DataDepth must be 2^n (n>=1). for SYNC,DataDepth is a positive number(>=1), RANGE 4 to 16777216
    parameter   RAMAddWidth     =   9;              //RAM address width
    parameter   WriteALEmpty    =   2;              //Write-almost-empty, RANGE 1 to DEPTH-1
    parameter   WriteALFull     =   1;              //Write-almost-full, RANGE 1 to DEPTH-1. 1:when wrusedw= DEPTH-1,WriteALFull will high.
    parameter   ReadALEmpty     =   2;              //Read-almost-empty, RANGE 1 to DEPTH-1
    parameter   ReadALFull      =   1;              //Read-almost-full, RANGE 1 to DEPTH-1

    input                       aclr;               //Reset the all signal
    input   [DataWidth-1:0]     data;               //The Inport of data 
    input                       rdreq;              //active-high
    input                       clk;                //ASYNC WriteClk, SYNC use wrclk
    input                       wrreq;              //active-high
    output  [DataWidth-1:0]     q;                  //The output of data
    output                      wrfull;             //Write domain full 
    output                      wralfull;           //Write domain almost-full
    output                      wrempty;            //Write domain empty
    output                      wralempty;          //Write domain almost-full  
    output                      rdfull;             //Read domain full
    output                      rdalfull;           //Read domain almost-full   
    output                      rdempty;            //Read domain empty
    output                      rdalempty;          //Read domain almost-empty
    output  [RAMAddWidth-1:0]   wrusedw;            //Write-usedword
    output  [RAMAddWidth-1:0]   rdusedw;            //Read-usedword
    //connect the ram
    wire                        ram_Reset;      
    wire                        ram_wrclock;
    wire                        ram_rdclock;
    wire    [DataWidth-1:0]     ram_RamData;    
    wire                        ram_RamRdreq;   
    wire                        ram_RamWrreq;   
    wire    [RAMAddWidth-1:0]   ram_rdaddress;  
    wire    [RAMAddWidth-1:0]   ram_wraddress;  
    wire    [DataWidth-1:0]     ram_Ram_q;

    afifo_top
    #(      .ShowHead           (ShowHead                   ),  //show head model,1<->show head,0<->normal
            .DataWidth          (DataWidth                  ),  //This is data width
            .DataDepth          (DataDepth                  ),  //for ASYNC,DataDepth must be 2^n (n>=1). for SYNC,DataDepth is a positive number(>=1)
            .RAMAddWidth        (RAMAddWidth                ),  //RAM address width, RAMAddWidth= log2(DataDepth).
            .WriteALEmpty       (WriteALEmpty               ),  //Write-almost-empty, RANGE 1 to DEPTH-1
            .WriteALFull        (WriteALFull                ),  //Write-almost-full, RANGE 1 to DEPTH-1 
            .ReadALEmpty        (ReadALEmpty                ),  //Read-almost-empty, RANGE 1 to DEPTH-1
            .ReadALFull         (ReadALFull                 )   //Read-almost-full, RANGE 1 to DEPTH-1  
    )dcfifo(
            .rd_aclr            (aclr                       ),  //Reset the all signal, active high
            .wr_aclr            (aclr                       ),  //Reset the all signal, active high
            .data               (data                       ),  //The Inport of data 
            .rdclk              (clk                        ),  //ASYNC ReadClk
            .rdreq              (rdreq                      ),  //active-high
            .wrclk              (clk                        ),  //ASYNC WriteClk, SYNC use wrclk
            .wrreq              (wrreq                      ),  //active-high
            .q                  (q                          ),  //The Outport of data
            .wrfull             (wrfull                     ),  //Write domain full 
            .wralfull           (wralfull                   ),  //Write domain almost-full
            .wrempty            (wrempty                    ),  //Write domain empty
            .wralempty          (wralempty                  ),  //Write domain almost-full  
            .rdfull             (rdfull                     ),  //Read domain full
            .rdalfull           (rdalfull                   ),  //Read domain almost-full   
            .rdempty            (rdempty                    ),  //Read domain empty
            .rdalempty          (rdalempty                  ),  //Read domain almost-empty
            .wrusedw            (wrusedw                    ),  //Write-usedword
            .rdusedw            (rdusedw                    ),  //Read-usedword
            .Reset              (ram_Reset                  ),  //The signal of reset, active high
            .wrclock            (ram_wrclock                ),  //ASYNC WriteClk, SYNC use wrclk
            .rdclock            (ram_rdclock                ),  //ASYNC ReadClk
            .RamData            (ram_RamData                ),  //RAM input data
            .RamRdreq           (ram_RamRdreq               ),  //RAM read request
            .RamWrreq           (ram_RamWrreq               ),  //RAM write request
            .rdaddress          (ram_rdaddress              ),  //RAM read address
            .wraddress          (ram_wraddress              ),  //RAM write address
            .Ram_q              (ram_Ram_q                  )   //RAM output data           
    );

    sdprf512x9_s sdprf512x9_s_inst(
                    .aclr       (ram_Reset                  ),  //asynchronous reset(high active)
                    .clock      (ram_wrclock                ),  //ASYNC WriteClk, SYNC use wrclk
                    .data       (ram_RamData                ),  //RAM input data
                    .rdaddress  (ram_rdaddress              ),  //RAM read address
                    .rden       (ram_RamRdreq               ),  //RAM read request
                    .wraddress  (ram_wraddress              ),  //RAM write address
                    .wren       (ram_RamWrreq               ),  //RAM write request
                    .q          (ram_Ram_q                  )   //RAM output data
                );                              

endmodule
   
   

   
 