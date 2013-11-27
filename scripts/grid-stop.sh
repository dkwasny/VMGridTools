#!/bin/bash

$HADOOP_COMMON_HOME/sbin/stop-dfs.sh;
$HADOOP_COMMON_HOME/sbin/stop-yarn.sh;
$HADOOP_COMMON_HOME/sbin/mr-jobhistory-daemon.sh stop historyserver;

for SERVER in $(cat $HADOOP_CONF_DIR/zookeeper.properties | grep ^server | sed s_server\.[0-9]=__ | sed s_:.*__); do
	echo "Stopping Zookeeper on $SERVER";
	ssh $SERVER "\
		JMXDISABLE=INOWANTJMX \
		SERVER_JVMFLAGS='-Xmx128m' \
		$ZOOKEEPER_HOME/bin/zkServer.sh stop $HADOOP_CONF_DIR/zookeeper.properties \
	";
done;
