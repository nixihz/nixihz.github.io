---
title : Redis 版本信息
description : Redis 版本信息
tags:
 - redis
date: 2020-01-02
categories:
 - "develop"
 - "redis"
weight: 5
---

本文介绍 Redis发布周期, 版本兼容和版本特性说明
<!--more-->

# Redis发布周期

Redis 作为系统软件，被各个系统广泛使用，升级会有一定成本，因此发布周期都比较长。

* unstable
* development
* frozen
* release candidate
* stable

# 版本兼容

Redis 尽量向后兼容，比如 2.8 通常向 2.6.x 兼容， 跨版本 2.4 则可能有问题。

在主从配置中，虽然建议是 主从都是用相同的redis 版本， 
但是实际使用中， 低版本的的主 2.6 通常可以接上 高版本的从 2.8;  
而高版本的主2.8 接上 低版本的从 2.6 可能有问题。

# 版本说明

## Redis 6.0

Redis 6在许多关键领域改进了Redis，并且是最大的领域之一，在此仅列出此版本的最大功能：

* 模块系统现在允许开发者使用新API，比如:  
将任意模块私有数据存储在RDB文件中，处理不同服务器事件，捕获和重写命令执行，阻止客户端key等
* Redis重写了过期key的周期，可更快地收回过期key
* Redis全面支持SSL  
Redis现在在所有通道上都支持SSL
* 支持ACL  
可以指定某些用户只能运行某些命令或者访问某些数据结构
* Redis提供了名为`RESP3`的新协议，该协议可返回更多语义答复  
客户端可以得到更明确的返回类型，客户端需要更新以支持此协议
* 服务器端支持键值的客户端缓存。  
这个该功能仍处于试验阶段，接下来的版本会有新的迭代，更多信息 https://redis.io/topics/client-side-caching
* Redis现在可以选择使用多线程来处理I/O，（最大128个线程）  
在单个实例中，每秒能共提供2倍的操作，但 `pipeline` 无法使用此功能
* 无硬盘复制现在支持从库，  
Redis版本2.8.18是支持无盘复制的第一个版本，支持主库直接同步，
现在则支持子进程直接在从库将RDB通过线路发送到从属设备，而不使用磁盘作为中间存储
* Redis-benchmark 现在开始支持 Redis Cluster 模式
* SRANDMEMBER 和其他相似的命令，有更好的随机性
* 改进了 Redis-cli 客户端
* 重写了 Systemd support
* 发布了 Redis Cluster 的代理服务  
   https://github.com/artix75/redis-cluster-proxy
* 发布了 新的Redis module ： Disque，内存中的分布式作业队列  
https://github.com/antirez/disque-module


## Redis 5.0

Redis 5是专注于一些重要功能的发行版。 而Redis 4非常专注于操作，  
Redis 5的更改大部分是面向用户的，在现有数据基础上实施新的数据类型和操作类型。
以下是此版本的主要功能：

* 支持 Stream 类型. https://redis.io/topics/streams-intro
* 增加 Redis Module API：计时器，集群和字典 API
* RDB 存储 LFU and LRU 信息
* 将集群管理器从Ruby（redis-trib.rb）由C改写，`redis-cli --cluster help` 查询更多帮助信息
* sorted set 增加新操作命令: ZPOPMIN/ZPOPMAX （ blocking variants todo 未知）
* 升级碎片整理 version 2
* HyperLogLog 优化底层实现
* 更好的内存报告功能。
* 子命令支持 HELP 
* client 终端经常连接和断开会有更好的性能体现
* 修复若干bug，随机功能的性能提升
* 内存管理 Jemalloc 升级版本到 5.1
* `CLIENT UNBLOCK and CLIENT ID`
* 添加 LOLWUT 功能（计算机美学，实际开发可能用不上） http://antirez.com/news/123
* 如果不是为了向后API兼容，Redis将不再使用“slave”一词
* 网络层中的Differnet优化
* Lua的改进：  
  * 更好地将Lua脚本传输到 Slave(从库) / AOF(AOF追加操作落地)
  * Lua脚本现在可以超时，并且处于`BUSY`状态的从库也支持
* 动态HZ，以平衡空闲CPU使用率和响应速度，  
hz理解为后台任务占用cpu资源
* Redis核心在许多方面得到了重构和改进


## Redis 4.0

## Redis 3.2

## Redis 3.0

