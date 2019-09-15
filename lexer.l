%option noyywrap

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "symtab.h"
	#include "parser.tab.h"
	extern FILE *yyin;
	extern FILE *yyout;
	
	int lineno = 1; // initialize to 1
	void ret_print(char *token_type);
	void yyerror();
%}

alpha     [a-zA-Z]
digit     [0-9]
alnum     {alpha}|{digit}
print     [ -~]

CCONST    '{alpha}'

ID        {alpha}+{alnum}*
ICONST    "0"|[0-9]{digit}*
FCONST    "0"|{digit}*"."{digit}+

STRING    \"{print}*\"

%%

"//".*        { printf("Comment at line %d\n", lineno); } 

"Print" 			  { return PRINT; }
"char"|"CHAR"         { return CHAR; }
"int"|"INT"           { return INT; }
"float"|"FLOAT"       { return FLOAT; }
"double"|"DOUBLE"     { return DOUBLE; }
"if"|"IF"             { return IF; }
"else"|"ELSE"         { return ELSE; }
"while"|"WHILE"       { return WHILE; }
"for"|"FOR"           { return FOR; }
"do"|"DO"			  { return DO; }
"continue"|"CONTINUE" { return CONTINUE; }
"break"|"BREAK"       { return BREAK; }
"void"|"VOID"         { return VOID; }
"return"|"RETURN"     { return RETURN; }


"+"|"-"             { return ADDOP; }
"*"                 { return MULOP; }
"/"                 { return DIVOP; }
"++"|"--"           { return INCR; }
"||"                { return OROP; }
"&&"                { return ANDOP; }
"!"                 { return NOTOP; }
"=="	            { return EQUOP; }
"!="				{ return NEQUOP;}
"<"					{ return LT;}
">"					{ return GT;}
">="				{ return GTE;}
"<="   				{ return LTE; }


"("       { return LPAREN; }
")"       { return RPAREN; }
"]"       { return RBRACK; }
"["       { return LBRACK; }
"{"       { return LBRACE; }
"}"       { return RBRACE; }
";"       { return SEMI; }
"."       { return DOT; }
","       { return COMMA; }
"="       { return ASSIGN; }
"&"       { return REFER; }


{ID}    {
        yylval.id = (list_t*)malloc(sizeof(list_t));
        strcpy(yylval.id->st_name, yytext);
        //strcpy(yylval.idname, yytext);
        return ID;
        }
{ICONST}    { yylval.int_val   = atoi(yytext); return ICONST; }
{FCONST}    { yylval.double_val = atof(yytext); return FCONST; }
{CCONST}    { yylval.char_val  = yytext[1]; printf("%c\n", yytext[1]);  return CCONST; }
{STRING}    { yylval.str_val = malloc(yyleng * sizeof(char));
              strcpy(yylval.str_val, yytext);  return STRING; }


"\n"        { lineno += 1; }
[ \t\r\f]+  

.       { yyerror("Unrecognized character"); }

%%
