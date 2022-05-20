// Copyright (C) 1953-2022 NUDT
// Verilog module name - network_management_generate 
// Version: 3.4.0.20220228
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         generate network management pkt 
///////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module network_management_generate 
(
        i_clk,
        i_rst_n,
        
        iv_dmac,
        iv_smac,
        
        iv_hcp_mac,
        iv_controller_mac,
        iv_rd_state_num,
        
        iv_fifo_usedw,
        o_fifo_rd,
        iv_command_ack,

        ov_data,
        o_data_wr,    
     
        ov_tsmp_ack_cnt,
        ov_fifo_underflow_cnt
);

// clk & rst
input                  i_clk;
input                  i_rst_n;

input     [47:0]       iv_dmac;
input     [47:0]       iv_smac;

input     [47:0]       iv_hcp_mac;
input     [47:0]       iv_controller_mac;
input     [15:0]       iv_rd_state_num;

input     [7:0]        iv_fifo_usedw;
output reg             o_fifo_rd;
input     [63:0]	   iv_command_ack;
// nmac report data to host_tx
output reg[8:0]        ov_data;
output reg             o_data_wr;

output reg[31:0]       ov_tsmp_ack_cnt;
output reg[31:0]       ov_fifo_underflow_cnt;
//***************************************************
//               nmac pkt generate
//***************************************************
reg     [15:0]        rv_rd_state_num;
reg     [7:0]         rv_report_cnt;
reg     [3:0]         nmg_state;
localparam            IDLE_S                   = 4'd0,
                      GENERATE_DMAC_S          = 4'd1,
                      GENERATE_SMAC_S          = 4'd2,
                      GENERATE_ETH_S           = 4'd3,
                      GENERATE_TYPE_S          = 4'd4,
                      GENERATE_SUBTYPE_S       = 4'd5,
                      GENERATE_NUM_S           = 4'd6,
                      GENERATE_COMMAND_TYPE_S  = 4'd7,
                      GENERATE_BASE_ADDR_S     = 4'd8,
                      TRANS_STATE_S            = 4'd9,
                      PAD_ZERO_S               = 4'd10;
                                                    
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin 
        o_fifo_rd                     <= 1'b0; 
                                      
        ov_data                       <= 9'h0;
        o_data_wr                     <= 1'h0;
        ov_tsmp_ack_cnt               <= 32'h0;
                                      
        rv_report_cnt                 <= 8'b0;
        rv_rd_state_num               <= 16'b0;
        
        ov_fifo_underflow_cnt         <= 32'b0;
                                      
        nmg_state                     <= IDLE_S;
    end
    else begin
        case(nmg_state)
            IDLE_S:begin//state report nmac pkt
                o_fifo_rd             <= 1'b0;                 
                if((iv_fifo_usedw != 8'b0)&&(iv_fifo_usedw == iv_rd_state_num[7:0]))begin//receive rd_command_ack
                    rv_report_cnt       <= 8'h1;
                    rv_rd_state_num     <= iv_rd_state_num;
                    ov_data             <= {1'b1,iv_smac[47:40]};
                    o_data_wr           <= 1'b1; 
                    ov_tsmp_ack_cnt     <= ov_tsmp_ack_cnt + 1'h1; 
                                       
                    nmg_state           <= GENERATE_DMAC_S;
                end
                else begin
                    rv_report_cnt       <= 8'h0;
                    rv_rd_state_num     <= 16'b0; 
                    ov_data             <= 9'h0;
                    o_data_wr           <= 1'h0;
                    
                    nmg_state           <= IDLE_S;
                end
            end            
            GENERATE_DMAC_S:begin//generate pkt DMAC
                rv_report_cnt                <= rv_report_cnt + 8'h1;
                if(rv_report_cnt < 8'd5)begin
                    case(rv_report_cnt)
                        8'd1:ov_data    <= {1'b0,iv_smac[39:32]};
                        8'd2:ov_data    <= {1'b0,iv_smac[31:24]};
                        8'd3:ov_data    <= {1'b0,iv_smac[23:16]};
                        8'd4:ov_data    <= {1'b0,iv_smac[15:8]};
                        default:ov_data <= ov_data;
                    endcase
                    nmg_state           <= GENERATE_DMAC_S;
                end                          
                else begin                   
                    ov_data             <= {1'b0,iv_smac[7:0]};
                    nmg_state           <= GENERATE_SMAC_S;
                end
            end
            
            GENERATE_SMAC_S:begin//generate pkt SMAC
                rv_report_cnt           <= rv_report_cnt + 8'h1;
                if(rv_report_cnt < 8'd11)begin
                    nmg_state                 <= GENERATE_SMAC_S;
                    case(rv_report_cnt)
                        8'd6 :ov_data    <= {1'b0,iv_dmac[47:40]};
                        8'd7 :ov_data    <= {1'b0,iv_dmac[39:32]};
                        8'd8 :ov_data    <= {1'b0,iv_dmac[31:24]};
                        8'd9 :ov_data    <= {1'b0,iv_dmac[23:16]};
                        8'd10:ov_data    <= {1'b0,iv_dmac[15:8]} ;
                        default:ov_data  <= ov_data;
                    endcase
                end
                else begin 
                    ov_data              <= {1'b0,iv_dmac[7:0]};        
                    nmg_state            <= GENERATE_ETH_S;
                end
            end
            
            GENERATE_ETH_S:begin
                rv_report_cnt       <= rv_report_cnt + 8'h1;
                if(rv_report_cnt == 8'd12)begin//generate pkt Ethernet first byte
                    ov_data    <= 9'h0ff;
                    nmg_state  <= GENERATE_ETH_S;                                    
                end
                else begin//generate pkt Ethernet last byte
                    ov_data    <= 9'h001;                
                    nmg_state  <= GENERATE_TYPE_S;
                end
            end
            GENERATE_TYPE_S:begin
                ov_data            <= 9'h002;
                rv_report_cnt      <= rv_report_cnt + 8'h1; 
                nmg_state          <= GENERATE_SUBTYPE_S;                   
            end
            GENERATE_SUBTYPE_S:begin
                ov_data            <= 9'h003;
                rv_report_cnt      <= rv_report_cnt + 8'h1; 
                nmg_state          <= GENERATE_NUM_S;                   
            end            
            GENERATE_NUM_S:begin
                rv_report_cnt      <= rv_report_cnt + 8'h1; 
                if(rv_report_cnt == 8'd16)begin
                    ov_data        <= {1'b0,rv_rd_state_num[15:8]};
                end
                else begin
                    ov_data        <= {1'b0,rv_rd_state_num[7:0]};
                    nmg_state      <= GENERATE_BASE_ADDR_S; 
                end                
            end
            GENERATE_BASE_ADDR_S:begin
                rv_report_cnt       <= rv_report_cnt + 8'h1; 
                if(rv_report_cnt[1:0] == 2'd1)begin                
                    nmg_state       <= TRANS_STATE_S; 
                end
                else begin
                    nmg_state       <= GENERATE_BASE_ADDR_S; 
                end
                case(rv_report_cnt[1:0])
                    2'd2:ov_data <= {1'b0,iv_command_ack[63:56]};
                    2'd3:ov_data <= {1'b0,iv_command_ack[55:48]}; 
                    2'd0:ov_data <= {1'b0,iv_command_ack[47:40]};
                    2'd1:ov_data <= {1'b0,iv_command_ack[39:32]};  
                    default:begin
                        ov_data  <= 9'd0;
                    end
                endcase

            end            
            TRANS_STATE_S:begin//generate pkt data base on regist
                rv_report_cnt   <= rv_report_cnt + 8'h1;
                //judge when to read fifo.
                if(rv_report_cnt[1:0] == 2'd0)begin
                    o_fifo_rd   <= 1'b1;
                end
                else begin
                    o_fifo_rd   <= 1'b0;
                end
                //judge when to finish reading fifo,and whether length of packet is enough.
                if(rv_report_cnt[1:0] == 2'd1)begin
                    rv_rd_state_num           <= rv_rd_state_num - 1'b1;
                    if(rv_rd_state_num == 2'd1)begin//read all command ack of fifo 
                        if(rv_report_cnt < 8'd60)begin
                            ov_data    <= {1'b0,iv_command_ack[7:0]};                       
                            o_data_wr  <= 1'b1;
                            nmg_state  <= PAD_ZERO_S;
                        end 
                        else begin
                            ov_data      <= {1'b1,iv_command_ack[7:0]};                       
                            o_data_wr    <= 1'b1;
                            nmg_state    <= IDLE_S;
                        end
                        if(iv_fifo_usedw == 8'd0)begin
                            ov_fifo_underflow_cnt <= ov_fifo_underflow_cnt + 1'b1;
                        end
                        else begin
                            ov_fifo_underflow_cnt <= ov_fifo_underflow_cnt;
                        end                        
                    end
                    else begin//there is data in fifo.
                        ov_data       <= {1'b0,iv_command_ack[7:0]};                                          
                        o_data_wr     <= 1'b1;
                        nmg_state     <= TRANS_STATE_S;   
                    end
                end
                else begin
                    //generate data
                    case(rv_report_cnt[1:0])
                        8'd2:ov_data <= {1'b0,iv_command_ack[31:24]};
                        8'd3:ov_data <= {1'b0,iv_command_ack[23:16]};
                        8'd0:ov_data <= {1'b0,iv_command_ack[15:8]};
                        8'd1:ov_data <= {1'b0,iv_command_ack[7:0]};                       
                        default:begin
                            ov_data  <= 9'd0;
                        end
                    endcase                
                    rv_rd_state_num   <= rv_rd_state_num;
                    o_data_wr         <= 1'b1;
                    nmg_state         <= TRANS_STATE_S;                     
                end
            end
            
            PAD_ZERO_S:begin
                rv_report_cnt    <= rv_report_cnt + 8'h1;
                if(rv_report_cnt == 8'd60)begin
                    o_data_wr  <= 1'b0;
                    nmg_state  <= IDLE_S;
                end
                else begin
                    if(rv_report_cnt == 8'd59)begin
                        ov_data          <= {1'b1,8'b0};
                    end
                    else begin
                        ov_data          <= 9'b0; 
                    end                    
                    o_data_wr  <= 1'h1;                    
                    nmg_state  <= PAD_ZERO_S;
                end                
            end
            default:begin
                rv_report_cnt  <= 8'h0;
                ov_data        <= 8'b0;
                o_data_wr      <= 1'b0;
                nmg_state      <= IDLE_S;            
            end
        endcase
    end
end
endmodule