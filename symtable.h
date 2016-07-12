#ifndef SYMTABLE_H
#define SYMTABLE_H

#define TABLESIZE 1024

#include <stdint.h>

void init_symtable();
void destruct_symtable();
void symbol_define(char*, uint16_t);
uint16_t symbol_resolv(char*);

#endif // SYMTABLE_H
