# OpenTSN3.4-SOFTWARE-src

## 概述

src介绍的是OpenTSN3.4的软件设计源码，包含软件控制器、opensync同步控制程序源码。opensync对应的硬件代码，包括opensync_mac和opensync_timing。 
硬件源码路径： 
opensync_mac：OpenTSN3.4\HARDWARE\src\opensync_mac  
opensync_timing：OpenTSN3.4\HARDWARE\src\opentsn_hcp\opensync_timing  
## 结构
```
SOFTWARE  
  ├── TSNLight              //控制器软件源码,设计文档参考OpenTSN3.4\SOFTWARE\doc\TSN网络控制器(TSNLight3.4)设计方案-v1.0  
  └── opensync              //同步控制程序源码   
	  ├── 802.1_AS               //802.1_AS时钟同步程序源码,设计文档参考OpenTSN3.4\SOFTWARE\doc\802.1AS_P2P时间同步设计方案-v1.0  	  
	  └── AS_6802                //AS_6802时钟同步程序源码,设计文档参考OpenTSN3.4\SOFTWARE\doc\基于OpenSync的TTE时钟同步控制软件设计方案-v1.0  
```

