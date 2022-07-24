#!/bin/bash
set -x

# Check to see if there are any changes to /var/webserver_monitor/unauthorized.log. 
#  If there are new entries, an email should be sent to the admin with the content of these new entries. 
#  Otherwise, the email simply says "No unauthorized access."

isdifflog='diff /webserver_log/unauthorized.log /webserver_log/temp.log'

if [[ $isdifflog -eq 0 ]]
then
  echo "No unauthorized access" | mail -s "No New Unauthorized Access" so749257@wcupa.edu
else
  echo -n "Unauthorized access report: $isdifflog" | mail -s "New Unauthorized Access" so749257@wcupa.edu
fi

sudo bash -c "cat /webserver_log/unauthorized.log > /webserver_log/temp.log"
