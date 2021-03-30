******************
*****Graphs*******
*****************

***have to drop unwanted variables********

****\\\\All sessions///********
clear all       
set more off  

cd "C:\Users\Sakshi Upadhyay\Documents\Sem 9\Experiment_Exogeneous\STATA\Stata_Append\Append_v2"
use exogenous_append.dta


************************************************************************************
****Part 1 and Part 2 will have different analysis, so divide them******
*************************************************************************************



gen Part=.

replace Part =1 if Period<=8
replace Part =2 if Period>=9


**label Part***

 label def Parts 1 "Part 1" 2"Part 2"
 label value Part Parts
**period till 8: 12*3*8=288***
**period from 9: 12*12*3=432************

**label the variables for analysis**

* Lable Type

label def Type 1 "type 1(0.2)" 2 "type 2(0.5)" 3 " type 3(0.8)"
label value type Type


***session type****
label def SessionType 1 "Heteregoneous" 2 "Homogeneous"

label variable sessiontype "Type of Session"
label value sessiontype SessionType
** generate variables**

**MPCR define by periods we ned to define for every subject***
gen mpcr = .


replace mpcr = 0.3 if game==1
replace mpcr = 0.7 if game==2

**label mpcr**

gen MPCR = .


replace MPCR = 1 if game==1
replace MPCR = 2 if game==2

label def benefit 1 "Low MPCR" 2 "High MPCR"
label value MPCR benefit




