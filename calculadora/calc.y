%{      
#include <stdio.h>           /*arquivo sintatico */
int yylex(void);             /*considera que essas funções já estão implementadas no .c compilado a partir do .l*/
void yyerror(char *);        /*para cada um dos returns definidos no .l se define um token correspondente no .y*/
%}

%token NUM
%token MAIS
%token MENOS
%token VEZES
%token DIV
%token ABRE
%token FECHA
%token ENTER

%start comando

%left MAIS MENOS        /*a expressao será resolvida da direita para esquerda*/
%left VEZES DIV

%%
/*$$*/
comando
    /* $1      $2   $3   */
    : comando expr ENTER { printf ("result = %d\n", $2); }                
    |                                                                    /*comando pode ser feito por comando e uma expressão seguida de ENTER, ou vazio*/
    ;

expr 
    : NUM               { $$ = $1; }                /*expr pode ser NUM*/
    | expr MAIS expr    { $$ = $1 + $3; }           /*ou expr + expr*/
    | expr MENOS expr   { $$ = $1 - $3; }
    | expr VEZES expr   { $$ = $1 * $3; }
    | expr DIV expr     { $$ = $1 / $3; }
    | ABRE expr FECHA   { $$ = $2; }          /*a expr $$ recebe o valor da expressão enter () que tem valor $2;*/
    ;

%%

void yyerror (char *s) {
    printf("%s \n", s);
}

int main (void) {
    yyparse();
    return 0;
}