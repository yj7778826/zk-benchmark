#!/bin/sh
py='/usr/bin/python'
cluster='10.82.158.15:2181,10.82.158.16:2181,10.82.158.17:2181'
root='/zk_test'
file=node.dat
size=250
step=5000
round=20

> $file

for((i=1; i <= $round; ++i))
do
    n=$(($i*$step))
    $py zk-latencies.py --cluster="$cluster" --root_znode="$root" --timeout=120000 --znode_size=$size --znode_count=$n | tee "${file}.tmp"
    cat "${file}.tmp" | egrep -o "[0-9]+\.[0-9]+/sec" | awk -v num=$n -F'/' 'BEGIN{printf("|%i|",num)}{printf("%i|",$1)}END{printf"\n"}' >>$file
done

rm -f cli_log*
