// Copyright (C) 1953-2022 NUDT
// Verilog module name - hcp_register_group
// Version: V3.4.0.20220301
// Created:
//         by - fenglin
////////////////////////////////////////////////////////////////////////////
// Description:
//         - encapsulate ARP request frame、PTP frame、NMAC report frame to tsmp frame;
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module hcp_register_group 
#(//parameter opentsn_controller_mid = 12'h800,
  parameter vendor_id = 16'h0000,//opentsn
  parameter device_id = 16'h0000,//tsnswitch
  parameter hcp_ver   = 32'h3410
  //parameter ost_ver   = 8'h34,
  //parameter osm_ver   = 8'h34
  //parameter iv_hardware_control_point_version = 64'h0003040020220301, 
  //parameter iv_time_sensitive_switch_version = 64'h0003040020220301,
  //parameter iv_port_num = 8'h08
  )
(
        i_clk,
        i_rst_n,

	    iv_hcp_mid,
        iv_tsnlight_mid,
        iv_os_cid ,
        iv_tss_ver,
        o_rc_rxenable,
        o_st_rxenable,
        //o_tsmp_fwenable,
        //i_tsn_or_tte,
        //iv_hardware_control_point_version,
        //iv_time_sensitive_switch_version,
        //iv_port_num,
        
        iv_addr                  ,         
        i_addr_fixed             ,        
        iv_wdata                 ,         
        i_wr                     ,      
        i_rd                     ,      
           
        o_wr                     ,      
        ov_addr                  ,      
        o_addr_fixed             ,      
        ov_rdata                 , 
	   
        ov_hcp_mac               ,
        ov_tsnlight_controller_mac,
        ov_opensync_controller_mac        
);

// I/O
// clk & rst
input                   i_clk;
input                   i_rst_n;  

input	    [11:0]	    iv_hcp_mid;
input       [11:0]      iv_os_cid ;
input       [11:0]      iv_tsnlight_mid;
input       [31:0]      iv_tss_ver;
//input                   i_tsn_or_tte;//0:as6802;1:ptp
//input       [63:0]      iv_hardware_control_point_version;
//input       [63:0]      iv_time_sensitive_switch_version;
//input       [7:0]       iv_port_num;
output reg              o_rc_rxenable;
output reg              o_st_rxenable;
//output reg              o_tsmp_fwenable;

input       [18:0]      iv_addr;                         
input                   i_addr_fixed;                   
input       [31:0]      iv_wdata;                        
input                   i_wr;         
input                   i_rd;         
output reg              o_wr                  ;          
output reg  [18:0]      ov_addr               ;       
output reg              o_addr_fixed          ;  
output reg  [31:0]      ov_rdata              ;
//output
output      [47:0]	    ov_hcp_mac                   ;
output      [47:0]	    ov_tsnlight_controller_mac   ;
output      [47:0]	    ov_opensync_controller_mac   ;
assign      ov_hcp_mac                  =  {24'h662662,iv_hcp_mid,12'h000};
assign      ov_tsnlight_controller_mac  =  {24'h662662,iv_tsnlight_mid,12'h001};
assign      ov_opensync_controller_mac  =  {24'h662662,iv_os_cid,12'h002};
always@(posedge i_clk or negedge i_rst_n)begin
    if(!i_rst_n) begin 
        o_rc_rxenable          <= 1'b0    ;
        o_st_rxenable          <= 1'b0    ;
        //o_tsmp_fwenable        <= 1'b0    ;
        o_wr                   <= 1'b0    ;
        ov_addr                <= 19'b0   ;
        o_addr_fixed           <= 1'b0    ;
        ov_rdata               <= 32'b0   ;        
    end
    else begin
        if(i_wr)begin//write
            o_wr                  <= 1'b0    ;
            ov_addr               <= 19'b0   ;
            o_addr_fixed          <= 1'b0    ;
            ov_rdata              <= 32'b0   ;   
            if((!i_addr_fixed) && (iv_addr == 19'd4))begin 
                o_rc_rxenable     <= iv_wdata[0];
                o_st_rxenable     <= iv_wdata[1];
                //o_tsmp_fwenable   <= iv_wdata[2];
            end             
            else begin
                o_rc_rxenable     <= o_rc_rxenable  ;
                o_st_rxenable     <= o_st_rxenable  ;
                //o_tsmp_fwenable   <= o_tsmp_fwenable;           
            end            
        end
        else if(i_rd)begin//read
            if((!i_addr_fixed) && (iv_addr == 19'd0))begin
                o_wr                  <= 1'b1                  ;
                ov_addr               <= iv_addr               ;
                o_addr_fixed          <= i_addr_fixed          ;
                ov_rdata              <= {device_id,vendor_id}  ;  
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd1))begin
                o_wr                  <= 1'b1                  ;
                ov_addr               <= iv_addr               ;
                o_addr_fixed          <= i_addr_fixed          ;
                ov_rdata              <= hcp_ver               ;  
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd2))begin
                o_wr                  <= 1'b1                  ;
                ov_addr               <= iv_addr               ;
                o_addr_fixed          <= i_addr_fixed          ;
                ov_rdata              <= {8'b0,iv_tsnlight_mid,iv_hcp_mid}    ;  
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd3))begin
                o_wr                  <= 1'b1                  ;
                ov_addr               <= iv_addr               ;
                o_addr_fixed          <= i_addr_fixed          ;
                ov_rdata              <= iv_tss_ver            ;  
            end
            else if((!i_addr_fixed) && (iv_addr == 19'd4))begin
                o_wr                  <= 1'b1                  ;
                ov_addr               <= iv_addr               ;
                o_addr_fixed          <= i_addr_fixed          ;
                ov_rdata              <= {30'b0,o_st_rxenable,o_rc_rxenable};
                //ov_rdata              <= {29'b0,o_tsmp_fwenable,o_st_rxenable,o_rc_rxenable};  
            end
            //else if((!i_addr_fixed) && (iv_addr == 19'd4))begin
            //    o_wr                  <= 1'b1                  ;
            //    ov_addr               <= iv_addr               ;
            //    o_addr_fixed          <= i_addr_fixed          ;
            //    ov_rdata              <= {20'b0,ov_opensync_controller_mac[23:12]}  ;  
            //end
            //else if((!i_addr_fixed) && (iv_addr == 19'd5))begin
            //    o_wr                  <= 1'b1                  ;
            //    ov_addr               <= iv_addr               ;
            //    o_addr_fixed          <= i_addr_fixed          ;
            //    ov_rdata              <= {i_tsn_or_tte,15'b0,ost_ver,osm_ver};  
            //end 
            //else if((!i_addr_fixed) && (iv_addr == 19'd6))begin
            //    o_wr                  <= 1'b1                  ;
            //    ov_addr               <= iv_addr               ;
            //    o_addr_fixed          <= i_addr_fixed          ;
            //    ov_rdata              <= {20'b0,iv_tsnlight_mid}  ;  
            //end             
            else begin
                o_wr                  <= 1'b0    ;
                ov_addr               <= 19'b0   ;
                o_addr_fixed          <= 1'b0    ;
                ov_rdata              <= 32'b0   ;
            end          
        end
        else begin
            o_wr                  <= 1'b0    ;
            ov_addr               <= 19'b0   ;
            o_addr_fixed          <= 1'b0    ;
            ov_rdata              <= 32'b0   ;
        end        
    end
end 
endmodule