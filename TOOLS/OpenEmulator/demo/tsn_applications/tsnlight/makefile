#!/bin/bash
#
#make TYPE=TSN_SIM 表示对tsn仿真应用场景进行编译
#make TYPE=TSN_FPGA 表示对tsn FPGA应用场景进行编译


CC = gcc -std=c99
AR = ar

LDHDPATH = -I ./complib/include 
LDLIBS = -lm 
ifeq (TSN_SIM,$(TYPE))
	LDLIBS2  = -L ./complib/ -lcomp_api -I /usr/local/include/libxml2/ -lxml2
else ifeq (TSN_FPGA,$(TYPE))
	LDLIBS2  = -L ./complib/ -lcomp_api -I /usr/local/include/libxml2/ -lxml2 -lpcap
endif

LIBSRC=./complib/src/



TSMPAPI = ./complib/

INIT_CFG = ./net_init/
BASIC_CFG = ./basic_cfg/
LOCAL_CFG = ./local_cfg/
NET_RUN = ./net_run/


tsnlight: main.c libcomp_api.a net_init.o basic_cfg.o local_cfg.o tsnlight_tsninsight.o 
	$(CC) -o tsnlight main.c $(INIT_CFG)net_init.o $(BASIC_CFG)basic_cfg.o $(LOCAL_CFG)local_cfg.o $(NET_RUN)tsnlight_tsninsight.o $(LDLIBS) $(LDLIBS2) $(LDHDPATH)

libcomp_api.a:

ifeq (TSN_FPGA,$(TYPE))
	$(CC) -o $(LIBSRC)tsmp_data_rec_engine.o -c $(LIBSRC)tsmp_data_rec_engine.c $(LDLIBS) $(LDLIBS2) $(LDHDPATH)
	$(CC) -o $(LIBSRC)tsmp_data_send_engine.o -c $(LIBSRC)tsmp_data_send_engine.c $(LDLIBS) $(LDLIBS2) $(LDHDPATH)
else ifeq (TSN_SIM,$(TYPE))
	$(CC) -o $(LIBSRC)tsmp_data_rec_engine.o -c $(LIBSRC)tsmp_data_rec_engine_sim.c $(LDLIBS) $(LDLIBS2) $(LDHDPATH)
	$(CC) -o $(LIBSRC)tsmp_data_send_engine.o -c $(LIBSRC)tsmp_data_send_engine_sim.c $(LDLIBS) $(LDLIBS2) $(LDHDPATH)
endif
	$(CC) -o $(LIBSRC)tsninsight.o -c $(LIBSRC)tsninsight.c $(LDLIBS) $(LDLIBS2) $(LDHDPATH)
	$(CC) -o $(LIBSRC)tsmp_reg_cfg.o -c $(LIBSRC)tsmp_reg_cfg.c $(LDLIBS) $(LDLIBS2) $(LDHDPATH)
	$(AR) -rc $(TSMPAPI)libcomp_api.a $(LIBSRC)tsninsight.o $(LIBSRC)tsmp_data_rec_engine.o $(LIBSRC)tsmp_data_send_engine.o $(LIBSRC)tsmp_reg_cfg.o 
	
net_init.o:
	$(CC) -o $(INIT_CFG)net_init.o -c $(INIT_CFG)net_init.c $(LDLIBS) $(LDLIBS2) $(LDHDPATH)

basic_cfg.o:
	$(CC) -o $(BASIC_CFG)basic_cfg.o -c $(BASIC_CFG)basic_cfg.c $(LDLIBS) $(LDLIBS2) $(LDHDPATH)

local_cfg.o:
	$(CC) -o $(LOCAL_CFG)local_cfg.o -c $(LOCAL_CFG)local_cfg.c $(LDLIBS) $(LDLIBS2) $(LDHDPATH)

tsnlight_tsninsight.o:
	$(CC) -o $(NET_RUN)tsnlight_tsninsight.o -c $(NET_RUN)tsnlight_tsninsight.c $(LDLIBS) $(LDLIBS2) $(LDHDPATH)

clean:
	rm -rf tsnlight  $(INIT_CFG)*.o $(BASIC_CFG)*.o $(LOCAL_CFG)*.o  $(NET_RUN)*.o $(LIBSRC)*.o $(TSMPAPI)*.a 
