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
static TreeNode* savedTree;

int yyerror(char*);
static int yylex();
%}

%token ERROR
%token ELSE IF INT RETURN VOID WHILE
%token ID NUM
%token PLUS MINUS TIMES OVER 
%token LT LE GT GE EQ NE
%token ASSIGN SEMI COMMA LPAREN RPAREN LSQUARE RSQUARE LCURLY RCURLY
%token ERROR_IN_COMMENT

%%

/* 1 */
program: declaration_list
	   ;

/* 2 */
declaration_list: declaration_list declaration 
				| declaration
				;

/* 3 */
declaration: var_declaration
		   | fun_declaration
		   ;

/* 4 */
var_declaration: type_specifier ID SEMI
			   | type_specifier ID LSQUARE NUM RSQUARE SEMI
			   ;

/* 5 */
type_specifier: INT
			  | VOID
			  ;
/* 6 */
fun_declaration: type_specifier ID LPAREN params RPAREN compound_stmt
			   ;

/* 7 */
params: param_list 
      | VOID
	  ;

/* 8 */
param_list: param_list COMMA param 
          | param
		  ;

/* 9 */
param: type_specifier ID
     | type_specifier ID LSQUARE RSQUARE
	 ;

/* 10 */
compound_stmt: LCURLY local_declarations statement_list RCURLY
			 ;

/* 11 */
local_declarations: local_declarations var_declaration
				  | 
				  ;

/* 12 */
statement_list: statement_list statement
			  |
			  ;

/* 13 */
statement: expression_stmt
		 | compound_stmt
		 | selection_stmt
		 | iteration_stmt
		 | return_stmt
		 ;

/* 14 */
expression_stmt: expression SEMI
			   | SEMI
			   ;

/* 15 */
selection_stmt: IF LPAREN expression RPAREN statement
			  | IF LPAREN expression RPAREN ELSE statement
			  ;

/* 16 */
iteration_stmt: WHILE LPAREN expression RPAREN statement
			  ;

/* 17 */
return_stmt: RETURN SEMI 
		   | RETURN expression SEMI
		   ;

/* 18 */
expression: var ASSIGN expression 
		  | simple_expression
		  ;

/* 19 */
var: ID
   | ID LSQUARE expression RSQUARE
   ;

/* 20 */
simple_expression: additive_expression relop additive_expression
				 | additive_expression
				 ;

/* 21 */
relop: LE | LT | GT | GE | EQ | NE ;

/* 22 */
additive_expression: additive_expression addop term 
				   | term
				   ;

/* 23 */
addop: PLUS | MINUS ;

/* 24 */
term: term mulop factor 
	| factor
	;

/* 25 */
mulop: TIMES | OVER ;

/* 26 */
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

	return 0;
}

static int yylex(void) {

	return getToken();
}

TreeNode* parse(void) {

	yyparse();
	return savedTree;
}
