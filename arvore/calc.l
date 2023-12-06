%{
#include <stdlib.h>
#include "tree.c"
#define YYSTYPE ptno
#include "calc.h"
void yyerror (char *);
%}

%%              /*Nessa parte foram definidas os símbolos que podem ser encontrados na linguagem e qual o retorno para cada um deles*/
[0-9]+  { yylval = criaNo ('n', atoi(yytext));  return NUM;}  /*quando ler um ou mais numeros*/
[a-z]+  { yylval = criaNo ('v', *yytext-'a');   return VAR;}
"="     return ATRIB;
"+"     return MAIS;                 /*quando ler um + retorna MAIS*/
"-"     return MENOS;
"*"     return VEZES;
"/"   return DIV;
"("     return ABRE;
")"     return FECHA;
\n      return ENTER;
[ \t]+  /* saltar espaços e tabulacoes*/
.       yyerror("caracter invalido");      /*para qualquer outro caracter encontrado não faz nada e retorna inválido*/
%%

int yywrap(void) {
    return 1;
}