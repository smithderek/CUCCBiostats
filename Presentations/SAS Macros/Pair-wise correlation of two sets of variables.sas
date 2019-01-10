*H*******************************************************************;
*H         Program Name: s:\Pan\&projectn\programs\Correlation between sleep param and clinical - Pre-CPAP.sas
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

%let rootpath=X:\Retreats\Retreat November 2018\Presentations\Pan;
%let yrmo=2017_10.Oct;
%let projectn=CPAT study;
%let dsdate=20171026;

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
filename newlog "&rootpath\&projectn\Data\&yrmo\&dsdate\Correlation between sleep param and clinical - Pre-CPAP.log";
filename newlst "&rootpath\&projectn\Data\&yrmo\&dsdate\Correlation between sleep param and clinical - Pre-CPAP.lst";

options font=(sasfont 6) 
        orientation=portrait
        noFmtErr
        missing=' '
        formdlim='='
		nodate
        pageno=1 ps=59 ls=256 SPOOL;

Title1 "&rootpath\&projectn\Programs\Correlation between sleep param and clinical - Pre-CPAP.sas";

proc printto print=newlst log=newlog new;
run;

%macro lblfmt(inds=, fmtname=);

proc contents data=&inds out=contents(keep=name label) noprint;
run;

data _null_;
 set contents (where=( label ne ' ')) end=lastobs;
 file "&rootpath\&projectn\Data\&yrmo\&dsdate\lblformat.sas";
 doublequotes='"';
 name=upcase(name);
 left="'"||trim(left(name))||"'";
 right=trim(left(doublequotes))||trim(left(label))||trim(left(doublequotes));
 if _n_ = 1 then do;
  put "Proc format ;";
  put "value $&fmtname";
                 end;
  put left "=" right;
  if lastobs then do;
    put "; run;";
	              end;
run;

%include  "&rootpath\&projectn\Data\&yrmo\&dsdate\lblformat.sas";
%mend;


 %macro reg(inds=, DV =,  IV=);

title "Analysis of &DV vs. &IV";
  ods rtf startpage=now;

ods text="~S={fontsize=2 color=blue}Analysis of &DV vs. &IV";
ods text="~S={fontsize=2 color=blue}Linear model";

Proc reg data=&inds;
model &DV = &IV;
ods select parameterestimates;
ods output parameterestimates=params;
run;

data _null_;
 set params;
 if variable ne 'Intercept' then do;
    slope=estimate;
	pvalue4slope=probt;
	call symput ('slope', trim(left(put(slope, 8.3))));
	call symput ('pvalue4slope', trim(left(put(pvalue4slope, pvalue5.))));
                               end;
run;


Proc corr data=&inds nosimple spearman pearson;
var &DV  &IV;
ods output spearmancorr=spearmancorr pearsoncorr=pearsoncorr;
run;

data spearmancorr1;
  set spearmancorr end=lastobs;
  length DV $32. IV $32.;
   DV="&DV";
  if lastobs then do;
      IV=Label;
	   spearmancorr=&DV;
	  spearmancorrp=p&DV;
	  output;
                 end;
keep IV DV spearmancorr spearmancorrp;
run;


Data _null_;
 set spearmancorr1;
 call symput('spearmancorr', put(spearmancorr, 8.2));
 call symput('spearmancorrP', put(spearmancorrP, pvalue5.));
run;


data Pearsoncorr1;
  set Pearsoncorr end=lastobs;
  length DV $32. IV $32.;
   DV="&DV";
  if lastobs then do;
      IV="&IV";
	   Pearsoncorr=&DV;
	  Pearsoncorrp=p&DV;
	  output;
                 end;
keep IV DV Pearsoncorr Pearsoncorrp;
run;

Data _null_;
 set pearsoncorr1;
 call symput('Pearsoncorr', put(Pearsoncorr, 8.2));
 call symput('PearsoncorrP', put(PearsoncorrP, pvalue5.));
run;

goption device=emf hsize=3.5 in vsize=2.6 in htext=10 points hpos=100 vpos=100;
axis1 label=(a=90  ) minor=none ;
axis2    minor=none offset=(0.5 cm, 0.5 cm);

Proc gplot data=&inds ;
plot &DV*&IV/haxis=axis2 vaxis=axis1;
symbol i=rl v=circle w=3 h=3 c=black r=3 line=1;
title1 h=10 points "Linear regression. Slope=%trim(&slope), p-value %trim(&pvalue4slope)";
title2 h=10 points "Spearman r = %trim(&spearmancorr), p-value %trim(&spearmancorrp)";
title3 h=10 points "Pearson r = %trim(&Pearsoncorr), p-value %trim(&Pearsoncorrp)";run;

%mend;

ods _all_ close;

ods rtf
file="&rootpath\&projectn\Data\&yrmo\&dsdate\Correlation between sleep param and clinical - Pre-CPAP.rtf"
style=rtf_pan startpage=no ;
ods escapechar="~";

