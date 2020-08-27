#!/bin/sh

(
cd bin
jar -cvfm APKCallGraph.jar META-INF/MANIFEST.MF *.class
mv APKCallGraph.jar ../
)

