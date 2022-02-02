## hugo version
v0.74.2

## 初始化
```
## git submodule update --init --depth 1

git submodule add -b master --force git@gitee.com:fence/blog.git public/
cd public
git remote add github git@github.com:fencex/fencex.github.io.git
cd ..

git submodule add -b master --force git@gitee.com:fence/hugo-book.git themes/book

git restore --staged public themes/book

git submodule update --init --recursive

```


## 测试

```
hugo server --minify --theme book

```
## sync from notion

```
export HANDY_WORK_DIR=$PWD
./handy blogation
```


## 文件生成
```
git checkout blogedit
git add .
git commit -m 'update'
git push origin blogedit
git status
rm -rf public/en.*
hugo -D
./voice --mode=name

```

## 重新生成所有语音文件
```
export  GOOGLE_APPLICATION_CREDENTIALS="text-speech-272314-3276ed3df6e6.json"

export http_proxy=http://127.0.0.1:7777;export https_proxy=http://127.0.0.1:7777;
rm -rf public/audio/*.mp3
./voice

```

## 发布github系统

```
cd public

git add .
git commit -m 'update post'
git push github master
git status
cd ..
```

## 发布keli.tech系统

```
cd public

git add .
git commit -m 'update post'
git push origin master
git status
cd ..
```
