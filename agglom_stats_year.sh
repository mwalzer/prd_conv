#!/bin/sh
# $1 is supposed to be the converted year folder of public pride submissions, with the mothly folders inside, and therein the PXD folders
# execute from where $1 resides, e.g.
# pwd
# /hps/nobackup/proteomics/prd_conv
# ./agglom_stats_year.sh 2016 > bsubstats_2016.log

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
    # start project stats
    for d in */ ; do
        cd $d
        for pxd in */ ; do
	    cd $pxd		
            pwi=$(bsub -o /dev/null -R 'select[singularity]' "singularity exec docker://mwalzer/openms-py:v2.1.0 python /homes/walzer/agglom_stats_year.py")
            jobid=$(nk_jobid $pwi)
	    echo "Stats for project $pxd in $jobid"
            cd ..		
        done
        cd ..
    done

fi

