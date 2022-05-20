// Copyright (C) 1953-2022 NUDT
// Verilog module name - receive_mac_process 
// Version: V3.4.0.20220223
// Created:
//         by - fenglin 
//         at - 02.2022
////////////////////////////////////////////////////////////////////////////
// Description:
//         1.Deletion of CRC field；
//         2.message length is controlled within 60-1514 bytes；
//         3.IP length controlled；
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
module receive_mac_process(
    input             clk,
    input             rst_n,
    input             port_type,
                                               
    input  wire       gmii_rx_dv,
    input  wire       gmii_rx_er,
    input  wire [7:0] gmii_rxd,
    
    output reg        grc2ppt_gmii_dv,
    output reg        grc2ppt_gmii_er,
    output reg  [7:0] grc2ppt_gmii_data

);
/*/////////////////////////////////////////////////////////////////////
            Intermediate variable Declaration
*//////////////////////////////////////////////////////////////////////          
    reg             state0;
    wire            pos_edge;
    wire            neg_edge;
    reg             state1;
    wire            me_neg_edge;
    reg             gmii_rx_dv_r;
    reg             gmii_rx_er_r;
    reg  [    7:0]  gmii_rxd_r;
    
//Deletion of CRC field variable Intermediation
    reg   [2:0]     crc_rnt;
    reg             gmii_crc_dv;  
    reg             gmii_crc_er;
    reg  [    7:0]  gmii_crc_rxd;
    reg  [    7:0]  crc_delete0;
    reg  [    7:0]  crc_delete1;
    reg  [    7:0]  crc_delete2;
    reg  [    7:0]  crc_delete3;
    reg  [    3:0]  en_delete;
    reg  [    3:0]  er_delete;
    reg  [    1:0]  CRC_S;
    localparam CRC_START_S = 2'b00;
    localparam CRC_END_S = 2'b01;
    
//message length is controlled variable Intermediation
    reg             gmii_me_dv;  
    reg             gmii_me_er;
    reg  [    7:0]  gmii_me_rxd;
    reg  [   10:0]  me_cnt;
    reg  [    1:0]  ME_S;
    localparam ME_START_S = 2'b00;
    localparam ME_END_S = 2'b01;
    localparam ME_ADD_S = 2'b10;
    localparam ME_WAIT_S = 2'b11;
    
//IP length controlled variable Intermediation
    reg  [    1:0]  ip_lable; 
    reg  [   15:0]  ip_cnt;
    reg  [    2:0]  IP_S;
    reg  [   15:0]  length;
    localparam IP_START_S = 3'b000;
    localparam IP_END_S = 3'b001;
    localparam IP_WAIT_S = 3'b010;
    localparam IP_ADD_S = 3'b011;
    localparam IP_IDLE_S = 3'b100;
    localparam IP_ST_S = 3'b101;
    localparam IP_ASS_S = 3'b110;
/*/////////////////////////////////////////////////////////////////////
            Initial Driver
*//////////////////////////////////////////////////////////////////////       
always @(posedge clk)begin
    gmii_rx_dv_r <= gmii_rx_dv; 
    gmii_rx_er_r <= gmii_rx_er;
    gmii_rxd_r[7:0] <= gmii_rxd[7:0];
end
//enable signal detection of posedge and negedge
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        state0 <= 0;
        state1 <= 0;
    end
    else begin
        state0 <= gmii_rx_dv_r;
        state1 <= gmii_me_dv;
    end
end

assign pos_edge =  gmii_rx_dv_r && ~state0;
assign neg_edge = ~gmii_rx_dv_r && state0;
assign me_neg_edge = ~gmii_me_dv && state1;
reg             neg_edge_delay;

always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        neg_edge_delay <= 0;
    end
    else begin
        neg_edge_delay <= neg_edge;
    end
