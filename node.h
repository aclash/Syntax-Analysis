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
	string type;
	vector<Node*> children;
	Node(string _name, string _type = "") {
		name = _name;
		type = _type;
	}
};

struct Symbol {
	string str;
	string type;
	int blockNum;
	Symbol(string _str, int _blockNum, string _type) {
		str = _str;
		type = _type;
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
extern vector<vector<pair<string, string>>> output;
extern stack<int> curScope;
extern stack<Node*> parseTreeSTK;
extern int maxScope;
extern Node* root;
extern void MeetLeftBrace();
extern void MeetRightBrace();
extern void Insert(string str, string type);
extern void PrintSymbolTbl();
extern void PrintParseTree(Node* node, int indents);
extern void DeleteTree(Node* node);
#endif
