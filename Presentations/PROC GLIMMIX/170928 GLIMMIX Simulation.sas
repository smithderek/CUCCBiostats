
/* Define Parameters */

	%let Beta0=-3;
	%let Beta1=1.5;
	%let Beta2=0.5;
	%let Beta3=-0.25;
	%let G=2;
	%let Sigma=1.5;

/* Simulate Data */

	data sim;
		do i=1 to 100;
			X1_i=ranbin(1,1,0.5);
			X2_i=ranuni(2)*30;
			Gamma_i=rannor(3)*&G;
			Fixed_i=&Beta0+&Beta1*X1_i+&Beta2*X2_i+&Beta3*X1_i*X2_i;
			YLM_i=Fixed_i+rannor(4)*&Sigma;
			YGLM_i=ranbin(5,1,1/(1+exp(-Fixed_i)));
			do j=1 to 10;
				YLMM_ij=Fixed_i+Gamma_i+rannor(5)*&Sigma;
				YGLMM_ij=ranbin(6,1,1/(1+exp(-Fixed_i-Gamma_i)));
				output;
			end;
		end;
	run;

/* Linear Model */

	Proc GLM data=sim;
	model YLM_i = X1_i X2_i X1_i*X2_i / clparm;
	run;

	Proc GLIMMIX data=sim;
	model YLM_i = X1_i X2_i X1_i*X2_i / s cl;
	run;

/* GLM */

	Proc GENMOD data=sim descending;
	model YGLM_i = X1_i X2_i X1_i*X2_i /  cl dist=bin link=logit;
	run;

	proc GLIMMIX data=sim;
	model YGLM_i = X1_i X2_i X1_i*X2_i / s cl dist=bin link=logit;
	run;

/* LMM */

	proc MIXED data=sim;
	class i;
	model YLMM_ij = X1_i X2_i X1_i*X2_i / s cl;
	random intercept / subject=i;
	run;

	proc GLIMMIX data=sim;
	class i;
	model YLMM_ij = X1_i X2_i X1_i*X2_i / s cl;
	random intercept / subject=i;
	run;

/* Subject-Specific GLMM */

	proc NLMIXED data=sim;
	YGLMM_ij=Beta0+Beta1*X1_i+Beta2*X2_i+Beta3*X1_i*X2_i+Gamma;
	model YGLMM_ij~binary(p);
	random Gamma~normal(0,G) subject=i;
	run;

	proc GLIMMIX data=sim method=quad;
	class i;
	model YGLMM_ij = X1_i X2_i X1_i*X2_i / dist=binary link=logit s cl;
	random intercept / subject=i;
	run;

	proc GLIMMIX data=sim method=laplace;
	class i;
	model YGLMM_ij = X1_i X2_i X1_i*X2_i / dist=binary link=logit s cl;
	random intercept / subject=i;
	run;

	proc GLIMMIX data=sim method=mspl;
	class i;
	model YGLMM_ij = X1_i X2_i X1_i*X2_i / dist=binary link=logit s cl;
	random intercept / subject=i;
	run;

	proc GLIMMIX data=sim method=rspl;
	class i;
	model YGLMM_ij = X1_i X2_i X1_i*X2_i / dist=binary link=logit s cl;
	random intercept / type=vc subject=i;
	run;

/* Population-Averaged GLMM */

	proc GENMOD data=sim;
	class i;
	model YGLMM_ij = X1_i X2_i X1_i*X2_i / dist=bin link=logit cl;
	repeated  subject=i;
	run;

	proc GLIMMIX data=sim method=mmpl;
	class i;
	model YGLMM_ij = X1_i X2_i X1_i*X2_i / dist=binary link=logit s cl;
	random residual / subject=i;
	run;

	proc GLIMMIX data=sim method=rmpl;
	class i;
	model YGLMM_ij = X1_i X2_i X1_i*X2_i / dist=binary link=logit s cl;
	random residual / subject=i;
	run;

