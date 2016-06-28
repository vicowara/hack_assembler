#include <stdio.h>

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

    yyparse();
    
    return 0;
}
