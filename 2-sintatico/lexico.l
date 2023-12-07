%{
#include "sintatico.h"  //o sintatico.h faz a sincronização entre os tokens do sintatico e os termos do lexico
int yyerror(char *);    
int numLinha = 1;
%}

identificador [a-zA-Z]([a-zA-Z0-9])*
numero        [0-9]+
espaco        [ \t]+
novalinha     [\n]

%x coment     
%%
programa            return T_PROGRAMA;
inicio              return T_INICIO;
fimprograma         return T_FIM;
leia                return T_LEIA;
escreva             return T_ESCREVA;
se                  return T_SE;
entao               return T_ENTAO;
senao               return T_SENAO;
fimse               return T_FIMSE;
enquanto            return T_ENQTO;
faca                return T_FACA;
fimenquanto         return T_FIMENQTO;
"+"                 return T_MAIS;
"-"                 return T_MENOS;
"*"                 return T_VEZES;
div                 return T_DIV;
">"                 return T_MAIOR;
"<"                 return T_MENOR;
"="                 return T_IGUAL; 
e                   return T_E; 
ou                  return T_OU;
nao                 return T_NAO;
"<-"                return T_ATRIB;
"("                 return T_ABRE;
")"                 return T_FECHA; 
inteiro             return T_INTEIRO;
logico              return T_LOGICO;
V                   return T_V;
F                   return T_F;

"#".*               /* nada   */     
"//".*              /* nada */           /*qualquer sequência formada por // seguido de qualquer coisa vai ser descartada*/
"/*"                BEGIN(coment);      /*tratar comentários*/
<coment>"*/"        BEGIN(INITIAL);  /*se no estado >coment> e encontrar '* /' retornar ao estado inicial" */    
<coment>.            /* nada */
<coment>\n          numLinha++;

{identificador}     return T_IDENTIF;
{numero}            return T_NUMERO;
{espaco}            /* nada */
{novalinha}         numLinha++;
.                   yyerror ("lexico!");
%%
int yywrap () { return 1; }

int yyerror (char *s) {
    printf("ERRO na linha %d: %s\n", numLinha, s);
    exit(100);
}