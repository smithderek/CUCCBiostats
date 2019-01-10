*H*******************************************************************;
*H         Program Name: s:\Pan\&projectn\programs\Completers -- LMM analysis of BLM06M18M18 data -- No data imputation.sas
*H         Investigator: Catenacci, Vicki <Vicki.Catenacci@ucdenver.edu>
*H              Project: R01 NIDDK 5R01DK097266-02
*H                       Optimal Timing of Exercise Initiation Within a Lifestyle Weight Loss Program
*H                        
*H              Purpose: RCT to examine effect of timing of exercise on weight loss 
*H        Datasets Used: Final data sets for this five year project
*H     Datasets Created:
*H Output Files Created:
*H               Author: Zhaoxing Pan
*H             Comments: 
*H         Date Written: 02-13-2018
*H*******************************************************************;


proc template;
Define Style RTF_pan;
Parent=Styles.rtf;
  style body from document /
             leftmargin=1in
             rightmargin=1in
             topmargin=0.5in
             bottommargin=0.5in;
  Parent=Styles.rtf;
  Replace fonts /
    'TitleFont2'       =("Arial",10pt,Bold)
	'TitleFont'        =("Arial",10pt,Bold)
	'StrongFont'       =("Arial",10pt,Bold)
	'EmphasisFont'     =("Arial",10pt)
	'FixedEmphasisFont'=("Courier",9pt)
	'FixedStrongFont'  =("Courier",9pt,Bold) 
	'FixedHeadingFont' =("Courier",9pt,Bold)
	'BatchFixedFont'   =("Courier",7pt) /* for data _null_ step*/
	'FixedFont'        =("Courier",9pt)
	'headingEmphasisFont'=("Arial",10pt,Bold)
	'headingFont'        =("Arial",7pt,Bold)/* for table headings by proc print */
	'docFont'            =("Arial",6pt);    /* for table contents by proc print */
  End;
Run;

Libname library "&rootpath\&projectn\Data\&yrmo\&dsdate";
filename newlog "&rootpath\&projectn\Data\&yrmo\&dsdate\Completers -- LMM analysis of BLM06M18M18 data -- No data imputation.log";
filename newlst "&rootpath\&projectn\Data\&yrmo\&dsdate\Completers -- LMM analysis of BLM06M18M18 data -- No data imputation.lst";


options font=(sasfont 6) 
        orientation=portrait
        noFmtErr
        missing=' '
        formdlim='='
		nodate
        pageno=1 ps=59 ls=256 noquotelenmax spool;

Title1 "&rootpath\&projectn\Programs\Completers -- LMM analysis of BLM06M18M18 data -- No data imputation.sas";

proc printto print=newlst log=newlog new;
run;

%macro removeOldFile(bye); 
%if %sysfunc(exist(&bye.)) %then %do; 
proc delete data=&bye.; 
run; %end; 

%mend removeOldFile;


%macro lblfmt(inds=, fmtname=);

proc contents data=&inds out=contents(keep=name label) noprint;
run;

data _null_;
 set contents (where=( label ne ' ')) end=lastobs;
 file "&rootpath\&projectn\Data\&yrmo\&dsdate\lblformat.sas";
 name=upcase(name);
 left="'"||trim(left(name))||"'";
 right="'"||trim(left(label))||"'";
 if _n_ = 1 then do;
  put "Proc format library=library;";
  put "value $&fmtname";
                 end;
  put left "=" right;
  if lastobs then do;
    put "; run;";
	              end;
run;

%include  "&rootpath\&projectn\Data\&yrmo\&dsdate\lblformat.sas";
%mend;


Data temp;
 set library.serialdata;
 array varlist
 visit_weight
bmi
wc_1
wc_2
wc_average

 L_ARM_BMC_g
