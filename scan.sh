#!/bin/bash
set -x

sudo bash -c 'cat /var/log/auth.log | grep sshd >> /share/log/unauthorized.log'
sudo cat /var/log/auth.log | grep -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
sudo cat /var/log/auth.log | grep -E 'Invalid|Failed'

sudo grep "Failed password" /var/log/auth.log | grep -v COMMAND | awk '{print $9}' | sort | uniq -c

#Grep for multiple strings and patterns: https://linuxize.com/post/grep-multiple-patterns/
#Monitoring failed login attempts on Linux: https://www.networkworld.com/article/3598048/monitoring-failed-login-attempts-on-linux.html
#Find failed SSH Login attempts in Linux: https://www.tecmint.com/find-failed-ssh-login-attempts-in-linux/
#Grep an ip address from a file: https://www.putorius.net/grep-an-ip-address-from-a-file.html#:~:text=In%20Linux%20you%20can%20use,as%20a%20extended%20regular%20expression.
#Linux API for finding geolocation of IP address: https://ostechnix.com/find-geolocation-ip-address-commandline/
