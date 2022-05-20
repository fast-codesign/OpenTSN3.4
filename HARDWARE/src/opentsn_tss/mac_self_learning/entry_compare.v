// Copyright (C) 1953-2020 NUDT
// Verilog module name - entry_compare
// Version: V3.2_20210722
// Created:
//         by - wumaowen 
//         at - 7.2021
////////////////////////////////////////////////////////////////////////////
// Description:
//         pkt parse,extract standard pkt SMAC and inport
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module entry_compare(
        i_clk,
        i_rst_n,
      
        iv_smac_ppa2ecp,
		iv_inport_ppa2ecp,
		i_data_wr_ppa2ecp,
		
        ov_smac_inport,
        o_data_wr,
        ov_entry_addr      
);

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;

input       [47:0]      iv_smac_ppa2ecp;
input       [8:0]       iv_inport_ppa2ecp;
input                   i_data_wr_ppa2ecp;
// data output
output  reg [56:0]      ov_smac_inport;
output  reg [4:0]       ov_entry_addr;
output  reg             o_data_wr;
// internal reg&wire
reg         [57:0]       mac_forword_table0;
reg         [57:0]       mac_forword_table1;
reg         [57:0]       mac_forword_table2;
reg         [57:0]       mac_forword_table3;
reg         [57:0]       mac_forword_table4;
reg         [57:0]       mac_forword_table5;
reg         [57:0]       mac_forword_table6;
reg         [57:0]       mac_forword_table7;
reg         [57:0]       mac_forword_table8;
reg         [57:0]       mac_forword_table9;
reg         [57:0]       mac_forword_table10;
reg         [57:0]       mac_forword_table11;
reg         [57:0]       mac_forword_table12;
reg         [57:0]       mac_forword_table13;
reg         [57:0]       mac_forword_table14;
reg         [57:0]       mac_forword_table15;
reg         [57:0]       mac_forword_table16;
reg         [57:0]       mac_forword_table17;
reg         [57:0]       mac_forword_table18;
reg         [57:0]       mac_forword_table19;
reg         [57:0]       mac_forword_table20;
reg         [57:0]       mac_forword_table21;
reg         [57:0]       mac_forword_table22;
reg         [57:0]       mac_forword_table23;
reg         [57:0]       mac_forword_table24;
reg         [57:0]       mac_forword_table25;
reg         [57:0]       mac_forword_table26;
reg         [57:0]       mac_forword_table27;
reg         [57:0]       mac_forword_table28;
reg         [57:0]       mac_forword_table29;
reg         [57:0]       mac_forword_table30;
reg         [57:0]       mac_forword_table31;

reg [5:0]        rv_mac_cnt;
reg [4:0]        rv_addr;
reg [31:0]       rv_mac_flag;
reg [56:0]       rv_smac_inport;

reg         [2:0]       ecp_state;
localparam  idle_s      = 3'd0,
            lut_s       = 3'd1,
            tran_s      = 3'd2;

