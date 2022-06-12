---

title: 在多台计算机上共享一套鼠标和键盘 Synergy

date: 2022-05-24

slug: "share-mouse-keyboard"
tags:
- development
- synergy

---

2022年了，多台设备，使用一套键鼠的方案有很多。

- 实体线缆实现：绿联USB对拷线（讲真的，不好用，经常断开）
- 实体键鼠：罗技 master-keys 键盘 和 master3 鼠标
- 软件实现：Synergy，29 美刀可以实现最多3台设备共享，39美到支持最多15台，永久支持。
- 如果是你像我一样是 Apple 套装用户，那么恭喜你，解锁了 免费的多台设备共享一套键鼠的能力，后续会更新新一期的内容。（问题是多设备必须离的非常近，测试1.5米以内，而我拿着电脑坐在沙发上拿着MacBook就断开了 Mac Studio了 的通用控制）。

那么，今天只讲 Synergy 实现方案。

# 一、Synergy的使用

先确定需要共享的设备的操作系统类型，前往官网下载对应版本的软件并安装。

[https://symless.com/synergy/download](https://symless.com/synergy/download)

支持系统： macOS windows ubuntu fedora RaspberryPi Debian CentOS

Synergy 共享是通过网络实现，所以必须要确保设备都在同一个局域网内。

是不是非常棒

# 二、Synergy的问题：MacOS 使用 wifi 鼠标移动延迟非常大

其实比较容易排查，打开终端，输入 `ping 192.168.31.1`  注意替换为你自己的路由器网关。

如果延迟有超过100ms，那么 synergy 基本无法正常使用。

所以想办法把 `ping` 的延迟降低，synergy 就可以如丝般顺滑。

目前网上能找到的解决方案基本都是关闭系统中的定位功能。

- 变更无线路由器的Wifi信道
- 关闭系统中的定位功能
- 关闭蓝牙
- 关闭唤醒以供网络访问 (系统偏好设置-电池-电源适配器-取消勾选`唤醒以供网络访问`)

关闭蓝牙绝对是笔者首创，至少我是没有找到相关资料的。而且在我的设备中，只有关闭蓝牙才真正把延迟降低到了10ms以内。