#!/bin/bash
set -x

# monitor.sh checks to see if there are any changes to /var/webserver_monitor/unauthorized.log. 
#  If there are new entries, an email should be sent to the admin with the content of these new entries. 
#  Otherwise, the email simply says "No unauthorized access."


# A temporary log, atemp.log, is either created or appended to. This log is used to discern if there are
#  any changes that were made to unauthorized.log by utilizing the diff command. All changes are stored 
#  in variable $isdifflog.
echo -n '' | sudo tee -a /webserver_log/atemp.log

isdifflog=$(sudo diff /webserver_log/unauthorized.log /webserver_log/atemp.log)

# A check is made to see if $isdifflog is "", signifying any differences between atemp.log and 
#  unauthorized.log.
# If $isdifflog is not "", then an email is sent to the user with the subject line: "New Unauthorized 
#  Access," and the contents of $isdifflog. Then, the contents of atemp.log are overwritten by the
#  contents of unauthorized.log to prepare them for the next time this shell file runs.
# If $isdifflog is "", then an email is sent to the suer with the subject line: "No New Unauthorized
#  Access."
if [[ "$isdifflog" != "" ]] 
then
  echo -n "Unauthorized access report: $isdifflog" | mail -s "New Unauthorized Access" so749257@wcupa.edu
  sudo cat /webserver_log/unauthorized.log | sudo tee /webserver_log/atemp.log
else
  echo "No unauthorized access" | mail -s "No New Unauthorized Access" so749257@wcupa.edu
fi
