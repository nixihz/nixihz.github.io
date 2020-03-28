---
title : Hugo 支持audio播放
description : Hugo 支持audio播放
tags:
date: 2020-03-27
categories:
weight: 1
---

## hugo如何播放mp3文件

纯文本博客有时枯燥无味，试试让网站闹出点声响。  
Hugo 支持 html5 element 节点，所以直接在文章中插入 audio 节点即可:

<!--more-->

`<audio src="/speech.mp3" preload="none" controls="controls"/>`  

<audio src="/speech.mp3" style="background:white;" preload="none" controls="controls" speech="none"></audio>    

<div style="margin-top:100px"></div>

## audio 自定义样式

[http://kolber.github.io/audiojs/](http://kolber.github.io/audiojs/)
  
上篇文章中讲到如何在文章中自定义 js css 文件 [《Hugo自定义js css 文件》](/posts/tools/hugo/hugo/)

下载文件根据上篇文章添加到博客模版中。

