---
title : 六、MySQL 建表原则
description : Mysql 建表原则
tags:
 - mysql
date: 2020-01-02
categories:
 - "mysql"
weight: 6
---


MySQL 建表原则， 常见面试题

<!--more-->

# 一、合适的数据类型

## 原则
1. 更小的数据类型，不滥用类型  
    占用更少的磁盘、内存、CPU缓存，CPU周期也更少
2. 简单存储  
    DataTime 存储日期和时间，而不是"字符串"
    整型存储IP地址，而非字符串， INET_ATON / INET_NOTA
3. 尽量避免 NULL
    列如果可为 NULL，MySQL更难优化；  
    如果该列需要索引，则需要更多空间；
    
    如果需要加索引，那么必须设置为 NOT NULL。
4. 少列
5. 少关联， 12表以内
6. 更快地读，更慢地写，（读是大部分项目的大部分操作）

## 类型细节

整型
1. TINYINT， SMALLINT， MEDIUMINT，INT，BIGINT
2. INT(1)和INT(20) 存储相同，客户端显示字符个数

实数
1. FLOAT,DOUBLE,DECIMAL
2. DECIMAL 存储精确小数， 而计算时则转化为DOUBLE

字符串
1. VARCHAR, CHAR
2. 不定长字符串比定长更省资源。
3. CHAR 裁剪末尾空格；
4. VARCHAR需要额外字节记录字符串长度；
5. VARCHAR(5) 和 VARCHAR(20) 存储 'hello', 存储开销一样，
    但是后者内存消耗更多。 


以下情况优先使用 VARCHAR
1. 字符串的最大长度比平均长度大很多；
2. 列更新少，因为经常更新容易碎片。
3. 使用UTF-8 这样复杂的字符集,  每个字符都使用了不同字节数进行存储。

以下情况使用 CHAR
1. CHAR 用来存储MD5这类定长的值。
2. 经常更新的数据，因为定长，所以不容易产生碎片。
3. CHAR(1) 存储 Y / N

BLOB 和 TEXT

用来存储很大的数据，分别是二进制和字符串形式存储。 Memory 引擎不支持该类型。

TINYBLOB,SMALLBLOB,BLOB,MEDIUMBLOB, LONGBLOB  
BLOB = SMALLBLOB  
TEXT，同理

实际存储，采用"外部"存储，列中存储指针。

实际排序只采用， max_sort_length, 如果针对小部分排序，一个是减小 max_sort_length;
或者使用 ORDER by SUBSTRING(column, length).


```
EXPLAIN，执行计划的Extra，包含 Using temporary， 说明使用了隐式临时表。

```

使用 枚举 ENUM 代替字符串类型, 节约空间，  
用在 重复度很高的地方，并且不会变化的地方，  
实际存储的是整型。  

` 注意排序使用的整型，而不是实际的字符串。。。 所以需要按照顺序定义枚举`

关联表必须使用整数组件。


时间

DATETIME 范围大 1001-9999年  
TIMESTAMP 范围小，存储一半，效率高， 1907 - 2038年

时间到秒， 但是计算是毫秒， 可以改为 MariaDB，或者使用 BIGINT 存储s，使用 DOUBLE 存储毫秒。


位

BIT




SET




## 范式和反范式

* 1NF，属性不可再分， (现在出现了sql，map这样的)
* 2NF，关联
* 3NF，

优点：
1. 范式更新比反范式块
2. 范式无重复数据
3. 范式化表更小，操作更快
4. 范式化，需要独立的表，不太需要使用 distinct 或者 group by；
5. 反范式，冗余某些数据

缺点：
1. 范式需要关联，可能导致索引策略无效。

注意范式和反范式的混合使用。


## 缓存表和汇总表

1. 缓存表，比如多张表关联查询的更少的字段。
2. 汇总表，记录累计结果的。

定期维护数据，定期重建，解决碎片问题，处理有效的索引。

可以使用"影子表"， 背后创建，结束了在使用重命名方式。


## 加快ALTER TABLE 操作速度

