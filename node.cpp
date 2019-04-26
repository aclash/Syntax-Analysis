#include "node.h"
using namespace std;

int scopeNum = -1;
unordered_set<Symbol, hashFunction> hashSet;
vector<vector<string>> output;
stack<int> curScope;
stack<Node*> parseTreeSTK;
int maxScope = 0;

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

void PrintParseTree() {
	/*int identNum = 0;
	while (!parseTreeSTK.empty()) {
		Node* tmp = parseTreeSTK.top();
		parseTreeSTK.pop();
		vector<Node*> tmpVec = tmp->children;
		cout << tmp->name << endl;
		++identNum;
		for (int i = 0; i < tmpVec.size(); ++i) {
			for (int j = 0; j < identNum; ++j) {
				cout << " ";
			}
			cout << tmpVec[i]->name << endl;
		}
	}*/
}