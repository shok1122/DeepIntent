#!/bin/sh

JARS=lib/axml-2.0.jar
JARS=${JARS}:lib/ic3-0.2.0.jar
JARS=${JARS}:lib/jgraph-5.13.0.0.jar
JARS=${JARS}:lib/jgraph-5.13.0.0-sources.jar
JARS=${JARS}:lib/jgrapht-core-1.0.1.jar
JARS=${JARS}:lib/jgrapht-ext-1.0.1.jar
JARS=${JARS}:lib/jgrapht-ext-1.0.1-uber.jar
JARS=${JARS}:lib/jgraphx-2.0.0.1.jar
JARS=${JARS}:lib/json-simple-1.1.1.jar
JARS=${JARS}:lib/mysql-connector-java-8.0.13.jar
JARS=${JARS}:lib/protobuf-java-3.6.1.jar
JARS=${JARS}:lib/protobuf-java-format-1.2.jar
JARS=${JARS}:lib/slf4j-api-1.7.5.jar
JARS=${JARS}:lib/slf4j-simple-1.7.5.jar
JARS=${JARS}:lib/sootclasses-trunk.jar
JARS=${JARS}:lib/sootclasses-trunk-sources.jar
JARS=${JARS}:lib/soot-infoflow-android.jar
JARS=${JARS}:lib/soot-infoflow.jar
JARS=${JARS}:lib/soot-trunk.jar
JARS=${JARS}:/usr/lib/jvm/java-1.8.0-amazon-corretto/jre/lib/ext

(
javac -sourcepath src -classpath $JARS src/APKCallGraph.java -d bin2
cd bin2
jar -cvfm APKCallGraph.jar META-INF/MANIFEST.MF *.class
mv APKCallGraph.jar ../
)

