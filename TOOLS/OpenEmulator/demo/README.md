## OpenEmulator-demo

### 概述

OpenEmulator-demo介绍的是软硬件联合仿真工具的应用示例，仿真组网的拓扑是哑铃型，包含2个交换机和4个网卡。

### 结构  
demo  
├── script             //脚本程序，运行示例工程只需要在本文件夹下操作即可完成。具体操作步骤见OpenTSN3.4\TOOLS\OpenEmulator\doc\OpenEmulator使用手册-v1.0  
├── libs		       //FPGA器件依赖库  
├── data               //仿真组网的输入、输出文本     
├── sim project        //仿真工程搭建参考文件  
├── tsn net build      //仿真TSN网络搭建示例  
└── tsn_applications   //TSN网络控制器、TSN同步应用  
