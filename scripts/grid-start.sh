#!/bin/bash

$HADOOP_COMMON_HOME/sbin/start-dfs.sh;
$HADOOP_COMMON_HOME/sbin/start-yarn.sh;
$HADOOP_COMMON_HOME/sbin/mr-jobhistory-daemon.sh start historyserver;

for SERVER in $(cat $HADOOP_CONF_DIR/slaves); do
	ssh $SERVER "JMXDISABLE=INOWANTJMX SERVER_JVMFLAGS='-Xmx128m' $ZOOKEEPER_HOME/bin/zkServer.sh start $HADOOP_CONF_DIR/zookeeper.properties";
done;
