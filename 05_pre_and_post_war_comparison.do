*Table 7
Table 7 Comparison of pre-war and post-war consumption of food items among children aged 6-23 months in Mekelle 
(p-value given for Fischer’s exact test and Benjamini-Hochberg correction for multiple comparisons)

*Testing assumptions
import excel "C:\EDHS16_19.xlsx", sheet("EDHS16_19") firstrow clear
swilk v012
swilk hw1
tab year nt_mdd
tab year nt_mdd, exact
ttest v012, by(year)
ttest hw1, by(year)
tab year v106
tab year v106, chi2
tab year v106, exact
tab year v501
tab year v501, chi2
tab year v501, exact
tab year b4
tab year b4, exact
tab year nt_mdd,
tab year nt_mdd, exact

*Weighted data anlaysis
svyset [pweight=wt]
svy: mean nt_mdd
svy: mean group1 group2 group3 group4 group5 group6 group7 group8 nt_mdd


# Observed counts for each food group (in percentages converted to actual counts)

* Clear memory
clear all
set more off


* Set number of observations (9 food groups)
set obs 9

* Create necessary variables
gen food_group = ""  
gen pre_counts = .   
gen pre_total = 35   
gen post_counts = .  
gen post_total = 584 
gen p_value = .      
gen rank = .         

* Define food groups and observed proportions
local food_groups "breastfeeding dairy grains vita_A other eggs flesh legumes total"
local pre_vals 95.0 42.6 77.5 46.7 26.5 32.6 20.9 33.8 33.1
local post_vals 89.6 46.6 92.1 26 18.2 22.6 7.2 69.3 25.2

* Loop to populate the dataset
local i = 1
foreach food of local food_groups {
    replace food_group = "`food'" in `i'
    replace pre_counts = round(`=word("`pre_vals'", `i')' * pre_total / 100) in `i'
    replace post_counts = round(`=word("`post_vals'", `i')' * post_total / 100) in `i'
    local i = `i' + 1
}

* Compute Fisher's Exact Test p-values
forvalues i = 1/9 {
    local a = pre_counts[`i']
    local b = pre_total - pre_counts[`i']
    local c = post_counts[`i']
    local d = post_total - post_counts[`i']
    
    * Run Fisher's exact test and store p-value
    quietly tabi `a' `b' \ `c' `d', exact
    replace p_value = r(p_exact) in `i'
}

* Apply Benjamini-Hochberg (BH) Correction
sort p_value  
forvalues i = 1/9 {
    replace rank = `i' in `i'
}
gen adjusted_p_BH = min((p_value * 9) / rank, 1)

* Display final results
list food_group pre_counts post_counts p_value adjusted_p_BH, sepby(food_group)