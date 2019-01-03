#!/bin/sh


DT=`date +"%Y-%m-%d %H:%M:%S"`
WORKDIR="$( cd "$( dirname "$0"  )" && pwd  )"

send_weixin(){
/usr/bin/python /root/cron/send_weixin.py @all test "$ip-$DT-Error,checkplease~"
}


for i in `find  /root/cron/check_cmdb/tmp -type f -name 'parse-*.txt'`
do
	sum=`tail -10 $i | awk -F' - ' '{print $NF}' |grep 200 |wc -l`
	ip=`tail -1 $i |awk -F' - ' '{print $2}' |awk -F'parse-' '{print $2}'`
	recordid=`python $WORKDIR/listrecord.py |grep $ip |grep 'play.vod' |awk '{print $3}'`

	if [ $sum -lt 1 ];then
		python  $WORKDIR/setrecordstatus.py  $recordid Disable
		/usr/bin/python /root/cron/send_weixin.py @all test "域名IP:${ip}暂停解析成功!"
		echo "-------- 域名IP:${ip}暂停解析成功 ! $DT "
	#else
		#python  setrecordstatus.py  $recordid Enable
		#/usr/bin/python /root/cron/send_weixin.py @all test "域名IP:${ip}开启解析成功!"
	fi
done
