### OpenTSN3.4-HARDWARE-script-TSNNic3.4_FPGA_2port-ipcore

####  概述
因针对不同的平台或者不同的FPGA器件，所使用的IP核生成存在差异，所以IP核文件需要用户自行依据提供的IP核配置参数去生成IP核.

####  IP核参数
TSN网卡硬件核心代码中总共使用到18个IP核文件，IP核详细配置参数如下：
（1）IP核:2-port RAM
    ipcore_name:simpledualportram_drwclock_outputaclr_w8d16
    Operation Mode:With one read port and one write port
    Ram_width:8
    Ram_depth:16
    Clocking method:dual clock:use separate 'read' and 'write' clocks
    Create a 'rden' read enable signal:selected
    Read input aclrs:selected
    Others:default

（2）IP核:2-port RAM
    ipcore_name:simpledualportram_drwclock_outputaclr_w9d16
    Operation Mode:With one read port and one write port
    Ram_width:9
    Ram_depth:16
    Clocking method:dual clock:use separate 'read' and 'write' clocks
    Create a 'rden' read enable signal:selected
    Read input aclrs:selected
    Others:default

（3）IP核: FIFO
    ipcore_name:syncfifo_w9d128_aclr_showahead
    Fifo_width:9
    Fifo_depth:128
    Clock for reading and writing the FIFO : synchronize both reading and writing to 'clock'
    Read access:show_ahead synchronous FIFO mode
    Reset:Asynchronous clear
    Others:default

（4）IP核: FIFO
    ipcore_name:dcm_fifo9x256
    Fifo_width:9
    Fifo_depth:256
    Clock for reading and writing the FIFO : synchronize both reading and writing to 'clock'.
    Read access:show_ahead synchronous FIFO mode
    Reset:Asynchronous clear
    Others:default

（5）IP核:FIFO
    ipcore_name:fifo_35x4
    Fifo_width:35
    Fifo_depth:4
    Clock for reading and writing the FIFO : synchronize both reading and writing to 'clock'.
    Read access:show_ahead synchronous FIFO mode
    Reset:Asynchronous clear
    Others:default

（6）IP核:2-port RAM
    ipcore_name:asdprf16x22_s
    Operation Mode:With one read port and one write port
    Ram_width:22
    Ram_depth:16
    Clocking method:single
    Create a 'rden' read enable signal:selected
    Read input aclrs:selected
    Others:default

（7）IP核:2-port RAM
    ipcore_name:asdprf32x40_s
    Operation Mode:With one read port and one write port
    Ram_width:40
    Ram_depth:32
    Clocking method:single
    Create a 'rden' read enable signal:selected
    Read input aclrs:selected
    Others:default

（8）IP核:2-port RAM
    ipcore_name:ram_60_32
    Operation Mode:With two read/write ports
    Ram_width:60
    Ram_depth:32
    Clocking method : Single
    Create 'rden_a' and 'read_b' read enable signal:selected
    Others:default

（9）IP核:2-port RAM
    ipcore_name:ram_163_32
    Operation Mode:With two read/write ports
    Ram_width:163
    Ram_depth:32
    Clocking method : Single
    Create 'rden_a' and 'read_b' read enable signal:selected
    Others:default

（10）IP核:2-port RAM
    ipcore_name:suhddpsram1024x8_rq
    Operation Mode:With two read/write ports
    Ram_width:8
    Ram_depth:1024
    Clocking method : Single
    Create 'rden_a' and 'read_b' read enable signal:selected
    Others:default

（11）IP核:2-port RAM
    ipcore_name:suhddpsram1024x16_rq
    Operation Mode:With two read/write ports
    Ram_width:16
    Ram_depth:1024
    Clocking method : Single
    Create 'rden_a' and 'read_b' read enable signal:selected
    Others:default

（12）IP核:2-port RAM
    ipcore_name:sdprf512x9_s
    Operation Mode:With one read port and one write port
    Ram_width:9
    Ram_depth:512
    Clocking method : Single
    Create a 'rden' read enable signal:selected
    Read input aclrs:selected
    Others:default

（13）IP核:2-port RAM
    ipcore_name:suhddpsram65536x134_s
    Operation Mode:With two read/write ports
    Ram_width:134
    Ram_depth:65536
    Clocking method : Single
    Create 'rden_a' and 'read_b' read enable signal:selected
    Output aclrs:"q_a port" and "q_b port" are both selected
    Others:default

（14）IP核:2-port RAM
    ipcore_name:suhddpsram512x4_rq
    Operation Mode:With two read/write ports
    Ram_width:4
    Ram_depth:512
    Clocking method : Single
    Create 'rden_a' and 'read_b' read enable signal:selected
    Output aclrs:"q_a port" and "q_b port" are both selected
    Others:default

（15）IP核:2-port RAM
    ipcore_name:truedualportram_singleclock_outputaclr_w34d4096s
    Operation Mode:With two read/write ports
    Ram_width:34
    Ram_depth:4096
    Clocking method : Single
    Create 'rden_a' and 'read_b' read enable signal:selected
    Output aclrs:"q_a port" and "q_b port" are both selected
    Others:default

（16）IP核：altera_iopll 
    ipcore_name:clk125M_50M125M
    Device Family:Arria 10
    Component:10AX048H2F34E2SG
    Speed Grade:2
    Reference Clock Frequency : 125.0 MHz
    Enable locked output port : selected
    Compensation Mode : direct
    Number Of Clocks : 2
    Clock Name of outclk0 : clk_50M
    Desired Frequency of outclk0 : 50.0 MHz
    Phase Shift Units of outclk0 : ps
    Desired Phase Shift of outclk0 : 0.0  
    Desired  Duty Cycle of outclk0 : 50.0%
    Clock Name of outclk1 : clk_125M
    Desired Frequency of outclk0 : 125.0 MHz
    Phase Shift Units of outclk0 : ps
    Desired Phase Shift of outclk0 : 0.0  
    Desired  Duty Cycle of outclk0 : 50.0%
    PLL Bandwidth Preset : Low
    Others:default

（17）IP核: altera_eth_tse （生成三速以太网IP核后，需替换两个文件，详见./sgmii_pcs_revise_note）
    ipcore_name:sgmii_pcs_share
    Core variation : 10/100/1000Mb Ethernet MAC with 1000BASE-X/sgmii pcs
    Component:10AX048H2F34E2SG
    Use internal fifo：deseclect（不勾选Use internal fifo）
    Number of ports : 4
    Transceiver type : LVDS I/O
    PHY ID : 0x00000000
    Others:default
（18）IP核: FIFO
    ipcore_name:DCFIFO_10bit_64
    Fifo_width:10
    Fifo_depth:64
    Clock for reading and writing the FIFO : synchronize reading and writing to 'rdclk' and 'wrclk', respectively.
    Asynchronous clear: selected
    Read access:Normal synchronous FIFO mode
    Others:default
