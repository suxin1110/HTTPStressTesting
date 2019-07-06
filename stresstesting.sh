#!/bin/bash
# Created by Johnnyxsu from TencentCloud

> /tmp/stresstest.log

stresstesting(){
echo "                  HTTP压力测试脚本"
echo "---------------------------------------------------"

echo && read -e -p "请输入请求url：" url
echo && read -e -p "设置并发测试量（默认100次）：" loop
if [ ! -n "$loop" ];then loop=100;fi
http_or_hppts=`echo $url|awk -F':' '{print $1}'`
if [ $http_or_hppts == "http" ];then
	echo && read -e -p "设置proxy IP地址：" ip
	echo && read -e -p "设置回源端口号（HTTP默认80）：" port
	if [ ! -n "$port" ];then port=80;fi
	for ((i=1; i<=$loop; i ++)); do
		curl -I "$url" -x $ip:$port >> /tmp/stresstest.log
	done
	wait  ##等待所有子后台进程结束
	echo "压测命令：curl -I "$url" -x $ip:$port"
elif [  $http_or_hppts == "https" ];then
	echo && read -e -p "设置HTTPS HOST（默认为url HOST）：" host
	if [ ! $host ];then host=`echo $url|awk -F'/' '{print $3}'`;fi
	echo && read -e -p "设置proxy端口号（HTTPS默认443）：" port
	if [ ! -n "$port" ];then port=443;fi
	echo && read -e -p "设置proxy IP地址：" ip
	for ((i=1; i<=$loop; i ++)); do
                curl -I "$url" --resolve $host:$port:$ip >> /tmp/stresstest.log
        done
        #wait  ##等待所有子后台进程结束
	echo "压测命令：curl -I "$url" --resolve $host:$port:$ip"
else
        echo "输入请求url有误！！！"
fi
}
analysis_stresstesting_log(){ 
	echo "压测请求数：$loop"
	echo "返回200请求数：" `cat /tmp/stresstest.log|grep HTTP/|grep 200|wc -l`
	#echo "--------------------"
	echo "详细状态码分布如下:"
	echo "--------------------"
	echo "次数 状态码"
	echo `cat /tmp/stresstest.log|grep HTTP/ |awk '{print $2}'|sort|uniq -c|sort -nrk 1 -t' '`

}
stresstesting
analysis_stresstesting_log
