#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "symtable.h"
#include "node.h"

static void putsbin(uint16_t n);

void analysis_symbol(node_t *head){
    uint16_t lineno;
    node_t *tmp;
    
    for (tmp = head, lineno = 0; tmp != NULL; tmp = tmp->next) {
        if (tmp->is_symbol){
            if (tmp->is_label) {
                symbol_define(tmp->symbol, lineno);
            } else {
                lineno++;
            }
        } else {
            lineno++;
        }
    }
}

void output_program(node_t *head){
    node_t *tmp;
    for (tmp = head; tmp != NULL; tmp = tmp->next) {
        if (tmp->is_symbol) {
            if (!tmp->is_label) {
                putsbin(symbol_resolv(tmp->symbol));
            }
        } else {
            putsbin(tmp->value);
        }
    }
}

static void putsbin(uint16_t n) {
    int i;

    for (i = 15; i >= 0; i--) {
        printf("%d", (n >> i) & 1 );
    }
    printf("\n");
}