L_ARM_FAT_g
L_ARM_LEAN_mass_g
L_ARM_LEAN_plus_BMC_g
L_ARM_MASS_g
L_ARM_PctFAT
L_ARM_PctLEAN
R_ARM_BMC_g
R_ARM_FAT_g
R_ARM_LEAN_mass_g
R_ARM_LEAN_plus_BMC_g
R_ARM_MASS_g
R_ARM_PctFAT
R_ARM_PctLEAN
TRUNK_BMC_g
TRUNK_FAT_g
TRUNK_LEAN_mass_g
TRUNK_LEAN_plus_BMC_g
TRUNK_MASS_g
TRUNK_PctFAT
TRUNK_PctLEAN
L_LEG_BMC_g
L_LEG_FAT_g
L_LEG_LEAN_mass_g
L_LEG_LEAN_plus_BMC_g
L_LEG_MASS_g
L_LEG_PctFAT
L_LEG_PctLEAN
R_LEG_BMC_g
R_LEG_FAT_g
R_LEG_LEAN_mass_g
R_LEG_LEAN_plus_BMC_g
R_LEG_MASS_g
R_LEG_PctFAT
R_LEG_PctLEAN
SUBTOT_BMC_g
SUBTOT_FAT_g
SUBTOT_LEAN_mass_g
SUBTOT_LEAN_plus_BMC_g
SUBTOT_MASS
SUBTOT_PctFAT
SUBTOT_PctLEAN
HEAD_BMC_g
HEAD_FAT_g
HEAD_LEAN_mass_g
HEAD_LEAN_plus_BMC_g
HEAD_MASS_g
HEAD_PctFAT
HEAD_PctLEAN
WBTOT_BMC_g
WBTOT_FAT_g
WBTOT_LEAN_mass_g
WBTOT_LEAN_plus_BMC_g
WBTOT_MASS_g
WBTOT_PctFAT
WBTOT_PctLEAN;

  if record_id in (14 16 35 117) then do;
     do i=1 to dim(varlist);

      if month=18 then do;
        varlist(i)=.;
	    	             end;
    end;
                                     end;
  drop i;
 if month in ( 0 6 12 18) and completer=1; /* Only completers are included */
run;


%lblfmt(inds=Temp, fmtname=currentfmt);

ods rtf
file="&rootpath\&projectn\Data\&yrmo\&dsdate\Completers -- LMM analysis of BLM06M18M18 data -- No data imputation.rtf"
style=rtf_pan startpage=no gtitle;
ods escapechar="~";


data _null_;
 file print;
 put "This file is";
 put "&rootpath\&projectn\Data\&yrmo\&dsdate\Completers -- LMM analysis of BLM06M18M18 data -- No data imputation.rtf";
run;

Data _null_;
  file print;
  put "Program run on " "%sysfunc(date(),mmddyy10.)" " at " "%sysfunc(time(), hhmm5.)";
run;

ods text="~S={fontsize=2 color=black}In this program, between-Intervention difference in the change of outcome variable over baseline, month 6, month 12 and 18 are examined.
 Linear Mixed Effects model with Unstructured covariance was used. A saturated model was fit to the data of all four time points.  Contrasts of 
 interest were then used to conduct statistical tests under this model.  No adjustment for multiple comparisons were applied.";

 ods text=" ";
ods text="~S={fontsize=2 color=red}Details of analysis for each outcome variable are presented on consecutive 8 pages from page 2.";
 ods text="~S={fontsize=2 color=red}A table summarizing all the analysis is available in 'Completers -- LMM analysis of BLM06M18M18 data -- No data imputation.xls'";

 
 %macro mixedModel4TimePoints (inds= , outcome=, lsmeansout= , estimateout=, contrastout= );

 ods rtf startpage=now;

%removeOldFile(&lsmeansout);
%removeOldFile(&estimateout);
%removeOldFile(&contrastout);
%removeOldFile(final);
%removeOldFile(finalout);
%removeOldFile(change_Standard);
%removeOldFile(change_nonStandard);
%removeOldFile(BetweenInterventiondiff);


Data _null_;
 length outcome $32.;
 outcome="&outcome";
 outcomelabel=put(upcase(outcome), $thisfmt.);
 call symput("outcomelabel" , trim(left(outcomelabel)));
 put outcomelabel;
 run;

title "Analysis of %trim(&outcome) -- %trim(&outcomelabel)";
ods rtf startpage=now;

ods text="~S={fontsize=2 color=black}Raw data and summary statistics";

proc sort data=&inds;
by Record_id month Intervention;
run;


goption reset=all device=emf hsize=4 in vsize=3 in htext=4 hpos=100 
vpos=100;
axis1  minor=none offset=(0.5 cm , 0.5 cm) order=0, 6, 12,  18;
axis2 minor=none label=(a=90)  offset=( 0 cm, 0.5 cm);
legend1 shape=symbol( 3, 3) ;

Proc gplot data=&inds ;
where intervention='Sequential';
plot &outcome*Month=record_ID/haxis=axis1 vaxis=axis2 nolegend ;
symbol i=j v=circle c=black r=100 l=2 w=4 h=4;
title1 h=4 "Spaghetti plot of %trim(&Outcomelabel)";
title2 color=blue h=4 "Sequential group";
run;

Proc gplot data=&inds ;
where intervention='Standard';
plot &outcome*Month=record_ID/haxis=axis1 vaxis=axis2 nolegend ;
symbol i=j v=circle c=black r=100 l=2 w=4 h=4;
title1 h=4 "Spaghetti plot of %trim(&Outcomelabel)";
title2 color=blue h=4 "Standard group";
run;


