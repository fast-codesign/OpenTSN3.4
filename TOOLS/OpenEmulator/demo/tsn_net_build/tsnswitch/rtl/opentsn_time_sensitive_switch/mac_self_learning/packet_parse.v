// Copyright (C) 1953-2020 NUDT
// Verilog module name - packet_parse
// Version: V3.2_20210722
// Created:
//         by - wumaowen 
//         at - 7.2021
////////////////////////////////////////////////////////////////////////////
// Description:
//         pkt parse,extract standard pkt SMAC and inport
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module packet_parse
(
        i_clk,
        i_rst_n,
      
        iv_data,
        i_data_wr,
        iv_rec_ts,
    
        ov_data,
        o_data_wr,
        ov_rec_ts,
		
        ov_smac_ppa2ecp,
        ov_inport_ppa2ecp,
        o_data_wr_ppa2ecp
);

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;

input       [8:0]       iv_data;
input                   i_data_wr;
input       [18:0]      iv_rec_ts;
// data output
output  reg [8:0]       ov_data;
output  reg             o_data_wr;
output  reg [18:0]      ov_rec_ts;

output  reg [47:0]      ov_smac_ppa2ecp;
output  reg [8:0]       ov_inport_ppa2ecp;
output  reg             o_data_wr_ppa2ecp;

// internal reg&wire
reg         [3:0]       rv_cycle_cnt;
reg         [2:0]       ppa_state;
reg         [134:0]     rv_pkt_data;
reg         [15:0]      rv_pkt_type;
reg         [18:0]      rv_rec_ts;
localparam  idle_s      = 3'd0,
            tsn_s      = 3'd1,
            tran_s      = 3'd2,
            tail_s      = 3'd3,
            standard_s  = 3'd4,
			discard_s   = 3'd5;
 
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_pkt_data <= 135'b0;
    end
    else begin
        rv_pkt_data <= {rv_pkt_data[125:0],iv_data};
    end
end