****contributeg1 also 1 in part2, as it was created by ztree********
 *congame1 was choice participants made in game and contributeg1 was that value, however congame is only for part1 (choice in the experiemnt**
 
gen Contributep1=.
replace Contributep1=contributeg1 if Part==1
label variable Contributep1 "Contribute to Public good(Part 1)" 
label def Contributep1label 1"Contribute to Public good (Part 1)" 0"Not contribute to Public good (Part 1)"
label value Contributep1 Contributep1label

gen Contributecoal=.
replace Contributecoal=contribute if Part==2
label variable Contributecoal "Contribute to Public good (Coalition)" 
label def Contributecoallabel 1"Contribute to Public good (Coalition)" 0"Not contribute to Public good (Coalition)"
label value Contributecoal Contributecoallabel

**contributersg1(part1) become 6 in part 2, should be missing*****
 
 gen Contributerp1=.
 replace Contributerp1=contributersg1 if Part==1
 label  variable Contributerp1 "Number of contributers Part 1"
 
 
 
 *****Part 2 processign******
 **Join =0 for part 1 also***

gen Join=.
replace Join=join if Part==2
label variable Join "Join the Coalition"
label def Joinlabel 1"Join" 0"Not Join"
label  value Join Joinlabel

****vote also 0 when join 0 should be missing**
gen Votes=.
replace Votes=vote if Join==1
label variable Votes "Vote to contribute"
label def Votelabel 1"Vote" 0"Not Vote"
label  value Votes Votelabel

**Coalition Size**
gen CoalitionSize=.
replace CoalitionSize= coalSize if Part==2
label variable CoalitionSize "Coalition Size"
 

**for conFringe also 0 generated when join is 1*****

gen Fringecont=.
replace  Fringecont=conFringe if Join==0
label variable Fringecont  "Contribute to Public Good (Fringe)"
label def Fringecontlabel 1"Fringe contributes" 0"Fringe not contributes"
label  value Fringecont Fringecontlabel


***Majority also becomes 1 when part1  and 0 -1 also, should be -1 only*****

gen Majority=.
replace Majority=majority if Join==1
label variable Majority " Majority contributes" 
label def Majoritylabel 1"Coalition contributes" 0"Coalition does not contribute"
label  value Majority Majoritylabel

 

 
**contributers(coalition variable) become 6 in part 1, should be missing*****
 
 gen Contributercoal=.
 replace Contributercoal=contributers if Part==2
 label  variable Contributercoal "Number of contributers in Coalition"
 
 **Least also takes value in Part 1***
 gen Least=.
 replace Least=least if Part==2
 label  variable Least "Payoff of least well off person"
  

******Common variables***********

***contribute***
gen Contribute=.
replace Contribute=Contributep1 if Part==1
replace Contribute=Contributecoal if Part==2
label variable Contribute "Contribute to Public good "
label def Contributelabel 1"Contribute to Public good" 0"Not contribute to Public good "
label value Contribute Contributelabel

***contributers***
gen Contributers=.
replace Contributers=Contributerp1 if Part==1
replace Contributers=Contributercoal if Part==2
label variable Contributers "Number of contributers"


***payoff ***
 gen Payoffp1=.
 replace Payoffp1=payoff1 if Part==1
 label variable Payoffp1 "Payoff in Part 1"
 
 gen Payoffcoal=.
 replace Payoffcoal=payoff2 if Part==2
 label variable Payoffcoal "Payoff in Coalition"
 
 
 gen Payoff=.
 replace Payoff=Payoffp1 if Part==1
 replace Payoff=Payoffcoal if Part==2
 label variable Payoff "Payoff for subjects"
 
 



****generatign lagged variables****
 ***we  want payoff missing when subjectid is 1 and period also 1, similarly subject id 2, period 1 should be missing****
 ****the command sorts Period wihtin subjectid then sorts sujectid and assigns value, we have to add if Part==1, because period coninues after Part 1 also******
 ****you can not sort Period(subjectid) because Period is not unique*****
 
 
**can not take lag of Payoff as lag of payoff in period 9 should be missing (colaition first round) and not payoff from period 8****


 ***payoff***
bysort subjectid(Period):gen lagPayoffp1=Payoffp1[_n-1] if Part==1
label variable lagPayoffp1 "Lag of Payoff in Part 1"


bysort subjectid(Period):gen lagPayoffcoal=Payoffcoal[_n-1] if Part==2
label variable lagPayoffcoal "Lag of Payoff in Coalition"

gen lagPayoff=.
replace lagPayoff=lagPayoffp1 if Part==1
replace lagPayoff=lagPayoffcoal if Part==2
label variable lagPayoff "Lag of Payoff for subjects"
 


**Contribute***
bysort subjectid(Period):gen lagContributep1=Contributep1[_n-1] if Part==1
label variable lagContributep1 "Lag of Contribute to Public good (Part1)" 
label value lagContributep1 Contributep1label

bysort subjectid(Period):gen lagContributecoal=Contributecoal[_n-1] if Part==2
label variable lagContributecoal "Lag of Contribute to Public good (Coalition)" 
label value lagContributecoal Contributecoallabel

gen lagContribute=.
replace lagContribute=lagContributep1 if Part==1
replace lagContribute=lagContributecoal if Part==2
label variable lagContribute "Lag of Contribute to Public good "
label value lagContribute Contributelabel

**Contributer***
bysort subjectid(Period):gen lagContributerp1=Contributerp1[_n-1] if Part==1
label variable lagContributerp1 "Lag of Number of contributers(Part1)" 


bysort subjectid(Period):gen lagContributercoal=Contributercoal[_n-1] if Part==2
label variable lagContributercoal " Lag of Number of Contributers(Coalition)" 

gen lagContributers=.
replace lagContributers=lagContributerp1 if Part==1
replace lagContributers=lagContributercoal if Part==2
label variable lagContributers " Lag of Number of Contributers "

***least well off person***
bysort subjectid(Period): gen lagLeast=least[_n-1] if Part==2
label  variable lagLeast "Lag of Payoff of least well off person"

***Coalition Size****

bysort subjectid(Period): gen lagCoalitionSize=CoalitionSize[_n-1] if Part==2
label  variable lagCoalitionSize "Lag of Coalition Size"

***Fringecontribute***
bysort subjectid(Period): gen lagFringecont=Fringecont[_n-1] if Part==2
label variable lagFringecont  "Lag of Contribute to Public Good (Fringe)"
label value lagFringecont Fringecontlabel


 
 save "C:\Users\Sakshi Upadhyay\Documents\Sem 9\Experiment_Exogeneous\STATA\Simple Analysis\exog_processed1.dta", replace
 
 
 *******To add controls***********
  use "C:\Users\Sakshi Upadhyay\Documents\Sem 9\Experiment_Exogeneous\STATA\Simple Analysis\exog_processed1.dta"
 
 ****f1: someone who treats you unfairly******
 ***create fair 1, above the mean we call the person fair, mean 5.5, 1-5 unfair and 6-11 fair***
 
 gen fair1=.
 replace fair1=0 if f1<=5
 replace fair1=1 if f1>=6
  
 
 
 




