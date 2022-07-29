#!/bin/bash
set -x

# Check to see if there are any changes to /var/webserver_monitor/unauthorized.log. 
#  If there are new entries, an email should be sent to the admin with the content of these new entries. 
#  Otherwise, the email simply says "No unauthorized access."

echo -n '' | sudo tee -a /webserver_log/atemp.log

isdifflog=$(sudo diff /webserver_log/unauthorized.log /webserver_log/atemp.log)

if [[ "$isdifflog" != "" ]] 
then
  echo -n "Unauthorized access report: $isdifflog" | mail -s "New Unauthorized Access" so749257@wcupa.edu
  sudo cat /webserver_log/unauthorized.log | sudo tee /webserver_log/atemp.log"
else
  echo "No unauthorized access" | mail -s "No New Unauthorized Access" so749257@wcupa.edu
fi
