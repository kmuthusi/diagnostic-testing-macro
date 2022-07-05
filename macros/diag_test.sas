**************************************************************************
**************************************************************************
** FILENAME     : diag_test.sas                                         **
**                                                                      **
** DESCRIPTION	: Calculates diagnostic accuracy measures i.e.,			**
** 				sensitivity, spececificity, positive predictive 			**
** 				values (PPN), negative predictive values (NPV), 		**
** 				positive likelihood ratio (LR+), negative likelihood  	**
** 				ratio (LR-), diagnostic accuracy, disease,				**
** 				prevalence and diagnostic odds ratio (DOR) and			**
** 				prepares publication-quality output						**
**                                                                      **
** AUTHOR       : Jacques Muthusi                          				**
**                                                                      **
** DATE			: 10FEB2022												**
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

%*  macro to do error check then stop SAS from continuing to process;
%* the rest of the submitted statements if error is present;

%macro runquit;
	; run; quit;
	%if &syserr. ne 0 %then %do;
	%abort cancel;
	%end;
%mend runquit;

%macro diag_test(	data=,
					testvarlist=,
					testcutvalue=, 
					truthvar=,
					truthcutvalue=,
					domain=,
					domainvalue=,
					condition=,
				 	tabletitle=,
				 	tablename=,
				 	surveyname=,
				 	outputdir=,
					decimalpoints=,
					alpha=0.05,
					missvaluelabel=.,
				 	print=);

%* validation for input parameters;
%if %length(&data) eq 0 %then %do;
	%put ERROR: Please provide name of dataset, data=;
	%runquit;
%end;

%if %length(&testvarlist) eq 0 %then %do;
	%put ERROR: Please provide variable name(s) for diagnostic test, testvarlist=;
%runquit;
%end;

%if %length(&testcutvalue) eq 0 %then %do;
	%put ERROR: Please provide cut-off value for diagnostic test variable, testcutvalue=;
%runquit;
%end;

%if %length(&truthvar) eq 0 %then %do;
	%put ERROR: Please provide variable name for reference test, truthvar=;
%runquit;
%end;

%if %length(&truthcutvalue) eq 0 %then %do;
	%put ERROR: Please provide cut-off value for reference test variable, truthcutvalue=;
%runquit;
%end;

%if %length(&domain) ne 0 and %length(&domainvalue) eq 0 %then %do;
	%put ERROR: Please provide value for &domain analysis variable, domainvalue=;
%runquit;
%end;

%if %length(&outputdir) eq 0 %then %do;
	%put ERROR: Please provide output directory/path, outputdir=;
%runquit;
%end;

%if %length(&tablename) eq 0 %then %do;
	%put ERROR: Please provide shortname for output table, tablename=;
%runquit;
%end;

%if %length(&tabletitle) eq 0 %then %do;
	%put ERROR: Please provide title for output table, tabletitle=;
%runquit;
%end;

%if %length(&surveyname) eq 0 %then %do;
	%put ERROR: Please provide survey name abbreviation, surveyname=;
%runquit;
%end;

%if %length(&decimalpoints) eq 0 %then %do;
	%let decimalpoints=2;
%end;

%* get number of diagnostic test variables;
	data _null_;
		i = 0;
		do while (scanq("&testvarlist",i+1) ^= " "); i+1; end;
 		call symput("nvars", trim(left(i)));
	run;

    %* ;
  	%let xi=1;
  	%let len=0;
	data __out__; 
		set _null_;
	run;

%* over testvar list;
  	%do %while(&len < &nvars); 
		%let len = %eval(&len + 1);
		%let testvar = %scan(&testvarlist, &xi, %str( ));

%* get test variable label;
		data _null_; 
			set &data;
			call symputx("testtypelab", vlabel(&testvar));
		run;

    	%let testtype = &testtypelab;

