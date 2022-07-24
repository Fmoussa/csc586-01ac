#!/bin/bash
set -x

# The following while loop runs the grep command on the auth.log. For each line, $date, $ip_address, 
#  and $country are read in as variables. Each line is checked for a non-null $ip_address, and then 
#  is written to: /share/log/unauthorized.log. This ensures only unauthorized/failed ssh activity is
#  recorded.
sudo grep -i -E "invalid|fail" /var/log/auth.log | while read -r line ; do
  date=$(echo $line | grep -i -o -E "^[a-z]*\s[0-9]*\s")
  ip_address=$(echo $line | grep -o -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
  country=$(curl -s ipinfo.io/$ip_address | grep -o -P '(?<="country": )[^ ]*' | grep -io "[a-z]*")
  
  if [ -n "$ip_address" ]
  then
    echo "$ip_address $country $date" | sudo tee /share/log/unauthorized.log
  fi
done 
