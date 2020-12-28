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


- **trim**[^trim]

```php
<?php
echo trim("<p></p><p>pikachu hello world</p>", "<p></p>");

输出：
ikachu hello world
```
trim 第二个可选字符串参数 $character_mask 的含义是把第二参数字符串中的所有字符，从输入中剔除；

<!--more-->

- **explode**[^explode]

```php
<?php
var_export(explode(",", ""));

输出；
array (
  0 => '',
)
```
一般期望是个空数组，但返回是包含1个元素的数组，（细细回想，这个返回值是有其道理）



[^trim]: **trim**  [trim at php.net](https://www.php.net/manual/zh/function.trim.php)
[^explode]: **trim**  [explode at php.net](https://www.php.net/manual/zh/function.explode.php)

todo