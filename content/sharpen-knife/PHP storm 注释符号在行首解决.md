---

title: PHP storm 注释符号在行首

date: 2021-09-09

---

## 问题

PHP storm 默认设置 `注释快捷键` 设置的行注释 设置在行首，如下：❌

````PHP
            // todo 使用队列, 替换 raise dispatchNow
            $thread->raise(new Created($thread));
    //        ProcessThreadCreated::dispatchNow($thread);
            ProcessThreadCreated::dispatch($thread);
````

使用 `格式化` 功能以后，格式又发生错乱，❌

````PHP
            // todo 使用队列, 替换 raise dispatchNow
            $thread->raise(new Created($thread));
            //        ProcessThreadCreated::dispatchNow($thread);
            ProcessThreadCreated::dispatch($thread);
````

注释时直接 注释在代码前，而非行首，如下：✅

````PHP
            // todo 使用队列, 替换 raise dispatchNow
            $thread->raise(new Created($thread));
            //ProcessThreadCreated::dispatchNow($thread);
            ProcessThreadCreated::dispatch($thread)
````

## 解决

1. 设置， 取消勾选 `Line Comment at first column`

Settings - Editor - Code Style - PHP - Code Generation

![](/images/Untitled-e9e3b8e5-1e48-4d55-bd1d-39128b64b597.png)

1. 自动格式化配置，取消勾选 `Comment at first column` 

Settings - Editor - Code Style - PHP - Wrapping and Braces 

![](/images/Untitled-8af53b70-fb93-4a0e-b061-bf3ee21ba35a.png)