proc sort data=&inds;
by intervention month;
run;

proc univariate data=&inds noprint;
by intervention month;
var &outcome;
output out=summarystats&i n=n mean=mean std=std stderr=stderr min=min max=max median=median;
run;

data summarystats&i;
 set summarystats&i;
 length outcome $32.;
 outcome="&outcome";
 run;

proc print data=summarystats&i;
 var outcome intervention month n mean std stderr min median max;
 format mean std stderr min median max 8.2;
run;

Proc gplot data=summarystats&i;
plot mean*Month=intervention/haxis=axis1 vaxis=axis2 legend=legend1;
symbol1 i=j l=1 v=circle  c=red r=1 w=4 h=4;
symbol21 i=j l=2 v=triangle c=blue r=1 w=4 h=4 ;
title "Mean response curves";
run;

Proc gplot data=summarystats&i;
plot median*Month=intervention/haxis=axis1 vaxis=axis2 legend=legend1;
symbol1 i=j l=1 v=circle  c=red r=1 w=4 h=4;
symbol21 i=j l=2 v=triangle c=blue r=1 w=4 h=4 ;
title "Median response curves";
run;

title "Analysis of %trim(&outcome) -- %trim(&outcomelabel)";
ods rtf startpage=now;
ods text="~S={fontsize=2 color=black}Mixed model analysis";


proc sort data=&inds;
by Record_id month Intervention;
run;

Proc mixed data=&inds;
class Record_id Month Intervention;
model &outcome = Intervention Month Intervention*Month/solution;
repeated Month/type=un subject=Record_id rcorr r;
lsmeans Intervention*Month;
/* Cell means */
                                                                                 /* N S N S N S N S */
Estimate 'Sequential, baseline'  intercept 1     Intervention 1 0  Month 1 0 0 0 Intervention*Month 1 0 0 0 0 0 0 0;
Estimate 'Sequential, M06'       intercept 1     Intervention 1 0  Month 0 1 0 0 Intervention*Month 0 0 1 0 0 0 0 0;
Estimate 'Sequential, M12'       intercept 1     Intervention 1 0  Month 0 0 1 0 Intervention*Month 0 0 0 0 1 0 0 0;
Estimate 'Sequential, M18'       intercept 1     Intervention 1 0  Month 0 0 0 1 Intervention*Month 0 0 0 0 0 0 1 0;
                                                                              /* N S N S N S N S */
Estimate 'Standard, baseline'  intercept 1     Intervention 0 1  Month 1 0 0 0  Intervention*Month 0 1 0 0 0 0 0 0;
Estimate 'Standard, M06'       intercept 1     Intervention 0 1  Month 0 1 0 0  Intervention*Month 0 0 0 1 0 0 0 0;
Estimate 'Standard, M12'       intercept 1     Intervention 0 1  Month 0 0 1 0  Intervention*Month 0 0 0 0 0 1 0 0;
Estimate 'Standard, M18'       intercept 1     Intervention 0 1  Month 0 0 0 1  Intervention*Month 0 0 0 0 0 0 0 1;

/* Between-Intervention difference at a given time point */
                                                                     /* N S  N  S   N  S N  S */
Estimate '(Standard - Sequential) at baseline'   Intervention -1 1        Intervention*Month -1 1  0  0  0  0 0  0;
Estimate '(Standard - Sequential) at M06'        Intervention -1 1        Intervention*Month 0  0 -1  1  0  0 0  0;
Estimate '(Standard - Sequential) at M12'        Intervention -1 1        Intervention*Month 0  0  0  0 -1  1 0  0;
Estimate '(Standard - Sequential) at M18'        Intervention -1 1        Intervention*Month 0  0  0  0  0  0 -1 1;

/* Within Intervention difference between two different time points */
                                                                           /* N  S  N  S   N  S  N  S */
Estimate 'BL - M06, Sequential'       Month 1  -1  0  0   Intervention*Month  1 0  -1  0    0  0   0  0;
Estimate 'BL - M12, Sequential'       Month 1   0  -1  0   Intervention*Month  1 0   0  0   -1  0   0  0;
Estimate 'BL - M18, Sequential'       Month 1   0  0  -1   Intervention*Month  1 0   0  0    0  0  -1  0;
Estimate 'M06 - M12, Sequential'      Month  0  1  -1  0   Intervention*Month  0 0   1  0   -1  0   0  0;
Estimate 'M06 - M18, Sequential'      Month  0  1  0  -1   Intervention*Month  0 0   1  0    0  0  -1  0;
Estimate 'M12 - M18, Sequential'      Month  0  0  1  -1   Intervention*Month  0 0   0  0    1  0  -1  0;

                                                                        /* N  S  N  S   N  S  N  S */
