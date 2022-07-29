#!/bin/bash
set -x

sudo apt update
sudo apt install -y apache2
sudo apt install -y nfs-kernel-server
sudo mkdir /share/log
sudo chown nobody:nogroup /share/log
echo "/share/log 192.168.1.2(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
sudo systemctl restart nfs-kernel-server

sudo chmod 755 /local/repository/scan.sh

sleep 3m

sudo apt install -y nfs-common
sudo mkdir /nfs/home
sleep 2m
sudo mount 192.168.1.3:/nfs/home nfs/home/

(crontab -l 2>/dev/null; echo "*/5 * * * * /local/repository/scan.sh") | crontab -

#crontab -l > tempcron
#echo "*/5 * * * * su so749257 -c /local/repository/scan.sh" >> tempcron
#crontab tempcron
#rm tempcron

#crontab -l | { echo "*/5 * * * * /local/repository/scan.sh"; } | crontab -
#(crontab -l ; echo "*/5 * * * * /local/repository/scan.sh) | crontab -

#(crontab -l ; echo "*/5 * * * * /local/repository/scan.sh) | crontab -
