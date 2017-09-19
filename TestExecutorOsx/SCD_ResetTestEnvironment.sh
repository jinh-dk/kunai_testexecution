#! /bin/env bash

echo "Clean folder"
if [ -n "$2" ] &&  [ "$2" == true ]; then     
    . SCD_CleanStripAgentDockerFolder.sh $1 $2
else 
    . SCD_CleanStripAgentDockerFolder.sh
fi 


if [ -n "$3"] && ["$3" == true]; then
    echo "Delete Database and server, api image"
    powershell ../TestExecutor/DeleteDockerSetup.ps1
else
    echo "Delete Database"
    powershell ../TestExecutor/DeleteDatabaseDocker.ps1
fi

echo -e "\033[0;31m Remember to rescan Kallithea after restart the test environment \033[0m"