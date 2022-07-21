#!/bin/bash
set -x

sudo apt update
sudo apt install -y apache2
echo "/share/log 192.168.1.2(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