Estimate 'BL - M06, Standard'       Month 1  -1  0  0   Intervention*Month 0  1  0  -1  0   0    0   0  ;
Estimate 'BL - M12, Standard'       Month 1  0  -1  0   Intervention*Month 0  1  0   0  0   -1   0   0  ;
Estimate 'BL - M18, Standard'       Month 1  0  0  -1   Intervention*Month 0  1  0   0  0    0   0  -1  ;
Estimate 'M06 - M12, Standard'      Month  0 1  -1  0   Intervention*Month 0  0  0   1  0   -1   0   0  ;
Estimate 'M06 - M18, Standard'      Month  0 1  0  -1   Intervention*Month 0  0  0   1  0    0   0  -1  ;
Estimate 'M12 - M18, Standard'      Month  0  0 1  -1   Intervention*Month 0  0  0   0  0    1   0  -1  ;

/* Interaction */
                                                             /* N  S  N  S   N  S  N  S */
Estimate '(Standard - Sequential) in (BL - M06)'         Intervention*Month -1  1  1  -1  0   0  0  0;
Estimate '(Standard - Sequential) in (BL - M12)'         Intervention*Month -1  1  0   0  1  -1  0  0;
Estimate '(Standard - Sequential) in (BL - M18)'         Intervention*Month -1  1  0   0  0   0  1  -1;
Estimate '(Standard - Sequential) in (M06 - M12)'        Intervention*Month  0  0  -1  1  1  -1  0  0 ;
Estimate '(Standard - Sequential) in (M06 - M18)'        Intervention*Month  0  0  -1  1  0   0  1  -1;
Estimate '(Standard - Sequential) in (M12 - M18)'        Intervention*Month  0  0  0   0  -1  1  1  -1;

Contrast 'Overall interaction' Intervention*Month 1 -1 -1  1  0  0  0  0,
                               Intervention*Month 1 -1  0  0 -1  1  0  0,
                               Intervention*Month 1 -1  0  0  0  0 -1  1;
ods output estimates=&estimateout contrasts=&contrastout lsmeans=&lsmeansout;
run;

data &contrastout;
 set &contrastout;
length outcome $32. ;
 outcome="&outcome";
 alpha=0.05;
 noncen=numdf*fvalue;
 Fcrit=finv(1-alpha, numdf, dendf, 0);
 power=1 - probf(fcrit, numdf, dendf, noncen);
 label power='Post Hoc power';
 format power percent7.1;
 run;


ods rtf startpage=now;
ods text="~S={fontsize=2 color=green} Summary of analysis results for %trim(&outcomelabel)";
goption reset=all device=emf hpos=100 vpos=100 hsize=3 in vsize=1.5 in htext=5;
axis1 label=(a=90 'LS means') minor=none offset=(0.5 cm, 0);
axis2  offset=(0.5 cm, 0.5 cm) minor=none;

proc gplot data=&lsmeansout;
plot estimate*month = Intervention /vaxis=axis1 haxis=axis2;
symbol1 i=j line=1 v=dot color=black w=5 h=5;
symbol2 i=j line=2 v=circle color=red w=5 h=5;
format estimate 8.0;
title h=5 "Model estimate of mean response patterns"; 
run;
quit;

ods text="~S={fontsize=2 color=green}Overall interaction test";

proc print data=&contrastout noobs;
var outcome label numdf dendf fvalue probf /*power*/;
run;

ods text="~S={fontsize=2 color=green}Test of time by Intervention interaction 
 (i.e. between-Intervention difference in amount of change between time points) is used to estimate the efficacy of intervention..";
ods text=" ";
 ods text="~S={fontsize=2 color=green}The above table shows the testing result for the overall time by
 Intervention interaction. One usually stops the analysis if the overall time by Intervention interaction is not significant
 since it suggests that two response curves are paralelled. That is, no difference in amount of change between two Interventions..";



data &estimateout;
 set &estimateout;
 length stats $25.;
 Stats=trim(left(put(estimate, 8.2)))||" ("||trim(left(put(stderr, 8.2)))||")";
 length outcome $32. typeofestimate $40;
 outcome="&outcome";

if _n_ <=8 then do;
 listorder=1;
 typeofestimate='LS means';
 DF=.;
 tvalue=.;
 probt=.;
               end;

if 9<= _n_<=12 then do;
listorder=2;
typeofestimate='Between-Intervention comparison';
                  end;

