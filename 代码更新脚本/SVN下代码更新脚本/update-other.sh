#!/bin/bash

source /root/workspace/svn_conf/svn_base.conf


TestInfo(){
	SSH="san-dev-user@47.88.155.xxx"
        REMOTE="/opt/mam_game"
}

OnlineInfo(){
	SSH="san-game-user@47.74.187.xxx"
	REMOTE="/opt"
}


Update(){
	PROJECT_NAME=game
        Echo_Green "Update SVN: $PROJECT_NAME >>>"
        UpdateSvnBase

	PROJECT_NAME=game/tools
	chmod +x $PROJECT_NAME/bin/bintalk

        Echo_Green "Run: $PROJECT_NAME/export.py ........."
        pushd $PROJECT_NAME
        python export_server.py
        popd

}


Compile(){
	PROJECT_NAME=game/servers/mam_platform
	chmod +x $PROJECT_NAME/rebar3

	pushd $WORKDIR/$PROJECT_NAME
	Echo_Green "stop ..."
	_build/default/rel/mam_platform/bin/mam_platform stop
	Echo_Green "clean ..."	
	./rebar3 clean
	Echo_Green "compile ..."
	./rebar3 compile
	Echo_Green "release ..."
	./rebar3 release
        popd

        PROJECT_NAME=game/servers/mam_entry_server
        chmod +x $PROJECT_NAME/rebar3

        pushd $WORKDIR/$PROJECT_NAME
        Echo_Green "stop ..."
        _build/default/rel/mam_entry_server/bin/mam_platform stop
        Echo_Green "clean ..."
        ./rebar3 clean
        Echo_Green "compile ..."
        ./rebar3 compile
        Echo_Green "release ..."
        ./rebar3 release
        popd

}


RsyncTest(){
	TestInfo
	PROJECT_NAME=mam_platform
        PACKAGE_DIR=$WORKDIR/game/servers/$PROJECT_NAME/_build/default/rel/$PROJECT_NAME
        EXCLUDE='--exclude=releases/0.1.1/sys.config --exclude=releases/0.1.1/vm.args  --exclude=lager_log --exclude=log'
	RsyncBase

        PROJECT_NAME=mam_entry_server
        PACKAGE_DIR=$WORKDIR/game/servers/$PROJECT_NAME/_build/default/rel/$PROJECT_NAME
        EXCLUDE='--exclude=releases/0.1.1/sys.config --exclude=releases/0.1.1/vm.args  --exclude=lager_log --exclude=log'
        RsyncBase

	sed -i "2c Test : $WORKDIR" /root/workspace/san_game/README
}


RsyncOnline(){
	OnlineInfo
        PROJECT_NAME=mam_platform
        PACKAGE_DIR=$WORKDIR/game/servers/$PROJECT_NAME/_build/default/rel/$PROJECT_NAME
        EXCLUDE='--exclude=releases/0.1.1/sys.config --exclude=releases/0.1.1/vm.args  --exclude=lager_log --exclude=log'
        RsyncBase
        
        PROJECT_NAME=mam_entry_server
        PACKAGE_DIR=$WORKDIR/game/servers/$PROJECT_NAME/_build/default/rel/$PROJECT_NAME
        EXCLUDE='--exclude=releases/0.1.1/sys.config --exclude=releases/0.1.1/vm.args  --exclude=lager_log --exclude=log'
        RsyncBase

	sed -i "1c Online : $WORKDIR" /root/workspace/san_game/README
}



CommandTest(){
	TestInfo
	ssh $SSH "$REMOTE/mam_platform/bin/mam_platform $1"
	ssh $SSH "$REMOTE/mam_entry_server/bin/mam_entry_server $1"
}

CommandOnline(){
	OnlineInfo
	ssh $SSH "$REMOTE/mam_platform/bin/mam_platform $1"
	#ssh $SSH "$REMOTE/mam_entry_server/bin/mam_entry_server $1"
}


case $1 in
update)
	Update
	;;
compile)
	Compile
	;;
rsync)
	if [ "$2"x == "test"x ];then
	RsyncTest
	elif [ "$2"x == "online"x ];then
	RsyncOnline
	fi
	;;
command)
	if [ "$2"x == "test"x ];then
	CommandTest $3
        elif [ "$2"x == "online"x ];then
        CommandOnline $3
        fi
	;;
*)
	echo "help~"
	;;
esac
