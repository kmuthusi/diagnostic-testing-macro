**************************************************************************
**************************************************************************
** FILENAME     : diag_test.sas                                         **
**                                                                      **
** DESCRIPTION	: Calculates diagnostic accuracy measures i.e.,			**
** 				sensitivity, specificity, positive predictive 			**
** 				values (PPN), negative predictive values (NPV), 		**
** 				positive likelihood ratio (LR+), negative likelihood  	**
** 				ratio (LR-), diagnostic accuracy, disease,				**
** 				prevalence and diagnostic odds ratio (DOR) and			**
** 				prepares publication-quality output						**
**                                                                      **
** AUTHOR       : Jacques Muthusi                          				**
**                                                                      **
** DATE			: 01OCT2021												**
**                                                                      **
** MODIFIED		: 														**
**                                                                      **
** REFERENCE    :  														**
**               														**
** PLATFORM     : WINDOWS												**
**																		**
** INPUT		: Any dataset with diagnostic and reference test 		**
**				variables.												**
**                                                                      **
** OUTPUT		: Publication-quality table diagnostic accuracy 		**
** 				measures plus 2x2 contingency in MS Word and Excel.   	**
**                                                                      **
** ASSUMPTIONS	: The analysis dataset is clean, analysis variables 	**
** 				are well labelled, and values of variables have been	**
**				converted into appropriate SAS formats before they		**
**				can be input to the macro call.			      			**
**												   						**
** PARAMETERS	: See Table 1 of main manuscript for more details	   	**
**												   						**
**************************************************************************
**************************************************************************;

%macro diag_test(	data=,
					testvarlist=,
					/*testtypelist=,*/
					testcutvalue=, 
					/*testcutvalueunits=,*/
					truthvar=,
					/*truthvarlabel=,*/
					truthcutvalue=,
					/*truthcutvalueunits=,*/
					domain=,
					domainvalue=,
					condition=,
				 	tabletitle=,
				 	tablename=,
				 	surveyname=,
				 	outputdir=,
					decimalpoints=,
				 	print=);

%* validation for input parameters;
%if %length(&data) eq 0 %then %do;
	%put ERROR: Please provide name of dataset, data=;
	%abort;
%end;

%if %length(&testvarlist) eq 0 %then %do;
	%put ERROR: Please provide variable name for diagnostic test, testvarlist=;
%abort;
%end;

%if %length(&truthvar) eq 0 %then %do;
	%put ERROR: Please provide variable name for reference test (gold-standard), truthvar=;
%abort;
%end;
/*
%if %length(&truthvarlabel) eq 0 %then %do;
	%put ERROR: Please provide variable label for reference test (gold-standard), truthvarlabel=;
%abort;
%end;


%if %length(&testtypelist) eq 0 %then %do;
	%put ERROR: Please provide variable label(s) for diagnostic test (separated by space), testtypelist=;
%abort;
%end;
*/

%if %length(&testcutvalue) eq 0 %then %do;
	%put ERROR: Please provide cut-off value for diagnostic test variable, testcutvalue=;
%abort;
%end;

%if %length(&testcutvalueunits) eq 0 %then %do;
	%put ERROR: Please provide units of measurements for diagnostic test variable, testcutvalueunits=;
%abort;
%end;

%if %length(&domain) ne 0 and %length(&domainvalue) eq 0 %then %do;
	%put ERROR: Please provide value for &domain variable, domainvalue=;
%abort;
%end;

%if %length(&outputdir) eq 0 %then %do;
	%put ERROR: Please provide output directory/path, outputdir=;
%abort;
%end;

%if %length(&tablename) eq 0 %then %do;
	%put ERROR: Please provide shortname for output table, tablename=;
%abort;
%end;

%if %length(&tabletitle) eq 0 %then %do;
	%put ERROR: Please provide title for output table, tabletitle=;
%abort;
%end;

%if %length(&surveyname) eq 0 %then %do;
	%put ERROR: Please provide survey name abbreviation, surveyname=;
%abort;
%end;

%if %length(&decimalpoints) eq 0 %then %do;
	%let decimalpoints=1;
%end;

