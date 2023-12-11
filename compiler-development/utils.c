// Tabela de SImbolos

enum
{
    INT, 
    LOG,
    REG
};

//TODO: criar lista de campos?

// Defina uma estrutura para representar um campo de registro
struct CampoRegistro {
    char nome[100];  // Nome do campo
    int tipo;        // Tipo do campo (INT, LOG, REG)
    
    // Outros campos que você pode precisar, como tamanho, posição, etc.
    int pos;     // Posição do campo no registro (em bytes)
    int des;  // Deslocamento do campo no registro (em bytes)
    int tam;     // Tamanho do campo (em bytes)
};

// Defina uma estrutura para representar a lista de campos de um registro
struct ListaCampos {
    struct CampoRegistro campos[5];  // Por exemplo, assumindo no máximo 5 campos por registro
    int numCampos;  // Número atual de campos na lista

};




//TODO: criar função para percorrer a lista de campos


char nomeTipo[3][4] = {
    "INT", "LOG", "REG"
};

// criar uma estrutura e operações para manipular uma lista de campos

#define TAM_TAB 100


//acrescentar campos na tabela
struct  elemTabSimbolos 
{
    char id[100];   // nome do identificador   
    int end;        // endereco
    int tip;        // tipo
    int tam;        // tamanho
    int pos;       // posicao
    struct ListaCampos listaCampos;
} tabSimb[TAM_TAB], elemTab;

// struct elemTabSimbolos tabSimb[5]; // assumindo que MAX é o tamanho máximo
// struct elemTabSimbolos litabSimb[5]; // declare litabSimb

int posTab = 0;    // indica a próxima posição livre para inserção

int buscaSimbolo (char *s) 
{
    int i;
    for (i = posTab - 1; strcmp(tabSimb[i].id, s) && i >= 0; i--) 
            ;
    if (i == -1) 
    {
        char msg[200];
        sprintf(msg, "Identificador [%s] não ecnontrado!", s);
        yyerror(msg);
    }
    return i;
}

void insereSimbolo (struct elemTabSimbolos elem) 
{
    int i;          
    if (posTab == TAM_TAB)
        yyerror("Tabela de Simbolos cheia!");                                                    //
    for (i = posTab - 1; strcmp(tabSimb[i].id, elem.id) && i >= 0; i--) 
            ;
    if (i != -1) 
    {    // caso encontre um nome igual ao que deseja inserir já existente na tabela
    char msg[200];    // se o valor for igual a -1 a tabela foi totalmente percorrida e não foram encontradas elementos duplicados
    sprintf(msg, "Identificador [%s] duplicado!", elem.id);
    yyerror(msg);
    }
    char msg[200];    // s
    tabSimb[posTab++] = elem;         // insere o elemento na posição posTab++
}

void mostraTabela() 
{
    puts("------------------------------------Tabela de Simbolos------------------------------------");
    printf("%30s | %3s | %s | %s | %s | %s \n", "ID", "END", "TIP", "TAM", "POS", "CAMPOS");
    for(int i = 0; i < 90; i++)
        printf("-");
    for(int i = 0; i < posTab; i++)
        printf("\n%30s | %3d | %s | %d | %d | (%s, %d, %d, %d, %d)", 
                tabSimb[i].id,
                tabSimb[i].end,
                nomeTipo[tabSimb[i].tip],
                tabSimb[i].tam,
                tabSimb[i].pos,
                tabSimb[i].listaCampos.campos->nome, 
                tabSimb[i].listaCampos.campos->tipo, 
                tabSimb[i].listaCampos.campos->pos, 
                tabSimb[i].listaCampos.campos->des, 
                tabSimb[i].listaCampos.campos->tam);
    puts("");
}

// Pilha Semantica
#define TAM_PIL 100// criar uma estrutura e operações para manipular uma lista de campos
int pilha[TAM_PIL];
int topo = -1;      

void empilha (int valor) 
{
    if (topo == TAM_PIL)
        yyerror ("Pilha semantica cheia!");
    pilha[++topo] = valor;
}

int desempilha (void) 
{
    if (topo == -1)
        yyerror ("Pilha semantica vazia!");
    return pilha[topo--];      // se a pilha não for vazia retorna a nova posição da pilha após desempilhar
}

// tipo1 e tipo2 são os tipos esperados na expressão
// ret é o tipo que será empilhado com resultado da expressão
void testaTipo (int tipo1, int tipo2, int ret) {
    int t2 = desempilha();
    int t1 = desempilha();
    if (t1 != tipo1 || t2 != tipo2) 
        yyerror("Incompatibilidade de tipo!");
    empilha(ret);
}