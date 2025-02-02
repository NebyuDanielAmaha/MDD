import excel "C:\mdd_raw.xlsx", sheet("mdd") firstrow clear

*Checking missing values
misstable summarize

*impute missing values
*Median and Mode imputations for missing values
egen median_hhincome = median(hhincome)
replace hhincome = median_hhincome if missing(hhincome)
drop median_hhincome
summarize hhincome, detail
misstable summarize
egen median_hhincome = median(momage)
replace hhincome = median_hhincome if missing(momage)
drop median_hhincome
misstable summarize
egen median_hhincome = median(momage)
replace momage = median_hhincome if missing(hhincome)
drop median_hhincome
misstable summarize
egen median_hhincome = median(hhincome)
replace hhincome = median_hhincome if missing(hhincome)
drop median_hhincome
egen m_momage = median(momage)
replace momage = m_momage if missing(momage)
drop m_momage
tabulate religion, generate(temp)
summarize temp1
replace religion = `r(max)' if missing(religion)
drop temp*
tabulate dadedu, generate(temp)
summarize temp1
replace dadedu = `r(max)' if missing(dadedu)
drop temp*
tabulate dadjob, generate(temp)
summarize temp1
replace dadjob = `r(max)' if missing(dadjob)
drop temp*
misstable summarize
tabulate delivery, generate(temp)
summarize temp1
replace delivery = `r(max)' if missing(delivery)
drop temp*
tabulate internet, generate(temp)
summarize temp1
replace internet = `r(max)' if missing(internet)
drop temp*

*replacing the missing of food groups assuming not eaten
replace grains=0 if grains==.
replace eggs=0 if eggs==.


*Generate foodsum and MDD score

gen foodsum = breast + grains + legumes + dairy + flesh + eggs + vit_A + other
generate mdd = (foodsum >= 5)


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

*Checking assumptions

*Normality
qnorm childage
qnorm momage
qnorm hhincome
qnorm hhnumber
qnorm childorder

*Linearity of logit
logit mdd i.childage i.momage i.hhnumber i.hhincome i.childorder
linktest

*Multicollineariy
regress mdd i.childage3 i.childsex i.childorder3 i.wassick i.momage3 i.hhnumber3 i.religion2 i.marital2 i.momedu3 i.momjob3 i.dadedu3 i.dadjob3 i.hhincome3 i.internet i.delivery
vif


