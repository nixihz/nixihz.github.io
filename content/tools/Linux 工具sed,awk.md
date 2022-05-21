---

title: Linux 工具sed,awk

date: 2021-11-02
tags:
- linux

- sed

- awk

---

## Sed

行处理

sed [-nefr] [n1,n2] 动作

````Protobuf
    cat -n /tmp/passwd | sed '2,5s/old/new/g'
````

### 参数

-n 只展示匹配到的数据

-i 直接修改内容，而不是输出到终端

-f 输出写入到文件

-r 支持正则匹配

### 动作

a 下一行追加

c 替换

d 删除

i 上一行插入

p 打印

s 搜索和替换，类似 vim 的查找替换

## Awk

列处理

````Shell
    awk -F"\t"  '{ print $1,$3 }' /var/logs/nginx/access.log
````