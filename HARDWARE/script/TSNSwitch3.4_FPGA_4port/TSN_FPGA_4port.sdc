##Copyright (C) 1953-2021 NUDT
## file name - TSN_FPGA_4port.sdc 
##Version: TSN_FPGA_4port.sdc_V1.0
## Created:
##        by - fenglin 
##         at - 10.2020
##############################################
## Description:
##		  file of project design constraint.
##				 
##############################################
derive_pll_clocks
derive_clock_uncertainty
create_clock -name FPGA_SYS_CLK -period 8.000 -waveform {0 4} [get_ports {FPGA_SYS_CLK}]