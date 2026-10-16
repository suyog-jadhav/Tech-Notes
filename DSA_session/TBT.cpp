#include<iostream>
using namespace std;

struct node{
	int data;
	node *left,*right;
	bool lthread,rthread;
	node(int data){
		this->data = data;
		left = right = NULL;
		lthread = rthread = true;
	}
};

class TBT{
	private:
			node *root;

	public:
			TBT(){
				root = NULL;
			}
			void insert(int data);
			node* leftmost(node* ptr);
			void inorder();
};

void TBT::insert(int data){
	node *ptr = root;
	node *parent = NULL;

	while(ptr){
		if(data == ptr->data) return; //duplicate values
		parent = ptr;
		if(data < ptr->data){
			if(!ptr->lthread)
				ptr = ptr->left;
			else break;
		}else{
			if(!ptr->rthread)
				ptr = ptr->right;
			else break;
		}
	}

	node *temp = new node(data);

	if(!parent){
		root = temp;
		return;
	}

	if(data < parent->data){
		temp->left = parent->left;
		temp->right = parent;
		parent->lthread = false;
		parent->left = temp;
		return;
	}

	temp->right = parent->right;
	temp->left = parent;
	parent->rthread = false;
	parent->right = temp;
	return;
}
node* TBT::leftmost(node* ptr){
	if(!ptr) return NULL;
	while(!ptr->lthread)
		ptr = ptr->left;
	return ptr;
}

void TBT::inorder(){
	node *ptr = leftmost(root);
	while(ptr){
		cout<<ptr->data<<" ";
		if(ptr->rthread)
			ptr = ptr->right;
		else
			ptr = leftmost(ptr->right);
	}
	cout<<endl;
}

int main(){
	TBT tree;
	tree.insert(10);
	tree.insert(30);
	tree.insert(50);
	tree.insert(70);
	tree.insert(20);
	tree.inorder();
	return 0;
}