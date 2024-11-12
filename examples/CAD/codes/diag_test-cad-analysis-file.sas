dm "odsresults; clear; log; clear; out; clear";

* to remove all datasets from within the WORK folder;
proc datasets lib=work nolist kill; quit; run;

* program start time;
%let datetime_start = %sysfunc(TIME()) ;
%put START TIME: %sysfunc(datetime(),datetime14.);

* set working directory;
%let dir=/home/kmuthusi0/CAD/;

/*proc printto log="&dir./output/logs/diag_test_log.log" new; run;*/

* set output directory;
%let outputdir=&dir./output/tables/;
libname cad "&dir./data";

*load setup file;
%include "&dir./codes/cad-setup.sas";

*load required macro;
%include "&dir./macros/pr_curve.sas";

%include "&dir./macros/diag_test.sas";

* data steps...;
data cad;
set cad;
cad_probs = 0;
if cath="Cad" then cad_probs = 1;

	* data statements;
dom_all=1;
label 	cad_probs = "CAD" 
		gbm_probs ="GB"
		rf_probs ="RF"
		xgb_probs ="XGB"
		ann_probs ="ANN"
		ada_probs ="AdaBoost"
		tree_probs ="DT"
		bagging_probs ="Bagging"
		lr_probs ="LR"
		nb_probs ="NB"
		extra_probs ="ET"
		k_nn_probs ="kNN"
		svm_probs ="SVM" 
		;
run;  

/*
proc freq data=cad;
table cath*(gbm_probs rf_probs);
run;
*/

* call main macro;
option mlogic mprint symbolgen;

* initialize parameters;
%let testvarlist = 	/*gbm_probs */
					/*ann_probs */
					/*ada_probs */
					/*tree_probs */
					bagging_probs 
					/*extra_probs */
					k_nn_probs
					svm_probs 
					rf_probs
					/*xgb_probs*/
					/*nb_probs*/
					lr_probs
					;

%let tablename=table_cad_wilson;
%let tabletitle=Evaluating performance of different Machine Learning techniques in disease detection ;

%diag_test(	data				=cad,
			truthvar			=cad_probs,
			truthcutvalue		=0.5,
			testvarlist			=&testvarlist.,
			testcutvalue		=0.5,
			domain				=dom_all,
			domainvalue			=1,
			condition			=,
			tabletitle			=&tabletitle.,
			tablename			=&tablename.,
			surveyname			=CAD,
			outputdir			=&outputdir.,
			decimalpoints		=1,
			alpha				=0.05,
			missvaluelabel		=.,
			varmethod			=wilson,
			print				=YES);

* program end time;
%put END TIME: %sysfunc(datetime(),datetime14.);
%put PROCESSING TIME:  %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&datetime_start.),mmss.)) (mm:ss);

* reset print to log;
proc printto; run;
