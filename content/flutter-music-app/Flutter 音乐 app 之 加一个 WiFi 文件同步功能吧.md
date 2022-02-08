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

先看下实际效果图吧！

![](/images/image_(11)-0c06e0c2-7dec-493f-9900-26199e5dd531.jpg)

## Flutter 启动 http 服务

使用 内置的  HttpServer ，代码如下：

````Dart
    import 'dart:io';
    
    
    server = await HttpServer.bind(
        hostIp,
        8080,
    );
````

这就启动了一个 http 服务，这不是搞笑呢吗？请求咋处理，静态资源咋放这咋没说呢，稍候我先去吃个饭。

## 服务路由

 

由于该服务只有特定的几个功能，创建文件夹，获取列表，上传文件，删除文件，以及前端页面文件，所以路由功能直接根据 request uri ，进行 switch case 即可，代码如下：

````Dart
    // runZoned 捕获异步异常
        var runZoned2 = runZoned(() async {
          await for (var request in server) {
            switch (request.uri.toString().split("?").first) {
              case '/upload':
                _uploadController(request);
                break;
              case '/musicList':
                _musicListController(request);
                break;
              case '/deleteMusicInfo':
                _deleteMusicController(request);
                break;
              case '/createFold':
                _createFoldController(request);
                break;
              case '/':
                _homeController(request);
                break;
              default:
                _publicController(request);
                break;
            }
          }
        }, onError: (Object obj, StackTrace stack) {
          print(obj);
          print(stack);
        });
      }
````

### 请求前端文件

前端功能不复杂，但是有一些交互，直接用 Vue 写一个 SPA，来的快一些。vue 打包以后把所有的文件放在  `{project}/assets/httpserver/` 文件夹下即可访问。

比较难受的是，http 响应头  Response Header 中 `ContentType`  `Content-Length` 等要自己写，不能自动识别，这个比较考验 http 基本概念的理解了，如果有更好的实现方式，请留言，先谢过了。

 

````Dart
    // http 的静态资源资源
      _publicController(HttpRequest request) {
        String filePath = "assets/httpserver/public" + request.uri.path.toString();
        String filetype = filePath.split('.').last;
        String type1 = 'text';
        String type2 = 'html';
        if (filetype == 'html') {
          type2 = 'html';
        } else if (filetype == 'js') {
          type1 = 'application';
          type2 = 'javascript';
        } else if (filetype == 'css') {
          type2 = 'css';
        } else if (filetype == 'ico') {
          type2 = 'ico';
        } else if (filetype == 'png') {
          type1 = 'image';
          type2 = 'png';
        } else if (filetype == 'map') {
          type2 = 'html';
        } else if (filetype == 'woff') {
          type1 = 'font';
          type2 = 'woff';
        }
    
        if (type2 == "woff" || type2 == "ttf" || type2 == "ico" || type2 == "png") {
          rootBundle.load(fielPath).then((value) {
            request.response
              ..headers.clear()
              ..headers.contentType =
                  new ContentType(type1, type2, charset: "UTF-8")
              ..headers.set("Accept-Ranges", "bytes")
              ..headers.set("Connection", "keep-alive")
              ..headers.set("Content-Length", value.lengthInBytes)
              ..add(value.buffer.asUint8List())
              ..close();
          });
        } else {
          rootBundle.load(fielPath).then((value) {
            request.response
              ..headers.clear()
              ..headers.contentType =
                  new ContentType(type1, type2, charset: "UTF-8")
              ..headers.set("Accept-Ranges", "bytes")
              ..headers.set("Connection", "keep-alive")
              ..headers.set("Content-Length", value.lengthInBytes)
              ..write(utf8.decode(value.buffer.asUint8List()))
              ..close();
          });
        }
      }
````

### 请求功能接口

相较于静态文件，接口反而简单点，以 `音乐列表` 示例： 

功能：传入一个 文件路径，获取该路径下的音乐文件列表。

- 获取 GET 参数 path： `request.uri.queryParameters["path"]`
- 从 sqlite 读取数据
- 按照与前端约定的格式响应 json

````Dart
    
    // 列表页
      _musicListController(HttpRequest request) async {
        HttpBodyHandler.processRequest(request).then((body) async {
          String musicPath = request.uri.queryParameters["path"];
    
          // 从 sqlite 读取数据
          DBProvider.db.getMusicInfoByPath(musicPath).then((onValue) {
            Map map = new Map();
            map["List"] = onValue;
            map["Total"] = onValue.length;
    
            // HttpServerUtils 代码文件见附录：
            HttpServerUtils.response(request, 200, "Success", map);
          });
        });
      }
````

## 附录：

HttpServerUtils.dart

````Dart
    import 'dart:convert';
    import 'dart:io';
    
    class HttpServerUtils {
    
      static response(HttpRequest httpRequest, int code, String msg, Map data) {
        var resp = "{}";
    
        Responses response =
            new Responses(data: data, code: 200, message: "Success");
        resp = jsonEncode(response);
    
        httpRequest.response
          ..headers.clear()
          ..headers.contentType =
              new ContentType("application", "json", charset: "UTF-8")
          ..headers.set("Accept-Ranges", "bytes")
          ..headers.set("Connection", "keep-alive")
          ..headers.set("Content-Length", utf8.encode(musicInfoJson).length)
          ..add(utf8.encode(resp))
          ..close();
      }
      
    }
    
    // 自定义响应的格式
    class Responses {
    
      final Map data;
      final int code;
      final String message;
    
      Responses({this.data, this.code, this.message});
    
      Map toJson() {
        Map map = new Map();
        map["Data"] = this.data;
        map["Code"] = this.code;
        map["Message"] = this.message;
        return map;
      }
    }
````