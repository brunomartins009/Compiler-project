#include <stdlib.h>

typedef struct no *ptno;

struct no {
    char tipo;
    int valor;
    ptno filho, irmao;
};

ptno criaNo(char tipo, int valor) {
    ptno n = (ptno)malloc(sizeof(struct no));
    n->tipo = tipo;
    n->valor = valor;
    n->filho = n->irmao = NULL;
    return n;
}

void adFilho(ptno pai, ptno filho) {
    filho->irmao = pai->filho;
    pai->filho = filho;
}

void mostra (ptno r, int nivel) {
    ptno p;
    for (int i = 0; i < nivel; i++)
        printf("\t");
    if (r->tipo == 'v')
        printf("[%c,%c]\n", r->tipo, r->valor + 'a');
    else 
        printf("[%c,%d]\n", r->tipo, r->valor);
    p = r->filho;
    while (p) {
        mostra(p, nivel + 1);
        p = p->irmao;
    }
}