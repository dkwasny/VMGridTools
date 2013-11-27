#!/bin/bash

hadoop_toggle() {
	$HADOOP_COMMON_HOME/sbin/$1-dfs.sh;
	$HADOOP_COMMON_HOME/sbin/$1-yarn.sh;
	$HADOOP_COMMON_HOME/sbin/mr-jobhistory-daemon.sh $1 historyserver;
}

zookeeper_toggle() {
	local ZOOKEEPER_CONFIG_FILE=$HADOOP_CONF_DIR/zoo.cfg;
	for SERVER in $(cat $ZOOKEEPER_CONFIG_FILE | grep ^server | sed s_server\.[0-9]=__ | sed s_:.*__); do
		ssh $SERVER "\
			JMXDISABLE=INOWANTJMX \
			SERVER_JVMFLAGS='-Xmx128m' \
			$ZOOKEEPER_HOME/bin/zkServer.sh $1 $ZOOKEEPER_CONFIG_FILE \
		";
	done;
}

hbase_toggle() {
	$HBASE_HOME/bin/$1-hbase.sh;
}

# Start and stop have different orderings...dont wanna kill hdfs before hbase!
if [ "$1" = "start" ]; then
	hadoop_toggle "$1";
	zookeeper_toggle "$1";
	hbase_toggle "$1";
elif [ "$1" = "stop" ]; then
	hbase_toggle "$1";
	zookeeper_toggle "$1";
	hadoop_toggle "$1";
else
	echo "Invalid arg ($1) encountered";
	exit 1;
fi;