if 13<= _n_<=24 then do;
listorder=3;
typeofestimate='Within-Intervention comparison';
                    end;
if 25 <= _n_<=30 then do;
listorder=4;
typeofestimate='Interaction of time by Intervention';
                    end;

 if . < probt <0.05 then significance='Y';

 if probt ne . then do;
   alpha=0.05;
 Tcrit = tinv(1-alpha/2, df) ;
  noncen=estimate/stderr;
 power=sum(1, -cdf("t", tcrit, df, noncen),
              cdf("t", -tcrit, df, noncen));
end;
 Effectsize=2*tvalue/sqrt(df);
 label effectsize='Effect size (2*tvalue/sqrt(DF))';
label power='Post Hoc power';
format power percent7.1;
run;

ods text=" ";
 ods text="~S={fontsize=2 color=green}Multiple comparisons";

proc report data=&estimateout nowindows spanrows;
column listorder typeofestimate outcome label stats df tvalue probt significance /*power effectsize*/;
define listorder/order noprint; 
define typeofestimate/group;
define outcome/group;
define label/display;
define stats/display;
define df/display;
define tvalue/display;
define probt/display;
define significance/display;
*define power/display;
*define effectsize/display;

format effectsize 8.2;
label 
typeofestimate='Type of estimate'
stats='Estimate(SEM)'
outcome='Outcome'
significance='p<0.05?';
run;


data change_Standard;
 set &estimateout end=lastobs;
 length BL_mean M06Mean M12Mean  M18Mean 
   deltablvsM06 deltablvsM12 deltablvsM18  deltaM06vsM12 deltaM06vsM18 deltaM12vsM18 $25.;

 retain  BL_mean M06Mean M12Mean  M18Mean deltablvsM06 deltablvsM12 deltablvsM18  deltaM06vsM12 deltaM06vsM18 deltaM12vsM18 p1-p6 es1-es6;

if label ='Standard, baseline' then BL_mean=Stats;
if label ='Standard, M06' then M06Mean=Stats;
if label ='Standard, M12' then M12Mean=Stats;
if label ='Standard, M18' then M18Mean=stats;

 if label ='BL - M06, Standard' then do;
         deltablvsM06=stats;
		 p1=probt;
		 Es1=2*tvalue/sqrt(df);
		                          end;

 if label ='BL - M12, Standard' then do;
       deltablvsM12=stats;
	   p2=probt;
	    Es2=2*tvalue/sqrt(df);
	                              end;

 if label ='BL - M18, Standard' then do;
       deltaBlvsM18=stats;
	   p3=probt;
	   Es3=2*tvalue/sqrt(df);
	                          end;


 if label ='M06 - M12, Standard' then do;
       deltaM06vsM12=stats;
	   p4=probt;
	   Es4=2*tvalue/sqrt(df);
	                          end;

 if label ='M06 - M18, Standard' then do;
       deltaM06vsM18=stats;
	   p5=probt;
	   Es5=2*tvalue/sqrt(df);
	                          end;

 if label ='M12 - M18, Standard' then do;
       deltaM12vsM18=stats;
	   p6=probt;
	   Es6=2*tvalue/sqrt(df);
	                          end;

 length Intervention $15.;
 Intervention='Standard';

 if lastobs then output;

 keep outcome Intervention  BL_mean M06Mean M12Mean  M18Mean 
deltablvsM06 deltablvsM12 deltablvsM18  deltaM06vsM12 deltaM06vsM18 deltaM12vsM18 p1-p6 es1-es6;
run;


data change_nonStandard;
 set &estimateout end=lastobs;

 length BL_mean M06Mean M12Mean  M18Mean 
   deltablvsM06 deltablvsM12 deltablvsM18  deltaM06vsM12 deltaM06vsM18 deltaM12vsM18 $25.;

 retain  BL_mean M06Mean M12Mean  M18Mean  deltablvsM06 deltablvsM12 deltablvsM18  deltaM06vsM12 deltaM06vsM18 deltaM12vsM18 p1-p6 es1-es6;

