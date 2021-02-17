
scr=/psych/genetics_data/yfeng/covid_hg/scripts
log=/psych/genetics_data/yfeng/covid_hg/logs/
outdir=/psych/genetics_data/yfeng/covid_hg/results/20200915

#####
# EUR

# autosome
indir=/psych/genetics_data/yfeng/covid_hg/genetic_data/eur_rel
pop=eur;ana=c1;n_parts=100
pop=eur;ana=c2;n_parts=100
for chr in {22..1}; do
    qsub -j y -l h_vmem=10g -l h_rt=24:00:00 -t 1-${n_parts} -o $log/20200915_${pop}_saige_step2_${ana}.out $scr/run_saige_step2.sh ${indir} ${outdir} ${pop} ${ana} ${chr} ${n_parts}
done

# chrX
indir=/psych/genetics_data/yfeng/covid_hg/genetic_data/eur_rel
pop=eur;ana=c1;n_parts=100
pop=eur;ana=c2;n_parts=100
chr=X
qsub -j y -l h_vmem=10g -l h_rt=24:00:00 -t 1-${n_parts} -o $log/20200915_${pop}_saige_step2_${ana}.out $scr/run_saige_step2.sh ${indir} ${outdir} ${pop} ${ana} ${chr} ${n_parts}




######
# AFR

# autosome
indir=/humgen/diabetes2/users/josep/PartnersBIOBANK/merge_all_35K_datasets/merge_35K_genotypes/AFR/imputation_TOPMED_R2_RELATED_AFR/
pop=afr;ana=c1;n_parts=100
pop=afr;ana=c2;n_parts=100
for chr in {22..1}; do
    qsub -j y -l h_vmem=10g -l h_rt=8:00:00 -t 1-${n_parts} -o $log/20200915_${pop}_saige_step2_${ana}.out $scr/run_saige_step2.sh ${indir} ${outdir} ${pop} ${ana} ${chr} ${n_parts}
done

# chrX
indir=/psych/genetics_data/yfeng/covid_hg/genetic_data/afr_rel
pop=afr;ana=c1;n_parts=100
pop=afr;ana=c2;n_parts=100
chr=X
qsub -j y -l h_vmem=10g -l h_rt=8:00:00 -t 1-${n_parts} -o $log/20200915_${pop}_saige_step2_${ana}.out $scr/run_saige_step2.sh ${indir} ${outdir} ${pop} ${ana} ${chr} ${n_parts}



######
# HIS

# autosome
indir=/humgen/diabetes2/users/josep/PartnersBIOBANK/merge_all_35K_datasets/merge_35K_genotypes/HIS/imputation_TOPMED_R2_RELATED_HIS/
pop=his;ana=c1;n_parts=100
pop=his;ana=c2;n_parts=100
for chr in {22..1}; do
    qsub -j y -l h_vmem=10g -l h_rt=8:00:00 -t 1-${n_parts} -o $log/20200915_${pop}_saige_step2_${ana}.out $scr/run_saige_step2.sh ${indir} ${outdir} ${pop} ${ana} ${chr} ${n_parts}
done

# chrX
indir=/psych/genetics_data/yfeng/covid_hg/genetic_data/his_rel/
pop=his;ana=c1;n_parts=100
pop=his;ana=c2;n_parts=100
chr=X
qsub -j y -l h_vmem=10g -l h_rt=8:00:00 -t 1-${n_parts} -o $log/20200915_${pop}_saige_step2_${ana}-test.out $scr/run_saige_step2.sh ${indir} ${outdir} ${pop} ${ana} ${chr} ${n_parts}




#########
# Stratified analysis

scr=/psych/genetics_data/yfeng/covid_hg/scripts
log=/psych/genetics_data/yfeng/covid_hg/logs/
outdir=/psych/genetics_data/yfeng/covid_hg/results/20200915

#####
# EUR
indir=/psych/genetics_data/yfeng/covid_hg/genetic_data/eur_rel
pop=eur;ana=c1;n_parts=100
pop=eur;ana=c2;n_parts=100
strata=male
strata=female
strata=age.le.60
strata=age.gt.60

# for chr in {22..1}; do
for strata in male female age.le.60 age.gt.60; do 
    qsub -j y -l h_vmem=10g -l h_rt=24:00:00 -t 1-${n_parts} -o $log/20200915_${pop}_saige_step2_${ana}-${strata}.out $scr/run_saige_step2-stratified.sh ${indir} ${outdir} ${pop} ${ana} ${chr} ${n_parts} ${strata}
done

