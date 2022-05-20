// Copyright (C) 1953-2022 NUDT
// Verilog module name - tsmp_protocol_process
// Version: V3.4.0.20220228
// Created:
//         by - fenglin
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module tsmp_protocol_process
(
    i_clk,
    i_rst_n,
    
    iv_data,
	i_data_wr,

	ov_data_nma,
	o_data_wr_nma,
    
	ov_data_osp,
	o_data_wr_osp,
    
    ov_data_tfp        ,
	o_data_wr_tfp      ,
    o_encapsulated_flag_tfp,
    
    ov_data_adi,
	o_data_wr_adi
);

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n; 
// pkt input
input	   [8:0]	    iv_data;
input	         	    i_data_wr;
// pkt output to NMA
output reg [8:0]	    ov_data_nma    ;
output reg	            o_data_wr_nma  ;
// pkt output to osp
output reg [8:0]	    ov_data_osp    ;
output reg	            o_data_wr_osp  ;
// pkt output to pip
output reg [8:0]	    ov_data_tfp        ;
output reg	            o_data_wr_tfp      ;
output reg              o_encapsulated_flag_tfp;
// pkt output to adi
output reg [8:0]	    ov_data_adi    ;
output reg	            o_data_wr_adi  ;
//***************************************************
//      add valid of data and delay 8 cycles
//***************************************************
reg        [125:0]      rv_data;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n) begin
        rv_data         <= 126'b0;
    end
    else begin
        if(i_data_wr)begin
            rv_data     <= {rv_data[116:0],iv_data};
        end
        else begin
            rv_data     <= {rv_data[116:0],9'b0};
        end        
    end
end
//***************************************************
//       receive pit record in ctrl interface
//***************************************************
reg       [2:0]               rv_tpp_state;
localparam      IDLE_S                     = 3'd0,
                ADDI_DISPATCH_S            = 3'd1,
                NETWORK_MANAGEMENT_S       = 3'd2,
                OPENSYNC_PROCESS_S         = 3'd3,
                TUNNEL_PROCESS_S           = 3'd4,
                DISCARD_PKT_S              = 3'd5;
always @(posedge i_clk or negedge i_rst_n) begin
    if(!i_rst_n)begin
        ov_data_nma    <= 9'b0;
        o_data_wr_nma  <= 1'b0;

        ov_data_osp    <= 9'b0;
        o_data_wr_osp  <= 1'b0;

        ov_data_tfp         <= 9'b0;
        o_data_wr_tfp       <= 1'b0;
        o_encapsulated_flag_tfp <= 1'b0;

        ov_data_adi    <= 9'b0;
        o_data_wr_adi  <= 1'b0;

        rv_tpp_state   <= IDLE_S;        
    end
    else begin
        case(rv_tpp_state)
            IDLE_S:begin
                if(rv_data[125])begin//transmit first cycle.
                    if(({rv_data[16:9],rv_data[7:0]} == 16'hff01) && (iv_data[7:0] == 8'h01))begin//addi diapatch.                       
                        ov_data_nma    <= 9'b0;
                        o_data_wr_nma  <= 1'b0;

                        ov_data_osp    <= 9'b0;
                        o_data_wr_osp  <= 1'b0;

                        ov_data_tfp    <= 9'b0;
                        o_data_wr_tfp  <= 1'b0;

                        ov_data_adi    <= rv_data[125:117];
                        o_data_wr_adi  <= 1'b1;

                        rv_tpp_state   <= ADDI_DISPATCH_S;  
                    end
                    else if(({rv_data[16:9],rv_data[7:0]} == 16'hff01) && (iv_data[7:0] == 8'h02))begin//NETWORK MANAGEMENT
                        ov_data_nma    <= rv_data[125:117];
                        o_data_wr_nma  <= 1'b1;

                        ov_data_osp    <= 9'b0;
                        o_data_wr_osp  <= 1'b0;

                        ov_data_tfp    <= 9'b0;
                        o_data_wr_tfp  <= 1'b0;

                        ov_data_adi    <= 9'b0;
                        o_data_wr_adi  <= 1'b0;

                        rv_tpp_state   <= NETWORK_MANAGEMENT_S;  
                    end
                    else if((({rv_data[16:9],rv_data[7:0]} == 16'hff01) && (iv_data[7:0] == 8'h04)) || ({rv_data[16:9],rv_data[7:0]} != 16'hff01))begin//TUNNEL 
                        ov_data_nma    <= 9'b0;
                        o_data_wr_nma  <= 1'b0;

                        ov_data_osp    <= 9'b0;
                        o_data_wr_osp  <= 1'b0;

                        ov_data_tfp    <= rv_data[125:117];
                        o_data_wr_tfp  <= 1'b1;
                        if({rv_data[16:9],rv_data[7:0]} == 16'hff01)begin
                            o_encapsulated_flag_tfp <= 1'b1;
                        end
                        else begin
                            o_encapsulated_flag_tfp <= 1'b0;
                        end

                        ov_data_adi    <= 9'b0;
                        o_data_wr_adi  <= 1'b0;

                        rv_tpp_state   <= TUNNEL_PROCESS_S;  
                    end
                    else if(({rv_data[16:9],rv_data[7:0]} == 16'hff01) && (iv_data[7:0] == 8'h06))begin//OPENSYNC
                        ov_data_nma    <= 9'b0;
                        o_data_wr_nma  <= 1'b0;

                        ov_data_osp    <= rv_data[125:117];
                        o_data_wr_osp  <= 1'b1;

                        ov_data_tfp    <= 9'b0;
                        o_data_wr_tfp  <= 1'b0;

                        ov_data_adi    <= 9'b0;
                        o_data_wr_adi  <= 1'b0;

                        rv_tpp_state   <= OPENSYNC_PROCESS_S;  
                    end
                    else begin//discard pkt
                        ov_data_nma         <= 9'b0;
                        o_data_wr_nma       <= 1'b0;
                                            
                        ov_data_osp         <= 9'b0;
                        o_data_wr_osp       <= 1'b0;

                        ov_data_tfp         <= 9'b0;
                        o_data_wr_tfp       <= 1'b0;
                        o_encapsulated_flag_tfp <= 1'b0;

                        ov_data_adi         <= 9'b0;
                        o_data_wr_adi       <= 1'b0;
                                            
                        rv_tpp_state        <= DISCARD_PKT_S;  
                    end                    
                end
                else begin
                    ov_data_nma         <= 9'b0;
                    o_data_wr_nma       <= 1'b0;
                                        
                    ov_data_osp         <= 9'b0;
                    o_data_wr_osp       <= 1'b0;
                                        
                    ov_data_tfp         <= 9'b0;
                    o_data_wr_tfp       <= 1'b0;
                    o_encapsulated_flag_tfp <= 1'b0;

                    ov_data_adi         <= 9'b0;
                    o_data_wr_adi       <= 1'b0;
                                        
                    rv_tpp_state        <= IDLE_S;                      
                end
            end
            ADDI_DISPATCH_S:begin
                ov_data_adi    <= rv_data[125:117];
                o_data_wr_adi  <= 1'b1;              
                if(rv_data[125])begin//last cycle. 
                    rv_tpp_state   <= IDLE_S;
                end
                else begin
                    rv_tpp_state   <= ADDI_DISPATCH_S;
                end
            end
            NETWORK_MANAGEMENT_S:begin
                ov_data_nma        <= rv_data[125:117];
                o_data_wr_nma      <= 1'b1;              
                if(rv_data[125])begin//last cycle. 
                    rv_tpp_state   <= IDLE_S;
                end
                else begin
                    rv_tpp_state   <= NETWORK_MANAGEMENT_S;
                end
            end
            TUNNEL_PROCESS_S:begin
                ov_data_tfp        <= rv_data[125:117];
                o_data_wr_tfp      <= 1'b1;              
                if(rv_data[125])begin//last cycle. 
                    rv_tpp_state   <= IDLE_S;
                end
                else begin
                    rv_tpp_state   <= TUNNEL_PROCESS_S;
                end
            end
            OPENSYNC_PROCESS_S:begin
                ov_data_osp        <= rv_data[125:117];
                o_data_wr_osp      <= 1'b1;              
                if(rv_data[125])begin//last cycle. 
                    rv_tpp_state   <= IDLE_S;
                end
                else begin
                    rv_tpp_state   <= OPENSYNC_PROCESS_S;
                end
            end            
            DISCARD_PKT_S:begin
                ov_data_osp        <= 9'b0;
                o_data_wr_osp      <= 1'b0;              
                if(rv_data[125])begin//last cycle. 
                    rv_tpp_state   <= IDLE_S;
                end
                else begin
                    rv_tpp_state   <= DISCARD_PKT_S;
                end
            end             
            default:begin
                rv_tpp_state <= IDLE_S;  
            end
        endcase
    end
end
endmodule