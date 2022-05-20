// +FHDR***********************************************************************
// Copyright        :   GalaxyWind.
// Confidential     :   I LEVEL
// ============================================================================
// FILE NAME        :   STI2C.v
// CREATE DATE      :   2012-08-10 
// DEPARTMENT       :   R&D
// AUTHOR           :   TangRui
// AUTHOR'S EMAIL   :   trui_light@sina.com
// AUTHOR'S TEL     :   
// ============================================================================
// RELEASE  HISTORY     -------------------------------------------------------
// VERSION  DATE        AUTHOR      DESCRIPTION
// 1.0      2012-08-10  TangRui     Original Verison
// ============================================================================
// KEYWORDS         :   N/A
// ----------------------------------------------------------------------------
// PURPOSE          :   
// ----------------------------------------------------------------------------
// PARAMETERS           -------------------------------------------------------
// PARAM NAME           RANGE           DESCRIPTION
// N/A                                  (No need to set)
// ============================================================================
// REUSE ISSUES
// Reset Strategy   :   Async clear,active high
// Clock Domains    :   clk_100m
// Critical TiminG  :   N/A
// Instantiations   :   N/A
// Synthesizable    :   N/A
// Others           :   N/A
// -FHDR***********************************************************************
//`include "DEFINES.v"
module  SMI
    (
    
input       wire                clk_100m        ,  
input       wire                rst_100m        ,
                                                
input       wire                smi_bus_read    ,
input       wire                smi_bus_write   ,
input       wire                smi_bus_sel     ,
                                                                                    
input       wire                smi_mdi         ,
output      wire                smi_mdo         ,
output      reg                 smi_mdc         ,   
output      reg                 smi_link        ,

output      wire                smi_end         ,

input       wire    [1:0]       smi_operat      ,                                
input       wire    [4:0]       smi_phy_addr    ,
input       wire    [4:0]       smi_dev_addr    ,
input       wire    [15:0]      smi_writ_data   ,
output      reg     [15:0]      smi_read_data   ,
output      reg                 smi_read_dval   

    );
    
/**************************************************************************************/

parameter           DIV_WORTH   =   7'd9       ;
parameter           TRBF_WIDTH  =   64         ;
                    
parameter           MAXSCLKCNT  =   (TRBF_WIDTH + 8)*2;
    
/**************************************************************************************/

reg                 [6:0]       div_cnt         ;  
reg                 [7:0]       smi_mdc_cnt     ;

reg                 [1:0]       smi_mdc_dly     ;
//reg               [1:0]       ssel_pro_dly    ;
reg                 [1:0]       busop_end_dly   ;

reg                 [63:0]      smi_writ_temp   ;
reg                 [15:0]      smi_rdata_tmp   ;
reg                 [4:0]       smi_mdi_dly     ;

wire                            div_clk         ;
wire                            sclk_pro        ;
wire                            ssel_pro        ;
wire                            busop_end       ;
wire                            smi_mdc_ring    ;
wire                            smi_mdc_fall    ;
//wire                          ssel_pro_fall   ;

