
/* Load the junkmail dataset */
data junkmail;
set sashelp.junkmail;
run;

/* Partition the data */
data junkmail_train junkmail_val;
   set junkmail;
   if ranuni(0) < 0.7 then output junkmail_train;
   else output junkmail_val;
run;

/* Random Forest */
proc hpsplit data=junkmail_train;
   target Class;
   input PetalLength PetalWidth SepalLength SepalWidth;
   output out=scored;
   run;
