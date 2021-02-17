
# Upload the results to the designated google cloud bucket

cd /psych/genetics_data/yfeng/covid_hg/results/20200915
gsutil -m cp *AFR*gz gs://covid19-hg-upload-partnersbiobank
gsutil -m cp *HIS*gz gs://covid19-hg-upload-partnersbiobank
gsutil -m cp *EUR*gz gs://covid19-hg-upload-partnersbiobank 
