#include <stdio.h>
#include <search.h>
#include <stdint.h>

#include "symtable.h"
#include "node.h"
#include "analysis.h"
#include "parse.h"

extern int yylineno;

void yyerror (char const *s) {
    fprintf(stderr, "%d: %s\n", yylineno, s);
}

int main(int argc, char *argv[]){
    extern int yyparse(void);
    extern FILE *yyin;

    node_t *head;
    FILE *fp;
    
    if (argc < 2) {
        yyin = stdin;
    } else {
        fp = fopen(argv[1], "r");
        yyin = fp;
    }

    init_symtable();
    init_parser();

    yyparse();

    head = get_list();
    analysis_symbol(head);
    output_program(head);

    destruct_symtable();
    destruct_parser();
    
    return 0;
}
