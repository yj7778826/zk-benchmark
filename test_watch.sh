#!/bin/sh
py='/usr/bin/python'
cluster='10.82.158.15:2181,10.82.158.16:2181,10.82.158.17:2181'
root='/zk_watch_test'
file=watch.dat
count=10000
size=25
session=10
step=100000
round=10

> $file

for((i=1; i <= $round; ++i))
do
    n=$(($i*$step))
    $py zk-watch.py --cluster="$cluster" --root_znode="$root" --znode_size=$size --znode_count=$n --watch_session=$session | tee result.tmp
    cat result.tmp | egrep -o "[0-9]+\.[0-9]+/sec" | awk -v num=$n -F'/' 'BEGIN{printf("|%i|",num)}{printf("%i|",$1)}END{printf"\n"}' >>$file
done

rm -f cli_log*
