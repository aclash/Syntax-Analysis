#include "node.h"
using namespace std;

int scopeNum = -1;
unordered_set<Symbol, hashFunction> hashSet;
vector<vector<string>> output;
stack<int> curScope;
stack<Node*> parseTreeSTK;
int maxScope = 0;
Node* root = nullptr;

void MeetLeftBrace() {
	++scopeNum;
	curScope.push(scopeNum);
	maxScope = max(maxScope, curScope.top());
}

void MeetRightBrace() {
	curScope.pop();
}

void Insert(string str) {
	Symbol key(str, curScope.top());
	if (hashSet.count(key) == 0) {
		hashSet.insert(key);
	}
}

void PrintSymbolTbl() {
	cout << "Symbol Table as follows: " << endl;
	output.resize(maxScope + 1);
	for (auto it = hashSet.begin(); it != hashSet.end(); ++it) {
		output[it->blockNum].push_back(it->str);
	}
	for (int i = 0; i < output.size(); ++i) {
		cout << "Scope " << i << ": ";
		for (int j = 0; j < output[i].size(); ++j) {
			cout << output[i][j] << " ";
		}
		cout << endl;
	}
}

void PrintParseTree(Node* node, int indents) {
	for (int i = 0; i < indents; ++i)
		cout << " ";
	cout << node->name << endl;
	for (int i = 0; i < node->children.size(); ++i) {
		PrintParseTree(node->children[0], ++indents);
	}
}