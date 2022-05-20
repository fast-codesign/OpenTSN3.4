// Copyright (C) 1953-2020 NUDT
// Verilog module name - data_splice 
// Version: DAS_V1.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         data splice
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module data_splice_tse(
        i_clk,
        i_rst_n,
        i_data_wr,
        iv_data,
        o_pkt_wr,
        ov_pkt,
        
        data_splice_state
    );

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
//input
input                   i_data_wr;
input       [8:0]       iv_data;
//output
output  reg             o_pkt_wr;
output  reg [133:0]     ov_pkt;

output  reg [1:0]       data_splice_state;
//internal wire&reg
reg         [3:0]       byte_cnt;
reg                     pkt_head_flag;  
reg         [7:0]       rv_data_delay;

localparam  idle_s      = 2'b00,
            first_s     = 2'b01,
            tran_s      = 2'b10,
            discard_s   = 2'b11;            
always@(posedge i_clk or negedge i_rst_n)
    if(!i_rst_n) begin
        o_pkt_wr            <= 1'b0;
        ov_pkt              <= 134'b0;
        pkt_head_flag       <= 1'b0;
        byte_cnt            <= 4'b0;
        rv_data_delay       <= 8'd0;
        data_splice_state       <= idle_s;
        end
    else begin
        case(data_splice_state)
            idle_s:begin        
                if(i_data_wr == 1'b1 && iv_data[8] == 1'b1) begin//head
                    ov_pkt[133:128]     <= 6'b0;
                    ov_pkt[119:0]       <= 120'b0;                  
                    ov_pkt[127:120]     <= iv_data[7:0];
                    pkt_head_flag       <= 1'b1;
                    byte_cnt            <= 4'd1;
                    o_pkt_wr            <= 1'b0;  
                    data_splice_state   <= tran_s;
                    end
                else begin  //invalid
                    ov_pkt              <= 134'b0;
                    pkt_head_flag       <= 1'b0;
                    byte_cnt            <= 4'b0;    
                    o_pkt_wr            <= 1'b0;  
                    data_splice_state       <= idle_s;
                    end
                end

            tran_s:begin
                if(i_data_wr == 1'b1 && iv_data[8] == 1'b0)begin//middle
                    case(byte_cnt)
                        4'd0:begin ov_pkt[127:120] <= iv_data[7:0];o_pkt_wr <= 1'b0;byte_cnt <= byte_cnt + 4'd1;data_splice_state <= tran_s;end
                        4'd1:begin ov_pkt[119:112] <= iv_data[7:0];o_pkt_wr <= 1'b0;byte_cnt <= byte_cnt + 4'd1;data_splice_state <= tran_s;end
                        4'd2:begin ov_pkt[111:104] <= iv_data[7:0];o_pkt_wr <= 1'b0;byte_cnt <= byte_cnt + 4'd1;data_splice_state <= tran_s;end
                        4'd3:begin ov_pkt[103:96]  <= iv_data[7:0];o_pkt_wr <= 1'b0;byte_cnt <= byte_cnt + 4'd1;data_splice_state <= tran_s;end
                        4'd4:begin ov_pkt[95:88]   <= iv_data[7:0];o_pkt_wr <= 1'b0;byte_cnt <= byte_cnt + 4'd1;data_splice_state <= tran_s;end
                        4'd5:begin ov_pkt[87:80]   <= iv_data[7:0];o_pkt_wr <= 1'b0;byte_cnt <= byte_cnt + 4'd1;data_splice_state <= tran_s;end
                        4'd6:begin ov_pkt[79:72]   <= iv_data[7:0];o_pkt_wr <= 1'b0;byte_cnt <= byte_cnt + 4'd1;data_splice_state <= tran_s;end
                        4'd7:begin ov_pkt[71:64]   <= iv_data[7:0];o_pkt_wr <= 1'b0;byte_cnt <= byte_cnt + 4'd1;data_splice_state <= tran_s;end
                        4'd8:begin ov_pkt[63:56]   <= iv_data[7:0];o_pkt_wr <= 1'b0;byte_cnt <= byte_cnt + 4'd1;data_splice_state <= tran_s;end
                        4'd9:begin ov_pkt[55:48]   <= iv_data[7:0];o_pkt_wr <= 1'b0;byte_cnt <= byte_cnt + 4'd1;data_splice_state <= tran_s;end
                        4'd10:begin ov_pkt[47:40]  <= iv_data[7:0];o_pkt_wr <= 1'b0;byte_cnt <= byte_cnt + 4'd1;data_splice_state <= tran_s;end
                        4'd11:begin ov_pkt[39:32]  <= iv_data[7:0];o_pkt_wr <= 1'b0;byte_cnt <= byte_cnt + 4'd1;data_splice_state <= tran_s;end
                        4'd12:begin ov_pkt[31:24]  <= iv_data[7:0];o_pkt_wr <= 1'b0;byte_cnt <= byte_cnt + 4'd1;data_splice_state <= tran_s;end
                        4'd13:begin ov_pkt[23:16]  <= iv_data[7:0];o_pkt_wr <= 1'b0;byte_cnt <= byte_cnt + 4'd1;data_splice_state <= tran_s;end
                        4'd14:begin ov_pkt[15:8]   <= iv_data[7:0];o_pkt_wr <= 1'b0;byte_cnt <= byte_cnt + 4'd1;data_splice_state <= tran_s;end
                        4'd15:begin
                            ov_pkt[7:0]         <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd0;//invalid btye
                            if(pkt_head_flag == 1'b1) begin
                                pkt_head_flag       <= 1'b0;
                                ov_pkt[133:132]     <= 2'b01;//head flag
                                end
                            else begin
                                pkt_head_flag       <= pkt_head_flag;
                                ov_pkt[133:132]     <= 2'b11;//middle flag
                                end
                            o_pkt_wr            <= 1'b1;//ov_pkt is full,output
                            byte_cnt            <= 4'd0;
                            data_splice_state       <= tran_s;
                            end
                        default:begin ov_pkt <= ov_pkt; o_pkt_wr <= o_pkt_wr;data_splice_state <= idle_s;end                            
                        endcase
                    end
                else if(i_data_wr == 1'b1 && iv_data[8] == 1'b1)begin//tail
                    byte_cnt            <= 4'd0;
                    data_splice_state       <= idle_s;
                    case(byte_cnt)
                        4'd0:begin
                            ov_pkt[127:120]     <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd15;   //invalid btye
                            ov_pkt[133:132]     <= 2'b10;   //tail flag
                            o_pkt_wr            <= 1'b1;    //ov_pkt is full
                            ov_pkt[119:0]       <= 120'b0;
                            end
                        4'd1:begin
                            ov_pkt[119:112]     <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd14;       //invalid btye
                            ov_pkt[133:132]     <= 2'b10;       //tail flag
                            o_pkt_wr            <= 1'b1;        //ov_pkt is full
                            ov_pkt[111:0]       <= 112'b0;
                            end
                        4'd2:begin
                            ov_pkt[111:104]     <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd13;//invalid btye
                            ov_pkt[133:132]     <= 2'b10;//tail flag
                            o_pkt_wr            <= 1'b1;//ov_pkt is full                            
                            ov_pkt[103:0]       <= 104'b0;
                            end
                        4'd3:begin
                            ov_pkt[103:96]      <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd12;//invalid btye
                            ov_pkt[133:132]     <= 2'b10;//tail flag
                            o_pkt_wr            <= 1'b1;//ov_pkt is full                            
                            ov_pkt[95:0]        <= 96'b0;
                            end
                        4'd4:begin
                            ov_pkt[95:88]       <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd11;//invalid btye
                            ov_pkt[133:132]     <= 2'b10;//tail flag
                            o_pkt_wr            <= 1'b1;//ov_pkt is full                            
                            ov_pkt[87:0]        <= 88'b0;
                            end
                        4'd5:begin 
                            ov_pkt[87:80]       <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd10;//invalid btye
                            ov_pkt[133:132]     <= 2'b10;//tail flag
                            o_pkt_wr            <= 1'b1;//ov_pkt is full                            
                            ov_pkt[79:0]        <= 80'b0;
                            end                         
                        4'd6:begin 
                            ov_pkt[79:72]       <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd9;//invalid btye
                            ov_pkt[133:132]     <= 2'b10;//tail flag
                            o_pkt_wr            <= 1'b1;//ov_pkt is full                            
                            ov_pkt[71:0]        <= 72'b0;
                            end
                        4'd7:begin 
                            ov_pkt[71:64]       <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd8;//invalid btye
                            ov_pkt[133:132]     <= 2'b10;//tail flag
                            o_pkt_wr            <= 1'b1;//ov_pkt is full                            
                            ov_pkt[63:0]        <= 64'b0;
                            end
                        4'd8:begin 
                            ov_pkt[63:56]       <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd7;//invalid btye
                            ov_pkt[133:132]     <= 2'b10;//tail flag
                            o_pkt_wr            <= 1'b1;//ov_pkt is full                            
                            ov_pkt[55:0]        <= 56'b0;
                            end
                        4'd9:begin 
                            ov_pkt[55:48]       <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd6;//invalid btye
                            ov_pkt[133:132]     <= 2'b10;//tail flag
                            o_pkt_wr            <= 1'b1;//ov_pkt is full                            
                            ov_pkt[47:0]        <= 48'b0;
                            end
                        4'd10:begin 
                            ov_pkt[47:40]       <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd5;//invalid btye
                            ov_pkt[133:132]     <= 2'b10;//tail flag
                            o_pkt_wr            <= 1'b1;//ov_pkt is full                            
                            ov_pkt[39:0]        <= 40'b0;
                            end
                        4'd11:begin 
                            ov_pkt[39:32]       <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd4;//invalid btye
                            ov_pkt[133:132]     <= 2'b10;//tail flag
                            o_pkt_wr            <= 1'b1;//ov_pkt is full                            
                            ov_pkt[31:0]        <= 32'b0;
                            end
                        4'd12:begin 
                            ov_pkt[31:24]       <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd3;//invalid btye
                            ov_pkt[133:132]     <= 2'b10;//tail flag
                            o_pkt_wr            <= 1'b1;//ov_pkt is full                            
                            ov_pkt[23:0]        <= 24'b0;
                            end
                        4'd13:begin 
                            ov_pkt[23:16]       <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd2;//invalid btye
                            ov_pkt[133:132]     <= 2'b10;//tail flag
                            o_pkt_wr            <= 1'b1;//ov_pkt is full                            
                            ov_pkt[15:0]        <= 16'b0;
                            end
                        4'd14:begin 
                            ov_pkt[15:8]        <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd1;//invalid btye
                            ov_pkt[133:132]     <= 2'b10;//tail flag
                            o_pkt_wr            <= 1'b1;//ov_pkt is full                            
                            ov_pkt[7:0]         <= 8'b0;
                            end
                        4'd15:begin 
                            ov_pkt[7:0]         <= iv_data[7:0];
                            ov_pkt[131:128]     <= 4'd0;//invalid btye
                            ov_pkt[133:132]     <= 2'b10;//tail flag
                            o_pkt_wr            <= 1'b1;//ov_pkt is full                        
                            end 
                        default:begin ov_pkt <= ov_pkt; o_pkt_wr <= o_pkt_wr;data_splice_state <= idle_s;end                            
                        endcase                     
                    end
                else begin
                    o_pkt_wr            <= 1'b0;                
                    ov_pkt              <= 134'b0;
                    pkt_head_flag       <= 1'b0;
                    byte_cnt            <= 4'b0;                    
                    data_splice_state       <= idle_s;
                    end
                end
            default:begin
                o_pkt_wr            <= 1'b0;
                ov_pkt              <= 134'b0;
                pkt_head_flag       <= 1'b0;
                byte_cnt            <= 4'b0;
                data_splice_state       <= idle_s;
                end
            endcase
        end

endmodule