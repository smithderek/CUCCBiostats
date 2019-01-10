
/* There are at least six ways to define a macro variable. */

/*******************************/
/* No. 1 -- use %let statement */
/*******************************/

%let No1 =use '%let' statement;
%put &No1 ;

/* if there is special characters, use %str or %nrstr */
%let No1 =use %let statement;  /*Not working */
%let No1 =%nrstr(use %let statement);
%put &No1 ;

%let No1 =%str(use %let statement); /*not working*/

%let No1=A GT B; ;
%put &No1 ;

%let No1=%str(A GT B;) ;
%put &No1 ;

%let No1=A & B;
%put &No1 ;

%let No1=A &B; /* working with warning*/
%put &No1 ;

%let No1=%str(A &B); /* working with warning*/
%put &No1 ;

%let No1=%nrstr(A &B); /* working and no warning*/
%put &No1 ;

/*******************************/
/* No 2 -- use proc sql        */
/*******************************/

data a;
input ID $ outcome gender $;
datalines;
Subj-1 20 F
Subj-2 10 M
Subj-3 30 M
subj-4 40 F
run;

Proc print;
run;

Proc sql;
select id as id into :id1-:id99 from a;
quit;

%put &id1 ;
%put &id2 ;
%put &id3 ;
%put &id4 ; /* No id4 created */


Proc sql;
select mean(outcome) as avg into :avg_outcome from a;
quit;
%put &avg_outcome ;

/**********************************************/
/* No 3 -- use symput function in a data step */
/**********************************************/
Data _null_;
 set a end=lastobs;
 call symput('participant'||trim(left(_n_)), trim(left(id)));

 if lastobs then do;
   call symput('N_participants', trim(left(_n_)));
              end;
run;

%put &participant1;
%put &participant2;
%put &participant3;
%put &n_participants;

/*****************************************************/
/* No 4 -- Define macro variables in macro procedure */
/*****************************************************/

%macro demo (firstname= , lastname=);
 %put &firstname;
 %put &lastname;
%mend;

%demo (firstname=John , lastname=smith);

/*****************************************************/
/* No 5 -- use %do looping                           */
/*****************************************************/

%macro looping ;
 %do x = 1 %to &n_participants;
 %put &x;
 %end;
%mend;

%looping ;

/*****************************************************/
/* No 5 -- use %window                               */
/************* see program--Tolerance limit.sas*******/

