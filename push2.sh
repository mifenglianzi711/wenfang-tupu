#!/bin/bash
cd ~/Desktop/文房图谱
push_retry() {
  for a in 1 2 3 4 5 6; do
    if git push -q origin main 2>/tmp/push_err.txt; then echo "pushed (attempt $a)"; return 0; fi
    echo "attempt $a failed: $(tail -1 /tmp/push_err.txt)"
    sleep 15
  done
  return 1
}
push_retry || { echo "GIVEUP"; exit 1; }
i=0
ls mopu/mo/*.jpg | sort > /tmp/molist.txt
rm -f /tmp/mobatch_*
split -l 55 /tmp/molist.txt /tmp/mobatch_
for f in /tmp/mobatch_*; do
  xargs -a "$f" git add
  i=$((i+1))
  git -c user.name=mifenglianzi711 -c user.email=mifenglianzi711@users.noreply.github.com commit -qm "墨样图 第${i}批"
  push_retry || { echo "GIVEUP at batch $i"; exit 1; }
  echo "batch $i done ($(wc -l < $f | tr -d ' ') files)"
done
git log --oneline origin/main -1
