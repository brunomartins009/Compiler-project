%{
    int nchar, nline, nword;
%}
%%
\n  {nline++; nchar++;}
[^\n\t]+  {nword++; nchar = nchar + yyleng;}
.    {nchar++;}         /* qualquer coisa diferente */
%%
int yywrap() { return 1;}
int main () {
    yylex();
    printf("c = %d w = %d l = %d\n", nchar, nword, nline);
    return 0;
}
