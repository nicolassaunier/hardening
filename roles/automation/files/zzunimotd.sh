[ -z "$PS1" ] && return

#!/bin/sh
clear

# Color
RED='\033[0;31m' # Red
GRN='\033[0;32m' # Green
YLW='\033[0;33m' # Yellow
BLU='\033[0;34m' # Blue
PRP='\033[0;35m' # Purple
CYA='\033[0;36m' # Cyan
RST='\033[0m' # Reset color

DISTRIB=$(cat /etc/redhat-release)

UPTIME=$(uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes."}')

# Read Load average
read one five fifteen rest < /proc/loadavg

# Find process number
PROCESS=$(ps ax -o stat,command --no-headers | grep -v "ps ax")
RUNNING="$(echo "$PROCESS" | wc -l) ($(echo "$PROCESS" | grep '^R' | wc -l) running)"

# Find apps deployed on each tomuni
TOMUNI=$(ls /home | grep tomuni)
if [ -z "$TOMUNI" ]; then
        ROLES=""
else
        for T in $TOMUNI; do
                #APP=$(find /home/$T/tomcat/webapps/*.war -maxdepth 1 -type f 2>/dev/null | cut -d '/' -f 6 | sed 's/\.war$//' | paste -d'|' -s)
                APP=$(find /home/$T/tomcat/webapps/*.war -maxdepth 1 -type f 2>/dev/null | cut -d '/' -f 6 | sed 's/\.war$//' | awk '{print}' ORS=" $RST|$GRN " )
                ROLES+="     $BLU$T$RST :: $GRN$APP$RST\n"
        done
fi


echo -e "
$RED   * * * * * * * * * * : U N I B A I L - R O D A M C O : * * * * * * * * * * $RST

     $(last -5 | grep pts | grep -v "still logged" | head -1 | awk '{printf "Last login..: " $4 " " $5 " " $6 " " $7 " by " $1 " from " $3}')
     Distrib.....: $GRN$DISTRIB$RST
     Hostname....: $GRN$(hostname)$RST
     IP address..: $GRN$(hostname -I | cut -d ' ' -f 1)$RST
     Uptime......: $GRN$UPTIME$RST

     Load Average: $GRN${one}, ${five}, ${fifteen} (1, 5, 15 min)$RST
     Mem usage...: $GRN$(free | grep Mem | awk '{print $3/$2 * 100.0}' | cut -d '.' -f1)% of $(free | grep Mem | awk '{print $2/1024}') MB$RST
     Swap usage..: $GRN$(cat /proc/swaps | tail -1 | awk '{print $4/$3 * 100.0 "% of " $3/1024" MB"}')$RST

     User........: $GRN$(uptime | grep -ohe '[0-9.*] user[s]*')$RST
     Process.....: $GRN$RUNNING$RST

$RED   - - - - - - - - - - - - - - - - R o l e s - - - - - - - - - - - - - - - - $RST

$ROLES
$GRN$([[ ! -f /etc/profile.d/uniroles ]] || cat /etc/profile.d/uniroles)$RST

$RED   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * $RST

"

