%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *);
int yylex();
extern FILE* yyin;
%}

%union
{
	char* sval;
	int ival;
}

%token <sval> IDENTIFIER
%token <ival> NUMBER
%token ASSIGN SEMICOLON PLUS MINUS MULTIPLY DIVIDE INC DEC EQUAL NOTEQUAL LESSTHAN LESSEQ GREATERTHAN GREATEQ AND OR NOT SHL SHR LPAREN RPAREN LBRACE RBRACE IF ELSE WHILE RETURN CALL HALT NOP JMP
%type <sval> assignment
%type <ival> expression
%type <sval> control_flow
%type <sval> statements
%%

program : statements
        ;

statements : statements statement
	   | /* VACIO */
           ;

statement : assignment
          | expression SEMICOLON
          | control_flow
          | function_call SEMICOLON
          | HALT SEMICOLON { printf("programa detenido!"); }
          | NOP SEMICOLON { printf("NOP\n"); }
          | JMP expression SEMICOLON { printf("JMP %s\n", $2); }
          ;

assignment : IDENTIFIER ASSIGN expression SEMICOLON { printf("MOV %s, %i\n", $1, $3); }
           | IDENTIFIER INC SEMICOLON    { printf("INC %s\n", $1); }
           | IDENTIFIER DEC SEMICOLON    { printf("DEC %s\n", $1); }
           ;

expression : IDENTIFIER             { $$ = $1; }
           | NUMBER                 { $$ = $1; }
           | expression PLUS expression  { $$ = $1 + $3; }
           | expression MINUS expression { $$ = $1 - $3; }
           | expression MULTIPLY expression { $$ = $1 * $3; }
           | expression DIVIDE expression { $$ = $1 / $3; }
           | LPAREN expression RPAREN { $$ = $2; }
           | expression EQUAL expression { $$ = ($1 == $3) ? 1 : 0; }
           | expression NOTEQUAL expression { $$ = ($1 != $3) ? 1 : 0; }
           | expression LESSTHAN expression { $$ = ($1 < $3) ? 1 : 0; }
           | expression LESSEQ expression { $$ = ($1 <= $3) ? 1 : 0; }
           | expression GREATERTHAN expression { $$ = ($1 > $3) ? 1 : 0; }
           | expression GREATEQ expression { $$ = ($1 >= $3) ? 1 : 0; }
           | expression AND expression { $$ = ($1 && $3) ? 1 : 0; }
           | expression OR expression { $$ = ($1 || $3) ? 1 : 0; }
           | expression SHL expression { $$ = $1 << $3; }
           | expression SHR expression { $$ = $1 >> $3; }
           | NOT expression { $$ = !$2; }
           ;

control_flow : IF LPAREN expression RPAREN LBRACE statements RBRACE  { printf("IF %s {\n%s}\n", $3 ? "true" : "false", $6); }
             | IF LPAREN expression RPAREN LBRACE statements RBRACE ELSE LBRACE statements RBRACE { printf("IF %s {\n%s}\nELSE {\n%s}\n", $3 ? "true" : "false", $6, $10); }
             | WHILE LPAREN expression RPAREN LBRACE statements RBRACE { printf("WHILE %s {\n%s}\n", $3 ? "true" : "false", $6); }
             | RETURN expression SEMICOLON { printf("RETURN %s\n", $2); }
             ;

function_call : CALL IDENTIFIER LPAREN expression RPAREN { printf("CALL %s(%d)\n", $2, $4); }
              ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error al hacer parsing: %s\n", s);
    exit(1);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Uso: %s <archivo_entrada>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        printf("Error al abrir archivo.\n");
        return 1;
    }

    yyin = file;

    yyparse();

    fclose(file);

    return 0;
}
