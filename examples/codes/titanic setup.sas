PROC IMPORT OUT= WORK.TITANIC_TEST 
            DATAFILE= "C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\ESI\ML\Titanic\Excel\data\combined_predictions.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
