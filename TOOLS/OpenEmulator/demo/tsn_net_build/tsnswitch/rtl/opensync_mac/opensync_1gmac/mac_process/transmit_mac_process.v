// Copyright (C) 1953-2022 NUDT
// Verilog module name - transmit_mac_process 
// Version: V3.4.0.20220223
// Created:
//         by - fenglin 
//         at - 02.2022
////////////////////////////////////////////////////////////////////////////
// Description:
//         1.message first byte detection；
//         2.calcultion of CRC checkout code；
//         3.controlled of message output；
////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module transmit_mac_process(
    input                 i_rst_n,
    input                 i_clk,
    input  wire           i_data_wr,
    input  wire  [   7:0] iv_data,
    
    output reg            o_gmii_tx_en,
    output                o_gmii_tx_er,
    output reg   [  7:0]  ov_gmii_txd
    );

assign          o_gmii_tx_er = 1'b0;
//***************************************************
//   add valid of data and delay 8 cycles
//***************************************************
reg        [71:0]      rv_delay_data;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_delay_data <= 72'b0;
    end
    else begin
        if(i_data_wr)begin
            rv_delay_data <= {rv_delay_data[62:0],1'b1,iv_data};
        end
        else begin
            rv_delay_data <= {rv_delay_data[62:0],1'b0,8'b0};
        end        
    end
end

reg        [7:0]      rv_add_preamble_data;
reg                   r_add_preamble_data_wr;
reg        [2:0]      rv_byte_cnt;
reg        [2:0]      rv_add_preamble_state;
localparam            WAIT_PKT_S      = 3'd0,
                      ADD_PREAMBLE_S  = 3'd1,
                      ADD_SOF_S       = 3'd2,
                      TRANSMIT_PKT_S  = 3'd3;
always @ (posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n==1'b0)begin
        rv_add_preamble_data   <= 8'b0;
        r_add_preamble_data_wr <= 1'b0;
        rv_byte_cnt            <= 3'd0;
        rv_add_preamble_state  <= WAIT_PKT_S;         
    end
    else begin
        case(rv_add_preamble_state)
            WAIT_PKT_S:begin
                if(i_data_wr)begin
                    rv_add_preamble_data   <= 8'h55;
                    r_add_preamble_data_wr <= 1'b1;
                    rv_byte_cnt            <= 3'd1;                
                    rv_add_preamble_state  <= ADD_PREAMBLE_S;                  
                end
                else begin
                    rv_add_preamble_data   <= 8'b0;
                    r_add_preamble_data_wr <= 1'b0;
                    rv_byte_cnt            <= 3'd0;
                    rv_add_preamble_state  <= WAIT_PKT_S;              
                end
            end
            ADD_PREAMBLE_S:begin
                rv_byte_cnt            <= rv_byte_cnt + 3'd1;
                rv_add_preamble_data   <= 8'h55;
                r_add_preamble_data_wr <= 1'b1;  
                if(rv_byte_cnt <= 3'd5)begin           
                    rv_add_preamble_state  <= ADD_PREAMBLE_S;                  
                end
                else begin
                    rv_add_preamble_state  <= ADD_SOF_S;              
                end            
            end
            ADD_SOF_S:begin
                rv_add_preamble_data   <= 8'hd5;
                r_add_preamble_data_wr <= 1'b1;  
                rv_add_preamble_state  <= TRANSMIT_PKT_S;                             
            end        
            TRANSMIT_PKT_S:begin
                if(rv_delay_data[71])begin
                    rv_add_preamble_data   <= rv_delay_data[70:63];
                    r_add_preamble_data_wr <= 1'b1;                
                    rv_add_preamble_state  <= TRANSMIT_PKT_S; 
                end
                else begin
                    rv_add_preamble_data   <= 8'b0;
                    r_add_preamble_data_wr <= 1'b0;                
                    rv_add_preamble_state  <= WAIT_PKT_S; 
                end            
            end
            default:begin
                rv_add_preamble_data   <= 8'b0;
                r_add_preamble_data_wr <= 1'b0;
                rv_byte_cnt            <= 3'd0;
                rv_add_preamble_state  <= WAIT_PKT_S;  
            end
        endcase            
    end
end   
////////////////////////////////////////////////////////////////////////////
//        Intermediate variable Declaration
////////////////////////////////////////////////////////////////////////////
    reg            ppt2gtc_gmii_dv_r0;
    wire           pos_edge;
    wire           neg_edge;
    wire   [7:0]   data_in;
    wire   [31:0]  crc_f;
    reg    [31:0]  next_crc;
    wire   [31:0]  lastcrc;
    reg    [1:0]   crc_cnt;
   
    reg    [2:0]   ctrl_state;
    localparam IDLE_S = 3'd1,
               RCV_S  = 3'd2,
               CRC_S  = 3'd3,
               OUT_S  = 3'd4;

////////////////////////////////////////////////////////////////////////////
assign pos_edge =~ppt2gtc_gmii_dv_r0 & r_add_preamble_data_wr;
assign neg_edge =ppt2gtc_gmii_dv_r0 & ~r_add_preamble_data_wr;                 

always @ (posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n==1'b0)begin
        ppt2gtc_gmii_dv_r0 <= 1'b0;
    end
    else begin
        ppt2gtc_gmii_dv_r0 <= r_add_preamble_data_wr;
    end
end      

////////////////////////////////////////////////////////////////////////////

assign data_in ={rv_add_preamble_data[0],rv_add_preamble_data[1],rv_add_preamble_data[2],rv_add_preamble_data[3],rv_add_preamble_data[4],rv_add_preamble_data[5],rv_add_preamble_data[6],rv_add_preamble_data[7]};

assign crc_f ={next_crc[0],next_crc[1],next_crc[2],next_crc[3],next_crc[4],next_crc[5],next_crc[6],next_crc[7],next_crc[8],next_crc[9],
next_crc[10],next_crc[11],next_crc[12],next_crc[13],next_crc[14],next_crc[15],next_crc[16],next_crc[17],next_crc[18],next_crc[19],
next_crc[20],next_crc[21],next_crc[22],next_crc[23],next_crc[24],next_crc[25],next_crc[26],next_crc[27],next_crc[28],next_crc[29],
next_crc[30],next_crc[31]};
assign lastcrc =~crc_f;
always @ (posedge i_clk or negedge i_rst_n) begin
    if(i_rst_n==1'b0)begin
        o_gmii_tx_en <= 1'b0;
        ov_gmii_txd <= 8'b0;
        crc_cnt<= 2'b0;
        next_crc <= 32'hffffffff;
        ctrl_state <= IDLE_S;         
    end
    else begin
        case(ctrl_state)
        IDLE_S:begin        
            if (pos_edge == 1'b1)begin //posedge of “ppt2gtc_gmii_dv” signal
                ov_gmii_txd <= rv_add_preamble_data;
                o_gmii_tx_en <= r_add_preamble_data_wr;
                ctrl_state <= RCV_S;
            end
            else begin
                ctrl_state <= IDLE_S;      
            end
        end
        RCV_S:begin          
            if((r_add_preamble_data_wr == 1'b1)&&(rv_add_preamble_data == 8'hd5))begin//first byte
                ov_gmii_txd <= rv_add_preamble_data;
                o_gmii_tx_en <= r_add_preamble_data_wr;
                ctrl_state <= CRC_S;
            end
            else begin
                ov_gmii_txd <= rv_add_preamble_data;
                o_gmii_tx_en <= r_add_preamble_data_wr;              
                ctrl_state <= RCV_S; 
            end 
        end            
        CRC_S:begin
            if(neg_edge == 1'b1)begin
                
                ov_gmii_txd <= lastcrc[7:0];
                o_gmii_tx_en <= 1'b1;
                ctrl_state <= OUT_S;
            end
            else  begin   

                next_crc[0]<=  data_in[6] ^ data_in[0] ^ next_crc[24] ^ next_crc[30];
                next_crc[1]<=  data_in[7] ^ data_in[6] ^ data_in[1] ^ data_in[0] ^ next_crc[24] ^ next_crc[25] ^ next_crc[30] ^ next_crc[31];
                next_crc[2]<=  data_in[7] ^ data_in[6] ^ data_in[2] ^ data_in[1] ^ data_in[0] ^ next_crc[24] ^ next_crc[25] ^ next_crc[26] ^ next_crc[30] ^ next_crc[31];
                next_crc[3]<=  data_in[7] ^ data_in[3] ^ data_in[2] ^ data_in[1] ^ next_crc[25] ^ next_crc[26] ^ next_crc[27] ^ next_crc[31];
                next_crc[4]<=  data_in[6] ^ data_in[4] ^ data_in[3] ^ data_in[2] ^ data_in[0] ^ next_crc[24] ^ next_crc[26] ^ next_crc[27] ^ next_crc[28] ^ next_crc[30];
                next_crc[5]<=  data_in[7] ^ data_in[6] ^ data_in[5] ^ data_in[4] ^ data_in[3] ^ data_in[1] ^ data_in[0] ^ next_crc[24] ^ next_crc[25] ^ next_crc[27] ^ next_crc[28] ^ next_crc[29] ^ next_crc[30] ^ next_crc[31];
                next_crc[6]<=  data_in[7] ^ data_in[6] ^ data_in[5] ^ data_in[4] ^ data_in[2] ^ data_in[1] ^ next_crc[25] ^ next_crc[26] ^ next_crc[28] ^ next_crc[29] ^ next_crc[30] ^ next_crc[31];
                next_crc[7]<=  data_in[7] ^ data_in[5] ^ data_in[3] ^ data_in[2] ^ data_in[0] ^ next_crc[24] ^ next_crc[26] ^ next_crc[27] ^ next_crc[29] ^ next_crc[31];
                next_crc[8]<=  data_in[4] ^ data_in[3] ^ data_in[1] ^ data_in[0] ^ next_crc[0] ^ next_crc[24] ^ next_crc[25] ^ next_crc[27] ^ next_crc[28];
                next_crc[9]<=  data_in[5] ^ data_in[4] ^ data_in[2] ^ data_in[1] ^ next_crc[1] ^ next_crc[25] ^ next_crc[26] ^ next_crc[28] ^ next_crc[29];
                next_crc[10] <= data_in[5] ^ data_in[3] ^ data_in[2] ^ data_in[0] ^ next_crc[2] ^ next_crc[24] ^ next_crc[26] ^ next_crc[27] ^ next_crc[29];
                next_crc[11] <= data_in[4] ^ data_in[3] ^ data_in[1] ^ data_in[0] ^ next_crc[3] ^ next_crc[24] ^ next_crc[25] ^ next_crc[27] ^ next_crc[28];
                next_crc[12] <= data_in[6] ^ data_in[5] ^ data_in[4] ^ data_in[2] ^ data_in[1] ^ data_in[0] ^ next_crc[4] ^ next_crc[24] ^ next_crc[25] ^ next_crc[26] ^ next_crc[28] ^ next_crc[29] ^ next_crc[30];
                next_crc[13] <= data_in[7] ^ data_in[6] ^ data_in[5] ^ data_in[3] ^ data_in[2] ^ data_in[1] ^ next_crc[5] ^ next_crc[25] ^ next_crc[26] ^ next_crc[27] ^ next_crc[29] ^ next_crc[30] ^ next_crc[31];
                next_crc[14] <= data_in[7] ^ data_in[6] ^ data_in[4] ^ data_in[3] ^ data_in[2] ^ next_crc[6] ^ next_crc[26] ^ next_crc[27] ^ next_crc[28] ^ next_crc[30] ^ next_crc[31];
                next_crc[15] <= data_in[7] ^ data_in[5] ^ data_in[4] ^ data_in[3] ^ next_crc[7] ^ next_crc[27] ^ next_crc[28] ^ next_crc[29] ^ next_crc[31];
                next_crc[16] <= data_in[5] ^ data_in[4] ^ data_in[0] ^ next_crc[8] ^ next_crc[24] ^ next_crc[28] ^ next_crc[29];
                next_crc[17] <= data_in[6] ^ data_in[5] ^ data_in[1] ^ next_crc[9] ^ next_crc[25] ^ next_crc[29] ^ next_crc[30];
                next_crc[18] <= data_in[7] ^ data_in[6] ^ data_in[2] ^ next_crc[10] ^ next_crc[26] ^ next_crc[30] ^ next_crc[31];
                next_crc[19] <= data_in[7] ^ data_in[3] ^ next_crc[11] ^ next_crc[27] ^ next_crc[31];
                next_crc[20] <= data_in[4] ^ next_crc[12] ^ next_crc[28];
                next_crc[21] <= data_in[5] ^ next_crc[13] ^ next_crc[29];
                next_crc[22] <= data_in[0] ^ next_crc[14] ^ next_crc[24];
                next_crc[23] <= data_in[6] ^ data_in[1] ^ data_in[0] ^ next_crc[15] ^ next_crc[24] ^ next_crc[25] ^ next_crc[30];
                next_crc[24] <= data_in[7] ^ data_in[2] ^ data_in[1] ^ next_crc[16] ^ next_crc[25] ^ next_crc[26] ^ next_crc[31];
                next_crc[25] <= data_in[3] ^ data_in[2] ^ next_crc[17] ^ next_crc[26] ^ next_crc[27];
                next_crc[26] <= data_in[6] ^ data_in[4] ^ data_in[3] ^ data_in[0] ^ next_crc[18] ^ next_crc[24] ^ next_crc[27] ^ next_crc[28] ^ next_crc[30];
                next_crc[27] <= data_in[7] ^ data_in[5] ^ data_in[4] ^ data_in[1] ^ next_crc[19] ^ next_crc[25] ^ next_crc[28] ^ next_crc[29] ^ next_crc[31];
                next_crc[28] <= data_in[6] ^ data_in[5] ^ data_in[2] ^ next_crc[20] ^ next_crc[26] ^ next_crc[29] ^ next_crc[30];
                next_crc[29] <= data_in[7] ^ data_in[6] ^ data_in[3] ^ next_crc[21] ^ next_crc[27] ^ next_crc[30] ^ next_crc[31];
                next_crc[30] <= data_in[7] ^ data_in[4] ^ next_crc[22] ^ next_crc[28] ^ next_crc[31];
                next_crc[31] <= data_in[5] ^ next_crc[23] ^ next_crc[29];
                
                
                   
                ov_gmii_txd <= rv_add_preamble_data;//message normal transmission
                o_gmii_tx_en <= r_add_preamble_data_wr;
                ctrl_state <= CRC_S; 
            end
        end
        OUT_S:begin           
            if(crc_cnt==2'b00) begin
                o_gmii_tx_en <= 1'b1;
                ov_gmii_txd   <= lastcrc[15:8];
                ctrl_state <= OUT_S;  
                crc_cnt<=crc_cnt+1'b1;
            end
            else if(crc_cnt==2'b01)begin
                o_gmii_tx_en <= 1'b1;
                ov_gmii_txd   <= lastcrc[23:16];
                crc_cnt<=crc_cnt+1'b1;
                ctrl_state <= OUT_S; 
            end
            else if(crc_cnt==2'b10)begin
                o_gmii_tx_en <= 1'b1;
                ov_gmii_txd   <= lastcrc[31:24];
                crc_cnt<=crc_cnt+1'b1;
                ctrl_state <= OUT_S; 
            end
            else begin
                o_gmii_tx_en <= 1'b0;
                ov_gmii_txd <= 8'b0;
                crc_cnt<= 2'b0;
                next_crc <= 32'hffffffff;
                ctrl_state <= IDLE_S; 
            end
        end
        default:ctrl_state <= IDLE_S;
       
        endcase 
    end
end


endmodule

