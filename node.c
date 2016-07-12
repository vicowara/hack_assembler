#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "node.h"

node_t* new_node() {
    node_t *node;
    if ((node = (node_t *)malloc(sizeof(node_t))) == NULL) {
        perror("malloc failed");
        exit(1);
    }
    memset(node, 0, sizeof(node_t));

    node->is_symbol = false;
    node->is_label = false;

    return node;
}

node_t* node_init_with_num(uint16_t num){
    node_t *node;
    // allocate
    node = new_node();

    // 0x7fff == 0b0111111111111111
    num &= 0x7fff;
    node->value |= num;

    node->is_symbol = false;
    node->is_label = false;

    return node;
}

node_t* node_init_with_symbol(char *symbol){
    node_t *node;
    // allocate
    node = new_node();

    node->symbol = symbol;
    node->is_symbol = true;
    node->is_label = false;

    return node;
}

node_t* node_init_with_label(char *symbol){
    node_t *node;
    // allocate
    node = new_node();

    node->symbol = symbol;
    node->is_symbol = true;
    node->is_label = true;

    return node;
}
