#!/bin/sh
# $1 is supposed to be the absolute path to the wine env conaining the folder pwiz holding the pwiz wine installation to be used (_but_ without trailing `/`)
# $2 is supposed to be the absolute path to the input folder , _but_ without trailing or leading `/`
# script is supposed to be executed for each folder containing raw files, each of these passed as argument
#all env set for wine?
#folder permissions???

### prep wine
cp -r $1 /utils/.wine
#chown -r wine:docker .wine 

### unconverted only
for f in $2/*.[Rr][Aa][Ww]; do 
	if [ ! -f ${f%.*}.mzML ]
	then 
		echo "creating ${f%.*}.sha1"
		sha1sum $f > ${f%.*}.sha1
	else
		echo "skipping; ${f%.*}.mzML exists"
	fi
done

### changing to 
cd $1

### commence conversions!
echo "converting *.[Rr][Aa][Ww]  --filter 'peakPicking true 1' -z from folder $2"
wine msconvert *.[Rr][Aa][Ww] --filter "peakPicking true 1" -z

### unconverted only
for f in $2/*.sha1; do 
	if [ ! -f ${f%.*}.mzML ]
	then 
		occ=$(awk '{print $1}' ${f%.*}.sha1 | grep -o -f - ${f%.*}.mzML | wc -l)
		if [[ $occ -eq 1 ]]
		then
			echo "removing after sha1 check in mzML ${f%.*}.mzML"
			rm ${f%.*}.[Rr][Aa][Ww]
		else
			sz=$(ls -lah ${f%.*}.mzML | awk '{ print $5}')
			echo "conversion failed judging by mzML sha1 for ${f%.*}.mzML (size $sz)"
		fi
	else
		echo "Failed to convert to ${f%.*}.mzML"
	fi
done
