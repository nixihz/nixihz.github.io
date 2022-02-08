---

title: PHPStorm | Visual Studio Code |Vim 熟悉这些特性，提升效率

date: 2021-07-28

---

## PhpStorm

语法错误等提示和检测，调用跳转，代码生成，调试功能，代码全局观，文件管理，版本控制工具，数据库查看，命令行工具，丰富的扩展库。

### 文件检测

目录树选中文件，右击，点击 Inspect code … 执行代码检查

### 跳转

cmd + 鼠标左键

cmd + [  依次返回历史跳转点

cmd + ]  重新回到最新跳转点

### 文件管理

Favorites 文件，根据某个功能特定文件，

Bookmarks

### 代码生成

cmd + n 生成代码，弹框中选择生成 Copyright, Getter Setter，注释等

### 代码补全

输入 fore 按下回车生成 foreach 代码块 （Goland 也有类似的快捷短语）

![](/images/image-20210130-153427-b0bbeba2-773a-4113-882f-64d652a9e211.png)

插件 [PHP Advanced AutoComplete Thomas Schulz](https://plugins.jetbrains.com/plugin/7276-php-advanced-autocomplete) ，可以自动补全，舒心

![](/images/image-20210130-153233-e0beb7ac-0503-4a89-b804-7c0107b22f36.png)

### 定位到当前正在编辑的文件

![](/images/image-20210130-151448-745ec57e-3214-4a69-81ba-3b7e1567af79.png)

### 数据库插件

使用体验与 jetbrains 旗下 Datagrip 非常一致；

可以在项目中增加 sql 文件夹，存放相关sql；

cmd + enter 执行光标所在行的sql语句，可以在弹框选择子查询；

cmd + option + l(小写L) 格式化代码，

cmd + ，设置中搜索 sql 选择 code style， 可个性化配置sql代码风格。

比如关键词全部大写，SELECT 子句逗号前置，SELECT 元素独占一行。

### vim插件

享受各个 IDE 一致性的体验。

### 一些快捷键

|描述|快捷键|
|----|----|
|提交代码|cmd + k|
|推送代码|cmd + shift + k|
|格式化代码|cmd + option + L|
|精简 import 引入|ctrl + option + o|
|全局文本搜索|cmd + shift + f|
|可搜索文件名，配置了数据库，可搜索表名|shift + shift|
|cmd + e|最近打开文件|
|

## Visual Studio Code

### vim插件

享受各个 IDE 一致性的体验。

## Vim

插件

[https://github.com/scrooloose/nerdtree.git](https://github.com/scrooloose/nerdtree.git)

[https://github.com/vim-airline/vim-airline](https://github.com/vim-airline/vim-airline)

[https://github.com/vim-airline/vim-airline-themes](https://github.com/vim-airline/vim-airline-themes)

配置

做好配置，可以放到 git 托管。

[https://github.com/fencex/myvim.git](https://github.com/fencex/myvim.git)

### vim 基础

|按键|说明|
|----|----|
|h j k l|← ↓ ↑ →|
|^|行首|
|$|行尾|
|e|光标移动下一个单词的结尾|
|w|光标移动下一个单词的开头|
|b|光标移动上一个单词的开头|
|gg|第一行|
|最后一行|shit + g|
|ctrl + d|向下翻半页|
|ctrl + u|向上翻半页|
|/|搜索（ linux命令 less 也用 / 来搜索）|
|*|shift + 8 搜索当前光标所在的单词|
|n|向下搜索|
|shift + n|向上搜索|

### 编辑操作

|按键|说明|
|----|----|
|i|进入插入模式|
|esc|退出插入模式|
|dd|删除行|
|dw|删除光标之后的单词|
|d$|删除光标到行尾， d^ 同理|
|yy|复制行|
|p|粘贴|
|u|撤销操作|
|ctrl + r|重做撤销的操作|

### Visual 模式

|按键|说明|
|----|----|
|选择|v|
|shift + v|行选|
|ctrl + v|块选|

一般跟其他命令结合使用，比如 shift + v 选择多行， 再按 d， 删除所选行

### 命令

|说明|按键|
|----|----|
|保存|:w|
|保存并退出，（按住 shift 再按2下 z）|:wq （shift + z + z）|
|退出，如果有修改未保存在不能退出|:q|
|强制退出，有修改未保存也能退出|:q!|
|返回 shell 模式|:sh|
|返回 vim 模式|shell 模式中 输入 exit|
|按行搜索并替换，不加 g 表示替换每行第一次搜索的词，加g表示替换所有；|:%s/待替换/替换为/g|
|:1,4s/待替换/替换为/g|% 表示所有行|
|自定义行|shift + v 行选模式:s|
|定位到第 1000 行|:10000|

### 其他

- shift + j 当前行移动到上一行行尾, 可以做到单列转单行
- shift + u 转换成大写
- ~ 大小写互换