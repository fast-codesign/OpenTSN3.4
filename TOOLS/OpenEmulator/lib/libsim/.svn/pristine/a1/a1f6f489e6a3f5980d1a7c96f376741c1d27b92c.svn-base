CC = gcc
AR = ar rc
CFLAGS = -g

ROOT_DIR  = $(shell pwd)

LIBOBJECT = libsim.a
SRC = ./src/data_rec.c ./src/data_send.c ./src/sim_time.c
OBJECT =  data_rec.o data_send.o sim_time.o
INCLUDES = -I./include

${LIBOBJECT}:${OBJECT}
	${AR} ${LIBOBJECT} ${OBJECT}
${OBJECT}:${SRC}
	${CC} -c ${SRC} ${INCLUDES} ${CFLAGS}


clean:
	rm -rf ./*.a ./*.o