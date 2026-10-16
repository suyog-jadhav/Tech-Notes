# Threaded Binary Tree (TBT)

> **Quick idea:** A Threaded Binary Tree uses otherwise-`NULL` child
> pointers to store links to a node's inorder predecessor or successor.
> This makes inorder traversal possible without recursion or an
> auxiliary stack.

## 1. Why do we need a Threaded Binary Tree?

In a normal binary tree, many child pointers are `NULL`. During inorder
traversal, we usually use recursion or an explicit stack to remember
where to return.

A TBT reuses these empty pointers as **threads**: - A **left thread**
points to the inorder predecessor. - A **right thread** points to the
inorder successor.

This can reduce wasted pointer space and allow traversal with **O(1)
auxiliary space**. It does **not** guarantee faster traversal; both
ordinary inorder traversal and threaded inorder traversal take **O(n)**
time.

## 2. Important terminology

For a node `x`: - **Inorder predecessor:** the node visited immediately
before `x` in inorder traversal. - **Inorder successor:** the node
visited immediately after `x` in inorder traversal. - **Child link:** a
pointer to an actual left or right child. - **Thread:** a pointer used
to reach the predecessor or successor instead of a child.

### Node representation

``` cpp
struct Node {
    int data;
    Node *left, *right;
    bool lthread, rthread;
};
```

The flags tell us how to interpret each pointer:

  -----------------------------------------------------------------------
  Flag                    `true`                  `false`
  ----------------------- ----------------------- -----------------------
  `lthread`               `left` points to        `left` points to a real
                          inorder predecessor (or left child
                          `nullptr` if none)      

  `rthread`               `right` points to       `right` points to a
                          inorder successor (or   real right child
                          `nullptr` if none)      
  -----------------------------------------------------------------------

**Important:** Never follow a thread as if it were a child. Always check
the corresponding flag first.

## 3. Types of Threaded Binary Trees

### Based on direction

1.  **Left-threaded:** Empty left pointers point to inorder
    predecessors.
2.  **Right-threaded:** Empty right pointers point to inorder
    successors.
3.  **Doubly (fully) threaded:** Both empty left and right pointers are
    threaded.

### Based on traversal order

Threads can be designed for inorder, preorder, or postorder traversal.
**Inorder threading** is the most common introductory form.

## 4. Example

Insert the values `20, 10, 30` into a threaded binary search tree (BST).

``` text
          20
         /  \
       10    30
```

Inorder traversal is:

``` text
10 -> 20 -> 30
```

Thread relationships: - Node `10` has no real left child, so its left
thread is `nullptr` (no predecessor). - Node `10`'s right pointer is a
thread to `20`. - Node `30`'s left pointer is a thread to `20`. - Node
`30` has no successor, so its right thread is `nullptr`.

The `left` and `right` pointers of `20` are real child links.

## 5. Inorder traversal without recursion or stack

The traversal uses two ideas:

1.  Start at the **leftmost node** (keep moving left while
    `lthread == false`).
2.  Visit the current node:
    -   If `rthread == true`, follow the right thread to its inorder
        successor.
    -   Otherwise, move to the leftmost node in its real right subtree.

### Pseudocode

``` text
current = leftmost(root)

while current != null:
    visit(current)

    if current.rthread == true:
        current = current.right
    else:
        current = leftmost(current.right)
```

-   **Time complexity:** `O(n)` for `n` nodes.
-   **Auxiliary space:** `O(1)` (excluding output storage).

## 6. Insertion in an inorder-threaded BST

This implementation uses **doubly threaded BST insertion** and does not
allow duplicate values.

### Insertion logic

1.  If the tree is empty, create the root. Both pointers are threads and
    initially `nullptr`.
2.  Search as in a normal BST:
    -   Go left only if `lthread == false`.
    -   Go right only if `rthread == false`.
3.  If the required direction is a thread, that position is the
    insertion point.
4.  When inserting as a **left child** of `parent`:
    -   New node's left thread points to `parent`'s former predecessor.
    -   New node's right thread points to `parent`.
    -   `parent->left` becomes a real child link (`lthread = false`).
5.  When inserting as a **right child** of `parent`:
    -   New node's left thread points to `parent`.
    -   New node's right thread points to `parent`'s former successor.
    -   `parent->right` becomes a real child link (`rthread = false`).

## 7. Complete C++ implementation

