set -eu

apk_dir=$1
sdk_dir=$ANDROID_SDK
apktool_dir=$APKTOOL_HOME

rm -rf ./log_output
rm selectedAPK.txt

for x in $(ls $apk_dir)
do
	echo ${x%.*} >> selectedAPK.txt
done

#! /bin/sh
cd /DeepIntent/IconWidgetAnalysis/Static_Analysis/
#get apk names list
python3 getAPKNames.py $apk_dir #argv[1]: Your apk folder directory

mkdir /DeepIntent/IconWidgetAnalysis/Static_Analysis/gator-IconIntent/output
#run gator
#argv[1] Your apk folder directory
#argv[2] Your Android sdk directory
#argv[3] Your apktool.jar's directory, it is included in gator-IconIntent folder
python3 /DeepIntent/IconWidgetAnalysis/Static_Analysis/gator-IconIntent/gator.py $apk_dir $sdk_dir $apktool_dir

rm -rf /DeepIntent/IconWidgetAnalysis/Static_Analysis/output
mv /DeepIntent/IconWidgetAnalysis/Static_Analysis/gator-IconIntent/output/ /DeepIntent/IconWidgetAnalysis/Static_Analysis/

rm -rf permission_output
rm -rf dot_output
mkdir output/img2widgets
mkdir permission_output
mkdir dot_output

#run icon-widget-handler association
java -jar wid.jar $apk_dir #argv[1]: Your apk folder directory
java -jar ImageToWidgetAnalyzer.jar output/ output/ output/ selectedAPK.txt

#run ic3
sh ./ic3/runic3.sh $apk_dir #argv[1]: Your apk folder directory

#run handler-permission association
for app in `ls /$apk_dir/*.apk`
do
echo $app
java -jar APKCallGraph.jar $app $apk_dir /DeepIntent/IconWidgetAnalysis/Static_Analysis/img2widgets/ /DeepIntent/IconWidgetAnalysis/Static_Analysis/permission_output/ /DeepIntent/IconWidgetAnalysis/Static_Analysis/ic3/output/
done

#combine results and get 1-to-more mapping using 1tomore.txt
python3 combine.py /permission_output/
python3 map1tomore.py #change the input and output file names and paths at line 4, 5, and 6.
