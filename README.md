


测试


```

hugo server --minify --theme book


```



## 文件生成
```
git checkout blogedit
git add .
git commit -m 'update'
git push origin blogedit
git status
hugo -D
export  GOOGLE_APPLICATION_CREDENTIALS="/Users/fence/Desktop/text-speech-7b1f89740e96.json"
export http_proxy=http://127.0.0.1:7777;export https_proxy=http://127.0.0.1:7777;
./voice
```

## 发布系统

```
cd public

git add .
git commit -m 'update post'
git push origin master
git status
cd ..
```
