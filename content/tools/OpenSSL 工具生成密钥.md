---

title: OpenSSL 工具生成密钥

date: 2021-11-02
tags:
- openssl

---

第一步 生成RSA密钥

````Shell
    $openssl
    
    OpenSSL> genrsa -out app_private_key.pem 2048
    
    OpenSSL> pkcs8 -topk8 -inform PEM -in app_private_key.pem -outform PEM -nocrypt -out app_private_key_pkcs8.pem
    
    OpenSSL> rsa -in app_private_key.pem -pubout -out app_public_key.pem
    
    OpenSSL> exit
````

经过以上步骤，开发者可以在当前文件夹中（OpenSSL运行文件夹），看到

1. app_private_key.pem（开发者RSA私钥，非 Java 语言适用）、
2. app_private_key_pkcs8.pem（pkcs8格式开发者RSA私钥，Java语言适用）、
3. app_public_key.pem（开发者RSA公钥）3个文件。

  开发者将私钥保留，将公钥提交给支付宝配置到开发平台，用于验证签名。以下为私钥文件和公钥文件示例。

> 注：对于使用Java的开发者，需将生成的pkcs8格式的私钥去除头尾、换行和空格，作为私钥填入代码中，对于.NET和PHP的开发者来说，无需进行pkcs8命令行操作。