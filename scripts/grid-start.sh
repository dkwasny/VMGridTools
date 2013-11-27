#!/bin/bash

echo "I am a bad person...stopping iptables on the grid...actually setup the ports when you are not lazy!!";
for SERVER in $(cat $HADOOP_CONF_DIR/slaves); do
	ssh root@$SERVER service iptables stop;
done;

$HADOOP_COMMON_HOME/sbin/start-dfs.sh;
$HADOOP_COMMON_HOME/sbin/start-yarn.sh;
$HADOOP_COMMON_HOME/sbin/mr-jobhistory-daemon.sh start historyserver;

# Only start zookeeper on the configured nodes
for SERVER in $(cat $HADOOP_CONF_DIR/zookeeper.properties | grep ^server | sed s_server\.[0-9]=__ | sed s_:.*__); do
	echo "Starting Zookeeper on $SERVER";
	ssh $SERVER "\
		JMXDISABLE=INOWANTJMX \
		SERVER_JVMFLAGS='-Xmx128m' \
		$ZOOKEEPER_HOME/bin/zkServer.sh start $HADOOP_CONF_DIR/zoo.cfg \
	";
done;
