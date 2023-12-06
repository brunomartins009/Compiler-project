%{
#include "calc.h"
#include <stdlib.h>
void yyerror (char *);
%}

%%              /*Nessa parte foram definidas os símbolos que podem ser encontrados na linguagem e qual o retorno para cada um deles*/
[0-9]+  { yylval = atoi(yytext);     /*quando ler um ou mais numeros*/
          return NUM;}   
"+"     return MAIS;                 /*quando ler um + retorna MAIS*/
"-"     return MENOS;
"*"     return VEZES;
"div"   return DIV;
"("     return ABRE;
")"     return FECHA;
\n      return ENTER;
[ \t]+  /* saltar espaços e tabulacoes*/
.       yyerror("caracter invalido");      /*para qualquer outro caracter encontrado não faz nada e retorna inválido*/
%%

int yywrap(void) {
    return 1;
}