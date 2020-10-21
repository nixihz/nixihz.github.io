---
title : Hugo 版本控制
description : Hugo 版本控制
tags:
date: 2020-10-21
categories:
weight: 1
---


github page 以 username.github.io 这个项目的master 作为静态资源发布，所以不能把hugo项目放在master，必须开启一个新的分支存储 hugo 项目。

<!--more-->

我这里以 blogedit 分支举例：

```shell
git branch -a

* blogedit
  master
  remotes/origin/HEAD -> origin/master
  remotes/origin/blogedit
  remotes/origin/master

```

`hugo -D` 命令会把编译后的静态文件放到 public， 只要确保public 文件夹是 username.githu.io 的master分支即可。  
切换到blogedit分支，然后使用 submodule 创建一个子模块：

### 一、初始化

```sh
git submodule add git@github.com:fencex/fencex.github.io.git public/
```
`git submodule` 会创建 .gitmodules 文件，这个文件可以提交到 `blogedit` 分支；

`git submodule` 会把 public 放到暂存区，也就是多执行了一步 `git add public`， 但其实在 `blogedit` 分支，并不需要这个文件夹；


### 二、保存草稿和发布

1、保存草稿指的是保存 hugo 项目的 content，

``` sh
git add .
git commit -m 'update msg'
git push origin blogedit

```


2、发布，则需要到 public 里面操作
``` sh
cd public
git add .
git commit -m 'update msg'
git push origin master

```

