#! /bin/env bash

echo "Clean folder"
if [ -n "$2" ] &&  [ "$2" == true ]; then     
    . SCD_CleanStripAgentDockerFoler.sh $1 $2
else 
    . SCD_CleanStripAgentDockerFoler.sh
fi 
echo "Delete Database"
powershell ../TestExecutor/DeleteDatabaseDocker.ps1

echo echo -e "\033[0;31m Remember to rescan Kallithea after restart the test environment \033[0m"