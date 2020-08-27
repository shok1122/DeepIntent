#! /bin/sh

set -eu

(
cd ic3

appDir=$1
forceAndroidJar=$ANDROID_HOME/platforms/android-18/android.jar

rm -rf testspace
mkdir testspace
rm -rf output
mkdir output
var=1
for appPath in `ls $appDir/*.apk`
do
appName=`basename $appPath .apk`
retargetedPath=testspace/$appName.apk

mysql -h localhost --user=root --password=admin --protocol=tcp -e 'drop database if exists cc; create database cc'
mysql -h localhost --user=root --password=admin --protocol=tcp cc < schema

rm -rf output/$appName
mkdir output/$appName

timeout 1800 java -Xmx24000m -jar RetargetedApp.jar $forceAndroidJar $appPath $retargetedPath
timeout 1800 java -Xmx24000m -jar ic3-0.2.0-full.jar -apkormanifest $appPath -input $retargetedPath -cp $forceAndroidJar -protobuf output/$appName
var=$((var+1))
done
echo "finished $var apk files."
)
