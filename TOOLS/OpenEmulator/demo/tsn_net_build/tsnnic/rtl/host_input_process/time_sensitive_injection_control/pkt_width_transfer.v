// Copyright (C) 1953-2021 NUDT
// Verilog module name - pkt_width_transfer
// Version: V3.2.3.20210831
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         cache pkt with two regs and discard pkt if not get new bufid.
//         monitor traffic base on the threshold_value
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module pkt_width_transfer
(
       i_clk,
       i_rst_n,
       
       iv_data,
       i_data_wr,
	   i_pkt_bufid_wr,
       iv_bufid,
       
       ov_data1,
       o_data1_write_flag,
       ov_data2,
       o_data2_write_flag,
       ov_bufid
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;  
// pkt input
input      [8:0]       iv_data;
input                  i_data_wr;
input      [8:0]       iv_bufid;
input                  i_pkt_bufid_wr;

output reg [133:0]     ov_data1;
output reg             o_data1_write_flag;
output reg [133:0]     ov_data2;
output reg             o_data2_write_flag;
output reg [8:0]       ov_bufid;
//***************************************************
//               cache pkt 
//***************************************************
// internal reg&wire for state machine
reg        [3:0]       rv_pkt_cnt;
reg        [2:0]       pkt_state;
localparam  CACHE_IDLE_S = 3'd0,
            WRITE_REG1_S = 3'd1,
            WRITE_REG2_S = 3'd2;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        ov_data1 <= 134'b0;
        o_data1_write_flag <= 1'b0; 
        ov_data2 <= 134'b0;
        o_data2_write_flag <= 1'b0; 
        rv_pkt_cnt <= 4'b0;
        
        pkt_state <= CACHE_IDLE_S;
    end
    else begin
        case(pkt_state)
            CACHE_IDLE_S:begin
                o_data1_write_flag <= 1'b0;
                o_data2_write_flag <= 1'b0;  
                ov_data2 <= ov_data2;
                if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //first byte
                    ov_data1[133:132] <= 2'b01;
                    ov_data1[131:128] <= 4'b0000;
                    ov_data1[127:120] <= iv_data[7:0];  
                    rv_pkt_cnt <= rv_pkt_cnt + 1'b1;
                    pkt_state <= WRITE_REG1_S;                     
                end
                else begin
                    ov_data1 <= ov_data1;
                    rv_pkt_cnt <= 4'b0; 
                    pkt_state <= CACHE_IDLE_S;                  
                end
            end           
            WRITE_REG1_S:begin
                o_data2_write_flag <= 1'b0;         
                if(i_data_wr == 1'b1)begin 
                    rv_pkt_cnt <= rv_pkt_cnt + 4'd1;
                end
                else begin
                    rv_pkt_cnt <= rv_pkt_cnt;
                end
                case(rv_pkt_cnt)
                    4'd0:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;//pkt last flag
                            ov_data1[131:128] <= 4'b1111;//invalid number of bytes,just 1 byte valid
                            ov_data1[127:120] <= iv_data[7:0];
                            ov_data1[119:0] <= 120'b0;
                            o_data1_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[133:132] <= 2'b11;//pkt middle flag
                            ov_data1[131:128] <= 4'b0000;
                            ov_data1[127:120] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end 
                    4'd1:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;
                            ov_data1[131:128] <= 4'b1110;//invalid number of bytes,just 2 byte valid
                            ov_data1[119:112] <= iv_data[7:0];
                            ov_data1[111:0] <= 112'b0;
                            o_data1_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[119:112] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end                                         
                    4'd2:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;
                            ov_data1[131:128] <= 4'b1101;//invalid number of bytes,just 3 byte valid
                            ov_data1[111:104] <= iv_data[7:0];
                            ov_data1[103:0] <= 104'b0;
                            o_data1_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[111:104] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end         
                    4'd3:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;
                            ov_data1[131:128] <= 4'b1100;//invalid number of bytes,just 4 byte valid
                            ov_data1[103:96] <= iv_data[7:0];
                            ov_data1[95:0] <= 96'b0;
                            o_data1_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[103:96] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end 
                    4'd4:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;
                            ov_data1[131:128] <= 4'b1011;//invalid number of bytes,just 5 byte valid
                            ov_data1[95:88] <= iv_data[7:0];
                            ov_data1[87:0] <= 88'b0;
                            o_data1_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[95:88] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end     
                    4'd5:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;
                            ov_data1[131:128] <= 4'b1010;//invalid number of bytes,just 6 byte valid
                            ov_data1[87:80] <= iv_data[7:0];
                            ov_data1[79:0] <= 80'b0;
                            o_data1_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[87:80] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end     
                    4'd6:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;
                            ov_data1[131:128] <= 4'b1001;//invalid number of bytes,just 7 byte valid
                            ov_data1[79:72] <= iv_data[7:0];
                            ov_data1[71:0] <= 72'b0;
                            o_data1_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[79:72] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end     
                    4'd7:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;
                            ov_data1[131:128] <= 4'b1000;//invalid number of bytes,just 8 byte valid
                            ov_data1[71:64] <= iv_data[7:0];
                            ov_data1[63:0] <= 64'b0;
                            o_data1_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[71:64] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end 
                    4'd8:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;
                            ov_data1[131:128] <= 4'b0111;//invalid number of bytes,just 9 byte valid
                            ov_data1[63:56] <= iv_data[7:0];
                            ov_data1[55:0] <= 56'b0;
                            o_data1_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[63:56] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end     
                    4'd9:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;
                            ov_data1[131:128] <= 4'b0110;//invalid number of bytes,just 10 byte valid
                            ov_data1[55:48] <= iv_data[7:0];
                            ov_data1[47:0] <= 48'b0;
                            o_data1_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[55:48] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end     
                    4'd10:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;
                            ov_data1[131:128] <= 4'b0101;//invalid number of bytes,just 11 byte valid
                            ov_data1[47:40] <= iv_data[7:0];
                            ov_data1[39:0] <= 40'b0;
                            o_data1_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[47:40] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end     
                    4'd11:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;
                            ov_data1[131:128] <= 4'b0100;//invalid number of bytes,just 12 byte valid
                            ov_data1[39:32] <= iv_data[7:0];
                            ov_data1[31:0] <= 32'b0;
                            o_data1_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[39:32] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end     
                    4'd12:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;
                            ov_data1[131:128] <= 4'b0011;//invalid number of bytes,just 13 byte valid
                            ov_data1[31:24] <= iv_data[7:0];
                            ov_data1[23:0] <= 24'b0;
                            o_data1_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[31:24] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end     
                    4'd13:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;
                            ov_data1[131:128] <= 4'b0010;//invalid number of bytes,just 14 byte valid
                            ov_data1[23:16] <= iv_data[7:0];
                            ov_data1[15:0] <= 16'b0;
                            o_data1_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[23:16] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end     
                    4'd14:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;
                            ov_data1[131:128] <= 4'b0001;//invalid number of bytes,just 15 byte valid
                            ov_data1[15:8] <= iv_data[7:0];
                            ov_data1[7:0] <= 8'b0;
                            o_data1_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[15:8] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end 
                    4'd15:begin
                        o_data1_write_flag <= 1'b1;
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data1[133:132] <= 2'b10;
                            ov_data1[131:128] <= 4'b0000;//invalid number of bytes,16 byte valid
                            ov_data1[7:0] <= iv_data[7:0];
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data1[7:0] <= iv_data[7:0];//generate 128 bits data
                            pkt_state <= WRITE_REG2_S;    //reg1 is full,write data to reg2
                        end
                    end                     
                endcase
            end
            WRITE_REG2_S:begin
                o_data1_write_flag <= 1'b0;         
                if(i_data_wr == 1'b1)begin 
                    rv_pkt_cnt <= rv_pkt_cnt + 4'd1;
                end
                else begin
                    rv_pkt_cnt <= rv_pkt_cnt;
                end
                case(rv_pkt_cnt)
                    4'd0:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b1111;
                            ov_data2[127:120] <= iv_data[7:0];
                            ov_data2[119:0] <= 120'b0;
                            o_data2_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[133:132] <= 2'b11;
                            ov_data2[131:128] <= 4'b0000;
                            ov_data2[127:120] <= iv_data[7:0];  
                            pkt_state <= WRITE_REG2_S;  
                        end
                    end 
                    4'd1:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b1110;
                            ov_data2[119:112] <= iv_data[7:0];
                            ov_data2[111:0] <= 112'b0;
                            o_data2_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[119:112] <= iv_data[7:0];  
                            pkt_state <= WRITE_REG2_S;  
                        end
                    end                                         
                    4'd2:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b1101;
                            ov_data2[111:104] <= iv_data[7:0];
                            ov_data2[103:0] <= 104'b0;
                            o_data2_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[111:104] <= iv_data[7:0];  
                            pkt_state <= WRITE_REG2_S;  
                        end
                    end         
                    4'd3:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b1100;
                            ov_data2[103:96] <= iv_data[7:0];
                            ov_data2[95:0] <= 96'b0;
                            o_data2_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[103:96] <= iv_data[7:0];   
                            pkt_state <= WRITE_REG2_S;  
                        end
                    end 
                    4'd4:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b1011;
                            ov_data2[95:88] <= iv_data[7:0];
                            ov_data2[87:0] <= 88'b0;
                            o_data2_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[95:88] <= iv_data[7:0];    
                            pkt_state <= WRITE_REG2_S;  
                        end
                    end     
                    4'd5:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b1010;
                            ov_data2[87:80] <= iv_data[7:0];
                            ov_data2[79:0] <= 80'b0;
                            o_data2_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[87:80] <= iv_data[7:0];    
                            pkt_state <= WRITE_REG2_S;  
                        end
                    end     
                    4'd6:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b1001;
                            ov_data2[79:72] <= iv_data[7:0];
                            ov_data2[71:0] <= 72'b0;
                            o_data2_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[79:72] <= iv_data[7:0];    
                            pkt_state <= WRITE_REG2_S;  
                        end
                    end     
                    4'd7:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b1000;
                            ov_data2[71:64] <= iv_data[7:0];
                            ov_data2[63:0] <= 64'b0;
                            o_data2_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[71:64] <= iv_data[7:0];    
                            pkt_state <= WRITE_REG2_S;  
                        end
                    end 
                    4'd8:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b0111;
                            ov_data2[63:56] <= iv_data[7:0];
                            ov_data2[55:0] <= 56'b0;
                            o_data2_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[63:56] <= iv_data[7:0];    
                            pkt_state <= WRITE_REG2_S;  
                        end
                    end     
                    4'd9:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b0110;
                            ov_data2[55:48] <= iv_data[7:0];
                            ov_data2[47:0] <= 48'b0;
                            o_data2_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[55:48] <= iv_data[7:0];    
                            pkt_state <= WRITE_REG2_S;  
                        end
                    end     
                    4'd10:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b0101;
                            ov_data2[47:40] <= iv_data[7:0];
                            ov_data2[39:0] <= 40'b0;
                            o_data2_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[47:40] <= iv_data[7:0];    
                            pkt_state <= WRITE_REG2_S;  
                        end
                    end     
                    4'd11:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b0100;
                            ov_data2[39:32] <= iv_data[7:0];
                            ov_data2[31:0] <= 32'b0;
                            o_data2_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[39:32] <= iv_data[7:0];    
                            pkt_state <= WRITE_REG2_S;  
                        end
                    end     
                    4'd12:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b0011;
                            ov_data2[31:24] <= iv_data[7:0];
                            ov_data2[23:0] <= 24'b0;
                            o_data2_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[31:24] <= iv_data[7:0];    
                            pkt_state <= WRITE_REG2_S;  
                        end
                    end     
                    4'd13:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b0010;
                            ov_data2[23:16] <= iv_data[7:0];
                            ov_data2[15:0] <= 16'b0;
                            o_data2_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[23:16] <= iv_data[7:0];    
                            pkt_state <= WRITE_REG2_S;  
                        end
                    end     
                    4'd14:begin
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b0001;
                            ov_data2[15:8] <= iv_data[7:0];
                            ov_data2[7:0] <= 8'b0;
                            o_data2_write_flag <= 1'b1;
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[15:8] <= iv_data[7:0]; 
                            pkt_state <= WRITE_REG2_S;  
                        end
                    end 
                    4'd15:begin
                        o_data2_write_flag <= 1'b1;
                        if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin //last cycle
                            ov_data2[133:132] <= 2'b10;
                            ov_data2[131:128] <= 4'b0000;
                            ov_data2[7:0] <= iv_data[7:0];
                            pkt_state <= CACHE_IDLE_S;  
                        end
                        else begin
                            ov_data2[7:0] <= iv_data[7:0];  
                            pkt_state <= WRITE_REG1_S;  
                        end
                    end                     
                endcase
            end
            default:begin
                pkt_state <= CACHE_IDLE_S;
            end
        endcase
    end
end
 

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin 
        ov_bufid <= 9'b0;
    end
    else begin 
		if(i_pkt_bufid_wr)begin
			ov_bufid <= iv_bufid;
		end
		else begin
			ov_bufid <= ov_bufid;
		end
	end
end
endmodule 