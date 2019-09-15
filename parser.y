%{
	#include "symtab.c"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
    #include "CodeGen.h"
	extern FILE *yyin;
	extern FILE *yyout;
	extern int lineno;
	extern int yylex();
	void yyerror();
%}

/* YYSTYPE union */
%union{
    char char_val;
	int int_val;
	double double_val;
	char* str_val;
	list_t* id;
 
}

%token<int_val> CHAR INT FLOAT DOUBLE IF ELSE WHILE FOR CONTINUE BREAK VOID RETURN PRINT
%token<int_val> ADDOP MULOP DIVOP INCR OROP ANDOP NOTOP EQUOP NEQUOP LT GT GTE LTE
%token<int_val> LPAREN RPAREN LBRACK RBRACK LBRACE RBRACE SEMI DOT COMMA ASSIGN REFER APOSTOPH
%token <id> ID
%token <int_val> 	 ICONST
%token <double_val>  FCONST
%token <char_val> 	 CCONST
%token <str_val>     STRING

%left LPAREN RPAREN LBRACK RBRACK
%right NOTOP INCR REFER
%left MULOP DIVOP
%left ADDOP
%left LT GT LTE GTE
%left EQUOP NEQUOP
%left OROP
%left ANDOP
%right ASSIGN
%left COMMA

%type <int_val> constant names type expression declaration

%start program

%%

program: {gen_code(START,-1);} statements {gen_code(HALT,-1);};

statements: statements statement | ;

statement: ID ASSIGN expression tail 
    {
        list_t* l=search($1->st_name);
        //printf("%s %d\n",$1->st_name, $1->st_type);
        if(l == NULL)
        {
            printf("Not Defined\n");
        }
        else if(l->st_type==$3){
            printf("Valid assignment\n");
            address = search($1->st_name)->address;
            if(address!=-1){
				  gen_code(STORE, address);
            }
              else {
			  	exit(1);
              }
        }
        else{
            printf("Wrong assignment,type missmatch\n");
        }
        
        
    }
	| ID INCR tail
	{  
		list_t* l = search($1->st_name);

		printf("%s\n", $1->st_name);


		if(l==NULL)
		{
	          printf("Was not declared before increment\n");
		}
        else{
            gen_code(LD_VAR,l->address);
            gen_code(LD_INT,1);
            gen_code(ADD,-1);
            gen_code(STORE,l->address);
        }

	}
    | INCR ID SEMI;
    | declarations
    | if_statement
    | for_statement
    | while_statement
    | print_statement
;
tail: SEMI | ;
print_statement : PRINT LPAREN ID RPAREN SEMI
{
    ;

    //printf("PRINT\n\nNAME: %s Address: %d\n\n", search($3->st_name)->st_name, search($3->st_name)->address);
    gen_code(WRITE_INT,search($3->st_name)->address);
};
if_statement: IF LPAREN expression RPAREN {gen_code(JMP_FALSE,3);} LBRACE statements RBRACE  {gen_code(GOTO,4);}optional_else;

optional_else: 
               ELSE {gen_code(LABEL,3);} LBRACE statements RBRACE {gen_code(LABEL,4);} 
                |
                ELSE IF LPAREN expression RPAREN LBRACE statements RBRACE optional_else
                |
                ;
 
for_statement: FOR LPAREN statement {gen_code(LABEL,5);}expression SEMI{ gen_code(JMP_FALSE,6); } statement RPAREN LBRACE statements {gen_code(GOTO,5);} RBRACE {gen_code(LABEL,6);};

while_statement: WHILE {gen_code(LABEL,1);} LPAREN expression RPAREN {gen_code(JMP_FALSE,2);} LBRACE statements {gen_code(GOTO,1);}RBRACE {gen_code(LABEL,2);} 


declarations: declarations declaration | ;

