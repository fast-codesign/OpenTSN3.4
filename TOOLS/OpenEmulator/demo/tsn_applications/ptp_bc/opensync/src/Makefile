CC = gcc -g
AR = ar

LDHDPATH = -I ../include
LDLIBS = -lpcap -lnet -lsim


libopensync.a:
	$(CC) -o pkt_rec_api.o -c pkt_rec_api.c $(LDLIBS) $(LDHDPATH)
	$(CC) -o pkt_snd_api.o -c pkt_snd_api.c $(LDLIBS) $(LDHDPATH)
	$(CC) -o shadow_clock.o -c shadow_clock.c
	$(CC) -o tools.o -c tools.c $(LDLIBS) $(LDHDPATH)
	$(CC) -o clock_config.o -c clock_config.c
	$(CC) -o header_generate.o -c header_generate.c
	$(CC) -o header_parse.o -c header_parse.c
	$(AR) -rc ../lib/libopensync.a pkt_snd_api.o pkt_rec_api.o shadow_clock.o tools.o clock_config.o header_generate.o header_parse.o

clean:
	rm -rf *.o ../lib/libopensync.a