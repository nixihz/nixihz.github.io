---

title: Flutter 音乐 app 之 加一个 WiFi 文件同步功能吧

date: 2021-02-03
tags:
- flutter
- app
- wifi sync

---

既然是音乐播放器，那得搞些资源放进手机吧，兄弟你看小说吗？很多 app 有通过 Wi-Fi 把书传入手机的功能，效果还行，那就这么搞吧。

简单画一个图：

![](/images/image_(10)-dcdf0bf8-3ba9-4f63-88e4-73ac6c9f6897.jpg)

那么还是先看下实际效果图吧！

![](/images/image_(11)-0c06e0c2-7dec-493f-9900-26199e5dd531.jpg)

## Flutter 启动 http 服务

使用 内置的  HttpServer ，代码如下：

    import 'dart:io';
    
    
    server = await HttpServer.bind(
        hostIp,
        8080,
    );

这就启动了一个 http 服务，这不是搞笑呢吗？请求咋处理，静态资源咋放这咋没说呢，稍后我先去吃个饭。