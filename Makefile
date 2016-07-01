CC = clang
LD = clang
LEX = lex
YACC = bison
YACCFLAGS = -dv
CFLAGS = -g -Wall -DYYERROR_VERBOSE
LDFLAGS = -ll

PROG = asm
OBJS = main.o y.tab.o lex.yy.o
TEMPS = y.tab.c y.tab.h lex.yy.c

LEX_FILE = lex.l
YACC_FILE = parse.y

.PHONY:	all clean

all:	$(PROG)

clean:
	$(RM) $(OBJS) $(PROG) $(TEMPS)

lex.yy.c:	$(LEX_FILE)
	$(LEX) -o $@ $<

y.tab.c:	$(YACC_FILE)
	$(YACC) $(YACCFLAGS) $(YACC_FILE) -o $@

%.o:	%.c
	$(CC) $(CFLAGS) -c $<

$(PROG):	$(OBJS)
	$(LD) -o $@ $(OBJS) $(LDFLAGS)
