### OpenTSN3.4-HARDWARE-script-TSNSwitch3.4_FPGA_4port

#### 概述

TSNSwitch3.4_FPGA_4port介绍的是OpenTSN3.4的交换机实例化工程。
#### 结构
TSNSwitch3.4_FPGA_4port
          ├── ipcore                //TSN交换机示例工程使用的所有IP核以及其存放路径
		  ├── rtl					//TSN交换机示例工程的器件相关代码和接口相关代码
		  ├── create_project.tcl    //创建TSN交换机示例工程的脚本文件
		  ├── Makefile              //编译TSN交换机示例工程的Makefile文件，详细使用请见OpenTSN3.1-centralized\Hardware\doc\使用手册目录下的TSN交换机使用手册第三章节
          └── TSN_FPGA_4port.sdc    //TSN交换机示例工程的设计约束文件  

