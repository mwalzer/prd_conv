#!/bin/sh
# $1 is supposed to be the rsynced year folder of public pride submissions, with the mothly folders inside, and therein the PXD folders
# execute from where $ reside, e.g.
# pwd
# /hps/nobackup/proteomics/prd_conv
# ./submit_rsynced_year.sh 2016 > bsubmissions_2016.log

function nk_jobid {
    output=$($*)
    echo $output | head -n1 | cut -d'<' -f2 | cut -d'>' -f1
}

if [ $# -eq 0 ]
  then
    echo "No arguments supplied"
fi

cd $1
echo "spawing for directory:"
echo `pwd`
for d in */ ; do
    cd $d
    for pxd in */ ; do
#bsub -a 'docker(/homes/walzer/lsf_docker/test2.yaml)' '/home/wine/autoconvert.sh 2016/01/PXD003502'
	# bsub -M <exit when exceeding> -R "rusage[mem=<MB RAM requested>]" -p <project> -a <application>
        #mycmd=$(echo "bsub -M 8192 -R "rusage[mem=8192]" -P docker -a 'docker(/homes/walzer/lsf_docker/test2.yaml)' '/home/wine/autoconvert.sh "$1"/"$d""${pxd%/}"'" | xargs)
        mycmd=$(echo "bsub -a 'docker(/homes/walzer/lsf_docker/test2.yaml)' '/home/wine/autoconvert.sh "$1"/"$d""${pxd%/}"'" | xargs)
        jobid=$(nk_jobid ${mycmd%\\})
        echo "submitting ${pxd%/} as $jobid"       
        echo "=$mycmd"
    done
    cd ..
done
