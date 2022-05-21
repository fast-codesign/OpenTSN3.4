### OpenTSN3.4-Hardware-src

#### 概述

src文件夹展示的是OpenTSN3.4的硬件源码，包含通用硬件HCP源码、OS_MAC源码以及交换核心TSS源码、网卡核心TSE源码。通用硬件源码交换机和网卡共用。
#### 结构
```
 src
   ├── opensync_mac    //通用硬件OS_MAC源码,具体模块功能、对外接口以及使用方式参看设计文档的3.1章节，文档路径Hardware/doc/TSN交换机（TSNSwitch3.4）设计方案-v1.0
   ├── opentsn_hcp     //通用硬件HCP源码,具体模块功能、对外接口以及使用方式参看设计文档的3.2章节，文档路径Hardware/doc/TSN交换机（TSNSwitch3.4）设计方案-v1.0
   ├── opentsn_tse     //网卡核心TSE源码,具体模块功能、对外接口以及使用方式参看设计文档的3.3章节，文档路径Hardware/doc/TSN网卡（TSNNic3.4）设计方案-v1.0   
   └── opentsn_tss     //交换核心TSS源码,具体模块功能、对外接口以及使用方式参看设计文档的3.3章节，文档路径Hardware/doc/TSN交换机（TSNSwitch3.4）设计方案-v1.0 
```     
 
