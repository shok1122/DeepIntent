#!/bin/bash

function download()
{
	version=$1
	wget -P /tmp/apktool https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_${version}.jar
}

mkdir /tmp/apktool

download 2.4.1
download 2.4.0
download 2.3.4
download 2.3.3
download 2.3.2
download 2.3.1
download 2.3.0
download 2.2.4
download 2.2.3
download 2.2.2
download 2.2.1
download 2.2.0
download 2.1.1
download 2.1.0
download 2.0.3
download 2.0.2
download 2.0.1
download 2.0.0

