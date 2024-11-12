* create a working directory;
%let dir=C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS;

* reference library with formats;
libname vldbs v9 "&dir.\data\xpt\";

* load formats file;
%include "&dir.\data\xpt\clean_vldbs_infile.sas";

* data steps ...;
options fmtsearch=(WORK vldbs.clean_ out.clean_vldbs library);

data clean_vldbs;
set out.clean_vldbs;
* condition;
run;
