#!/bin/sh
# $1 is supposed to be the absolute path to the wine env conaining the folder pwiz holding the pwiz wine installation to be used (_but_ without trailing `/`)
# $2 is supposed to be the absolute path to the input folder , _but_ without trailing or leading `/`
# script is supposed to be executed for each folder containing raw files, each of these passed as argument
#all env set for wine?
#folder permissions???

### prep wine
ln -s $1 /utils/.wine
#chown -r wine:docker .wine 

### unconverted only
for f in $2/*.[Rr][Aa][Ww]; do 
	if [ ! -f ${f%.*}.mzML ]
	then 
		echo "Creating ${f%.*}.sha1"
		sha1sum $f > ${f%.*}.sha1
	else
		echo "Skipping sha1; ${f%.*}.mzML exists"
	fi
done

### changing to 
cd $2

### commence conversions!
echo "Converting *.[Rr][Aa][Ww] --filter 'peakPicking true 1' -z from folder $2"
wine msconvert *.[Rr][Aa][Ww] --filter "peakPicking true 1" -z

### unconverted only
for f in $2/*.sha1; do 
	if [ -f ${f%.*}.mzML ]
	then 
		occ=$(awk '{print $1}' ${f%.*}.sha1 | grep -o -f - ${f%.*}.mzML | wc -l)
		sz=$(ls -lah ${f%.*}.mzML | awk '{ print $5}')
		if [[ $occ -eq 1 ]]
		then
			echo "Removing raw after sha1 check in ${f%.*}.mzML (size $sz)"
			rm ${f%.*}.[Rr][Aa][Ww]
		else
			echo "Conversion failed judging by mzML sha1 for ${f%.*}.mzML (size $sz)"
			rm ${f%.*}.mzML
		fi
	else
		echo "Failed to convert to ${f%.*}.mzML"
	fi
done
