#!/bin/bash
set -e
cd ~/Desktop/文房图谱
git reset -q --soft origin/main
git reset -q
# 1) 先提交删除旧 web + 新 index.html（小）
git add -A mopu/index.html index.html 2>/dev/null || true
git rm -r -q --cached mopu/web 2>/dev/null || true
git -c user.name=mifenglianzi711 -c user.email=mifenglianzi711@users.noreply.github.com commit -qm "墨谱改版：页面只收墨样（1/4 页面与旧图下架）"
git push -q origin main && echo "batch1 pushed"

# 2) 墨样图分批加入
i=0
ls mopu/mo/*.jpg | sort > /tmp/molist.txt
split -l 55 /tmp/molist.txt /tmp/mobatch_
for f in /tmp/mobatch_*; do
  xargs -a "$f" git add
  i=$((i+1))
  git -c user.name=mifenglianzi711 -c user.email=mifenglianzi711@users.noreply.github.com commit -qm "墨样图 第${i}批"
  git push -q origin main && echo "batch$((i+1)) pushed $(wc -l < $f) files"
done
git log --oneline origin/main -1