%* data preparation - creating respective categories;
%* get number of test variables;
		data _null_;
			i = 0;
			do while (scanq("&testvarlist",i+1) ^= " "); i+1; end;
 			call symput("nvars", trim(left(i)));
		run;

        %* ;
  		%LET xi=1;
  		%LET len=0;
		data __out__; 
			set _null_;
		run;

  		%DO %WHILE(&len < &nvars); * over testvar list;
			%LET len = %EVAL(&len + 1);
			%LET testvar = %SCAN(&testvarlist, &xi, %STR( ));

			data _null_; 
				set &data;
				call symputx("testtypelab", vlabel(&testvar));
			run;

			/*%LET testtype = %SCAN(&testtypelist,&xi, %STR( ));*/
    		%LET testtype = &testtypelab;

			data dprepare;
 				set &data;
  				testvarcat=2-1*(&testvar > &testcutvalue);
  				if &testvar=. then testvarcat=.;

  				truthvarcat=2-1*(&truthvar > &truthcutvalue);
 				if &truthvar=. then truthvarcat=.;
				&condition;
					%if %length(&domain) eq 0 %then %do; 
						domain_all=1;
						%let domain=%str(domain_all);
						%let domainvalue=1;
					%end;
				if &domain=&domainvalue;
 			run;

    		data _TMP3_; 
				set _null_; 
			run;

			%dtest(	data=dprepare,
					testvar=testvarcat,
					testtype=&testtype,
					testcutvalue=&testcutvalue,
					testcutvalueunits=&testcutvalueunits,
					truthvar=truthvarcat,
					truthcutvalue=&truthcutvalue,
					truthcutvalueunits=&truthcutvalueunits,
					domain=&domainvalue);

 			data __out__;
 				set __out__ _TMP3_;
 			run;

 			%put i = &xi len = &len nvar = &nvars variable= &testvar;
    		%LET xi   = %EVAL(&xi + 1);
 		%END;
 	
%if %upcase(&print) = NO %then %do; ods exclude all; %end;
%else  %do; ods exclude none; %end;

%* define report template;
proc template;
	define style DIAG;
		parent = styles.printer;
		replace fonts /
			"titlefont2" = ("Times New Roman", 11pt, Bold)
			"titlefont" = ("Times New Roman", 12pt, Bold)
			"strongfont" = ("Times New Roman", 10pt, Bold)
			"emphasisfont" = ("Times New Roman", 10pt, Bold)
			"fixedemphasisfont" = ("Times New Roman", 10pt, Bold)
			"fixedstrongfont" = ("Times New Roman", 10pt, Bold)
			"fixedheadingfont" = ("Times New Roman", 10pt, Bold)
			"batchfixedfont" = ("Times New Roman", 10pt, Bold)
			"fixedfont" = ("Times New Roman", 10pt, Bold)
			"headingemphasisfont" = ("Times New Roman", 10pt, Bold)
			"headingfont" = ("Times New Roman", 10pt, Bold)
			"docfont" = ("Times New Roman", 10pt);
	end; 
run;

%* suppress macro options;
option nomprint nosymbolgen nomlogic nodate nonumber;

%* generate output table in MS Word and Excel using defined template;
ods escapechar = "^";

ods rtf file="&outputdir\&tablename..rtf" style=DIAG;
ods tagsets.ExcelXP file="&outputdir\&tablename..xls" style=DIAG;
ods tagsets.ExcelXP options(sheet_label="&tablename" suppress_bylines="yes" embedded_titles="yes");

title "&tabletitle" " (&surveyname study)";
footnote height=8pt j=l "(Dated: &sysdate)" j=c "{\b\ Page }{\field{\*\fldinst {\b\i PAGE}}}" j=r "&surveyname";

options papersize = A4 orientation = portrait;

data _null_; 
	set &data;
	call symputx("truthvarlab", vlabel(&truthvar));
run;

%LET truthvarlabel = &truthvarlab;


