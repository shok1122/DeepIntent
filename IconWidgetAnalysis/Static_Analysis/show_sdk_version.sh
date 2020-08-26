#!/bin/bash

dir=$1

function show_version()
{
	echo "> apk: $1"
	echo ">   target_sdk: $2"
	echo ">   min_sdk: $3"
}

for f in $(ls $dir)
do
	path=$dir/$f
	min_sdk_version=$(aapt l -a $path | grep "minSdkVersion" | cut -d = -f 2)
	target_sdk_version=$(aapt l -a $path | grep "targetSdkVersion" | cut -d = -f 2)
	show_version "$(basename $path)" "$min_sdk_version" "$target_sdk_version"
	echo ""
done