data _null_;
 file print;
 put "This file is";
 put "&rootpath\&projectn\Data\&yrmo\&dsdate\Correlation between sleep param and clinical - Pre-CPAP.rtf";
run;

Data _null_;
  file print;
  put "Program run on " "%sysfunc(date(),mmddyy10.)" " at " "%sysfunc(time(), hhmm5.)";
run;

ods text="~S={fontsize=2 color=blue}This program is to calculate Spearman and Pearson correlation of
 between pre-CPAP sleep parameters and pre-CPAP clinical variables.";

ods text=" ";

ods text="~S={fontsize=2 color=red}Detail of analysis for a pair of variables is presented on each page from
 page 2.  On the last few pages, there are summary tables.";



data temp;
 set library.analysisds;

 rfd_isom_meanof4measures=mean(of rfd_isom_30
rfd_isom_50
rfd_isom_100
rfd_isom_200);

if dominant_side=1 then do;/* right*/
  Avg_grip_strength_Dom= Avg_grip_strength_RH;
  Avg_grip_strength_nonDom= Avg_grip_strength_LH;
                  end;

if dominant_side=2 then do /* left */
    Avg_grip_strength_Dom= Avg_grip_strength_LH;
    Avg_grip_strength_nonDom= Avg_grip_strength_RH;
                      end;

/***********************/
if rfd_data_usable_d=1;  /* 1=regular process of RFD */
/**********************/

label rfd_isom_meanof4measures='Mean of rfd_isom_30 rfd_isom_50 rfd_isom_100 and rfd_isom_200'

Avg_grip_strength_Dom='Grip strength on dominant side'
Avg_grip_strength_nonDom='Grip strength on non-dominant side';

Avg_step_length_current =mean(of iga_sl_l_current igs_sl_r_current);
label Avg_step_length_current='Mean of sl_l_current and sl_r_current';

run;


%lblfmt(inds=temp, fmtname=thisfmt);


Data DVS;
input varname $1-32;
datalines;
Promis57_phy_func_total_score
Avg_grip_strength_nonDom
Avg_grip_strength_Dom
run;

Data _null_;
set DVS end=lastobs;
call symput ('DV'||trim(left(_n_)), trim(left(varname)));
if lastobs then do;
 call symput ('NDV', trim(left(_n_)));
                end;
run;

Data IVs;
input varname $1-32;
datalines;
rfd_isom_mvic_d
rfd_isom_prfd_d
run;

Data _null_;
set IVS end=lastobs;
call symput ('IV'||trim(left(_n_)), trim(left(varname)));
if lastobs then do;
 call symput ('NIV', trim(left(_n_)));
                end;
run;

%global N;
%let N=0;

%macro allreg ;

%do i= 1 %to &NDV;
  %do j=1  %to &NIV;

%reg(inds=temp, DV =&&DV&i,  iv=&&IV&J);

 data _null_;
  i=&i;
  j=&j;
  if i=1 and j=1 then do;
    N=1;
	               end;
  else do;
   last=&N;
   N=last+1;
      end;
   call symput( 'N', trim(left(N)));
	put N;
  run;

data ds&N;
 merge spearmancorr1 pearsoncorr1;
 order=&n;
 run;

  %end;
%end;

%mend;

%allreg ;


data allcorrs;
 set ds1-ds&n;
  length dvlabel ivlabel $80.;
 ivlabel=put(upcase(iv), $thisfmt.);
  dvlabel=put(upcase(dv), $thisfmt.);

  detailpagenumber=_n_+1;
  if . < spearmancorrp < 0.05 or . < Pearsoncorrp < 0.05 then significance="Y";
  label significance="p<0.05";
 run;

 title "~S={fontsize=2 color=red}Summary table for all analyses";
ods rtf startpage=now;
ods text="~S={fontsize=2 color=blue}Summary table for all correlation analysis.";

 ods text="~S={fontsize=2 color=green}Jacob Cohen used 0.10, 0.30 and 0.5 as cutoff to define
 Small, Medium and Large effect size respectively. Reference: Jacob Cohen, Psychological bulletin, 1992, Vol. 112, No. 1, 155-159 ";

ods text=" ";

 ods text="~S={fontsize=2 color=red}Summary table for all analyses";

ods text=" ";
ods text="~S={fontsize=2 color=blue}Color coding for effect size: Yellow=Small, green=Medium and Pink=Large";
ods text="~S={fontsize=2 color=red}NOTE:NO ADJUSTMENT for comparisons of multiple outcomes have been applied here.";

 Proc report data=allcorrs nowindows;
 column  dvlabel ivlabel  spearmancorr spearmancorrp Pearsoncorr Pearsoncorrp significance detailpagenumber;
 define dvlabel/display;
 define ivlabel/display;
 define spearmancorr/display;
 define spearmancorrp/display;
 define Pearsoncorr/display;
 define Pearsoncorrp/display;
 define significance/display;
 define detailpagenumber/display;
 

