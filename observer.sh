#!/bin/bash
set -x

sudo apt install -y nfs-common
sudo mkdir webserver_log
sleep 2m
sudo mount 192.168.1.1:/share/log webserver_log/

sudo chmod 755 /local/repository/monitor.sh

(crontab -l 2>/dev/null; echo "0 * * * * /local/repository/monitor.sh") | crontab -
