#!/bin/bash

logfile=./.main.log
: > "$logfile"  # Clears log file

echo "$(date '+%Y-%m-%d %H:%M:%S') - ********** Started Script **********" >> main.log 2>&1
echo "In Progress... | For details please review $logfile"
source ./init.sh >> "$logfile" 2>&1
source ./appdb.sh >> "$logfile" 2>&1
source ./om.sh >> "$logfile" 2>&1


# Pre-reqs
identitfy_platform >> "$logfile" 2>&1
install_reqs >> "$logfile" 2>&1
setup_vars >> "$logfile" 2>&1

# appdb setup
setup_appdb >> "$logfile" 2>&1
startup_appdb >> "$logfile" 2>&1

echo "$(date '+%Y-%m-%d %H:%M:%S') - ********** Completed Script **********" >> "$logfile" 2>&1