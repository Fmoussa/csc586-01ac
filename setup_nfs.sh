#!/bin/bash
set -x

sudo apt update
mkdir webserver_log
sudo mount 192.168.1.1:/share/log webserver_log/
