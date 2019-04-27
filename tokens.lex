%{
	#include "node.h"
	#include "parser.hpp"
	using namespace std;
	#define SAVE_TOKEN yylval.string = new std::string(yytext, yyleng)
	#define TOKEN(t) (yylval.token = t)
	extern "C" int yywrap() { }
    int line = 1;
%}

DIGIT [0-9]
INTEGER ("-")?[1-9]{DIGIT}*|0
FLOAT {INTEGER}"."({DIGIT}*)?|({INTEGER})?"."{DIGIT}*
BOOLEAN T|F
IDENTIFIER [a-zA-Z]([a-zA-Z0-9]){0,5}
STRING "("[a-zA-Z0-9\\]+")"
OPERATOR [-/+*()=%{}]
PREDEFINED_FUNCTION "print"
%%
\n {++line;}
{BOOLEAN} { string tmp = yytext; Insert(tmp); SAVE_TOKEN; return TBoolean;}
{INTEGER} { string tmp = yytext; Insert(tmp); SAVE_TOKEN; return Tinteger;}
{FLOAT} { string tmp = yytext; Insert(tmp); SAVE_TOKEN; return Tfloat;}
"Program" return PROGRAM;
"Function" return FUNCTION;
"return" return RETURN;
"if" return IF;
"then" return THEN;
"else" return ELSE;
"while" return WHILE;
"do" return DO;
"or" return OR;
"and" return AND;
"==" {return TOKEN(TCEQ);}                 
"!=" {return TOKEN(TCNE);}
"<" {return TOKEN(TCLT);}
"<=" {return TOKEN(TCLE);}
">" {return TOKEN(TCGT);}
">=" {return TOKEN(TCGE);}
{OPERATOR} { string tmp = yytext; if(tmp == "{") MeetLeftBrace(); if (tmp == "}") MeetRightBrace(); return yytext[0];}
{PREDEFINED_FUNCTION} {return TOKEN(TPRINT);}
{STRING} {string tmp = yytext; Insert(tmp);SAVE_TOKEN; return TString;}
{IDENTIFIER} {string tmp = yytext; Insert(tmp); SAVE_TOKEN; return Tidentifier;}
[ \t]+ {}
%%