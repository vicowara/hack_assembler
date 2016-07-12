#ifndef NODE_H
#define NODE_H

#include <stdbool.h>
#include <stdint.h>

typedef struct node {
    bool is_symbol;
    bool is_label;
    union {
        char *symbol;
        uint16_t value;
    };
    struct node *next;
} node_t;

node_t* new_node(void);
node_t* node_init_with_num(uint16_t);
node_t* node_init_with_symbol(char *);
node_t* node_init_with_label(char *);

#endif // NODE_H
