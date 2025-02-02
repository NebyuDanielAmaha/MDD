*Table 6 Sensitivity analysis of factors associated with minimum dietary diversity among children aged 6-23 months in Mekelle 
using complete case analysis (n=474) versus imputed cases (n=584)

*import the raw data
import excel "C:\mdd_raw.xlsx", sheet("mdd") firstrow clear

*sensitivey analysis
*dropping missing values

drop if religion==.
drop if momage==.
drop if marital ==.
drop if dadedu==.
drop if dadjob==.
drop if hhincome==.
drop if delivery==.
drop if internet==.
drop if grains==.
drop if eggs==.


*Recode variables

recode childage (6/11=1 "6-11") (12/17=2 "12-17")  (18/23=3 "18-23"), gen(childage3)
xtile hhincome3 = hhincome,nq(3)
recode momage (17/25=1 "17-25") (26/35=2 "26-35") (36/42=3 "36-42"), gen(momage3)
recode hhnumber (1/3=1 "1-3") (4=2 " 4") (5/8=3 "5-8"), gen(hhnumber3)
recode childorder (1=1 "First") (2=2 "Second") (3/6=3 "Third & Above"), gen(childorder3)
recode religion (1=1 "Orthodox") (2/4=2 "Other"), gen(religion2)
recode marital (1=1 "Married") (2/4=2 "Other"), gen(marital2)
recode momedu (1/3=1 "Below Secondary") (4=2 "Secondary") (5=3 "Above Secondary"), gen(momedu3)
recode dadedu (1/3=1 "Below Secondary") (4=2 "Secondary") (5=3 "Above Secondary"), gen(dadedu3)
recode momjob (1=1 "Homemaker") (2=2 "Government") (3/5=3 "Other"), gen(momjob3)
recode dadjob (2=1 "Government") (4=2 "Merchant") (1 3 5 6=3 "Other"), gen(dadjob3)

*Generate foodsum and MDD score

gen foodsum = breast + grains + legumes + dairy + flesh + eggs + vit_A + other
generate mdd = (foodsum >= 5)

*Multivariable Logistic regression for complete case analysis
logit mdd i.childage3 i.hhnumber3 i.marital2 i.momedu3 i.momjob3 i.dadedu3 i.dadjob3 i.hhincome3 i.internet,or

*Interactions comparison between childage, household income and dad's education
logit mdd i.hhincome3##i.childage3 i.hhnumber3 i.marital2 i.momedu3 i.momjob3 i.dadedu3 i.dadjob3 i.internet i.delivery,or
logit mdd i.hhincome3##i.dadedu3 i.hhnumber3 i.marital2 i.momedu3 i.momjob3 i.childage3 i.dadjob3 i.internet i.delivery,or
logit mdd i.dadedu3##i.childage3 i.hhnumber3 i.marital2 i.momedu3 i.momjob3 i.hhincome3 i.dadjob3 i.internet i.delivery,or
logit mdd i.childage3##i.dadedu3##i.hhincome3 i.hhnumber3 i.marital2 i.momedu3 i.momjob3 i.dadjob3 i.internet i.delivery,or

*Wald's test
logit mdd i.childage3##i.hhincome3##i.dadedu3 i.hhnumber3 i.marital2 i.momedu3 i.momjob3 i.dadjob3 i.internet i.delivery, or
testparm i.childage3##i.dadedu3
testparm i.childage3##i.hhincome3
testparm i.dadedu3##i.hhincome3