if label ='Sequential, baseline' then BL_mean=Stats;
if label ='Sequential, M06' then M06Mean=Stats;
if label ='Sequential, M12' then M12Mean=Stats;
if label ='Sequential, M18' then M18Mean=stats;

 if label ='BL - M06, Sequential' then do;
         deltablvsM06=stats;
		 p1=probt;
		 Es1=2*tvalue/sqrt(df);
		                          end;

 if label ='BL - M12, Sequential' then do;
       deltablvsM12=stats;
	   p2=probt;
	    Es2=2*tvalue/sqrt(df);
	                              end;

 if label ='BL - M18, Sequential' then do;
       deltaBlvsM18=stats;
	   p3=probt;
	   Es3=2*tvalue/sqrt(df);
	                          end;


 if label ='M06 - M12, Sequential' then do;
       deltaM06vsM12=stats;
	   p4=probt;
	   Es4=2*tvalue/sqrt(df);
	                          end;

 if label ='M06 - M18, Sequential' then do;
       deltaM06vsM18=stats;
	   p5=probt;
	   Es5=2*tvalue/sqrt(df);
	                          end;

 if label ='M12 - M18, Sequential' then do;
       deltaM12vsM18=stats;
	   p6=probt;
	   Es6=2*tvalue/sqrt(df);
	                          end;
 length Intervention $15.;
 Intervention='Sequential';

if lastobs then output;

 keep outcome Intervention  BL_mean M06Mean M12Mean  M18Mean 
deltablvsM06 deltablvsM12 deltablvsM18  deltaM06vsM12 deltaM06vsM18 deltaM12vsM18 p1-p6 es1-es6;
run;


data BetweenInterventiondiff;
 set &estimateout end=lastobs;
  length BL_mean M06Mean M12Mean  M18Mean 
   deltablvsM06 deltablvsM12 deltablvsM18  deltaM06vsM12 deltaM06vsM18 deltaM12vsM18 $25.;

 retain  BL_mean M06Mean M12Mean  M18Mean deltablvsM06 deltablvsM12 deltablvsM18  deltaM06vsM12 deltaM06vsM18 deltaM12vsM18 p1-p6 es1-es6;

if label ='(Standard - Sequential) at baseline' then BL_mean=Stats;
if label ='(Standard - Sequential) at M06' then M06Mean=Stats;
if label ='(Standard - Sequential) at M12' then M12Mean=Stats;
if label ='(Standard - Sequential) at M18' then M18Mean=stats;

 if label ='(Standard - Sequential) in (BL - M06)' then do;
         deltablvsM06=stats;
		 p1=probt;
		 Es1=2*tvalue/sqrt(df);
		                          end;

 if label ='(Standard - Sequential) in (BL - M12)' then do;
       deltablvsM12=stats;
	   p2=probt;
	    Es2=2*tvalue/sqrt(df);
	                              end;

 if label ='(Standard - Sequential) in (BL - M18)' then do;
       deltaBlvsM18=stats;
	   p3=probt;
	   Es3=2*tvalue/sqrt(df);
	                          end;


 if label ='(Standard - Sequential) in (M06 - M12)' then do;
       deltaM06vsM12=stats;
	   p4=probt;
	   Es4=2*tvalue/sqrt(df);
	                          end;

 if label ='(Standard - Sequential) in (M06 - M18)' then do;
       deltaM06vsM18=stats;
	   p5=probt;
	   Es5=2*tvalue/sqrt(df);
	                          end;

 if label ='(Standard - Sequential) in (M12 - M18)' then do;
       deltaM12vsM18=stats;
	   p6=probt;
	   Es6=2*tvalue/sqrt(df);
	                          end;
 Length Intervention $15.;
 Intervention='Difference';

 if lastobs then output;

 keep outcome Intervention  BL_mean M06Mean M12Mean  M18Mean 
deltablvsM06 deltablvsM12 deltablvsM18  deltaM06vsM12 deltaM06vsM18 deltaM12vsM18 p1-p6 es1-es6;
run;


 data final;
   set change_Standard change_nonStandard BetweenInterventiondiff;
 label
  outcome='Outcome'
  Intervention='Intervention'
  BL_mean='Baseline'
  M06Mean='6 month'
  M12Mean='12 month'
  M18Mean='18 month'

  deltablvsM06='Baseline - M06'
  deltablvsM12='Baseline - M12'
  deltablvsM18='Baseline - M18'
  deltaM06vsM12='M06 - M12'
  deltaM06vsM18='M06 - M18'
  deltaM12vsM18='M12 - M18'
  p1='p'
  p2='p'
  p3='p'
  p4='p'
  p5='p'
  p6='p'
es1='ES'
es2='ES'
es3='ES'
es4='ES'
es5='ES'
es6='ES'
;
  format p1-p6 pvalue5.;
 run;

 data finalout;
   set final end=lastobs;
   if lastobs then do;
     set &contrastout (keep=probf);
	         end;
	rename probf=poverallinteractiontest;
	label probf='p for overall interaction test';
 run;


 ods text="~S={fontsize=2 color=green}The table below is the same as the above one. However, p-values for between-Intervention
 comparison at each time point are not presented since they do not address the efficacy of intervention.";
