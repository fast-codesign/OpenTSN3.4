// Copyright (C) 1953-2020 NUDT
// Verilog module name - extern_phy_config
// Version: EPC.0
// Created:
//         by - fenglin 
//         at - 10.2020
////////////////////////////////////////////////////////////////////////////
// Description:
//         
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module  extern_phy_config
(
        clk_100m                ,
        rst_n                   ,
        
        smi_mdi                 ,
        smi_mdc                 , 
        smi_mdo                 ,
        smi_link                ,
        
        init_done
);
input               clk_100m                ;
input               rst_n                   ;
                                                        
input               smi_mdi                 ;
output              smi_mdc                 ; 
output              smi_mdo                 ;
output              smi_link                ;

output              init_done               ;

////////////////////////////////////////////
            
reg                 spi_stsmi_wract         ;
reg                 spi_stsmi_rdact         ;
wire                spi_stsmi_sel           ;
                                
reg     [15:0]      spi_stsmi_rxdata        ;
wire    [15:0]      stsmi_spi_txdata        ; 
wire                stsmi_spi_txdval        ;
                                
reg     [4:0]       smi_dev_addr            ;
reg     [4:0]       smi_phy_addr            ;

reg     [2:0]       phy_num                 ;

wire                operate_busy            ;

reg                 init_done               ;

reg     [3:0]       cur_state   ;
parameter   idle                     = 4'd0  ,
            vsc8504_addr_page0  = 4'd1  ,
            vsc8504_addr_page1  = 4'd2  ,
            vsc8504_addr_page2  = 4'd3  ,
            vsc8504_addr_rd     = 4'd4  ,
            vsc8504_addr_con      = 4'd5  ,
            vsc8504_addr_index  = 4'd6  ,
            vsc8504_sgmii_wr    = 4'd7  ,
            vsc8504_sgmii_rd    = 4'd8  ,
            vsc8504_sgmii_con   = 4'd9  ,
            vsc8504_autoneg_wr  = 4'd10 ,
            vsc8504_autoneg_rd  = 4'd11 ,
            vsc8504_autoneg_con = 4'd12 ,
            vsc8504_soft_rst_n  = 4'd13 ,
            vsc8504_rst_n_rd      = 4'd14 ,
            vsc8504_rst_n_con     = 4'd15 ;

//assign    smi_phy_addr = 5'd0 ; 
assign  spi_stsmi_sel = 1'b1 ;
////////////////////////////////////////////

