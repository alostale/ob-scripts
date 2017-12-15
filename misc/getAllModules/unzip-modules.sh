tar xvf allMods.tgz
mv tmp/allMods obx
mkdir src
for f in `ls -1 obx/*`; do unzip -l $f; done > contents
for f in `ls -1 obx/*`; do unzip $f -d src; done
