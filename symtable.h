#ifndef _SYMTABLE
#define _SYMTABLE

#define TABLESIZE 1024

#include <stdint.h>

void init_symtable();
void destroy_symtable();
void symbol_define(char*, uint16_t);
uint16_t symbol_resolv(char*);

#endif // _SYMTABLE
