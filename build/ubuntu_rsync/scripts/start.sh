#!/usr/bin/env bash

rm -f /mirror/index.html >/dev/null 2>&1
/usr/sbin/cron
/usr/sbin/service nginx start
/etc/init.d/monit start
if [ ! -d "/mirror/mirror" ]; then
  # needs to create the mirror
  mkdir -p /mirror/ubuntu
  echo "Ubuntu Repository not ready...please wait." > /mirror/index.html
  mkdir /data/logs
  rsync -azvh rsync://archive.ubuntu.com/ubuntu/ /mirror/ubuntu/  >> /data/logs/rsync.log
  rm -f /mirror/index.html >/dev/null 2>&1
fi
/etc/init.d/monit stop
sleep 5
/usr/bin/monit -I
