
CC=gcc -g
AR=ar

LDHDPATH = -I ./include 
LDLIBS =-lm -lpcap

LIBSRC=./src/


all: clean libcomp.a

libcomp.a:
	$(CC) -o $(LIBSRC)tsmp_data_rec_engine.o -c $(LIBSRC)tsmp_data_rec_engine.c $(LDLIBS) $(LDHDPATH)
	$(CC) -o $(LIBSRC)tsmp_data_send_engine.o -c $(LIBSRC)tsmp_data_send_engine.c $(LDLIBS) $(LDHDPATH)

	$(CC) -o $(LIBSRC)tsmp_reg_cfg.o -c $(LIBSRC)tsmp_reg_cfg.c $(LDLIBS) $(LDHDPATH)

	ar -rc libcomp.a $(LIBSRC)tsmp_data_rec_engine.o $(LIBSRC)tsmp_data_send_engine.o $(LIBSRC)tsmp_reg_cfg.o

clean:
	rm -rf $(LIBSRC)*.o *.a 
	
