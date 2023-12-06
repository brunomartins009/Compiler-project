%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "lexico.c"
#include "utils.c"
int contaVar = 0;
int rotulo = 0;
int ehRegistro = 0;
int tipo;
%}

%token T_PROGRAMA
%token T_INICIO
%token T_FIM
%token T_IDENTIF
%token T_LEIA
%token T_ESCREVA
%token T_ENQTO
%token T_FACA
%token T_FIMENQTO
%token T_SE
%token T_ENTAO
%token T_SENAO
%token T_FIMSE
%token T_ATRIB
%token T_VEZES
%token T_DIV
%token T_MAIS
%token T_MENOS
%token T_MAIOR
%token T_MENOR
%token T_IGUAL
%token T_E
%token T_OU
%token T_V
%token T_F
%token T_NUMERO
%token T_NAO
%token T_ABRE
%token T_FECHA
%token T_LOGICO
%token T_INTEIRO
%token T_DEF 
%token T_FIMDEF
%token T_REGISTRO
%token T_IDPONTO

%start programa
/*VV precedência, o com maior precedência é T_VEZES e T_DIV*/
%left T_E T_OU
%left T_IGUAL 
%left T_MAIOR T_MENOR
%left T_MAIS T_MENOS
%left T_VEZES T_DIV

%%

programa
    : cabecalho definicoes variaveis 
        { 
            mostraTabela();
            empilha (contaVar);
            if (contaVar)
                fprintf(yyout, "\tAMEM\t%d\n", contaVar);
        }    
     T_INICIO lista_comandos T_FIM
        { 
            int conta = desempilha();
            if(conta)
                fprintf(yyout, "\tDMEM\t%d\n", contaVar); 
        }
        { fprintf(yyout, "\tFIMP\n"); }
    ;

cabecalho 
    : T_PROGRAMA T_IDENTIF
        { fprintf(yyout, "\tINPP\n"); }     // escreve no arquivo após ler o cabecalho
    ;

tipo
    : T_LOGICO 
        {
            tipo = LOG;
            // TODO #3
            // Além do tipo, precisa guardar o TAM (tamanho) do tipo 
            // e a POS (posição) do tipo na tab. símbolos
        }
    | T_INTEIRO
        { tipo = INT; }
    | T_REGISTRO T_IDENTIF
        {
            tipo = REG;
            // TODO #4
            // Aqui tem uma chamada de buscaSimbolo para encontrar as informações de TAM e POS do registro
        }
    ;

definicoes
    : define definicoes 
    | /*vazio*/
    ;


define 
    : T_DEF 
        {
            // TODO #0
            // Iniciar a lista de campos 
        }
    definicao_campos T_FIMDEF T_IDENTIF
        {
            // TODO #2
            // Inserir esse novo tipo na tabela de simbolos com a lista que foi montada
        }
    ;

definicao_campos 
    : tipo lista_campos definicao_campos
    | tipo lista_campos 
    ;

lista_campos 
    : lista_campos T_IDENTIF
        {
            // TODO #1
            // Acrescentar esse campo na lista de campos que esta sendo construida o deslocamento (endereço) do próximo campo a será
            // o deslocamento anterior mais o tamanho desse campo
        }
    | T_IDENTIF
        {
            // idem
        } ;


variaveis
    : /* vazio */
    | declaracao_variaveis
    ;

declaracao_variaveis
    : tipo lista_variaveis declaracao_variaveis
    | tipo lista_variaveis
    ;


lista_variaveis
    : lista_variaveis 
    T_IDENTIF 
    { 
        strcpy(elemTab.id, atomo);      // por id ser char?
        elemTab.end = contaVar;
        elemTab.tip = tipo;
        insereSimbolo (elemTab);
        contaVar++;
        // TODO #6
        // Tem outros campos pra acrescentar na tab. simbolos
    }
    T_IDENTIF
        { 
            strcpy(elemTab.id, atomo);      // por id ser char?
            elemTab.end = contaVar;
            elemTab.tip = tipo;
            insereSimbolo (elemTab);
            contaVar++;
            // TODO #5
            // Se a variavel for registro contaVar = contaVar + TAM (tamanho do registro)
        }
    ;

