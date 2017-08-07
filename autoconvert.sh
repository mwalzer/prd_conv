#!/bin/sh
# $1 is supposed to be the folder name or path, _but_ without trailing or leading `/`
# script is supposed to be executed for each folder containing raw files, each of these passed as argument
#all env set for wine?
#folder permissions???

### prep wine
#echo `pwd` 
cd /home/wine/
#echo `pwd`
cp -r pwiz .wine
#chown -r wine:docker .wine 

### go to writing dir
cd /output
#echo `pwd`
mkdir -p $1
### -p is a fix me for cascading folders dir1/dir2/dir3
cd $1
### logging output
echo "converting into" && echo `pwd`
### start clean
find -type l -delete
### unconverted only
for f in /input/$1/*.[Rr][Aa][Ww]; do 
	s=${f##*/} 
	#echo "$s"
	if [ ! -f /output/$1/${s%.*}.mzML ]
	then 
		#echo "linking $f" 
		ln -s $f . 
	else
		echo "skipping; ${s%.*}.mzML exists"
	fi
done

#echo `ls -lah /output`
#echo `ls -lah /input/$1/*.[Rr][Aa][Ww]`
### commence conversions!
wine msconvert *.[Rr][Aa][Ww] --filter "peakPicking true 1" -z

### stop clean
find -type l -delete

