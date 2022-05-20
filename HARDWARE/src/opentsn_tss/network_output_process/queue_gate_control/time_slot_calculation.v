// Copyright (C) 1953-2022 NUDT
// Verilog module name - time_slot_calculation 
// Version: V3.4.0.20220226
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         calculation of time slot 
//             - calculate time slot according to syned global time and time slot length.
///////////////////////////////////////////////////////////////////////////
`timescale 1ns/100ps

module time_slot_calculation
(
       i_clk,
       i_rst_n,
       
       iv_syn_clk,
       iv_time_slot_length,
       
       iv_slot_period,
       
       ov_time_slot,
       o_time_slot_switch       
);

// I/O
// clk & rst
input                  i_clk;
input                  i_rst_n;
// calculation of time slot
input      [63:0]      iv_syn_clk;  //[47:7]:us_cnt ; [6:0]:cycle_cnt.      
input      [10:0]      iv_time_slot_length;    // measure:us; 10 means time slot length is 10us.
// period of injection slot table
input      [10:0]      iv_slot_period;//measure:time slot period. 
// time slot
output reg [9:0]       ov_time_slot;//current time slot 
output reg             o_time_slot_switch;       
//***************************************************
//                time slot count
//***************************************************  
reg       [19:0]    rv_local_slot_time;
reg                 r_previous_slot_flag;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_local_slot_time <= 20'd0;
        r_previous_slot_flag <= 1'b0;
        ov_time_slot <= 10'd0;
        o_time_slot_switch <= 1'b0;
    end
    else begin
        if (|iv_slot_period)begin
            case(iv_time_slot_length)  
                11'd4:begin//4096ns
                    if(iv_syn_clk[11:0] == 12'b0 || rv_local_slot_time == 20'd4088)begin
                        rv_local_slot_time <= 20'd0;
                    end
                    else begin
                        rv_local_slot_time <= rv_local_slot_time + 20'd8;
                    end
                 
                    if((iv_syn_clk[11:0] == 12'b0 && (iv_syn_clk[12] == ~r_previous_slot_flag)) || (rv_local_slot_time == 20'd4088))begin
                        o_time_slot_switch <= 1'b1;
                        r_previous_slot_flag <= ~r_previous_slot_flag;
                        if(iv_syn_clk[12] == ~r_previous_slot_flag)begin
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= {9'b0,iv_syn_clk[12:12]};
                                11'd4:   ov_time_slot <= {8'b0,iv_syn_clk[13:12]};
                                11'd8:   ov_time_slot <= {7'b0,iv_syn_clk[14:12]};
                                11'd16:  ov_time_slot <= {6'b0,iv_syn_clk[15:12]};
                                11'd32:  ov_time_slot <= {5'b0,iv_syn_clk[16:12]};
                                11'd64:  ov_time_slot <= {4'b0,iv_syn_clk[17:12]};
                                11'd128: ov_time_slot <= {3'b0,iv_syn_clk[18:12]};
                                11'd256: ov_time_slot <= {2'b0,iv_syn_clk[19:12]};
                                11'd512: ov_time_slot <= {1'b0,iv_syn_clk[20:12]};
                                11'd1024:ov_time_slot <= iv_syn_clk[21:12];
                                default:ov_time_slot <=  iv_syn_clk[21:12];
                            endcase
                        end
                        else begin                            
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= (ov_time_slot == 10'd1   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd4:   ov_time_slot <= (ov_time_slot == 10'd3   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd8:   ov_time_slot <= (ov_time_slot == 10'd7   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd16:  ov_time_slot <= (ov_time_slot == 10'd15  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd32:  ov_time_slot <= (ov_time_slot == 10'd31  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd64:  ov_time_slot <= (ov_time_slot == 10'd63  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd128: ov_time_slot <= (ov_time_slot == 10'd127 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd256: ov_time_slot <= (ov_time_slot == 10'd255 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd512: ov_time_slot <= (ov_time_slot == 10'd511 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd1024:ov_time_slot <= (ov_time_slot == 10'd1023) ? 10'd0 : ov_time_slot + 10'd1;
                            endcase
                        end
                    end
                    else begin
                        rv_local_slot_time <= rv_local_slot_time + 20'd8;
                        ov_time_slot       <= ov_time_slot;
                        o_time_slot_switch <= 1'b0; 
                        r_previous_slot_flag <= r_previous_slot_flag;
                    end
                end            
                11'd8:begin//8192ns
                    if(iv_syn_clk[12:0] == 13'b0 || rv_local_slot_time == 20'd8184)begin
                        rv_local_slot_time <= 20'd0;
                    end
                    else begin
                        rv_local_slot_time <= rv_local_slot_time + 20'd8;
                    end
                    
                    if((iv_syn_clk[12:0] == 13'b0 && (iv_syn_clk[13] == ~r_previous_slot_flag)) || (rv_local_slot_time == 20'd8184))begin
                        o_time_slot_switch <= 1'b1;                        
                        r_previous_slot_flag <= ~r_previous_slot_flag;
                        if(iv_syn_clk[13] == ~r_previous_slot_flag)begin
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= {9'b0,iv_syn_clk[13:13]};
                                11'd4:   ov_time_slot <= {8'b0,iv_syn_clk[14:13]};
                                11'd8:   ov_time_slot <= {7'b0,iv_syn_clk[15:13]};
                                11'd16:  ov_time_slot <= {6'b0,iv_syn_clk[16:13]};
                                11'd32:  ov_time_slot <= {5'b0,iv_syn_clk[17:13]};
                                11'd64:  ov_time_slot <= {4'b0,iv_syn_clk[18:13]};
                                11'd128: ov_time_slot <= {3'b0,iv_syn_clk[19:13]};
                                11'd256: ov_time_slot <= {2'b0,iv_syn_clk[20:13]};
                                11'd512: ov_time_slot <= {1'b0,iv_syn_clk[21:13]};
                                11'd1024:ov_time_slot <= iv_syn_clk[22:13];
                                default:ov_time_slot <= iv_syn_clk[22:13];
                            endcase                            
                        end
                        else begin
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= (ov_time_slot == 10'd1   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd4:   ov_time_slot <= (ov_time_slot == 10'd3   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd8:   ov_time_slot <= (ov_time_slot == 10'd7   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd16:  ov_time_slot <= (ov_time_slot == 10'd15  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd32:  ov_time_slot <= (ov_time_slot == 10'd31  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd64:  ov_time_slot <= (ov_time_slot == 10'd63  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd128: ov_time_slot <= (ov_time_slot == 10'd127 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd256: ov_time_slot <= (ov_time_slot == 10'd255 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd512: ov_time_slot <= (ov_time_slot == 10'd511 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd1024:ov_time_slot <= (ov_time_slot == 10'd1023) ? 10'd0 : ov_time_slot + 10'd1;
                            endcase
                        end                        
                    end
                    else begin
                        ov_time_slot <= ov_time_slot;
                        o_time_slot_switch <= 1'b0; 
                        r_previous_slot_flag <= r_previous_slot_flag;
                    end
                end             
                11'd16:begin//16384ns
                    if(iv_syn_clk[13:0] == 14'b0 || rv_local_slot_time == 20'd16376)begin
                        rv_local_slot_time <= 20'd0;
                    end
                    else begin
                        rv_local_slot_time <= rv_local_slot_time + 20'd8;
                    end

                    if((iv_syn_clk[13:0] == 14'b0 && (iv_syn_clk[14] == ~r_previous_slot_flag)) || (rv_local_slot_time == 20'd16376))begin
                        o_time_slot_switch <= 1'b1;                        
                        r_previous_slot_flag <= ~r_previous_slot_flag;
                        if(iv_syn_clk[14] == ~r_previous_slot_flag)begin
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= {9'b0,iv_syn_clk[14:14]};
                                11'd4:   ov_time_slot <= {8'b0,iv_syn_clk[15:14]};
                                11'd8:   ov_time_slot <= {7'b0,iv_syn_clk[16:14]};
                                11'd16:  ov_time_slot <= {6'b0,iv_syn_clk[17:14]};
                                11'd32:  ov_time_slot <= {5'b0,iv_syn_clk[18:14]};
                                11'd64:  ov_time_slot <= {4'b0,iv_syn_clk[19:14]};
                                11'd128: ov_time_slot <= {3'b0,iv_syn_clk[20:14]};
                                11'd256: ov_time_slot <= {2'b0,iv_syn_clk[21:14]};
                                11'd512: ov_time_slot <= {1'b0,iv_syn_clk[22:14]};
                                11'd1024:ov_time_slot <= iv_syn_clk[23:14];
                                default:ov_time_slot <= iv_syn_clk[23:14];
                            endcase                              
                        end
                        else begin
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= (ov_time_slot == 10'd1   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd4:   ov_time_slot <= (ov_time_slot == 10'd3   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd8:   ov_time_slot <= (ov_time_slot == 10'd7   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd16:  ov_time_slot <= (ov_time_slot == 10'd15  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd32:  ov_time_slot <= (ov_time_slot == 10'd31  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd64:  ov_time_slot <= (ov_time_slot == 10'd63  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd128: ov_time_slot <= (ov_time_slot == 10'd127 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd256: ov_time_slot <= (ov_time_slot == 10'd255 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd512: ov_time_slot <= (ov_time_slot == 10'd511 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd1024:ov_time_slot <= (ov_time_slot == 10'd1023) ? 10'd0 : ov_time_slot + 10'd1;
                            endcase
                        end
                    end
                    else begin
                        ov_time_slot <= ov_time_slot;
                        o_time_slot_switch <= 1'b0; 
                        r_previous_slot_flag <= r_previous_slot_flag;
                    end
                end            
                11'd32:begin//32768ns
                    if(iv_syn_clk[14:0] == 15'b0 || rv_local_slot_time == 20'd32760)begin
                        rv_local_slot_time <= 20'd0;
                    end
                    else begin
                        rv_local_slot_time <= rv_local_slot_time + 20'd8;
                    end
                    
                    if((iv_syn_clk[14:0] == 15'b0 && (iv_syn_clk[15] == ~r_previous_slot_flag)) || (rv_local_slot_time == 20'd32760))begin
                        o_time_slot_switch <= 1'b1;                          
                        r_previous_slot_flag <= ~r_previous_slot_flag;
                        if(iv_syn_clk[15] == ~r_previous_slot_flag)begin
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= {9'b0,iv_syn_clk[15:15]};
                                11'd4:   ov_time_slot <= {8'b0,iv_syn_clk[16:15]};
                                11'd8:   ov_time_slot <= {7'b0,iv_syn_clk[17:15]};
                                11'd16:  ov_time_slot <= {6'b0,iv_syn_clk[18:15]};
                                11'd32:  ov_time_slot <= {5'b0,iv_syn_clk[19:15]};
                                11'd64:  ov_time_slot <= {4'b0,iv_syn_clk[20:15]};
                                11'd128: ov_time_slot <= {3'b0,iv_syn_clk[21:15]};
                                11'd256: ov_time_slot <= {2'b0,iv_syn_clk[22:15]};
                                11'd512: ov_time_slot <= {1'b0,iv_syn_clk[23:15]};
                                11'd1024:ov_time_slot <= iv_syn_clk[24:15];
                                default:ov_time_slot <= iv_syn_clk[24:15];
                            endcase                              
                        end
                        else begin
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= (ov_time_slot == 10'd1   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd4:   ov_time_slot <= (ov_time_slot == 10'd3   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd8:   ov_time_slot <= (ov_time_slot == 10'd7   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd16:  ov_time_slot <= (ov_time_slot == 10'd15  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd32:  ov_time_slot <= (ov_time_slot == 10'd31  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd64:  ov_time_slot <= (ov_time_slot == 10'd63  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd128: ov_time_slot <= (ov_time_slot == 10'd127 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd256: ov_time_slot <= (ov_time_slot == 10'd255 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd512: ov_time_slot <= (ov_time_slot == 10'd511 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd1024:ov_time_slot <= (ov_time_slot == 10'd1023) ? 10'd0 : ov_time_slot + 10'd1;
                            endcase
                        end
                    end
                    else begin
                        ov_time_slot <= ov_time_slot;
                        o_time_slot_switch <= 1'b0; 
                        r_previous_slot_flag <= r_previous_slot_flag;
                    end
                end              
                 11'd64:begin//65536ns
                    if(iv_syn_clk[15:0] == 16'b0 || rv_local_slot_time == 20'd65528)begin
                        rv_local_slot_time <= 20'd0;
                    end
                    else begin
                        rv_local_slot_time <= rv_local_slot_time + 20'd8;
                    end
                    
                    if((iv_syn_clk[15:0] == 16'b0 && (iv_syn_clk[16] == ~r_previous_slot_flag)) || (rv_local_slot_time == 20'd65528))begin
                        o_time_slot_switch <= 1'b1;                           
                        r_previous_slot_flag <= ~r_previous_slot_flag;
                        if(iv_syn_clk[16] == ~r_previous_slot_flag)begin
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= {9'b0,iv_syn_clk[16:16]};
                                11'd4:   ov_time_slot <= {8'b0,iv_syn_clk[17:16]};
                                11'd8:   ov_time_slot <= {7'b0,iv_syn_clk[18:16]};
                                11'd16:  ov_time_slot <= {6'b0,iv_syn_clk[19:16]};
                                11'd32:  ov_time_slot <= {5'b0,iv_syn_clk[20:16]};
                                11'd64:  ov_time_slot <= {4'b0,iv_syn_clk[21:16]};
                                11'd128: ov_time_slot <= {3'b0,iv_syn_clk[22:16]};
                                11'd256: ov_time_slot <= {2'b0,iv_syn_clk[23:16]};
                                11'd512: ov_time_slot <= {1'b0,iv_syn_clk[24:16]};
                                11'd1024:ov_time_slot <= iv_syn_clk[25:16];
                                default:ov_time_slot <= iv_syn_clk[25:16];
                            endcase                             
                        end
                        else begin
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= (ov_time_slot == 10'd1   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd4:   ov_time_slot <= (ov_time_slot == 10'd3   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd8:   ov_time_slot <= (ov_time_slot == 10'd7   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd16:  ov_time_slot <= (ov_time_slot == 10'd15  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd32:  ov_time_slot <= (ov_time_slot == 10'd31  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd64:  ov_time_slot <= (ov_time_slot == 10'd63  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd128: ov_time_slot <= (ov_time_slot == 10'd127 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd256: ov_time_slot <= (ov_time_slot == 10'd255 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd512: ov_time_slot <= (ov_time_slot == 10'd511 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd1024:ov_time_slot <= (ov_time_slot == 10'd1023) ? 10'd0 : ov_time_slot + 10'd1;
                            endcase
                        end
                    end
                    else begin
                        ov_time_slot <= ov_time_slot;
                        o_time_slot_switch <= 1'b0; 
                        r_previous_slot_flag <= r_previous_slot_flag;
                    end
                end             
                 11'd128:begin//131072ns
                    if(iv_syn_clk[16:0] == 17'b0 || rv_local_slot_time == 20'd131064)begin
                        rv_local_slot_time <= 20'd0;
                    end
                    else begin
                        rv_local_slot_time <= rv_local_slot_time + 20'd8;
                    end
                    
                    if((iv_syn_clk[16:0] == 17'b0 && (iv_syn_clk[17] == ~r_previous_slot_flag)) || (rv_local_slot_time == 20'd131064))begin
                        o_time_slot_switch <= 1'b1;                          
                        r_previous_slot_flag <= ~r_previous_slot_flag;
                        if(iv_syn_clk[17] == ~r_previous_slot_flag)begin
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= {9'b0,iv_syn_clk[17:17]};
                                11'd4:   ov_time_slot <= {8'b0,iv_syn_clk[18:17]};
                                11'd8:   ov_time_slot <= {7'b0,iv_syn_clk[19:17]};
                                11'd16:  ov_time_slot <= {6'b0,iv_syn_clk[20:17]};
                                11'd32:  ov_time_slot <= {5'b0,iv_syn_clk[21:17]};
                                11'd64:  ov_time_slot <= {4'b0,iv_syn_clk[22:17]};
                                11'd128: ov_time_slot <= {3'b0,iv_syn_clk[23:17]};
                                11'd256: ov_time_slot <= {2'b0,iv_syn_clk[24:17]};
                                11'd512: ov_time_slot <= {1'b0,iv_syn_clk[25:17]};
                                11'd1024:ov_time_slot <= iv_syn_clk[26:17];
                                default:ov_time_slot <= iv_syn_clk[26:17];
                            endcase                             
                        end
                        else begin
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= (ov_time_slot == 10'd1   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd4:   ov_time_slot <= (ov_time_slot == 10'd3   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd8:   ov_time_slot <= (ov_time_slot == 10'd7   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd16:  ov_time_slot <= (ov_time_slot == 10'd15  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd32:  ov_time_slot <= (ov_time_slot == 10'd31  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd64:  ov_time_slot <= (ov_time_slot == 10'd63  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd128: ov_time_slot <= (ov_time_slot == 10'd127 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd256: ov_time_slot <= (ov_time_slot == 10'd255 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd512: ov_time_slot <= (ov_time_slot == 10'd511 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd1024:ov_time_slot <= (ov_time_slot == 10'd1023) ? 10'd0 : ov_time_slot + 10'd1;
                            endcase
                        end
                    end
                    else begin
                        ov_time_slot <= ov_time_slot;
                        o_time_slot_switch <= 1'b0; 
                        r_previous_slot_flag <= r_previous_slot_flag;
                    end
                end            
                 11'd256:begin//262144ns
                    if(iv_syn_clk[17:0] == 18'b0 || rv_local_slot_time == 20'd262136)begin
                        rv_local_slot_time <= 20'd0;
                    end
                    else begin
                        rv_local_slot_time <= rv_local_slot_time + 20'd8;
                    end
                    
                    if((iv_syn_clk[17:0] == 18'b0 && (iv_syn_clk[18] == ~r_previous_slot_flag)) || (rv_local_slot_time == 20'd262136))begin
                        o_time_slot_switch <= 1'b1;                          
                        r_previous_slot_flag <= ~r_previous_slot_flag;
                        if(iv_syn_clk[18] == ~r_previous_slot_flag)begin
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= {9'b0,iv_syn_clk[18:18]};
                                11'd4:   ov_time_slot <= {8'b0,iv_syn_clk[19:18]};
                                11'd8:   ov_time_slot <= {7'b0,iv_syn_clk[20:18]};
                                11'd16:  ov_time_slot <= {6'b0,iv_syn_clk[21:18]};
                                11'd32:  ov_time_slot <= {5'b0,iv_syn_clk[22:18]};
                                11'd64:  ov_time_slot <= {4'b0,iv_syn_clk[23:18]};
                                11'd128: ov_time_slot <= {3'b0,iv_syn_clk[24:18]};
                                11'd256: ov_time_slot <= {2'b0,iv_syn_clk[25:18]};
                                11'd512: ov_time_slot <= {1'b0,iv_syn_clk[26:18]};
                                11'd1024:ov_time_slot <= iv_syn_clk[27:18];
                                default:ov_time_slot <= iv_syn_clk[27:18];
                            endcase                             
                        end
                        else begin
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= (ov_time_slot == 10'd1   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd4:   ov_time_slot <= (ov_time_slot == 10'd3   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd8:   ov_time_slot <= (ov_time_slot == 10'd7   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd16:  ov_time_slot <= (ov_time_slot == 10'd15  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd32:  ov_time_slot <= (ov_time_slot == 10'd31  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd64:  ov_time_slot <= (ov_time_slot == 10'd63  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd128: ov_time_slot <= (ov_time_slot == 10'd127 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd256: ov_time_slot <= (ov_time_slot == 10'd255 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd512: ov_time_slot <= (ov_time_slot == 10'd511 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd1024:ov_time_slot <= (ov_time_slot == 10'd1023) ? 10'd0 : ov_time_slot + 10'd1;
                            endcase
                        end
                    end
                    else begin
                        ov_time_slot <= ov_time_slot;
                        o_time_slot_switch <= 1'b0; 
                        r_previous_slot_flag <= r_previous_slot_flag;
                    end
                end           
                 11'd512:begin//524288ns
                    if(iv_syn_clk[18:0] == 19'b0 || rv_local_slot_time == 20'd524280)begin
                        rv_local_slot_time <= 20'd0;
                    end
                    else begin
                        rv_local_slot_time <= rv_local_slot_time + 20'd8;
                    end
                    
                    if((iv_syn_clk[18:0] == 19'b0 && (iv_syn_clk[19] == ~r_previous_slot_flag)) || (rv_local_slot_time == 20'd524280))begin
                        o_time_slot_switch <= 1'b1;                          
                        r_previous_slot_flag <= ~r_previous_slot_flag;
                        if(iv_syn_clk[19] == ~r_previous_slot_flag)begin
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= {9'b0,iv_syn_clk[19:19]};
                                11'd4:   ov_time_slot <= {8'b0,iv_syn_clk[20:19]};
                                11'd8:   ov_time_slot <= {7'b0,iv_syn_clk[21:19]};
                                11'd16:  ov_time_slot <= {6'b0,iv_syn_clk[22:19]};
                                11'd32:  ov_time_slot <= {5'b0,iv_syn_clk[23:19]};
                                11'd64:  ov_time_slot <= {4'b0,iv_syn_clk[24:19]};
                                11'd128: ov_time_slot <= {3'b0,iv_syn_clk[25:19]};
                                11'd256: ov_time_slot <= {2'b0,iv_syn_clk[26:19]};
                                11'd512: ov_time_slot <= {1'b0,iv_syn_clk[27:19]};
                                11'd1024:ov_time_slot <= iv_syn_clk[28:19];
                                default:ov_time_slot <= iv_syn_clk[28:19];
                            endcase                             
                        end
                        else begin
                            case(iv_slot_period)
                                11'd1:   ov_time_slot <= {10'b0};
                                11'd2:   ov_time_slot <= (ov_time_slot == 10'd1   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd4:   ov_time_slot <= (ov_time_slot == 10'd3   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd8:   ov_time_slot <= (ov_time_slot == 10'd7   ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd16:  ov_time_slot <= (ov_time_slot == 10'd15  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd32:  ov_time_slot <= (ov_time_slot == 10'd31  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd64:  ov_time_slot <= (ov_time_slot == 10'd63  ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd128: ov_time_slot <= (ov_time_slot == 10'd127 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd256: ov_time_slot <= (ov_time_slot == 10'd255 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd512: ov_time_slot <= (ov_time_slot == 10'd511 ) ? 10'd0 : ov_time_slot + 10'd1;
                                11'd1024:ov_time_slot <= (ov_time_slot == 10'd1023) ? 10'd0 : ov_time_slot + 10'd1;
                            endcase
                        end
                    end
                    else begin
                        ov_time_slot <= ov_time_slot;
                        o_time_slot_switch <= 1'b0; 
                        r_previous_slot_flag <= r_previous_slot_flag;
                    end
                end            
                default:begin
                    o_time_slot_switch <= 1'b0;
                end
            endcase
        end
        else begin
            o_time_slot_switch <= 1'b0;
        end
    end
end 
endmodule

/*
TimeSlotCalculation TimeSlotCalculation_inst(
    .i_clk                      (),
    .i_rst_n                    (),

    .iv_syn_clk       (),
    .iv_time_slot_length        (),

    .iv_slot_period             (),

    .ov_time_slot               (),
    .o_time_slot_switch         ()
);
*/