end 
//Deletion of CRC field
always @(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        crc_rnt <= 3'b0;
        gmii_crc_dv  <= 1'b0;
        gmii_crc_er <= 1'b0;
        gmii_crc_rxd[7:0] <= 8'b0;
        crc_delete0[7:0] <= 8'b0;
        crc_delete1[7:0] <= 8'b0;
        crc_delete2[7:0] <= 8'b0;
        crc_delete3[7:0] <= 8'b0;
        en_delete[3:0] <= 4'b0;
        er_delete[3:0] <= 4'b0;
        CRC_S <= CRC_END_S;
    end
    else begin
    /*
        if(pos_edge == 1)begin
            gmii_crc_dv  <= gmii_rx_dv;
            gmii_crc_er <= gmii_rx_er;
            gmii_crc_rxd[7:0] <= gmii_rxd[7:0];
            CRC_S <= CRC_START_S;
        end
        else begin
    */
            case(CRC_S)
                CRC_START_S:begin
                    if(neg_edge == 1)begin
                        gmii_crc_rxd  [7:0] <= gmii_rxd_r[7:0];
                        gmii_crc_dv <= gmii_rx_dv_r;
                        gmii_crc_er <= gmii_rx_er_r;
                        CRC_S <= CRC_END_S;
                    end
                    else begin
                        if(crc_rnt < 3'b100 )begin
                            crc_delete0[7:0] <= gmii_rxd_r[7:0];
                            en_delete[0] <= gmii_rx_dv_r;
                            er_delete[0] <= gmii_rx_er_r;
                            crc_delete1[7:0] <= crc_delete0[7:0];
                            en_delete[1] <= en_delete [0];
                            er_delete[1] <= er_delete [0];
                            crc_delete2[7:0] <= crc_delete1[7:0];
                            en_delete[2] <= en_delete [1];
                            er_delete[2] <= er_delete [1];
                            crc_delete3[7:0] <= crc_delete2[7:0];
                            en_delete[3] <= en_delete [2];
                            er_delete[3] <= er_delete [2];
                            gmii_crc_rxd[7:0] <= crc_delete3[7:0];
                            crc_rnt <= crc_rnt + 1'b1; 
                        end
                        else begin 
                            crc_delete0[7:0] <= gmii_rxd_r[7:0];
                            en_delete[0] <= gmii_rx_dv_r;
                            er_delete[0] <= gmii_rx_er_r;
                            crc_delete1[7:0] <= crc_delete0[7:0];
                            en_delete[1] <= en_delete [0];
                            er_delete[1] <= er_delete [0];
                            crc_delete2[7:0] <= crc_delete1[7:0];
                            en_delete[2] <= en_delete [1];
                            er_delete[2] <= er_delete [1];
                            crc_delete3[7:0] <= crc_delete2[7:0];
                            en_delete[3] <= en_delete [2];
                            er_delete[3] <= er_delete [2];
                            gmii_crc_rxd[7:0] <= crc_delete3[7:0];
                            gmii_crc_dv <= en_delete [3];
                            gmii_crc_er <= er_delete [3];
                            CRC_S <= CRC_START_S;
                        end
                    end
                end
                CRC_END_S:begin
                    if(pos_edge == 1)begin
                        en_delete <= gmii_rx_dv_r;
                        er_delete <= gmii_rx_er_r;
                        crc_delete0[7:0] <= gmii_rxd_r[7:0];
                        crc_rnt <= 3'b01; 
                        CRC_S <= CRC_START_S;
                    end
                    else begin
                        gmii_crc_rxd  [7:0] <= 8'b0;
                        gmii_crc_dv <= 1'b0;
                        gmii_crc_er <= 1'b0;
                        crc_delete0[7:0] <= 8'b0;
                        crc_delete1[7:0] <= 8'b0;
                        crc_delete2[7:0] <= 8'b0;
                        crc_delete3[7:0] <= 8'b0;
                        crc_rnt <= 3'b0; 
                        CRC_S <= CRC_END_S;
                    end
                end
            default: begin
                gmii_crc_dv <= 1'b0;
                gmii_crc_er <= 1'b0;
                gmii_crc_rxd [7:0] <= 8'b0;
                CRC_S <= CRC_END_S;
            end
            endcase
        //end
    end
end

//message length is controlled
reg [2:0] rv_cycle_cnt;//count 7B preamble and 1B SFD.
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        gmii_me_dv <= 1'b0;
        gmii_me_er <= 1'b0;
        gmii_me_rxd [7:0] <= 8'b0;
        me_cnt <= 0;
        rv_cycle_cnt <= 3'b0;
        ME_S <= ME_END_S;
    end
    else begin
            case(ME_S)
                ME_WAIT_S:begin
                    gmii_me_dv <= 1'b0;
                    gmii_me_er <= 1'b0;
                    gmii_me_rxd [7:0] <= 8'b0;            
                    if(gmii_crc_dv)begin
                        if(rv_cycle_cnt == 3'h0)begin
                            if(gmii_crc_rxd == 8'h55)begin
                                rv_cycle_cnt <= rv_cycle_cnt + 1'b1;
                                ME_S <= ME_WAIT_S;
                            end
                            else begin
                                rv_cycle_cnt <= 3'b0;
                                ME_S <= ME_END_S;                                     
                            end
                        end
                        else if(rv_cycle_cnt == 3'h1)begin
                            if(gmii_crc_rxd == 8'hd5)begin
                                rv_cycle_cnt <= 3'b0;
                                ME_S <= ME_START_S;
                            end
                            else if(gmii_crc_rxd == 8'h55)begin
                                rv_cycle_cnt <= 3'b1;
                                ME_S <= ME_WAIT_S;
                            end
                            else begin
                                rv_cycle_cnt <= 3'b0;
                                ME_S <= ME_END_S;
                            end
                        end
                    end                            
                    else begin
                        rv_cycle_cnt <= 3'b0;
                        ME_S <= ME_WAIT_S;
                    end
                end    
                ME_START_S:begin
                    if(neg_edge == 1)begin
                        if(me_cnt < 11'd60)begin
                            gmii_me_dv <= 1'b1;
                            gmii_me_er <= 1'b0;
                            gmii_me_rxd[7:0] <= gmii_crc_rxd[7:0];
                            me_cnt <= me_cnt + 1'b1;
                            ME_S <= ME_ADD_S;
                        end
                        else begin
                            gmii_me_dv <= 1'b1;
                            gmii_me_er <= gmii_crc_er;
                            gmii_me_rxd[7:0] <= gmii_crc_rxd[7:0];
                            me_cnt <= 11'd0;
                            ME_S <= ME_END_S;
                        end
                    end
                    else begin
                        if(me_cnt == 11'd1514)begin
                            gmii_me_dv <= 1'b0;
                            gmii_me_er <= 1'b0;
                            gmii_me_rxd[7:0] <= 8'd0;
                            me_cnt <= 11'd0;
                            ME_S <= ME_END_S;
                        end
                        else begin
                            gmii_me_dv <= gmii_crc_dv;
                            gmii_me_er <= gmii_crc_er;
                            gmii_me_rxd[7:0] <= gmii_crc_rxd[7:0];
                            me_cnt <= me_cnt + 1'b1;
                            ME_S <= ME_START_S;
                        end
                    end
                end
                ME_ADD_S:begin
                    if(me_cnt > 11'd60 || me_cnt == 11'd60)begin
                        gmii_me_dv <= gmii_crc_dv;
                        gmii_me_er <= gmii_crc_er;
                        gmii_me_rxd[7:0] <= gmii_crc_rxd[7:0];
                        me_cnt <= 0;
                        ME_S <= ME_END_S;
                    end
                    else begin
                        gmii_me_dv <= 1'b1;
                        gmii_me_er <= 1'b0;
                        gmii_me_rxd[7:0] <= 8'b0;
                        me_cnt <= me_cnt + 1'b1;
                        ME_S <= ME_ADD_S;
                    end
                end
                ME_END_S:begin
                    if(pos_edge == 1)begin
                        gmii_me_dv  <= gmii_crc_dv;
                        gmii_me_er <= gmii_crc_er;
                        gmii_me_rxd[7:0] <= gmii_crc_rxd[7:0];
                        me_cnt <= 1'b0;
                        ME_S <= ME_WAIT_S;
                    end
                    else begin
                        gmii_me_dv <= 1'b0;
                        gmii_me_er <= gmii_crc_er;
                        gmii_me_rxd[7:0] <= gmii_crc_rxd[7:0];
                        me_cnt <= 0;
                        ME_S <= ME_END_S;
                    end
                end
            endcase
        //end
    end
end 

//IP length controlled；
always @(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        grc2ppt_gmii_dv <= 1'b0;
        grc2ppt_gmii_er <= 1'b0;
        grc2ppt_gmii_data [7:0] <= 8'b0;
        ip_cnt <= 16'b0;
        length <=16'b0;
        ip_lable <= 1'b0;
        IP_S <= IP_END_S;
    end

    else begin
        case(IP_S)
            IP_IDLE_S:begin
                grc2ppt_gmii_dv         <= gmii_me_dv;
                grc2ppt_gmii_er         <= gmii_me_er;
                grc2ppt_gmii_data[7:0]  <= gmii_me_rxd[7:0];
                if(gmii_crc_rxd == 'hD5)begin
                    IP_S <= IP_WAIT_S;
                end
                else begin
                    IP_S <= IP_IDLE_S;
                end
            end

            IP_WAIT_S:begin
                if(ip_cnt == 16'd13)begin
                    if(gmii_me_rxd[7:0] == 8'h08)begin
                        grc2ppt_gmii_dv <= gmii_me_dv;
                        grc2ppt_gmii_er <= gmii_me_er;
                        grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                        ip_lable <= 1'b1;
                        ip_cnt <= ip_cnt + 1'b1;
                        IP_S <= IP_WAIT_S;
                    end
                    else begin
                        grc2ppt_gmii_dv <= gmii_me_dv;
                        grc2ppt_gmii_er <= gmii_me_er;
                        grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                        ip_cnt <= ip_cnt + 16'b1;
                        IP_S <= IP_END_S;
                    end
                end
                else if(ip_cnt == 16'd14)begin
                    if(gmii_me_rxd[7:0] == 8'h00 && ip_lable == 1'b1)begin
                        grc2ppt_gmii_dv <= gmii_me_dv;
                        grc2ppt_gmii_er <= gmii_me_er;
                        grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                        ip_lable <= 1'b0;
                        ip_cnt <= 1'b1;
                        IP_S <= IP_ST_S;
                    end
                    else begin
                        grc2ppt_gmii_dv <= gmii_me_dv;
                        grc2ppt_gmii_er <= gmii_me_er;
                        grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                        ip_cnt <= ip_cnt + 16'b1;
                        IP_S <= IP_END_S;
                    end
                end
                else  begin
                    grc2ppt_gmii_dv <= gmii_me_dv;
                    grc2ppt_gmii_er <= gmii_me_er;
                    grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                    ip_cnt <= ip_cnt + 1'b1;
                    IP_S <= IP_WAIT_S; 
                end
            end
            IP_ST_S:begin
                if(ip_cnt == 16'd3)begin
                    grc2ppt_gmii_dv <= gmii_me_dv;
                    grc2ppt_gmii_er <= gmii_me_er;
                    grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                    ip_cnt <= ip_cnt + 1'b1;
                    length[15:8] <= gmii_me_rxd[7:0];
                    IP_S <= IP_ST_S;
                end
                else if(ip_cnt == 16'd4)begin
                    grc2ppt_gmii_dv <= gmii_me_dv;
                    grc2ppt_gmii_er <= gmii_me_er;
                    grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                    ip_cnt <= ip_cnt + 1'b1;
                    length[7:0] <= gmii_me_rxd[7:0];
                    
                    IP_S <= IP_START_S;
                end
                
                else  begin
                    grc2ppt_gmii_dv <= gmii_me_dv;
                    grc2ppt_gmii_er <= gmii_me_er;
                    grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                    ip_cnt <= ip_cnt + 1'b1;
                    IP_S <= IP_ST_S; 
                end

            end
            
            IP_START_S:begin
                if(length > 16'd1500)begin
                    length <= 16'd1500;
                end
                else if(length < 16'd46)begin
                    length <= 16'd46;
                end
                else begin
                    length <= length;
                end
                
                if(neg_edge_delay == 1)begin
                    if(ip_cnt < length)begin
                        grc2ppt_gmii_dv <= 1'b1;
                        grc2ppt_gmii_er <= 1'b0;
                        grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                        ip_cnt <= ip_cnt + 1'b1;
                        IP_S <= IP_ADD_S;
                    end
                    else begin
                        grc2ppt_gmii_dv <= 1'b1;
                        grc2ppt_gmii_er <= gmii_me_er;
                        grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                        ip_cnt <= 16'd0;
                        IP_S <= IP_END_S;
                    end
                end
                else if(ip_cnt == length)begin
                    grc2ppt_gmii_dv <= gmii_me_dv;
                    grc2ppt_gmii_er <= gmii_me_er;
                    grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                    ip_cnt <= 16'd0;
                    IP_S <= IP_END_S;
                end
                else begin
                    grc2ppt_gmii_dv <= gmii_me_dv;
                    grc2ppt_gmii_er <= gmii_me_er;
                    grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                    ip_cnt <= ip_cnt + 1'b1;
                    IP_S <= IP_START_S;
                end
            end
            IP_ADD_S:begin
                if(ip_cnt == length)begin
                    grc2ppt_gmii_dv <= 1'b1;
                    grc2ppt_gmii_er <= 1'b0;
                    grc2ppt_gmii_data [7:0] <= 8'b0;
                    ip_cnt <= 16'd0;
                    IP_S <= IP_END_S;
                end
                else begin
                    grc2ppt_gmii_dv <= 1'b1;
                    grc2ppt_gmii_er <= 1'b0;
                    grc2ppt_gmii_data [7:0] <= 8'b0; 
                    ip_cnt <= ip_cnt + 1'b1;
                    IP_S <= IP_ADD_S;
                end
            end
            IP_END_S:begin
                if(pos_edge == 1)begin
                    grc2ppt_gmii_dv <= gmii_me_dv;
                    grc2ppt_gmii_er <= gmii_me_er;
                    grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                    ip_lable <= 1'b0;
                    ip_cnt <= 16'd0;
                    if(port_type == 1)begin
                        IP_S <= IP_IDLE_S;
                    end
                    else begin
                        IP_S <= IP_ASS_S;
                    end
                end
                else if((gmii_me_dv == 1'b1) && (ip_cnt != 16'd0))begin
                    grc2ppt_gmii_dv <= 1'b1;
                    grc2ppt_gmii_er <= gmii_me_er;
                    grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                    ip_cnt <= ip_cnt + 16'd1;
                    IP_S <= IP_END_S;
                end
                else begin
                    grc2ppt_gmii_dv <= 1'b0;
                    grc2ppt_gmii_er <= gmii_me_er;
                    grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                    ip_cnt <= 16'd0;
                    IP_S <= IP_END_S;
                end
            end
            IP_ASS_S:begin
                if(me_neg_edge == 1)begin
                    ip_cnt <= 16'd0;
                    grc2ppt_gmii_dv <= gmii_me_dv;
                    grc2ppt_gmii_er <= gmii_me_er;
                    grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                    IP_S <= IP_END_S;
                end
                else begin
                    grc2ppt_gmii_dv <= gmii_me_dv;
                    grc2ppt_gmii_er <= gmii_me_er;
                    grc2ppt_gmii_data [7:0] <= gmii_me_rxd[7:0];
                    IP_S <= IP_ASS_S;
                end 
            end
        endcase
    end
end

endmodule
