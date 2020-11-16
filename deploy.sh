
git checkout blogedit
git add .
git commit -m 'update'
git push origin blogedit
git status
hugo -D --quiet



cd public

git add .
git commit -m 'update post'
git push github master
git status
cd ..


cd public

git add .
git commit -m 'update post'
git push origin master
git status
cd ..
