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
%}

%token ENDFILE ERROR
%token ELSE IF INT RETURN VOID WHILE
%token ID NUM
%token PLUS MINUS TIMES OVER 
%token LT LE GT GE EQ NE
%token ASSIGN SEMI COMMA LPAREN RPAREN LSQUARE RSQUARE LCURLY RCURLy
%token ERROR_IN_COMMENT

%%
program: declaration_list
	   ;

declaration_list: declaration_list declaration 
				| declaration
				;

declaration: var_declaration
		   | fun_declaration
		   ;

var_declaration: type_specifier ID SEMI
			   | type_specifier ID LSQUARE NUM RSQUARE SEMI
			   ;

type_specifier: INT
			  | VOID
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
