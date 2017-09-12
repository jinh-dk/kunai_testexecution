#!/usr/bin

if [ -n "$1" ]; then
    pushd ../../dev/
    git clone https://github.com/Unity-Technologies/Kunai.git "$1"
    cd "$1"
    git submodule update --init
    pushd
else 
    echo -e "CloneKunai.sh \033[0;31m foldername \033[0m, foldername is mandatory to give"
fi