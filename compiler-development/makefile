#+--------------------------------------------------------
#           UNIFAL - Universidade Federal de Alfenas.
#              BACHARELADO EM CIECIA DE COMPUTACAO.
#   Trabalho..: Registro e verificacao de tipos
#   Disciplina: Teoria de Linguagens e Compiladores
#   Professor..: Luiz Eduardo da Silva
#   Aluno......: Bruno Martins Cordeiro
#   Data.......: 15/12/2023
# +--------------------------------------------------------*/

simples: utils.c lexico.l sintatico.y;
	flex -o lexico.c lexico.l;\
	bison -v -d sintatico.y -o sintatico.c;\
	gcc sintatico.c -o simples;

limpa: ;
	rm lexico.c sintatico.c sintatico.h sintatico.output simples
