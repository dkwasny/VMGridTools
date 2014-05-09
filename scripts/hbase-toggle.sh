#!/bin/bash

# Start and stop have different orderings...dont wanna kill hdfs before hbase!
if [ "$1" = "start" ] || [ "$1" = "stop" ]; then
	$HBASE_HOME/bin/$1-hbase.sh;
else
	echo "Invalid arg ($1) encountered";
	exit 1;
fi;
