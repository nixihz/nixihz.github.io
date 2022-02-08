---

title: Curl 指定 IP 访问等常规用法总结

date: 2021-10-02
tags:
- curl

---

## -- resolve 指定ip访问

````Shell
    curl --resolve demo:443:127.0.0.1 https://demo/api.json
````