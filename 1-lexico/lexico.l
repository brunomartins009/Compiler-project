identificador [a-zA-Z]([a-zA-Z0-9])*
numero        [0-9]+
espaco        [ \t]+
novalinha     [\n]

%%
programa            {printf("%11s: reservada\n", yytext);}
inicio              {printf("%11s: reservada\n", yytext);}
fimprograma         {printf("%11s: reservada\n", yytext);}
leia                {printf("%11s: reservada\n", yytext);}
escreva             {printf("%11s: reservada\n", yytext);}
se                  {printf("%11s: reservada\n", yytext);}
entao               {printf("%11s: reservada\n", yytext);}
senao               {printf("%11s: reservada\n", yytext);}
fimse               {printf("%11s: reservada\n", yytext);}
enquanto            {printf("%11s: reservada\n", yytext);}
faca                {printf("%11s: reservada\n", yytext);}
fimenquanto         {printf("%11s: reservada\n", yytext);}
"+"                 {printf("%11s: soma\n", yytext);}
"-"                 {printf("%11s: subtracao\n", yytext);}
"*"                 {printf("%11s: multiplicacao\n", yytext);}
div                 {printf("%11s: divisao\n", yytext);}
">"                 {printf("%11s: maior\n", yytext);}
"<"                 {printf("%11s: menor\n", yytext);}
"="                 {printf("%11s: igual\n", yytext);}
e                   {printf("%11s: e-logico\n", yytext);}
ou                  {printf("%11s: ou-logico\n", yytext);}
nao                 {printf("%11s: negacao\n", yytext);}
"<-"                {printf("%11s: atribuicao\n", yytext);}
"("                 {printf("%11s: abre\n", yytext);}
")"                 {printf("%11s: fecha\n", yytext);}
inteiro             {printf("%11s: tipo-inteiro\n", yytext);}
logico              {printf("%11s: tipo-logico\n", yytext);}
V                   {printf("%11s: constante-verdade\n", yytext);}
F                   {printf("%11s: constante-falso\n", yytext);}
{identificador}     {printf("%11s: identificador\n", yytext);}
{numero}            {printf("%11s: numero\n", yytext);}
{espaco}            /* nada */
{novalinha}         /* nada */
.                   {printf("%11s: ERRO LEXICO\n", yytext);}
%%
int yywrap () { return 1; }
int main() {
    yylex();
    return 0;
}