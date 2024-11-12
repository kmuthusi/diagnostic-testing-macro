dm 'odsresults; clear; log; clear; out; clear';

* to remove all datasets from within the WORK folder;
proc datasets lib=work nolist kill; quit; run;

/*proc printto log="&dir.\output\logs\svy_freqs log.log" new; run;*/

* program start time;
%let datetime_start = %sysfunc(TIME()) ;
%put START TIME: %sysfunc(datetime(),datetime14.);

* set working directory;
%let dir=C:\PhD\SAS;

* set output directory;
%let outputdir=&dir.\output\tables;

libname data "&dir.\data\DBS_analysis\data_a";

*load setup file;
%include "&dir.\data\DBS_analysis\pgm_a\setup_10_28_2014.sas";
%include "&dir.\data\DBS_analysis\formats\vl dbs formats.sas";

*load required macro(s);
%include "&dir.\macros\mevaluation.sas";

* data steps...;
data vl_dbs;
set data._allforms;
* data statements;
run;  

%let testvarlist=V_DBSVload M_DBSVload D_DBSVload Roche_Plasma_VLoad Roche_VDBS_VLoad;
%let testtypelist=Abbott-VDBS Abbott-MDBS Abbott-DDBS CAP/CTM-Plasma CAP/CTM-VDBS;
%let tablename=table_abbott_plasma_vs_dbs;
%let tabletitle=Table 1. Evaluation diagnostic accuracy of Abbott DBS and CAP/CTM Plasma and CAP/CTM V-DBS vs Abbott Plasma in Viral Load testing;

%mevaluation(	data				=vl_dbs,
				testvarlist			=&testvarlist.,
				truthvar			=Abbott_Plasma_VLoad,
				truthvarlabel		=Abbott-Plasma,
				testtypelist		=&testtypelist.,
				testcutvalue		=1000, 
				testcutvalueunits	=copies/mL,
				truthcutvalue		=1000,
				truthcutvalueunits	=copies/mL,
				domain				=dom_all,
				domainvalue			=1,
				condition			=if Abbott_Plasma_Valid=1 and log_diff_abbott_roche < 0.7 and atleast_dbs=1,
				tabletitle			=&tabletitle.,
				tablename			=&tablename.,
				surveyname			=VL DBS,
				outputdir			=&outputdir.,
				print				=YES);

* program end time;
%put END TIME: %sysfunc(datetime(),datetime14.);
%put PROCESSING TIME:  %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&datetime_start.),mmss.)) (mm:ss);

* reset print to log;
proc printto; run;



