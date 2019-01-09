//  Created by 大强神 on 2019/1/9.
//  Copyright © 2019 大强神. All rights reserved.

import UIKit

//二叉树结点
class BinaryTreeNode {
    var data: Int                   //结点存储数据
    var leftChild: BinaryTreeNode?  //左孩子指针
    var rightChild: BinaryTreeNode? //右孩子指针
    
    //初始化方法
    init(data: Int) {
        self.data = data
    }

}

//二叉排序树查找结果
class SearchResult {
    //存储查找的结点，如果查找成功就是当前查找成功的结点
    var searchNode: BinaryTreeNode?
    
    //存储当前查找结点的直接父母结点
    var parentNode: BinaryTreeNode?
    
    //查找成功为true,查找失败为false
    var isFound: Bool = false
}

class BinarySortTree {
    
    //根结点
    fileprivate var rootNode: BinaryTreeNode?
    
    //数据源
    fileprivate var items: [Int]
    
    //初始化方法
    init(items: [Int]) {
        self.items = items
        //创建二叉排序树
        createBST()
    }
    
    //二叉排序树查找
    func searchBST(key: Int) -> Bool {
       let searchResult = searchBST(currentRoot: rootNode, parentNode: nil, key: key)
       return searchResult.isFound
    }
    
    //二叉排序树插入
    func insertBST(key: Int) {
        let searchResult = searchBST(currentRoot: rootNode, parentNode: nil, key: key)
        if !searchResult.isFound {
            insertBST(parentNode: searchResult.parentNode, key: key)
        }
    }
    
    //二叉排序树删除
    func deleteBST(key: Int) {
        let searchResult = searchBST(currentRoot: rootNode, parentNode: nil, key: key)
        deleteBST(searchResult: searchResult)
    }
    
    
    //中序遍历二叉排序树
    func inOrderTraversal() {
        print("中序遍历：")
        inOrderTraversal(node: rootNode)
    }

}

extension BinarySortTree {
    /**
     * 二叉排序树查找
     * @param currentRoot 当前二叉排序树的根结点或子树的根结点
     * @param parentNote  currentRoot的父母结点，如果currentRoot是整个二叉排序树的根结点，则该参数为nil
     * @param key         查找的关键字
     *
     * @return            返回查找的结果对象 
     */
    fileprivate func searchBST(currentRoot: BinaryTreeNode?,
                               parentNode: BinaryTreeNode?,
                               key: Int) -> SearchResult {
        let searchResult = SearchResult()
        
        //查找失败，返回该结点的父母结点（便于插入）
        if currentRoot == nil {
            searchResult.parentNode = parentNode
            searchResult.isFound = false
            return searchResult
        }
        
        //查找成功，返回查找成功的结点，将isFound设置为true
        if key == currentRoot!.data {
            searchResult.searchNode = currentRoot
            searchResult.parentNode = parentNode
            searchResult.isFound = true
            return searchResult
        }
        
        if key < currentRoot!.data { //在左子树继续查找
            return searchBST(currentRoot:currentRoot?.leftChild, parentNode: currentRoot, key: key)
        } else { //在右子树继续查找
            return searchBST(currentRoot:currentRoot?.rightChild, parentNode: currentRoot, key: key)
        }
    }
    
    /**
     * 二叉排序树插入
     * @param parentNote 待插入结点的父母结点
     * @param key        待插入的数据
     */
    fileprivate func insertBST(parentNode: BinaryTreeNode?, key: Int) {
        //创建结点
        let node = BinaryTreeNode(data: key)
        //如果parentNote为nil,说明当前二叉排序树为空树
        guard parentNode != nil else {
            rootNode = node
            return
        }
        
        if key < parentNode!.data { //插入为左孩子
            parentNode?.leftChild = node
        } else { //插入为右孩子
            parentNode?.rightChild = node
        }
    }
    
    /**
     * 根据提供的集合创建二叉排序树
     */
    fileprivate func createBST() {
        for key in items {
            //查找key
            let searchResult = searchBST(currentRoot: rootNode, parentNode: nil, key: key)
            
            //如果查找失败，则插入到二叉排序树上
            if !searchResult.isFound {
                insertBST(parentNode: searchResult.parentNode, key: key)
            }
        }
    }
    
    /**
     * 二叉排序树删除
     * @param searchResult 待删除结点查询结果
     */
    fileprivate func deleteBST(searchResult: SearchResult) {
        guard let searchNode = searchResult.searchNode else { //没有要删除的值
            print("没有要删除的值")
            return
        }
        
        //叶子结点
        if searchNode.leftChild == nil && searchNode.rightChild == nil {
            print("该结点为叶子结点")
            deleteNodeWithZeroOrOneChild(searchResult: searchResult,
                                         subNode: nil)
            return
        }
        
        //只有左子树的结点
        if searchNode.leftChild != nil && searchNode.rightChild == nil {
            print("该结点只有左子树")
            deleteNodeWithZeroOrOneChild(searchResult: searchResult, subNode: searchNode.leftChild)
            return
        }
        
        //只有左子树的结点
        if searchNode.leftChild == nil && searchNode.rightChild != nil {
            print("该结点只有右子树")
            deleteNodeWithZeroOrOneChild(searchResult: searchResult, subNode: searchNode.rightChild)
            return
        }
        
        //既有左子树又有右子树的结点
        if searchNode.leftChild != nil && searchNode.rightChild != nil {
            print("该结点既有左子树也有右子树")
            deleteNodeWithTwoChild(searchResult: searchResult)
            return
        }
    }
    
    /**
     * 中序遍历二叉排序树
     * @param node 结点
     */
    fileprivate func inOrderTraversal(node: BinaryTreeNode?) {
        guard let node = node else {
            return
        }
        inOrderTraversal(node: node.leftChild)
        print(node.data)
        inOrderTraversal(node: node.rightChild)
    }
    
    /**
     * 待删除的结点是叶子结点或者只有一个孩子
     * @param searchResult 待删除结点搜索结果
     * @param subNote      待删除结点孩子
     */
    fileprivate func deleteNodeWithZeroOrOneChild(searchResult: SearchResult, subNode: BinaryTreeNode?) {
        //将待删除结点的左右孩子指针置空
        searchResult.searchNode?.leftChild = nil
        searchResult.searchNode?.rightChild = nil
        
        guard let parentNode = searchResult.parentNode else { //如果待删除结点为整个二叉排序树的根结点
            rootNode = subNode //更新根结点
            return
        }
        
        if searchResult.searchNode!.data < parentNode.data { //待删除结点的孩子成为待删除结点父母结点的左孩子
            parentNode.leftChild = subNode
        } else { //待删除结点的孩子成为待删除结点父母结点的右孩子
            parentNode.rightChild = subNode
        }
        
    }
    
    /**
     * 待删除的结点有左右两孩
     */
    fileprivate func deleteNodeWithTwoChild(searchResult: SearchResult) {
        //初始化游标结果对象，用于存储右子树最小结点（最左边）
        let cursorResult = SearchResult()
        cursorResult.parentNode = searchResult.searchNode
        cursorResult.searchNode = searchResult.searchNode?.rightChild
        cursorResult.isFound = false
        
        //寻找待删除结点右子树最左边的结点
        while cursorResult.searchNode?.leftChild != nil {
            cursorResult.parentNode = cursorResult.searchNode
            cursorResult.searchNode = cursorResult.searchNode?.leftChild
        }
        
        //将右子树最左边的结点赋值给待删除结点
        searchResult.searchNode!.data = cursorResult.searchNode!.data
        
        //删除右子树最左边的结点
        deleteBST(searchResult: cursorResult)
    }
}
