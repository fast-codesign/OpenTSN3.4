## OpenTSN3.4-HARDWARE

### 概述

HARDWARE介绍的是OpenTSN3.4的硬件设计，包含设计文档、硬件源代码以及硬件FPGA工程脚本化示例
### 结构
  HARDWARE
    ├── doc           //硬件设计文档
	├── script        //硬件FPGA工程示例脚本
    └── src           //硬件源代码 
   	    ├── opensync_mac       //OS_MAC通用硬件源码，主要有时间戳标记、透明时钟计算、跨时钟域处理等功能
   	    ├── opentsn_hcp        //HCP通用硬件源码，支持本地配置、控制报文的查表转发、定时电路、cycle_start脉冲产生等功能
   	    ├── opentsn_tse        //TSE网卡核心源码（支持流映射、重映射、注入控制等功能）		  
   	    └── opentsn_tss        //TSS交换核心源码（支持流监管、查表转发等功能）	 