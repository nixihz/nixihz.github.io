---
title : "PHP的函数中意想不到的坑"
description : "PHP的函数中意想不到的坑"
tags :
  - "php"
date : "2020-10-03"
categories : 
  - "develop"
  -  "php"
menu : "main"
---

## strtotime[^strtotime]

```php {hl_lines=[2]}
<?php
echo date("Y-m-d", strtotime("-1 month"));
```

假设今天是2019-07-31,
输出：
2019-07-01

1. 先做-1 month, 那么当前是07-31, 减去一以后就是06-31.
2. 再做日期规范化, 因为6月没有31号, 所以就好像2点60等于3点一样, 6月31就等于了7月1


[^strtotime]: **strtotime**  [令人困惑的strtotime - 鸟哥](https://www.laruence.com/2018/07/31/3207.html)

## trim[^trim]


```php {hl_lines=[2]}
<?php
echo trim("<p></p><p>pikachu hello world</p>", "<p></p>");
```

输出：
ikachu hello world

trim 第二个可选字符串参数 $character_mask 的含义是把第二参数字符串中的所有字符，从输入中剔除；

<!--more-->
[^trim]: **trim**  [trim at php.net](https://www.php.net/manual/zh/function.trim.php)

## explode[^explode]

```php {hl_lines=[2]}
<?php
var_export(explode(",", ""));

```
输出:
```
array (
  0 => '',
)
```

一般期望是个空数组，但返回是包含1个元素的数组，（细细回想，这个返回值是有其道理）

[^explode]: **trim**  [explode at php.net](https://www.php.net/manual/zh/function.explode.php)

持续更新