lista_comandos
    : /* vazio */
    | comando lista_comandos
    ;

comando 
    : entrada_saida
    | atribuicao
    | selecao
    | repeticao
    ;

entrada_saida   
    : entrada
    | saida
    ;

entrada
    : T_LEIA T_IDENTIF            //TODO: adiconar expressao de acesso
        { 
            int pos = buscaSimbolo (atomo);
            // TODO #7
            // Se for registro, tem que fazer uma repetição do TAM do registro de leituras
            fprintf(yyout, "\tLEIA\n"); 
            fprintf(yyout, "\tARZG\t%d\n", tabSimb[pos].end); 
        }
    ;

saida 
    : T_ESCREVA expressao
        {
            desempilha();
            //TODO #8
            // Se for registro, tem que fazer uma repetição do TAM do registro de escritas 
            fprintf(yyout, "\tESCR\n"); 
        }
    ;

atribuicao          
    : T_IDENTIF                 //TODO: lado esquerdo da expressão de acesso pode ser uma expressao de acesso
        {
            int pos = buscaSimbolo(atomo);
            empilha(pos);
            // Tem que guardar o TAM e a POS se for registro
        }
      T_ATRIB expressao
        {
            int tip = desempilha();
            int pos = desempilha();
            if (tabSimb[pos].tip != tip)
                yyerror("Incompatibilidade de tipo!"); 
            // TODO #9
            // Se for registro, tem que fazer uma repetição do TAM do registro em ARZG
            fprintf(yyout, "\tARZG\t%d\n", tabSimb[pos].end); 
        }
    ;

selecao
    : T_SE expressao T_ENTAO 
        {   
            int t = desempilha();
            if (t != LOG)
                yyerror ("Incompatibilidade de tipo!");
            fprintf(yyout, "\tDSVF\tL%d\n", ++rotulo); 
            empilha(rotulo);
        }
      lista_comandos T_SENAO 
        { 
            fprintf(yyout, "\tDSVS\tL%d\n", ++rotulo); 
            int rot = desempilha();
            fprintf(yyout, "L%d\tNADA\n", rot);
            empilha(rotulo); 
        }
      lista_comandos T_FIMSE
        { 
            int rot = desempilha();
            fprintf(yyout, "L%d\tNADA\n", rot); 
        }
    ;

repeticao
    : T_ENQTO 
        { 
            fprintf(yyout, "L%d\tNADA\n", ++rotulo); 
            empilha(rotulo);    
        }
      expressao T_FACA 
        { 
            int t = desempilha();
            if (t != LOG)
                yyerror ("Incompatibilidade de tipo!");
            fprintf(yyout, "\tDSVF\tL%d\n", ++rotulo);
            empilha(rotulo); 
        }
      lista_comandos T_FIMENQTO
      {
            int rot1 = desempilha();
            int rot2 = desempilha();
            fprintf(yyout, "\tDSVS\tL%d\n", rot2);
            fprintf(yyout, "L%d\tNADA\n", rot1);
      }
    ;

expressao 
    : expressao T_VEZES expressao
        { testaTipo(INT, INT, INT); fprintf(yyout, "\tMULT\n"); }
    | expressao T_DIV expressao
        { testaTipo(INT, INT, INT); fprintf(yyout, "\tDIVI\n"); }
    | expressao T_MAIS expressao
        { testaTipo(INT, INT ,INT); fprintf(yyout, "\tSOMA\n"); }
    | expressao T_MENOS expressao
        { testaTipo(INT, INT ,INT); fprintf(yyout, "\tSUBT\n"); }
    | expressao T_MAIOR expressao
        { testaTipo(INT, INT, LOG); fprintf(yyout, "\tCMMA\n"); }
    | expressao T_MENOR expressao
        { testaTipo(INT, INT, LOG); fprintf(yyout, "\tCMME\n"); }
    | expressao T_IGUAL expressao
        { testaTipo(INT, INT, LOG); fprintf(yyout, "\tCMIG\n"); }
    | expressao T_E expressao
        { testaTipo(LOG, LOG, LOG); fprintf(yyout, "\tCONJ\n"); }
    | expressao T_OU expressao
        { testaTipo(LOG, LOG, LOG); fprintf(yyout, "\tDISJ\n"); }
    | termo
    ;


