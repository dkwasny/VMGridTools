#!/bin/bash

if [ "$1" != "start" ] && [ "$1" != "stop" ]; then
	echo "Invalid arg ($1) encountered";
	exit 1;
fi;

echo "I am a bad person...stopping iptables on the grid...actually setup the ports when you are not lazy!!";
for SERVER in $(cat $HADOOP_CONF_DIR/slaves); do
	ssh root@$SERVER service iptables stop;
done;

$HADOOP_COMMON_HOME/sbin/$1-dfs.sh;
$HADOOP_COMMON_HOME/sbin/$1-yarn.sh;
$HADOOP_COMMON_HOME/sbin/mr-jobhistory-daemon.sh $1 historyserver;

# Only start zookeeper on the configured nodes
ZOOKEEPER_CONFIG_FILE=$HADOOP_CONF_DIR/zoo.cfg; 
for SERVER in $(cat $ZOOKEEPER_CONFIG_FILE | grep ^server | sed s_server\.[0-9]=__ | sed s_:.*__); do
	echo "Starting Zookeeper on $SERVER";
	ssh $SERVER "\
		JMXDISABLE=INOWANTJMX \
		SERVER_JVMFLAGS='-Xmx128m' \
		$ZOOKEEPER_HOME/bin/zkServer.sh $1 $ZOOKEEPER_CONFIG_FILE \
	";
done;