%* create binary version of test variable based on test variable cutoff value;
		data dprepare;
 			set &data;
  			testvarcat=2-1*(&testvar > &testcutvalue);
  			if &testvar=&missvaluelabel. then testvarcat=&missvaluelabel.;

  			truthvarcat=2-1*(&truthvar > &truthcutvalue);
 			if &truthvar=&missvaluelabel. then truthvarcat=&missvaluelabel.;
		run;

    	data _TMP3_; 
			set _null_; 
		run;

		%dtest(	data=dprepare,
				testvar=testvarcat,
				testtype=&testtype,
				testcutvalue=&testcutvalue,
				truthvar=truthvarcat,
				truthcutvalue=&truthcutvalue,
				domain=&domain,
				domainvalue=&domainvalue);

 		data __out__;
 			set __out__ _TMP3_;
 		run;

 		%put i = &xi len = &len nvar = &nvars variable= &testvar;
    	%let xi = %eval(&xi + 1);
 	%end;
 
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

%* get truth variable label;
data _null_; 
	set &data;
	call symputx("truthvarlab", vlabel(&truthvar));
	ci=(1-&alpha)*100;
	call symput("nci",trim(left(ci)));
run;

%LET truthvarlabel = &truthvarlab;

%* prepare output;;
proc report data=__out__  headline spacing=1 split = "*" nowd;
        column ("Diagnostic test(s)" testtype test_r) ("Reference test (&truthvarlabel)" cnt1 cnt2 tot) ("Diagnostic accuracy measures" measrgree stat);
        define testtype / order descending width = 25 right "Test category" flow;
		define test_r / display width = 10 right "Test result" flow;
		define cnt1 / display width=10 center ">=&truthcutvalue" flow;
		define cnt2 / display width=10 center "<&truthcutvalue" flow;
        define tot / display width=10 center "Total" flow;
		define measrgree / display width=30 right "Measure" flow;
        define stat / display width=20 center "Estimate (&nci % CI)" flow;
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
				truthvar=,
				truthcutvalue=,
				domain=,
				domainvalue=);

%* take care of missing values;
data _tmp1_; 
	set &data; 
	if &testvar ^in (1,2) or &truthvar ^in (1,2) then delete;
	%if %length(&domain) eq 0 %then %do; 
		domain_all=1;
		%let domain=%str(domain_all);
		%let domainvalue=1;
	%end;
	if &domain=&domainvalue;
	&condition;
run;

data _tmp1_; 
	set _tmp1_;
	if &testvar in(1,2) or &truthvar in(1,2);
run;

proc freq order=internal; 
	tables &testvar*&truthvar/noprint sparse out=_out_;
run;

