*============================*
* 1. Import data
*============================*
clear
import excel "C:\mdd_raw.xlsx", sheet("mdd") firstrow clear

* Check missing values
misstable summarize


*============================*
* 2. Impute missing values
*============================*

*---- Continuous variables: median imputation ----*
egen med_hhincome = median(hhincome)
replace hhincome = med_hhincome if missing(hhincome)
drop med_hhincome

egen med_momage = median(momage)
replace momage = med_momage if missing(momage)
drop med_momage

egen med_hhnumber = median(hhnumber)
replace hhnumber = med_hhnumber if missing(hhnumber)
drop med_hhnumber

egen med_childorder = median(childorder)
replace childorder = med_childorder if missing(childorder)
drop med_childorder


*---- Categorical variables: mode imputation ----*
egen mode_religion = mode(religion)
replace religion = mode_religion if missing(religion)
drop mode_religion

egen mode_dadedu = mode(dadedu)
replace dadedu = mode_dadedu if missing(dadedu)
drop mode_dadedu

egen mode_dadjob = mode(dadjob)
replace dadjob = mode_dadjob if missing(dadjob)
drop mode_dadjob

egen mode_delivery = mode(delivery)
replace delivery = mode_delivery if missing(delivery)
drop mode_delivery

egen mode_internet = mode(internet)
replace internet = mode_internet if missing(internet)
drop mode_internet


*============================*
* 3. Food group missing → assume not consumed
*============================*
replace grains = 0 if missing(grains)
replace legumes = 0 if missing(legumes)
replace dairy = 0 if missing(dairy)
replace flesh = 0 if missing(flesh)
replace eggs = 0 if missing(eggs)
replace vit_A = 0 if missing(vit_A)
replace other = 0 if missing(other)


*============================*
* 4. Generate MDD
*============================*
gen foodsum = breast + grains + legumes + dairy + flesh + eggs + vit_A + other
gen mdd = foodsum >= 5
label define mddlbl 0 "No" 1 "Yes"
label values mdd mddlbl


*============================*
* 5. Recode explanatory variables
*============================*

* Child age groups
recode childage (6/11=1 "6-11") (12/17=2 "12-17") (18/23=3 "18-23"), gen(childage3)

* Household income tertiles
xtile hhincome3 = hhincome, nq(3)

* Mother age groups
recode momage (17/25=1 "17-25") (26/35=2 "26-35") (36/49=3 "36+"), gen(momage3)

* Household size
recode hhnumber (1/3=1 "1-3") (4=2 "4") (5/12=3 "5+"), gen(hhnumber3)

* Birth order
recode childorder (1=1 "First") (2=2 "Second") (3/12=3 "Third+"), gen(childorder3)

* Religion
recode religion (1=1 "Orthodox") (2/4=2 "Other"), gen(religion2)

* Marital status
recode marital (1=1 "Married") (2/4=2 "Other"), gen(marital2)

* Maternal education
recode momedu (1/3=1 "Below Secondary") (4=2 "Secondary") (5=3 "Above Secondary"), gen(momedu3)

* Paternal education
recode dadedu (1/3=1 "Below Secondary") (4=2 "Secondary") (5=3 "Above Secondary"), gen(dadedu3)

* Maternal occupation
recode momjob (1=1 "Homemaker") (2=2 "Government") (3/5=3 "Other"), gen(momjob3)

* Paternal occupation
recode dadjob (2=1 "Government") (4=2 "Merchant") (1 3 5 6=3 "Other"), gen(dadjob3)



*============================*
* 7. Multicollinearity check
*============================*
regress foodsum i.childage3 i.childsex i.childorder3 i.wassick ///
                i.momage3 i.hhnumber3 i.religion2 i.marital2 ///
                i.momedu3 i.momjob3 i.dadedu3 i.dadjob3 ///
                i.hhincome3 i.internet i.delivery

vif
