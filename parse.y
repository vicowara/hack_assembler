%{
#include <stdio.h>
#include <stdint.h>
#include <search.h>
#include "symtable.h"
#define YYDEBUG 1

static uint16_t output_lineno = 0; //一応明示

uint16_t set_instructure_type(uint16_t, char);
uint16_t set_value(uint16_t, uint16_t);
uint16_t set_comp(uint16_t, uint16_t);
uint16_t set_dest(uint16_t, uint16_t);
uint16_t set_jump(uint16_t, uint16_t);
uint16_t num2comp(uint16_t);
void putsbin(uint16_t);
%}

%union
{
    uint16_t value;
    char *symbol;
}

%token  <value>         NUMBER
                        JUMP
                        DESTEQ
                        COMP

%token  <symbol>        SYMBOL

%token                  AT
                        NL
                        SEMIC
                        O_PAREN
                        C_PAREN

%type   <value>         instructures
%type   <value>         a_instructure c_instructure
%type   <symbol>        l_instructure

%start instructures

%%

instructures:
        |       instructures NL
        |       instructures a_instructure NL
                {
                    $$ = set_instructure_type($2, 'a');
                    putsbin($$);
                    output_lineno++;
                }
        |       instructures c_instructure NL
                {
                    $$ = set_instructure_type($2, 'c');
                    putsbin($$);
                    output_lineno++;
                }
        |       instructures l_instructure NL
                {
                    // symbol define
                }
        ;

a_instructure:  AT NUMBER
                {
                    $$ = $2;
                }
        |       AT SYMBOL
                {
                    $$ = symbol_resolv($2);
                }
        ;

c_instructure:  DESTEQ COMP
                {
                    uint16_t temp;
                    temp = set_dest(0, $1);
                    $$ = set_comp(temp, $2);
                }
        |       DESTEQ NUMBER
                {
                    uint16_t temp;
                    temp = set_dest(0, $1);
                    $$ = set_comp(temp, num2comp($2));
                }
        |       COMP SEMIC JUMP
                {
                    uint16_t temp;
                    temp = set_comp(0, $1);
                    $$ = set_jump(temp, $3);
                }
        |       NUMBER SEMIC JUMP
                {
                    uint16_t temp;
                    temp = set_comp(0, num2comp($1));
                    $$ = set_jump(temp, $3);
                }
        ;

l_instructure:  O_PAREN SYMBOL C_PAREN
                {
                    symbol_define($2, output_lineno + 1);
                }
        ;

%%
                // FIXME: 関数名が微妙
uint16_t set_instructure_type(uint16_t instructure, char type) {
    if (type == 'a') {
        // 0x8000 == 0b1000000000000000
        instructure &= ~0x8000;
    } else if (type == 'c') {
        // 0xe000 == 0b1110000000000000
        instructure |= 0xe000;
    }
    return instructure;
}

uint16_t set_value(uint16_t instructure, uint16_t value) {
    // 0x7fff == 0b0111111111111111
    value &= 0x7fff;
    instructure |= value;
    return instructure;
}

uint16_t num2comp(uint16_t number) {
    if (number == 0) {
        return 42;
    } else if (number == 1) {
        return 63;
    } else if (number == 0xffff) { // unsignedなので一応
        return 58;
    }
}

uint16_t set_comp(uint16_t instructure, uint16_t comp) {
    // 0x1fc0 == 0b0001111111000000
    comp = comp << 6;
    comp &= 0x1fc0;
    instructure |= comp;
    return instructure;
}

uint16_t set_dest(uint16_t instructure, uint16_t dest) {
    // 0x0038 == 0b0000000000111000
    dest = dest << 3;
    dest &= 0x0038;
    instructure |= dest;
    return instructure;
}

uint16_t set_jump(uint16_t instructure, uint16_t jump) {
    // 0x0007 == 0b0000000000000111
    jump &= 0x0007;
    instructure |= jump;
    return instructure;
}

void putsbin(uint16_t n) {
    int i;

    for (i = 15; i >= 0; i--) {
        printf("%d", (n >> i) & 1 );
    }
    printf("\n");
}
