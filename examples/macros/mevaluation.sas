/*******************************************************************************
** FILENAME     : mevaluation.sas                                             
**                                                                            
** AUTHOR       : Jacques Muthusi                          
** DATE			: 28SEP2021
** MODIFIED		:                                                                             
** REFERENCE    :  
**                                                                            
** PLATFORM     : WINDOWS                                                     
** DESCRIPTION  : Calculates diagnostic accuracy measures (sensitivity, specificity, PPN, NPV, LR+, LR-, Accuracy, DOR
** PARAMETERS:
**		data=,
		testvarlist=,
		truthvar=,
		testtypelist=,
		testcutvalue=, 
		testcutvalueunits=,
		truthcutvalue=,
		truthcutvalueunits=,
		domain=,
		domainvalue=,
		outputtitle=
**
**   Assumption:
*******************************************************************************/


%macro mevaluation(	data=,
					testvarlist=,
					truthvar=,
					truthvarlabel=,
					testtypelist=,
					testcutvalue=, 
					testcutvalueunits=,
					truthcutvalue=,
					truthcutvalueunits=,
					domain=,
					domainvalue=,
					condition=,
				 	tabletitle=,
				 	tablename=,
				 	surveyname=,
				 	outputdir=,
				 	print=);

* data preparation - creating respective categories;
		data _null_;
			i = 0;
			do while (scanq("&testvarlist",i+1) ^= ''); i+1; end;
 			call symput('nvars', trim(left(i)));
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
    		%LET testtype = %SCAN(&testtypelist,&xi, %STR( ));

			/*data _null_; 
				set &data (obs=1);
				call symputx('testtype', vlabel(&testvar));
			run;
			*/

			data dprepare;
 				set &data;
  				testvarcat=2-1*(&testvar > &testcutvalue);
  				if &testvar=. then testvarcat=.;

  				truthvarcat=2-1*(&truthvar > &truthcutvalue);
 				if &truthvar=. then truthvarcat=.;
				if &domain=&domainvalue;
				&condition;
 			run;

    		data _TMP3_; 
				set _null_; 
			run;

			%meval(	data=dprepare,
					testvar=testvarcat,
					truthvar=truthvarcat,
					testcutvalue=&testcutvalue,
					testcutvalueunits=&testcutvalueunits,
					truthcutvalue=&truthcutvalue,
					truthcutvalueunits=&truthcutvalueunits,
					testtype=&testtype);

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

%* prepare output;;
proc report data=__out__  headline spacing=1 split = "*" nowd;
        column ("Diagnostic test(s)" testtype test_r) ("Reference test (&truthvarlabel)" cnt1 cnt2 tot) ("Diagnostic accuracy measures" measrgree stat);
        define testtype / order descending width = 20 right "Test category" flow;
		define test_r / display width = 20 right "Test result" flow;
		define cnt1  / display width=10  center ">=&truthcutvalue &truthcutvalueunits" flow;
		define cnt2  / display width=10  center "<&truthcutvalue &truthcutvalueunits" flow;
        define tot / display width=20  left "Total" flow;
		define measrgree / display width=20  left "Measure" flow;
        define stat / display width=20  left "Estimate (95% CI)" flow;
		break after testtype/skip ;
run;

footnote;
title;
ods tagsets.excelxp close;
ods rtf close;

ods exclude none;

quit;
%mend mevaluation;

%* a sub-macro to produce data of test and true results;
%macro meval(	data=,
				testvar=,
				truthvar=,
				testcutvalue=,
				testcutvalueunits=,
				truthcutvalue=,
				truthcutvalueunits=,
				testtype=);

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
length measrgree $200 testtype $20;
label measrgree = "Measures of agreement";
do i=1 to 11;
	if i=1 then do;
 		measrgree="Sensitivity";
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
		stat=put(100*sn,f5.2)||" ("||trim(left(put(100*sn_lcl,5.2)))||" - "||trim(left(put(100*sn_ucl,5.2)))||")";
		cnt1 = put(a,f4.0);
		cnt2 = put(b,f4.0);
		tot  = put(a + b,f4.0);
	end;
	if i=2 then do;
 		measrgree="Specificity";
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
		stat=put(100*sp,f5.2)||" ("||trim(left(put(100*sp_lcl,5.2)))||" - "||trim(left(put(100*sp_ucl,5.2)))||")";
		cnt1 = "";
		cnt2 = "";
		tot  = "";
	end;
	if i=3 then do;
 		measrgree="Positive Predictive Value (PPV)";
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
		stat=put(100*ppv,f5.2)||" ("||trim(left(put(100*ppv_lcl,5.2)))||" - "||trim(left(put(100*ppv_ucl,5.2)))||")";
		cnt1 = put(c,f4.0);
		cnt2 = put(d,f4.0);
		tot  = put(c + d,f4.0);
	end;
	if i=4 then do;
 		measrgree="Negative Predictive Value (NPV)";
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
		stat=put(100*npv,f5.2)||" ("||trim(left(put(100*npv_lcl,5.2)))||" - "||trim(left(put(100*npv_ucl,5.2)))||")";
		cnt1 = "";
		cnt2 = "";
		tot  = "";
	end;
	if i=5 then do;
 		measrgree="Likelihood Ratio Positive (LR+)";
		test_r="Total";
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
		stat=put(lr_plus,f5.2)||" ("||trim(left(put(lr_plus_lcl,5.2)))||" - "||trim(left(put(lr_plus_ucl,5.2)))||")";
		cnt1 = put(a + c,f4.0);
		cnt2 = put(b + d,f4.0);
		tot  = put(a + b + c + d,f4.0);
	end;
	if i=6 then do;
 		measrgree="Likelihood Ratio Negative (LR-)";
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
		stat=put(lr_minus,f5.2)||" ("||trim(left(put(lr_minus_lcl,5.2)))||" - "||trim(left(put(lr_minus_ucl,5.2)))||")";
		cnt1 = "";
		cnt2 = "";
		tot  = "";
	end;
	if i=7 then do;
 		measrgree="Diagnostic Accuracy";
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
		stat=put(100*acc,f5.2)||" ("||trim(left(put(100*acc_lcl,5.2)))||" - "||trim(left(put(100*acc_ucl,5.2)))||")";
		cnt1 = "";
		cnt2 = "";
		tot  = "";
	end;
	if i=8 then do;
 		measrgree="Disease Prevalence";
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
		stat=put(100*prev,f5.2)||" ("||trim(left(put(100*prev_lcl,5.2)))||" - "||trim(left(put(100*prev_ucl,5.2)))||")";
		cnt1 = "";
		cnt2 = "";
		tot  = "";
	end;
	if i=9 then do;
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
		stat=put(dor,f5.2)||" ("||trim(left(put(dor_lcl,5.2)))||" - "||trim(left(put(dor_ucl,5.2)))||")";
		cnt1 = "";
		cnt2 = "";
		tot  = "";
	end;
	if i=10 then do;
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
		stat=put(yo,f5.2)||" ("||trim(left(put(yo_lcl,5.2)))||" - "||trim(left(put(yo_ucl,5.2)))||")";
		cnt1 = "";
		cnt2 = "";
		tot  = "";
	end;
	if i=11 then do; * do nothing - skip line;
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
%mend meval;