//extract pkt type
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_pkt_type <= 16'b0;        
        rv_cycle_cnt <= 4'b0;  
        rv_rec_ts <= 19'b0;
    end
    else begin
        if(i_data_wr == 1'b1)begin
            if(rv_cycle_cnt == 4'd15)begin
                rv_cycle_cnt <= rv_cycle_cnt; 
            end
            else begin
                rv_cycle_cnt <= rv_cycle_cnt + 1'b1; 
            end
        end
        else begin
            rv_cycle_cnt <= 4'b0; 
        end 
        if((i_data_wr == 1'b1) && (rv_cycle_cnt == 4'd0))begin
            rv_rec_ts <= iv_rec_ts;          
        end
        else begin
            rv_rec_ts <= rv_rec_ts;
        end        
        if((i_data_wr == 1'b1) && (rv_cycle_cnt == 4'd12))begin
            rv_pkt_type <= {iv_data[7:0],8'b0};          
        end
        else if(rv_cycle_cnt == 4'd13)begin
            rv_pkt_type <= {rv_pkt_type[15:8],iv_data[7:0]};             
        end
        else begin
            rv_pkt_type <= rv_pkt_type;
        end
            
    end
end
 
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin
        ov_data         <= 9'b0;
        o_data_wr       <= 1'b0;
		ov_smac_ppa2ecp <= 48'b0;
		ov_inport_ppa2ecp  <= 9'b0;
		o_data_wr_ppa2ecp  <= 1'b0;
        ov_rec_ts  <= 19'b0;
		
        ppa_state <= idle_s;
        end
    else begin
        case(ppa_state)
            idle_s:begin
                ov_data         <= 9'b0;
				o_data_wr       <= 1'b0;
				ov_smac_ppa2ecp <= 48'b0;
				ov_inport_ppa2ecp  <= 9'b0;
				o_data_wr_ppa2ecp  <= 1'b0;
                if(rv_cycle_cnt== 4'd15)begin
					if((rv_pkt_type == 16'h1800)||(rv_pkt_type == 16'h98f7)||(rv_pkt_type == 16'hff01))begin
						if(i_data_wr)begin //tsn pkt
							ov_data         <= rv_pkt_data[134:126];
                            ov_rec_ts <= rv_rec_ts;
							o_data_wr       <= 1'b1;
							ppa_state <= tsn_s;
						end
						else begin
							ppa_state <= idle_s;
						end                    
					end
					else begin           
						if(i_data_wr)begin // not tsn pkt
						 	ov_smac_ppa2ecp <= {rv_pkt_data[79:72],rv_pkt_data[70:63],rv_pkt_data[61:54],rv_pkt_data[52:45],rv_pkt_data[43:36],rv_pkt_data[34:27]};
							o_data_wr_ppa2ecp  <= 1'b1;
							case(rv_pkt_data[84:81])
								4'd0:ov_inport_ppa2ecp  <= 9'b0_0000_0001;
								4'd1:ov_inport_ppa2ecp  <= 9'b0_0000_0010;
								4'd2:ov_inport_ppa2ecp  <= 9'b0_0000_0100;
								4'd3:ov_inport_ppa2ecp  <= 9'b0_0000_1000;
								4'd4:ov_inport_ppa2ecp  <= 9'b0_0001_0000;
								4'd5:ov_inport_ppa2ecp  <= 9'b0_0010_0000;
								4'd6:ov_inport_ppa2ecp  <= 9'b0_0100_0000;
								4'd7:ov_inport_ppa2ecp  <= 9'b0_1000_0000;	
								4'd8:ov_inport_ppa2ecp  <= 9'b1_0000_0000;	
								default:ov_inport_ppa2ecp  <= 9'b0;
							endcase
							ppa_state <= standard_s;
						end
						else begin
							ppa_state <= idle_s;
						end    
					end
				end
				else begin
				    ppa_state <= idle_s;
				end
            end
            tsn_s:begin
                if(rv_pkt_data[134] == 1'b0 ) begin//judge frame head,and make sure pkt body is not empty.
                    ov_data         <= rv_pkt_data[134:126];
                    ov_rec_ts <= 19'b0;
					o_data_wr       <= 1'b1;
                    ppa_state     <= tran_s;
                end
                else begin                   
                    ppa_state     <= tail_s;
                end
            end
			standard_s:begin
				if(i_data_wr)begin
					ov_smac_ppa2ecp <= 48'b0;
					ov_inport_ppa2ecp  <=9'b0;
					o_data_wr_ppa2ecp  <= 1'b0;
					ov_data         <= 9'b0;
					o_data_wr       <= 1'b0;	
					ppa_state     <= standard_s;						
				end
				else begin
					ppa_state     <= discard_s;	
				end
			end
            tran_s:begin
                ov_data         <= rv_pkt_data[134:126];
			    o_data_wr       <= 1'b1;
				if(rv_pkt_data[134] == 1'b0)begin
					ppa_state     <= tran_s;
				end
				else begin
					ppa_state     <= tail_s;					
				end
            end				
            tail_s:begin
                if(rv_pkt_data[134] == 1'b1) begin//tail
                    ov_data             <= rv_pkt_data[134:126];
                    o_data_wr           <= 1'b1;             
                    ppa_state     <= tail_s;
                    end
                else begin
					ov_data             <= 9'b0;
                    o_data_wr           <= 1'b0;
                    ppa_state     <= idle_s;
                end             
            end
            discard_s:begin
				ov_data             <= 9'b0;
                o_data_wr           <= 1'b0;
                if(rv_pkt_data[134 ] == 1'b1) begin//tail        
                    ppa_state     <= discard_s;
                end
                else begin
                    ppa_state     <= tail_s;           
                end
			end				
            default:begin
                ov_data             <= 9'b0;
                o_data_wr           <= 1'b0;
                ppa_state     <= idle_s;              
            end
        endcase
    end
end        
endmodule