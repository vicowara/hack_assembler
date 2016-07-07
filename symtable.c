#include <stdlib.h>
#include <stdint.h>
#include <search.h>
#include <string.h>

#include "symtable.h"

static uint16_t assigned_index = 0x10;

uint16_t symbol_resolv(char* symbol){
    uint16_t *temp;
    ENTRY e, *ep;
    // symbolはlex側でstrdupされているはず
    e.key = symbol;
    // まず捜索する
    ep = hsearch(e, FIND);
    if (ep) {
        // 見つかったので返す
        return *(uint16_t *)(ep->data);
    } else {
        // 見つからなかったので新しいメモリ領域を割り当てる
        // hdestroyした時にfreeされるらしいので一応mallocする
        temp = (uint16_t *)malloc(sizeof(uint16_t));
        *temp = assigned_index++;

        e.data = temp;
        hsearch(e, ENTER);
       
        return *(uint16_t *)(e.data);
    }
}

void symbol_define(char* symbol, uint16_t address){
    uint16_t *temp;
    ENTRY e;

    // hdestroyした時にfreeされるらしいので一応mallocする
    temp = (uint16_t *)malloc(sizeof(uint16_t));
    *temp = address;

    e.key = symbol;
    e.data = temp;
    hsearch(e, ENTER);
}

static void init_predefined_symbols() {
    // hdestroyした時にfreeされるらしいのでstrdup(malloc)する
    symbol_define(strdup("SP"),     0x0);
    symbol_define(strdup("LCL"),    0x1);
    symbol_define(strdup("ARG"),    0x2);
    symbol_define(strdup("THIS"),   0x3);
    symbol_define(strdup("THAT"),   0x4);
    symbol_define(strdup("R0"),     0x0);
    symbol_define(strdup("R1"),     0x1);
    symbol_define(strdup("R2"),     0x2);
    symbol_define(strdup("R3"),     0x3);
    symbol_define(strdup("R4"),     0x4);
    symbol_define(strdup("R5"),     0x5);
    symbol_define(strdup("R6"),     0x6);
    symbol_define(strdup("R7"),     0x7);
    symbol_define(strdup("R8"),     0x8);
    symbol_define(strdup("R9"),     0x9);
    symbol_define(strdup("R10"),    0xa);
    symbol_define(strdup("R11"),    0xb);
    symbol_define(strdup("R12"),    0xc);
    symbol_define(strdup("R13"),    0xd);
    symbol_define(strdup("R14"),    0xe);
    symbol_define(strdup("R15"),    0xf);
    symbol_define(strdup("SCREEN"), 0x4000);
    symbol_define(strdup("KBD"),    0x6000);
}

void init_symtable() {
    hcreate(TABLESIZE);
    init_predefined_symbols();
}

void destroy_symtable() {
    hdestroy();
}
