// Copyright (C) 1953-2022 NUDT
// Verilog module name - clock_timing_and_correcting 
// Version: V3.4.0.20211123
// Created:
//         by - fenglin 
////////////////////////////////////////////////////////////////////////////
// Description:
//         global time synchronization 
//         generate report pulse base on global time
///////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module clock_timing_and_correcting #(parameter clk_period = 8'd8)
(

        i_clk                  ,
        i_rst_n                ,
        
        i_tsn_or_tte           ,
       
        iv_syn_clock_set       ,
        iv_reference_pit       ,
        i_syn_clock_set_wr     ,
        iv_syn_clock_cycle     ,
        iv_phase_cor           ,
        i_phase_cor_wr         ,
        iv_frequency_cor       ,
        i_frequency_cor_wr     ,

        ov_syn_clk
);
// clk & rst
input                  i_clk;
input                  i_rst_n;

input                  i_tsn_or_tte;

input      [63:0]      iv_syn_clock_set       ;
input      [31:0]      iv_reference_pit       ;
input                  i_syn_clock_set_wr     ;
input      [31:0]      iv_syn_clock_cycle     ;
input      [31:0]      iv_phase_cor           ;
input                  i_phase_cor_wr         ;
input      [31:0]      iv_frequency_cor       ;
input                  i_frequency_cor_wr     ;
 
output     [63:0]      ov_syn_clk             ;               // have syned global time 

