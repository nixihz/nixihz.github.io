---
title : Scala 简介
description : Scala 简介
tags:
 - scala
date: 2018-06-01
weight: 1

---

## 特点关键词：

* jvm、
* 静态类型、
* 多范例
    * 面向对象-trait(mixin组合)
    * 函数式编程FP-适用大数据和并发  
        * Immutable 值、
        * First Class 函数、
        * 无副作用函数
        * 高阶函数
        * 函数集合
* 泛型  
通过类型推断，Scala代码通常与动态类型语言中的代码一样简洁。
* 可扩展架构  
    * trait: mixin组合
    * 抽象成员和泛型
    * 嵌套类
    * 明确的自我类型??
    

## 其他关键词
REPL  
“读取-求值-输出”循环(英语:Read-Eval-Print Loop)，sbt 终端启动 console。

```sh
$ sbt
sbt:fence> console
scala>

```


## 语法

```scala

class Upper {
  def upper(strings: String*): Seq[String] = {
    strings.map((s:String) => s.toUpperCase())
  }
}

val up = new Upper
println(up.upper("Hello", "World!"))

```


### 方法定义
```scala
def upper(strings: String*): Seq[String] = ...

```

* def
* strings: String* 可变函数，类型为 WrappedArray,
* : 后面返回值，类型为 scala.collection.mutable.ArrayBuffer
* 泛型参数化类型使用 [...]， Java 使用的是 <...>，  因为 scala 支持 < 这个符号出现在 变量名 中。
* = 不可缺少，为了使参略分号之时可以推断出分号，同时是 函数式编程中的原则
* map 参数为 匿名函数  
(s:String) => s.toUpperCase()， 方法中可以使用 return， 但是 匿名函数不能使用 return

### 方法 vs 函数
 
METHODS VERSUS FUNCTIONS

* method 方法是类或者对象中的 function 函数
* 调用 method 方法时，隐式将this作为附加参数
* (s:String) => s.toUpperCase() 是一个函数，而不是方法



 




 

