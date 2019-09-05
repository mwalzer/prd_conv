#!/bin/sh
# $1 is supposed to be the absolute path to the wine env conaining the folder pwiz holding the pwiz wine installation to be used (_but_ without trailing `/`)
# $2 is supposed to be the absolute path to the input file
# to be executed from the folder of $2

### prep wine
ln -s $1 /utils/.wine
#chown -r wine:docker .wine 

### unconverted only
if [ ! -f $2 ]
then 
	echo "Creating ${2%.*}.sha1"
	sha1sum $2 > ${2%.*}.sha1
else
	echo "Skipping sha1; ${2%.*}.mzML exists"
	exit
fi


### commence conversions!
echo "Converting $2 --filter 'peakPicking true 1' -z"
wine msconvert $2 --filter "peakPicking true 1" -z

### unconverted only
if [ -f ${2%.*}.mzML ]
then 
	occ=$(awk '{print $1}' ${2%.*}.sha1 | grep -o -f - ${2%.*}.mzML | wc -l)
	sz=$(ls -lah ${2%.*}.mzML | awk '{ print $5}')
	if [[ $occ -eq 1 ]]
	then
		echo "Removing raw after sha1 check in ${f%.*}.mzML (size $sz)"
		rm ${2%.*}.[Rr][Aa][Ww]
	else
		echo "Conversion failed judging by mzML sha1 for ${2%.*}.mzML (size $sz)"
		rm ${2%.*}.mzML
	fi
else
	echo "Failed to convert to $2"
fi

