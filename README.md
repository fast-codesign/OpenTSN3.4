# OpenTSN3.4

## 概述
OpenTSN3.4开源项目基于新提出的同步架构，设计了同时支持1588、6802两种同步方式的硬件架构；同时设计了软硬件联合仿真工具OpenEmulator，实现在仿真环境下进行软硬件的联合调试。


## 结构
```  
opentsn-OpenTSN3.4                                                                   
	├──DEMO     //OpenTSN3.4真实物理组网环境示例                                     
	│      ├── bin              //执行文件，包括硬件固化文件、软件可执行文件              
	│      ├── config           //软件配置文本，包括控制器和同步软件应用的XML文本         
	│      └── doc              //操作使用手册                                            
	├──HARDWARE //OpenTSN3.4硬件设计                                                 
	│      ├── doc              //硬件设计文档、手册                                                                         		   
	│      ├── src              //硬件源代码                                              
	│	   │   ├── opensync_mac        //OS_MAC通用硬件源码（时间戳标记/透明时钟计算等功能）            
	│	   │   ├── opentsn_hcp         //HCP通用硬件源码（本地配置、定时电路等功能）        
	│	   │   ├── opentsn_tse         //TSE网卡核心源码（流映射/重映射/注入控制等功能） 	   
	│	   │   └── opentsn_tss         //TSS交换核心源码（流监管/查表转发等功能）  
    │      └── script           //硬件FPGA工程脚本程序    
	├──SOFTWARE //OpenTSN3.4软件设计                                                                                             
    │      ├── src              //软件源代码                                              
	│	   │   ├── tsnlight            //TSN网络控制器TSNLihgt                                
	│	   │   └── opensync            //opensync同步控制程序，包含TTE同步控制和TSN同步控制  
	│	   └── doc              //软件设计文档、手册  
	└──TOOLS    //OpenTSN3.4工具设计                                                   
	       └── OpenEmulator     //OpenTSN3.4软硬件联合仿真工具OpenEmulator                
		       ├── demo                //软硬件联合仿真组网示例（哑铃型）                     
		       ├── doc                 //仿真器设计文档、环境安装、使用手册等文档 	         
		       ├── lib                 //仿真器依赖的库文件说明  
               ├── script              //仿真器运行脚本，脚本执行参看OpenEmulator使用手册   			   
		       └── src                 //仿真器源码    				                         
```