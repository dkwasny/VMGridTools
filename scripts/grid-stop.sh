#!/bin/bash

$1/sbin/stop-dfs.sh;
$1/sbin/stop-yarn.sh;
$1/sbin/mr-jobhistory-daemon.sh stop historyserver;

for SERVER in $(cat $HADOOP_CONF_DIR/slaves); do
	ssh $SERVER "\
		JMXDISABLE=INOWANTJMX \
		SERVER_JVMFLAGS='-Xmx128m' \
		$ZOOKEEPER_HOME/bin/zkServer.sh stop $HADOOP_CONF_DIR/zookeeper.properties \
	";
done;
