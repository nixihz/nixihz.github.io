---
title : Yii 2 开发环境允许跨域，解决 Access-Control-Allow-Origin 
description : Yii 2 解决 vue 调试问题，跨域和携带cookie。
tags:
 - redis
date: 2020-01-02
categories:
 - "develop"
 - "redis"
weight: 1

---

Yii 2 解决 vue 调试问题，跨域和携带cookie。

<!--more-->

## 问题一 跨域

调试时前端域名自然是 0.0.0.0:8080， 服务端域名可能是 *.be.com, uri 跨域了！

第一种方案是：让服务端允许跨域，响应中添加几个header值即可
``` php
<?php
// php 示例
header("Access-Control-Allow-Origin: http://0.0.0.0:8080");
// 或者
header("Access-Control-Allow-Origin: *");

```

第二种方案是：前端 vue 设置 proxyTable
```javascript
// config/index.js
module.exports = {
    port: 8080,       // 项目开发时本地端口
    host: '0.0.0.0',  // 项目开发时本地地址
    proxyTable: {
        '/backendapi': {         // 模版框架
            target: 'http://be.com',
            changeOrigin: true,
            pathRewrite: {
                '^/backendapi': 'api'
            }
        },
    }
}
```

第二种方案非常棒，果断采纳！  
事情往往没有想象的简单，服务端老代码，使用了 cookie-session 作为登录标识，并且使用的是单点登录，一旦服务端接口判定没有登录，是通过302 跳转到另一个域名进行sso❓❓❓，服务端必须改动点什么了。

## 问题二 跨域携带cookie

```javascript
// 允许跨域携带 cookie
let axiosInstance = axios.create({
    withCredentials: true,
})

```

```php

header("Access-Control-Allow-Origin: http://0.0.0.0:8080");
header("Access-Control-Allow-Credentials: true");
header('P3P: CP="CURa ADMa DEVa PSAo PSDo OUR BUS UNI PUR INT DEM STA PRE COM NAV OTC NOI DSP COR"');

```

```php
<?php

// config/main-dev.php
$config = [
    // ...
    'components' => [
        // ...
        'session' => [
            'name' => 'qimao-backend',
            'cookieParams' => [
                'httpOnly' => false, //必须设置 httpOnly 为false，js 才能跨域携带cookie
                'sameSite' => 'none', // sameSite 必须 none，js才能跨域携带cookie
                'secure' => true, // sameSite为none，则必须设置 secure 为true，也就是需使用 https 
            ],
        ],
        // ...
    ],
    // ...
];

```
有3个注意点:  
1. 必须设置 httpOnly 为false，js 才能跨域携带cookie
1. sameSite 必须 none，js才能跨域携带cookie
1. sameSite为none，则必须设置 secure 为true，也就是需使用 


## 
前端拿到代码直接执行 `cnpm run dev` 就可以开心开发了