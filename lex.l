%{
#include <stdio.h>
#include <stdint.h>
#include "node.h"
#include "y.tab.h"

uint16_t decode_jump(char*);
uint16_t decode_dest(char*);
%}

%%
"JGT"                  {yylval.value = decode_jump(yytext); return JUMP;}
"JEQ"                  {yylval.value = decode_jump(yytext); return JUMP;}
"JGE"                  {yylval.value = decode_jump(yytext); return JUMP;}
"JLT"                  {yylval.value = decode_jump(yytext); return JUMP;}
"JNE"                  {yylval.value = decode_jump(yytext); return JUMP;}
"JLE"                  {yylval.value = decode_jump(yytext); return JUMP;}
"JMP"                  {yylval.value = decode_jump(yytext); return JUMP;}

"D&A"                  {yylval.value = 0; return COMP;}
"D+A"                  {yylval.value = 2; return COMP;}
"A-D"                  {yylval.value = 7; return COMP;}
"D-A"                  {yylval.value = 19; return COMP;}
"D|A"                  {yylval.value = 21; return COMP;}

"D&M"                  {yylval.value = 64; return COMP;}
"D+M"                  {yylval.value = 66; return COMP;}
"M-D"                  {yylval.value = 71; return COMP;}
"D-M"                  {yylval.value = 83; return COMP;}
"D|M"                  {yylval.value = 85; return COMP;}

"!D"                   {yylval.value = 13; return COMP;}
"D-1"                  {yylval.value = 14; return COMP;}
"-D"                   {yylval.value = 15; return COMP;}
"D+1"                  {yylval.value = 31; return COMP;}
"D"                    {yylval.value = 12; return COMP;}

"!A"                   {yylval.value = 49; return COMP;}
"A-1"                  {yylval.value = 50; return COMP;}
"-A"                   {yylval.value = 51; return COMP;}
"A+1"                  {yylval.value = 55; return COMP;}
"A"                    {yylval.value = 48; return COMP;}

"!M"                   {yylval.value = 113; return COMP;}
"M-1"                  {yylval.value = 114; return COMP;}
"-M"                   {yylval.value = 115; return COMP;}
"M+1"                  {yylval.value = 119; return COMP;}
"M"                    {yylval.value = 112; return COMP;}

"@"                    {return AT;}
";"                    {return SEMIC;}
"("                    {return O_PAREN;}
")"                    {return C_PAREN;}

[AMD]{1,3}"="          {yylval.value = decode_dest(yytext); return DESTEQ;}
"-"?[0-9]+             {
                           if(yytext[0]!='-'){
                               yylval.value = (uint16_t)atoi(yytext);
                           } else {
                               /* unconditional set as -1 */
                               yylval.value = 0xffff;
                           }
                           return NUMBER;
                       }
[a-zA-Z_\.\$:][0-9a-zA-Z_\.\$:]* {yylval.symbol = strdup(yytext); return SYMBOL;}
"//".*\n|\r|\r\n       {return NL;}
[ \t]+                 /* ignore space */;
\n|\r|\r\n             {return NL;}
.                      {fprintf(stderr, "(line:%d) unknown charactor: %s(%d)\n", yylineno, yytext, yytext[0]);}
%%

uint16_t decode_jump(char* yytext) {
    if (!strncmp(yytext, "JGT", 3)) {
        return 1;
    } else if (!strncmp(yytext, "JEQ", 3)) {
        return 2;
    } else if (!strncmp(yytext, "JGE", 3)) {
        return 3;
    } else if (!strncmp(yytext, "JLT", 3)) {
        return 4;
    } else if (!strncmp(yytext, "JNE", 3)) {
        return 5;
    } else if (!strncmp(yytext, "JLE", 3)) {
        return 6;
    } else if (!strncmp(yytext, "JMP", 3)) {
        return 7;
    }
}

uint16_t decode_dest(char* yytext) {
    if (!strncmp(yytext, "AMD", 3)) {
        return 7;
    } else if (!strncmp(yytext, "AD", 2)) {
        return 6;
    } else if (!strncmp(yytext, "AM", 2)) {
        return 5;
    } else if (!strncmp(yytext, "A", 1)) {
        return 4;
    } else if (!strncmp(yytext, "MD", 2)) {
        return 3;
    } else if (!strncmp(yytext, "D", 1)) {
        return 2;
    } else if (!strncmp(yytext, "M", 1)) {
        return 1;
    }
}
