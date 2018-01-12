#!/bin/bash

# 
# repository aosp-mirror.github.io(https://github.com/aosp-mirror/aosp-mirror.github.io)
# repo art https://github.com/aosp-mirror/art is empty
# 2017.10.18 now https://github.com/aosp-mirror?page=1 has 97 real repositories.

cat << EOF
usage:
    bash getaosp.sh param1 param2 param3
    param1--the location of aosp source file you want download
    param2--the branch you want to get
    param3--the location of repository_readonly.txt
    param4--the location of repository_writable.txt
EOF

gitclone()
{
    url=$1                              #eg:https://github.com/aosp-mirror/platform_packages_apps_stk.git
    suffix=${url#*_}                    #eg:packages_apps_stk.git
    len=$(expr length $suffix)          #eg:the char number of 'packages_apps_stk.git'
    entry_all=${suffix:0:$len-4}        #eg:packages_apps_stk
    dst=$(echo $entry_all | tr _ /)     #eg:packages/apps/stk
    
    git clone -v -b $branch $url $dst
}

gitclonepush()
{
    url=$1                              #eg:https://github.com/AOSPSRC/platform_system_adb.git
    suffix=${url#*_}                    #eg:system_adb.git
    len=$(expr length $suffix)          #eg:the char number of 'system_adb.git'
    entry_all=${suffix:0:$len-4}        #eg:system_adb
    dst=$(echo $entry_all | tr _ /)     #eg:system/adb
    
    git clone -v -b $branch $url $dst


    cd $dst
    git config http.proxy http://10.100.2.154:3128
    git remote add googlesource https://android.googlesource.com/platform/$dst
    cd -




    #git fetch googlesource
    #git checkout $branch
    #git merge googlesource/$branch
    #git push origin $branch
}

sync()
{
    url=$1                              #eg:https://github.com/AOSPSRC/platform_system_adb.git
    suffix=${url#*_}                    #eg:system_adb.git
    len=$(expr length $suffix)          #eg:the char number of 'system_adb.git'
    entry_all=${suffix:0:$len-4}        #eg:system_adb
    dst=$(echo $entry_all | tr _ /)     #eg:system/adb

    cd $dst
    git fetch googlesource
    git checkout $branch
    git merge googlesource/$branch
    git push #git push origin $branch
    cd -

}

aosproot=$1
branch=$2
repository_readonly=$3
repository_writable=$4

# just clone read-only repositories from https://github.com/aosp-mirror
cd $aosproot
cat $repository_readonly | while read line
do
    echo ${line}.git
    gitclone ${line}.git
done


# clone and push repositories from https://github.com/AOSPSRC
# in this situation, the $branch we want to get is master usually.
cd $aosproot
cat $repository_writable | while read line
do
    echo ${line}.git
    gitclonepush ${line}.git
done

# sync periodic
cd $aosproot
cat $repository_writable | while read line
do
    echo ${line}.git
    sync ${line}.git
done
