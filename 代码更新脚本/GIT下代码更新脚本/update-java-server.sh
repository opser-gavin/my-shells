#!/bin/sh

source /root/workspace/git_conf/git_base.conf

PROJECT_NAME="OddsNav"
PROJECT_DIR="$WORKDIR/$PROJECT_NAME"
SSH="root@47.74.4.xxx"
REMOTE="/opt/oddsnav"
JAR_LIKE="back-*.*.jar"
PACKAGE_DIR=`find $PROJECT_DIR -name $JAR_LIKE`
JAR_NAME=`echo $PACKAGE_DIR |awk -F'/' '{print $NF}'`

EXCLUDE="--exclude=.git --exclude=WEB-INF/classes/properties"


source /root/workspace/git_conf/manage_jar_proc.conf

function update() {

        git_base
        MavenBase
        RsyncBase
}

start(){
	start_jar_proc $PROJECT_NAME $JAR_LIKE $REMOTE
	sh ../oddsnav_client_update/update-oddsnav-client.sh start
}

stop(){
	sh ../oddsnav_client_update/update-oddsnav-client.sh stop
	stop_jar_proc $PROJECT_NAME $JAR_LIKE
}


case $1 in
update)
	update
	stop
	start
	;;
restart)
	stop
	start
	;;
stop)
	stop
	;;
start)
	start
	;;
*)
	Echo_Green "usage: sh $0 'update|restart'"
	;;
esac