## Redis 2.8


* 现在，从站可以与主站部分重新同步，因此大多数情况下，当短短时间断开主从链接时，不需要与主端RDB创建完全重新同步
* 支持 IPv6 （实验性功能）
* 从站现在可以显式ping主机，主机可以独立检测超时的从站
* 可以设置如果没有连接足够多具有给定最大延迟的从站，则主站可以停止接受写操作
* 键空间通过发布/订阅更改通
* CONFIG SET maxclients 现在可使用命令设置最大连接数
* 可以绑定多个ip地址
* 设置 进程
* 设置进程名称，以便您可以在“ ps”命令输出中识别实例的侦听端口，或者该实例是正在保存的子实例
* 崩溃时自动检查内存
* CONFIG REWRITE可以将使用CONFIG SET操作的配置更改具体化到redis.conf文件中
* NetBSD 更友好的代码库
* PUBSUB命令用于发布/订阅自省功能， 列出相关信息，
* 现在可以照原样复制 EVALSHA，而无需为复制链接扩展到完整的EVAL LUA脚本(??)
* 更好的Lua脚本错误报告
* SDIFF性能提升

* 实验特性： 无盘复制 http://redis.io/topics/replication
* 增加 SCAN, SSCAN, HSCAN, ZSCAN 命令
* AOF 如果硬盘不够，则不会 异常退出，并且在硬盘足够的情况下，能够继续正常工作
* 增加 BITPOS: find first bit set or clear in a bitmap.
* Redis-cli更新为使用SCAN而不是通过以下方式RANDOMKEY 进行随机采样
* 提升6倍 info 的速度
* Jemalloc updated to 3.6.0
* 截断的 AOF 也可以重新加载

## Redis 2.6

* 服务器端支持Lua脚本，请参阅http://redis.io/commands/eval
* 虚拟内存已删除（在2.4中已弃用）
* 删除了最大客户端数的硬编码限制，
* AOF低级语义通常更为理智，尤其是在使用 Slaves
* 增加毫秒级的过期策略，相关命令为 PEXPIRE, PTTL
* lists, ziplists hashes 小规模使用该类数据结构存储小数字，可以更好的利用内存
* 从库支持只读功能
* 新的 BIT 操作：BITCOUNT 和 BITOP
* 客户端最大输出缓冲区的软硬限制。您可以为不同类别的客户端（普通，pubsub，从库）指定不同的限制
* 更多增量（较少阻塞）的过期密钥收集算法，实际上，这意味着当大量密钥大约同时过期时，Redis的响应速度更快。
* AOF 能够使用可变参数命令重写聚合数据类型，通常可以生成一个更易于保存，加载且尺寸更小的AOF
* 现在，每个redis.conf指令都可以作为redis-server二进制文件的命令行选项使用，并且具有相同的名称和参数数量。
* 散列表种子随机化，以防止冲突攻击。
* 将大型对象写入Redis时，性能得到改善
* 集成内存测试，请参阅redis-server --test-memory
* 新增 INCRBYFLOAT and HINCRBYFLOAT 命令
* 新的DUMP，RESTORE，MIGRATE命令（从Redis Cluster移植回2.6）
* RDB文件中的CRC64 Checksump
* MONITOR 有更好的输出和行为（现在在执行之前已记录命令）
* Watchdog “看门狗”可调试延迟，慢日志等 CONFIG SET watchdog-period 500
* 重构或重写了核心的重要部分。新的内部API和核心更改允许在新代码的基础上开发Redis Cluster，但是对于2.6，所有集群代码均已删除，并且将在Redis 3.0更加完整和稳定时与Redis 3.0一起发布。
* Redis 启动画面增加 ASCII logo
* 关于内存违规或失败的断言的崩溃报告得到了显着改进，从而使难以捕获的错误的调试更加简单。
* redis-benchmark 提升: 能够运行选定的测试，CSV输出，更快，更好的帮助
* redis-cli改进：--eval用于舒适地开发Lua脚本
* SHUTDOWN 现在支持两个可选参数：“SAVE”和“ NOSAVE”
* INFO输出分为多个部分，该命令现在仅能显示特定的部分
* 有关命令被调用多少时间以及使用了多少执行时间的新统计信息: info commandstats
* 在边缘情况下更可预测的SORT行为。
* 更好地支持大字节序和*BSD系统
* 改进了构建系统
