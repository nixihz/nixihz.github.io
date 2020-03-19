+++
title = "git重刷提交的email和name信息"
description = "git 重刷提交的email和name信息"
tags = [
    "git",
]
date = "2020-03-02"
categories = [
    "develop",
    "git",
]
menu = "main"
+++

## 场景

公司项目和个人项目不能耦合特别是发布到公开项目的“提交人”信息最好不要和公司一致；

但，难免忘记配置，需要重新刷；

推荐的方式是，放弃全局配置，每个项目独立配置 user.name user.email

<!--more--> 

## 步骤

### 1. 克隆bare项目 纯仓库

```
git clone --bare https://github.com/user/repo.git
cd repo.git

```

### 2. 修改信息

```

#!/bin/sh

git filter-branch --env-filter '

OLD_EMAIL="old@email.com"
CORRECT_NAME="new_name"
CORRECT_EMAIL="new@email.com"


if [ "$GIT_COMMITTER_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags

```

### 3. 修正的任务推送到远程

```
git push --force --tags origin 'refs/heads/*'
```

### 4. 清理多余文件
```
cd ..
rm -rf repo.git

```
