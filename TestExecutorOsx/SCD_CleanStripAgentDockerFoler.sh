#!/usr/bin/

source settings.sh
if [ -z "$1" ]; then 
    echo "Setup folder $masterdockerfolder"    
    folder="$masterdockerfolder"
else
    echo "Setup folder from argument"
    folder="$1"
fi

pushd $folder
pwd
rm -rf BuildServer/volumes/buildserver_01/build/*
rm -rf BuildServer/volumes/buildserver_01/destination/*
rm -rf Kallithea/volumes/repos/.cache
rm -rf Kallithea/volumes/repos/unity-2017/
popd


#curl -X POST -i -H "Content-type: application/json" http//localhost:3080/_admin/settings/mapping