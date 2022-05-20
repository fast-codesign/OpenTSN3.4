// Copyright (C) 1953-2022 NUDT
// Verilog module name - command_parse_hcp 
// Version: V3.4.0.20220228
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module command_parse_hcp
(
        i_clk,
        i_rst_n,
       
        iv_command,
	    i_command_wr,    

        o_hrg_wr,
        ov_hrg_wdata,
        ov_hrg_addr,
        o_hrg_addr_fix,        
        o_hrg_rd,

        o_ost_wr,
        ov_ost_wdata,
        ov_ost_addr,
        o_ost_addr_fix,        
        o_ost_rd,

        o_tft_wr,
        ov_tft_wdata,
        ov_tft_addr,
        o_tft_addr_fix,        
        o_tft_rd,
        
        o_cc_wr,
        ov_cc_wdata,
        ov_cc_addr,
        o_cc_addr_fix,        
        o_cc_rd,

        o_osm_wr,
        ov_osm_wdata,
        ov_osm_addr,
        o_osm_addr_fix,        
        o_osm_rd        
);


// I/O
// i_clk & rst
input                  i_clk;
input                  i_rst_n;      
//nmac data
input      [63:0]      iv_command;               
input                  i_command_wr;             

output reg             o_hrg_wr;
output reg [31:0]      ov_hrg_wdata;
output reg [18:0]      ov_hrg_addr; 
output reg             o_hrg_addr_fix;       
output reg             o_hrg_rd;

output reg             o_ost_wr;
output reg [31:0]      ov_ost_wdata;
output reg [18:0]      ov_ost_addr; 
output reg             o_ost_addr_fix;       
output reg             o_ost_rd; 

output reg             o_tft_wr;
output reg [31:0]      ov_tft_wdata;
output reg [18:0]      ov_tft_addr; 
output reg             o_tft_addr_fix;       
output reg             o_tft_rd; 

output reg             o_cc_wr;
output reg [31:0]      ov_cc_wdata;
output reg [18:0]      ov_cc_addr; 
output reg             o_cc_addr_fix;       
output reg             o_cc_rd; 

