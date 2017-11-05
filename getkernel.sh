#!/bin/bash

#https://github.com/aosp-mirror/kernel_common
#https://github.com/aosp-mirror/kernel_msm

type=$1
branch=$2

cat << EOF
usage:
    bash getaosp.sh param1 param2 param3
    param1--the type of aosp kernel source file you want download, 'common' or 'msm'
    param2--the branch you want to get,eg: android-4.4-o-release,android-3.18-o-release
EOF



if [ $type = "common" ]; then
  git clone -b $branch https://github.com/aosp-mirror/kernel_common.git
fi


if [ $type = "common" ]; then
  git clone -b $branch https://github.com/aosp-mirror/kernel_msm.git
fi


