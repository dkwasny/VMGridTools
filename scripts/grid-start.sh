#!/bin/bash

SERVERS=$(cat $HADOOP_CONF_DIR/slaves);
echo "I am a bad person...stopping iptables on the grid...actually setup the ports when you are not lazy!!";
for SERVER in $SERVERS; do
	ssh root@$SERVER service iptables stop;
done;

$HADOOP_COMMON_HOME/sbin/start-dfs.sh;
$HADOOP_COMMON_HOME/sbin/start-yarn.sh;
$HADOOP_COMMON_HOME/sbin/mr-jobhistory-daemon.sh start historyserver;

for SERVER in $SERVERS; do
	echo "Starting Zookeeper on $SERVER";
	ssh $SERVER "\
		JMXDISABLE=INOWANTJMX \
		SERVER_JVMFLAGS='-Xmx128m' \
		$ZOOKEEPER_HOME/bin/zkServer.sh start $HADOOP_CONF_DIR/zookeeper.properties \
	";
done;
