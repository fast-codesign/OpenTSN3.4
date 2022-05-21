## OpenEmulator-demo

### 概述

OpenEmulator-demo介绍的是软硬件联合仿真工具的应用示例，仿真组网的拓扑是哑铃型，包含2个交换机和4个网卡。

### 结构  
```  
demo  
├── libs		       //FPGA器件依赖库  
├── data               //仿真组网的输入、输出文本     
├── sim project        //仿真工程搭建参考文件  
├── tsn net build      //仿真TSN网络搭建示例  
└── tsn_applications   //TSN网络控制器、TSN同步应用  
```  