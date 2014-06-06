#!/bin/bash

TOGGLE="$1";
if [ "$TOGGLE" != "stop" ] || [ "$TOGGLE" != "start"]; then
	echo "bad command ($TOGGLE). Use stop or start.";
	exit 1;
fi;

for i in 1 2 3 4; do
	ssh centos-$i "tomcat-$TOGGLE";
done;
