

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

%macro pooledSD (SD1=, N1=, SD2=, N2=);

Data pooledSD;
 SD1=&SD1;
 N1=&N1;
 SD2=&SD2;
 N2=&N2;
 PooledSD= SQRT(( (N1-1)*SD1**2 + (N2-1)*SD2**2 )/(N1+N2-2));
 run;

Proc print data=pooledSD;
run;

%mend;


Title "Estimate of Cohen's D and its interpretation";

%macro effsizeplot (mean1=0, mean2=0., sd=1, refintvl= , labellower=, labelupper=, outcomelabel=percent post-trt change);


 /*****************************************************************************/
 /* Generate data set for plotting two normal curves for a particular Cohen's */
 /*****************************************************************************/


data curves; /* density function of each group */

 mean1=&mean1;
 sd=&sd;
 mean2=&mean2;
 effsize=abs(mean2-mean1)/sd;

 beg=mean1 - 4*sd;
 end=mean1 + 4*sd;

do x= beg to end by &refintvl;
   pdf=PDF('NORMAL',x ,mean1 , sd  ); curve=1; output;
end;

 beg=mean2 - 4*sd;
 end=mean2 + 4*sd;

do x= beg to end by &refintvl;
   pdf=PDF('NORMAL',x ,mean2,sd); curve=2; output;
  end;

 drop beg end;
run;

Proc format;
 value rxfmt
 1="&labellower"
 2="&labelupper";
run;

 proc sort data=curves;
 by curve x;
 run;

 /*************************************/
 /* calculate all effect size measures*/
 /*************************************/

Data effectsize_D;

 mean1=&mean1;
 sd=&sd;
 mean2=&mean2;

 Diff_mean=(mean2-mean1) ;
 Diff_SD=SQRT(SD**2 + SD**2);

 effsize=diff_mean/sd;

 M_intersection=mean1 + abs((diff_mean/2));

 pctoverlap=2*CDF('NORMAL', m_intersection , mean2 , sd  );
 U3=1-CDF('NORMAL', mean1 , mean2 , sd  );

  u2=1-cdf('Normal', M_intersection, mean2 , sd);

  U1=(2*U2-1)/u2;

  *u1check=1-pctoverlap/(2*U2);

 c_stat=1-CDF('NORMAL',0 , diff_mean , diff_SD  );

 
call symput('c_stat', trim(left(put(c_stat, percent7.1))));

call symput('diff_mean', trim(left(put(Diff_mean, 8.2))));
call symput('diff_SD', trim(left(put(diff_SD, 8.2))));
call symput('effsize', trim(left(put(effsize, 8.2))));
call symput('Overlap', trim(left(put(pctoverlap, percent7.1))));
call symput ('u3nonoverlap', trim(left(put(u3, percent7.1))));
call symput ('U1nonoverlap', trim(left(put(u1, percent7.1))));
call symput ('U2nonoverlap', trim(left(put(u2, percent7.1))));


Label Mean1="Mean of &labellower group"
 mean2="Mean of &labelupper group"
 diff_mean="Mean difference"
 diff_SD="SD of individual difference"

 SD="Common (pooled) SD"
 effsize="Cohen's D"
 pctoverlap='% overlap'
 u3="Cohen's U3 nonoverlap"
  u1="Cohen's U1 nonoverlap"
  u2="Cohen's U2 nonoverlap"
 c_stat='C statistic';
run;


/*****************************************/
 /* Annotate data set for mean reference */
 /***************************************/
Data annomean;
 set effectsize_D;
 length function $8. color $8.;
 xsys='2'; ysys='2';
 function='move'; x=mean1; y=0; output;
 function='draw'; x=mean1; y=PDF('NORMAL',x ,mean1 , sd ); color='red'; output;
 function='move'; x=mean2; y=0; output;
 function='draw'; x=mean2; y=PDF('NORMAL',x ,mean2 , sd ); color='black'; output;
run;

/*************************************/
 /* Annotate data set for overlap    */
 /************************************/
Data annooverlaps;
  set effectsize_D;

 length function $8. color $8.;
 xsys='2'; ysys='2';

 beg=M_intersection -4*SD;
 end=M_intersection;

 do x= beg to end by  &refintvl;

 function='move'; ylow=0;
  yupp=PDF('NORMAL',x , mean2 , sd  );
  function='move'; y=ylow; output;
  function='draw'; y=yupp; line=2; color='black'; output;
 end;

 function='move'; 
  x=M_intersection; ylow=0;
  yupp=PDF('NORMAL',x , mean1 , sd  );
  function='move'; y=ylow; output;
  function='draw'; y=yupp; line=2; color='black'; output;


 beg=M_intersection;
 end=M_intersection + 4*SD;

 do x= beg to end by &refintvl;

