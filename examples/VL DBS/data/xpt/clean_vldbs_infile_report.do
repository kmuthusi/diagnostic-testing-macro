capture program drop sas_rep
program define sas_rep, rclass
di as err " SAS failed to create clean_vldbs " 
di as err " Look at {view C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS\data\xpt\clean_vldbs_infile.log:C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS\data\xpt\clean_vldbs_infile.log} to see what error occurred. " 
local sas_rep_error= 1 
return local sas_rep_error "`sas_rep_error\'" 
end
