// Copyright (C) 1953-2022 NUDT
// Verilog module name - network_management_parse 
// Version: V3.4.0.20220228
// Created:
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         parse network management pkt 
//         configure the regist
//         configure the RAM
///////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module network_management_parse
(
       i_clk,
       i_rst_n,

       ov_dmac ,
       ov_smac ,
       
       iv_data  ,
       i_data_wr,
       
       ov_command     ,
	   o_command_wr   ,
       ov_rd_state_num,       
       
       o_tsmp_receive_pulse
);


// I/O
// i_clk & rst
input                  i_clk;
input                  i_rst_n;

output reg [47:0]      ov_dmac; 
output reg [47:0]      ov_smac;        
//nmac data
input      [8:0]       iv_data;               // input nmac data
input                  i_data_wr;             // nmac writer signals

output reg [65:0]	   ov_command;
output reg	           o_command_wr;
output reg [15:0]      ov_rd_state_num;

output reg             o_tsmp_receive_pulse;

reg        [8:0]       rv_init_cnt;
reg        [3:0]       rv_pkt_cycle_cnt;
reg        [15:0]      rv_configure_cnt;
reg                    r_base_addr_flag;
//***************************************************
//          network management pkt parse
//***************************************************
reg     [3:0]         nmp_state;
localparam            INIT_S                = 4'd0,
                      IDLE_S                = 4'd1,
                      EXTRACT_DMAC_S        = 4'd2,
                      EXTRACT_SMAC_S        = 4'd3,
                      DISTINGUISH_RWTYPE_S  = 4'd4,
                      EXTRACT_NUM_S         = 4'd5,
                      EXTRACT_ADDR_S        = 4'd6,
                      GENERATE_CMD_S        = 4'd7,
                      DISC_S                = 4'd8;
