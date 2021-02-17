#! /bin/bash

indir=$1
outdir=$2
pop=$3
ana=$4

if [ $pop == "eur" ]; then POP=EU; 
elif [ $pop == "afr" ]; then POP=AFR;
elif [ $pop == "his" ]; then POP=HIS; fi

echo "Input dir: "$indir
echo "Output dir: "$outdir
echo "Population: "$pop
echo "Analysis "$ana
echo "Input file: "${indir}/${pop}_${ana}_gwas_pheno.tsv


source /broad/software/scripts/useuse
reuse -q UGER
reuse Anaconda
export R_LIBS="/home/unix/yfeng/.conda/envs/RSAIGE/lib/R/library"

source activate RSAIGE

# Run saige step 1
saige=/psych/genetics_data/yfeng/software/SAIGE/extdata


# [For Binary traits]
# Step 1: fitting a null mixed model
Rscript ${saige}/step1_fitNULLGLMM.R \
--plinkFile=/humgen/diabetes/users/josep/PartnersBIOBANK/merge_all_35K_datasets/merge_35K_genotypes/${POP}/PHBB_SNPs_35K.${POP}.clean.snps1_MAF_05_forMDS_RELATED_phase3_not_gcat_SNPs \
--phenoFile=${indir}/${pop}_${ana}_gwas_pheno.tsv \
--phenoCol=y \
--covarColList=sex,age,age2,agexsex,pc1,pc2,pc3,pc4,pc5,pc6,pc7,pc8,pc9,pc10 \
--sampleIDColinphenoFile=IID \
--traitType=binary \
--outputPrefix=${outdir}/${pop}_${ana}_gwas.saige \
--outputPrefix_varRatio=${outdir}/${pop}_${ana}_gwas.saige \
--nThreads=4 \
--IsOverwriteVarianceRatioFile=TRUE




source deactivate RSAIGE



## related individuals: plink files for calc. GRM
# /humgen/diabetes/users/josep/PartnersBIOBANK/merge_all_35K_datasets/merge_35K_genotypes/EU/PHBB_SNPs_35K.EU.clean.snps1_MAF_05_forMDS_RELATED_phase3_not_gcat_SNPs.bim/fam/bed
# /humgen/diabetes/users/josep/PartnersBIOBANK/merge_all_35K_datasets/merge_35K_genotypes/HIS/PHBB_SNPs_35K.HIS.clean.snps1_MAF_05_forMDS_RELATED_phase3_not_gcat_SNPs.bim/fam/bed
# /humgen/diabetes/users/josep/PartnersBIOBANK/merge_all_35K_datasets/merge_35K_genotypes/AFR/PHBB_SNPs_35K.AFR.clean.snps1_MAF_05_forMDS_RELATED_phase3_not_gcat_SNPs.bim/fam/bed