dm 'odsresults; clear; log; clear; out; clear';

* to remove all datasets from within the WORK folder;
proc datasets lib=work nolist kill; quit; run;

* set working directory;
%let dir=C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS;

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
%include "&dir.\macros\metadata.sas";

* data steps ...;
data vl_dbs;
set vldbs.clean_vldbs;
	* data statements;
run;  

* call main macro;
option mlogic mprint symbolgen;

* define input/output parameters;
%let _outdir 	 = &outdir;
%let _tablename	 = vl_dbs_metadata;
%let _studyname	 = VL DBS;
%let _tabletitle = Appendix 1: Metadata for &_studyname Study;

%metadata(_dataset		= vl_dbs,
		  _missval		= -100,
		  _outdir		= &_outdir.,
		  _studyname	= &_studyname.,
	 	  _tablename	= &_tablename.,
		  _tabletitle	= &_tabletitle.);

* program end time;
%put END TIME: %sysfunc(datetime(),datetime14.);
%put PROCESSING TIME:  %sysfunc(putn(%sysevalf(%sysfunc(TIME())-&datetime_start.),mmss.)) (mm:ss);

proc printto; run;
