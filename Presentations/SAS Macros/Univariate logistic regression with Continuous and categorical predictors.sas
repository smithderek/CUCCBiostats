*H*******************************************************************;
*H         Program Name: "S:\Pan\&projectn\programs\Univariate logistic regression.sas"
*H         Investigator: 
*H              Project: 
*H              PurposS:  
*H        Datasets Used: 
*H     Datasets Created:
*H Output Files Created:
*H               Author: Zhaoxing Pan
*H             CommentS:
*H         Date Written: Oct-1-2009
*H*******************************************************************;
*H          Modified On:
*H          Modified By:
*H              DetailS:
*H*******************************************************************;




proc Template;
Define Style pan_rtf;
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
filename newlog "&rootpath\&projectn\Data\&yrmo\&dsdate\Univariate logistic regression.log";
filename newlst "&rootpath\&projectn\Data\&yrmo\&dsdate\Univariate logistic regression.lst";

options font=(sasfont 6) 
        orientation=portrait
        noFmtErr
        missing=' '
        formdlim='='
		nodate
        pageno=1;

Title1 "&rootpath\&projectn\Programs\Univariate logistic regression.sas";

proc printto print=newlst log=newlog new;
run;

data temp;
 set library.lactation;

if disposition_at_discharge ne 3; /*Exclude cases with infant dead*/
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

%lblfmt(inds=temp, fmtname=thisfmt);

ods _all_ close;

ods rtf file="&rootpath\&projectn\Data\&yrmo\&dsdate\Univariate logistic regression.rtf"
     startpage=no style=pan_rtf ;
ods escapechar="~";


 Data _null_;
  file print;
  put "This file is";
  put "&rootpath\&projectn\Data\&yrmo\&dsdate\Univariate logistic regression.rtf";
 run;

ods text="  ";

data continuousvars;
input varname $32.;
categoricalvariable=0;
datalines;
length_of_stay
gestational_age
birth_weight
number_of_maternal_risk_fa
number_of_trips_to_the_ope
total_days_of_mechanical_v
five_minute_aggar
run;

data categoricalvars;
input varname $32.;
categoricalvariable=1;
datalines;
abdominal_wall_defect
abruption_or_post_partum_h
auto_immune_disorder
birth_weight_classificatio
choice_of_mother_to_cease
congenital_heart_disease_o
diabetes
failure_to_thrive_ftt
feeding_intolerance
gastrostomy_tube
hispanic_origin
hypertension
inadequate_weight_gain
inborn
infrequent_visits_or_trans
insufficient_breast_tissue
intubated_at_any_time
lack_of_resources
low_volume_of_breast_milk
maternal_infection
mental_health
metabolic_or_endocrine_dis
necrotizing_enterocolitis
neonatal_abstinence_syndro
obesity
ostomy
race
severe_bronchopulmonary_dy
type_of_delivery
unable_to_produce_breast_m
use_of_marijuana
run;

/* quasi-complete separation of data*/
/* 
drugs
feeds_at_discharge_from_th
insurance_at_discharge
other_social_or_non_medica
*/
%let firststart=3;

data predictors;
 set continuousvars categoricalvars;
 retain lastend;

 if _n_=1 then do;

   if categoricalvariable=0 then do;
     start=&firststart; end=start+2;
	                       end;

	 if categoricalvariable=1 then do;
     start=&firststart; end=start+2;
	                       end;
  lastend=end;

 end;

  if _n_ > 1 then do;
   
   if categoricalvariable=0 then do;
     start=lastend+1; end=start+2;
	                       end;

	 if categoricalvariable=1 then do;
     start=lastend+1; end=start+2;
	                       end;
	 lastend=end;
                 end;
	drop lastend;
 run;

ods text="~S={fontsize=2 color=blue}This program is to perform Univariate Logistic regression for the following predictors";

proc print data=predictors label;
label
varname='Predictor variable name'
categoricalvariable='Categorical variable?'
start='start page'
end='End page';
run;

ods text="  ";

ods text="~S={fontsize=2 color=red}There is a summary table on the last page";

data _null_;
 set predictors end=lastobs;
 Call symput ('predictor'||trim(left(_n_)), trim(left(varname)));
  Call symput ('categoricalPredictor'||trim(left(_n_)), trim(left(categoricalvariable)));

 if lastobs then do;
 call symput('Nvar', trim(left(_n_)));
           end;
run;

ods graphics on;

%macro logisticreg(DV= , Predictor=, roccutoffout= , ORout=);

