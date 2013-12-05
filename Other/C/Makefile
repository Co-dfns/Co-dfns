CC = clang
CPP = clang++
CFLAGS = -g -pedantic -Wall -ansi -fno-color-diagnostics `llvm-config --cflags` -I.

SRC := util.c pool.c stack.c ast.c parser.c env.c \
	lift_constants.c generate_llvm.c codfns.c
OBJ := $(SRC:.c=.o)
PEG := $(wildcard *.peg)

CLEANERS = 

all: codfns

codfns: $(OBJ)
	$(CPP) $(OBJ) `llvm-config --ldflags --libs` -o $@


include tests/Makefile
include $(OBJ:.o=.d)

%.d: %.c
	$(CC) -MM -MG $(CFLAGS) $*.c > $@

%.c: %.peg
	peg -o $@ $<

clean: $(CLEANERS)
	rm -f $(OBJ) 
	rm -f $(OBJ:.o=.d)
	rm -f $(PEG:.peg=.c)
	rm -f codfns
