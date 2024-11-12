proc logistic data= dprepare plots(only)=roc;
*class rank / param=ref ;
model truthvarcat (event="1")= M_DBSVload 
				 /*V_DBSVload */
				 /*D_DBSVload*/
				 /*Roche_VDBS_VLoad*/ / outroc=performance noint;
output out = estprob p= pred;
run;
%prcurve(data=performance, options=nomarkers tr);


/* Precision Recall Curve SAS */
data precision_recall;
set performance;
precision = _POS_/(_POS_ + _FALPOS_);
recall = _POS_/(_POS_ + _FALNEG_);
F_stat = harmean(precision,recall);
run;

/*
proc sort data=precision_recall;
by recall;
run;
*/

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


data one;
   set precision_recall end=eof;
   output;
   if eof then do;
      recall=recall+(1e-10);
      output;
   end;
   run;

/* proc print data=one;
   title 'Original Series';
   run;
*/

proc gplot data=one;
   title 'Original Series';
   plot precision*recall;
   run;
   quit;



proc sort data=one nodupkey;
by recall;
run;


****************** Compute area by spline method *********************;

proc expand data=one out=three method=spline ;
   convert precision=total/observed=(beginning,total) transformout=(sum);
   id recall;
   run;

proc sort data=three;
   by descending total;
   run;

proc print data=three(obs=1) noobs label;
   title 'Approximate Integral Using Spline method';
   var total;
   label total="Spline Area";
   run;


******************* Compute area by trapezoid rule *********************;

proc expand data=one out=three method=join;
   convert precision=total/observed=(beginning,total) transformout=(sum);
   id recall;
   run;

proc sort data=three;
   by descending total;
   run;

proc print data=three(obs=1) noobs label;
   title 'Approximate Integral Using Trapezoid Rule';
   var total;
   label total="Trapezoid Area";
   run;


