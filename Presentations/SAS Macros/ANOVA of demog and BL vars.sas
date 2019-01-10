*H*******************************************************************;
*H         Program Name: s:\Pan\&projectn\programs\ANOVA of demog and BL vars.sas
*H         Investigator: Amy wood
*H              Project: 
*H                        
*H              Purpose:  
*H        Datasets Used: 
*H     Datasets Created:
*H Output Files Created:
*H               Author: Zhaoxing Pan
*H             Comments:
*H         Date Written: 02-27-2009
*H*******************************************************************;


%let rootpath=c:\Pan\Projects;
%let yrmo=2012_10.Oct;
%let projectn=NAFLD_Fructose;
%let dsdate=20121023;

proc template;
Define Style RTF_pan;
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
filename newlog "&rootpath\&projectn\Data\&yrmo\&dsdate\ANOVA of demog and BL vars.log";
filename newlst "&rootpath\&projectn\Data\&yrmo\&dsdate\ANOVA of demog and BL vars.lst";

options font=(sasfont 6) 
        orientation=portrait
        noFmtErr
        missing=' '
        formdlim='='
		nodate
        pageno=1;

Title1 "&rootpath\&projectn\Programs\ANOVA of demog and BL vars.sas";

proc printto print=newlst log=newlog new;
run;

%macro GLM(inds=,  var=);


Proc mixed data=&inds;
class group;
model &var =group;
lsmeans group/pdiff;
ods output diffs=diffs/cl;
run;

 proc print data=diffs;
 run;

%mend;

	

%macro AllGLM (inds=library.demog, finaloutds=Alldemog);

%do i = 1 %to &nvar;

Title "ANOVA of &&var&i";
ods rtf startpage=now;

Proc sort data=&inds;
by group;
run;

Proc univariate data=&inds noprint;
by group;
var &&var&i;
output out=sum&i mean=mean n=n std=std min=min max=max median=median;
run;

data sum&i;
 set sum&i;
  length varname $50.;
  varname="&&var&i";
 run;

 ods text="Summary stats for &&var&i";

Proc print data=sum&i;
var varname group n mean std min median max;
run;

goption reset=all device=emf hsize=4 in vsize=3.5;
axis1 label=(a=90 "Mean of &&var&i");

 Proc gchart data=sum&i;
  vbar group/sumvar=mean discrete axis=axis1;
  run;
ods text="Anava analysis";

Proc mixed data=&inds;
class group;
model &&var&i =group;
lsmeans group/pdiff cl;
ods output diffs=ds&i ;
run;

data ds&i ;
 set ds&i ;
 length varname $50.;
  varname="&&var&i";

run;

%If &i = 1 %then %do;
 data &finaloutds;
  set ds1;
  run;

  Data allsummary;
   set sum1;
   run;
                %end;
%else %do;
  
  proc append base=&finaloutds data=ds&i;
  run;



  proc append base=allsummary data=sum&i;
  run;

%end;

%end;

%mend;


ods rtf
file="&rootpath\&projectn\Data\&yrmo\&dsdate\ANOVA of demog and BL vars.rtf"
style=rtf_pan startpage=no nogtitle;

data _null_;
 file print;
 put "This file is";
 put "&rootpath\&projectn\Data\&yrmo\&dsdate\ANOVA of demog and BL vars.rtf";
run;

Data _null_;
  file print;
  put "Program run on " "%sysfunc(date(),mmddyy10.)" " at " "%sysfunc(time(), hhmm5.)";
run;

Data _null_;
  file print;
  put "This program is to compare some variables across the three groups using ANOVA.";
  put "On the last few pages, summary of between group comparisons are presented.";
run;

Data vars;
input varname $1-24;
datalines;
age
height_2	
weight_2	
bmi_2	
bmi_zscore_2	
ideal_weight_2	
waist_circumference_2	
hip_circumference_2	
waist_hip_ratio_2	
calories_2	
carbs_2	
sucrose_2	
fructose_2	
totsug_2
SBP_arrival	
DBP_arrival
run;

Data _null_;
set vars end=lastobs;
call symput ('var'||trim(left(_n_)), trim(left(varname)));
if lastobs then do;
 call symput ('nvar', trim(left(_n_)));
                end;
run;

%AllGLM (inds=library.demog, finaloutds=Alldemog);

Data vars;
input varname $1-24;
datalines;
BL_uric_acid	
BL_glucose	
BL_fattyacids	
BL_Triglycerides	
BL_Insulin
BL_CC	
BL_Hydrogen	
BL_CH4	
BL_Co2	
BL_CV
run;

Data _null_;
set vars end=lastobs;
call symput ('var'||trim(left(_n_)), trim(left(varname)));
if lastobs then do;
 call symput ('nvar', trim(left(_n_)));
                end;
run;

%AllGLM (inds=library.allauc, finaloutds=Allbl);


title "Table for summary statistics";
ods rtf startpage=now;

Proc print data=allsummary;
by varname notsorted;
id varname;
var group n mean std min median max;
run;

title "Summary of ANOVA results";
ods rtf startpage=now;

data allglm;
 set alldemog allbl ;
 varlabel=put(upcase(varname), $demoglbl.);
 if . < probt <0.05 then significance="Y";
 label significance="p < 0.05?";
 run;

Proc print data=allglm label;
by varlabel notsorted;
id varlabel;
run;


ods rtf startpage=now;

ods rtf close;

proc printto;
run;

%let logfile=%str(&rootpath\&projectn\Data\&yrmo\&dsdate\ANOVA of demog and BL vars.log);
%let chklogresult=%str(&rootpath\&projectn\Data\&yrmo\&dsdate\ANOVA of demog and BL vars.txt);

%include "&rootpath\include\checklog.sas";

data _null_;
; error=SEtRC("FinishedProcessing", 4); put error; run;
