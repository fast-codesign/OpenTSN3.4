## OpenTSN3.4-TOOLS-OpenEmulator

### 概述

TSN网络在部署前需要对网络进行验证以确保可靠性，并且在真实的TSN网络环境中对各种故障情况模拟的难度比较大。基于这些问题，OpenTSN项目组基于OpenTSN3.4架构，搭建了联合仿真调试平台OpenEmulator，实现在仿真环境下进行软硬件的联合调试，并具有以下几个特性：

### 结构  
OpenEmualtor  
   ├── demo     //软硬件联合仿真组网示例，组网示例环境使用参考OpenTSN3.4\TOOLS\OpenEmulator\doc\OpenEmulator使用手册  
   ├── doc      //仿真器设计文档、环境安装、使用手册等文档  	
   ├── lib      //仿真器依赖的库文件说明  					  
   └── src      //仿真器源码   
