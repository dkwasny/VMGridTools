#!/bin/bash

for SERVER in $(cat $HADOOP_CONF_DIR/slaves | grep -v $(hostname)); do
	ssh $SERVER "mkdir $GRID_HOME && cd $GRID_HOME && git clone dkwasny@centos-1:$GRID_HOME";
#	ssh $SERVER "cd $HADOOP_CONF_DIR && git pull --rebase";
done;