always @(posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n == 1'b0)begin
        ov_dmac              <= 48'b0;
        ov_smac              <= 48'b0;
    
        ov_command           <= 66'b0;
        o_command_wr         <= 1'b0;
        ov_rd_state_num      <= 16'b0;
        
        o_tsmp_receive_pulse <= 1'd0;
        
        rv_init_cnt          <= 9'h0;
        rv_pkt_cycle_cnt     <= 4'b0;
        rv_configure_cnt     <= 16'h0;
        r_base_addr_flag     <= 1'b0;
        nmp_state            <= IDLE_S;
    end
    else begin
        case(nmp_state)          
            IDLE_S:begin // receive pkt
                ov_command   <= 66'b0;
                o_command_wr <= 1'b0;            
                
                rv_configure_cnt <= 16'h0; 
                r_base_addr_flag <= 1'b0;              
                if((i_data_wr == 1'b1) && (iv_data[8] == 1'b1))begin
                    rv_pkt_cycle_cnt     <= rv_pkt_cycle_cnt + 4'b1;
                    o_tsmp_receive_pulse <= 1'b1;
                    ov_dmac              <= {ov_dmac[39:0],iv_data[7:0]};
                    nmp_state            <= EXTRACT_DMAC_S;
                end
                else begin
                    rv_pkt_cycle_cnt     <= 4'b0;
                    o_tsmp_receive_pulse <= 1'b0;
                    nmp_state            <= IDLE_S;
                end
            end
            EXTRACT_DMAC_S:begin
                rv_pkt_cycle_cnt     <= rv_pkt_cycle_cnt + 4'b1;
                ov_dmac              <= {ov_dmac[39:0],iv_data[7:0]};
                if(rv_pkt_cycle_cnt == 4'd5)begin
                    nmp_state            <= EXTRACT_SMAC_S;
                end
                else begin
                    nmp_state            <= EXTRACT_DMAC_S;
                end
            end
            EXTRACT_SMAC_S:begin
                rv_pkt_cycle_cnt     <= rv_pkt_cycle_cnt + 4'b1;
                ov_smac              <= {ov_smac[39:0],iv_data[7:0]};
                if(rv_pkt_cycle_cnt == 4'd11)begin
                    nmp_state            <= DISTINGUISH_RWTYPE_S;
                end
                else begin
                    nmp_state            <= EXTRACT_SMAC_S;
                end
            end
            DISTINGUISH_RWTYPE_S:begin
                o_tsmp_receive_pulse <= 1'b0;
                if(i_data_wr == 1'b1)begin
                    if(rv_pkt_cycle_cnt == 4'd15)begin
                        rv_pkt_cycle_cnt <= 4'b0;
                        if(iv_data[7:0] == 8'h01)begin//rd req
                            ov_command[65:64] <= 2'b10;
                            nmp_state         <= EXTRACT_NUM_S;
                        end
                        else if(iv_data[7:0] == 8'h02)begin//wr req
                            ov_command[65:64] <= 2'b00;
                            nmp_state         <= EXTRACT_NUM_S;
                        end
                        else begin
                            nmp_state         <= IDLE_S;  
                        end
                    end
                    else begin
                        rv_pkt_cycle_cnt      <= rv_pkt_cycle_cnt + 4'b1;
                        nmp_state             <= DISTINGUISH_RWTYPE_S;
                    end
                end
                else begin
                    nmp_state         <= IDLE_S; 
                end           
            end
            EXTRACT_NUM_S:begin  // record the pkt write/read count
                if(i_data_wr == 1'b1)begin
                    if(rv_pkt_cycle_cnt == 4'd0)begin
                        ov_rd_state_num[15:8]  <= iv_data[7:0];
                        rv_configure_cnt[15:8] <= iv_data[7:0];
                        rv_pkt_cycle_cnt       <= rv_pkt_cycle_cnt + 4'b1;
                        nmp_state              <= EXTRACT_NUM_S;
                    end
                    else if(rv_pkt_cycle_cnt == 4'd1)begin
                        ov_rd_state_num[7:0]   <= iv_data[7:0];
                        rv_configure_cnt[7:0]  <= iv_data[7:0];
                        rv_pkt_cycle_cnt       <= 4'b0;
                        nmp_state              <= EXTRACT_ADDR_S;                    
                    end
                    else begin
                        nmp_state              <= IDLE_S;
                    end
                end
                else begin
                    rv_pkt_cycle_cnt <= 4'h0;
                    nmp_state        <= IDLE_S;
                end
            end           
            EXTRACT_ADDR_S:begin // record the nmac pkt write/read regist addr
                if(i_data_wr == 1'b1)begin
                    ov_command[63:32]    <= {ov_command[55:32],iv_data[7:0]};                       
                    if(rv_pkt_cycle_cnt < 4'd3)begin//extract regist addr
                        rv_pkt_cycle_cnt <= rv_pkt_cycle_cnt + 4'b1; 
                        nmp_state        <= EXTRACT_ADDR_S;
                    end
                    else begin
                        rv_pkt_cycle_cnt <= 4'b0;
                        r_base_addr_flag <= 1'b1;//base addr
                        nmp_state        <= GENERATE_CMD_S;
                    end
                end
                else begin
                    rv_pkt_cycle_cnt    <= 4'h0;
                    nmp_state           <= IDLE_S;
                end
            end 
            GENERATE_CMD_S:begin
                if(i_data_wr == 1'b1)begin
                    ov_command[31:0] <= {ov_command[23:0],iv_data[7:0]}; 
                    if(rv_pkt_cycle_cnt < 4'd3)begin
                        rv_pkt_cycle_cnt <= rv_pkt_cycle_cnt + 4'b1;
                        o_command_wr     <= 1'b0; 
                        nmp_state        <= GENERATE_CMD_S;
                    end
                    else begin
                        rv_pkt_cycle_cnt <= 4'b0;
                        o_command_wr     <= 1'b1;
                        if(r_base_addr_flag)begin
                            ov_command[63:32] <= ov_command[63:32];
                            r_base_addr_flag  <= 1'b0;
                        end
                        else begin
                            ov_command[63:32] <= ov_command[63:32] + 1'b1;
                        end                        
                        if(rv_configure_cnt == 16'b1)begin
                            if(iv_data[8] == 1'b1)begin
                                nmp_state        <= IDLE_S;
                            end
                            else begin
                                nmp_state        <= DISC_S;
                            end
                        end
                        else begin
                            rv_configure_cnt <= rv_configure_cnt - 16'b1;
                            nmp_state        <= GENERATE_CMD_S;
                        end
                    end
                end
                else begin
                    rv_pkt_cycle_cnt    <= 4'h0;
                    r_base_addr_flag    <= 1'b0;
                    nmp_state           <= IDLE_S;               
                end
            end
            DISC_S:begin
                ov_command <= 66'b0;
                o_command_wr <= 1'b0;              
            
                rv_configure_cnt <= 16'h0;
                r_base_addr_flag  <= 1'b0;
                rv_pkt_cycle_cnt <= 4'd0;
                if(iv_data[8] == 1'b1)begin
                    nmp_state     <= IDLE_S;
                end
                else begin
                    nmp_state     <= DISC_S;
                end
            end
            
            default:begin
                nmp_state        <= IDLE_S;
            end
        endcase
    end
end    

endmodule
    