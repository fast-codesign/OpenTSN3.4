#!/bin/bash
#
#make TYPE=TSN_SIM 表示对tsn仿真应用场景进行编译
#make TYPE=TSN_FPGA 表示对tsn FPGA应用场景进行编译

CC = gcc -g
AR = ar

LDHDPATH = -I ./opensync/include
ifeq (TSN_SIM,$(TYPE))
	LDLIBS = -lm  -L ./opensync/lib/ -lopensync -L ./opensync/src/ -lsim  -I /usr/local/include/libxml2/ -lxml2
else ifeq (TSN_FPGA,$(TYPE))
	LDLIBS = -lm  -L ./opensync/lib/ -lopensync -L ./opensync/src/ -lsim  -I /usr/local/include/libxml2/ -lxml2 -lpcap -lnet
endif

LIBSRC=./opensync/src/
OPENSYNCAPI = ./opensync/lib/

ptp_app: main.c ./tsninsight/tsninsight.c ptp_tsninsight.c 8021AS_P2P.c libopensync.a
	$(CC) -o ptp_app main.c ./tsninsight/tsninsight.c ptp_tsninsight.c 8021AS_P2P.c  $(LDLIBS) $(LDHDPATH)

libopensync.a:
	$(CC) -o $(LIBSRC)pkt_rec_api.o -c $(LIBSRC)pkt_rec_api.c $(LDLIBS) $(LDHDPATH)
	$(CC) -o $(LIBSRC)pkt_snd_api.o -c $(LIBSRC)pkt_snd_api.c $(LDLIBS) $(LDHDPATH)
	$(CC) -o $(LIBSRC)shadow_clock.o -c $(LIBSRC)shadow_clock.c
	$(CC) -o $(LIBSRC)tools.o -c $(LIBSRC)tools.c $(LDLIBS) $(LDHDPATH)
	$(CC) -o $(LIBSRC)clock_config.o -c $(LIBSRC)clock_config.c
	$(CC) -o $(LIBSRC)header_generate.o -c $(LIBSRC)header_generate.c
	$(CC) -o $(LIBSRC)header_parse.o -c $(LIBSRC)header_parse.c
	$(AR) -rc $(OPENSYNCAPI)libopensync.a $(LIBSRC)pkt_snd_api.o $(LIBSRC)pkt_rec_api.o $(LIBSRC)shadow_clock.o $(LIBSRC)tools.o $(LIBSRC)clock_config.o $(LIBSRC)header_generate.o $(LIBSRC)header_parse.o


clean:
	rm -rf ptp_app *.o $(LIBSRC)*.o $(OPENSYNCAPI)libopensync.a





