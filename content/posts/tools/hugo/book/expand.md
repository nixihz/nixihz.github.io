---
title : Expand 展开和隐藏

---


<!--more-->


Expand 扩展可以通过隐藏部分文本来帮助减少屏幕混乱。通过单击扩展内容。

## 示例
### 默认

```tpl
{{</* expand */>}}
## Markdown content
Lorem markdownum insigne...
{{</* /expand */>}}
```

{{< expand >}}
## Markdown content
Lorem markdownum insigne...
{{< /expand >}}

### 自定义标签

```tpl
{{</* expand "这是自定义标签" "更多" */>}}
## Markdown content
Lorem markdownum insigne...
{{</* /expand */>}}
```

{{< expand "这是自定义标签" "更多" >}}
## Markdown content
Lorem markdownum insigne. Olympo signis Delphis! Retexi Nereius nova develat
stringit, frustra Saturnius uteroque inter! Oculis non ritibus Telethusa
protulit, sed sed aere valvis inhaesuro Pallas animam: qui _quid_, ignes.
Miseratus fonte Ditis conubia.
{{< /expand >}}