%* sort the a b c d n values;
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
	length measrgree $100 testtype $50;
	label measrgree = "Measures of agreement";
	do i=1 to 17;
		if i=1 then do;
	 		measrgree="Sensitivity (%)";
			test_r=">=&testcutvalue"; 
			testtype="&testtype";
			sens=a/(a+c);
			n=a+c;

			%* confidence intervals;
			%* upper limit;    
			sens_ucl=(sens + quantile('NORMAL', (1-&alpha/2))**2/(2*n) + quantile('NORMAL', (1-&alpha/2))*sqrt((sens*(1-sens)/n) + quantile('NORMAL', (1-&alpha/2))**2/(4*n**2))) / (1 + quantile('NORMAL', (1-&alpha/2))**2/n); 

			%* lower limit;    
			sens_lcl=(sens + (-quantile('NORMAL', (1-&alpha/2)))**2/(2*n) + (-quantile('NORMAL', (1-&alpha/2)))*sqrt((sens*(1-sens)/n) + (-quantile('NORMAL', (1-&alpha/2)))**2/(4*n**2))) / (1 + (-quantile('NORMAL', (1-&alpha/2)))**2/n); 

			%* interval;
			stat=put(100*sens,f5.&decimalpoints.)||" ("||trim(left(put(100*sens_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*sens_ucl,5.&decimalpoints.)))||")";
			cnt1 = put(a,f4.0);
			cnt2 = put(b,f4.0);
			tot  = put(a + b,f4.0);
		end;
		if i=2 then do;
	 		measrgree="Specificity (%)";
			test_r="";
			spec=d/(b+d);
			n=b+d;

			%* confidence intervals;
			%* upper limit;    
			spec_ucl=(spec + quantile('NORMAL', (1-&alpha/2))**2/(2*n) + quantile('NORMAL', (1-&alpha/2))*sqrt((spec*(1-spec)/n) + quantile('NORMAL', (1-&alpha/2))**2/(4*n**2))) / (1 + quantile('NORMAL', (1-&alpha/2))**2/n); 

			%* lower limit;    
			spec_lcl=(spec + (-quantile('NORMAL', (1-&alpha/2)))**2/(2*n) + (-quantile('NORMAL', (1-&alpha/2)))*sqrt((spec*(1-spec)/n) + (-quantile('NORMAL', (1-&alpha/2)))**2/(4*n**2))) / (1 + (-quantile('NORMAL', (1-&alpha/2)))**2/n); 

			%* interval;
			stat=put(100*spec,f5.&decimalpoints.)||" ("||trim(left(put(100*spec_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*spec_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=3 then do;
	 		measrgree="Positive Predictive Value (PPV) (%)";
			test_r="<&testcutvalue"; 
			ppv=a/(a+b);
			n=a+b;

			%* confidence intervals;
			%* upper limit;    
			ppv_ucl=(ppv + quantile('NORMAL', (1-&alpha/2))**2/(2*n) + quantile('NORMAL', (1-&alpha/2))*sqrt((ppv*(1-ppv)/n) + quantile('NORMAL', (1-&alpha/2))**2/(4*n**2))) / (1 + quantile('NORMAL', (1-&alpha/2))**2/n); 

			%* lower limit;    
			ppv_lcl=(ppv + (-quantile('NORMAL', (1-&alpha/2)))**2/(2*n) + (-quantile('NORMAL', (1-&alpha/2)))*sqrt((ppv*(1-ppv)/n) + (-quantile('NORMAL', (1-&alpha/2)))**2/(4*n**2))) / (1 + (-quantile('NORMAL', (1-&alpha/2)))**2/n); 

			%* interval;
			stat=put(100*ppv,f5.&decimalpoints.)||" ("||trim(left(put(100*ppv_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*ppv_ucl,5.&decimalpoints.)))||")";
			cnt1 = put(c,f4.0);
			cnt2 = put(d,f4.0);
			tot  = put(c + d,f4.0);
		end;
		if i=4 then do;
	 		measrgree="Negative Predictive Value (NPV) (%)";
	    	test_r="";
	        npv=d/(c+d);
			n=c+d;

			%* 95% confidence intervals;
			%* upper limit;    
			npv_ucl=(npv + quantile('NORMAL', (1-&alpha/2))**2/(2*n) + quantile('NORMAL', (1-&alpha/2))*sqrt((npv*(1-npv)/n) + quantile('NORMAL', (1-&alpha/2))**2/(4*n**2))) / (1 + quantile('NORMAL', (1-&alpha/2))**2/n); 

			%* lower limit;    
			npv_lcl=(npv + (-quantile('NORMAL', (1-&alpha/2)))**2/(2*n) + (-quantile('NORMAL', (1-&alpha/2)))*sqrt((npv*(1-npv)/n) + (-quantile('NORMAL', (1-&alpha/2)))**2/(4*n**2))) / (1 + (-quantile('NORMAL', (1-&alpha/2)))**2/n); 

			%* interval;
			stat=put(100*npv,f5.&decimalpoints.)||" ("||trim(left(put(100*npv_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*npv_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=5 then do;
	 		measrgree="Upward Misclassification (%)";
			test_r="Total"; 
		  	spec=d/(b+d);
			umiss=1-spec;
			n=b+d;

			%* 95% confidence intervals;
			%* upper limit;    
			umiss_ucl=(umiss + quantile('NORMAL', (1-&alpha/2))**2/(2*n) + quantile('NORMAL', (1-&alpha/2))*sqrt((umiss*(1-umiss)/n) + quantile('NORMAL', (1-&alpha/2))**2/(4*n**2))) / (1 + quantile('NORMAL', (1-&alpha/2))**2/n); 

			%* lower limit;    
			umiss_lcl=(umiss + (-quantile('NORMAL', (1-&alpha/2)))**2/(2*n) + (-quantile('NORMAL', (1-&alpha/2)))*sqrt((umiss*(1-umiss)/n) + (-quantile('NORMAL', (1-&alpha/2)))**2/(4*n**2))) / (1 + (-quantile('NORMAL', (1-&alpha/2)))**2/n); 

			%* interval;
			stat=put(100*umiss,f5.&decimalpoints.)||" ("||trim(left(put(100*umiss_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*umiss_ucl,5.&decimalpoints.)))||")";
			cnt1 = put(a + c,f4.0);
			cnt2 = put(b + d,f4.0);
			tot  = put(a + b + c + d,f4.0);
		end;
		if i=6 then do;
	 		measrgree="Downward Misclassification (%)";
			test_r="";
		 	sens=a/(a+c);
			dmiss=1-sens;
			n=a+c;

			%* 95% confidence intervals;
			%* upper limit;    
			dmiss_ucl=(dmiss + quantile('NORMAL', (1-&alpha/2))**2/(2*n) + quantile('NORMAL', (1-&alpha/2))*sqrt((dmiss*(1-dmiss)/n) + quantile('NORMAL', (1-&alpha/2))**2/(4*n**2))) / (1 + quantile('NORMAL', (1-&alpha/2))**2/n); 

			%* lower limit;    
			dmiss_lcl=(dmiss + (-quantile('NORMAL', (1-&alpha/2)))**2/(2*n) + (-quantile('NORMAL', (1-&alpha/2)))*sqrt((dmiss*(1-dmiss)/n) + (-quantile('NORMAL', (1-&alpha/2)))**2/(4*n**2))) / (1 + (-quantile('NORMAL', (1-&alpha/2)))**2/n); 

			%* interval;
			stat=put(100*dmiss,f5.&decimalpoints.)||" ("||trim(left(put(100*dmiss_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*dmiss_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=7 then do;
	 		measrgree="False Omission Rate (FOR) (%)";
			test_r=""; 
		  	npv=d/(c+d);
			fo_rate=1-npv;
			n=c+d;

			%* upper limit;    
			fo_rate_ucl=(fo_rate + quantile('NORMAL', (1-&alpha/2))**2/(2*n) + quantile('NORMAL', (1-&alpha/2))*sqrt((fo_rate*(1-fo_rate)/n) + quantile('NORMAL', (1-&alpha/2))**2/(4*n**2))) / (1 + quantile('NORMAL', (1-&alpha/2))**2/n); 

			%* lower limit;    
			fo_rate_lcl=(fo_rate + (-quantile('NORMAL', (1-&alpha/2)))**2/(2*n) + (-quantile('NORMAL', (1-&alpha/2)))*sqrt((fo_rate*(1-fo_rate)/n) + (-quantile('NORMAL', (1-&alpha/2)))**2/(4*n**2))) / (1 + (-quantile('NORMAL', (1-&alpha/2)))**2/n); 

			%* interval;
			stat=put(100*fo_rate,f5.&decimalpoints.)||" ("||trim(left(put(100*fo_rate_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*fo_rate_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=8 then do;
	 		measrgree="False Discovery Rate (FDR) (%)";
			test_r="";
		 	ppv=a/(a+b);
			fd_rate=1-ppv;
			n=a+b;

			%* upper limit;    
			fd_rate_ucl=(fd_rate + quantile('NORMAL', (1-&alpha/2))**2/(2*n) + quantile('NORMAL', (1-&alpha/2))*sqrt((fd_rate*(1-fd_rate)/n) + quantile('NORMAL', (1-&alpha/2))**2/(4*n**2))) / (1 + quantile('NORMAL', (1-&alpha/2))**2/n); 

			%* lower limit;    
			fd_rate_lcl=(fd_rate + (-quantile('NORMAL', (1-&alpha/2)))**2/(2*n) + (-quantile('NORMAL', (1-&alpha/2)))*sqrt((fd_rate*(1-fd_rate)/n) + (-quantile('NORMAL', (1-&alpha/2)))**2/(4*n**2))) / (1 + (-quantile('NORMAL', (1-&alpha/2)))**2/n); 

			%* interval;
			stat=put(100*fd_rate,f5.&decimalpoints.)||" ("||trim(left(put(100*fd_rate_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*fd_rate_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=9 then do;
	 		measrgree="Positive Likelihood Ratio (LR+)";
			test_r=" ";
			sens=a/(a+c);
			spec=d/(b+d);
	        lr_pos=sens/(1-spec);

			%if (a != 0 & b != 0) %then %do;
				%* standard error;
				lr_pos_var=(1/a)-(1/m1)+(1/b)-(1/m2);

				%* upper limit;    
				lr_pos_ucl=lr_pos*exp(quantile('NORMAL', (1-&alpha/2))*sqrt(lr_pos_var)); 

				%* lower limit;    
				lr_pos_lcl=lr_pos*exp(-quantile('NORMAL', (1-&alpha/2))*sqrt(lr_pos_var)); 

			%end;

			%else %if (a = 0 & b = 0) %then %do;
			    lr_pos_lcl = 0;
			    lr_pos_ucl = Inf;
			%end;

			%else %if (a = 0 & b != 0) %then %do;
			    a_temp = (1/2);
			    spec_temp = d/(b+d);
			    sens_temp = a_temp/(a+c);
			    lr_pos_temp = sens_temp/(1 - spec_temp);
			    lr_pos_lcl = 0;
			    lr_pos_var =(1/a_temp)-(1/(a_temp+c))+(1/b)-(1/(b+d));
			    lr_pos_ucl = lr_pos_temp*exp(quantile('NORMAL', (1-&alpha/2))*sqrt(lr_pos_var));
			%end;
			%else %if (a != 0 & b = 0) %then %do;
			    b_temp = (1/2);
			    spec_temp = d/(b_temp+d);
			    sens_temp = a/(a+c);
			    lr_pos_temp = sens_temp/(1 - spec_temp); 
			    lr_pos_var = (1/a) - (1/(a+c)) + (1/b_temp) - (1/(b_temp+d));
			    lr_pos_lcl = lr_pos_temp*exp(-quantile('NORMAL', (1-&alpha/2))*sqrt(lr_pos_var));
			    lr_pos_ucl = Inf;
			%end;
			%else %do;
			    a_temp = a - (1/2);
			    b_temp = b - (1/2);

			    spec_temp = d/(b_temp+d);
			    sens_temp = a_temp/(a+c);
			    lr_pos_temp = sens_temp/(1 - spec_temp); 
			    lr_pos_var = (1/a_temp) - (1/(a_temp+c)) + (1/b_temp) - (1/(b_temp+d));
			    lr_pos_lcl = lr_pos_temp*exp(-quantile('NORMAL', (1-&alpha/2))*sqrt(lr_pos_var));
			    lr_pos_ucl = lr_pos_temp*exp(quantile('NORMAL', (1-&alpha/2))*sqrt(lr_pos_var)); 
			%end;

			%* interval;
			stat=put(lr_pos,f5.&decimalpoints.)||" ("||trim(left(put(lr_pos_lcl,5.&decimalpoints.)))||" - "||trim(left(put(lr_pos_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=10 then do;
	 		measrgree="Negative Likelihood Ratio (LR-)";
			test_r="";
			sens=a/(a+c);
			spec=d/(b+d);
	        lr_neg=(1-sens)/spec;

			%if ( c != 0 & d != 0 ) %then %do;
				%* standard error;
				lr_neg_var=(1/c)-(1/m1)+(1/d)-(1/m2);

				%* upper limit;    
				lr_neg_ucl=lr.neg*exp(quantile('NORMAL', (1-&alpha/2))*sqrt(lr_neg_var)); 

				%* lower limit;    
				lr_neg_lcl=lr_neg*exp(-quantile('NORMAL', (1-&alpha/2))*sqrt(lr_neg_var)); 
			%end;
			%else %if (c = 0 & d = 0) %then %do;
				lr_neg_lcl = 0;
   				lr_neg_ucl = Inf;
			%end;

			%else %if (c = 0 & d != 0) %then %do;
				c_temp = (1/2);
			    spec_temp = d/(b+d);
			    sens_temp = a/(a+c_temp);
			    lr_neg_temp = (1 - sens_temp)/spec_temp ;   
			    lr_neg_lcl = 0;
			    lr_neg_var = (1/c_temp) - (1/(a+c)) + (1/d) - (1/(b+d));
			    lr_neg_ucl = lr_neg_temp * exp(quantile('NORMAL', (1-&alpha/2))*sqrt(lr_neg_var));
			%end;

			%else %if (c != 0 & d = 0) %then %do;
				d_temp = (1/2);
			    spec_temp = d_temp/(b+d);
			    sens_temp = a/(a+c);
			    lr_neg_temp = (1 - sens_temp)/spec_temp;
			    lr_neg_var = (1/c) - (1/(a+c)) + (1/d_temp) - (1/(b+d));
			    lr_neg_lcl = lr_neg_temp * exp(-quantile('NORMAL', (1-&alpha/2))*sqrt(lr_neg_var));
			    lr_neg_ucl = Inf;
			%end;

			%else %do;
			    c_temp = c - (1/2);
			    d_temp = d - (1/2);
			    spec_temp = d_temp/(b+d);
			    sens_temp = a/(a+c_temp);
			    lr_neg_temp = (1 - sens_temp)/spec_temp;  
			    lr_neg_var = (1/c_temp) - (1/(a+c)) + (1/d_temp) - (1/(b+d));
			    lr_neg_lcl = lr_neg_temp * exp(-quantile('NORMAL', (1-&alpha/2))*sqrt(lr_neg_var));
			    lr_neg_ucl = lr_neg_temp * exp(quantile('NORMAL', (1-&alpha/2))*sqrt(lr_neg_var));
			%end;

			%* interval;
			stat=put(lr_neg,f5.&decimalpoints.)||" ("||trim(left(put(lr_neg_lcl,5.&decimalpoints.)))||" - "||trim(left(put(lr_neg_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=11 then do;
	 		measrgree="Diagnostic Accuracy (%)";
			test_r="";
			acc=(a+d)/(a+b+c+d);
			n=a+b+c+d;

			%* upper limit;    
			acc_ucl=(acc + quantile('NORMAL', (1-&alpha/2))**2/(2*n) + quantile('NORMAL', (1-&alpha/2))*sqrt((acc*(1-acc)/n) + quantile('NORMAL', (1-&alpha/2))**2/(4*n**2))) / (1 + quantile('NORMAL', (1-&alpha/2))**2/n); 

			%* lower limit;    
			acc_lcl=(acc + (-quantile('NORMAL', (1-&alpha/2)))**2/(2*n) + (-quantile('NORMAL', (1-&alpha/2)))*sqrt((acc*(1-acc)/n) + (-quantile('NORMAL', (1-&alpha/2)))**2/(4*n**2))) / (1 + (-quantile('NORMAL', (1-&alpha/2)))**2/n); 

			%* interval;
			stat=put(100*acc,f5.&decimalpoints.)||" ("||trim(left(put(100*acc_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*acc_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=12 then do;
	 		measrgree="Disease Prevalence (%)";
			test_r="";
			prev=(a+c)/(a+b+c+d);
			n=a+b+c+d;

			%* upper limit;    
			prev_ucl=(prev + quantile('NORMAL', (1-&alpha/2))**2/(2*n) + quantile('NORMAL', (1-&alpha/2))*sqrt((prev*(1-prev)/n) + quantile('NORMAL', (1-&alpha/2))**2/(4*n**2))) / (1 + quantile('NORMAL', (1-&alpha/2))**2/n); 

			%* lower limit;    
			prev_lcl=(prev + (-quantile('NORMAL', (1-&alpha/2)))**2/(2*n) + (-quantile('NORMAL', (1-&alpha/2)))*sqrt((prev*(1-prev)/n) + (-quantile('NORMAL', (1-&alpha/2)))**2/(4*n**2))) / (1 + (-quantile('NORMAL', (1-&alpha/2)))**2/n); 

			%* interval;
			stat=put(100*prev,f5.&decimalpoints.)||" ("||trim(left(put(100*prev_lcl,5.&decimalpoints.)))||" - "||trim(left(put(100*prev_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=13 then do;
	 		measrgree="Diagnostic Odds Ratio (DOR)";
			test_r="";
			dor=(a/c)/(b/d);

			%* standard error;
			dor_se=sqrt((1/a)+(1/b)+(1/c)+(1/d));

			%* upper limit;    
			dor_ucl=exp(log(dor)+(quantile('NORMAL', (1-&alpha/2))*dor_se)); 

			%* lower limit;    
			dor_lcl=exp(log(dor)-(quantile('NORMAL', (1-&alpha/2))*dor_se)); 

			%* interval;
			stat=put(dor,f5.&decimalpoints.)||" ("||trim(left(put(dor_lcl,5.&decimalpoints.)))||" - "||trim(left(put(dor_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=14 then do;
	 		measrgree="Kappa Agreement";
			test_r="";

			ac=a;
			bd=b;
			n=a+b+c+d;

			%* agreements;
			po = (a+d)/n ;
			pe = ((a+c)*(a+b)+(b+d)*(c+d))/n**2 ;
			ppos = (2*a)/(n+a-d) ;
			pneg = (2*d)/(n-a+d) ;

	        %* the kappa statistic and its asymptotic standard error (fleiss, 2003);
	       	kappa = (po-pe)/(1-pe) ;
			q = ((a/n)*(1-(((a+b)/n)+((a+c)/n))*(1-kappa))**2)+((d/n)*(1-(((c+d)/n)+((b+d)/n))*(1-kappa))**2);
			r = ((1-kappa)**2)*((b/n)*(((a+c)/n)+((c+d)/n))**2+(c/n)*(((b+d)/n)+((a+b)/n))**2) ;
			s = (kappa - pe*(1-kappa))**2 ;

			%* asymptotic standard error;
			se_kappa = sqrt((q+r-s)/(n*(1-pe)**2));
			kappa_lcl = kappa-quantile('NORMAL', (1-&alpha/2))*se_kappa;
			if kappa_lcl < -1.00 then kappa_lcl = -1.00;
			kappa_ucl = kappa+quantile('NORMAL', (1-&alpha/2))*se_kappa;
			if kappa_ucl > 1 then kappa_ucl = 1.00;
	        z = kappa/se_kappa;

			%* interval;
			stat=put(kappa,f5.&decimalpoints.)||" ("||trim(left(put(kappa_lcl,5.&decimalpoints.)))||" - "||trim(left(put(kappa_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=15 then do;
	 		measrgree="Youden's Index";
			test_r="";
			sn=a/(a+c);
			sp=d/(b+d);
			yo=sn+sp-1;
			n=a+b+c+d;

			%* upper limit;    
			yo_ucl=(yo + quantile('NORMAL', (1-&alpha/2))**2/(2*n) + quantile('NORMAL', (1-&alpha/2))*sqrt((yo*(1-yo)/n) + quantile('NORMAL', (1-&alpha/2))**2/(4*n**2))) / (1 + quantile('NORMAL', (1-&alpha/2))**2/n); 

			%* lower limit;    
			yo_lcl=(yo + (-quantile('NORMAL', (1-&alpha/2)))**2/(2*n) + (-quantile('NORMAL', (1-&alpha/2)))*sqrt((yo*(1-yo)/n) + (-quantile('NORMAL', (1-&alpha/2)))**2/(4*n**2))) / (1 + (-quantile('NORMAL', (1-&alpha/2)))**2/n); 


			%* interval;
			stat=put(yo,f5.&decimalpoints.)||" ("||trim(left(put(yo_lcl,5.&decimalpoints.)))||" - "||trim(left(put(yo_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=16 then do;
	 		measrgree="F-score";
			test_r="";
			f1_score=2*a / ((2*a)+b+c);
			n=a+b+c+d;

			%* upper limit;    
			f1_score_ucl=(f1_score + quantile('NORMAL', (1-&alpha/2))**2/(2*n) + quantile('NORMAL', (1-&alpha/2))*sqrt((f1_score*(1-f1_score)/n) + quantile('NORMAL', (1-&alpha/2))**2/(4*n**2))) / (1 + quantile('NORMAL', (1-&alpha/2))**2/n); 

			%* lower limit;    
			f1_score_lcl=(f1_score + (-quantile('NORMAL', (1-&alpha/2)))**2/(2*n) + (-quantile('NORMAL', (1-&alpha/2)))*sqrt((f1_score*(1-f1_score)/n) + (-quantile('NORMAL', (1-&alpha/2)))**2/(4*n**2))) / (1 + (-quantile('NORMAL', (1-&alpha/2)))**2/n); 

			%* interval;
			stat=put(f1_score,f5.&decimalpoints.)||" ("||trim(left(put(f1_score_lcl,5.&decimalpoints.)))||" - "||trim(left(put(f1_score_ucl,5.&decimalpoints.)))||")";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
		if i=17 then do; * do nothing - skip line;
			measrgree="";
			test_r="";
			stat = "";
			cnt1 = "";
			cnt2 = "";
			tot  = "";
		end;
	  output;
	 end;
	 label 	cnt1=">= &truthcutvalue" 
			cnt2="< &truthcutvalue" 
			test_r="Test result" 
			tot="Total"  
			Stat="%(95% CI)" 
			testtype="Test type";   
 run;
%mend dtest;
