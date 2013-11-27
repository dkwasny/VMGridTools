#!/bin/bash

for SERVER in $(cat $HADOOP_CONF_DIR/slaves | grep -v $(hostname)); do
	ssh $SERVER "cd $GRID_HOME && git pull --rebase";
done;
