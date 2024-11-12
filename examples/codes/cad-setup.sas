PROC IMPORT OUT= WORK.CAD 
            DATAFILE= "C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\ESI\ML\CAD\Excel\data\combined_predictions.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
