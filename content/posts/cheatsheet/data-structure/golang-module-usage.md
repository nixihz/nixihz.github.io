---
title : Linked List 链表（Golang）
description : Linked List 链表（Golang）
tags:
 - golang
date: 2020-03-24
categories:
 - "golang"
weight: 1
---

# 链表和数组差异

链表类似数组，非常大的不同是，可以方便的在列表中间插入和删除元素。  

相对于数组的优点：  
数组把所有元素都保留在同一块内存中，链表通过存储下一个元素的指针来，把分散在内存中的元素包含在链表内。

相对于数组的缺点：  
如果想在链表中间选择一个元素就会比较困难， 因为不知道该元素的地址，只能从链表的开头开始查找。

# 实现

链表应该具有这些方法

* Append(t) 在链表末尾追加元素t
* Insert(i, t) 在链表指定位置i插入元素t
* RemoveAt(i) 删除链表指定位置i的元素
* IndexOf(t) 返回元素t所在的位置
* IsEmpty() 返回链表是否为空链表
* Size() 返回链表长度
* String() 返回元素按顺序拼接的字符串
* Head() 返回第一个位置的元素
