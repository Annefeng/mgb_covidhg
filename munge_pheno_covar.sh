## 2020/09/01
wdir=/psych/genetics_data/yfeng/covid_hg/pheno/20200915
gdir=/humgen/diabetes2/users/josep/PartnersBIOBANK/merge_all_35K_datasets/merge_35K_genotypes/
misc=/psych/genetics_data/yfeng/covid_hg/misc_data
f_demog=$misc/BiobankPortal_yf084_GenotypeDemographics_2020-03-23.tsv

f_dintu=covid-positive-inpts-death-or-intubation.txt
f_inpts=covid-positive-inpts.txt
f_covid=covid-positive.txt
f_negat=covid-negative.txt
f_pctrl=controls.txt

cd $wdir

# Reformat and check input data (any overlap btw definitions)
# (note the input files Emma shared do not separate by genetic ancestry)
awk 'NR>1{print $2}' $f_dintu | sort > dintu_id.tsv
awk 'NR>1{print $2}' $f_inpts | sort > inpts_id.tsv
awk 'NR>1{print $3}' $f_covid | sort > covid_id.tsv
awk 'NR>1{print $2}' $f_negat | sort > negat_id.tsv
awk 'NR>1{print $2}' $f_pctrl | sort > pctrl_id.tsv

join covid_id.tsv negat_id.tsv | wc -l #0
join inpts_id.tsv negat_id.tsv | wc -l #0
join nonip_id.tsv negat_id.tsv | wc -l #0
join covid_id.tsv inpts_id.tsv | wc -l #68

join -v1 covid_id.tsv inpts_id.tsv | wc -l #228
join -v1 covid_id.tsv inpts_id.tsv > nonip_id.tsv
join inpts_id.tsv nonip_id.tsv | wc -l #0 

wc -l dintu_id.tsv #21
wc -l inpts_id.tsv #68
wc -l nonip_id.tsv #228
wc -l covid_id.tsv #296
wc -l negat_id.tsv #3884

join dintu_id.tsv inpts_id.tsv | wc -l #19 (2 not in inpts)
join dintu_id.tsv covid_id.tsv | wc -l #20 (1 not in overall covid)
join -v1 dintu_id.tsv inpts_id.tsv
# 10030254
# 10056463
join -v1 dintu_id.tsv covid_id.tsv
# 10030254
# --> excl. these two pts from death/intubation list
join -v1 dintu_id.tsv inpts_id.tsv | join -v1 dintu_id.tsv - > tmp && mv tmp dintu_id.tsv
wc -l dintu_id.tsv #19

join covid_id.tsv pctrl_id.tsv | wc -l #0
join negat_id.tsv pctrl_id.tsv | wc -l #3884




