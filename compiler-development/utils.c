// Tabela de SImbolos
#include <stdio.h>
#include <stdlib.h>

enum {
    INT,
    LOG,
    REG
};

char nomeTipo[3][4] = {
    "INT", "LOG", "REG"
};

// criar uma estrutura e operações para manipular uma lista de campos

#define TAM_TAB 100

// TODO #1 - FEITO
// Criar lista de campos
typedef struct listaCampos *ptregistro;

struct listaCampos {
    char nome[100];
    int tipo;
    int pos;
    int desl;
    int tam;
    ptregistro prox;
} listaCampos;

// TODO #2 -
// Adaptar "insere" do lista.c, feito em aula
ptregistro insere(ptregistro L, char nome[100], int tipo, int pos, int desl, int tam) {
    ptregistro p, new;
    new = (ptregistro)malloc(sizeof(struct listaCampos));
    strcpy(new->nome, nome);
    new->tipo = tipo;
    new->pos = pos;
    new->desl = desl;
    new->tam = tam;
    new->prox = NULL;
    p = L;
    while (p && p->prox) {
        p = p->prox;
    }
    if (p) {
        p->prox = new;
    } else {
        L = new;
    }

    return L;
}

// TODO #3 -
// Adaptar "busca" do lista.c, feito em aula
ptregistro busca(ptregistro L, char *nome) {
    while (L && L->nome != nome) {
        L = L->prox;
    }
    return L;
}

// TODO #4 -
// Adaptar "mostra" do lista.c, feito em aula
void mostra(ptregistro L) {
    while (L) {
        if (L->prox) {
            printf("(%s, %s, %d, %d, %d)=>", L->nome, nomeTipo[L->tipo], L->pos, L->desl, L->tam);
        } else {
            printf("(%s, %s, %d, %d, %d)", L->nome, nomeTipo[L->tipo], L->pos, L->desl, L->tam);
        }
        L = L->prox;
    }
}

// TODO #5 - FEITO
// Acrescentar campos na tabela
struct elemTabSimbolos {
    char id[100];      // nome do identificador
    int end;           // endereco
    int tip;           // tipo
    int tam;           // tamanho
    int pos;           // posição
    ptregistro listaCampos; // campos
} tabSimb[TAM_TAB], elemTab;

int posTab = 0; // indica a próxima posição livre para inserção

int buscaSimbolo(char *s) {
    int i;
    for (i = posTab - 1; strcmp(tabSimb[i].id, s) && i >= 0; i--){
        ;
    }
    if (i == -1) {
        char msg[200];
        sprintf(msg, "Identificador [%s] não encontrado!", s);
        yyerror(msg);
    }
    return i;
}

void insereSimbolo(struct elemTabSimbolos elem) {
    int i;
    if (posTab == TAM_TAB){
        yyerror("Tabela de Simbolos cheia!");
    }
    for (i = posTab - 1; strcmp(tabSimb[i].id, elem.id) && i >= 0; i--){
        ;
    }
    if (i != -1) { // caso encontre um nome igual ao que deseja inserir já existente na tabela
        char msg[200]; // se o valor for igual a -1 a tabela foi totalmente percorrida e não foram encontradas elementos duplicados
        sprintf(msg, "Identificador [%s] duplicado!", elem.id);
        yyerror(msg);
    }
    tabSimb[posTab++] = elem; // insere o elemento na posição posTab++
}

// TODO #6 - FEITO
// Ajustrar "mostraTabela" para mostrar "TAM", "POS" e "CAMPOS"
void mostraTabela() {
    puts("----------------------------------- Tabela de Simbolos -----------------------------------");
    puts("");
    printf("%30s | %3s | %s | %s | %s | %s \n", "ID", "END", "TIP", "TAM", "POS", "CAMPOS");
    for (int i = 0; i < 90; i++){
        printf("-");
    }
    for (int i = 0; i < posTab; i++) {
        printf("\n%30s | %3d | %s |  %d  |  %d  | ",
               tabSimb[i].id,
               tabSimb[i].end,
               nomeTipo[tabSimb[i].tip],
               tabSimb[i].tam,
               tabSimb[i].pos);
        mostra(tabSimb[i].listaCampos);
    }
    puts("");
}

// Pilha Semantica
#define TAM_PIL 100
int pilha[TAM_PIL];
int topo = -1;

void empilha(int valor) {
    if (topo == TAM_PIL){
        yyerror("Pilha semantica cheia!");
    }
    pilha[++topo] = valor;
}

int desempilha(void) {
    if (topo == -1){
        yyerror("Pilha semantica vazia!");
    }
    return pilha[topo--]; // se a pilha não for vazia retorna a nova posição da pilha após desempilhar
}

// tipo1 e tipo2 são os tipos esperados na expressão
// ret é o tipo que será empilhado com resultado da expressão
void testaTipo(int tipo1, int tipo2, int ret) {
    int t2 = desempilha();
    int t1 = desempilha();
    if (t1 != tipo1 || t2 != tipo2){
        yyerror("Incompatibilidade de tipo!");
    }
    empilha(ret);
}
