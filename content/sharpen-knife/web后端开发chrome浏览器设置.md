---

title: web后端开发chrome浏览器设置

date: 2022-05-14

slug: "chrome-setting"
tags:
- development
- chrome

---

## 切换 host 之后，清除 dsn 缓存

访问链接 

chrome://net-internals/#sockets

![](/images/Untitled-c5ec35a6-d386-4add-8134-4a5346274483.png)

点击 `Flush socket pools` 一次，其他都不用点击了。

## 搜索引擎设置

访问搜索引擎设置页面

chrome://settings/search

管理搜索引擎和网站搜索-网站搜索-添加

![](/images/Untitled-39424c68-fbec-4309-b10a-f352744323ce.png)
1. `cmd/ctrl` + `L`  定位到浏览器链接输入框，
2. 输入 `dict` 按下 `Tab`  
3. 输入想要翻译的单词
4. 按下 `Enter`

看似四步，简单上手后一气呵成！

### 多搜索引擎管理

不同的搜索内容，应该使用不同的搜索引擎，就像你不能在 baidu 搜索技术关键词一样。

你可以设置，google搜索，输入 `goo` 按下 `Tab` ，输入搜索词，按下回车。

同样可以设置，baidu搜索，输入 `baidu` 按下 `Tab` ，输入搜索词，按下回车。

### 链接快捷访问

网址中不使用搜索字词占位符 “%s” ，那么输入快捷字词后可以直接按下回车访问链接了。

# 插件

### **Web开发者助手 FeHelper**

[https://www.baidufe.com/fehelper/index/index.html](https://www.baidufe.com/fehelper/index/index.html)

最常用的是 `JSON美化工具`、 `时间戳转换`

还有很多其他工具，随机密码生成，页面取色等等

结合上文中的 `链接快捷访问`

你可以 设置 在 链接栏输入 `json` 快速访问 `JSON美化工具`，输入 `ts` 快速访问 `时间戳转换`

### Website IP

[https://chrome.google.com/webstore/detail/website-ip/ghbmhlgniedlklkpimlibbaoomlpacmk](https://chrome.google.com/webstore/detail/website-ip/ghbmhlgniedlklkpimlibbaoomlpacmk)

这个插件只有一个用途，就是在网页的右下角显示当前网址的 IP 地址。这非常有用，判断当前是测试环境还是生产环境，切换 host 之后可以快速验证。

虽然 IP 地址只有一小部分，但是还是遮挡部分页面，插件开发者也考虑到这点，你可以把鼠标移动到 IP 的位置，这是 IP 文字就会乖乖的跑到左下角了，光标再次移到左下角亦然。

### ****SwitchyOmega****

这是一个代理工具