#!/bin/sh
py='/usr/bin/python'
cluster='10.82.158.15:2181,10.82.158.16:2181,10.82.158.17:2181'
root='/zk_size_test'
file=size.dat
count=10000
step=10240
round=10

> $file

for((i=1; i <= $round; ++i))
do
    n=$(($i*$step))
    $py zk-latencies.py --cluster="$cluster" --root_znode="$root" --znode_count=$count --znode_size=$n | tee result.tmp
    cat result.tmp | egrep -o "[0-9]+\.[0-9]+/sec" | awk -v num=$n -F'/' 'BEGIN{printf("|%i|",num)}{printf("%i|",$1)}END{printf"\n"}' >>$file
done

rm -f cli_log*