%* prepare output;;
proc report data=__out__  headline spacing=1 split = "*" nowd;
        column ("Diagnostic test(s)" testtype test_r) ("Reference test (&truthvarlabel)" cnt1 cnt2 tot) ("Diagnostic accuracy measures" measrgree stat);
        define testtype / order descending width = 20 right "Test category" flow;
		define test_r / display width = 20 right "Test result" flow;
		define cnt1 / display width=10 center ">=&truthcutvalue" flow;
		define cnt2 / display width=10 center "<&truthcutvalue" flow;
        define tot / display width=20 center "Total" flow;
		define measrgree / display width=20 right "Measure" flow;
        define stat / display width=20 center "Estimate (95% CI)" flow;
		break after testtype/skip ;
run;

footnote;
title;
ods tagsets.excelxp close;
ods rtf close;

ods exclude none;

quit;
%mend diag_test;

%* a sub-macro to produce data of test and true results;
%macro dtest(	data=,
				testvar=,
				testtype=,
				testcutvalue=,
				testcutvalueunits=,
				truthvar=,
				truthcutvalue=,
				truthcutvalueunits=,
				domain=);

*take care of missing values;
data _tmp1_; 
	set &data; 
	if &testvar ^in (1,2) or &truthvar ^in (1,2) then delete;
run;

data _tmp1_; 
	set _tmp1_;
	if &testvar in(1,2) or &truthvar in(1,2);
run;

proc freq order=internal; 
	tables &testvar*&truthvar/noprint sparse out=_out_;
run;

* sort the a b c d n values;
data _tmp2_; 
	set _out_;    
	idx=1; 
	proc sort; by idx; 
run;    

data _tmp2_; 
	set _tmp2_; 
	by idx; 
	keep n a b c d n1 n2 m1 m2;
	if first.idx then do;      
		a=0; 
		b=0; 
		c=0; 
		d=0;      
		retain a b c d n1 n2 m1 m2;    
end;

	if &testvar=1 and &truthvar=1 then a=count;
	if &testvar=1 and &truthvar=2 then b=count;
	if &testvar=2 and &truthvar=1 then c=count;
	if &testvar=2 and &truthvar=2 then d=count;
		n1=a+b;
		n2=c+d;
		m1=a+c;
		m2=b+d;
		n=a+b+c+d;
	if last.idx then output; 
run;