function='move'; ylow=0;
  yupp=PDF('NORMAL',x , mean1 , sd  );
  function='move'; y=ylow; output;
  function='draw'; y=yupp; line=2; color='black'; output;
 end;
 drop beg end;
run;


/*************************************/
 /* Annotate data set for U2         */
 /************************************/
Data annoU2;
  set effectsize_D;

 length function $8. color $8.;
 xsys='2'; ysys='2';

 function='move'; x=m_intersection; y=0; output;
 function='draw'; x=m_intersection; y=PDF('NORMAL',x ,mean1 , sd ); color='black'; output;

 beg=m_intersection;
 end=mean2+4*SD;

 do x= beg to end by &refintvl;
  function='move'; ylow=0;
  yupp=PDF('NORMAL',x , mean2 , sd  );
  function='move'; y=ylow; output;
  function='draw'; y=yupp; line=2; color='black'; output;
 end;
  drop beg end;
run;

/*************************************/
 /* Annotate data set for U3         */
 /************************************/
Data annoU3;
  set effectsize_D;

 length function $8. color $8.;
 xsys='2'; ysys='2';

 function='move'; x=mean1; y=0; output;
 function='draw'; x=mean1; y=PDF('NORMAL',x ,mean1 , sd ); color='black'; output;

 beg=mean1;
 end=mean2+4*SD;

 do x= beg to end by &refintvl;
  function='move'; ylow=0;
  yupp=PDF('NORMAL',x , mean2 , sd  );
  function='move'; y=ylow; output;
  function='draw'; y=yupp; line=2; color='black'; output;
 end;
  drop beg end;
run;

 axis1 label=(a=90 'Probability density function' ) minor=none;
 axis2 minor=none;


ods text="~S={fontsize=2 color=green}This program is to estimate Cohen's D and interpret
 it in terms of three other measures for effect size.";

 ods text="~S={fontsize=2 color=green}User needs to initialize mean values of two groups and their
 common standard deviation.";
ods text=" ";

ods text="~S={fontsize=2 color=blue}Table 1:Estimate of Cohen's D effect size";
  
Proc print data=effectsize_d label noobs;
var Mean1 Mean2 SD Diff_mean effsize pctoverlap U1 U2 u3 c_stat;
format diff_mean effsize 8.2;
format pctoverlap U1 U2 u3 percent7.1 c_stat percent7.1;
run;

ods text="~S={fontsize=4 color=black}INTERPRETATION OF COHEN'S D:";
ods text="~S={fontsize=4 color=black}=============================";


ods text=" ";
ods text="~S={fontsize=2 color=green}Figure 1: Plot of a case of effect size assuming binormal distrition.";
ods text=" ";

 goptions device=emf hsize=5 in vsize=2.5 in
          htext=12 points hpos=100 vpos=100;

 Proc gplot data=curves annotate=annomean;
 plot pdf*x=curve/ vaxis=axis1 haxis=axis2 noframe;
 symbol1 i=j v=none c=red l=1 w=3 h=3;
 symbol2 i=j v=none c=black l=1 w=3 h=3;
  label x="&outcomelabel";
 format curve rxfmt.;
 title1 h=10 points "Cohen's D effect size = &effsize";
run;
quit;

ods text="~S={fontsize=1 color=black}Cohen's D is defined as the between-group difference
 in mean (i.e. distance between two vertical reference lines in Figure 1) standardized by the
 common standard deviation (Cohen 1977). In this case (Table 1), Cohen's D = (%trim(&mean2)-%trim(&mean1))/%trim(&sd) = %trim(&effsize).";
ods text=" ";

ods text="~S={fontsize=2 color=green}Figure 2: Oerlaping coefficient and Cohen's U1 nonoverlap for a given Cohen's D";
ods text=" ";

 goptions device=emf hsize=5 in vsize=2.6 in
          htext=12 points hpos=100 vpos=100;

 Proc gplot data=curves annotate=annooverlaps;
 plot pdf*x=curve/ vaxis=axis1 haxis=axis2 noframe;
 symbol1 i=j v=none c=red l=1 w=3 h=3;
 symbol2 i=j v=none c=black l=1 w=3 h=3;
  label x="&outcomelabel";
 format curve rxfmt.;
 title1 h=10 points "Cohen's D effect size = &effsize";
 title2 h=10 points "Overlaping Coefficient = &Overlap";
 title3 h=10 points "Cohen's U1 non-overlap = &u1nonoverlap";

run;
quit;

