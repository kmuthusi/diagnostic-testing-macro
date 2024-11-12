dm "odsresults; clear; log; clear; out; clear";

* to remove all datasets from within the WORK folder;
proc datasets lib=work nolist kill; quit; run;

* program start time;
%let datetime_start = %sysfunc(TIME()) ;
%put START TIME: %sysfunc(datetime(),datetime14.);

* set working directory;
%let dir=/home/kmuthusi0/VL DBS;

proc printto log="&dir./output/logs/diag_test_log.log" new; run;

* set output directory;
%let outputdir=&dir./output/tables;
libname vldbs "&dir./data";

*load setup file;
%include "&dir./setup/setup.sas";

*load required macro;
%include "&dir./macros/pr_curve.sas";

%include "&dir./macros/diag_test.sas";

* data steps...;
data vl_dbs;
set vldbs.clean_vldbs;
	* data statements;
run;  

* call main macro;
option mlogic mprint symbolgen;

* initialize parameters;
%let testvarlist=M_DBSVload 
		 V_DBSVload 
		 D_DBSVload
		 Roche_VDBS_VLoad
		 /*Roche_Plasma_VLoad*/
		 ;
%let tablename=table_abbott_plasma_vs_dbs_wilson;
%let tabletitle=Evaluating diagnostic accuracy of Abbott DBS/*and CAP/CTM Plasma*/ and CAP/CTM V-DBS vs Abbott Plasma in VL testing;

%diag_test(	data				=vl_dbs,
			truthvar		=Abbott_Plasma_VLoad,
			truthcutvalue		=1000,
			testvarlist		=&testvarlist.,
			testcutvalue		=1000,
			domain			=dom_all,
			domainvalue		=1,
			condition		=if Abbott_Plasma_Valid=1 and log_diff_abbott_roche < 0.7 and atleast_dbs=1 
									/*& V_DBSVload ne -100 & M_DBSVload ne -100 & D_DBSVload ne -100*/,
			tabletitle		=&tabletitle.,
			tablename		=&tablename.,
			surveyname		=VL DBS,
			outputdir		=&outputdir.,
			decimalpoints		=1,
			alpha			=0.05,
			missvaluelabel		=-100,
			varmethod		=wilson,
			print			=YES);

* program end time;
%put END TIME: %sysfunc(datetime(),datetime14.);
%put PROCESSING TIME:  %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&datetime_start.),mmss.)) (mm:ss);

* reset print to log;
proc printto; run;
