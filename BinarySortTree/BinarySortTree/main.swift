//  Created by 大强神 on 2019/1/9.
//  Copyright © 2019 大强神. All rights reserved.

import Foundation

//数据源
let items = [62, 88, 58, 47, 35, 73, 51, 99, 37, 93]
//创建二叉排序树
let bst = BinarySortTree(items: items)
//查找
_ = bst.searchBST(key: 62)
//插入
bst.insertBST(key: 53)
//删除
bst.deleteBST(key: 88)
//输出
bst.inOrderTraversal()
