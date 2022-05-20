// Copyright (C) 1953-2021 NUDT
// Verilog module name - centralized_buffer_interface
// Version: V3.2.3.20210831
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         read pkt from two regs and write pkt to ram.
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module centralized_buffer_interface
(
        i_clk,
        i_rst_n,
        
        iv_data1,
        iv_data2,
        
        i_data1_write_flag,
        i_data2_write_flag,
        iv_bufid,
        
        //o_bufid_ack,    
       
        ov_wdata,
        o_data_wr,
        ov_data_waddr,
        i_wdata_ack,
        transmission_state,
	    ov_debug_ts_out_cnt
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;  
// pkt input
input      [133:0]     iv_data1;
input      [133:0]     iv_data2;

input                  i_data1_write_flag;
input                  i_data2_write_flag;

input      [8:0]       iv_bufid;

//output reg             o_bufid_ack;
// pkt output
output reg [133:0]     ov_wdata;
output reg             o_data_wr;
output reg [15:0]      ov_data_waddr;
input                  i_wdata_ack;
//***************************************************
//              transmit pkt 
//***************************************************
// internal reg&wire for state machine
reg                    r_data1_read_flag;
reg                    r_data2_read_flag;
reg                    r_data1_empty; 
reg                    r_data2_empty; 
output reg        [2:0]       transmission_state;
localparam  TRANS_IDLE_S = 3'd0,
            TRANS_REG1_S = 3'd1,
            WAIT_REG1_ACK_S = 3'd2,
            TRANS_REG2_S = 3'd3,
            WAIT_REG2_ACK_S = 3'd4,
            DISC_DATA_S = 3'd5;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        ov_wdata <= 134'b0;
        o_data_wr <= 1'b0;
        ov_data_waddr <= 16'b0;
        
        r_data1_read_flag <= 1'b0;
        r_data2_read_flag <= 1'b0;
        
        //o_bufid_ack <= 1'b0;
        
        transmission_state <= TRANS_IDLE_S;
    end
    else begin
        case(transmission_state)
            TRANS_IDLE_S:begin
                if(r_data1_empty == 1'b0)begin //not empty
                    ov_wdata <= iv_data1;
                    o_data_wr <= 1'b1;
                    ov_data_waddr <= {iv_bufid,7'b0};
                    //o_bufid_ack <= 1'b1;
                    
                    r_data1_read_flag <= 1'b1;
                    transmission_state <= WAIT_REG1_ACK_S;                         
                end
                else begin
                    ov_wdata <= 134'b0;
                    o_data_wr <= 1'b0;
                    ov_data_waddr <= 16'b0;
                    //o_bufid_ack <= 1'b0;
                    r_data1_read_flag <= 1'b0;
                    r_data2_read_flag <= 1'b0;
                    transmission_state <=TRANS_IDLE_S;              
                end
            end
            TRANS_REG1_S:begin //write the data from the reg1 into PCB
                if(r_data1_empty == 1'b0)begin
                    ov_wdata <= iv_data1;
                    o_data_wr <= 1'b1;
                    ov_data_waddr <= ov_data_waddr + 16'b1;
                    r_data1_read_flag <= 1'b1;
                    r_data2_read_flag <= 1'b0;
                    transmission_state <= WAIT_REG1_ACK_S;  
                end
                else begin
                    o_data_wr <= 1'b0;
                    transmission_state <= TRANS_REG1_S;                 
                end
            end
            WAIT_REG1_ACK_S:begin//wait ack signal from PCB,and write the next data from reg2 into PCB
                //o_bufid_ack <= 1'b0;
                r_data1_read_flag <= 1'b0;
                if(i_wdata_ack == 1'b1)begin
                    o_data_wr <= 1'b0;
                    if(iv_data1[133:132] == 2'b10)begin
                        transmission_state <= TRANS_IDLE_S; 
                    end
                    else begin
                        transmission_state <= TRANS_REG2_S; 
                    end
                end
                else begin
                    transmission_state <= WAIT_REG1_ACK_S;  
                end
            end
            TRANS_REG2_S:begin //write the data from the reg2 into PCB
                if(r_data2_empty == 1'b0)begin
                    ov_wdata <= iv_data2;
                    o_data_wr <= 1'b1;
                    ov_data_waddr <= ov_data_waddr + 16'b1;
                    r_data1_read_flag <= 1'b0;
                    r_data2_read_flag <= 1'b1;              
                    transmission_state <= WAIT_REG2_ACK_S;  
                end
                else begin
                    o_data_wr <= 1'b0;
                    transmission_state <= TRANS_REG2_S;                 
                end
            end
            WAIT_REG2_ACK_S:begin//wait ack signal from PCB,and write the next data from reg1 into PCB
                r_data2_read_flag <= 1'b0;
                if(i_wdata_ack == 1'b1)begin
                    o_data_wr <= 1'b0;
                    if(iv_data2[133:132] == 2'b10)begin
                        transmission_state <= TRANS_IDLE_S; 
                    end
                    else begin
                        transmission_state <= TRANS_REG1_S; 
                    end                    
                end
                else begin
                    transmission_state <= WAIT_REG2_ACK_S;  
                end
            end         
            default:begin               
                transmission_state <=TRANS_IDLE_S;
            end
        endcase
   end
end 
//***************************************************
//      judge whether iv_data1 & iv_data2 is empty 
//***************************************************
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        r_data1_empty <= 1'b1; 
        r_data2_empty <= 1'b1;      
    end
    else begin
        if(i_data1_write_flag == 1'b1 && r_data1_read_flag == 1'b1)begin
            r_data1_empty <= r_data1_empty;
        end
        else if(i_data1_write_flag == 1'b1 && r_data1_read_flag == 1'b0)begin
            r_data1_empty <= 1'b0;
        end 
        else if(i_data1_write_flag == 1'b0 && r_data1_read_flag == 1'b1)begin
            r_data1_empty <= 1'b1;
        end         
        else if(i_data1_write_flag == 1'b0 && r_data1_read_flag == 1'b0)begin
            r_data1_empty <= r_data1_empty;
        end 
        
        if(i_data2_write_flag == 1'b1 && r_data2_read_flag == 1'b1)begin
            r_data2_empty <= r_data2_empty;
        end
        else if(i_data2_write_flag == 1'b1 && r_data2_read_flag == 1'b0)begin
            r_data2_empty <= 1'b0;
        end 
        else if(i_data2_write_flag == 1'b0 && r_data2_read_flag == 1'b1)begin
            r_data2_empty <= 1'b1;
        end         
        else if(i_data2_write_flag == 1'b0 && r_data2_read_flag == 1'b0)begin
            r_data2_empty <= r_data2_empty;
        end         
    end
end 
////////////debug//////////////////
output reg [15:0] ov_debug_ts_out_cnt;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        ov_debug_ts_out_cnt <= 16'b0;
    end
    else begin
		if(i_wdata_ack && (ov_wdata[133:125] == 9'b010000000))begin
			ov_debug_ts_out_cnt <= ov_debug_ts_out_cnt + 1'b1;
		end
		else begin
			ov_debug_ts_out_cnt <= ov_debug_ts_out_cnt;
		end
	end
end	
endmodule 