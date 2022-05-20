// Copyright (C) 1953-2022 NUDT
// Verilog module name - pkt_dispatch 
// Version: V3.4.1.20220406
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//          
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module pkt_dispatch
(
        i_clk,
        i_rst_n,

        i_data_wr,
        iv_data,  

        o_data_wr_cpu,
        ov_data_cpu,
        
        o_data_wr_hcp,
        ov_data_hcp        
);

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;
// pkt input
input                   i_data_wr;
input       [7:0]       iv_data;
// pkt output
output  reg [7:0]       ov_data_cpu;
output  reg             o_data_wr_cpu;
output  reg [7:0]       ov_data_hcp;
output  reg             o_data_wr_hcp;
//***************************************************
//      add valid of data and delay 4 cycles
//***************************************************
reg        [44:0]      rv_data;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_data         <= 45'b0;
    end
    else begin
        if(i_data_wr)begin
            rv_data     <= {rv_data[35:0],1'b1,iv_data};
        end
        else begin
            rv_data     <= {rv_data[35:0],1'b0,8'b0};
        end        
    end
end
//***************************************************
//               judge MID
//***************************************************
reg        [3:0]       rv_judge_mid_state;
reg        [3:0]       rv_byte_cnt;
localparam  IDLE_S             = 2'b00,
            JUDGE_MID_S        = 2'b01,
            TRANS_PKT_TO_CPU_S = 2'b10,
            TRANS_PKT_TO_HCP_S = 2'b11;
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        ov_data_cpu             <= 8'b0;
        o_data_wr_cpu           <= 1'b0;
        ov_data_hcp             <= 8'b0;
        o_data_wr_hcp           <= 1'b0;
        rv_byte_cnt             <= 4'b0;
        rv_judge_mid_state      <= IDLE_S;
    end
    else begin
        case(rv_judge_mid_state)
            IDLE_S:begin
                ov_data_cpu             <= 8'b0;
                o_data_wr_cpu           <= 1'b0;
                ov_data_hcp             <= 8'b0;
                o_data_wr_hcp           <= 1'b0;            
                if(i_data_wr)begin//to ouput after 1 cycle delay,judge frame's head once more and make sure pkt is not empty.                                 
                    rv_byte_cnt         <= 4'd1;
                    rv_judge_mid_state  <= JUDGE_MID_S;
                end
                else begin
                    rv_byte_cnt         <= 4'd0;
                    rv_judge_mid_state  <= IDLE_S;                    
                end
            end
            JUDGE_MID_S:begin
                rv_byte_cnt         <= rv_byte_cnt + 1'd1;
                if(rv_byte_cnt == 4'd5)begin
                    if({rv_data[43:36],rv_data[34:27],rv_data[25:18]} == 24'h662662)begin//TSMP.                
                        if({rv_data[3:0],iv_data[7:0]} == 12'h000)begin//transmit to hcp.
                            ov_data_hcp             <= rv_data[43:36];
                            o_data_wr_hcp           <= rv_data[44]; 

                            ov_data_cpu             <= 8'b0;
                            o_data_wr_cpu           <= 1'b0;
                            rv_judge_mid_state      <= TRANS_PKT_TO_HCP_S;                        
                        end
                        else begin//transmit to cpu.
                            ov_data_hcp             <= 8'b0;
                            o_data_wr_hcp           <= 1'b0;   

                            ov_data_cpu             <= rv_data[43:36];
                            o_data_wr_cpu           <= rv_data[44]; 
                            rv_judge_mid_state      <= TRANS_PKT_TO_CPU_S;                         
                        end
                    end
                    else begin
                        ov_data_hcp             <= rv_data[43:36];
                        o_data_wr_hcp           <= rv_data[44]; 

                        ov_data_cpu             <= 8'b0;
                        o_data_wr_cpu           <= 1'b0;
                        rv_judge_mid_state      <= TRANS_PKT_TO_HCP_S;   
                    end                    
                end         
                else begin                
                    ov_data_cpu             <= 8'b0;
                    o_data_wr_cpu           <= 1'b0;
                    ov_data_hcp             <= 8'b0;
                    o_data_wr_hcp           <= 1'b0;
                    rv_judge_mid_state      <= JUDGE_MID_S;                 
                end
            end
            TRANS_PKT_TO_CPU_S:begin
                ov_data_hcp             <= 8'b0;
                o_data_wr_hcp           <= 1'b0;   

                ov_data_cpu             <= rv_data[43:36];
                o_data_wr_cpu           <= rv_data[44]; 
                if(rv_data[44] == 1'b0)begin//transmit finish.               
                    rv_judge_mid_state  <= IDLE_S;  
                end
                else begin//transmit data. 
                    rv_judge_mid_state  <= TRANS_PKT_TO_CPU_S;  
                end                                     
            end
            TRANS_PKT_TO_HCP_S:begin
                ov_data_hcp             <= rv_data[43:36];
                o_data_wr_hcp           <= rv_data[44]; 

                ov_data_cpu             <= 8'b0;
                o_data_wr_cpu           <= 1'b0;
                if(rv_data[44] == 1'b0)begin//transmit finish.               
                    rv_judge_mid_state  <= IDLE_S;  
                end
                else begin//transmit data. 
                    rv_judge_mid_state  <= TRANS_PKT_TO_HCP_S;  
                end                                     
            end            
            default:begin
                ov_data_cpu             <= 8'b0;
                o_data_wr_cpu           <= 1'b0;
                ov_data_hcp             <= 8'b0;
                o_data_wr_hcp           <= 1'b0; 
                rv_judge_mid_state      <= IDLE_S;             
            end
        endcase
    end
end
endmodule