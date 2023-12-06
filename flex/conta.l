digito [0-9]
letra [A-Za-z]
%{
    int conta = 0;
%}

%%
{letra}({letra}|{digito})*  { conta++; puts(yytext); }
.                          /* nada */
\n                         /* nada */

%%
int yywrap() { return 1; }
int main () {
    yylex();
    printf("Conta = %d\n", conta);
    return 0;
}