#!/bin/sh
py='/usr/bin/python'
cluster='10.82.158.15:2181,10.82.158.16:2181,10.82.158.17:2181'
root='/zk_test'
file=watch.dat
count=2000
size=250
step=100
round=12

> $file

for((i=1; i <= $round; ++i))
do
    n=$(($i*$step))
    $py zk-watch.py --cluster="$cluster" --root_znode="$root" --timeout=1800000 --znode_size=$size --znode_count=$count --watch_session=$n | egrep "created|set|deleted" | tee "${file}.tmp"
    cat "${file}.tmp" | egrep -o "[0-9]+\.[0-9]+/sec" | awk -v num=$n -F'/' 'BEGIN{printf("|%i|",num)}{printf("%i|",$1)}END{printf"\n"}' >>$file
done

rm -f cli_log*
