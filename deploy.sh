
git checkout blogedit
git add .
git commit -m 'update'
git pull origin blogedit
git push origin blogedit
git status
rm -rf public/en.*
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
