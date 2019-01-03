#!/bin/sh

source /root/workspace/svn_conf/svn_base.conf

PROJECT_NAME="majiang-backstage"
PROJECT_DIR="$WORKDIR/$PROJECT_NAME"
SSH="root@43.242.34.xxx"
REMOTE="/opt/wwwroot"
PACKAGE_DIR="$WORKDIR/$PROJECT_NAME/target/$PROJECT_NAME"

EXCLUDE="--exclude=.svn --exclude=WEB-INF/classes/properties"


function update() {
	UpdateSvnBase
	MavenBase
	RsyncBase
}



function restart(){
Echo_Flash "restart tomcat ? [Y/N]"
read ENTERSTOP
case $ENTERSTOP in
   y|Y|yes|Yes)
        TOMCAT_DIR="/usr/local/apache-tomcat-9.0.0.M19"
        TOMCAT_BIN="$TOMCAT_DIR/bin"
        Echo_Green "Stop tomcat now !"
        ssh $SSH "/usr/bin/ps -ef |grep Dcatalina.base=$TOMCAT_DIR |grep -v grep |awk '{print \$2}' |while read i ; do kill -9 \$i; done"
        sleep 5

        tomcat_sum=`ssh $SSH "ps -ef |grep "Dcatalina.base=$TOMCAT_DIR" |grep -v grep |wc -l"`
        if [ "$tomcat_sum" -eq "0" ];then
        Echo_Green "stop tomcat ok ! start it,go on ...."
                ssh $SSH "rm -rf $TOMCAT_DIR/work/Catalina/localhost/" && echo "Delete tomcat-cache ok !"
                ssh $SSH $TOMCAT_BIN/startup.sh
                ssh $SSH "/usr/bin/tailf $TOMCAT_DIR/logs/catalina.out"
                #sleep 10
                tomcat_pid=`ssh $SSH "ps -ef |grep "Dcatalina.base=$TOMCAT_DIR" |grep -v grep"`
                tomcat_sum=`ssh $SSH "ps -ef |grep "Dcatalina.base=$TOMCAT_DIR" |grep -v grep |wc -l"`
                if [ "$tomcat_sum" -eq "1" ];then
                         Echo_Green "tomcat start ok!  Process is: "
                        echo $tomcat_pid
                fi
        fi
        ;;
   *)
        Echo_Red "exit restart..."
        ;;
esac
}


case $1 in
update)
	update
	restart
	;;
restart)
	restart
	;;
*)
	Echo_Green "usage: sh $0 'update|restart'"
	;;
esac
