CC = gcc -g -fno-stack-protector
AR = ar

LDHDPATH = -I ./include -I ../include
LDLIBS = -L ../lib -lopensync -lpcap -lnet -lsim -lxml2
TTESYNCSRC = ./src/

sync_ctrl: main.c $(TTESYNCSRC)libttesync.a 
	$(CC) -o sync_ctrl main.c $(TTESYNCSRC)libttesync.a -L ./src -lttesync $(LDLIBS) $(LDHDPATH)

$(TTESYNCSRC)libttesync.a:
	$(CC) -o $(TTESYNCSRC)basic_func.o -c $(TTESYNCSRC)basic_func.c 
	$(CC) -o $(TTESYNCSRC)cm_pkt_proc.o -c $(TTESYNCSRC)cm_pkt_proc.c $(LDLIBS) $(LDHDPATH)
	$(CC) -o $(TTESYNCSRC)cm_timeout_handle.o -c $(TTESYNCSRC)cm_timeout_handle.c $(LDLIBS) $(LDHDPATH)
	$(CC) -o $(TTESYNCSRC)pcf_pkt_generate.o -c $(TTESYNCSRC)pcf_pkt_generate.c 
	$(CC) -o $(TTESYNCSRC)sm_pkt_proc.o -c $(TTESYNCSRC)sm_pkt_proc.c	$(LDLIBS) $(LDHDPATH)
	$(CC) -o $(TTESYNCSRC)sm_timeout_handle.o -c $(TTESYNCSRC)sm_timeout_handle.c $(LDLIBS) $(LDHDPATH)
	$(CC) -o $(TTESYNCSRC)timerlist.o -c $(TTESYNCSRC)timerlist.c
	$(CC) -o $(TTESYNCSRC)pkt_process.o -c $(TTESYNCSRC)pkt_process.c
	
	$(AR) -rc $(TTESYNCSRC)libttesync.a $(TTESYNCSRC)basic_func.o $(TTESYNCSRC)cm_pkt_proc.o $(TTESYNCSRC)cm_timeout_handle.o $(TTESYNCSRC)pcf_pkt_generate.o \
	$(TTESYNCSRC)sm_pkt_proc.o $(TTESYNCSRC)sm_timeout_handle.o $(TTESYNCSRC)timerlist.o $(TTESYNCSRC)pkt_process.o

clean:
	rm -rf sync_ctrl $(TTESYNCSRC)*.o $(TTESYNCSRC)*.a
