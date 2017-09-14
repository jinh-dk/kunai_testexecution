#!/usr/bin/
source settings.sh
if [ -z "$1" ]; then 
    echo "Setup folder $masterdockerfolder"    
    folder="$masterdockerfolder"
else
    echo "Setup folder from argument"
    folder="$1"
fi

echo $folder
cd $folder
$pwd
rm -rf BuildServer/volumes/buildserver_01/build/*
rm -rf BuildServer/volumes/buildserver_01/destination/*
rm -rf Kallithea/volumes/repos/.cache
rm -rf Kallithea/volumes/repos/unity-2017/
cd -