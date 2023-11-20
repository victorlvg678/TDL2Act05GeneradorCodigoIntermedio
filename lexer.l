%{
#include "y.tab.h"
%}

%%

"="     { return ASSIGN; }
";"     { return SEMICOLON; }
"+"     { return PLUS; }
"-"     { return MINUS; }
"*"     { return MULTIPLY; }
"/"     { return DIVIDE; }
"++"    { return INC; }
"--"    { return DEC; }
"=="    { return EQUAL; }
"!="    { return NOTEQUAL; }
"<"     { return LESSTHAN; }
"<="    { return LESSEQ; }
">"     { return GREATERTHAN; }
">="    { return GREATEQ; }
"&&"    { return AND; }
"||"    { return OR; }
"!"     { return NOT; }
"<<"    { return SHL; }
">>"    { return SHR; }
"("     { return LPAREN; }
")"     { return RPAREN; }
"{"     { return LBRACE; }
"}"     { return RBRACE; }
"if"    { return IF; }
"else"  { return ELSE; }
"while" { return WHILE; }
"return" { return RETURN; }
"call"  { return CALL; }
"halt"  { return HALT; }
"nop"   { return NOP; }
"jmp"   { return JMP; }
[0-9]+  { yylval.ival = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.sval = strdup(yytext); return IDENTIFIER; }
[ \t\n] ; /* Evitar espacios en blanco */

%%

int yywrap() {
    return 1;
}
