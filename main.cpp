#include "node.h"
extern int yyparse();
using namespace std;
int main(int argc, char **argv)
{
	maxScope = 0;
	hashSet.clear();
	output.clear();
	while (!curScope.empty())
		curScope.pop();	
    yyparse();
	PrintParseTree(root, 0);
	PrintSymbolTbl();
    return 0;
}