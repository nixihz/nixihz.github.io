


测试


```

hugo server --minify --theme book


```



发布


```


git checkout blogedit

git add .

git commit -m 'update'

git push origin blogedit

git status

hugo -D

cd public

git add .

git commit -m 'update post'

git push origin master

git status

cd ..

```