always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
		ov_smac_inport <= 57'b0;
		rv_smac_inport <= 57'b0;
		ov_entry_addr <= 5'b0;
		rv_mac_flag  <=  32'b0;
		o_data_wr      <= 1'b0;
		rv_mac_cnt     <= 6'b0;
		rv_addr        <= 5'b0;
		mac_forword_table0 <= 58'b0;
		mac_forword_table1 <= 58'b0;		
		mac_forword_table2 <= 58'b0;
		mac_forword_table3 <= 58'b0;
		mac_forword_table4 <= 58'b0;
		mac_forword_table5 <= 58'b0;
		mac_forword_table6 <= 58'b0;
		mac_forword_table7 <= 58'b0;
		mac_forword_table8 <= 58'b0;	
		mac_forword_table9 <= 58'b0;
		mac_forword_table10 <= 58'b0;		
		mac_forword_table11 <= 58'b0;
		mac_forword_table12 <= 58'b0;
		mac_forword_table13 <= 58'b0;
		mac_forword_table14 <= 58'b0;
		mac_forword_table15 <= 58'b0;
		mac_forword_table16 <= 58'b0;
		mac_forword_table17 <= 58'b0;	
		mac_forword_table18 <= 58'b0;
		mac_forword_table19 <= 58'b0;		
		mac_forword_table20 <= 58'b0;
		mac_forword_table21 <= 58'b0;
		mac_forword_table22 <= 58'b0;
		mac_forword_table23 <= 58'b0;
		mac_forword_table24 <= 58'b0;
		mac_forword_table25 <= 58'b0;
		mac_forword_table26 <= 58'b0;
		mac_forword_table27 <= 58'b0;
		mac_forword_table28 <= 58'b0;		
		mac_forword_table29 <= 58'b0;
		mac_forword_table30 <= 58'b0;
		mac_forword_table31 <= 58'b0;
		ecp_state      <= idle_s;
    end
    else begin
        case(ecp_state)
            idle_s:begin 
				ov_smac_inport <= 57'b0;
				ov_entry_addr  <= 5'b0;
				o_data_wr      <= 1'b0;			
				rv_mac_cnt     <= 6'b0;			
		        if(i_data_wr_ppa2ecp == 1'b1)begin//macdata	enable		
					rv_smac_inport <= {iv_inport_ppa2ecp,iv_smac_ppa2ecp};
					ecp_state      <= lut_s;
				end
				else begin
					rv_smac_inport  <= 57'b0;
					ecp_state       <= idle_s;				
				end
			end
			lut_s:begin
				if(rv_mac_cnt==6'd32)begin
					ecp_state      <= tran_s;
				end
				else begin 
					ecp_state      <= lut_s;
				end
				case(rv_mac_cnt)
					6'd0:begin
						if(mac_forword_table0[57]) begin  // reg mac_forword_table0 flag 
							if(mac_forword_table0[47:0]== rv_smac_inport[47:0])begin//smac compare
								if(mac_forword_table0[56:48]== rv_smac_inport[56:48])begin//inport compare
                                    rv_mac_flag[0]  <= 1'b0;	//not updata rv_addr==5'd0
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[0]  <= 1'b1;	//updata rv_addr==5'd0
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin //lookup to mac_forword_table1
								rv_mac_flag[0]  <= 1'b1;
								rv_mac_cnt      <= rv_mac_cnt +1'b1;
							end
						end
						else begin   //updata rv_addr==5'd0
							rv_mac_cnt      <= 6'd32;
							rv_addr         <= rv_mac_cnt[4:0];
							rv_mac_flag[0]  <= 1'b1;
						end
					end
					6'd1:begin
						if(mac_forword_table1[57]) begin  
							if(mac_forword_table1[47:0]== rv_smac_inport[47:0])begin//smac compare
								if(mac_forword_table1[56:48]== rv_smac_inport[56:48])begin//inport compare
                                    rv_mac_flag[1]  <= 1'b0;	//not updata rv_addr==5'd1
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[1]  <= 1'b1;	//updata rv_addr==5'd1
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin //lookup to mac_forword_table1
								rv_mac_flag[1]  <= 1'b1;
								rv_mac_cnt      <= rv_mac_cnt +1'b1;
							end
                        end    
						else begin
							rv_mac_cnt      <= 6'd32;
							rv_addr         <= rv_mac_cnt[4:0];							
							rv_mac_flag[1]  <= 1'b1;
						end
					end 
				    6'd2:begin
						if(mac_forword_table2[57]) begin  
							if(mac_forword_table2[47:0]== rv_smac_inport[47:0])begin//smac compare
								if(mac_forword_table2[56:48]== rv_smac_inport[56:48])begin//inport compare
                                    rv_mac_flag[2]  <= 1'b0;	//not updata rv_addr==5'd2
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[2]  <= 1'b1;	//updata rv_addr==5'd2
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[2]      <= 1'b1;
								rv_mac_cnt          <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[2]  <= 1'b1;
							rv_addr         <= rv_mac_cnt[4:0];	
							rv_mac_cnt      <= 6'd32;
						end
					end                        
				    6'd3:begin
						if(mac_forword_table3[57]) begin  
							if(mac_forword_table3[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table3[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[3]  <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[3]  <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[3]      <= 1'b1;
								rv_mac_cnt          <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[3]  <=1'b1;
							rv_addr         <= rv_mac_cnt[4:0];	
							rv_mac_cnt      <= 6'd32;
						end                          
					end                               
				    6'd4:begin
						if(mac_forword_table4[57]) begin  
							if(mac_forword_table4[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table4[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[4]  <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[4]  <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[4]      <= 1'b1;
								rv_mac_cnt          <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[4]  <= 1'b1;
							rv_addr         <= rv_mac_cnt[4:0];	
							rv_mac_cnt      <= 6'd32;
						end                          
					end  
				    6'd5:begin
						if(mac_forword_table5[57]) begin  
							if(mac_forword_table5[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table5[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[5]  <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[5]  <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[5]      <= 1'b1;
								rv_mac_cnt          <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[5]   <= 1'b1;
							rv_addr          <= rv_mac_cnt[4:0];	
							rv_mac_cnt       <= 6'd32;
						end                          
					end 
				    6'd6:begin
						if(mac_forword_table6[57]) begin  
							if(mac_forword_table6[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table6[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[6]  <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[6]  <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[6]  <= 1'b1;
								rv_mac_cnt      <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[6]  <= 1'b1;
							rv_addr         <= rv_mac_cnt[4:0];	
							rv_mac_cnt      <= 6'd32;
						end                          
					end 
				    6'd7:begin
						if(mac_forword_table7[57]) begin  
							if(mac_forword_table7[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table7[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[7]  <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[7]  <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[7] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[7] <=  1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd8:begin
						if(mac_forword_table8[57]) begin  
							if(mac_forword_table8[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table8[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[8]  <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[8]  <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[8] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[8] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd9:begin
						if(mac_forword_table9[57]) begin  
							if(mac_forword_table9[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table9[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[9]  <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[9]  <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[9] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[9] <=  1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 	
				    6'd10:begin
						if(mac_forword_table10[57]) begin  
							if(mac_forword_table10[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table10[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[10]  <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[10]  <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[10] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[10] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 	
				    6'd11:begin
						if(mac_forword_table11[57]) begin  
							if(mac_forword_table11[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table11[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[11]  <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[11]  <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[11] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[11] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 	
				    6'd12:begin
						if(mac_forword_table12[57]) begin  
							if(mac_forword_table12[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table12[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[12]  <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[12]  <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[12] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[12] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 	
				    6'd13:begin
						if(mac_forword_table13[57]) begin  
							if(mac_forword_table13[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table13[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[13] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[13]  <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[13] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[13] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd14:begin
						if(mac_forword_table14[57]) begin  
							if(mac_forword_table14[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table14[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[14]  <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[14]  <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[14] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[14] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd15:begin
						if(mac_forword_table15[57]) begin  
							if(mac_forword_table15[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table15[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[15]  <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[15]  <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[15] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[15] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd16:begin
						if(mac_forword_table16[57]) begin  
							if(mac_forword_table16[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table16[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[16] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[16] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[16] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[16] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd17:begin
						if(mac_forword_table17[57]) begin  
							if(mac_forword_table17[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table17[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[17] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[17] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[17] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[17] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd18:begin
						if(mac_forword_table18[57]) begin  
							if(mac_forword_table18[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table18[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[18] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[18] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[18] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[18] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd19:begin
						if(mac_forword_table19[57]) begin  
							if(mac_forword_table19[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table19[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[19] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[19] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[19] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[19] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd20:begin
						if(mac_forword_table20[57]) begin  
							if(mac_forword_table20[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table20[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[20] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[20] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[20] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[20] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd21:begin
						if(mac_forword_table21[57]) begin  
							if(mac_forword_table21[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table21[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[21] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[21] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[21] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[21] <=1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd22:begin
						if(mac_forword_table22[57]) begin  
							if(mac_forword_table22[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table22[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[22] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[22] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[22] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[22] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd23:begin
						if(mac_forword_table23[57]) begin  
							if(mac_forword_table23[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table23[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[23] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[23] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[23] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[23] <=1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd24:begin
						if(mac_forword_table24[57]) begin  
							if(mac_forword_table24[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table24[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[24] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[24] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[24] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[24] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd25:begin
						if(mac_forword_table25[57]) begin  
							if(mac_forword_table25[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table25[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[25] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[25] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[25] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[25] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd26:begin
						if(mac_forword_table26[57]) begin  
							if(mac_forword_table26[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table26[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[26] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[26] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[26] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[26] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd27:begin
						if(mac_forword_table27[57]) begin  
							if(mac_forword_table27[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table27[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[27] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[27] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[27] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[27] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 				
				    6'd28:begin
						if(mac_forword_table28[57]) begin  
							if(mac_forword_table28[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table28[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[28] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[28] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[28] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[28] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 								
				    6'd29:begin
						if(mac_forword_table29[57]) begin  
							if(mac_forword_table29[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table29[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[29] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[29] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[29] <= 1'b1;							
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[29] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 				
				    6'd30:begin
						if(mac_forword_table30[57]) begin  
							if(mac_forword_table30[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table30[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[30] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[30] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[30] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[30] <= 1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 
				    6'd31:begin
						if(mac_forword_table31[57]) begin  
							if(mac_forword_table31[47:0]== rv_smac_inport[47:0])begin
								if(mac_forword_table31[56:48]== rv_smac_inport[56:48])begin
                                    rv_mac_flag[31] <= 1'b0;
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;
                                end
                                else begin
                                    rv_mac_flag[31] <= 1'b1;	
								    rv_addr         <= rv_mac_cnt[4:0];
								    rv_mac_cnt      <= 6'd32;                                
                                end                                    
							end
							else begin
								rv_mac_flag[31] <= 1'b1;
								rv_mac_cnt  <= rv_mac_cnt +1'b1;
							end
						end
						else begin
							rv_mac_flag[31] <=1'b1;
							rv_addr <= rv_mac_cnt[4:0];	
							rv_mac_cnt  <= 6'd32;
						end                          
					end 					
					default:begin
						rv_mac_flag <= rv_mac_flag;   
					end 		
				endcase    							
            end
			tran_s:begin	
				case(rv_addr)
					5'd0:begin
						if(rv_mac_flag[0]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table0  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end
					end
					5'd1:begin
						if(rv_mac_flag[1]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table1<={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end
					end 
				    5'd2:begin
						if(rv_mac_flag[2]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table2  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end
					end                        
				    5'd3:begin
						if(rv_mac_flag[3]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table3  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                        
					end                               
				    5'd4:begin
						if(rv_mac_flag[4]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table4  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                        
					end  
				    5'd5:begin
						if(rv_mac_flag[5]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table5  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                        
					end 
				    5'd6:begin
						if(rv_mac_flag[6]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table6  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                        
					end 
				    5'd7:begin
						if(rv_mac_flag[7]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table7  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                      
					end 
				    5'd8:begin
						if(rv_mac_flag[8]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table8  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                        
					end 
				    5'd9:begin
						if(rv_mac_flag[9]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table9  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                       
					end 	
				    5'd10:begin
						if(rv_mac_flag[10]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table10  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                         
					end 	
				    5'd11:begin
						if(rv_mac_flag[11]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table11  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                        
					end 	
				    5'd12:begin
						if(rv_mac_flag[12]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table12  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                         
					end 	
				    5'd13:begin
						if(rv_mac_flag[13]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table13  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                        
					end 
				    5'd14:begin
						if(rv_mac_flag[14]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table14  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                          
					end 
				    5'd15:begin
						if(rv_mac_flag[15]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table15  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                         
					end 
				    5'd16:begin
						if(rv_mac_flag[16]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table16  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                         
					end 
				    5'd17:begin
						if(rv_mac_flag[17]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table17  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                        
					end 
				    5'd18:begin
						if(rv_mac_flag[18]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table18  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                          
					end 
				    5'd19:begin
						if(rv_mac_flag[19]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table19  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                         
					end 
				    5'd20:begin
						if(rv_mac_flag[20]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table20  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                   
					end 
				    5'd21:begin
						if(rv_mac_flag[21]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table21  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                        
					end 
				    5'd22:begin
						if(rv_mac_flag[22]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table22  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                         
					end 
				    5'd23:begin
						if(rv_mac_flag[23]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table23  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                     
					end 
				    5'd24:begin
						if(rv_mac_flag[24]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table24  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                        
					end 
				    5'd25:begin
						if(rv_mac_flag[25]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table25  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                      
					end 
				    5'd26:begin
						if(rv_mac_flag[26]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table26  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                      
					end 
				    5'd27:begin
						if(rv_mac_flag[27]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table27  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                        
					end 				
				    5'd28:begin
						if(rv_mac_flag[28]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table28  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                       
					end 								
				    5'd29:begin
						if(rv_mac_flag[29]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table29  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                       
					end 				
				    5'd30:begin
						if(rv_mac_flag[30]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table30  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                      
					end 
				    5'd31:begin
						if(rv_mac_flag[31]) begin  
							o_data_wr      <= 1'b1;
							ov_smac_inport <= rv_smac_inport;
							ov_entry_addr <= rv_addr;
							mac_forword_table31  <={1'b1,rv_smac_inport};
						end
						else begin
							o_data_wr      <= 1'b0;
							ov_smac_inport <= 57'b0;
							ov_entry_addr <= 5'b0;
						end                         
					end 					
					default:begin
						o_data_wr      <= 1'b0;
                        ov_smac_inport <= 57'b0;
                        ov_entry_addr <= 5'b0;					
					end 		
				endcase  
				ecp_state      <= idle_s;
            end
			default:begin
				ov_smac_inport <= 57'b0;
				rv_smac_inport <= 57'b0;
				ov_entry_addr <= 5'b0;
				rv_mac_flag  <=  32'b0;
				o_data_wr      <= 1'b0;
				rv_mac_cnt     <= 6'b0;
				ecp_state      <= idle_s; 
			end 						
		endcase           
    end
end

endmodule