``` cpp
#include <iostream>
using namespace std;

struct Node {
    int data;
    Node *left, *right;
    bool lthread, rthread;
};

Node* createNode(int data) {
    Node* node = new Node;
    node->data = data;
    node->left = nullptr;
    node->right = nullptr;
    node->lthread = true;
    node->rthread = true;
    return node;
}

Node* insert(Node* root, int data) {
    // Empty tree: the new node becomes the root.
    if (root == nullptr) {
        return createNode(data);
    }

    Node* current = root;
    Node* parent = nullptr;

    while (current != nullptr) {
        if (data == current->data) {
            cout << "Duplicate values are not allowed: "
                 << data << '\n';
            return root;
        }

        parent = current;

        if (data < current->data) {
            if (current->lthread == false) {
                current = current->left;
            } else {
                break;  // Left thread marks the insertion position.
            }
        } else {
            if (current->rthread == false) {
                current = current->right;
            } else {
                break;  // Right thread marks the insertion position.
            }
        }
    }

    Node* node = createNode(data);

    if (data < parent->data) {
        // Insert as the real left child of parent.
        node->left = parent->left;  // Parent's former predecessor.
        node->right = parent;       // Parent is the new node's successor.
        parent->left = node;
        parent->lthread = false;
    } else {
        // Insert as the real right child of parent.
        node->left = parent;        // Parent is the new node's predecessor.
        node->right = parent->right; // Parent's former successor.
        parent->right = node;
        parent->rthread = false;
    }

    return root;
}

Node* leftmost(Node* node) {
    if (node == nullptr) {
        return nullptr;
    }

    while (node->lthread == false) {
        node = node->left;
    }

    return node;
}

void inorder(Node* root) {
    Node* current = leftmost(root);

    while (current != nullptr) {
        cout << current->data << ' ';

        if (current->rthread == true) {
            // Right pointer is a thread to the inorder successor.
            current = current->right;
        } else {
            // Move into the real right subtree, then to its leftmost node.
            current = leftmost(current->right);
        }
    }

    cout << '\n';
}

void destroyTree(Node* root) {
    if (root == nullptr) {
        return;
    }

    // Recurse only through real child links, never through threads.
    if (root->lthread == false) {
        destroyTree(root->left);
    }
    if (root->rthread == false) {
        destroyTree(root->right);
    }

    delete root;
}

int main() {
    Node* root = nullptr;

    root = insert(root, 20);
    root = insert(root, 10);
    root = insert(root, 30);
    root = insert(root, 5);
    root = insert(root, 15);
    root = insert(root, 25);
    root = insert(root, 35);

    cout << "Inorder traversal: ";
    inorder(root);

    destroyTree(root);
    return 0;
}
```

**Output**

``` text
Inorder traversal: 5 10 15 20 25 30 35
```

### Edge cases handled

-   Empty tree.
-   Inserting the first/root node.
-   Inserting a left or right child.
-   Inserting into a tree with existing threads.
-   Duplicate values (rejected).
-   Traversing an empty tree.
-   Cleanup that follows only real child links.

## 8. Advantages

-   Inorder traversal requires no recursion or explicit stack.
-   Uses otherwise-empty child pointers to store useful traversal links.
-   Provides `O(1)` auxiliary space for inorder traversal.
-   Successor/predecessor navigation can be convenient when moving
    through the tree in order.

## 9. Disadvantages

-   Insertion and deletion require careful maintenance of threads.
-   The flags make pointer logic more complex than in a normal binary
    tree.
-   Threads must never be mistaken for real child links.
-   Threading does not automatically make traversal faster.
-   A threaded BST can still become skewed; without balancing, search
    and insertion can take `O(n)` time.

## 10. Applications

-   Traversing a binary tree when recursion or an auxiliary stack should
    be avoided.
-   Memory-constrained tree traversal.
-   Efficient sequential navigation to inorder predecessors and
    successors.
-   Educational implementations of pointer-based data structures.

## 11. Threaded Binary Tree vs Normal Binary Tree

  -----------------------------------------------------------------------
  Feature                 Normal binary tree      Inorder-threaded binary
                                                  tree
  ----------------------- ----------------------- -----------------------
  Empty child pointers    `nullptr`               May store
                                                  predecessor/successor
                                                  threads

  Inorder traversal       Usually recursion or    Can use threads without
                          stack                   recursion or stack

  Auxiliary traversal     Up to `O(h)` for        `O(1)`
  space                   recursion/stack         

  Traversal time          `O(n)`                  `O(n)`

  Implementation          Simpler                 More complex; flags
                                                  must be maintained

  Insert/delete           Standard pointer        Must preserve thread
                          updates                 relationships
  -----------------------------------------------------------------------

Here, `h` is the height of the tree.

## 12. Common viva questions

**Q1. What is a Threaded Binary Tree?**\
A binary tree in which one or both kinds of `NULL` child pointers are
replaced with links to inorder predecessors or successors.

**Q2. Why is threading used?**\
To make traversal possible without recursion or an auxiliary stack and
to reuse otherwise-empty pointers.

**Q3. What is an inorder predecessor?**\
The node visited immediately before a given node in inorder traversal.

**Q4. What is an inorder successor?**\
The node visited immediately after a given node in inorder traversal.

**Q5. What do `lthread` and `rthread` mean in this implementation?**\
If a flag is `true`, its pointer is a thread; if `false`, it is a real
child link.

**Q6. What is the complexity of inorder traversal?**\
`O(n)` time and `O(1)` auxiliary space.

**Q7. Is a TBT always faster than a normal binary tree?**\
No. Its main traversal benefit is constant auxiliary space, not
guaranteed speed.

**Q8. Can duplicate keys be inserted in this implementation?**\
No. The insertion function rejects duplicates.

**Q9. Is every pointer a thread in a TBT?**\
No. A pointer can be either a real child link or a thread; the flags
distinguish them.

**Q10. What is the main disadvantage of a TBT?**\
Insertion and deletion are more complicated because thread links must
remain correct.

------------------------------------------------------------------------

## Quick revision

-   **Left thread** → inorder predecessor.
-   **Right thread** → inorder successor.
-   `lthread == false` → `left` is a real child.
-   `rthread == false` → `right` is a real child.
-   Inorder traversal → leftmost node, visit, then follow successor
    thread or enter the right subtree.
-   Traversal complexity → **`O(n)` time, `O(1)` auxiliary space**.
