#!/bin/sh
# $1 is supposed to be the rsynced year folder of public pride submissions, with the mothly folders inside, and therein the PXD folders

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
        mycmd=$(echo "bsub -a 'docker(/homes/walzer/lsf_docker/test2.yaml)' '/home/wine/autoconvert.sh "$1"/"$d""${pxd%/}"'" | xargs)
        jobid=$(nk_jobid ${mycmd%\\})
        echo "submitting ${pxd%/} as $jobid"       
        echo "=$mycmd"
    done
    cd ..
done