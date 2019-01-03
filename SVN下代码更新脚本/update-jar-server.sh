#!/bin/sh

source /root/workspace/svn_conf/svn_base.conf

PROJECT_NAME="wantest"
PROJECT_DIR="$WORKDIR/$PROJECT_NAME"
SSH="root@47.74.14.xxx"
REMOTE="/opt/badugi"
JAR_LIKE="wantest-*.*.jar"
PACKAGE_DIR=`find $PROJECT_DIR -name $JAR_LIKE`
JAR_NAME=`echo $PACKAGE_DIR |awk -F'/' '{print $NF}'`

EXCLUDE="--exclude=.git"

source /root/workspace/svn_conf/manage_jar_proc.conf

function update() {

	UpdateSvnBase
        MavenBase
        RsyncBase
}

start(){
        start_jar_proc $PROJECT_NAME $JAR_LIKE $REMOTE
}

stop(){
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
