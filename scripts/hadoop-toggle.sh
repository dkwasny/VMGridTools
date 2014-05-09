
#!/bin/bash

# Start and stop have different orderings...dont wanna kill hdfs before hbase!
if [ "$1" = "start" ]; then
	$HADOOP_COMMON_HOME/sbin/$1-dfs.sh;
	$HADOOP_COMMON_HOME/sbin/$1-yarn.sh;
	$HADOOP_COMMON_HOME/sbin/mr-jobhistory-daemon.sh $1 historyserver;
elif [ "$1" = "stop" ]; then
	$HADOOP_COMMON_HOME/sbin/mr-jobhistory-daemon.sh $1 historyserver;
	$HADOOP_COMMON_HOME/sbin/$1-yarn.sh;
	$HADOOP_COMMON_HOME/sbin/$1-dfs.sh;
else
	echo "Invalid arg ($1) encountered";
	exit 1;
fi;