compute spearmancorr;
if 0.2 <= abs(_c3_)  < 0.3  then 
       call define("_c3_", "style", "STYLE=[BACKGROUND=yellow]"); 
if 0.3 <= abs(_c3_ ) < 0.5  then 
       call define("_c3_", "style", "STYLE=[BACKGROUND=lightgreen]"); 
if 0.5<= abs(_c3_)  < 1  then 
       call define("_c3_", "style", "STYLE=[BACKGROUND=pink]"); 
endcomp;

compute Pearsoncorr;
if 0.2 <= abs(_c5_)  < 0.3  then 
       call define("_c5_", "style", "STYLE=[BACKGROUND=yellow]"); 
if 0.3 <= abs(_c5_)  < 0.5  then 
       call define("_c5_", "style", "STYLE=[BACKGROUND=lightgreen]"); 
if 0.5<= abs(_c5_)  < 1  then 
       call define("_c5_", "style", "STYLE=[BACKGROUND=pink]"); 
endcomp;

format Pearsoncorr spearmancorr 8.2;
format Pearsoncorrp spearmancorrp pvalue5.;
 label detailpagenumber="Page number for detail"
 dvlabel='DV'
 ivlabel='IV'
 spearmancorr='Spearman r'
 spearmancorrp='p for Spearman r'
 Pearsoncorr='Pearson r'
 Pearsoncorrp='p for Pearson r';
 run;


 Proc sql noprint;
  select count(spearmancorr) into :N_sig from allcorrs where significance="Y";
  run;

%macro printsig;

%if &N_sig = 0 %then %do;
 ods text="~S={fontsize=2 color=blue}There is no correlation coefficients significantly different from zero.";
%end;

%if &N_sig gt 0 %then %do;


title "Summary table for pairs with p < 0.05.";

ods rtf startpage=now;
 ods text="~S={fontsize=2 color=green}Jacob Cohen used 0.10, 0.30 and 0.5 as cutoff to define
 Small, Medium and Large effect size respectively. Reference: Jacob Cohen, Psychological bulletin, 1992, Vol. 112, No. 1, 155-159 ";

ods text=" ";

 ods text="~S={fontsize=2 color=red}Summary table for all analyses";

ods text=" ";
ods text="~S={fontsize=2 color=blue}Color coding for effect size: Yellow=Small, green=Medium and Pink=Large";
ods text="~S={fontsize=2 color=red}NOTE:NO ADJUSTMENT for comparisons of multiple outcomes have been applied here.";

ods text="~S={fontsize=2 color=blue}Summary table for pairs with p < 0.05.";

 Proc report data=allcorrs nowindows;
 where significance ='Y';
 column  dvlabel ivlabel  spearmancorr spearmancorrp Pearsoncorr Pearsoncorrp significance detailpagenumber;
 define dvlabel/display;
 define ivlabel/display;
 define spearmancorr/display;
 define spearmancorrp/display;
 define Pearsoncorr/display;
 define Pearsoncorrp/display;
 define significance/display;
 define detailpagenumber/display;
 

compute spearmancorr;
if 0.2 <= abs(_c3_)  < 0.3  then 
       call define("_c3_", "style", "STYLE=[BACKGROUND=yellow]"); 
if 0.3 <= abs(_c3_ ) < 0.5  then 
       call define("_c3_", "style", "STYLE=[BACKGROUND=lightgreen]"); 
if 0.5<= abs(_c3_)  < 1  then 
       call define("_c3_", "style", "STYLE=[BACKGROUND=pink]"); 
endcomp;

compute Pearsoncorr;
if 0.2 <= abs(_c5_)  < 0.3  then 
       call define("_c5_", "style", "STYLE=[BACKGROUND=yellow]"); 
if 0.3 <= abs(_c5_)  < 0.5  then 
       call define("_c5_", "style", "STYLE=[BACKGROUND=lightgreen]"); 
if 0.5<= abs(_c5_)  < 1  then 
       call define("_c5_", "style", "STYLE=[BACKGROUND=pink]"); 
endcomp;

format Pearsoncorr spearmancorr 8.2;
format Pearsoncorrp spearmancorrp pvalue5.;
 label detailpagenumber="Page number for detail"
 dvlabel='DV'
 ivlabel='IV'
 spearmancorr='Spearman r'
 spearmancorrp='p for Spearman r'
 Pearsoncorr='Pearson r'
 Pearsoncorrp='p for Pearson r';
 run;

%end;
 
%mend;

%printsig;

ods rtf close;

ods listing;

proc printto;
run;

%let logfile=%str(&rootpath\&projectn\Data\&yrmo\&dsdate\Correlation between sleep param and clinical - Pre-CPAP.log);
%let chklogresult=%str(&rootpath\&projectn\Data\&yrmo\&dsdate\Correlation between sleep param and clinical - Pre-CPAP.txt);

%include "&rootpath\include\checklog.sas";

data _null_;
; error=SEtRC("FinishedProcessing", 4); put error; run;
