%{
#include <stdio.h>
#include <stdint.h>
#include <search.h>
#include "symtable.h"
#include "node.h"
#define YYDEBUG 1

static node_t *dummy_head, *current;

void init_parser(void);
node_t* get_list(void);
void destruct_parser(void);

static node_t* set_instructure_type(node_t*, char);
static node_t* set_comp(node_t*, uint16_t);
static node_t* set_dest(node_t*, uint16_t);
static node_t* set_jump(node_t*, uint16_t);
static uint16_t num2comp(uint16_t);
%}

%union
{
    node_t *node;
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

%type   <node>          instructure
%type   <node>          a_instructure c_instructure
%type   <node>          l_instructure

%start instructures

%%

instructures://     empty
        |       instructures instructure
                {
                    current->next = $2;
                    current = $2;
                }
        |       instructures NL
        ;

instructure:    a_instructure NL
                {
                    $$ = set_instructure_type($1, 'a');
                }
        |       c_instructure NL
                {
                    $$ = set_instructure_type($1, 'c');
                }
        |       l_instructure NL
                {
                    $$ = $1;
                }
        ;

a_instructure:  AT NUMBER
                {
                    $$ = node_init_with_num($2);
                }
        |       AT SYMBOL
                {
                    $$ = node_init_with_symbol($2);
                }
        ;

c_instructure:  DESTEQ COMP
                {
                    node_t *temp;
                    temp = new_node();
                    set_dest(temp, $1);
                    set_comp(temp, $2);
                    $$ = temp;
                }
        |       DESTEQ NUMBER
                {
                    node_t *temp;
                    temp = new_node();
                    set_dest(temp, $1);
                    set_comp(temp, num2comp($2));
                    $$ = temp;
                }
        |       COMP SEMIC JUMP
                {
                    node_t *temp;
                    temp = new_node();
                    set_comp(temp, $1);
                    set_jump(temp, $3);
                    $$ = temp;
                }
        |       NUMBER SEMIC JUMP
                {
                    node_t *temp;
                    temp = new_node();
                    set_comp(temp, num2comp($1));
                    set_jump(temp, $3);
                    $$ = temp;
                }
        ;

l_instructure:  O_PAREN SYMBOL C_PAREN
                {
                    $$ = node_init_with_label($2);
                }
        ;

%%
void init_parser(void) {
    dummy_head = current = new_node();
}

node_t* get_list() {
    // 本当のリストのheadはdummyの次
    return dummy_head->next;
}

void destruct_parser() {
    node_t *tmp;
    for (tmp = dummy_head; tmp != NULL; tmp = tmp->next) {
        free(tmp);
    }
}

// FIXME: 関数名が微妙
node_t* set_instructure_type(node_t *node, char type) {
    if (type == 'a') {
        // 0x8000 == 0b1000000000000000
        node->value &= ~0x8000;
    } else if (type == 'c') {
        // 0xe000 == 0b1110000000000000
        node->value |= 0xe000;
    }
    return node;
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

node_t* set_comp(node_t *node, uint16_t comp) {
    // 0x1fc0 == 0b0001111111000000
    comp = comp << 6;
    comp &= 0x1fc0;
    node->value |= comp;
    return node;
}

node_t* set_dest(node_t *node, uint16_t dest) {
    // 0x0038 == 0b0000000000111000
    dest = dest << 3;
    dest &= 0x0038;
    node->value |= dest;
    return node;
}

node_t* set_jump(node_t *node, uint16_t jump) {
    // 0x0007 == 0b0000000000000111
    jump &= 0x0007;
    node->value |= jump;
    return node;
}
