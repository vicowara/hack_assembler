#include <stdio.h>
#include <search.h>
#include <stdint.h>

#include "symtable.h"

extern int yylineno;

void yyerror (char const *s) {
    fprintf(stderr, "%d: %s\n", yylineno, s);
}

int main(int argc, char *argv[]){
    extern int yyparse(void);
    extern FILE *yyin;
    
    FILE *fp;
    
    if (argc < 2) {
        yyin = stdin;
    } else {
        fp = fopen(argv[1], "r");
        yyin = fp;
    }

    init_symtable();
    yyparse();
    destruct_symtable();
    
    return 0;
}