Data _null_;
DV="&dv";
Predictor="&Predictor";
call symput ('DVlabel', trim(left(put(upcase(dv), $Thisfmt.))));
call symput ('Predictorlabel', trim(left(put(upcase(Predictor), $Thisfmt.))));
put "Analysis of " predictor;
run;

title "Analysis: &dvlabel Vs. &Predictorlabel";
ods rtf startpage=now;

ods graphics on/reset=all
       width =3in
	   height=3in
       imagefmt=static;

ods text="~S={fontsize=2 color=blue}Analysis of &dvlabel Vs. &Predictorlabel";

%if &&categoricalPredictor&i = 1 %then %do;

Proc logistic data=temp  plots(only)=(Roc(id=prob) effect ) descending ;
class &predictor /param=glm ;
 model
 &dv	= &Predictor	/expb  clodds=both  orpvalue outroc=outroc;
oddsratio &predictor;

ods output association=association
    ParameterEstimates=parameterestimates
	cloddspl=cloddspl
    cloddswald=cloddswald
	ModelANOVA=type3
	;
run;

data _null_;
    set type3; 
    call symput('Ptype3', probchisq);/* p for type 3 test.*/
  run;

%end;

%if &&categoricalPredictor&i = 0 %then %do;

Proc logistic data=temp  plots(only)=(Roc(id=prob) effect ) descending ;
 model
 &dv	= &Predictor	/expb  clodds=both  orpvalue outroc=outroc ;
oddsratio &predictor;

ods output association=association
    ParameterEstimates=parameterestimates
	cloddspl=cloddspl
    cloddswald=cloddswald
	;
run;

data _null_;
    set parameterestimates; 
     if variable ne 'Intercept' then call symput('Ptype3', probchisq);/* p for type 3 test.*/
  run;


%end;


data _null_;
    set association; /*Data set from logistic regression, association.*/
    if label2='c' then do;
    call symput('AUC', cvalue2); /*Output the c-index as a macro for later use in this macro*/
                   end;
  run;

data &ORout;
  set cloddswald;
  length predictor $32. OR_comparison $125.;

  OR_comparison=effect;
  predictor="&Predictor";
  order=&i;
  c_stat=&AUC;
  type3p=&Ptype3;
  drop effect;
run;

%mend;


%macro all_ORs;

%do i = 1 %to &nvar ;

  %logisticreg(DV=study_group_breastfeeding, Predictor=&&predictor&i , 
roccutoffout=ds&i, ORout=or&i);

%end;

%mend;

%all_ORs;


Data allor;
 set or1-or&nvar;
 Outcome="Stopped or Continued Human Milk Feeding";
 predictordesc=put(upcase(predictor), $thisfmt.);
run;

options orientation=landscape;

ods rtf startpage=now;
ods text="~S={fontsize=2 color=blue}Summary of all OR estimates";

proc report data=allor nowindows spanrows;
Column order outcome predictordesc predictor C_stat type3p OR_comparison Unit	OddsRatioEst	LowerCL	UpperCL pvalue;
define order/order noprint;
define outcome/group;
define predictordesc/group;
define predictor/group;
define c_stat/group;
define type3p/group;
define or_comparison/display;
define unit/display;
define oddsratioest/display;
define lowercl/display;
define uppercl/display;
define pvalue/display;

compute type3p;
if 0 <= abs(_C6_)  < 0.05  then 
       call define("_C6_", "style", "STYLE=[BACKGROUND=lightgreen]"); 
endcomp;

label
Outcome='Outcome variable'
predictordesc='Predictor'
predictor='Predictor variable'
c_stat='c-Statistic'
type3p='P, type 2 test'
OR_comparison='OR description';

format type3p pvalue6.;
run;

ods text="~S={fontsize=2 color=blue}Predictors with p < 0.05";

data predictorssignificant;
 set allor;
 by order notsorted;
 if first.order and type3p < 0.05 ;
 run;

 Proc print data=predictorssignificant;
 var predictor predictordesc type3p;
 run;


ods graphics off;


ods rtf close;

ods listing;

proc printto;
run;

%let logfile=%str(&rootpath\&projectn\Data\&yrmo\&dsdate\Univariate logistic regression.log);
%let chklogresult=%str(&rootpath\&projectn\Data\&yrmo\&dsdate\Univariate logistic regression.txt);

%include "&rootpath\include\checklog.sas";

data _null_; error=SETRC("FinishedProcessing", 4); put error; run;
