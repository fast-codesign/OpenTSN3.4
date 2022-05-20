CC = gcc
CFLAGS = -L../libsim -lsim

ROOT_DIR  = $(shell pwd)

EXEOBJECT = interlock
SRC = ./src/interlock.c ./src/time_service.c
OBJECT = interlock.o time_service.o

${EXEOBJECT}:${OBJECT}
	${CC} -o ${EXEOBJECT} ${OBJECT} ${CFLAGS}
${OBJECT}:${SRC}
	${CC} -c  ${SRC} ${INCLUDES}  -g

cleano:
	rm -rf *.o

clean:
	rm -rf *.a *.o