/**************************************************************************************/

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        div_cnt     <=    7'h00 ;     
    end
    else if( smi_bus_sel == 1'b0 ) begin
        div_cnt     <=    7'h00 ; 
    end
    else if( div_cnt != DIV_WORTH) begin
        div_cnt     <=    div_cnt + 1'b1 ;
    end 
    else begin
        div_cnt     <=    7'h00 ;   
    end
end

assign  div_clk =   div_cnt == DIV_WORTH ? 1'b1 : 1'b0 ;

/**************************************************************************************/

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_mdi_dly     <=  5'b00000 ;     
    end
    else begin
        smi_mdi_dly     <=  {smi_mdi_dly[3:0],smi_mdi} ;
    end 
end

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_mdc_cnt <=   8'h00 ;    
    end
    else if( smi_mdc_cnt == MAXSCLKCNT ) begin
        smi_mdc_cnt <=   8'h00 ;
    end 
    else if( div_clk == 1'b1 ) begin
        smi_mdc_cnt <=   smi_mdc_cnt + 1'b1 ;    
    end
end

assign  sclk_pro    =   (smi_mdc_cnt[7:1] >= 2) && (smi_mdc_cnt[7:1] <= (TRBF_WIDTH + 1));
assign  ssel_pro    =   (smi_mdc_cnt[7:1] >= 1) && (smi_mdc_cnt[7:1] <= (TRBF_WIDTH + 2));
assign  busop_end   =   (smi_mdc_cnt[7:1] > (TRBF_WIDTH + 7)) ? 1'b1 : 1'b0 ;

/**************************************************************************************/

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        busop_end_dly   <=   2'b00 ;     
    end
    else begin
        busop_end_dly   <=   {busop_end_dly[0],busop_end};
    end 
end

assign  smi_end     =   busop_end_dly == 2'b01 ? 1'b1 : 1'b0 ;

/**************************************************************************************/

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_mdc     <=   1'b0 ;     
    end
    else if( sclk_pro == 1'b1 ) begin
        smi_mdc     <=   smi_mdc_cnt[0] ;
    end 
    else begin
        smi_mdc     <=   1'b0 ; 
    end
end

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_mdc_dly <=   2'b00 ;
    end
    else begin
        smi_mdc_dly <=   {smi_mdc_dly[0],smi_mdc} ;
    end
end

assign  smi_mdc_ring    =   smi_mdc_dly == 2'b01 ? 1'b1 : 1'b0 ;
assign  smi_mdc_fall    =   smi_mdc_dly == 2'b10 ? 1'b1 : 1'b0 ;

/**************************************************************************************/

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_writ_temp   <=   64'h00 ;     
    end
    else if( ssel_pro == 1'b1 ) begin
        if( smi_mdc_cnt[7:1] == 7'h01 ) begin
            if( smi_bus_write == 1'b1 ) begin
                smi_writ_temp   <=   {32'hFFFFFFFF,2'b01,smi_operat,smi_phy_addr,smi_dev_addr,2'b10,smi_writ_data};     
            end
            else if( smi_bus_read == 1'b1 ) begin
                smi_writ_temp   <=   {32'hFFFFFFFF,2'b01,smi_operat,smi_phy_addr,smi_dev_addr,2'b00,16'h00};  
            end
        end
        else if( smi_mdc_fall == 1'b1 ) begin
            smi_writ_temp   <=   smi_writ_temp << 1 ;
        end
    end 
    else begin
        smi_writ_temp   <=   64'h00 ;        
    end
end

assign  smi_mdo = smi_writ_temp[63] == 1'b1 ? 1'b1 : 1'b0 ;

/**************************************************************************************/

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_link    <=   1'b0 ; 
    end
    else if( smi_bus_sel == 1'b0 || ssel_pro == 1'b0 ) begin 
        smi_link    <=   1'b0 ; 
    end
    else if( (smi_operat[1] == 1'b0 || smi_mdc_cnt[7:1] == 7'h01) ) begin
        smi_link    <=   1'b1 ;  
    end
    else if( smi_mdc_cnt[7:1] == 7'd48 ) begin
        smi_link    <=   1'b0 ;
    end 
end

/**************************************************************************************/

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_rdata_tmp   <=   16'h00 ;        
    end
    else if( smi_link == 1'b0 && smi_bus_sel == 1'b1 && 
             smi_mdc_ring == 1'b1 && smi_operat[1] == 1'b1 ) begin
        smi_rdata_tmp   <=   { smi_rdata_tmp[14:0],smi_mdi_dly[4]} ;
    end 
end

//always @( posedge clk_100m or posedge rst_100m ) begin
//    if( rst_100m == 1'b1 ) begin
//        ssel_pro_dly   <=  `U_DLY 2'b00 ;     
//    end
//    else begin
//        ssel_pro_dly   <=  `U_DLY {ssel_pro_dly[0],ssel_pro} ;
//    end 
//end

//assign  ssel_pro_fall   =   ssel_pro_dly == 2'b10 ? 1'b1 : 1'b0 ;

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_read_dval   <=   1'b0 ; 
    end
    else if( smi_end == 1'b1 && smi_bus_read == 1'b1 ) begin
        smi_read_dval   <=   1'b1 ;
    end 
    else begin
        smi_read_dval   <=   1'b0 ;  
    end
end

/**************************************************************************************/

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_read_data   <=   16'h00 ;    
    end
    else if( smi_end == 1'b1 && smi_bus_read == 1'b1 ) begin
        smi_read_data   <=   smi_rdata_tmp ;
    end 
end

/**************************************************************************************/

endmodule 


