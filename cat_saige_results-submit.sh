
scr=/psych/genetics_data/yfeng/covid_hg/scripts
log=/psych/genetics_data/yfeng/covid_hg/logs/
# wdir=/psych/genetics_data/yfeng/covid_hg/results/20200915/
# date=20200915
wdir=/psych/genetics_data/yfeng/covid_hg/results/20210301
date=20210301
###
pop=eur
ana=b1;iter=6;ncase=112;nctrl=303;strata=all
qsub -o $log/20210301_cat_results_${pop}_${ana}.out $scr/cat_saige_results.sh $wdir $pop $ana $iter $ncase $nctrl $date $strata

ana=b2;iter=6;ncase=112;nctrl=29702;strata=all
qsub -o $log/20210301_cat_results_${pop}_${ana}.out $scr/cat_saige_results.sh $wdir $pop $ana $iter $ncase $nctrl $date $strata

ana=c2;iter=6;ncase=415;nctrl=29702;strata=all
ana=c2;iter=6;ncase=70;nctrl=14179;strata=male
ana=c2;iter=6;ncase=81;nctrl=15787;strata=female
ana=c2;iter=6;ncase=81;nctrl=13042;strata=age.le.60
ana=c2;iter=6;ncase=70;nctrl=16924;strata=age.gt.60
qsub -o $log/20210301_cat_results_${pop}_${ana}.out $scr/cat_saige_results.sh $wdir $pop $ana $iter $ncase $nctrl $date $strata


###
pop=afr
ana=c2;iter=6;ncase=127;nctrl=2378;strata=all
qsub -o $log/20210301_cat_results_${pop}_${ana}.out $scr/cat_saige_results.sh $wdir $pop $ana $iter $ncase $nctrl $date $strata

###
pop=his
ana=c2;iter=6;ncase=123;nctrl=2348;strata=all
qsub -o $log/20210301_cat_results_${pop}_${ana}.out $scr/cat_saige_results.sh $wdir $pop $ana $iter $ncase $nctrl $date $strata

