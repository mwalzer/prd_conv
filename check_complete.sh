#!/bin/bash
# $1 is supposed to be the rsynced year folder of public pride submissions, with the mothly folders inside, and therein the PXD folders

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
    exit 1
fi


##TODO replace backticks by $(cmd) notation
cd $1
echo "checking directory:"
echo `pwd`
for d in */ ; do
    cd $d
    for pxd in */ ; do
        #cdir="/hps/nobackup/docker/walzer/output/$1/$d$pxd"
        cdir="/home/walzer/cloud-stuff/prd_conv/test/outtest/$1/$d$pxd"
        echo "outdir $cdir"
        count=`ls -1 $cdir*.mzML 2>/dev/null | wc -l`
        if [ $count = 0 ]; then
                echo "empty"
        else
                echo "got some"
		for f in $cdir*mzML
		do
			validx=`tail -1 $f | grep -c "</\w*mzML>"`
			#echo "is mzML? $validx"
			if [ $validx = 0 ] ; then
				echo "removing incomplete file $f!"
				rm $f
			fi
		done
		
		# check all raw converted
		#raw=$(ls $PWD/$pxd/*[Rr][Aa][Ww] | sed -E 's/^([\/]?.*\/)*(.*)\..*$/\2.NA/')
		#mzml=$(ls -1 $cdir*.mzML 2>/dev/null | sed -E 's/^([\/]?.*\/)*(.*)\..*$/\2.NA/')
		# will only work in bash and is actually not that informative
		#diff <(echo $raw) <(echo $mzml)

		# check all raw are converted, echo unconverted
		for fullfile in $PWD/$pxd/*[Rr][Aa][Ww]
		do
        		filename=$(basename "$fullfile")
        		extension="${filename##*.}"
        		cleanfilename="${filename%.*}"
        		if ! [ -a "$cdir/$cleanfilename.mzML" ] ; then
                		echo $fullfile
        		fi
		done

	fi
	ziped=`ls -1 -d $PWD/$pxd*zip 2>/dev/null`
	if [ ! -z "$ziped" ]; then
		echo "has zips:"
		echo "$ziped"
	fi
	# ** operator seems to not recurse, this ugly construct checks manually up to 3rd level
        nested=$(ls -1 -d $PWD/$pxd/**/*[Rr][Aa][Ww] 2>/dev/null)
	nestedL2=$(ls -1 -d $PWD/$pxd/**/**/*[Rr][Aa][Ww] 2>/dev/null)
        nestedL3=$(ls -1 -d $PWD/$pxd/**/**/**/*[Rr][Aa][Ww] 2>/dev/null)
	#trim whitespaces
        if [ ! -z "$nested" ] || [ ! -z $nestedL2 ] || [ ! -z $nestedL3 ]; then
                echo "has nested raws:"
                echo "$nested"
        fi

    done
    cd ..
done
