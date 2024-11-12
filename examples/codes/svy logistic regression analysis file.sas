dm 'odsresults; clear; log; clear; out; clear';

* to remove all datasets from within the WORK folder;
proc datasets lib=work nolist kill; quit; run;

%let dir=C:\Users\mwj6\Documents\Muthusi\CaTX\EID HIVDR\SAS;

* print log to file;
proc printto log="&dir.\output\logs\svy_logistic_regression log file.txt" new; run;

* track program run time;
* program start time;
%let datetime_start = %sysfunc(TIME()) ;
%put START TIME: %sysfunc(datetime(),datetime14.);

* load data setup file;
%include "&dir.\setup\setup.sas";

* load required macros;
%include "&dir.\macros\svy_logistic_regression.sas";

* data steps ...;
data clean_eid_dr_data;
	set clean_eid_dr_data;

	* replace missing values code with .;
	/*
	array a(*) _numeric_;
	do i=1 to dim(a);
		if a(i) = -100 then a(i) =.;
	end;
	drop i;
	*/
run;

* call svy_logistic_regression macro;
option mlogic mprint symbolgen;

* initialize outcome variable;
%let outcome = any_sdrms;
%let outevent= Yes;
%let data = clean_eid_dr_data;

* define simple logistic regression model input parameters;
%let classvarb= infantage_weeks_cat(ref="<=8 weeks")/*infant_gender(ref="Male")  mother_age_cat(ref="< 25 years") mother_status(ref="Unknown")*/ exp_both_prophylaxis(ref="None")
				infantprophylaxis_cat(ref="None")  mother_pmtctreg_cat1(ref="None") mother_pmtctreg_cat2(ref="None") ;

%let catvarsb = infantage_weeks_cat/*infant_gender  mother_age_cat mother_status*/ exp_both_prophylaxis infantprophylaxis_cat mother_pmtctreg_cat1 
				mother_pmtctreg_cat2;
%let contvarsb= ;

* fit simple logistic regression model;
%svy_unilogit ( dataset 			= &data., 
				outcome 			= &outcome.,
				outevent			= &outevent.,
				catvars	 			= &catvarsb., 
				contvars			= &contvarsb.,
				class 				= &classvarb., 
				weight				= final_normal_weight,
				cluster				= ,
				strata				= ,
				domain				= ,
				domvalue			= ,
				varmethod			= ,
				rep_weights_values	= ,
				varmethod_opts		= ,
				missval_opts		= ,
				missval_lab			= -100,
				condition 			= if sample_status=3 & infant_gender in (1,2),
				pvalue_decimal		= 3,
				or_decimal			= 1,
				print				= YES); 

* define parameters for selected predictor variables;
%let classvarm= infantage_weeks_cat(ref="<=8 weeks") 
				/*exp_both_prophylaxis(ref="None")*/
				/*infantprophylaxis_cat(ref="None")*/
				/*mother_pmtctreg_cat1(ref="None")*/
				mother_pmtctreg_cat2(ref="None");
%let catvarsm = infantage_weeks_cat 
				/*exp_both_prophylaxis*/
				/*infantprophylaxis_cat*/
				/*mother_pmtctreg_cat1*/
				mother_pmtctreg_cat2;
%let contvarsm=;

* fit multiple logistic regression model;
%svy_multilogit (dataset 			= &data., 
				outcome 			= &outcome.,
				outevent			= &outevent.,
				catvars	 			= &catvarsm., 
				contvars			= &contvarsm.,
				class 				= &classvarm., 
				weight				= final_normal_weight,
				cluster				= ,
				strata				= ,
				domain				= ,
				domvalue			= ,
				varmethod			= ,
				rep_weights_values	= ,
				varmethod_opts		= ,
				missval_opts		= ,
				missval_lab			= -100,
				condition 			= if sample_status=3 & infant_gender in (1,2),
				pvalue_decimal		= 3,
				or_decimal			= 1,
				print				= YES); 

* output final table;
%svy_printlogit(tablename	= logit_table_3_any_sdrms,
				outcome		= &outcome.,
				outevent	= &outevent.,
				outdir		= &dir.\output\tables, 
				tabletitle	= Table 3: Factors associated with Prevalence of SDRMs to NNRTIs among newly diagnosed HIV infected infants aged 0-18 months in Kenya - 2018);

* program end time;
%put END TIME: %sysfunc(datetime(),datetime14.);
%put PROCESSING TIME:  %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&datetime_start.),mmss.)) (mm:ss);

* reset print to log;
proc printto; run;
