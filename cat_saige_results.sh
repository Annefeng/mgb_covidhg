#! /bin/bash
#$ -j y
#$ -l h_vmem=10g
#$ -l h_rt=10:00:00

wdir=$1
pop=$2
ana=$3
iter=$4
ncase=$5
nctrl=$6
date=$7
strata=$8 #20200916 added


source /broad/software/scripts/useuse
reuse -q R-3.3
reuse .htslib-1.8 #for using bgzip
export R_LIBS="~/R/x86_64-pc-linux-gnu-library/3.3"


ANA=$(echo $ana"_V2" | tr '[a-z]' '[A-Z]')

if [ $pop == "eur" ]; then POP=EUR; 
elif [ $pop == "afr" ]; then POP=AFR;
elif [ $pop == "his" ]; then POP=HIS; fi

if [ $strata == "all" ]; then STRATA=ALL;
elif [ $strata == "male" ]; then STRATA=M; 
elif [ $strata == "female" ]; then STRATA=F; 
elif [ $strata == "age.le.60" ]; then STRATA=LE_60;
elif [ $strata == "age.gt.60" ]; then STRATA=GT_60; fi

pfx=${pop}_${ana}_gwas.saige.vcf.dosage
if [ $strata != "all" ]; then pfx=${pop}_${ana}_gwas.saige-${strata}.vcf.dosage; fi


cd $wdir

echo "Combine all partitions per analysis/pop"
awk 'NR==1' $wdir/parts/${pfx}.chr22.part1.txt > ${pfx}.txt
awk FNR-1 $wdir/parts/${pfx}.*.txt >> ${pfx}.txt


echo "Select output columns and rename file for submission"
awk '{print $1,$2,$4,$5,$6,$7,$8,$10,$11,$12,$13,$16,$18,$19,$20,$21,$22,$23,$24,$25}' ${pfx}.txt | bgzip > PHBB.Feng.${ANA}.${iter}.${STRATA}.${POP}.${ncase}.${nctrl}.SAIGE.${date}.txt.gz



###
echo "Save a subset of the results for plotting (MAF>0.01 and INFO > 0.8)"
awk '$7>0.01 && $8>0.8{print $1,$2,$3,$10,$11,$13}' ${pfx}.txt > ${pfx}.aaf0.01.info0.8.txt

echo "Make QQ and manhattan plot (submit Rscript)"
Rscript /psych/genetics_data/yfeng/covid_hg/scripts/plot_saige_gwas.R ${wdir} ${pop} ${ana} ${ncase} ${nctrl} ${strata}
###

rm ${pfx}.txt