output reg             o_osm_wr;
output reg [31:0]      ov_osm_wdata;
output reg [18:0]      ov_osm_addr; 
output reg             o_osm_addr_fix;       
output reg             o_osm_rd;
//***************************************************
//               command parse
//***************************************************
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        o_hrg_wr        <= 1'b0;
        ov_hrg_wdata    <= 32'b0;
        ov_hrg_addr     <= 19'b0;
        o_hrg_addr_fix  <= 1'b0;
        o_hrg_rd        <= 1'b0;

        o_ost_wr        <= 1'b0;
        ov_ost_wdata    <= 32'b0;
        ov_ost_addr     <= 19'b0;
        o_ost_addr_fix  <= 1'b0;
        o_ost_rd        <= 1'b0;

        o_tft_wr        <= 1'b0;
        ov_tft_wdata    <= 32'b0;
        ov_tft_addr     <= 19'b0;
        o_tft_addr_fix  <= 1'b0;
        o_tft_rd        <= 1'b0;
        
        o_cc_wr         <= 1'b0;
        ov_cc_wdata     <= 32'b0;
        ov_cc_addr      <= 19'b0;
        o_cc_addr_fix   <= 1'b0;
        o_cc_rd         <= 1'b0;        

        o_osm_wr        <= 1'b0;
        ov_osm_wdata    <= 32'b0;
        ov_osm_addr     <= 19'b0;
        o_osm_addr_fix  <= 1'b0;
        o_osm_rd        <= 1'b0;       
    end
    else begin
        if(i_command_wr)begin
            if(iv_command[57:51] == 7'd0)begin//hrg     
                ov_hrg_wdata    <= iv_command[31:0];
                ov_hrg_addr     <= iv_command[50:32];
                o_hrg_addr_fix  <= iv_command[61];
                if(iv_command[63:62] == 2'b00)begin//write
                    o_hrg_wr        <= 1'b1;
                    o_hrg_rd        <= 1'b0;      
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_hrg_wr        <= 1'b0;
                    o_hrg_rd        <= 1'b1;                 
                end
                else begin
                    o_hrg_wr        <= 1'b0;
                    o_hrg_rd        <= 1'b0;                   
                end
            end
            else if(iv_command[57:51] == 7'd1)begin//ost     
                ov_ost_wdata    <= iv_command[31:0];
                ov_ost_addr     <= iv_command[50:32];
                o_ost_addr_fix  <= iv_command[61];
                if(iv_command[63:62] == 2'b00)begin//write
                    o_ost_wr        <= 1'b1;
                    o_ost_rd        <= 1'b0;      
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_ost_wr        <= 1'b0;
                    o_ost_rd        <= 1'b1;                 
                end
                else begin
                    o_ost_wr        <= 1'b0;
                    o_ost_rd        <= 1'b0;                   
                end
            end
            else if(iv_command[57:51] == 7'd2)begin//cc     
                ov_cc_wdata    <= iv_command[31:0];
                ov_cc_addr     <= iv_command[50:32];
                o_cc_addr_fix  <= iv_command[61];
                if(iv_command[63:62] == 2'b00)begin//write
                    o_cc_wr        <= 1'b1;
                    o_cc_rd        <= 1'b0;      
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_cc_wr        <= 1'b0;
                    o_cc_rd        <= 1'b1;                 
                end
                else begin
                    o_cc_wr        <= 1'b0;
                    o_cc_rd        <= 1'b0;                   
                end
            end             
            else if(iv_command[57:51] == 7'd3)begin//tft     
                ov_tft_wdata    <= iv_command[31:0];
                ov_tft_addr     <= iv_command[50:32];
                o_tft_addr_fix  <= iv_command[61];
                if(iv_command[63:62] == 2'b00)begin//write
                    o_tft_wr        <= 1'b1;
                    o_tft_rd        <= 1'b0;      
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_tft_wr        <= 1'b0;
                    o_tft_rd        <= 1'b1;                 
                end
                else begin
                    o_tft_wr        <= 1'b0;
                    o_tft_rd        <= 1'b0;                   
                end
            end           
            else if(iv_command[57:51] == 7'd4)begin//osm     
                ov_osm_wdata    <= iv_command[31:0];
                ov_osm_addr     <= iv_command[50:32];
                o_osm_addr_fix  <= iv_command[61];
                if(iv_command[63:62] == 2'b00)begin//write
                    o_osm_wr        <= 1'b1;
                    o_osm_rd        <= 1'b0;      
                end
                else if(iv_command[63:62] == 2'b10)begin//read
                    o_osm_wr        <= 1'b0;
                    o_osm_rd        <= 1'b1;                 
                end
                else begin
                    o_osm_wr        <= 1'b0;
                    o_osm_rd        <= 1'b0;                   
                end
            end            
            else begin
                o_hrg_wr        <= 1'b0;
                ov_hrg_wdata    <= 32'b0;
                ov_hrg_addr     <= 19'b0;
                o_hrg_addr_fix  <= 1'b0;
                o_hrg_rd        <= 1'b0;

                o_ost_wr        <= 1'b0;
                ov_ost_wdata    <= 32'b0;
                ov_ost_addr     <= 19'b0;
                o_ost_addr_fix  <= 1'b0;
                o_ost_rd        <= 1'b0; 

                o_tft_wr        <= 1'b0;
                ov_tft_wdata    <= 32'b0;
                ov_tft_addr     <= 19'b0;
                o_tft_addr_fix  <= 1'b0;
                o_tft_rd        <= 1'b0; 

                o_cc_wr         <= 1'b0;
                ov_cc_wdata     <= 32'b0;
                ov_cc_addr      <= 19'b0;
                o_cc_addr_fix   <= 1'b0;
                o_cc_rd         <= 1'b0; 
                
                o_osm_wr        <= 1'b0;
                ov_osm_wdata    <= 32'b0;
                ov_osm_addr     <= 19'b0;
                o_osm_addr_fix  <= 1'b0;
                o_osm_rd        <= 1'b0;                 
            end
        end      
        else begin
            o_hrg_wr        <= 1'b0;
            ov_hrg_wdata    <= 32'b0;
            ov_hrg_addr     <= 19'b0;
            o_hrg_addr_fix  <= 1'b0;
            o_hrg_rd        <= 1'b0;

            o_ost_wr        <= 1'b0;
            ov_ost_wdata    <= 32'b0;
            ov_ost_addr     <= 19'b0;
            o_ost_addr_fix  <= 1'b0;
            o_ost_rd        <= 1'b0; 

            o_tft_wr        <= 1'b0;
            ov_tft_wdata    <= 32'b0;
            ov_tft_addr     <= 19'b0;
            o_tft_addr_fix  <= 1'b0;
            o_tft_rd        <= 1'b0; 
            
            o_cc_wr         <= 1'b0;
            ov_cc_wdata     <= 32'b0;
            ov_cc_addr      <= 19'b0;
            o_cc_addr_fix   <= 1'b0;
            o_cc_rd         <= 1'b0;             

            o_osm_wr        <= 1'b0;
            ov_osm_wdata    <= 32'b0;
            ov_osm_addr     <= 19'b0;
            o_osm_addr_fix  <= 1'b0;
            o_osm_rd        <= 1'b0; 
        end
    end
end    
endmodule
    