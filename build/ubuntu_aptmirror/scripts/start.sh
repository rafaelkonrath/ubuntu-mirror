#!/usr/bin/env bash

rm -f /mirror/mirror/archive.ubuntu.com/index.html >/dev/null 2>&1
/usr/sbin/cron
/etc/init.d/nginx start
/etc/init.d/monit start
if [ ! -d "/mirror/mirror" ]; then
  # needs to create the mirror
  mkdir -p /mirror/mirror/archive.ubuntu.com
  mkdir -p /data/logs
  echo "Ubuntu Repository not ready...please wait." > /mirror/mirror/archive.ubuntu.com/index.html
  sleep 15
  ##/usr/bin/apt-mirror >> /data/logs/apt-mirror.log
  # after apt-mirror completed, it should remove the index.html to show the directory
  rm -f /mirror/mirror/archive.ubuntu.com/index.html >/dev/null 2>&1
fi
/etc/init.d/monit stop
sleep 5
/usr/bin/monit -I
