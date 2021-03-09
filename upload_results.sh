
# Upload the results to the designated google cloud bucket
qlogin -q interactive -l h_vmem=20g -l h_rt=10:00:00


# cd /psych/genetics_data/yfeng/covid_hg/results/20200915
cd /psych/genetics_data/yfeng/covid_hg/results/20210301
gsutil -m cp *PHBB*AFR*gz gs://covid19-hg-upload-partnersbiobank
gsutil -m cp *PHBB*HIS*gz gs://covid19-hg-upload-partnersbiobank
gsutil -m cp *PHBB*EUR*gz gs://covid19-hg-upload-partnersbiobank 
