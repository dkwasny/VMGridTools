#!/bin/bash

TOGGLE="$1";
if [ "$TOGGLE" == "stop" ]; then
	CMD="$CATALINA_HOME/bin/shutdown.sh";
elif [ "$TOGGLE" == "start" ]; then
	CMD="$CATALINA_HOME/bin/startup.sh";
else
	echo "bad command ($TOGGLE). Use stop or start.";
	exit 1;
fi;

for i in 1 2 3 4; do
	ssh centos-$i "$CMD";
done;
