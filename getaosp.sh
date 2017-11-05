#!/bin/bash

# 
# repository aosp-mirror.github.io(https://github.com/aosp-mirror/aosp-mirror.github.io)
# repo art https://github.com/aosp-mirror/art is empty
# 2017.10.18 now https://github.com/aosp-mirror?page=1 has 97 real repositories.


aosproot=$1
branch=$2
repourl=$3

gitclone()
{
    url=$1                              #eg:https://github.com/aosp-mirror/platform_packages_apps_stk.git
    suffix=${url#*_}                    #eg:packages_apps_stk.git
    len=$(expr length $suffix)          #eg:the char number of 'packages_apps_stk.git'
    entry_all=${suffix:0:$len-4}        #eg:packages_apps_stk
    dst=$(echo $entry_all | tr _ /)     #eg:packages/apps/stk
    
    git clone -v -b $branch $url dst
}

cat << EOF
usage:
    bash getaosp.sh param1 param2 param3
    param1--the location of aosp source file you want download
    param2--the branch you want to get
    param3--the location of database.txt
EOF

cd $aosproot
cat $repourl | while read line
do
    echo ${line}.git
    gitclone ${line}.git
done

