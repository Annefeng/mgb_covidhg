
scr=/psych/genetics_data/yfeng/covid_hg/scripts
log=/psych/genetics_data/yfeng/covid_hg/logs/
wdir=/psych/genetics_data/yfeng/covid_hg/results/20200915/
date=20200915
###
pop=eur
ana=c1;iter=4;ncase=151;nctrl=3118;strata=all
ana=c1;iter=4;ncase=70;nctrl=1371;strata=male
ana=c1;iter=4;ncase=81;nctrl=1747;strata=female
ana=c1;iter=4;ncase=81;nctrl=1331;strata=age.le.60
ana=c1;iter=4;ncase=70;nctrl=1787;strata=age.gt.60
qsub -o $log/cat_results_$pop_$ana.out $scr/cat_saige_results.sh $wdir $pop $ana $iter $ncase $nctrl $date $strata


ana=c2;iter=4;ncase=151;nctrl=29966;strata=all
ana=c2;iter=4;ncase=70;nctrl=14179;strata=male
ana=c2;iter=4;ncase=81;nctrl=15787;strata=female
ana=c2;iter=4;ncase=81;nctrl=13042;strata=age.le.60
ana=c2;iter=4;ncase=70;nctrl=16924;strata=age.gt.60
qsub -o $log/cat_results_$pop_$ana.out $scr/cat_saige_results.sh $wdir $pop $ana $iter $ncase $nctrl $date $strata


###
pop=afr
ana=c1;iter=4;ncase=60;nctrl=375
ana=c2;iter=4;ncase=60;nctrl=2445
qsub -o $log/cat_results_$pop_$ana.out $scr/cat_saige_results.sh $wdir $pop $ana $iter $ncase $nctrl $date

###
pop=his
ana=c1;iter=4;ncase=66;nctrl=276
ana=c2;iter=4;ncase=66;nctrl=2405
qsub -o $log/cat_results_$pop_$ana.out $scr/cat_saige_results.sh $wdir $pop $ana $iter $ncase $nctrl $date

