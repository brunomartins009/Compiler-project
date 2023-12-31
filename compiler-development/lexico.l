/*+--------------------------------------------------------
            UNIFAL - Universidade Federal de Alfenas.
               BACHARELADO EM CIECIA DE COMPUTACAO.
    Trabalho..: Registro e verificacao de tipos
    Disciplina: Teoria de Linguagens e Compiladores
    Professor..: Luiz Eduardo da Silva
    Aluno......: Bruno Martins Cordeiro
    Data.......: 15/12/2023
  +---------------------------------------------------------*/

%{
#include "sintatico.h"  //o sintatico.h faz a sincronização entre os tokens do sintatico e os termos do lexico
int yyerror(char *);    
int numLinha = 1;
char atomo[100];    
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
def                 return T_DEF;
fimdef              return T_FIMDEF;
registro            return T_REGISTRO;



"#".*               /* nada   */     
"//".*              /* nada */           /*qualquer sequência formada por // seguido de qualquer coisa vai ser descartada*/
"/*"                BEGIN(coment);      /*tratar comentários*/
<coment>"*/"        BEGIN(INITIAL);  /*se no estado >coment> e encontrar '* /' retornar ao estado inicial" */    
<coment>.            /* nada */
<coment>\n          numLinha++;

{identificador}     { strcpy (atomo, yytext); return T_IDENTIF; }   /* retorna o nome do identificador */
{identificador}"."  { 
                        strcpy (atomo, yytext);
                        atomo[strlen(atomo)-1] = 0;    //pega o tamanho do atomo e na posição, tam-1 que é o ponto, e o sobescreve como 0 apagando da string 
                        return T_IDPONTO;   
                    }
{numero}            { strcpy (atomo, yytext); return T_NUMERO; }    /* guarda na variável atomo o identificador*/
{espaco}            /* nada */
{novalinha}         numLinha++;
.                   yyerror ("lexico!");
%%
int yywrap () { return 1; }

int yyerror (char *s) {
    printf("ERRO na linha %d: %s\n", numLinha, s);
    exit(100);
}
