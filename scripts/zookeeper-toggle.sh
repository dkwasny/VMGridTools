#!/bin/bash

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

# Start and stop have different orderings...dont wanna kill hdfs before hbase!
if [ "$1" = "start" ] || [ "$1" = "stop" ]; then
	zookeeper_toggle "$1";
else
	echo "Invalid arg ($1) encountered";
	exit 1;
fi;
