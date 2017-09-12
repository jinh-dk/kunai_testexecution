#!/usr/bin

if [ -n "$1" ]; then
    pushd ../../dev/
    git clone https://github.com/Unity-Technologies/Kunai.git "$1"
    cd "$1"
    git submodule update --init
    pushd
else 
    echo "CloneKunai.sh folername,  foldername is mandatory to give"
fi