# Create phenotype/covariate files for saige input; summarize sample size for each analysis
for pop in eur afr his; do
    echo ""
    echo "[ Population: "$pop" ]"
    if [ $pop == "eur" ]; then POP=EU; 
    elif [ $pop == "afr" ]; then POP=AFR;
    elif [ $pop == "his" ]; then POP=HIS; fi
    
    echo "1. Intersect case pheno with geno"
    # inpatients- death or intubation
    sed 's/[^\-]*-//' $misc/pbk_${pop}_rel_qc_no-overlap_samples.tsv | sort | join - dintu_id.tsv > ${pop}_dintu_id.tsv
    # inpatients
    sed 's/[^\-]*-//' $misc/pbk_${pop}_rel_qc_no-overlap_samples.tsv | sort | join - inpts_id.tsv > ${pop}_inpts_id.tsv
    # total covid-non-inpt cases
    sed 's/[^\-]*-//' $misc/pbk_${pop}_rel_qc_no-overlap_samples.tsv | sort | join - nonip_id.tsv > ${pop}_nonip_id.tsv
    # total covid cases
    sed 's/[^\-]*-//' $misc/pbk_${pop}_rel_qc_no-overlap_samples.tsv | sort | join - covid_id.tsv > ${pop}_covid_id.tsv
    # tested negative
    sed 's/[^\-]*-//' $misc/pbk_${pop}_rel_qc_no-overlap_samples.tsv | sort | join - negat_id.tsv > ${pop}_negat_id.tsv
    # all population controls
    sed 's/[^\-]*-//' $misc/pbk_${pop}_rel_qc_no-overlap_samples.tsv | sort | join -v1 - covid_id.tsv > ${pop}_non-covid_id.tsv

    # echo "N covid-inpts-death-or-intub: "$(cat ${pop}_dintu_id.tsv | wc -l)
    # echo "N covid-inpts: "$(cat ${pop}_inpts_id.tsv | wc -l)
    # echo "N covid-nonip: "$(cat ${pop}_nonip_id.tsv | wc -l)
    # echo "N covid-total: "$(cat ${pop}_covid_id.tsv | wc -l)
    # echo "N tested negat: "$(cat ${pop}_negat_id.tsv | wc -l)
    # echo "N pop controls: "$(cat ${pop}_non-covid_id.tsv | wc -l)

    echo "2. Find the remaining non-case as controls"
    echo "* A1: inpts-death-or-intub. vs. non-inpts covid patients"
    awk '{print $1,$2=1}' ${pop}_dintu_id.tsv > case.tmp
    awk '{print $1,$2=0}' ${pop}_nonip_id.tsv > ctrl.tmp
    echo "- N cases: "$(cat case.tmp | wc -l)
    echo "- N ctrls: "$(cat ctrl.tmp | wc -l)
    cat case.tmp ctrl.tmp > ${pop}_a1_gwas_pheno.tsv

    echo "* A2: inpts-death-or-intub. vs. pop controls"
    awk '{print $1,$2=1}' ${pop}_dintu_id.tsv > case.tmp
    awk '{print $1,$2=0}' ${pop}_non-covid_id.tsv > ctrl.tmp
    echo "- N cases: "$(cat case.tmp | wc -l)
    echo "- N ctrls: "$(cat ctrl.tmp | wc -l)
    cat case.tmp ctrl.tmp > ${pop}_a2_gwas_pheno.tsv

    echo "* B1: inpts vs. non-inpts covid patients"
    awk '{print $1,$2=1}' ${pop}_inpts_id.tsv > case.tmp
    awk '{print $1,$2=0}' ${pop}_nonip_id.tsv > ctrl.tmp
    echo "- N cases: "$(cat case.tmp | wc -l)
    echo "- N ctrls: "$(cat ctrl.tmp | wc -l)
    cat case.tmp ctrl.tmp > ${pop}_b1_gwas_pheno.tsv

    echo "* B2: inpts vs. pop controls"
    awk '{print $1,$2=1}' ${pop}_inpts_id.tsv > case.tmp
    awk '{print $1,$2=0}' ${pop}_non-covid_id.tsv > ctrl.tmp
    echo "- N cases: "$(cat case.tmp | wc -l)
    echo "- N ctrls: "$(cat ctrl.tmp | wc -l)
    cat case.tmp ctrl.tmp > ${pop}_b2_gwas_pheno.tsv

    echo "* C1: covid vs. covid-negative"
    awk '{print $1,$2=1}' ${pop}_covid_id.tsv > case.tmp
    awk '{print $1,$2=0}' ${pop}_negat_id.tsv > ctrl.tmp
    echo "- N cases: "$(cat case.tmp | wc -l)
    echo "- N ctrls: "$(cat ctrl.tmp | wc -l)
    cat case.tmp ctrl.tmp > ${pop}_c1_gwas_pheno.tsv

    echo "* C2: covid vs. pop controls"
    awk '{print $1,$2=1}' ${pop}_covid_id.tsv > case.tmp
    awk '{print $1,$2=0}' ${pop}_non-covid_id.tsv > ctrl.tmp
    echo "- N cases: "$(cat case.tmp | wc -l)
    echo "- N ctrls: "$(cat ctrl.tmp | wc -l)
    cat case.tmp ctrl.tmp > ${pop}_c2_gwas_pheno.tsv

    rm *tmp

    echo "3. Combine with covariates"
    # From hg analysis plan:
    # Phenotype ~ variant + age + age2 + sex + age*sex + PCs + study_specific_covariates
    for f in ${pop}_*_gwas_pheno.tsv; do
        # - demographnic info
        join <(sort -k1 $f) <(sort -k1 $f_demog) > tmp && mv tmp $f
        # - PCs
        awk '{print $2}' $gdir/${POP}/PHBB_SNPs_35K_20_PCs_${POP}_RELATED.txt | sed 's/[^\-]*-//' | paste - $gdir/${POP}/PHBB_SNPs_35K_20_PCs_${POP}_RELATED.txt | sort -k1 | join <(sort -k1 $f) - | awk '{print $8,$9,$2,$3,$4,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29}' | sed 's/\<F\>/1/g' | sed 's/\<M\>/0/g' | awk '{print $1,$2,$3,$4,$5,$5^2,$4*$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25}' | sed '1i FID IID y sex age age2 agexsex pc1 pc2 pc3 pc4 pc5 pc6 pc7 pc8 pc9 pc10 pc11 pc12 pc13 pc14 pc15 pc16 pc17 pc18 pc19 pc20' > tmp && mv tmp $f
    done

