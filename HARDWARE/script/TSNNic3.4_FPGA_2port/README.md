### OpenTSN3.4-HARDWARE-script-TSNNic3.4_FPGA_2port

#### 概述

TSNNic3.4_FPGA_2port介绍的是OpenTSN3.4的网卡实例化工程。
#### 结构
TSNNic3.4_FPGA_2port
          ├── ipcore                //TSN网卡示例工程使用的所有IP核以及其存放路径
		  ├── rtl					//TSN网卡示例工程的器件相关代码和接口相关代码
		  ├── create_project.tcl    //创建TSN网卡示例工程的脚本文件
		  ├── Makefile              //编译TSN网卡示例工程的Makefile文件，详细使用请见OpenTSN3.4-centralized\Hardware\doc\使用手册目录下的TSN网卡使用手册第三章节
          └── TSN_FPGA_4port.sdc    //TSN网卡示例工程的设计约束文件  

