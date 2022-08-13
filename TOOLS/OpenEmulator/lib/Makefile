CC = gcc
AR = ar rc
CFLAGS = -g

ROOT_DIR  = $(shell pwd)

SRC = ./src/data_rec.c ./src/data_send.c ./src/sim_time.c
OBJECT =  data_rec.o data_send.o sim_time.o
INCLUDES = -I./include


static:
	${CC} -c ${SRC} ${INCLUDES} ${CFLAGS}
	${AR}  libsim.a ${OBJECT}

dynamic: 
	${CC} -c -fPIC ${SRC} ${INCLUDES} ${CFLAGS}
	${CC} -shared -o libsim.so ${OBJECT}
	


clean:
	rm -rf ./*.a ./*.o ./*.so