影子拷贝， 工具有 Percona Toolkit.
 
比如使用 ALTER COLUMN 替代 MODIFY COLUMN 来修改默认值。

这种方法是修改 .frm 。

以下操作不需要重建表
1. remove 一个列的 auto_increment 属性，
2. 增加，一处，或者更改ENUM和SET常量，

通过修改 .frm 文件来实现目的。


快速创建 MyISAM 索引。。

1. 禁用索引，载入数据，重新启用索引；  
不支持唯一索引， 删除索引记得保留唯一索引。


 
## 创建高性能索引

先理解索引。

### 一、底层的类型

#### 1. B-Tree 索引

如果没有特殊说明，那么多半说的就是B-Tree索引类型。

key(姓, 名, 出生日期)

key(last_name, first_name, dob)

最左前缀查找，以下是有效查询：

* 全值匹配  
    姓 + 名 + 出生日期，全值匹配，第一列，第二列，第三列
* 匹配最左前缀  
    姓， 只查看索引第一项
* 匹配列前缀  
    substring(姓, 0, 1) 用到了第一列索引
* 匹配范围值  
    姓>'allen' and 姓<'Barrymore' 用到了第一列索引
* 精确匹配某一列并范围匹配另外一列  
    姓=='allen' and (名>'jelly' and 名<'rock'), 第一列全匹配，第二列范围匹配
* 只访问索引的查询
    B-Tree 覆盖索引

同时，也支持 ORDER BY 这种类型。

B-Tree 索引限制：

* 非最左列开始查找，则无法使用索引。比如无法查 姓'%oodjob'；
* 不能跳过索引中的列，比如，姓+出生日期，则只能用第一列索引；
* 查询了某一列的范围，则右边的列，都无法使用索引； 



#### 2. HASH 索引

hash 表实现， 精确匹配索引所有的列查询才有效。
非常快； Memory 表中默认类型， 也支持B-Tree

限制：
* 哈希哈希只包含哈希值和行指针， 不能用来避免读取行。
* 无法用来排序。
* 不可使用部分索引，HASH(A,B)， 必须AB两列都要查询。
* 只能用来等值查询 = , IN, <=>(与NULL值的比较) , 
* 多哈希相同，则找出所有的，然后遍历；
* 冲突多，维护的代价也很高，比如删除；
 
适用于限定场合， 数据仓库中经典的 星型 schema，需要关联很多查找表。可以使用 哈希索引；

自适应哈希索引：  
InnoDB 注意到某些索引用的很频繁，则再次智商在创建一个哈希索引。是一个自动的，内部的行为， 无法控制，但是可开关。



`创建自定义哈希索引`
 
url作为长字符串，使用B-Tree，索引太麻烦，如果常用的全职匹配，则可以增加一列，比如 url_crc， 值是经过 crc32 哈希之后在入库，
之后查询就是 where url_crc=CRC32('http://goodjob.com');

非常高效。 可以使用触发器。


#### 3. 全文索引


// todo


### 二、高性能索引策略

#### 独立的列

索引列不能是表达式的一部分，也不能是函数的参数。


#### 前缀索引和索引选择性


有时索引很长的字符串，一个策略是 哈希索引，另外一个策略是索引开始的部分字符。

计算前缀可能性， 需要有一定量的数据， 然后通过一个公式，
n=长度， f(n) 约等于 0.031 ，这个长度 n 的索引就够用了。

```sql

select count(distinct left(city,3))/count(*) as sel3,
 count(distinct left(city,4))/count(*) as sel4,
  count(distinct left(city,5))/count(*) as sel5,
   count(distinct left(city,6))/count(*) as sel6,
    count(distinct left(city,7))/count(*) as sel7
    from test.test;

```

优点：  
更小，更快

缺点：  
无法使用前缀索引作 ORDER BY 和 GROUP BY， 也无法做覆盖扫描。 // todo


后缀索引，也有用，比如某个公司的邮箱，
mysql 不支持后缀索引，这时，可以先反转字符串。


#### 多列索引



