declaration: INT ID SEMI
			  {
                  //$2 = (list_t*)malloc(sizeof(list_t));
                list_t* l=search($2->st_name);
                if(l==NULL)
                {
                    insert($2->st_name, strlen($2->st_name), INT_TYPE);
                }
                else
                {
                    printf("%s is already declared.Try with different names.\n",l->st_name);
                }
				  
			  }
			  | INT ID ASSIGN ICONST SEMI
			  {
                list_t* l=search($2->st_name);
                if(l==NULL)
                {
                  insert($2->st_name, strlen($2->st_name), INT_TYPE);
                  gen_code(LD_INT_VALUE, $4);
                  //list_t* l = search($2->st_name);
                  //printf("NNN: %d\n",address);
                  $2->address = address-1;
                  gen_code(STORE, address-1);
                }
                else
                {
                    printf("%s is already declared.Try with different names.\n",l->st_name);
                }
                  //$2 = (list_t*)malloc(sizeof(list_t));
				  
			  }
                |FLOAT ID SEMI
               {
                //$2 = (list_t*)malloc(sizeof(list_t));
 
                
                insert($2->st_name, strlen($2->st_name), REAL_TYPE );
               }
            | FLOAT ID ASSIGN FCONST SEMI
			  {
                  //$2 = (list_t*)malloc(sizeof(list_t));
				  insert($2->st_name, strlen($2->st_name), INT_TYPE);
			  }
                | INT ID ASSIGN FCONST SEMI
			  {
                  printf("Type mismatch\n");
			  }
              |
                CHAR ID ASSIGN CCONST SEMI
                {
                    insert($2->st_name, strlen($2->st_name), CHAR_TYPE);
                }
                 | INT ID ASSIGN expression SEMI
			  {
                  if($4 == VOID)
                  {
                    printf("Can't assign\n");
                   }
                    else
                    {
                        insert($2->st_name, strlen($2->st_name), INT_TYPE);
                    }
				  
			  }

			;

type: INT {$$=INT_TYPE;} | CHAR {$$=CHAR_TYPE;} | FLOAT {$$=REAL_TYPE;} | DOUBLE {$$=REAL_TYPE;} | VOID ;

names: ASSIGN expression 
{
	$$ = $2;
};

constant: ICONST {$$=INT_TYPE; gen_code(LD_INT,$1);} | FCONST {$$=REAL_TYPE;} | CCONST {$$=CHAR_TYPE;} ;

expression:
    expression ADDOP expression {
         if($1 == $3 && $1!=VOID && $3!=VOID) 
         { 
             $$ = $1;
             //printf("Type %d\n",$1);
             gen_code(ADD,-1);
         } 
         else 
         {
              printf("Type Mismatch\n"); $$ = VOID; 
         } 
         
         } |
    expression MULOP expression {
        if($1 == $3 && $1!=VOID && $3!=VOID) 
         { 
             $$ = $1;
             gen_code(MUL,-1);
         } 
         else 
         {
              printf("Type Mismatch\n"); $$ = VOID; 
         } 
    }
    |expression DIVOP expression 
        {
        if($1 == $3 && $1!=VOID && $3!=VOID) 
         { 
             $$ = $1;
             gen_code(DIV,-1);
         } 
         else 
         {
              printf("Type Mismatch\n"); $$ = VOID; 
         } 
    }
    |
    ID INCR {
        list_t* l = search($1->st_name);

		printf("%s\n", $1->st_name);


		if(l==NULL)
		{
	          printf("Was not declared before increment\n");
		}
        else{
            gen_code(LD_VAR,l->address);
            gen_code(LD_INT,1);
            gen_code(ADD,-1);
            gen_code(STORE,l->address);
        }
    }|
    INCR ID |
    expression OROP expression |
    expression ANDOP expression |
    NOTOP expression |
    expression EQUOP expression 
    {
         gen_code(EQN, -1);
    }
     |
     expression LT expression 
     {
         gen_code(LTN, -1);
     }
    | expression GT expression
    | expression LTE expression
    | expression GTE expression    
    | LPAREN expression RPAREN |
    sign constant { $$=$2;} |
	ID 
    {
        list_t* l=search($1->st_name);
        if(l == NULL)
        {
            printf("Not Declared--\n");
            $$ = VOID;
        }
        else
        {
            gen_code(LD_VAR,search($1->st_name)->address);
            $$=l->st_type;
        }

        


    }
;

sign: ADDOP | /* empty */ ;


%%

void yyerror ()
{
  fprintf(stderr, "Syntax error at line %d\n", lineno);
  exit(1);
}

int main (int argc, char *argv[])
{
	int flag;
	flag = yyparse();
	
	printf("Parsing finished!\n\n");
    symtab_data();
	
    print_code();
    print_assembly();
	// symbol table data
	// yyout = fopen("symtab_data.out", "w");
	// symtab_data(yyout);
	// fclose(yyout);
	
	return flag;
}
