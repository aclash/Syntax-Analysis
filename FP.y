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
%type <node> program program_name function_definitions statements statement function_definition function_name arguments argument return_arg assignment_stmt parameters parameter number predefined_function function_call if_stmt expression while_stmt comparison_operator Boolean_operator

%left '+' '-'
%left '*' '/' '%'
%start program

%%
program : '{' PROGRAM program_name function_definitions statements'}' {
	cout << "program : '{' PROGRAM program_name function_definitions statements'}' begin" <<endl;
	root = new Node("program"); 
	root->children.push_back(new Node("{")); 
	root->children.push_back(new Node("Program"));
	root->children.push_back($3);
	root->children.push_back($4);
	root->children.push_back($5);
	root->children.push_back(new Node("}"));
	cout << "program : '{' PROGRAM program_name function_definitions statements'}'" <<endl;
}	

program_name : Tidentifier {
	$$ = new Node("program_name"); 
	$$->children.push_back(new Node(*$1));
	delete $1;
	cout << "program_name : Tidentifier" <<endl;
}

function_definitions : function_definitions function_definition {
	$$ = new Node("function_definitions");
	$$->children.push_back($1);
	$$->children.push_back($2);
	cout << "function_definitions : function_definitions function_definition" <<endl;	
}
| %empty {
	$$ = new Node("function_definitions - epsilon");
	cout << "function_definitions : epsilon" <<endl;
}

function_definition : '{' FUNCTION function_name arguments statements RETURN return_arg '}' {
	cout << "function_definition : '{' FUNCTION function_name arguments statements RETURN return_arg '}' begin" <<endl;
	$$ = new Node("function_definition"); 
	$$->children.push_back(new Node("{")); 
	$$->children.push_back(new Node("Function"));
	$$->children.push_back($3);
	$$->children.push_back($4);
	$$->children.push_back($5);
	$$->children.push_back(new Node("return"));
	$$->children.push_back($7);
	$$->children.push_back(new Node("}"));
	cout << "function_definition : '{' FUNCTION function_name arguments statements RETURN return_arg '}'" <<endl;
}

function_name : Tidentifier {
	$$ = new Node("function_name"); 
	$$->children.push_back(new Node(*$1));
	delete $1;
	cout << "function_name : Tidentifier" <<endl;
}

arguments : arguments argument {
	$$ = new Node("arguments");
	$$->children.push_back($1);
	$$->children.push_back($2);
	cout << "arguments : arguments argument" <<endl;
}
| %empty {
	$$ = new Node("arguments - epsilon");
	cout << "arguments : epsilon" <<endl;
}

argument : Tidentifier {
	$$ = new Node("argument"); 
	$$->children.push_back(new Node(*$1));
	delete $1;
	cout << "argument : Tidentifier" <<endl;
}

return_arg : Tidentifier {
	cout << "return_arg : Tidentifier begin" <<endl;
	$$ = new Node("return_arg"); 
	$$->children.push_back(new Node(*$1));  
	delete $1;
	cout << "return_arg : Tidentifier" <<endl;
}
| %empty {
	cout << "return_arg : epsilon begin" <<endl;
	$$ = new Node("return_arg - epsilon");
	cout << "return_arg : epsilon" <<endl;
}

statements : statements statement {
	cout << "statements : statements statement begin" <<endl;
	$$ = new Node("statements");
	$$->children.push_back($1);
	$$->children.push_back($2);
	cout << "statements : statements statement" <<endl;
}
| statement {
	$$ = new Node("statements");
	$$->children.push_back($1);
	cout << "statements : statement" <<endl;
}

statement : assignment_stmt {
	$$ = new Node("statement");
	$$->children.push_back($1);
	cout << "statement : assignment_stmt" <<endl;	
}
| function_call {
	$$ = new Node("statement");
	$$->children.push_back($1);
}
| if_stmt {
	$$ = new Node("statement");
	$$->children.push_back($1);
}
| while_stmt {
	$$ = new Node("statement");
	$$->children.push_back($1);
}

function_call : '{' function_name parameters '}' {
	$$ = new Node("function_call"); 
	$$->children.push_back(new Node("{")); 
	$$->children.push_back($2);
	$$->children.push_back($3);
	$$->children.push_back(new Node("}"));
}
| '{' predefined_function parameters '}' {
	$$ = new Node("function_call"); 
	$$->children.push_back(new Node("{")); 
	$$->children.push_back($2);
	$$->children.push_back($3);
	$$->children.push_back(new Node("}"));
}

