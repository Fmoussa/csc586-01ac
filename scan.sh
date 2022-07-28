#!/bin/bash
set -x

# The following while loop runs the grep command on the auth.log. For each line, $date, $ip_address, 
#  and $country are read in as variables. Each line is checked for a non-null $ip_address, and then 
#  is written to: /share/log/unauthorized.log. This ensures only unauthorized/failed ssh activity is
#  recorded.

echo -n '' | sudo tee-a /var/log/temp.log

isdifflog=$(diff /var/log/auth.log /var/log/temp.log)

if [[ $isdifflog -ne 0 ]]
then
  sudo comm -13 --nocheck-order /var/log/auth.log /var/log/temp.log | sudo grep -i -E "invalid|fail" | while read -r line ; do
    date=$(echo "$line" | grep -i -o -E "^[a-z]*\s[0-9]*\s")
    ip_address=$(echo "$line" | grep -o -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
    country=$(curl -s ipapi.co/$ip_address/country_name/)
  
    if [ -n "$ip_address" ]
    then
      echo "$ip_address $country $date" | sudo tee -a /share/log/unauthorized.log
    fi
  done 
fi

sudo bash -c "cat /var/log/auth.log > /var/log/temp.log"
