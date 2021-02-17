
# GWAS of COVID-19 susceptibility and severity

This repository contains scripts to perform GWAS using SAIGE for COVID patients and control individuals from the Mass General Brigham Biobank (formerly Partners Healthcare Biobank). This analysis contributes to the meta-analysis of the COVID-19 Host Genetics Initiative (https://www.covid19hg.org/) to study the genetic determinants of COVID-19 susceptibility and severity.


* `munge_pheno_covar.sh`
	- Format and integrate phenotype and covariate files
	- Summarize Ncase and Ncontrol for each analysis


* `run_saige_step1.sh` & `run_saige_step1-submit.sh`
	- Fit the null model and calculate GRM
	- `run_saige_step1-stratified.sh` same as above, but add in additional strata (male/felame and age below/above 60; this is an updated analysis plan since Sept 2020)


* `run_saige_step2.sh` & `run_saige_step2-submit.sh`
	- Paritition each chromosome into non-overlapping chunks and perform GWAS for all chunks in parallel
	- `run_saige_step2i-stratified.sh` same as above, but add in additional strata (male/felame and age below/above 60)


* `cat_saige_results.sh` & `cat_saige_results-submit.sh`
	- Concatenate all chunks together into one result file
	- Format results according to consortium guidelines
	- Make QQ plot and Manhattan plot for each GWAS (`plot_saige_gwas.R`)


* `upload_results.sh`
	- Upload results to the designated google cloud bucket

