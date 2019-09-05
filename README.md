# prd_conv

## using docker in lsf
bsub -a 'docker(/homes/walzer/lsf_docker/test2.yaml)' '/home/wine/autoconvert.sh 2016/01/PXD003502

'''
image: mwalzer/pwiz:alpine_v0.1
mount_home: false
mounts:
- /hps/nobackup/proteomics/prd_conv/:/input
- /hps/nobackup/proteomics/prd_conv/wine_pwiz_4323-anonym/:/home/wine/pwiz
write_output: true                                                                          
'''

with mounted in /home/wine/pwiz the complete .wine contents will be copied to utils

## using singularity
bsub -R "select[singularity]" -M 8192 -R "rusage[mem=8192]" "singularity exec docker://mwalzer/pwiz:alpine_v0.5 /utils/singularity.autoconvert.sh /hps/nobackup/proteomics/prd_conv/wine_pwiz_4323-anonym /hps/nobackup/proteomics/prd_conv/test"

## using singularity and a per file parallelised version
for f in *.raw; do if [[ ! -r ${f%.*}.mzML  ]] ; then bsub -e ${f%.*}.pwiz.err -o ${f%.*}.pwiz.out -R "sele
ct[singularity]" -M 16192 -R "rusage[mem=16192]" "singularity exec docker://mwalzer/pwiz:alpine_v0.5 /hps/n
obackup/proteomics/prd_conv/singularity.singletconvert.sh /hps/nobackup/proteomics/prd_conv/wine_pwiz_4323-
anonym $f"; fi; done