ods text="~S={fontsize=2 color=green}p-values of primary interest are highlighted";
 ods text="~S={fontsize=2 color=green}One might want to include a table like this in the manuscript.";
 ods text="~S={fontsize=2 color=green}Model based estimates of Mean (SEM) are printed for baseline,	
 4 month, 8 month,12 month, M06 - baseline, M12 - baselin, eM18 - baseline, M06 - M12, M06 - M18 and M12 - M18.";

  ods text=" ";

 ods text="~S={fontsize=2 color=green}Multiple comparisons";
 ods text="~S={fontsize=2 color=green}Highlighted are tests of primary interest.";

 Proc report data=finalout nowindows  ;
 column outcome Intervention BL_mean M06Mean M12Mean M18Mean
  deltablvsM06 /*es1*/  p1 
  deltablvsM12          p2
  deltablvsM18 /*es2*/  p3 
  deltaM06vsM12 /*es3*/ p4
  deltaM06vsM18 /*es3*/ p5
  deltaM12vsM18 /*es3*/ p6
  poverallinteractiontest;

Define outcome /display;
Define Intervention /display;
Define BL_mean /display;
Define M06Mean /display;
Define M12Mean /display;
Define M18Mean /display; 

Define deltablvsM06 /display;
*Define es1 /display;
Define p1 /display;
define deltablvsM12 /display;
Define p2 /display;

Define deltablvsM18 /display;
*Define es2 /display;
Define p3 /display;

Define deltaM06vsM12 /display;
*Define es3 /display;
Define p4 /display;

Define deltaM06vsM18 /display;
*Define es3 /display;
Define p5 /display;

Define deltaM12vsM18 /display;
*Define es3 /display;
Define p6 /display;

Define poverallinteractiontest/display;

*format es1 es2 es3 8.2;

compute p1 ;
if _c2_ ='Difference' then 
       call define("_c8_", "style", "STYLE=[BACKGROUND=yellow]");
endcomp;

compute p2 ;
if _c2_ ='Difference' then 
       call define("_c10_", "style", "STYLE=[BACKGROUND=yellow]");
endcomp;

compute p3 ;
if _c2_ ='Difference' then 
       call define("_c12_", "style", "STYLE=[BACKGROUND=yellow]");
endcomp;

compute p4 ;
if _c2_ ='Difference' then 
       call define("_c14_", "style", "STYLE=[BACKGROUND=yellow]");
endcomp;

compute p5 ;
if _c2_ ='Difference' then 
       call define("_c16_", "style", "STYLE=[BACKGROUND=yellow]");
endcomp;

compute p6 ;
if _c2_ ='Difference' then 
       call define("_c18_", "style", "STYLE=[BACKGROUND=yellow]");
endcomp;

compute poverallinteractiontest ;
if _c2_ ='Difference' then 
       call define("_c19_", "style", "STYLE=[BACKGROUND=yellow]");
endcomp;

run;

%mend;

%macro allmixed ();


%do i = 1 %to &nvar;

 %mixedModel4TimePoints (inds=Temp , outcome=&&var&i, 
lsmeansout=lsmeans&i , estimateout=est&i, contrastout=contrast&i );

data final_V&i ;
 set final ;
  order=&i;
run;

data final_h&i ;
 set finalout ;
  order=&i;
run;

%If &i = 1 %then %do;

 data final_V ;
  set final_V1;
  run;

  
 data final_h ;
  set final_h1;
  run;
                %end;
%else %do;
  
  proc append base=final_v data=final_v&i;
  run;

  proc append base=final_H data=final_H&i;
  run;
 
%end;

%end;

%mend;


data vars;
input varname $1-32;
datalines;
visit_weight
bmi
wc_average
ett_vo2max_liters
ett_vo2max_ml_kg
TRUNK_BMC_g
TRUNK_FAT_g
TRUNK_LEAN_mass_g
TRUNK_LEAN_plus_BMC_g
TRUNK_MASS_g
TRUNK_PctFAT
TRUNK_PctLEAN
SUBTOT_BMC_g
SUBTOT_FAT_g
SUBTOT_LEAN_mass_g
SUBTOT_LEAN_plus_BMC_g
SUBTOT_MASS
SUBTOT_PctFAT
SUBTOT_PctLEAN
WBTOT_BMC_g
WBTOT_FAT_g
WBTOT_LEAN_mass_g
WBTOT_LEAN_plus_BMC_g
WBTOT_MASS_g
WBTOT_PctFAT
WBTOT_PctLEAN
run;

Data _null_;
set vars end=lastobs;
order=_n_;
call symput ('var'||trim(left(_n_)), trim(left(varname)));
call symput ('order'||trim(left(_n_)), trim(left(order)));
if lastobs then do;
 call symput ('nvar', trim(left(_n_)));
                end;
