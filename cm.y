/* 
 * 	CM Yacc/Bison specification file.
 */

%{
#define YYPARSER

#include "globals.h"
#include "util.h"
#include "scan.h"
#include "parse.h"

#define YYSTYPE TreeNode*
static char* savedName;
static int savedLineno;
static int savedType;
static int savedNum;
static TreeNode* savedTree;

int yyerror(char*);
static int yylex(void);

char* stack[100];
int stack_top = -1;
void stack_push (char* name) {
	if (stack_top >= 100)
		return;
	else
		stack[++stack_top] = name;
	return;
}

char* stack_pop (void) {
	if (stack_top < 0)
		return NULL;
	else
		return stack[stack_top--];
}

%}

%token ELSE IF INT RETURN VOID WHILE
%token PLUS MINUS TIMES OVER 
%token LT LE GT GE EQ NE ASSIGN
%token SEMI COMMA LPAREN RPAREN LSQUARE RSQUARE LCURLY RCURLY
%token ID NUM
%token ERROR_IN_COMMENT
%token ERROR

%%

program: declaration_list
			{ savedTree = $1; }
	   ;

declaration_list: declaration_list declaration 
					{
					  YYSTYPE t = $1;
					  if (t){
						for(; t->sibling != NULL; t = t->sibling)
							;
						t->sibling = $2;
						$$ = $1;
					  }
					  else
						  $$ = $2;
				  	}
				| declaration 
					{ $$ = $1;}
				;

declaration: var_declaration 
				{ $$ = $1;}
		   | fun_declaration
			    { $$ = $1;}		
		   ;

id: ID { savedName = copyString(tokenString); stack_push(savedName);} ;
num: NUM { savedNum = atoi(tokenString); } ;

var_declaration: type_specifier id SEMI 
				{
					$$ = newDeclNode(VarK);
					$$->attr.name = stack_pop();
					$$->len = -1;

					$$->child[0] = $1;
				}		
			   | type_specifier id LSQUARE num RSQUARE SEMI
			    {
					$$ = newDeclNode(VarK);
					$$->attr.name = stack_pop();
					$$->len = savedNum;

					$$->child[0] = $1;
				}
			   ;

type_specifier: INT 
				{ $$ = newTypeNode(IntK);}
			  | VOID
			  	{ $$ = newTypeNode(VoidK);}
			  ;

fun_declaration: type_specifier id 
				 LPAREN params RPAREN compound_stmt
				{
					$$ = newDeclNode(FunK);
					$$->attr.name = stack_pop();
					$$->child[0] = $1;
					$$->child[1] = $4;
					$$->child[2] = $6; 
				}
			   ;

params: param_list
		{ $$ = $1; }
      | VOID
	  	{ $$ = newTypeNode(VoidK); }
	  ;

param_list: param_list COMMA param
			{
				YYSTYPE t = $1;
				if (t) {
					for (; t->sibling; t = t->sibling)
						;
					t->sibling = $3;
					$$ = $1;
				}
				else
					$$ = $3;
			}
          | param
		  	{ $$ = $1; }
		  ;

param: type_specifier id
		{
			$$ = newExpNode(IdK);
			$$->attr.name = stack_pop();
			$$->child[0] = $1;
		}
     | type_specifier id LSQUARE RSQUARE
		{
			$$ = newExpNode(IdK);
			$$->attr.name = stack_pop();
			$$->child[0] = $1;
		}
	 ;

compound_stmt: LCURLY local_declarations statement_list RCURLY
				{
					$$ = newStmtNode(CompoundK);
					$$->child[0] = $2;
					$$->child[1] = $3;
				}
			 ;

local_declarations: local_declarations var_declaration
					{
						YYSTYPE t = $1;
						if (t) {
							for (; t->sibling; t = t->sibling)
								;
							t->sibling = $2;
							$$ = $1;
						}
						else
							$$ = $2;
					}
				  | { $$ = NULL; } 
				  ;

statement_list: statement_list statement
				{ $$ = NULL; }
			  | { $$ = NULL; }
			  ;

statement: expression_stmt
		 | compound_stmt
		 | selection_stmt
		 | iteration_stmt
		 | return_stmt
		 ;

expression_stmt: expression SEMI
			   | SEMI
			   ;

selection_stmt: IF LPAREN expression RPAREN statement
			  | IF LPAREN expression RPAREN ELSE statement
			  ;

iteration_stmt: WHILE LPAREN expression RPAREN statement
			  ;

return_stmt: RETURN SEMI 
		   | RETURN expression SEMI
		   ;

expression: var ASSIGN expression 
		  | simple_expression
		  ;

var: ID
   | ID LSQUARE expression RSQUARE
   ;

simple_expression: additive_expression relop additive_expression
				 | additive_expression
				 ;

relop: LE | LT | GT | GE | EQ | NE ;

additive_expression: additive_expression addop term 
				   | term
				   ;

addop: PLUS | MINUS ;

term: term mulop factor 
	| factor
	;

mulop: TIMES | OVER ;

factor: LPAREN expression RPAREN
	  | var
	  | call
	  | NUM
	  ;

call: ID LPAREN args RPAREN
	;

args: arg_list 
	|
	;

arg_list: arg_list COMMA expression 
		| expression
		;

%%

int yyerror(char* msg) {

	printf("error at line %d: %s\n", lineno, msg);
	return 0;
}

static int yylex(void) {

	TokenType t = getToken();
	return t;
}

TreeNode* parse(void) {

	yyparse();
	return savedTree;
}