always@(posedge clk_100m or negedge rst_n)
    if( ~ rst_n)begin 
        cur_state       <=  idle ;
        spi_stsmi_wract <=  1'b0 ;
        spi_stsmi_rdact <=  1'b0 ;
        spi_stsmi_rxdata<=  16'd0;
        smi_dev_addr    <=  5'h0 ;
        smi_phy_addr    <=  5'd0 ;
        init_done       <=  1'b0 ;
        phy_num         <=  3'd0 ;
    end 
    else    begin 
        case(cur_state)
            idle    :begin
                if(( ~ init_done) & ( ~ operate_busy))begin 
                    cur_state       <=  vsc8504_addr_rd ;
                    spi_stsmi_wract <=  1'b1 ;
                    spi_stsmi_rdact <=  1'b0 ;
                    spi_stsmi_rxdata<=  16'h0010;
                    smi_dev_addr    <=  5'h1f ;
                    smi_phy_addr    <=  phy_num ;
                    phy_num         <=  phy_num + 2'd1 ;
                end
                else    begin 
                    cur_state       <=  idle ;
                    spi_stsmi_wract <=  1'b0 ;
                    spi_stsmi_rdact <=  1'b0 ;
                    spi_stsmi_rxdata<=  16'd0;
                    smi_dev_addr    <=  5'h0 ;
                    phy_num         <=  phy_num ;
                end
            end
            
            vsc8504_addr_rd:begin 
                if( ~ stsmi_spi_txdval)begin 
                    cur_state       <=  vsc8504_addr_rd ;
                    spi_stsmi_wract <=  1'b0 ;
                    spi_stsmi_rdact <=  1'b1 ;
                    smi_dev_addr    <=  5'h1f ;
                end
                else    begin 
                    cur_state       <=  vsc8504_addr_con ;
                    spi_stsmi_wract <=  1'b0 ;
                    spi_stsmi_rdact <=  1'b0 ;
                    smi_dev_addr    <=  5'h0 ;
                end
            end
            
            vsc8504_addr_con:begin 
                if(stsmi_spi_txdata == 16'h0010)
                    cur_state   <= vsc8504_sgmii_wr  ;
                else    if(stsmi_spi_txdata == 16'h0003)
                    cur_state   <= vsc8504_autoneg_wr    ;
                else
                    cur_state   <= vsc8504_soft_rst_n ;
                spi_stsmi_wract <=  1'b0 ;
                spi_stsmi_rdact <=  1'b0 ;
                smi_dev_addr    <=  5'h0 ;  
            end
            
            vsc8504_sgmii_wr:begin 
                if( ~ operate_busy)begin 
                    cur_state       <=  vsc8504_sgmii_rd ;
                    spi_stsmi_wract <=  1'b1 ;
                    spi_stsmi_rdact <=  1'b0 ;
                    smi_dev_addr    <=  5'h12 ;
                    spi_stsmi_rxdata<=  16'h80f0;
                end
                else    begin 
                    cur_state       <=  vsc8504_sgmii_wr ;
                    spi_stsmi_wract <=  1'b0 ;
                    spi_stsmi_rdact <=  1'b0 ;
                    smi_dev_addr    <=  5'h0 ;
                end
            end
            
            vsc8504_sgmii_rd:begin 
                if( ~ stsmi_spi_txdval)begin 
                    cur_state       <=  vsc8504_sgmii_rd ;
                    spi_stsmi_wract <=  1'b0 ;
                    spi_stsmi_rdact <=  1'b1 ;
                    smi_dev_addr    <=  5'h12 ;
                end
                else    begin 
                    cur_state       <=  vsc8504_sgmii_con ;
                    spi_stsmi_wract <=  1'b0 ;
                    spi_stsmi_rdact <=  1'b1 ;
                    smi_dev_addr    <=  5'h12 ;
                end
            end
            
            vsc8504_sgmii_con:begin 
                //if(stsmi_spi_txdata == 16'h00f0)
                if(stsmi_spi_txdata[15] == 1'b0)
                    cur_state       <=  vsc8504_addr_page2 ;
                else
                    cur_state       <=  vsc8504_sgmii_con ;
                spi_stsmi_wract <=  1'b0 ;
                spi_stsmi_rdact <=  1'b1 ;
                smi_dev_addr    <=  5'h12 ;
            end
            
            vsc8504_addr_page2:begin 
                if( ~ operate_busy)begin
                    cur_state       <=  vsc8504_addr_rd ;
                    spi_stsmi_wract <=  1'b1 ;
                    spi_stsmi_rdact <=  1'b0 ;
                    spi_stsmi_rxdata<=  16'h0003;
                    smi_dev_addr    <=  5'h1f ;
                end
                else    begin 
                    cur_state       <=  vsc8504_addr_page2 ;
                    spi_stsmi_wract <=  1'b0 ;
                    spi_stsmi_rdact <=  1'b0 ;
                    spi_stsmi_rxdata<=  16'h0;
                    smi_dev_addr    <=  5'h0 ;
                end
            end
            
            vsc8504_autoneg_wr:begin 
                if( ~ operate_busy)begin 
                    cur_state       <=  vsc8504_autoneg_rd ;
                    spi_stsmi_wract <=  1'b1 ;
                    spi_stsmi_rdact <=  1'b0 ;
                    smi_dev_addr    <=  5'h10 ;
                    spi_stsmi_rxdata<=  16'h0180;
                end
                else    begin 
                    cur_state       <=  vsc8504_autoneg_wr ;
                    spi_stsmi_wract <=  1'b0 ;
                    spi_stsmi_rdact <=  1'b0 ;
                    smi_dev_addr    <=  5'd0 ;
                end
            end
            
            vsc8504_autoneg_rd:begin 
                if( ~ stsmi_spi_txdval)begin 
                    cur_state       <=  vsc8504_autoneg_rd ;
                    spi_stsmi_wract <=  1'b0 ;
                    spi_stsmi_rdact <=  1'b1 ;
                    smi_dev_addr    <=  5'h10 ;
                end
                else    begin 
                    cur_state       <=  vsc8504_autoneg_con ;
                    spi_stsmi_wract <=  1'b0 ;
                    spi_stsmi_rdact <=  1'b0 ;
                    smi_dev_addr    <=  5'h0 ;
                end
            end
            
            vsc8504_autoneg_con:begin 
                if(stsmi_spi_txdata == 16'h0180)
                    cur_state       <=  vsc8504_addr_page0 ;
                else
                    cur_state       <=  idle ;
                spi_stsmi_wract <=  1'b0 ;
                spi_stsmi_rdact <=  1'b0 ;
                smi_dev_addr    <=  5'h0 ;
            end
            
            vsc8504_addr_page0:begin 
                if( ~ operate_busy)begin
                    cur_state       <=  vsc8504_soft_rst_n ;
                    spi_stsmi_wract <=  1'b1 ;
                    spi_stsmi_rdact <=  1'b0 ;
                    spi_stsmi_rxdata<=  16'h0000;
                    smi_dev_addr    <=  5'h1f ;
                end
                else    begin 
                    cur_state       <=  vsc8504_addr_page0 ;
                    spi_stsmi_wract <=  1'b0 ;
                    spi_stsmi_rdact <=  1'b0 ;
                    spi_stsmi_rxdata<=  16'd0;
                    smi_dev_addr    <=  5'h0 ;
                end
            end
            
            vsc8504_soft_rst_n:begin 
                if( ~ operate_busy)begin
                    cur_state       <=  vsc8504_rst_n_rd ;
                    spi_stsmi_wract <=  1'b1 ;
                    spi_stsmi_rdact <=  1'b0 ;
                    spi_stsmi_rxdata<=  16'h9140;
                    smi_dev_addr    <=  5'h0 ;
                end
                else    begin 
                    cur_state       <=  vsc8504_addr_page0 ;
                    spi_stsmi_wract <=  1'b0 ;
                    spi_stsmi_rdact <=  1'b0 ;
                    spi_stsmi_rxdata<=  16'd0;
                    smi_dev_addr    <=  5'h0 ;
                end
            end
            
            vsc8504_rst_n_rd:begin 
                if( ~ stsmi_spi_txdval)begin 
                    cur_state       <=  vsc8504_rst_n_rd ;
                    spi_stsmi_wract <=  1'b0 ;
                    spi_stsmi_rdact <=  1'b1 ;
                    smi_dev_addr    <=  5'h0 ;
                end
                else    begin 
                    cur_state       <=  vsc8504_rst_n_con ;
                    spi_stsmi_wract <=  1'b0 ;
                    spi_stsmi_rdact <=  1'b0 ;
                    smi_dev_addr    <=  5'h0 ;
                end
            end
            
            vsc8504_rst_n_con:begin 
                if(stsmi_spi_txdata[15] == 1'b0)//h1140
                    cur_state       <=  idle ;
                else
                    cur_state       <=  vsc8504_rst_n_con ;
                //cur_state     <=  idle ;
                init_done       <= (phy_num==3'h4) ;
                spi_stsmi_wract <=  1'b0 ;
                spi_stsmi_rdact <=  1'b0 ;
                smi_dev_addr    <=  5'd0 ;
            end
        endcase
    end

////////////////////////////////////////////

STSMI   STSMI_inst0
(
        .clk_100m                ( clk_100m                ),
        .rst_100m                ( ~ rst_n                 ),
                                 
        .spi_stsmi_wract         ( spi_stsmi_wract         ),
        .spi_stsmi_rdact         ( spi_stsmi_rdact         ),
        .spi_stsmi_sel           ( spi_stsmi_sel           ),
                                                           
        .spi_stsmi_rxdata        ( spi_stsmi_rxdata        ),
        .stsmi_spi_txdata        ( stsmi_spi_txdata        ), 
        .stsmi_spi_txdval        ( stsmi_spi_txdval        ),
                                                           
        .smi_dev_addr            ( smi_dev_addr            ),
        .smi_phy_addr            ( smi_phy_addr            ),
        
        .operate_busy            ( operate_busy            ),
                                                           
        .smi_mdi                 ( smi_mdi                 ),
        .smi_mdc                 ( smi_mdc                 ),                                                   
        .smi_mdo                 ( smi_mdo                 ),
        .smi_link                ( smi_link                )
);

////////////////////////////////////////////

endmodule 
/*
extern_phy_config extern_phy_config_inst(
    .clk_100m    (SYS2MGMT_clk) ,
    .rst_n       (phy_rst_n)    ,

    .smi_mdi     ( smi_mdi ),
    .smi_mdc     ( smi_mdc ), 
    .smi_mdo     ( smi_mdo ),
    .smi_link    ( smi_link),

    .init_done   (init_done )
);
*/