done



# ##########
# [ Population: eur ]
# 1. Intersect case pheno with geno
# 2. Find the remaining non-case as controls
# * A1: inpts-death-or-intub. vs. non-inpts covid patients
# - N cases: 12
# - N ctrls: 114
# * A2: inpts-death-or-intub. vs. pop controls
# - N cases: 12
# - N ctrls: 29971
# * B1: inpts vs. non-inpts covid patients
# - N cases: 37
# - N ctrls: 114
# * B2: inpts vs. pop controls
# - N cases: 37
# - N ctrls: 29971
# * C1: covid vs. covid-negative
# - N cases: 151
# - N ctrls: 3118
# * C2: covid vs. pop controls
# - N cases: 151
# - N ctrls: 29971

# [ Population: afr ]
# 1. Intersect case pheno with geno
# 2. Find the remaining non-case as controls
# * A1: inpts-death-or-intub. vs. non-inpts covid patients
# - N cases: 4
# - N ctrls: 45
# * A2: inpts-death-or-intub. vs. pop controls
# - N cases: 4
# - N ctrls: 2445
# * B1: inpts vs. non-inpts covid patients
# - N cases: 15
# - N ctrls: 45
# * B2: inpts vs. pop controls
# - N cases: 15
# - N ctrls: 2445
# * C1: covid vs. covid-negative
# - N cases: 60
# - N ctrls: 375
# * C2: covid vs. pop controls
# - N cases: 60
# - N ctrls: 2445

# [ Population: his ]
# 1. Intersect case pheno with geno
# 2. Find the remaining non-case as controls
# * A1: inpts-death-or-intub. vs. non-inpts covid patients
# - N cases: 3
# - N ctrls: 56
# * A2: inpts-death-or-intub. vs. pop controls
# - N cases: 3
# - N ctrls: 2405
# * B1: inpts vs. non-inpts covid patients
# - N cases: 10
# - N ctrls: 56
# * B2: inpts vs. pop controls
# - N cases: 10
# - N ctrls: 2405
# * C1: covid vs. covid-negative
# - N cases: 66
# - N ctrls: 276
# * C2: covid vs. pop controls
# - N cases: 66
# - N ctrls: 2405



#######
# For EUR C1 and C2 (where N is sufficient), separate into male/female and age>=60/<60
# [C1]
awk 'NR==1' eur_c1_gwas_pheno.tsv > eur_c1_gwas_pheno-male.tsv
awk '$4==0' eur_c1_gwas_pheno.tsv >> eur_c1_gwas_pheno-male.tsv

awk 'NR==1' eur_c1_gwas_pheno.tsv > eur_c1_gwas_pheno-female.tsv
awk '$4==1' eur_c1_gwas_pheno.tsv >> eur_c1_gwas_pheno-female.tsv


awk 'NR==1' eur_c1_gwas_pheno.tsv > eur_c1_gwas_pheno-age.le.60.tsv
awk '$5<=60' eur_c1_gwas_pheno.tsv >> eur_c1_gwas_pheno-age.le.60.tsv

# awk 'NR==1' eur_c1_gwas_pheno.tsv > eur_c1_gwas_pheno-age.gt.60.tsv
awk '$5>60' eur_c1_gwas_pheno.tsv > eur_c1_gwas_pheno-age.gt.60.tsv

###
# [C2]
awk 'NR==1' eur_c2_gwas_pheno.tsv > eur_c2_gwas_pheno-male.tsv
awk '$4==0' eur_c2_gwas_pheno.tsv >> eur_c2_gwas_pheno-male.tsv

awk 'NR==1' eur_c2_gwas_pheno.tsv > eur_c2_gwas_pheno-female.tsv
awk '$4==1' eur_c2_gwas_pheno.tsv >> eur_c2_gwas_pheno-female.tsv


awk 'NR==1' eur_c2_gwas_pheno.tsv > eur_c2_gwas_pheno-age.le.60.tsv
awk '$5<=60' eur_c2_gwas_pheno.tsv >> eur_c2_gwas_pheno-age.le.60.tsv

# awk 'NR==1' eur_c2_gwas_pheno.tsv > eur_c2_gwas_pheno-age.gt.60.tsv
awk '$5>60' eur_c2_gwas_pheno.tsv > eur_c2_gwas_pheno-age.gt.60.tsv


