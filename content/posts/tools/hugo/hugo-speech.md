---
title : Hugo 支持博客朗读
description : Hugo 支持博客朗读
tags:
date: 2020-03-27
categories:
weight: 1
---

## 博客朗读 <audio preload="none"/>
如果博客篇幅较长，有时候文字难免密密麻麻，看着头晕，那为何不增加一个语音朗读博客的功能呢？
如果文章里有些病句或者语句不通顺，也可通过重新听语音来判断，并予以纠正。

说干就干。

<!--more-->

## 思路 <audio preload="none"/>

得益于上一篇文章：[《hugo如何播放mp3文件》](/posts/tools/hugo/hugo-audio)，我们知道了该如何在文章中插入 mp3 播放组件，
那么我们要做的就剩下两步：
1. 分析博客内容
2. 文字转语音

**第一步：分析博客内容**

直接分析 Markdown 文件，暂时找不到好的解析器，决定在 Hugo 编译了 Html 文件之后，再分析 Html 文件来提取文字。

一篇博客可能包含代码，所以我计划只在关键位置增加朗读功能。  
首先编辑文章时，在需要朗读的位置插入audio组件，这样我们就知道朗读内容的开始。不断检测下一个节点，把文字追加到待转语音文字变量里，直到再次遇到 audio组件节点或者是 H1和H2这类关键节点。


**第二步：文字转语音**

文字转语音有很多解决方案，我选择了 Google 方案，嗯，没有原因。
直接上代码，基本官网示例就能用了。[创建语音音频文件示例](https://cloud.google.com/text-to-speech/docs/create-audio)

文件保存到 public文件夹中，同时把 mp3 路径回写到 html 文件中。


由于 Hugo 是 Go 语言开发的，所以这个小插件也用 Go 语言开发。我们把程序编译成可执行文件并拷贝到 Hugo 博客源目录，
每次执行 Hugo 编译后再次执行该文件，达成目标。


###### 示例代码

{{< tabs "uniqueid" >}}
{{< tab "1.分析博客内容" >}}

go解析html文件可以使用 `github.com/PuerkitoBio/goquery`


```go
...

func deal(filePath string, assetsPath string) {
	f, err := os.OpenFile(filePath, os.O_RDONLY, 0777)
	doc, err := goquery.NewDocumentFromReader(f)
	defer f.Close()

    // 查找 audio 找到语音朗读起点
	doc.Find("audio").Map(func(i int, selection *goquery.Selection) string {
		parentType := selection.Parent().Nodes[0].DataAtom

		isEnd := false
		textSpeech := ""
		nextItem := selection.Parent().Next()
		for !isEnd {
			item := nextItem.Nodes[0]
			// 遇到同级则停止
			if item.DataAtom == parentType {
				isEnd = true
				continue
			}
			var head1 = [] atom.Atom{
				atom.H1,
				atom.H2,
				atom.H3,
				atom.H4,
				atom.H5,
				atom.H6,
			}
			// 遇到h1～h6则停止
			if contains(head1, item.DataAtom) {
				isEnd = true
				continue
			}
			// 遇到audio则停止
			if nextItem.Find("audio").Length() > 0 {
				isEnd = true
				continue
			}

			textSpeech += "。" + nextItem.Text()
			nextItem = nextItem.Next()
		}

		// 文字转语音
		speech.TextToSpeech(textSpeech, assetsPath, true)

		fileName := md5.Sum([]byte(textSpeech))
		filename := hex.EncodeToString(fileName[:]) + ".mp3"

		// 更新audio节点的src
		selection.SetAttr("src", "/audio/"+filename)
		return ""
	})
	// 更新audio节点的src之后，再重新回写到 html 文件
	f, err = os.OpenFile(filePath, os.O_RDWR|os.O_TRUNC|os.O_CREATE, 0777)
	if err != nil {
		fmt.Println("read fail", err)
	}
	htmlContent, err := doc.Html()
	_, err = f.Write([]byte(htmlContent))
	defer f.Close()
}

```

 {{< /tab >}}
{{< tab "2.文字转语音" >}}

```go
package speech

import (
	"context"
	"crypto/md5"
	"encoding/hex"
	"fmt"
	"io/ioutil"
	"log"

	texttospeech "cloud.google.com/go/texttospeech/apiv1"
	texttospeechpb "google.golang.org/genproto/googleapis/cloud/texttospeech/v1"
)

func TextToSpeech(text string, assetsPath string, isFemale bool) string {
	ctx := context.Background()

	client, err := texttospeech.NewClient(ctx)
	if err != nil {
		log.Fatal(err)
	}
	var ssmlGender = texttospeechpb.SsmlVoiceGender_MALE
	if isFemale {
		ssmlGender = texttospeechpb.SsmlVoiceGender_FEMALE
	}
	req := texttospeechpb.SynthesizeSpeechRequest{
		Input: &texttospeechpb.SynthesisInput{
			InputSource: &texttospeechpb.SynthesisInput_Text{Text: text},
		},

		Voice: &texttospeechpb.VoiceSelectionParams{
			LanguageCode: "zh-CN",
			SsmlGender:   ssmlGender,
		},
		// Select the type of audio utils you want returned.
		AudioConfig: &texttospeechpb.AudioConfig{
			AudioEncoding: texttospeechpb.AudioEncoding_MP3,
			SpeakingRate:  1.1,
			Pitch:         1,
		},
	}

	resp, err := client.SynthesizeSpeech(ctx, &req)
	if err != nil {
		log.Fatal(err)
	}

	// The resp's AudioContent is binary.

	fileName := md5.Sum([]byte(text))
	filename := hex.EncodeToString(fileName[:]) + ".mp3"
	err = ioutil.WriteFile(assetsPath+"/"+filename, resp.AudioContent, 0644)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("%v\n", filename)

	return filename
}

```
 
 {{< /tab >}}
{{< /tabs >}}
