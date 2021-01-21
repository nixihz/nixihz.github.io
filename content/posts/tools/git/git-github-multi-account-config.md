---
title : "git 指定 ssh key 配置多账号"
description : "git 指定 ssh key 配置，github 配置多账号"
tags :
  - "git"
date : "2021-01-02"
categories : 
  - "develop"
  -  "git"
menu : "main"
---

## 场景 <audio src="/" preload="none" />

github 拥有多账号, 需要使用不同的 ssh-key


<!--more--> 


## 方案
修改ssh配置文件 `~/.ssh/config`

以 codeup.aliyun.com 为例子

```go
Host codeup.aliyun.com
    HostName codeup.aliyun.com
    User git
    IdentityFile /Users/admin/.ssh/id_rsa
    IdentitiesOnly yes

Host codeup.aliyun.com-fence
    HostName codeup.aliyun.com
    User git
    IdentityFile /Users/admin/.ssh/id_rsa_fence
    IdentitiesOnly yes
```

配置中 Host 是别名, 替换掉原来git地址的Host  
比如 `git clone@codeup.aliyun.com:****/user/proj.git` 替换为 `git clone@codeup.aliyun.com-fence:****/user/proj.git`
