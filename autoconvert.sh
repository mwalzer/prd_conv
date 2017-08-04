#!/bin/sh
# $1 is supposed to be the folder name or path, _but_ without trailing or leading `/`
# script is supposed to be executed for each folder containing raw files, each of these passed as argument
#all env set for wine?
#folder permissions???

#echo `pwd` 
cd /home/wine/
#echo `pwd`
cp -r pwiz .wine
#chown -r wine:docker .wine 

cd /output
#echo `pwd`
mkdir -p $1
### -p is a fix me for cascading folders dir1/dir2/dir3
cd $1
echo `pwd`
#ln -s /input/$1/*.[Rr]aw .
#echo `ls -lah /output`
#echo `ls -lah /input/$1/*.[Rr]aw`
wine msconvert *.[Rr]aw --filter "peakPicking true 1" -z
