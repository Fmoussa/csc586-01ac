#!/bin/bash
set -x

# scan.sh will scan the webserver's auth.log file for unauthorized/failed SSH access. It will then
#  append the resulting information to a file called unauthorized.log inside the NFS-mounted 
#  /var/webserver_log with the following format: IP_ADDRESS COUNTRY DATE.

# A temporary log, atemp.log, is either created or appended to. This log is used to discern if there are
#  any changes that were made to auth.log by utilizing the diff command. All changes are stored in variable 
#  $isdifflog.
echo -n '' | sudo tee -a /var/log/atemp.log

isdifflog=$(sudo diff /var/log/auth.log /var/log/atemp.log)

# The following if statement checks to see if $isdifflog is "", signifying whether there are changes between
#  auth.log and atemp.log.
# If there are no differences, a while loop runs the grep command on the auth.log. For each line, $date, 
#  $ip_address, and $country are read in as variables. Each line is checked for a non-null $ip_address, and 
#  then is written to: /share/log/unauthorized.log. This ensures only unauthorized/failed ssh activity is
#  recorded. The contents of atemp.log are then overwritten with the contents of auth.log, to prepare the log
#  files for the next time the shell file runs.
if [[ "$isdifflog" != "" ]]
then
  sudo comm -1 -3 /var/log/atemp.log /var/log/auth.log | sudo grep -i -E "invalid|fail" | while read -r line 
  do
    date=$(echo "$line" | grep -i -o -E "^[a-z]*.\s[0-9]*\s")
    ip_address=$(echo "$line" | grep -o -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
    country=$(curl -s https://ipapi.co/$ip_address/country_name/)
  
    if [[ -n "$ip_address" ]]
    then
      echo "$ip_address $country $date" | sudo tee -a /share/log/unauthorized.log 
    fi
  done 
  
  sudo cat /var/log/auth.log | sudo tee /var/log/atemp.log
fi
