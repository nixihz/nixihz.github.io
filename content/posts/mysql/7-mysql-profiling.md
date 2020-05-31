---
title : 七、Mysql 性能问题定位
description : Mysql 性能问题定位
tags:
 - mysql
date: 2020-01-02
categories:
 - "develop"
 - "mysql"
weight: 7
---


本文介绍 Mysql 性能问题定位。

慢查询日志 和 Percona Toolkit
pt-query-digest

https://www.percona.com/doc/percona-toolkit/2.2/installation.html

<!--more-->

# 定义
性能： 完成某件任务所需要的时间度量。

根据 amdahl 阿姆达尔定律，要想获得性能有效提升，必须优先优化最耗时的部分。

所以做性能优化最重要的是测量响应时间花在哪里，以及为什么花在哪里。

where and why

任务耗时可以分两部分：`执行时间`和`等待时间`  
1. 执行时间： 最好的方法是测量定位不同的子任务花费的时间。对子任务进行优化效率/去掉/降低频率操作；
2. 等待时间：复杂一点，可能是系统其他任务间接影响， 磁盘/CPU资源。

千万不要试图通过某些方法修改参数，什么的试错的方式来看有没有可能解决问题。可能会变得更糟糕，比如没有足够理由地升级版本。

# 剖析步骤

## 找到慢 SQL

1. 慢查询
    1. 一定要开，注意旋转，I/O无影响，CPU密集型受到影响更大
    2. 分析工具： pt-query-digest
```bash

书本 p 92 页， awk 语句


```
2. show full processlist; 粗粒度
3. Percona Toolkit

## 剖析单个 SQL

1、 show profiles

```sql
mysql> set profiling = 1;
mysql> show profiles;

mysql> show profile for query 1;


不能 排序。

用sql 转化， 见 83 页

```

2、 show status

```sql

show status where Variable_name like 'Handler%' or Variable_name like 'Created%';

```

3、EXPLAIN 查询执行计划， 检查索引使用情况，
4、尝试修改WHERE排查命中缓存情况，

## 单个sql还是服务器问题

慢查询是否表现一致，是，服务器问题，否，单sql问题。


## show global status

todo P97

## show processlist


# 偶发问题

Threads_running 的趋势可以看出问题所在；  
show processlist 中线程的异常状态尖峰也是不错的指标； 
```sh 
$mysql -e 'show processlist \G' | grep -c "State: freeing items"

```

show innodb status 特定输出：   
服务器的平均负载尖峰。  

Percona Toolkit 的 pt-stalk

oprofile  linux 内置的性能工具。
strace 剖析服务器的系统调用， （生产环境有一定风险）。

tcpdump 来监听慢查询，（如果不能打开慢查询日志）。


## 问题采集

1. 查询：
    1. 索引扫描
    2. 范围扫描
    3. 全表扫描
    4. 表关联查询
2. 每秒排序次数和行数
3. 临时表
    1. 临时表数量
    2. 内存临时表还是磁盘临时表(超过 tmp_table_size max_heap_table_size)
4. 锁 lock table
5. innodb的查询缓存问题
6. show innodb status
7. 每秒捕获一次 iostat， 持续30s
8. vmstat 检查

    
    