expressao_acesso
    : T_IDPONTO 
        {   // --- Primeiro nome do registro
            if (!ehRegistro) {
                ehRegistro = 1;
                // TODO #10
                // 1. Buscar o símbolo na tabela de símbolos
                // 2. Se não for do tipo registro tem erro
                // 3. Guardar o TAM, POS e DES desse t_IDENTIF
            } else {
                // --- Campo que eh registro
                // TODO #11
                // 1. Busca esse campo na lista de campos
                // 2. Se não encontrar, erro
                // 3. Se encontrar e não for registro, erro
                // 4. Guardar o RAM, POS e DES desse CAMPO
            }
        }
        expressao_acesso
    | T_IDENTIF
        {
            if (ehRegistro) {
                // TODO #12
                // 1. Buscar esse campo na lista de campos
                // 2. Se não encontrar, erro
                // 3. Guardar o TAM, DES e TIP desse campo (o tipo (TIP) nesse caso é a posição do tipo na tabela de simbolos)
            }   
            else {
                int pos = buscaSimbolo(atomo);
                // TODO #13
                // Guardar TAM, DES e TIP dessa variável
            }
            ehRegistro = 0;
        } ;


termo
    : expressao_acesso
        {
            // TODO #14
            // Se for registro, tem que fazer uma repetição do TAM do registro em CRZG (em ordem inversa)
            fprintf(yyout, "\tCRVG\t%d\n", tabSimb[pos].end);
            empilha(tipo);
        }
    | T_NUMERO
        { 
            fprintf(yyout, "\tCRCT\t%s\n", atomo); 
            empilha(INT);
        }
    | T_V
        { 
            fprintf(yyout, "\tCRCT\t1\n"); 
            empilha(LOG);
        }
    | T_F
        { 
            fprintf(yyout, "\tCRCT\t0\n"); 
            empilha(LOG);
        }
    | T_NAO termo
        {
            int t = desempilha();
            if (t != LOG)
                yyerror ("Incompatibilidade de tipo!"); 
            fprintf(yyout, "\tNEGA\n"); 
            empilha(LOG);
        }
    | T_ABRE expressao T_FECHA
    ;
%%

int main(int argc, char *argv[]) {
    char *p, nameIn[100], nameOut[100];
    argv++;          //pular para o próximo nome,    o primeiro nome é o nome do executável, por isso o salto
    if (argc < 2) {        //caso o único argumento seja o nome do executável então explicar como executar ele
        puts("\nCompilador da linguagem SIMPLES");
        puts("\n\tUSO: ./simples <NOME>[.simples]\n\n");
        exit(1);
    }
    p = strstr(argv[0], ".simples");        //caso haja a extensão .simples vamos apagar a extensão
    if (p) *p = 0;
    strcpy(nameIn, argv[0]);            //coloca a extensão, assim tratamos o caso quando não houve passagem da extensão
    strcat(nameIn, ".simples");         
    strcpy(nameOut, argv[0]);           // gera um novo arquivo com o mesmo nome mas com a extensão .mvs como arquivo de saída
    strcat(nameOut, ".mvs");
    yyin = fopen(nameIn, "rt");
    if (!yyin) {                                // caso o arquivo não abra
        puts ("Programa fonte não encontrado!");
        exit(2);
    }
    yyout = fopen(nameOut, "wt");
    yyparse();
    printf("programa ok!\n");
    return 0;
}