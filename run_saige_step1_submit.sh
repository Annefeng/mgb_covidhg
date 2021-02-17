
scr=/psych/genetics_data/yfeng/covid_hg/scripts
log=/psych/genetics_data/yfeng/covid_hg/logs/

indir=/psych/genetics_data/yfeng/covid_hg/pheno/20200915
outdir=/psych/genetics_data/yfeng/covid_hg/results/20200915

####
pop=eur
for ana in c1 c2; do 
    qsub -j y -l h_vmem=10g -l h_rt=15:00:00 -o $log/20200915_${pop}_saige_step1_${ana}.out $scr/run_saige_step1.sh ${indir} ${outdir} ${pop} ${ana}
done

pop=afr
for ana in c1 c2; do
    qsub -j y -l h_vmem=10g -l h_rt=15:00:00 -o $log/20200915_${pop}_saige_step1_${ana}.out $scr/run_saige_step1.sh ${indir} ${outdir} ${pop} ${ana}
done

pop=his
for ana in c1 c2; do
    qsub -j y -l h_vmem=10g -l h_rt=15:00:00 -o $log/20200915_${pop}_saige_step1_${ana}.out $scr/run_saige_step1.sh ${indir} ${outdir} ${pop} ${ana}
done



####
# Stratified analysis
pop=eur;ana=c1
strata=female
strata=male
covars=$(echo "age,age2,pc1,pc2,pc3,pc4,pc5,pc6,pc7,pc8,pc9,pc10")
qsub -j y -l h_vmem=10g -l h_rt=15:00:00 -o $log/20200915_${pop}_saige_step1_${ana}-${strata}.out $scr/run_saige_step1-stratified.sh ${indir} ${outdir} ${pop} ${ana} ${strata} ${covars}

strata=age.le.60
strata=age.gt.60
covars=$(echo "sex,age,age2,agexsex,pc1,pc2,pc3,pc4,pc5,pc6,pc7,pc8,pc9,pc10")
qsub -j y -l h_vmem=10g -l h_rt=15:00:00 -o $log/20200915_${pop}_saige_step1_${ana}-${strata}.out $scr/run_saige_step1-stratified.sh ${indir} ${outdir} ${pop} ${ana} ${strata} ${covars}


####
pop=eur;ana=c2
strata=female
strata=male
covars=$(echo "age,age2,pc1,pc2,pc3,pc4,pc5,pc6,pc7,pc8,pc9,pc10")
qsub -j y -l h_vmem=10g -l h_rt=15:00:00 -o $log/20200915_${pop}_saige_step1_${ana}-${strata}.out $scr/run_saige_step1-stratified.sh ${indir} ${outdir} ${pop} ${ana} ${strata} ${covars}

strata=age.le.60
strata=age.gt.60
covars=$(echo "sex,age,age2,agexsex,pc1,pc2,pc3,pc4,pc5,pc6,pc7,pc8,pc9,pc10")
qsub -j y -l h_vmem=10g -l h_rt=15:00:00 -o $log/20200915_${pop}_saige_step1_${ana}-${strata}.out $scr/run_saige_step1-stratified.sh ${indir} ${outdir} ${pop} ${ana} ${strata} ${covars}