reg        [87:0]      rv_complete_clk        ;
assign     ov_syn_clk = rv_complete_clk[87:24];
//assign ov_global_time_cycle = iv_syn_clock_cycle;
reg        [31:0]      rv_frequency_cor       ;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)begin
        rv_frequency_cor        <= {clk_period,24'h0};      
    end
    else begin
        if(i_frequency_cor_wr)begin
            rv_frequency_cor        <= iv_frequency_cor;
        end
        else begin
            rv_frequency_cor        <= rv_frequency_cor;
        end        
    end
end
reg        [32:0]      rv_syn_clock_cycle     ;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)begin
        rv_syn_clock_cycle        <= 33'h0;      
    end
    else begin
        if(i_tsn_or_tte)begin//tsn-1588
            rv_syn_clock_cycle        <= {1'b1,iv_syn_clock_cycle};
        end
        else begin//tte-as6802
            rv_syn_clock_cycle        <= {1'b0,iv_syn_clock_cycle};
        end        
    end
end
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)begin
        rv_complete_clk        <= 88'b0;    
    end
    else begin  
        if(i_syn_clock_set_wr)begin  //sync clock < sync clock cycle,correct sync clock        
            if(iv_reference_pit == 32'b0)begin//set sync clock to  iv_syn_clock_set.               
                rv_complete_clk[87:24] <= iv_syn_clock_set + rv_frequency_cor[31:24]; 
                rv_complete_clk[23:0]  <= rv_frequency_cor[23:0];                     
            end
            else begin
                if({1'b0,rv_complete_clk[23:0]} + {1'b0,rv_frequency_cor[23:0]} > 17'h0ffff)begin
                    rv_complete_clk[23:0]  <= {1'b0,rv_complete_clk[23:0]} + {1'b0,rv_frequency_cor[23:0]} - 17'h10000;
                    if(rv_complete_clk[55:24] > iv_reference_pit)begin
                        if((iv_syn_clock_set + (rv_complete_clk[55:24] - iv_reference_pit) + rv_frequency_cor[31:24] +1'b1) >= {32'b0,iv_syn_clock_cycle})begin//corrected sync clock is more than iv_syn_clock_cycle.
                            rv_complete_clk[87:24] <= iv_syn_clock_set + (rv_complete_clk[55:24] - iv_reference_pit) + 1'b1 + rv_frequency_cor[31:24] - iv_syn_clock_cycle;
                        end
                        else begin//corrected sync clock is less than iv_syn_clock_cycle.
                            rv_complete_clk[87:24] <= iv_syn_clock_set + (rv_complete_clk[55:24] - iv_reference_pit) + 1'b1 + rv_frequency_cor[31:24];
                        end
                    end
                    else begin
                        if((iv_syn_clock_set + (rv_complete_clk[55:24] + rv_syn_clock_cycle - iv_reference_pit) + rv_frequency_cor[31:24] +1'b1) >= {32'b0,iv_syn_clock_cycle})begin//corrected sync clock is more than iv_syn_clock_cycle.
                            rv_complete_clk[87:24] <= iv_syn_clock_set + (rv_complete_clk[55:24] + rv_syn_clock_cycle - iv_reference_pit) + 1'b1 + rv_frequency_cor[31:24] - iv_syn_clock_cycle;
                        end
                        else begin//corrected sync clock is less than iv_syn_clock_cycle.
                            rv_complete_clk[87:24] <= iv_syn_clock_set + (rv_complete_clk[55:24] + rv_syn_clock_cycle - iv_reference_pit) + 1'b1 + rv_frequency_cor[31:24];
                        end                        
                    end
                end
                else begin
                    rv_complete_clk[23:0]  <= rv_complete_clk[23:0] + rv_frequency_cor[23:0];
                    if(rv_complete_clk[55:24] > iv_reference_pit)begin
                        if((iv_syn_clock_set + (rv_complete_clk[55:24] - iv_reference_pit) + rv_frequency_cor[31:24]) >= {32'b0,iv_syn_clock_cycle})begin//corrected sync clock is more than iv_syn_clock_cycle.
                            rv_complete_clk[87:24] <= iv_syn_clock_set + (rv_complete_clk[55:24] - iv_reference_pit) + rv_frequency_cor[31:24] - iv_syn_clock_cycle;
                        end
                        else begin//corrected sync clock is less than iv_syn_clock_cycle.
                            rv_complete_clk[87:24] <= iv_syn_clock_set + (rv_complete_clk[55:24] - iv_reference_pit) + rv_frequency_cor[31:24];
                        end
                    end
                    else begin
                        if((iv_syn_clock_set + (rv_complete_clk[55:24] + rv_syn_clock_cycle - iv_reference_pit) + rv_frequency_cor[31:24]) >= {32'b0,iv_syn_clock_cycle})begin//corrected sync clock is more than iv_syn_clock_cycle.
                            rv_complete_clk[87:24] <= iv_syn_clock_set + (rv_complete_clk[55:24] + rv_syn_clock_cycle - iv_reference_pit) + rv_frequency_cor[31:24] - {32'b0,iv_syn_clock_cycle};
                        end
                        else begin//corrected sync clock is less than iv_syn_clock_cycle.
                            rv_complete_clk[87:24] <= iv_syn_clock_set + (rv_complete_clk[55:24] + rv_syn_clock_cycle - iv_reference_pit) + rv_frequency_cor[31:24];
                        end                        
                    end
                end                                                    
            end                    
        end   
        else if(i_phase_cor_wr)begin//correct phase of sync clock.
            if(iv_phase_cor[31] == 1'b0)begin//  +               
                if({1'b0,rv_complete_clk[23:0]} + {1'b0,rv_frequency_cor[23:0]} > 17'h0ffff)begin
                    rv_complete_clk[23:0]  <= {1'b0,rv_complete_clk[23:0]} + {1'b0,rv_frequency_cor[23:0]} - 17'h10000;                               
                    if(rv_complete_clk[87:24] + iv_phase_cor[30:0] + rv_frequency_cor[31:24] + 1'd1 >= {32'b0,iv_syn_clock_cycle})begin//sync clock after correcting frequency is more than {32'b0,iv_syn_clock_cycle}.
                        rv_complete_clk[87:24] <= rv_complete_clk[87:24] + iv_phase_cor[30:0] + rv_frequency_cor[31:24] + 1'd1 - {32'b0,iv_syn_clock_cycle};
                    end
                    else begin//sync clock after correcting frequency is less than iv_syn_clock_cycle.
                        rv_complete_clk[87:24] <= rv_complete_clk[87:24] + iv_phase_cor[30:0] + rv_frequency_cor[31:24] + 1'd1;
                    end
                end
                else begin
                    rv_complete_clk[23:0]  <= rv_complete_clk[23:0] + rv_frequency_cor[23:0];
                    if(rv_complete_clk[87:24] + iv_phase_cor[30:0] + rv_frequency_cor[31:24] >= {32'b0,iv_syn_clock_cycle})begin//sync clock after correcting frequency is more than iv_syn_clock_cycle.
                        rv_complete_clk[87:24] <= rv_complete_clk[87:24] + iv_phase_cor[30:0] + rv_frequency_cor[31:24] - {32'b0,iv_syn_clock_cycle};
                    end
                    else begin//sync clock after correcting frequency is less than iv_syn_clock_cycle.
                        rv_complete_clk[87:24] <= rv_complete_clk[87:24] + iv_phase_cor[30:0] + rv_frequency_cor[31:24];
                    end                            
                end              
            end                   
            else begin// - 
                if({1'b0,rv_complete_clk[23:0]} + {1'b0,rv_frequency_cor[23:0]} > 17'h0ffff)begin
                    rv_complete_clk[23:0]  <= {1'b0,rv_complete_clk[23:0]} + {1'b0,rv_frequency_cor[23:0]} - 17'h10000;                               
                    if(rv_complete_clk[87:24] - iv_phase_cor[30:0] + rv_frequency_cor[31:24] + 1'd1 >= {32'b0,iv_syn_clock_cycle})begin
                        rv_complete_clk[87:24] <= rv_complete_clk[87:24] - iv_phase_cor[30:0] + rv_frequency_cor[31:24] + 1'd1 - {32'b0,iv_syn_clock_cycle};
                    end
                    else begin
                        rv_complete_clk[87:24] <= rv_complete_clk[87:24] - iv_phase_cor[30:0] + rv_frequency_cor[31:24] + 1'd1;
                    end
                end
                else begin
                    rv_complete_clk[23:0]  <= rv_complete_clk[23:0] + rv_frequency_cor[23:0];
                    if(rv_complete_clk[87:24] - iv_phase_cor[30:0] + rv_frequency_cor[31:24] >= {32'b0,iv_syn_clock_cycle})begin
                        rv_complete_clk[87:24] <= rv_complete_clk[87:24] - iv_phase_cor[30:0] + rv_frequency_cor[31:24] - {32'b0,iv_syn_clock_cycle};
                    end
                    else begin
                        rv_complete_clk[87:24] <= rv_complete_clk[87:24] - iv_phase_cor[30:0] + rv_frequency_cor[31:24];
                    end                            
                end               
            end         
        end                 
        else begin//correct frequence of sync clock.
            if({1'b0,rv_complete_clk[23:0]} + {1'b0,rv_frequency_cor[23:0]} > 17'h0ffff)begin
                rv_complete_clk[23:0]  <= {1'b0,rv_complete_clk[23:0]} + {1'b0,rv_frequency_cor[23:0]} - 17'h10000;  
                if(rv_complete_clk[87:24] + rv_frequency_cor[31:24] + 1'd1 >= {32'b0,iv_syn_clock_cycle})begin
                    rv_complete_clk[87:24] <= rv_complete_clk[87:24] + rv_frequency_cor[31:24] + 1'd1 - {32'b0,iv_syn_clock_cycle};
                end
                else begin
                    rv_complete_clk[87:24] <= rv_complete_clk[87:24] + rv_frequency_cor[31:24] + 1'd1;
                end
            end
            else begin
                rv_complete_clk[23:0]  <= rv_complete_clk[23:0] + rv_frequency_cor[23:0];
                if(rv_complete_clk[87:24] + rv_frequency_cor[31:24] >= {32'b0,iv_syn_clock_cycle})begin
                    rv_complete_clk[87:24] <= rv_complete_clk[87:24] + rv_frequency_cor[31:24] - {32'b0,iv_syn_clock_cycle};
                end
                else begin
                    rv_complete_clk[87:24] <= rv_complete_clk[87:24] + rv_frequency_cor[31:24];
                end                            
            end 
        end
    end
end
endmodule