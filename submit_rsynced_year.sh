#!/bin/sh
# $1 is supposed to be the rsynced year folder of public pride submissions, with the mothly folders inside, and therein the PXD folders
# execute from where $ reside, e.g.
# pwd
# /hps/nobackup/proteomics/prd_conv
# ./submit_rsynced_year.sh 2016 > bsubmissions_2016.log

function nk_jobid {
    echo $* | head -n1 | cut -d'<' -f2 | cut -d'>' -f1
}

if [ $# -eq 0 ]
    then
        echo "No arguments supplied"
        exit
    else
        echo "$# arguments supplied"
fi

cd $1
echo "spawing for directory: $PWD"
read -p "Are you sure? (y/n)" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # unzip all zips where they are
    # remove all non raw files (save space and make sure the mzMLs are from own conversion)
    # start conversion
    for d in */ ; do
        cd $d
        for pxd in */ ; do
            unz=$(bsub -M 8192 -R 'rusage[mem=8192]' "find $PWD/$pxd -depth -name '*.zip' -execdir unzip -n {} \; -delete")
	    echo "unz $unz"
            jobid=$(nk_jobid $unz)
	    echo "unzip in $jobid"
            cle=$(bsub -w $jobid -M 8192 -R 'rusage[mem=8192]' "find $PWD/$pxd -type f ! -name '*.[Rr][Aa][Ww]' -delete")
            jobid=$(nk_jobid $cle)
	    echo "remove clutter in $jobid"	
            pwi=$(bsub -w $jobid -R 'select[singularity]' -M 8192 -R 'rusage[mem=8192]' "singularity exec docker://mwalzer/pwiz:alpine_v0.5 /utils/singularity.autoconvert.sh /hps/nobackup/proteomics/prd_conv/wine_pwiz_4323-anonym $PWD/${pxd%?}")
            jobid=$(nk_jobid $pwi)
	    echo "convert in $jobid"		
        done
        cd ..
    done

fi