run;

%allmixed ();

ods rtf close;


title;
ods excel file="&rootpath\&projectn\Data\&yrmo\&dsdate\Completers -- LMM analysis of BLM06M18M18 data -- No data imputation.xlsx";;

 Proc report data=final_H nowindows  ;
 column order outcome Intervention BL_mean M06Mean M12Mean M18Mean
  deltablvsM06 /*es1*/  p1 
  deltablvsM12          p2
  deltablvsM18 /*es2*/  p3 
  deltaM06vsM12 /*es3*/ p4
  deltaM06vsM18 /*es3*/ p5
  deltaM12vsM18 /*es3*/ p6
  poverallinteractiontest;
define order/order noprint;
Define outcome /group;
Define Intervention /display;
Define BL_mean /display;
Define M06Mean /display;
Define M12Mean /display;
Define M18Mean /display; 

Define deltablvsM06 /display;
*Define es1 /display;
Define p1 /display;
define deltablvsM12 /display;
Define p2 /display;

Define deltablvsM18 /display;
*Define es2 /display;
Define p3 /display;

Define deltaM06vsM12 /display;
*Define es3 /display;
Define p4 /display;

Define deltaM06vsM18 /display;
*Define es3 /display;
Define p5 /display;

Define deltaM12vsM18 /display;
*Define es3 /display;
Define p6 /display;

Define poverallinteractiontest/display;

*format es1 es2 es3 8.2;

compute p1 ;
if _c3_ ='Difference' then do;
     if . <  _c9_ < 0.1   then  call define("_c9_", "style", "STYLE=[BACKGROUND=yellow]");
	 if . <  _c9_ < 0.05 then  call define("_c9_", "style", "STYLE=[BACKGROUND=lightgreen fontweight=bold]");
	                      end;
endcomp;

compute p2 ;
if _c3_ ='Difference' then do;
     if . <  _c11_ < 0.1   then  call define("_c11_", "style", "STYLE=[BACKGROUND=yellow]");
	 if . <  _c11_ < 0.05 then  call define("_c11_", "style", "STYLE=[BACKGROUND=lightgreen fontweight=bold]");
	                      end;
endcomp;

compute p3 ;
if _c3_ ='Difference' then do;
     if . <  _c13_ < 0.1   then  call define("_c13_", "style", "STYLE=[BACKGROUND=yellow]");
	 if . <  _c13_ < 0.05 then  call define("_c13_", "style", "STYLE=[BACKGROUND=lightgreen fontweight=bold]");
	                       end;
endcomp;

compute p4 ;
if _c3_ ='Difference' then do;
     if . <  _c15_ < 0.1   then  call define("_c15_", "style", "STYLE=[BACKGROUND=yellow]");
	 if . <  _c15_ < 0.05 then  call define("_c15_", "style", "STYLE=[BACKGROUND=lightgreen fontweight=bold]");
	                     end;
endcomp;

compute p5 ;
if _c3_ ='Difference' then do;
     if . <  _c17_ < 0.1   then  call define("_c17_", "style", "STYLE=[BACKGROUND=yellow]");
	 if . <  _c17_ < 0.05 then  call define("_c17_", "style", "STYLE=[BACKGROUND=lightgreen fontweight=bold]");
	                    end;
endcomp;

compute p6 ;
if _c3_ ='Difference' then do;
     if . <  _c19_ < 0.1   then  call define("_c19_", "style", "STYLE=[BACKGROUND=yellow]");
	 if . <  _c19_ < 0.05 then  call define("_c19_", "style", "STYLE=[BACKGROUND=lightgreen fontweight=bold]");
	                     end;
endcomp;

compute poverallinteractiontest ;
if _c3_ ='Difference' then do;

     if . <  _c20_ < 0.1   then  call define("_c20_", "style", "STYLE=[BACKGROUND=yellow]");
	 if . <  _c20_ < 0.05 then  call define("_c20_", "style", "STYLE=[BACKGROUND=lightgreen fontweight=bold]");
                          end;
endcomp;

run;

ods excel close;

proc printto;
run;

%let logfile=%str(&rootpath\&projectn\Data\&yrmo\&dsdate\Completers -- LMM analysis of BLM06M18M18 data -- No data imputation.log);
%let chklogresult=%str(&rootpath\&projectn\Data\&yrmo\&dsdate\Completers -- LMM analysis of BLM06M18M18 data -- No data imputation.txt);

%include "&rootpath\include\checklog.sas";

data _null_;
; error=SEtRC("FinishedProcessing", 4); put error; run;

