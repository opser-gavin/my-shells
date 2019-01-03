#!/bin/sh

source /root/workspace/git_conf/git_base.conf

PROJECT_NAME="OddsNavBack"
PROJECT_DIR="$WORKDIR/$PROJECT_NAME"
SSH="root@47.74.4.xxx"
REMOTE="/opt/wwwroot"
PACKAGE_DIR="$WORKDIR/$PROJECT_NAME/target/oddsNav-backstage"

EXCLUDE="--exclude=.git --exclude=WEB-INF/classes/properties"

TOMCAT_BASEDIR="/usr/local/apache-tomcat-9.0.0.M19"
source /root/workspace/git_conf/manage_tomcat.conf

function update() {

        git_base
        MavenBase
        RsyncBase
}

start(){
	start_tomcat $SSH $TOMCAT_BASEDIR $PROJECT_NAME
}

stop(){
	stop_tomcat $SSH $TOMCAT_BASEDIR $PROJECT_NAME
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
start)
	start
	;;
stop)
	stop
	;;
*)
	Echo_Green "usage: sh $0 'update|restart'"
	;;
esac
