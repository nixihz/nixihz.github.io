---
title : WEB 安全 - 内容安全策略介绍与使用
description : WEB 安全 - 内容安全策略介绍与使用
tags:
 - web
date: 2020-08-11
categories:
 - web
 - security
weight: 4
bookToc: false

---

内容安全策略 (CSP, Content Security Policy) 是一个附加的安全层，用于帮助检测和缓解某些类型的攻击，包括跨站脚本 (XSS) 和数据注入等攻击。 这些攻击可用于实现从数据窃取到网站破坏或作为恶意软件分发版本等用途。

<!--more-->

# 一、简介
CSP被设计成向后兼容；不支持的浏览器依然可以运行使用了它的服务器页面，反之亦然。不支持CSP的浏览器会忽略它，像平常一样运行，默认对网页内容使用标准的同源策略。如果网站不提供CSP头部，浏览器同样会使用标准的（同源策略）。

开启CSP就如配置您的页面服务来返回Content-Security-Policy HTTP 头部一样简单.

# 二、目标
CSP的主要目标是减少和报告XSS攻击. XSS攻击利用浏览器对从服务器接受的内容的信任。恶意的脚本在受害的浏览器被执行, 因为浏览器相信内容源，甚至当内容源并不是从它应该来的地方过来的。

早些年，javascript 刚出来的时候，是非常不安全的，经常爆出漏洞，为了安全，浏览器都有一项配置项，禁止脚本执行，但现在的进入web3.0，todo，禁止脚本执行的结果，可能是网站都不能正常运行。

仅仅支持 HTTPS 传输数据，代理服务器上控制 HTTP 页面重定向到 HTTPS 页面

# 三、用法

## 3.1 开启安全策略

你可以使用  Content-Security-Policy HTTP头部 来指定策略，像这样:

```shell
Content-Security-Policy: policy
```


policy参数是一个包含了各种描述你的CSP策略指令的字符串。

### 3.1.1 常用示例

#### 示例1

{{< expand "所有内容均来自站点的同一个源（不包含子域名）" "展开" >}}
```shell
Content-Security-Policy: default-src 'self'
```
{{< /expand >}}

#### 示例2
{{< expand "允许内容来自信任的域名及其子域名" "展开" >}}
```shell
Content-Security-Policy: default-src 'self' *.trusted.com
```
{{< /expand >}}

#### 示例3

{{< expand "允许加载任何源的图片， 限制音频/视频来源，限制脚本来源" "展开" >}}
```shell
Content-Security-Policy: default-src 'self'; img-src *; media-src media1.com media2.com; script-src userscripts.example.com
```


- 图片可以从任何地方加载(注意 "*" 通配符)。  
- 多媒体文件仅允许从 media1.com 和 media2.com 加载(不允许从这些站点的子域名)。  
- 可运行脚本仅允许来自于userscripts.example.com。 

{{< /expand >}}



#### 示例4
{{< expand  "所有内容都要通过SSL方式获取，以避免攻击者窃听用户发出的请求。" "展开">}}
```shell
Content-Security-Policy: default-src https://onlinebanking.jumbobank.com
```

该服务器仅允许通过HTTPS方式并仅从onlinebanking.jumbobank.com域名来访问文档。
{{< /expand>}}


## 3.2 策略触发上报


策略触发上报报文示例：

```json
{
  "csp-report": {
    "document-uri": "http://example.com/signup.html", //发生违规的文档的URI。
    "referrer": "", //违规发生处的文档引用（地址）。
    "blocked-uri": "http://example.com/css/style.css", //被CSP阻止的资源URI。如果被阻止的URI来自不同的源而非文档URI，那么被阻止的资源URI会被删减，仅保留协议，主机和端口号。
    "violated-directive": "style-src cdn.example.com", //违反的策略名称。
    "original-policy": "default-src 'none'; style-src cdn.example.com; report-uri /_/csp-reports", //在 Content-Security-Policy HTTP 头部中指明的原始策略。

    "disposition": "",
    "effective-directive": "",
    "script-sample": "",
    "status-code": "",
  }
}
```

四、实践


## 参考
 
- [官网 https://www.w3.org/TR/CSP](https://www.w3.org/TR/CSP/)
- [浏览器支持情况 https://caniuse.com/#search=csp](https://caniuse.com/#search=csp)

caniuse.com 是一个神奇的网站。：D