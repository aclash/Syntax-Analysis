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
%type <node> program program_name function_definitions statements statement function_definition function_name arguments argument return_arg assignment_stmt parameter number

%left '+' '-'
%left '*' '/' '%'
%start program

%%
program : '{' PROGRAM program_name function_definitions statements'}' {
	root = new Node("program"); 
	$$->children.push_back(new Node("{")); 
	$$->children.push_back(new Node("Program"));
	$$->children.push_back($3);
	$$->children.push_back($4);
	$$->children.push_back($5);
	$$->children.push_back(new Node("}")); 
}	

program_name : Tidentifier {
	$$ = new Node("program_name"); 
	$$->children.push_back(new Node(*$1));
	delete $1;
}

function_definitions : function_definitions function_definition {
	$$ = new Node("function_definitions");
	$$->children.push_back($1);
	$$->children.push_back($2); 
	
}
| %empty {
	$$ = new Node("function_definitions - epsilon");
}

function_definition : '{' FUNCTION function_name arguments statements RETURN return_arg '}' {
	$$ = new Node("function_definition"); 
	$$->children.push_back(new Node("{")); 
	$$->children.push_back(new Node("Function"));
	$$->children.push_back($3);
	$$->children.push_back($4);
	$$->children.push_back($5);
	$$->children.push_back(new Node("return"));
	$$->children.push_back($7);
	$$->children.push_back(new Node("}")); 
}

function_name : Tidentifier {
	$$ = new Node("function_name"); 
	$$->children.push_back(new Node(*$1));
	delete $1;
}

arguments : arguments argument {
	$$ = new Node("arguments");
	$$->children.push_back($1);
	$$->children.push_back($2); 
}
| %empty {
	$$ = new Node("arguments - epsilon");
}

argument : Tidentifier {
	$$ = new Node("argument"); 
	$$->children.push_back(new Node(*$1));
	delete $1;
}

return_arg : Tidentifier {
	$$ = new Node("return_arg"); 
	$$->children.push_back(new Node(*$1));  
	delete $1;
}
| %empty {
	$$ = new Node("return_arg - epsilon"); 
}

statements : statements statement {
	$$ = new Node("statements");
	$$->children.push_back($1);
	$$->children.push_back($2); 
}
| statement {
	$$ = new Node("statements");
	$$->children.push_back($1); 
}

statement : assignment_stmt {
	$$ = new Node("statement");
	$$->children.push_back($1); 
}

assignment_stmt : '{' '=' Tidentifier parameter '}' { 
	$$ = new Node("assignment_stmt"); 
	$$->children.push_back(new Node("{")); 
	$$->children.push_back(new Node("=")); 
	$$->children.push_back(new Node(*$3)); 
	delete $3;
	$$->children.push_back($4); 
	$$->children.push_back(new Node("}")); 
}

parameter : number { 
	$$ = new Node("parameter"); 
	$$->children.push_back($1);
}

number : Tinteger { 
	$$ = new Node("number"); 
	$$->children.push_back(new Node(*$1)); 
	delete $1;
}
%%
