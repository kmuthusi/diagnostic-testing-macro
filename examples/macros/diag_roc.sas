dm "odsresults; clear; log; clear; out; clear";

* to remove all datasets from within the WORK folder;
proc datasets lib=work nolist kill; quit; run;

* program start time;
%let datetime_start = %sysfunc(TIME()) ;
%put START TIME: %sysfunc(datetime(),datetime14.);

* set working directory;
%let dir=C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS;

proc printto log="&dir.\output\logs\diag_test_log.log" new; run;

* set output directory;
%let outputdir=&dir.\output\tables;
libname vldbs "&dir.\data";

*load setup file;
%include "&dir.\setup\setup.sas";

*load required macro;
%include "&dir.\macros\diag_test.sas";

* data steps...;
data vl_dbs;
set vldbs.clean_vldbs;
	* data statements;
run;  

%macro diag_roc(	data=,
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
					varmethod=,
				 	print=);

		%* get number of diagnostic test variables;
			data _null_;
				i = 0;
				do while (scanq("&testvarlist",i+1) ^= " "); i+1; end;
		 		call symput("nvars", trim(left(i)));
			run;

		    %* ;
		  	%let xi=1;
		  	%let len=0;

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

				ods _all_ close;
				ods rtf file="&outputdir\roc_&tablename..rtf" startpage=yes;
				ods noproctitle;


				proc logistic data=dprepare plots=roc(id=prob) ;*plots(only)=roc;
				title "ROC Curves";
					model truthvarcat(event='1') = &testvarlist. / nofit;
						%do _i=1 %to &nvars;
						%let t_var = %scan(&testvarlist, &_i);

						%let t_type = call symputx("testtypelab", vlabel(&t_var));

							roc '&t_type.' &t_var.;
						%end;
					where truthvarcat in (1,2);
					ods select ROCOverlay;
				*output out=__roc_out__ predicted=&testvar._pred; 
				title;
				run;
				quit;

		ods rtf close;
		ods listing;

 		%put i = &xi len = &len nvar = &nvars variable= &testvar;
    	%let xi = %eval(&xi + 1);
 	%end;
 /*   	data _TMP4_; 
			set _null_; 
		run;

		ods _all_ close;
		ods rtf file="&outputdir\roc_&tablename..rtf" startpage=yes;
		ods noproctitle;

			ods graphics on;
			%droc(	data=dprepare,
					testvar=&testvar,
					testtype=&testtype,
					testcutvalue=&testcutvalue,
					truthvar=truthvarcat,
					truthcutvalue=&truthcutvalue,
					domain=&domain,
					domainvalue=&domainvalue);
	 		
			ods graphics off;
		ods rtf close;
		ods listing;

		data __roc_out__;
 			set __roc_out__ _TMP4_;
 		run;

 */
%if %upcase(&print) = NO %then %do; ods exclude all; %end;
%else  %do; ods exclude none; %end;

ods exclude none;
%mend;

/*%macro droc(data=,
			testvar=,
			testtype=,
			testcutvalue=,
			truthvar=,
			truthcutvalue=,
			domain=,
			domainvalue=);

*title "ROC Curve for &testtype";
*ods select ROCcurve;
%let &nvars = %eval(%sysfunc(count(&testvarlist., %quote( )))+1);

proc logistic data=&data plots=roc(id=prob) ;*plots(only)=roc;
	model truthvarcat(event='1') = &testvarlist / nofit;
	where truthvarcat in (1,2);

%do _i=1 %to &nvars;
	roc '&testtypelab' &testvar;
%end;
*output out=__roc_out__ predicted=&testvar._pred; 
run;
quit;
*title;
%mend;
*/
/*
ods graphics on;
proc logistic data=dprepare plots(only)=roc;
   model truthvarcat(event='1') = Roche_VDBS_VLoad;
   output out=LogiOut predicted=LogiPred;       
   where truthvarcat in (1,2);
   ods select ROCcurve;
run;
ods graphics off;
*/

* call main macro;
option mlogic mprint symbolgen;

* initialize parameters;
%let testvarlist=V_DBSVload 
				 M_DBSVload 
				 D_DBSVload 
				 Roche_Plasma_VLoad 
				 Roche_VDBS_VLoad;
%let tablename=plasma_vs_dbs;
%let tabletitle=Table 1. Evaluation diagnostic accuracy of Abbott DBS and CAP/CTM Plasma and CAP/CTM V-DBS vs Abbott Plasma in Viral Load testing;

%diag_roc(	data				=vl_dbs,
			truthvar			=Abbott_Plasma_VLoad,
			truthcutvalue		=1000,
			testvarlist			=&testvarlist.,
			testcutvalue		=1000,
			domain				=dom_all,
			domainvalue			=1,
			condition			=if Abbott_Plasma_Valid=1 and log_diff_abbott_roche < 0.7 and atleast_dbs=1,
			tabletitle			=&tabletitle.,
			tablename			=&tablename.,
			surveyname			=VL DBS,
			outputdir			=&outputdir.,
			decimalpoints		=2,
			alpha				=0.05,
			missvaluelabel		=-100,
			varmethod			=normal,
			print				=YES);
