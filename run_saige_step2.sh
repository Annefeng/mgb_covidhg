#! /bin/bash

indir=$1
outdir=$2
pop=$3
ana=$4
chr=$5
n_parts=$6


source /broad/software/scripts/useuse
reuse -q UGER
reuse Anaconda
export R_LIBS="/home/unix/yfeng/.conda/envs/RSAIGE/lib/R/library"

source activate RSAIGE

# Run SAIGE step 2
saige=/psych/genetics_data/yfeng/software/SAIGE/extdata
misc=/psych/genetics_data/yfeng/covid_hg/misc_data/


head=1
tail=250000000
((snps_per_part = (tail - head + 1) / ${n_parts}))
((start = head + snps_per_part*(${SGE_TASK_ID} - 1 )))
((end = head + snps_per_part *${SGE_TASK_ID} - 1 ))

echo "snps_per_part: "$snps_per_part
echo "start: "$start
echo "end: "$end


Rscript ${saige}/step2_SPAtests.R \
--vcfFile=${indir}/chr${chr}.dose.vcf.gz \
--vcfFileIndex=${indir}/chr${chr}.dose.vcf.gz.tbi \
--vcfField=DS \
--chrom=chr${chr} \
--minInfo=0.5 \
--start=${start} \
--end=${end} \
--GMMATmodelFile=${outdir}/${pop}_${ana}_gwas.saige.rda \
--varianceRatioFile=${outdir}/${pop}_${ana}_gwas.saige.varianceRatio.txt \
--SAIGEOutputFile=${outdir}/parts/${pop}_${ana}_gwas.saige.vcf.dosage.chr${chr}.part${SGE_TASK_ID}.txt \
--numLinesOutput=10000 \
--IsOutputAFinCaseCtrl=TRUE \
--IsOutputNinCaseCtrl=TRUE \
--IsOutputHetHomCountsinCaseCtrl=TRUE


source deactivate RSAIGE
