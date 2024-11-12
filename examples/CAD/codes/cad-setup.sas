PROC IMPORT OUT= WORK.CAD 
            DATAFILE= "/home/kmuthusi/CAD/SAS/data/combined_predictions.csv" 
            DBMS=CSV REPLACE;
     GETNAMES=YES;
     DATAROW=2; 
RUN;
