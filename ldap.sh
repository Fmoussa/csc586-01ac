#!/bin/bash
set -x

sudo apt update
sudo apt install -y nfs-kernel-server
sudo mkdir /nfs/home
sudo chown nobody:nogroup /nfs/home
echo "/nfs/home 192.168.1.1(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
echo "/nfs/home 192.168.1.2(rw,sync,no_root_squash,no_subtree_check)" | sudo tee -a /etc/exports
sudo systemctl restart nfs-kernel-server
