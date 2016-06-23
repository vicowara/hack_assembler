%{
#include <stdio.h>
#include <stdint.h>
#include "y.tab.h"

uint16_t decode_jump(char*);
uint16_t decode_dest(char*);
%}
%option yylineno
%%
"JGT"                  {yylval = decode_jump(yytext); return JUMP;}
"JEQ"                  {yylval = decode_jump(yytext); return JUMP;}
"JGE"                  {yylval = decode_jump(yytext); return JUMP;}
"JLT"                  {yylval = decode_jump(yytext); return JUMP;}
"JNE"                  {yylval = decode_jump(yytext); return JUMP;}
"JLE"                  {yylval = decode_jump(yytext); return JUMP;}
"JMP"                  {yylval = decode_jump(yytext); return JUMP;}

"D&A"                  {yylval = 0; return COMP;}
"D+A"                  {yylval = 2; return COMP;}
"A-D"                  {yylval = 7; return COMP;}
"D-A"                  {yylval = 19; return COMP;}
"D|A"                  {yylval = 21; return COMP;}

"D&M"                  {yylval = 64; return COMP;}
"D+M"                  {yylval = 66; return COMP;}
"M-D"                  {yylval = 71; return COMP;}
"D-M"                  {yylval = 83; return COMP;}
"D|M"                  {yylval = 85; return COMP;}

"!D"                   {yylval = 13; return COMP;}
"D-1"                  {yylval = 14; return COMP;}
"-D"                   {yylval = 15; return COMP;}
"D+1"                  {yylval = 31; return COMP;}
"D"                    {yylval = 12; return COMP;}

"!A"                   {yylval = 49; return COMP;}
"A-1"                  {yylval = 50; return COMP;}
"-A"                   {yylval = 51; return COMP;}
"A+1"                  {yylval = 55; return COMP;}
"A"                    {yylval = 48; return COMP;}

"!M"                   {yylval = 113; return COMP;}
"M-1"                  {yylval = 114; return COMP;}
"-M"                   {yylval = 115; return COMP;}
"M+1"                  {yylval = 119; return COMP;}
"M"                    {yylval = 112; return COMP;}

"@"                    {return AT;}
";"                    {return SEMIC;}
"("                    {return O_PAREN;}
")"                    {return C_PAREN;}

[AMD]{1,3}"="          {yylval = decode_dest(yytext); return DESTEQ;}
[0-9]+                 {sscanf(yytext, "%d", &yylval); return NUMBER;}
[a-zA-Z_\.\$:][0-9a-zA-Z_\.\$:]* {return SYMBOL;}
"//".*\n|\r|\r\n       {return NL;}
[ \t]+                 /* ignore space */;
\n|\r|\r\n             {return NL;}
.                      {fprintf(stderr, "unknown charactor: %s(%d)\n", yytext, yytext[0]);}
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
