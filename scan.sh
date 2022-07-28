#!/bin/bash
set -x

# The following while loop runs the grep command on the auth.log. For each line, $date, $ip_address, 
#  and $country are read in as variables. Each line is checked for a non-null $ip_address, and then 
#  is written to: /share/log/unauthorized.log. This ensures only unauthorized/failed ssh activity is
#  recorded.

echo -n '' | sudo tee-a /var/log/atemp.log

isdifflog=$(diff /var/log/auth.log /var/log/atemp.log)

if [[ $isdifflog -ne 0 ]]
then
  "$isdifflog" | sudo grep -i -E "invalid|fail" | while read -r line 
  do
    date=$(echo "$line" | grep -i -o -E "^[a-z]*\s[0-9]*\s")
    ip_address=$(echo "$line" | grep -o -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
    country=$(curl -s ipapi.co/$ip_address/country_name/)
  
    if [ -n "$ip_address" ]
    then
      echo "$ip_address $country $date" | sudo tee -a /share/log/unauthorized.log
      sudo bash -c "cat /var/log/auth.log > /var/log/atemp.log"
    fi
  done 
fi
