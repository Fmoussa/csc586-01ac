#!/bin/bash
set -x

sudo apt install -y nfs-common
sudo mkdir webserver_log
sleep 2m
sudo mount 192.168.1.1:/share/log webserver_log/
