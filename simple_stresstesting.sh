#!/bin/bash
date
> /tmp/stresstest.log
for i in `seq 1 $1`
do
{
    #echo "test $i"
    curl -I $2 $3 $4 $5 $6 >> /tmp/stresstest.log
} &
done
wait  ##等待所有子后台进程结束
date
echo "curl -I "$2 $3 $4 $5 $6 
echo "压测请求数：$1 "
echo "返回200请求数：`cat /tmp/stresstest.log|grep HTTP/|grep 200|wc -l`"
echo "---------------"
echo "详细状态码统计:"
echo "次数 状态码"
echo `cat /tmp/stresstest.log|grep HTTP/ |awk '{print $2}'|sort|uniq -c|sort -nrk 1 -t' '`
