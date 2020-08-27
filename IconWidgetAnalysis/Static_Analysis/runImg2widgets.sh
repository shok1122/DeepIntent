set -eu

apk_dir=$1
sdk_dir=$ANDROID_HOME
gator_root=gator-IconIntent

rm -rf ./log_output
rm -f selectedAPK.txt
rm -f result.txt

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
python3 gator-IconIntent/gator.py $apk_dir $sdk_dir $gator_root

#rm -rf /DeepIntent/IconWidgetAnalysis/Static_Analysis/output
#mv /DeepIntent/IconWidgetAnalysis/Static_Analysis/gator-IconIntent/output /DeepIntent/IconWidgetAnalysis/Static_Analysis/gator_output

rm -rf permission_output
rm -rf dot_output
mkdir permission_output
mkdir dot_output

#run icon-widget-handler association
(
cd WidImageResolver
java -jar ../wid.jar $apk_dir #argv[1]: Your apk folder directory
mv output/* ../output
)
java -jar ImageToWidgetAnalyzer.jar output output output/img2widgets selectedAPK.txt

#run ic3
sh ./ic3/runic3.sh $apk_dir #argv[1]: Your apk folder directory

python3 parse_mappings.py jellybean_allmappings.txt
mysql -h localhost --user=root --password=jiaozhuys05311 --protocol=tcp -e 'drop database if exists APKCalls; create database APKCalls'
mysql -h localhost --user=root --password=jiaozhuys05311 --protocol=tcp APKCalls < schema_APKCalls

#run handler-permission association
for app in `ls $apk_dir/*.apk`
do
echo $app
java -jar APKCallGraph/APKCallGraph.jar $app $apk_dir output/img2widgets permission_output ic3/output
done

#combine results and get 1-to-more mapping using 1tomore.txt
python3 combine.py /permission_output/
python3 map1tomore.py #change the input and output file names and paths at line 4, 5, and 6.