ods text="~S={fontsize=1 color=black}The shaded area (the common area under two probability density curves) in Figure 2 is called overlapping coefficient (OVL) or proportion of similar responses.
 OVL ranges from 0 to 1 with 1 indicating that the two distributions are identical whereas a value of 0 shows that there is no overlap (Ruscio & Mullen, 2012).
 Cohen's D of &effsize corresponds to the OVL of &overlap..";
 
 ods text="~S={fontsize=1 color=black}Cohen's U1 non-overlap is defined as the non-shaded area under two curves divided by the total area (shaded + non-shaded area).
 U1 ranges 0 to 1 with 0 indicating two distributions are identical whereas a value of 1 shows that there is no overlap. Cohen's D of &effsize corresponds to
 U1 of %trim(&u1nonoverlap) (Note, U1 is not equal to 1 - OVL).";
 

ods text=" ";
ods text=" ";

Title "Estimate of Cohen's D and its interpretation";
ods rtf startpage=now;


ods text="~S={fontsize=2 color=green}Figure 3: Cohen's U2 nonoverlap";

 
ods text=" ";
ods text=" ";

 goptions device=emf hsize=5 in vsize=2.5 in
          htext=12 points hpos=100 vpos=100;

 Proc gplot data=curves annotate=annou2;
 plot pdf*x=curve/ vaxis=axis1 haxis=axis2 noframe annotate=annomean;
 symbol1 i=j v=none c=red l=1 w=3 h=3;
 symbol2 i=j v=none c=black l=1 w=3 h=3;
 label x="&outcomelabel";
 format curve rxfmt.;
 title1 h=10 points "Cohen's D effect size = &effsize";
  title2 h=10 points "U2 = &U2nonOverlap";

run;
quit;

ods text="~S={fontsize=1 color=black}Cohen's U2 nonoverlap measure is defined as the percentage in the %trim(&labelupper) (shaded area in Figure 3)
 population that exceeds the same percentage in the %trim(&labellower) population (non-shaded area). Cohen's D of &effsize corresponds to
 U2 of %trim(&u2nonoverlap). That is, %trim(&u2nonoverlap) of the %trim(&labelupper) population exceeds
 the lowest %trim(&u2nonoverlap) of the %trim(&labellower) population.";


ods text=" ";
ods text=" ";
ods text="~S={fontsize=2 color=green}Figure 4: Cohen's U3  nonoverlap";


 goptions device=emf hsize=5 in vsize=2.5 in
          htext=12 points hpos=100 vpos=100;

 Proc gplot data=curves annotate=annou3;
 plot pdf*x=curve/ vaxis=axis1 haxis=axis2 noframe annotate=annomean;
 symbol1 i=j v=none c=red l=1 w=3 h=3;
 symbol2 i=j v=none c=black l=1 w=3 h=3;
 label x="&outcomelabel";
 format curve rxfmt.;
 title1 h=10 points "Cohen's D effect size = &effsize";
  title2 h=10 points "U3 = &U3nonOverlap";

run;
quit;

ods text="~S={fontsize=1 color=black}The shaded area in Figure 4 is called Cohen's U3 which is the probability that %trim(&labelupper) group will be above the mean of the
 %trim(&labellower) group. Cohen's D of &effsize corresponds to the U3 of &u3nonOverlap..";
ods text="~S={fontsize=1 color=black}U3 nonoverlap is also called percentile standing since the mean of %trim(&labelupper) poputlation stands at the
 %trim(&u3nonoverlap)ile of the %trim(&labellower) population";

Title "Estimate of Cohen's D and its interpretation";
ods rtf startpage=now;

/****************************************/
/* generate curve for difference outcome */
/*****************************************/

data diff_curve;
 set effectsize_D;
 beg=diff_mean - 4*diff_SD;
 end=diff_mean + 4*diff_SD;

 do x=beg to end by &refintvl;
 pdf=PDF('NORMAL',x ,diff_mean , diff_SD  ); output;
 end;
 run;
 
/****************************************/
/* annotate for c stat                  */
/*****************************************/

Data annoCstat;
  set effectsize_D;
 length function $8. color $8.;
 xsys='2'; ysys='2';
 
 function='move'; x=diff_mean; y=0; output;
 function='draw'; x=diff_mean; y=PDF('NORMAL',x ,diff_mean , diff_SD ); line=1; size=2; color='green'; output;

 function='move'; x=0; y=0; output;
 function='draw'; x=0; y=PDF('NORMAL',x ,diff_mean , diff_SD ); line=1; size=2; color='black'; output;

 beg=0;

 end=diff_mean+4*diff_sd;

 do x=beg to end by &refintvl;

 function='move'; y=0; output;
 function='draw';  y=PDF('NORMAL',x ,diff_mean , diff_SD ); line=2; color='black'; output;
