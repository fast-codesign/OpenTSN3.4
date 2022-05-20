// +FHDR***********************************************************************
// Copyright        :   GalaxyWind.                                            
// Confidential     :   I LEVEL                                                
// ============================================================================
// FILE NAME        :   STI2C.v                                                
// CREATE DATE      :   2012-09-03                                             
// DEPARTMENT       :   R&D                                                    
// AUTHOR           :   TangRui                                                
// AUTHOR'S EMAIL   :   trui_light@sina.com                                    
// AUTHOR'S TEL     :                                                          
// ============================================================================
// RELEASE  HISTORY     -------------------------------------------------------
// VERSION  DATE        AUTHOR      DESCRIPTION                                
// 1.0      2012-09-03  TangRui     Original Verison                           
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
module  STSMI
    (
    
input   wire                clk_100m                ,
input   wire                rst_100m                ,

input   wire                spi_stsmi_wract         ,
input   wire                spi_stsmi_rdact         ,
input   wire                spi_stsmi_sel           ,

input   wire    [15:0]      spi_stsmi_rxdata        ,
output  reg     [15:0]      stsmi_spi_txdata        , 
output  reg                 stsmi_spi_txdval        ,

//input   wire    [15:0]      smi_reg_addr            ,
input   wire    [4:0]       smi_dev_addr            ,
input   wire    [4:0]       smi_phy_addr            ,

output  wire                operate_busy            ,

input   wire                smi_mdi                 ,
output  wire                smi_mdc                 ,                                                   
output  wire                smi_mdo                 ,
output  wire                smi_link                
    );
    
/*************************************************************************/

parameter       IDLE        =   3'b000              ;
parameter       WRITE_ADDR  =   3'b001              ;
parameter       WRITE_DATA  =   3'b010              ;
parameter       READ_ADDR   =   3'b011              ;
parameter       READ_DATA   =   3'b100              ;
parameter       WRITE_FINISH=   3'b101              ;

/*************************************************************************/

wire                        smi_end                 ;

reg                         smi_bus_read            ;
reg                         smi_bus_write           ;

reg                         smi_read                ;
reg                         smi_write               ;

reg             [1:0]       smi_operat              ;
reg                         smi_bus_sel             ;
reg             [15:0]      smi_writ_data           ;

wire            [15:0]      smi_read_data           ;
wire                        smi_read_dval           ;

reg             [2:0]       current_s,next_s        ;

assign  operate_busy = (current_s != IDLE)  ;
/*************************************************************************/

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_read    <=    1'b0 ;     
    end    
    else if( spi_stsmi_rdact == 1'b1 && spi_stsmi_sel == 1'b1 ) begin
        smi_read    <=    1'b1 ;
    end
    else begin
        smi_read    <=    1'b0 ; 
    end
end  

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_write   <=    1'b0 ;     
    end    
    else if( spi_stsmi_wract == 1'b1 && spi_stsmi_sel == 1'b1 ) begin
        smi_write   <=    1'b1 ;
    end
    else begin
        smi_write   <=    1'b0 ; 
    end
end

/**********************************************************************/

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_writ_data       <=   16'h0000 ;     
    end
    else begin
        smi_writ_data       <=   spi_stsmi_rxdata ;        
    end
end


always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_bus_sel     <=   1'b0 ; 
    end
    else if( current_s != IDLE ) begin
        smi_bus_sel     <=   1'b1 ;
    end 
    else begin
        smi_bus_sel     <=   1'b0 ;  
    end
end

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_bus_read     <=   1'b0 ;  
    end
    else if( current_s == READ_DATA ) begin
        smi_bus_read     <=   1'b1 ;
    end 
    else begin
        smi_bus_read     <=   1'b0 ;  
    end
end

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_bus_write    <=   1'b0 ;  
    end
    else if( current_s == WRITE_DATA ) begin
        smi_bus_write    <=   1'b1 ;
    end 
    else begin
        smi_bus_write    <=   1'b0 ;  
    end
end

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        smi_operat      <=   2'b00 ;     
    end 
    else if( current_s == WRITE_DATA ) begin
        smi_operat      <=   2'b01 ; 
    end
    else if( current_s == READ_DATA ) begin
        smi_operat      <=   2'b10 ; 
    end
    else begin
        smi_operat      <=   2'b00 ;
    end 
end

/**********************************************************************/

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        stsmi_spi_txdata    <=   16'h00 ;    
    end
    else if( smi_read_dval == 1'b1 ) begin
        stsmi_spi_txdata    <=   smi_read_data ;
    end 
end

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        stsmi_spi_txdval    <=    1'b0 ;    
    end
    else if( smi_read_dval == 1'b1 ) begin
        stsmi_spi_txdval    <=    1'b1 ;
    end 
    else begin
        stsmi_spi_txdval    <=    1'b0 ;  
    end
end

/**********************************************************************/

always @( posedge clk_100m or posedge rst_100m ) begin
    if( rst_100m == 1'b1 ) begin
        current_s   <=  IDLE    ; 
    end
    else begin
        current_s  <=   next_s  ;
    end 
end

always @( * ) begin
    case( current_s )
        IDLE    :   begin
            if(  smi_write == 1'b1 ) begin
                next_s  =   WRITE_DATA  ; 
            end
            else if( smi_read == 1'b1 ) begin
                next_s  =   READ_DATA  ; 
            end
            else begin
                next_s  =   IDLE ; 
            end
        end
        WRITE_DATA  :   begin
            if( smi_end == 1'b1 ) begin
                next_s  =   WRITE_FINISH ; 
            end
            else begin
                next_s  =   WRITE_DATA ;
            end
        end
        READ_DATA   :   begin
            if( smi_end == 1'b1 ) begin
                 next_s  =   WRITE_FINISH ; 
            end
            else begin
                next_s  =   READ_DATA ;
            end
        end
        WRITE_FINISH    :   begin
            next_s  =    IDLE   ;
        end
        default :   begin
            next_s  =    IDLE   ; 
        end
    endcase 
end

/*************************************************************************/
    
    SMI                     U_SMI
    (                       
    .clk_100m               (clk_100m           ),
    .rst_100m               (rst_100m           ),
    .smi_bus_sel            (smi_bus_sel        ),
    .smi_bus_read           (smi_bus_read       ),
    .smi_bus_write          (smi_bus_write      ),
    .smi_mdc                (smi_mdc            ),
    .smi_mdi                (smi_mdi            ),
    .smi_mdo                (smi_mdo            ),
    .smi_end                (smi_end            ),
    .smi_link               (smi_link           ),
    .smi_operat             (smi_operat         ),
    .smi_phy_addr           (smi_phy_addr       ),
    .smi_dev_addr           (smi_dev_addr       ),
    .smi_writ_data          (smi_writ_data      ),
    .smi_read_data          (smi_read_data      ),
    .smi_read_dval          (smi_read_dval      )
    );  
    
endmodule
