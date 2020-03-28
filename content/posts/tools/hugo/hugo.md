---
title : Hugo 基本技巧
description : Hugo 基本技巧
tags:
date: 2020-03-27
categories:
weight: 1
---


*以 book theme 示例*

## Hugo 添加自定义 css 和 javascript

public 目录是最终目录，

Hugo 会把根目录 /static 文件拷贝到 public 下。首先把 js css 拷贝到static 文件夹。示例

<!--more-->

```ssh
/public
/static
├── audio
├── css
│   └── audio.css
├── js
│   └── audio.js
└── speech.mp3
```

[http://localhost:1313/js/audio.js](http://localhost:1313/js/audio.js)  
[http://localhost:1313/css/audio.css](http://localhost:1313/css/audio.css)  
[http://localhost:1313/speech.mp3](http://localhost:1313/speech.mp3)


编辑 `theme/book/layouts/_default/baseof.html`

```html
<html>
    <head>
       ...
        <link rel=stylesheet href="/css/audio.css" >
    </head>
    <body>
        ...
        <script src="/js/audio.js"></script>
    </body>
</html>
```  

## 为每个特定 post 页面指定 js 和 css 文件

hugo 模版支持变量， 如下即可自定义参数。

```markdown

---
title : Hugo 基本技巧
description : Hugo 基本技巧
tags:
date: 2020-03-27

js1: "/se/js/audiojs/audio.min.js"
js2: "/se/js/audiojs/custom.js"
css1: "/se/js/audiojs/custom.css"
---
```

模版中获取变量方式 如下: `.Params.css1`

```html
{{ if ".Params.css1" }}
<link rel=stylesheet href="{{ .Params.css1 }}" >
{{ end }}

...

{{ if ".Params.js1" }}
<script src="{{ .Params.js1 }}"></script>
{{ end }}
{{ if ".Params.js2" }}
<script src="{{ .Params.js2 }}"></script>
{{ end }}
```


