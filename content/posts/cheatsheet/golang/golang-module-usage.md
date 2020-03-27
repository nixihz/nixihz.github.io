---
title : Golang Module 备忘
description : Golang Module 备忘
tags:
 - golang
date: 2020-01-02
categories:
 - "develop"
 - "golang"
weight: 1
---

<audio src="/" preload="none"></audio>  终于，在go1.11 版本中，新增了module管理模块功能，用来管理依赖包。
文章包你  
一招鲜，走天下

<!--more-->


## 开启环境变量

```
export GO111MODULE=on  
```

## 操作

### 初始化

```
go mod init mytest  
```

### 添加/删除依赖

自动根据 go 文件中的import 添加或者删除依赖

```
go mod tidy
```