data _tmp3_; 
	set _tmp2_;
	length measrgree $200 testtype $50;
	label measrgree = "Measures of agreement";
	do i=1 to 14;
		if i=1 then do;
	 		measrgree="Sensitivity (%)";
			test_r=">=&testcutvalue &testcutvalueunits"; 
			testtype="&testtype";
			sn=a/(a+c);

			* standard error;
			sn_se=sqrt(sn*(1-sn)/m1);

			* upper limit;    
			sn_ucl=sn+(1.96*sn_se); 

			* lower limit;    
			sn_lcl=sn-(1.96*sn_se); 

			* 95% CI;
			stat=put(100*sn,f5.&decimalpoints.)||" ("||trim(left(put(100*sn_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*sn_ucl,5.&decimalpoints.)))||")";
			cnt1 = put(a,f4.0);
			cnt2 = put(b,f4.0);
			tot  = put(a + b,f4.0);
		end;
		if i=2 then do;
	 		measrgree="Specificity (%)";
			test_r="";
			*testtype="";
			sp=d/(b+d);

			* standard error;
			sp_se=sqrt(sp*(1-sp)/m2);

			* upper limit;    
			sp_ucl=sp+(1.96*sp_se); 

			* lower limit;    
			sp_lcl=sp-(1.96*sp_se); 

			* 95% CI;
			stat=put(100*sp,f5.&decimalpoints.)||" ("||trim(left(put(100*sp_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*sp_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=3 then do;
	 		measrgree="Positive Predictive Value (PPV) (%)";
			test_r="<&testcutvalue &testcutvalueunits"; 
			*testtype="";
			ppv=a/(a+b);
			* standard error;
			ppv_se=sqrt(ppv*(1-ppv)/n1);

			* upper limit;    
			ppv_ucl=ppv+(1.96*ppv_se); 

			* lower limit;    
			ppv_lcl=ppv-(1.96*ppv_se); 

			* 95% CI;
			stat=put(100*ppv,f5.&decimalpoints.)||" ("||trim(left(put(100*ppv_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*ppv_ucl,5.&decimalpoints.)))||")";
			cnt1 = put(c,f4.0);
			cnt2 = put(d,f4.0);
			tot  = put(c + d,f4.0);
		end;
		if i=4 then do;
	 		measrgree="Negative Predictive Value (NPV) (%)";
	    	test_r="";
	  		*testtype="";
	        npv=d/(c+d);
			* standard error;
			npv_se=sqrt(npv*(1-npv)/n2);

			* upper limit;    
			npv_ucl=npv+(1.96*npv_se); 

			* lower limit;    
			npv_lcl=npv-(1.96*npv_se); 

			* 95% CI;
			stat=put(100*npv,f5.&decimalpoints.)||" ("||trim(left(put(100*npv_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*npv_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=5 then do;
	 		measrgree="Upward Misclassification (%)";
			test_r="Total"; 
		  	sp=d/(b+d);
			umiss=1-sp;
			umiss_se=sqrt(umiss*(1-umiss)/m2);

			* upper limit;    
			umiss_ucl=umiss+(1.96*umiss_se); 

			* lower limit;    
			umiss_lcl=umiss-(1.96*umiss_se); 

			* 95% CI;
			stat=put(100*umiss,f5.&decimalpoints.)||" ("||trim(left(put(100*umiss_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*umiss_ucl,5.&decimalpoints.)))||")";
			cnt1 = put(a + c,f4.0);
			cnt2 = put(b + d,f4.0);
			tot  = put(a + b + c + d,f4.0);
		end;
		if i=6 then do;
	 		measrgree="Downward Misclassification (%)";
			test_r="";
		 	sn=a/(a+c);
			dmiss=1-sn;
			dmiss_se=sqrt(dmiss*(1-dmiss)/m1);

			* upper limit;    
			dmiss_ucl=dmiss+(1.96*dmiss_se); 

			* lower limit;    
			dmiss_lcl=dmiss-(1.96*dmiss_se); 

			* 95% CI;
			stat=put(100*dmiss,f5.&decimalpoints.)||" ("||trim(left(put(100*dmiss_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*dmiss_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=7 then do;
	 		measrgree="Kappa Agreement";
			test_r="";
			ac=a;
	        bd=b;
	        * agreements;
			po = (a+d)/n ;
			pe = ((a+c)*(a+b)+(b+d)*(c+d))/n**2 ;
			ppos = (2*a)/(n+a-d) ;
			pneg = (2*d)/(n-a+d) ;

	        * the kappa statistic and its asymptotic standard error (fleiss, 2003);
	       	kappa = (po-pe)/(1-pe) ;
			q = ((a/n)*(1-(((a+b)/n)+((a+c)/n))*(1-kappa))**2)+((d/n)*
				(1-(((c+d)/n)+((b+d)/n))*(1-kappa))**2);
			r = ((1-kappa)**2)*((b/n)*(((a+c)/n)+((c+d)/n))**2+(c/n)*
				(((b+d)/n)+((a+b)/n))**2) ;
			s = (kappa - pe*(1-kappa))**2 ;
			* asymptotic standard error ;
			se_kappa = sqrt((q+r-s)/(n*(1-pe)**2)) ;
			ll_95_ci = kappa-1.96*se_kappa ;
			if ll_95_ci < -1.00 then ll_95_ci = -1.00 ;
			ul_95_ci = kappa+1.96*se_kappa ;
			if ul_95_ci > 1 then ul_95_ci = 1.00 ;
	        z = kappa/se_kappa;
			* p = 1 - cdf('normal',z,0,1) ;
			stat=put(kappa,f5.&decimalpoints.)||" ("||trim(left(put(ll_95_ci,5.&decimalpoints.)))||" - "||trim(left(put(ul_95_ci,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=8 then do;
	 		measrgree="Positive Likelihood Ratio (LR+)";
			test_r=" ";
			*testtype="";
			sn=a/(a+c);
			sp=d/(b+d);
	        lr_plus=sn/(1-sp);

			* standard error;
			lr_plus_se=sqrt((1/a)-(1/m1)+(1/b)-(1/m2));

			* upper limit;    
			lr_plus_ucl=exp(log(lr_plus)+(1.96*lr_plus_se)); 

			* lower limit;    
			lr_plus_lcl=exp(log(lr_plus)-(1.96*lr_plus_se)); 

			* 95% CI;
			stat=put(lr_plus,f5.&decimalpoints.)||" ("||trim(left(put(lr_plus_lcl,5.&decimalpoints.)))||" - "||trim(left(put(lr_plus_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=9 then do;
	 		measrgree="Negative Likelihood Ratio (LR-)";
			test_r="";
			*testtype="";
			sn=a/(a+c);
			sp=d/(b+d);
	        lr_minus=(1-sn)/sp;

			* standard error;
			lr_minus_se=sqrt((1/c)-(1/m1)+(1/d)-(1/m2));

			* upper limit;    
			lr_minus_ucl=exp(log(lr_minus)+(1.96*lr_minus_se)); 

			* lower limit;    
			lr_minus_lcl=exp(log(lr_minus)-(1.96*lr_minus_se)); 

			* 95% CI;
			stat=put(lr_minus,f5.&decimalpoints.)||" ("||trim(left(put(lr_minus_lcl,5.&decimalpoints.)))||" - "||trim(left(put(lr_minus_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=10 then do;
	 		measrgree="Diagnostic Accuracy (%)";
			test_r="";
			*testtype="";
			acc=(a+d)/(a+b+c+d);

			* standard error;
			acc_se=sqrt(acc*(1-acc)/n);

			* upper limit;    
			acc_ucl=acc+(1.96*acc_se); 

			* lower limit;    
			acc_lcl=acc-(1.96*acc_se); 

			* 95% CI;
			stat=put(100*acc,f5.&decimalpoints.)||" ("||trim(left(put(100*acc_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*acc_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=11 then do;
	 		measrgree="Disease Prevalence (%)";
			test_r="";
			*testtype="";
			prev=(a+c)/(a+b+c+d);

			* standard error;
			prev_se=sqrt(prev*(1-prev)/n);

			* upper limit;    
			prev_ucl=prev+(1.96*prev_se); 

			* lower limit;    
			prev_lcl=prev-(1.96*prev_se); 

			* 95% CI;
			stat=put(100*prev,f5.&decimalpoints.)||" ("||trim(left(put(100*prev_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*prev_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=12 then do;
	 		measrgree="Diagnostic Odds Ratio (DOR)";
			test_r="";
			*testtype="";
			dor=(a/c)/(b/d);

			* standard error;
			dor_se=sqrt((1/a)+(1/b)+(1/c)+(1/d));

			* upper limit;    
			dor_ucl=exp(log(dor)+(1.96*dor_se)); 

			* lower limit;    
			dor_lcl=exp(log(dor)-(1.96*dor_se)); 

			* 95% CI;
			stat=put(dor,f5.&decimalpoints.)||" ("||trim(left(put(dor_lcl,5.&decimalpoints.)))||" - "||trim(left(put(dor_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=13 then do;
	 		measrgree="Youden's Index";
			test_r="";
			*testtype="";
			sn=a/(a+c);
			sp=d/(b+d);
			yo=sn+sp-1;

			* standard error;
			yo_se=sqrt(yo*(1-yo)/n);

			* upper limit;    
			yo_ucl=yo+(1.96*yo_se); 

			* lower limit;    
			yo_lcl=yo-(1.96*yo_se); 

			* 95% CI;
			stat=put(yo,f5.&decimalpoints.)||" ("||trim(left(put(yo_lcl,5.&decimalpoints.)))||" - "||trim(left(put(yo_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=14 then do; * do nothing - skip line;
			measrgree="";
			test_r="";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
			stat ="";
		end;
	  output;
	 end;
	 label 	cnt1=">= &truthcutvalue copies/ml" 
			cnt2="< &truthcutvalue copies/ml" 
			test_r="Test result" 
			tot="Total"  
			Stat="%(95% CI)" 
			testtype="Test type";   
 run;
%mend dtest;
