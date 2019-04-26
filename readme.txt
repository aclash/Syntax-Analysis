use the following commands on Linux:

bison -d -o parser.cpp FP.y
flex -o tokens.cpp tokens.lex
g++ -o parser.out -std=c++11 parser.cpp tokens.cpp main.cpp node.cpp
./parser.out  < sample2.fp