#ifndef SYNTAX_ANALYSIS_NODE_HEADER_INCLUDED
#define	SYNTAX_ANALYSIS_NODE_HEADER_INCLUDED
#include <iostream>
#include <string>
#include <unordered_set>
#include <stack>
#include <vector>
#include <algorithm>
using namespace std;
struct Node {
	string name;
	vector<Node*> children;
	Node(string _name) {
		name = _name;
	}
};

struct Symbol {
	string str;
	int blockNum;
	Symbol(string _str, int _blockNum) {
		str = _str;
		blockNum = _blockNum;
	}
	bool operator== (const Symbol& other) const {
		return blockNum == other.blockNum && str == other.str;
	}
};

struct hashFunction {
	size_t operator()(const Symbol& key) const {
		size_t hashValue = 17;
		hashValue = 31 * hashValue + hash<string>()(key.str);
		hashValue = 31 * hashValue + hash<int>()(key.blockNum);
		return hashValue;
	}
};
extern int scopeNum;
extern unordered_set<Symbol, hashFunction> hashSet;
extern vector<vector<string>> output;
extern stack<int> curScope;
extern stack<Node*> parseTreeSTK;
extern int maxScope;
extern Node* root;
extern void MeetLeftBrace();
extern void MeetRightBrace();
extern void Insert(string str);
extern void PrintSymbolTbl();
extern void PrintParseTree(Node* node, int indents);
extern void DeleteTree(Node* node);
#endif
