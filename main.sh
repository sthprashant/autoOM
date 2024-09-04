#!/bin/bash

: > main.log  # Clears log file

echo "$(date '+%Y-%m-%d %H:%M:%S') - ********** Started Script **********" >> main.log 2>&1
echo "In Progress... | For details please review main.log"
source ./init.sh >> main.log 2>&1
source ./appdb.sh >> main.log 2>&1
source ./om.sh >> main.log 2>&1


# Pre-reqs
identitfy_platform >> main.log 2>&1
install_reqs >> main.log 2>&1
setup_vars >> main.log 2>&1

# appdb setup
setup_appdb >> main.log 2>&1
startup_appdb >> main.log 2>&1

echo "$(date '+%Y-%m-%d %H:%M:%S') - ********** Completed Script **********" >> main.log 2>&1