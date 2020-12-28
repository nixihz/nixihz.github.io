---
title : 一、Mysql Mac 安装和使用
description : Mysql Mac 安装和使用
tags:
 - mysql
date: 2020-01-02
categories:
 - "develop"
 - "mysql"
weight: 3
---





#### 一、安装

1、执行安装命令



```bash
brew install mysql
```

2、安装完后启动mysql


<!--more-->

```bash
mysql.server start
```

3、执行安全设置



```shell
mysql_secure_installation
```

显示如下



```bash
There are three levels of password validation policy:

LOW    Length >= 8
MEDIUM Length >= 8, numeric, mixed case, and special characters
STRONG Length >= 8, numeric, mixed case, special characters and dictionary                  file
```

按照提示选择密码等级，并设置root密码

#### 二、创建新的数据库、用户并授权

1、登录mysql



```bash
mysql -u root -p
```

按提示输入root密码



```bash
root@poksi-test-2019:~# mysql -u root -p
Enter password: 
```

2、创建数据库



```sql
create database testdb character set utf8mb4;
```

3、创建用户



```sql
create user 'testtest_u'@'%' identified by 'testtest_PWD_123';
```

4、授权用户



```sql
grant all privileges on testdb.* to 'testtest_u'@'%';
```



```sql
flush privileges;
```

5、查看当前的数据库



```sql
show databases;
```

6、显示当前数据库的表单



```sql
show tables;
```

#### 三、建表



```sql
CREATE TABLE t_user(
  key_id VARCHAR(255) NOT NULL PRIMARY KEY,  -- id 统一命名为key_id
  user_name VARCHAR(255) NOT NULL ,
  password VARCHAR(255) NOT NULL ,
  phone VARCHAR(255) NOT NULL,
  deleted INT NOT NULL DEFAULT 0,  -- 逻辑删除标志默认值
  create_time   timestamp NULL default CURRENT_TIMESTAMP, -- 创建时间默认值
  update_time   timestamp NULL default CURRENT_TIMESTAMP -- 修改时间默认值
) ENGINE=INNODB AUTO_INCREMENT=1000 DEFAULT CHARSET=utf8mb4;
```

#### 四、检查mysql服务状态

先退出mysql命令行，输入命令



```bash
systemctl status mysql.service
```

显示如下结果说明mysql服务是正常的



```bash
● mysql.service - MySQL Community Server
  Loaded: loaded (/lib/systemd/system/mysql.service; enabled; vendor preset: enabled)
  Active: active (running) since Wed 2019-05-22 10:53:13 CST; 13min ago
Main PID: 16686 (mysqld)
   Tasks: 29 (limit: 4667)
  CGroup: /system.slice/mysql.service
          └─16686 /usr/sbin/mysqld --daemonize --pid-file=/run/mysqld/mysqld.pid

May 22 10:53:12 poksi-test-2019 systemd[1]: Starting MySQL Community Server...
May 22 10:53:13 poksi-test-2019 systemd[1]: Started MySQL Community Server.
```

