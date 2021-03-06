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
fi

cd $1

for d in */ ; do
    cd $d
    unz=$(bsub -M 8192 -R 'rusage[mem=8192]' find . -depth -name '*.zip' -execdir unzip -n {} \; -delete)
    jobid=$(nk_jobid unz)
    cle=$(bsub -w $jobid -M 8192 -R 'rusage[mem=8192]' find . -type f ! -name '*.[Rr][Aa][Ww]' -delete)
    jobid=$(nk_jobid cle)
    mycmd=$(bsub -R 'select[singularity]' -M 8192 -R 'rusage[mem=8192]' 'singularity exec docker://mwalzer/pwiz:alpine_v0.5 /utils/singularity.autoconvert.sh /hps/nobackup/proteomics/prd_conv/wine_pwiz_4323-anonym $PWD/${pxd%?}')

    cd ..
done
