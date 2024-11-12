FILENAME PROBLY TEMP;
PROC HTTP
 URL="https://stats.idre.ucla.edu/stat/data/binary.csv"
 METHOD="GET"
 OUT=PROBLY;
RUN;

OPTIONS VALIDVARNAME=ANY;
PROC IMPORT
  FILE=PROBLY
  OUT=WORK.binary REPLACE
  DBMS=CSV;
RUN;

proc sql;
create table binary2 as 
select * from binary
where not(gre>=600 and gre>=3.5 and admit=1);
quit;

Proc logistic data= WORK.binary2 descending plots(only)=roc;
class rank / param=ref ;
model admit = gre gpa rank / outroc=performance;
output out = estprob p= pred;
run;

/* Precision Recall Curve SAS */
data precision_recall;
set performance;
precision = _POS_/(_POS_ + _FALPOS_);
recall = _POS_/(_POS_ + _FALNEG_);
F_stat = harmean(precision,recall);
run;

proc sort data=precision_recall;
by recall;
run;

proc iml;
use precision_recall;
read all var {recall} into sensitivity;
read all var {precision} into precision;
N  = 2 : nrow(sensitivity);
tpr = sensitivity[N] - sensitivity[N-1];
prec = precision[N] + precision[N-1];
AUPRC = tpr`*prec/2;
print AUPRC;

title1 "Area under Precision Recall Curve";
symbol1 interpol=join value=dot;
proc gplot data=precision_recall;
plot precision*recall /  haxis=0 to 1 by .2
                        vaxis=0 to 1 by .2;
run;
quit;
