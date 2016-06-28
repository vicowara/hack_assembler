%{
#include <stdint.h>
#define YYDEBUG 1
#define YYSTYPE uint16_t
void set_instructure_type(uint16_t*, char);
void set_value(uint16_t*, uint16_t);
void set_comp(uint16_t*, uint16_t);
void set_dest(uint16_t*, uint16_t);
void set_jump(uint16_t*, uint16_t);
uint16_t num2comp(uint16_t);
void putsbin(uint16_t);
%}
%token
                        NUMBER
                        SYMBOL
                        JUMP
                        DESTEQ
                        COMP
                        NL
                        AT
                        SEMIC
                        O_PAREN
                        C_PAREN
%%

programs:
        |       programs NL
        |       programs a_instructure NL
                {
                    set_instructure_type($2, 'a');
                    $$ = $2;
                    putsbin($$);
                }
        |       programs c_instructure NL
                {
                    set_instructure_type($2, 'c');
                    $$ = $2;
                    putsbin($$);
                }
        |       programs l_instructure NL
                {
                    // symbol define
                }
        ;

a_instructure:  AT a_expr { $$ = $2; }
        ;

c_instructure:  DESTEQ COMP
                {
                    set_dest($$, $1);
                    set_comp($$, $2);
                }
        |       DESTEQ NUMBER
                {
                    set_dest($$, $1);
                    set_comp($$, num2comp($2));
                }
        |       COMP SEMIC JUMP
                {
                    set_comp($$, $1);
                    set_jump($$, $3);
                }
        |       NUMBER SEMIC JUMP
                {
                    set_comp($$, num2comp($1));
                    set_jump($$, $3);
                }
        ;

l_instructure:  O_PAREN SYMBOL C_PAREN
        ;

a_expr:         NUMBER
        |       SYMBOL
        ;
%%

void set_instructure_type(uint16_t* instructure, char type) {
    if (type == 'a') {
        // 0x8000 == 0b1000000000000000
        *instructure &= ~0x8000;
    } else if (type == 'c') {
        // 0xe000 == 0b1110000000000000
        *instructure |= 0xe000;
    }
}

void set_value(uint16_t* instructure, uint16_t value) {
    // 0x7fff == 0b0111111111111111
    value &= 0x7fff;
    *instructure |= value;
}

uint16_t num2comp(uint16_t number) {
    if (number == 0) {
        return 42;
    } else if (number == 1) {
        return 63;
    } else if (number == -1) {
        return 58;
    }
}

void set_comp(uint16_t* instructure, uint16_t comp) {
    // 0x1fc0 == 0b0001111111000000
    comp = comp << 6;
    comp &= 0x1fc0;
    *instructure |= comp;
}

void set_dest(uint16_t* instructure, uint16_t dest) {
    // 0x0038 == 0b0000000000111000
    dest = dest << 3;
    dest &= 0x0038;
    *instructure |= dest;
}

void set_jump(uint16_t* instructure, uint16_t jump) {
    // 0x0007 == 0b0000000000000111
    jump &= 0x0007;
    *instructure |= jump;
}

void putsbin(uint16_t n) {
    int i;

    for (i = 15; i >= 0; i--) {
        printf("%d", (n >> i) & 1 );
    }
    printf("\n");
}
