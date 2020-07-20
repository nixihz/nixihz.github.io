## 初始化
```
git submodule update --init --depth 1

```


## 测试

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
./voice --mode=name

```

## 重新生成所有语音文件
```
export  GOOGLE_APPLICATION_CREDENTIALS="/Users/fence/Desktop/text-speech-7b1f89740e96.json"
export http_proxy=http://127.0.0.1:7777;export https_proxy=http://127.0.0.1:7777;
rm -rf public/audio/*.mp3
./voice

```

## 发布github系统

```
cd public

git add .
git commit -m 'update post'
git push origin master
git status
cd ..
```

## 发布keli.tech系统

```
cd public

git add .
git commit -m 'update post'
git push gitee master
git status
cd ..
```