predefined_function : '+' {
	$$ = new Node("predefined_function");
	$$->children.push_back(new Node("+")); 
}
| '-' {
	$$ = new Node("predefined_function");
	$$->children.push_back(new Node("-")); 
}
| '*' {
	$$ = new Node("predefined_function");
	$$->children.push_back(new Node("*")); 
}
| '/' {
	$$ = new Node("predefined_function");
	$$->children.push_back(new Node("/")); 
}
| '%' {
	$$ = new Node("predefined_function");
	$$->children.push_back(new Node("%")); 
}
| TPRINT {
	$$ = new Node("predefined_function");
	$$->children.push_back(new Node("print"));
}

parameters : parameters parameter {
	$$ = new Node("parameters");
	$$->children.push_back($1);
	$$->children.push_back($2);
	cout << "parameters : parameters parameter" <<endl;	
}
| %empty {
	$$ = new Node("parameters - epsilon");
	cout << "parameters : epsilon" <<endl;
}

assignment_stmt : '{' '=' Tidentifier parameter '}' { 
	$$ = new Node("assignment_stmt"); 
	$$->children.push_back(new Node("{")); 
	$$->children.push_back(new Node("=")); 
	$$->children.push_back(new Node(*$3)); 
	delete $3;
	$$->children.push_back($4); 
	$$->children.push_back(new Node("}"));
	cout << "assignment_stmt : '{' '=' Tidentifier parameter '}'" <<endl;
}

parameter : function_call {
	$$ = new Node("parameter"); 
	$$->children.push_back($1);
}
| Tidentifier {
	$$ = new Node("parameter"); 
	$$->children.push_back(new Node(*$1)); 
	delete $1;
}
| number { 
	$$ = new Node("parameter"); 
	$$->children.push_back($1);
	cout << "parameter : number" <<endl;
}
| TString {
	$$ = new Node("parameter"); 
	$$->children.push_back(new Node(*$1)); 
	delete $1;
}
| TBoolean {
	$$ = new Node("parameter"); 
	$$->children.push_back(new Node(*$1)); 
	delete $1;
}

number : Tinteger {
	$$ = new Node("number"); 
	$$->children.push_back(new Node(*$1)); 
	delete $1;
	cout << "number : Tinteger" <<endl;
}
| Tfloat {
	$$ = new Node("number"); 
	$$->children.push_back(new Node(*$1)); 
	delete $1;
}

if_stmt : '{' IF expression THEN statements ELSE statements '}' {
	$$ = new Node("if_stmt"); 
	$$->children.push_back(new Node("{")); 
	$$->children.push_back(new Node("if"));
	$$->children.push_back($3);
	$$->children.push_back(new Node("then"));
	$$->children.push_back($5);
	$$->children.push_back(new Node("else"));
	$$->children.push_back($7);
	$$->children.push_back(new Node("}"));
}

while_stmt : '{' WHILE expression DO statements '}' {
	$$ = new Node("while_stmt"); 
	$$->children.push_back(new Node("{")); 
	$$->children.push_back(new Node("while"));
	$$->children.push_back($3);
	$$->children.push_back(new Node("do"));
	$$->children.push_back($5);
	$$->children.push_back(new Node("}"));
}

expression : '{' comparison_operator parameter parameter '}' {
	$$ = new Node("expression"); 
	$$->children.push_back(new Node("{")); 
	$$->children.push_back($2);
	$$->children.push_back($3);
	$$->children.push_back($4);
	$$->children.push_back(new Node("}"));
}
| '{' Boolean_operator expression expression '}' {
	$$ = new Node("expression"); 
	$$->children.push_back(new Node("{")); 
	$$->children.push_back($2);
	$$->children.push_back($3);
	$$->children.push_back($4);
	$$->children.push_back(new Node("}"));
}
| TBoolean {
	$$ = new Node("expression"); 
	$$->children.push_back(new Node(*$1)); 
	delete $1;
}

comparison_operator : TCEQ {
	$$ = new Node("comparison_operator"); 
	$$->children.push_back(new Node("=="));
}
| TCGT {
	$$ = new Node("comparison_operator"); 
	$$->children.push_back(new Node(">"));
} 
| TCLT {
	$$ = new Node("comparison_operator"); 
	$$->children.push_back(new Node("<"));
} 
| TCGE {
	$$ = new Node("comparison_operator"); 
	$$->children.push_back(new Node(">="));
} 
| TCLE {
	$$ = new Node("comparison_operator"); 
	$$->children.push_back(new Node("<="));
} 
| TCNE {
	$$ = new Node("comparison_operator"); 
	$$->children.push_back(new Node("!="));
}

Boolean_operator : OR {
	$$ = new Node("Boolean_operator"); 
	$$->children.push_back(new Node("or"));
}
| AND {
	$$ = new Node("Boolean_operator"); 
	$$->children.push_back(new Node("and"));
}

%%