end;
run;

ods text=" ";
ods text=" ";
ods text="~S={fontsize=2 color=green}Figure 5: Probability of superiority (C-statistic)";  
ods text=" ";
 Proc gplot data=diff_curve annotate=annocstat;
 plot pdf*x/ vaxis=axis1 haxis=axis2 noframe;
 symbol1 i=j v=none c=green l=1 w=3 h=3;
 label x="Difference ( %trim(&labelupper) - %trim(&labellower)) in outcome";
 title1 h=10 points "Cohen's D effect size = %trim(&effsize)";
 title2 h=10 points "C statistic=%trim(&c_stat).";
run;
quit;

ods text="~S={fontsize=1 color=black}If a pair of data points (one from %trim(&labelupper) and another from %trim(&labellower)) is randomly selected. 
 the distribution of the difference of the paired data points ( %trim(&labelupper) - %trim(&labellower)) was shown in Figure 4. The location and scale
 parameters are as follows.";
 ods text=" ";
 
 ods text="~S={fontsize=2 color=blue}Table 2: Parameters for the distribution of the individual difference";
Proc print data=effectsize_D noobs label;
var mean1 mean2 diff_mean diff_SD;
format diff_Sd 8.2;
run;
 ods text=" ";
ods text="~S={fontsize=1 color=black}The shaded area in Figure 5 is the estimate of the probability that a data point picked at random from the %trim(&labelupper) group
 will have a larger value than a data point picked at random from the %trim(&labellower) group.  This probability has several names, including:" ;
  ods text="~S={fontsize=1 color=black}        1. Probability of superiority";
  ods text="~S={fontsize=1 color=black}        2. Common language effect size (CL)";
  ods text="~S={fontsize=1 color=black}        3. C-statistic (Area under ROC Curve)";

  ods text="~S={fontsize=1 color=black}For the effect size of &effsize, the corresponding C-statistic is &c_stat..";

  ods text=" ";
  ods text=" ";
  ods text=" ";
  ods text=" ";

ods text="~S={fontsize=2 color=blue}References";
ods text="~S={fontsize=2 color=black}•Baguley, T. (2009). Standardized or simple effect size: what should be reported? British journal of psychology, 100(Pt 3), 603–17."; 
ods text="~S={fontsize=2 color=black}•Cohen, J. (1977). Statistical power analysis for the behavioral sciencies. Routledge.";
ods text="~S={fontsize=2 color=black}•Furukawa, T. A., & Leucht, S. (2011). How to obtain NNT from Cohen's d: comparison of two methods. PloS one, 6(4).";
ods text="~S={fontsize=2 color=black}•Reiser, B., & Faraggi, D. (1999). Confidence intervals for the overlapping coefficient: the normal equal variance case. Journal of the Royal Statistical Society, 48(3), 413-418.";
ods text="~S={fontsize=2 color=black}•Ruscio, J. (2008). A probability-based measure of effect size: robustness to base rates and other factors. Psychological methods, 13(1), 19–30.";
ods text="~S={fontsize=2 color=black}•Ruscio, J., & Mullen, T. (2012). Confidence Intervals for the Probability of Superiority Effect Size Measure and the Area Under a Receiver Operating Characteristic Curve. Multivariate Behavioral Research, 47(2), 201–223.";

%mend;

/*************** initializing it if needed **********************/
%let outputfilepath=%str(h:\References\Effect size\sas);
/***************************************************************/

ods _all_ close;
ods rtf file="&outputfilepath\Estimate of Cohen D and its interpreation.rtf" gtitle
 style=rtf_pan startpage=no;
 ods escapechar="~";

%effsizeplot(mean1=5, mean2=8, sd=3, refintvl=0.3, 
 labellower=control, labelupper=experimental, outcomelabel=Weight loss at 12 mo (kg));

 /****** Initialization parameter definition for Efsizeplot macro****************/
 /* Mean1=Mean value for group 1 ( < mean value of group 2)                     */
 /* Mean1=Mean value fro group 2 ( > mean value of group 1)                     */
 /* SD=Pooled (common) Standard deviation for both groups                       */
 /* refintvl=interval size between two reference lines for shadded area in plot */
 /* labellower='Label for the group 1                                           */
 /* labelupper='Label for group 2                                               */
 /* Outcomlabel=Label for the outcome variable                                  */
 /*******************************************************************************/

*%pooledSD (SD1=4, N1=6, SD2=3, N2=4);

ods rtf close;
ods listing;
