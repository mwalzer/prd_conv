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
