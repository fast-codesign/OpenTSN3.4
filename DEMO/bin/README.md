### OpenTSN3.4-DEMO-bin

#### 概述  

bin文件夹下包括的是真实物理环境组网下的执行文件，包括软件编译后生成的可执行程序与硬件FPGA工程编译后的固化逻辑。

#### 结构 
```
    bin     //包括硬件固化逻辑、软件可执行程序  
		├── “ptp_app”         //802.1AS时间同步可执行程序  
		├── “tsnlight”        //TSN控制器可执行程序  
        ├── “sync_ctrl”       //AS6802时间同步可执行程序  		
		├── “tsnswitch.zip”   //交换机硬件固化逻辑  		
		└── “tsnnic.zip”      //网卡硬件固化逻辑  
```     
 
