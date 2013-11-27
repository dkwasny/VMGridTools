#!/bin/bash

$1/sbin/stop-dfs.sh;
$1/sbin/stop-yarn.sh;
$1/sbin/mr-jobhistory-daemon.sh stop historyserver;
