dm 'odsresults; clear; log; clear; out; clear';

* to remove all datasets from within the WORK folder;
proc datasets lib=work nolist kill; quit; run;

* set working directory;
%let dir=C:\Users\mwj6\Documents\Muthusi\CaTX\EID HIVDR\SAS;

* set output directory;
%let outdir=&dir.\output\tables;

* print log to file;
/*proc printto log="&dir.\output\logs\eid_dr_data_metadata_log_file.txt" new; run;*/

* track program run time;
* program start time;
%let datetime_start = %sysfunc(TIME()) ;
%put START TIME: %sysfunc(datetime(),datetime14.);

* load data setup file;
%include "&dir.\setup\setup.sas";

* load required macros;
%include "&dir.\macros\svy_freqs_jrr_dev_03_15_21.sas";

* data steps ...;
data clean_eid_dr_data;
	set clean_eid_dr_data;
	total=1;
	label total="Total";
	* replace missing values code with .;
	/*
	array a(*) _numeric_;
	do i=1 to dim(a);
		if a(i) = -100 then a(i) =.;
	end;
	drop i;
	*/
run;

* call main macro;
option mlogic mprint symbolgen;

* Table 1: Characteristics of newly diagnosed HIV infected infants aged 0-18 months in Kenya by sex - 2018;
%let fvars=	infant_gender infantage_weeks_cat infant_feedinginfo sample_entrypoint infantprophylaxis_cat exp_infant_prophylaxis mother_age_cat 
			mother_status mother_pmtctreg_cat1 mother_pmtctreg_cat2 exp_mother_prophylaxis   
			exp_both_prophylaxis pcrtest_requested receiptpackaging_condition sample_status;
%let cvars=	infantage_months mother_age;
%let tablename=svy_freq_table_1;
%let title =Table 1: Characteristics of newly diagnosed HIV infected infants aged 0-18 months in Kenya by sex - 2018;

%svy_freqs(_data=clean_eid_dr_data,
		   _outcome=,
		   _outvalue=,
		   _factors=&fvars.,
		   _contvars=&cvars.,
		   _byvar=total,
		   _domain=,
		   _domainvalue=,
		   _strata=,
		   _cluster=,
           _weight=final_normal_weight,
		   _varmethod=,
		   _rep_weights_values=,
		   _varmethod_opts=,
		   _missval_lab=-100,
		   _missval_opts=missing,
		   _idvar=sid,
		   _cat_type=col,
		   _cont_type=median,
		   _est_decimal=1,
		   _p_value_decimal=3,
		   _condition=if infant_gender in (1,2),
		   _title=&title.,
		   _tablename=&tablename.,
		   _surveyname=EID,
		   _outdir=&outdir.,
		   _print=YES);


* Table 2a: Prevalence of SDRMs to NNRTI among newly diagnosed HIV infected infants aged 0-18 months in Kenya by sex - 2018;
%let fvars=	infant_gender ;
%let cvars=	;
%let tablename=svy_freq_table_2a;
%let title =Table 2a: Prevalence of SDRMs to NNRTI among newly diagnosed HIV infected infants aged 0-18 months in Kenya by sex - 2018;

%svy_freqs(_data=clean_eid_dr_data,
		   _outcome=nnrti_sdrms_bin,
		   _outvalue=1,
		   _factors=&fvars.,
		   _contvars=&cvars.,
		   _byvar=total,
		   _domain=,
		   _domainvalue=,
		   _strata=,
		   _cluster=,
           _weight=final_normal_weight,
		   _varmethod=,
		   _rep_weights_values=,
		   _varmethod_opts=,
		   _missval_lab=-100,
		   _missval_opts=missing,
		   _idvar=sid,
		   _cat_type=prev,
		   _cont_type=median,
		   _est_decimal=1,
		   _p_value_decimal=3,
		   _condition=if sample_status=3 and infant_gender in (1,2),
		   _title=&title.,
		   _tablename=&tablename.,
		   _surveyname=EID,
		   _outdir=&outdir.,
		   _print=YES);

* Table 2b: Prevalence of SDRMs to NRTI among newly diagnosed HIV infected infants aged 0-18 months in Kenya by sex - 2018;
%let fvars=	infant_gender ;
%let cvars=	;
%let tablename=svy_freq_table_2b;
%let title =Table 2b: Prevalence of SDRMs to NRTI among newly diagnosed HIV infected infants aged 0-18 months in Kenya by sex - 2018;

%svy_freqs(_data=clean_eid_dr_data,
		   _outcome=nrti_sdrms_bin,
		   _outvalue=1,
		   _factors=&fvars.,
		   _contvars=&cvars.,
		   _byvar=total,
		   _domain=,
		   _domainvalue=,
		   _strata=,
		   _cluster=,
           _weight=final_normal_weight,
		   _varmethod=,
		   _rep_weights_values=,
		   _varmethod_opts=,
		   _missval_lab=-100,
		   _missval_opts=missing,
		   _idvar=sid,
		   _cat_type=prev,
		   _cont_type=median,
		   _est_decimal=1,
		   _p_value_decimal=3,
		   _condition=if sample_status=3 and infant_gender in (1,2),
		   _title=&title.,
		   _tablename=&tablename.,
		   _surveyname=EID,
		   _outdir=&outdir.,
		   _print=YES);


* Table 2c: Prevalence of SDRMs to PI among newly diagnosed HIV infected infants aged 0-18 months in Kenya by sex - 2018;
%let fvars=	infant_gender ;
%let cvars=	;
%let tablename=svy_freq_table_2c;
%let title =Table 2c: Prevalence of SDRMs to PI among newly diagnosed HIV infected infants aged 0-18 months in Kenya by sex - 2018;

%svy_freqs(_data=clean_eid_dr_data,
		   _outcome=pi_sdrms_bin,
		   _outvalue=1,
		   _factors=&fvars.,
		   _contvars=&cvars.,
		   _byvar=total,
		   _domain=,
		   _domainvalue=,
		   _strata=,
		   _cluster=,
           _weight=final_normal_weight,
		   _varmethod=,
		   _rep_weights_values=,
		   _varmethod_opts=,
		   _missval_lab=-100,
		   _missval_opts=missing,
		   _idvar=sid,
		   _cat_type=prev,
		   _cont_type=median,
		   _est_decimal=1,
		   _p_value_decimal=3,
		   _condition=if sample_status=3 and infant_gender in (1,2),
		   _title=&title.,
		   _tablename=&tablename.,
		   _surveyname=EID,
		   _outdir=&outdir.,
		   _print=YES);

* program end time;
%put END TIME: %sysfunc(datetime(),datetime14.);
%put PROCESSING TIME:  %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&datetime_start.),mmss.)) (mm:ss);

* reset print to log;
proc printto; run;
