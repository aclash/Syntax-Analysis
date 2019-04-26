%{
	#include "node.h"
	using namespace std;
	extern int yylex();
	void yyerror(const char *s) { printf("ERROR: %s\n", s); }
%}

%union {
	std::string* string;
	int token;
	Node* node;
}

%token <string> TBoolean Tinteger Tfloat TString Tidentifier
%token <token> TCEQ TCNE TCLT TCLE TCGT TCGE TPRINT
%token PROGRAM FUNCTION RETURN IF THEN ELSE WHILE DO OR AND 
%type <node> program program_name function_definitions statements function_definition function_name arguments argument return_arg assignment_stmt parameter number

%left '+' '-'
%left '*' '/' '%'
%start program

%%
program : '{' PROGRAM program_name function_definitions statements'}'							{}	
program_name : Tidentifier																		{}
function_definitions : function_definitions function_definition 								{}
| %empty																						{}
function_definition : '{' FUNCTION function_name arguments statements RETURN return_arg '}' 	{}
function_name : Tidentifier																		{}
arguments : arguments argument 																	{}
| %empty																						{}
argument : Tidentifier																			{}
return_arg : Tidentifier 																		{}
| %empty																						{}
statements : statements statement 																{}
| statement																						{}
statement : assignment_stmt																		{}
assignment_stmt : '{' '=' Tidentifier parameter '}'												{}
parameter : number																				{}
number : Tinteger																				{ printf("Integer: %s\n", $1->c_str());}
%%
