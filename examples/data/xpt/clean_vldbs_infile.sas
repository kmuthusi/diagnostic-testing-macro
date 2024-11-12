
/********************************************************
** program: C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS\data\xpt\clean_vldbs_infiles.sas  
** programmer: savasas  
** date: 17 Feb 2022 
** comments: SAS program to read and label:  
**  C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS\data\xpt\clean_.xpt 
**           which contains data from a Stata dataset
********************************************************/

options nofmterr nocenter linesize=max;


 ** this version of _infile_report.do will be overwritten if all goes well. **; 
 data _null_;
file "C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS\data\xpt\clean_vldbs_infile_report.do"; 
 put "capture program drop sas_rep"; 
 put "program define sas_rep, rclass"; 
 put "di as err "" SAS failed to create clean_vldbs "" "; 
 put "di as err "" Look at {view C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS\data\xpt\clean_vldbs_infile.log:C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS\data\xpt\clean_vldbs_infile.log} to see what error occurred. "" "; 
 put "local sas_rep_error= 1 "; 
 put "return local sas_rep_error ""`sas_rep_error\'"" "; 
 put "end"; 

libname library v9 "C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS\data\xpt\" ;  

options fmtsearch=(out.clean_vldbs);  

libname out v9 "C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS\data\xpt\"  ;  

libname raw xport "C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS\data\xpt\clean_.xpt";  


options NoQuoteLenMax;
data formats;
length fmtname $32 start end 8 label $32000;
infile "C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS\data\xpt\clean_vldbs_formats.txt" lrecl=32075 truncover ; 
input fmtname 1-32 start 34-53 end 55-74 label 76-32000;
run; 


proc format library= library.clean_vldbs cntlin= work.formats(where= (fmtname ^= ""));
run; quit;

%macro redo;
 ** Check for this error message:
  * upcase(error:) File LIBRARY.clean_vldbs.CATALOG was created for a different operating system. **;
 %if &syserr.= 3000 %then %do;
   proc datasets library= library 
                 memtype= catalog 
                 nodetails nolist nowarn;
     delete clean_vldbs;
   run;
   ** now try it! **;
   proc format library= library.clean_vldbs cntlin= work.formats(where= (fmtname ^= ""));
   run; quit;
 %end;
%mend redo;
%redo;

data out.clean_vldbs  (label= "-savasas- created dataset on %sysfunc(date(), date9.)"  rename=(
 FORM9FOR= form9formnum STUDY_ID= study_id PATIENTI= patientid FORM9FAC= form9facilityname FORM9ABB= form9abbottplasma
 ABBOTT_P= abbott_plasma_vload ABBOTT_1= abbott_plasma_vloadlog ABBOTT_2= abbott_plasma_vloadlog_c FORM9PLA= form9plasma_dateresults FORM9AB1= form9abbott_mdbs
 M_DBSVLO= m_dbsvload M_DBSVL1= m_dbsvloadlog M_DBSVL2= m_dbsvloadlog_c FORM9RES= form9resultequal_m FORM9M_D= form9m_dbsdateresults
 FORM9AB2= form9abbott_ddbs D_DBSVLO= d_dbsvload D_DBSVL1= d_dbsvloadlog D_DBSVL2= d_dbsvloadlog_c FORM9RE1= form9resultequal_d
 FORM9D_D= form9d_dbsdateresults V_DBSVLO= v_dbsvload V_DBSVL1= v_dbsvloadlog V_DBSVL2= v_dbsvloadlog_c FORM9RE2= form9resultequal_p
 FORM9AB3= form9abbott_vdbs FORM9RE3= form9resultequal_v FORM9V_D= form9v_dbsdateresults FORM9DAT= form9datereview FORM9SIT= form9sitecode
 M_DBS_VA= m_dbs_valid D_DBS_VA= d_dbs_valid V_DBS_VA= v_dbs_valid ABBOTT_3= abbott_plasma_valid FORM4FOR= form4formnum
 FORM4FAC= form4facilityname FORM4FA1= form4facilitycode DATEVBCO= datevbcollected TIMEVBCO= timevbcollected AMPMCOLL= ampmcollected
 COLLECTO= collectorcode DATEVBC1= datevbcollected_2 TIMEVBC1= timevbcollected_2 AMPMCOL1= ampmcollected_2 COLLECT1= collectorcode_2
 CAPILLAR= capillarypuncturetype M_DBSSPO= m_dbsspots D_DBSSPO= d_dbsspots V_DBSSPO= v_dbsspots DATERECI= daterecievedcrc
 TIMERECE= timereceivedcrc AMPMRECE= ampmreceivedcrc DATEREC1= daterecievedkisiannhrl TIMEREC1= timereceived_kisiannhrl AMPMREC1= ampmreceived_kisiannhrl
 ACCEPTRE= acceptrejectcrc1 ACCEPTR1= acceptrejectkisiannhrl1 REASONRE= reasonrejectionkisian1 REASON_R= reason_rejectionnhrl1 ACCEPTR2= acceptreject_crc2
 ACCEPTR3= acceptreject_kisiannhrl2 REASON_1= reason_rejectionkisian2 REASON_2= reason_rejectionnhrl2 ACCEPTR4= acceptreject_crc3 ACCEPTR5= acceptreject_kisiannhrl3
 REASON_3= reason_rejectionkisian3 REASON_4= reason_rejectionnhrl3 ROCHE_VD= roche_vdbs_vload ROCHE_V1= roche_vdbs_vloadlog ROCHE_V2= roche_vdbs_vloadlog_c
 ROCHE_V_= roche_v_dbsdateresults FORM4SIT= form4sitecode D_DBS_CO= d_dbs_collected M_DBS_CO= m_dbs_collected V_DBS_CO= v_dbs_collected
 ROCHE_V3= roche_vdbs_valid FORM3FOR= form3formnum FORM3DAT= form3daterecievedcrc FORM3ACC= form3acceptrejectcrc FORM3REA= form3reasonrejectioncrc
 FORM3DA1= form3daterecieved FORM3RE1= form3reasonrejectionkisian FORM3RE2= form3reasonrejectionnhrl ROCHE_PL= roche_plasma_vload ROCHE_P1= roche_plasma_vloadlog
 ROCHE_P2= roche_plasma_vloadlog_c FORM3DA2= form3dateanalysis FORM3RES= form3resultequal ROCHE_P3= roche_plasma_valid FORM1FOR= form1formnum
 FORM1FAC= form1facilityname FORM1STU= form1study_siteid FACILITY= facilitycode FORM1DAT= form1dateenrolled FORM1CHI= form1child_assent
 FORM1ADU= form1adult_consent FORM1PAR= form1pare_guard_consent FORM1CON= form1consent_sample_storage FORM1PED= form1pedadult_potential FORM1AGR= form1agreedv_dbs
 FORM1AG1= form1agreedm_dbs FORM1CHE= form1checkedby FORM1DA1= form1datechecked FORM1DA2= form1daterecieved FORM1REV= form1reviewer
 FORM1FO1= form1form_id FORM1TIM= form1time_stamp FORM1VER= form1verify_wks FORM2FOR= form2formnum PROVINCE= province_name
 DISTRICT= district_name FORM2FAC= form2facilityname FORM2FA1= form2facility_type FORM2FIR= form2firstname FORM2SUR= form2surname
 BIRTHDAT= birthdate SEX= sex DATECOLL= datecollected CLINICAL= clinicalindication RECURREN= recurrentstage
 RECURRE1= recurrentppe ADDITION= additionalchild DECLINEG= declinegrowth FAILUREN= failureneuro RECURRE2= recurrentinfection
 IMMUNIND= immunindication CD4NORES= cd4noresponse PERSISTL= persistlowcd4 CD4FALL= cd4fall CD4FALLP= cd4fallpeak
 OTHERREA= otherreasons ASSESSME= assessment OPTIMIZI= optimizing REPEATVL= repeatvl PATIENTO= patientoi
 OISPECIF= oispecify_1 PATIENTR= patientrecurrentoi OISPECI1= oispecify_2 PATIENTT= patienttb PHASESTB= phasestb
 TOXICITY= toxicityspecify_1 ARVTOXIC= arvtoxicity TOXICIT1= toxicityspecify_2 PATIENTP= patientpreg BASELINE= baselinedate
 PEAKDATE= peakdate CURRENTD= currentdate BASELIN1= baselinecd4 PEAKCD4= peakcd4 CURRENTC= currentcd4
 BASELIN2= baselinechildcd4 PEAKCHIL= peakchildcd4 CURRENT1= currentchildcd4 PREVIOUS= previousvltest DATERECE= daterecenttest
 DRUG1A= drug1a DRUG1B= drug1b DRUG1C= drug1c DATEINIT= dateinit1 DATEDISC= datedisc1
 DISCONTI= discontinued1 INDICATI= indicationarv1 DRUG2A= drug2a DRUG2B= drug2b DRUG2C= drug2c
 DATEINI1= dateinit2 DATEDIS1= datedisc2 DISCONT1= discontinued2 INDICAT1= indicationarv2 DRUG3A= drug3a
 DRUG3B= drug3b DRUG3C= drug3c DATEINI2= dateinit3 DATEDIS2= datedisc3 DISCONT2= discontinued3
 INDICAT2= indicationarv3 DRUG4A= drug4a DRUG4B= drug4b DRUG4C= drug4c DATEINI3= dateinit4
 DATEDIS3= datedisc4 DISCONT3= discontinued4 INDICAT3= indicationarv4 DRUG5A= drug5a DRUG5B= drug5b
 DRUG5C= drug5c DATEINI4= dateinit5 DATEDIS4= datedisc5 DISCONT4= discontinued5 INDICAT4= indicationarv5
 DRUG6A= drug6a DRUG6B= drug6b DRUG6C= drug6c DATEINI5= dateinit6 DATEDIS5= datedisc6
 DISCONT5= discontinued6 INDICAT5= indicationarv6 OTHEREAS= othereasonspecify1 OTHEREA1= othereasonspecify2 OTHEREGI= otheregimenspecify
 MISSEDAR= missedarv_lst2wks DAYSMISS= daysmissed_pills MISSED_A= missed_arvclinic PERCEPTA= perceptadhere OTHERDRU= otherdrugs
 RIFAMPIC= rifampicin FLUCONAZ= fluconazole KETOCONA= ketoconazole DAPSONE= dapsone COTRIMOX= cotrimox
 CONTRACE= contraceptives MULTIVIT= multivitamin OTHERARV= otherarvspecify OTHERAR1= otherarvspecify_2 OTHER= other
 FACILIT1= facilityname FORM3PAT= form3patientid INFORM1= inform1 INFORM2= inform2 INFORM3= inform3
 INFORM4= inform4 INFORM9= inform9 PROV_COD= prov_code LOG_DIFF= log_diff_abbott_roche LOG_DIF1= log_diff_abbott_roche_c
 LOG_DIF2= log_diff_abbott_vdbs LOG_DIF3= log_diff_abbott_mdbs LOG_DIF4= log_diff_abbott_ddbs LOG_DIF5= log_diff_roche_vdbs LOG_DIF6= log_diff_roche_mdbs
 LOG_DIF7= log_diff_roche_ddbs LOG_DIF8= log_diff_roche_rochevdbs LOG_DIF9= log_diff_abbott_rochevdbs LAB_COL_= lab_col_code LAB_COL1= lab_col_code_2
 OLD_AGE= old_age AGE= age DOB= dob M_DBS_AC= m_dbs_accepted D_DBS_AC= d_dbs_accepted
 V_DBS_AC= v_dbs_accepted VB_COLLE= vb_collected ABBOTT_D= abbott_dbs_collected AGEGRP4= agegrp4 AGE_PEDS= age_peds
 AGE_ADUL= age_adults AGEGROUP= agegroup GT_1_ARV= gt_1_arv AZT_REGI= azt_regimen TDF_REGI= tdf_regimen
 D4T_REGI= d4t_regimen ADULT_OT= adult_other_regimen ADULT_RE= adult_regimen_cat NVP_REGI= nvp_regimen EFV_REGI= efv_regimen
 KALETRA_= kaletra_regimen PEDS_OTH= peds_other_regimen PEDS_REG= peds_regimen_cat PEDS_RE1= peds_regimen_cat2 DISCO_RE= disco_reason1
 DISCO_R1= disco_reason2 DISCO_R2= disco_reason3 DISCO_R3= disco_reason4 REASON_D= reason_discontinue FAIL_PED= fail_peds_ind
 FAIL_ADU= fail_adult_ind TARGET_A= target_adult_ind ROUTINE_= routine_adult_ind VL_INDIC= vl_indication ADULT_CL= adult_clinic_immun_vl
 PEDS_ASS= peds_assess_no_vl PEDS_CLI= peds_clinic_immun_vl PEDS_CL1= peds_clinic_immun_vf PEDS_CL2= peds_clinic_immun_vf2 GENDER= gender
 ADULT_AG= adult_age_cat SAMPLE_L= sample_last_init_mon ART_ADUL= art_adult_time_cat ART_PEDS= art_peds_time_cat ART_PED1= art_peds_time_cat2
 ADULT_VL= adult_vl_indication PEDS_VL_= peds_vl_indication PLASMA_A= plasma_accepted REASON_P= reason_plasma_reject REASON_M= reason_mdbs_reject
 REASON_5= reason_ddbs_reject REASON_V= reason_vdbs_reject DATE_SAM= date_sample_collected DATE_PLA= date_plasma_collected DATE_PL1= date_plasma_received_crc
 DATE_PL2= date_plasma_received_lab DATE_DBS= date_dbs_collected DATE_DB1= date_dbs_collected_2 DATE_DB2= date_dbs_received_crc DATE_DB3= date_dbs_received_lab
 PLASMA_C= plasma_crc_datediff PLASMA_L= plasma_lab_datediff DBS_CRC_= dbs_crc_datediff DBS_LAB_= dbs_lab_datediff AGEGRP3= agegrp3
 SITECODE= sitecode AZT_3TC_= azt_3tc_regimen ABC_3TC_= abc_3tc_regimen D4T_3TC_= d4t_3tc_regimen ADULT_C1= adult_clinical_ind
 PEDS_CL3= peds_clinical_ind IMMUNOLO= immunologic_ind OPTIMIZE= optimize_ind VALID_RO= valid_roche_vdbs VALID_R1= valid_roche_plasma
 VALID_AB= valid_abbott_plasma VALID_MD= valid_mdbs VALID_DD= valid_ddbs VALID_VD= valid_vdbs ADULTS_C= adults_clinic_immun_vf
 ADULTS_1= adults_clinic_immun_vf2 ABBOTT_4= abbott_plasma_vload_cat ROCHE_P4= roche_plasma_vload_cat ABBOTT_5= abbott_plasma_indicator ROCHE_P5= roche_plasma_indicator
 ROCHE_V4= roche_vdbs_indicator VDBS_IND= vdbs_indicator MDBS_IND= mdbs_indicator DDBS_IND= ddbs_indicator ATLEAST_= atleast_dbs
 ABBOTT_A= abbott_atleast ROCHE_AT= roche_atleast PLASMA_1= plasma_atleast ABBOTT_6= abbott_plasma_vload550 ABBOTT_7= abbott_plasma_vload1000
 ABBOTT_8= abbott_plasma_vload3000 ABBOTT_9= abbott_plasma_vload5000 V_DBSVL3= v_dbsvload550 V_DBSVL4= v_dbsvload1000 V_DBSVL5= v_dbsvload3000
 V_DBSVL6= v_dbsvload5000 M_DBSVL3= m_dbsvload550 M_DBSVL4= m_dbsvload1000 M_DBSVL5= m_dbsvload3000 M_DBSVL6= m_dbsvload5000
 D_DBSVL3= d_dbsvload550 D_DBSVL4= d_dbsvload1000 D_DBSVL5= d_dbsvload3000 D_DBSVL6= d_dbsvload5000 ROCHE_P6= roche_plasma_vload550
 ROCHE_P7= roche_plasma_vload1000 ROCHE_P8= roche_plasma_vload3000 ROCHE_P9= roche_plasma_vload5000 ROCHE_V5= roche_vdbs_vload550 ROCHE_V6= roche_vdbs_vload1000
 ROCHE_V7= roche_vdbs_vload3000 ROCHE_V8= roche_vdbs_vload5000 ABBOTT10= abbott_plasma_vload_1 ABBOTT11= abbott_plasma_vload_2 ABBOTT12= abbott_plasma_vload_3
 ABBOTT13= abbott_plasma_vload_4 V_DBSVL7= v_dbsvload_1 V_DBSVL8= v_dbsvload_2 V_DBSVL9= v_dbsvload_3 V_DBSV10= v_dbsvload_4
 M_DBSVL7= m_dbsvload_1 M_DBSVL8= m_dbsvload_2 M_DBSVL9= m_dbsvload_3 M_DBSV10= m_dbsvload_4 D_DBSVL7= d_dbsvload_1
 D_DBSVL8= d_dbsvload_2 D_DBSVL9= d_dbsvload_3 D_DBSV10= d_dbsvload_4 ROCHE_10= roche_plasma_vload_1 ROCHE_11= roche_plasma_vload_2
 ROCHE_12= roche_plasma_vload_3 ROCHE_13= roche_plasma_vload_4 ROCHE_V9= roche_vdbs_vload_1 ROCHE_14= roche_vdbs_vload_2 ROCHE_15= roche_vdbs_vload_3
 ROCHE_16= roche_vdbs_vload_4 V_DBSV11= v_dbsvload_cat M_DBSV11= m_dbsvload_cat D_DBSV11= d_dbsvload_cat ROCHE_17= roche_vdbs_vload_cat
 AGE_LT_5= age_lt_5 AGE_5_10= age_5_10 AGE_10_1= age_10_15 AGE_GE_1= age_ge_15 DOM_ALL= dom_all
 DOM_ALL_= dom_all_nyz DOM_ALL1= dom_all_nrb DOM_ALL2= dom_all_adults DOM_ALL3= dom_all_peds DOM_ADUL= dom_adults_nyz
 DOM_PEDS= dom_peds_nyz DOM_ADU1= dom_adults_nrb DOM_PED1= dom_peds_nrb VALID_RE= valid_result LOWEST_D= lowest_drg1
 HIGHEST_= highest_drg1 I= i LOWEST_1= lowest_drg1_var HIGHEST1= highest_drg1_var VAL5_1= val5_1
 VAL6_1= val6_1 VAL7_1= val7_1 VAL51= val51 VAL61= val61 VAL71= val71
 AZT1= azt1 D4T1= d4t1 NVP1= nvp1 EFV1= efv1 _3TC1= _3tc1
 FTC1= ftc1 TDF1= tdf1 NFV1= nfv1 ABC1= abc1 DDI1= ddi1
 KALETRA1= kaletra1 OTHER1= other1 _1DRG1= _1drg1 _1DRG2= _1drg2 _1DRG3= _1drg3
 _1DRG4= _1drg4 _1DRG5= _1drg5 _1DRG6= _1drg6 _1DRG7= _1drg7 _1DRG8= _1drg8
 _1DRG9= _1drg9 _1DRG10= _1drg10 _1DRG11= _1drg11 _1DRG12= _1drg12 DRG1_HAA= drg1_haart
 DRG1_PRO= drg1_profile LOWEST_2= lowest_drg2 HIGHEST2= highest_drg2 LOWEST_3= lowest_drg2_var HIGHEST3= highest_drg2_var
 VAL5_2= val5_2 VAL6_2= val6_2 VAL7_2= val7_2 VAL52= val52 VAL62= val62
 VAL72= val72 AZT2= azt2 D4T2= d4t2 NVP2= nvp2 EFV2= efv2
 _3TC2= _3tc2 FTC2= ftc2 TDF2= tdf2 NFV2= nfv2 ABC2= abc2
 DDI2= ddi2 KALETRA2= kaletra2 OTHER2= other2 _2DRG1= _2drg1 _2DRG2= _2drg2
 _2DRG3= _2drg3 _2DRG4= _2drg4 _2DRG5= _2drg5 _2DRG6= _2drg6 _2DRG7= _2drg7
 _2DRG8= _2drg8 _2DRG9= _2drg9 _2DRG10= _2drg10 _2DRG11= _2drg11 _2DRG12= _2drg12
 DRG2_HAA= drg2_haart DRG2_PRO= drg2_profile LOWEST_4= lowest_drg3 HIGHEST4= highest_drg3 LOWEST_5= lowest_drg3_var
 HIGHEST5= highest_drg3_var VAL5_3= val5_3 VAL6_3= val6_3 VAL7_3= val7_3 VAL53= val53
 VAL63= val63 VAL73= val73 AZT3= azt3 D4T3= d4t3 NVP3= nvp3
 EFV3= efv3 _3TC3= _3tc3 FTC3= ftc3 TDF3= tdf3 NFV3= nfv3
 ABC3= abc3 DDI3= ddi3 KALETRA3= kaletra3 OTHER3= other3 _3DRG1= _3drg1
 _3DRG2= _3drg2 _3DRG3= _3drg3 _3DRG4= _3drg4 _3DRG5= _3drg5 _3DRG6= _3drg6
 _3DRG7= _3drg7 _3DRG8= _3drg8 _3DRG9= _3drg9 _3DRG10= _3drg10 _3DRG11= _3drg11
 _3DRG12= _3drg12 DRG3_HAA= drg3_haart DRG3_PRO= drg3_profile LOWEST_6= lowest_drg4 HIGHEST6= highest_drg4
 LOWEST_7= lowest_drg4_var HIGHEST7= highest_drg4_var VAL5_4= val5_4 VAL6_4= val6_4 VAL7_4= val7_4
 VAL54= val54 VAL64= val64 VAL74= val74 AZT4= azt4 D4T4= d4t4
 NVP4= nvp4 EFV4= efv4 _3TC4= _3tc4 FTC4= ftc4 TDF4= tdf4
 NFV4= nfv4 ABC4= abc4 DDI4= ddi4 KALETRA4= kaletra4 OTHER4= other4
 _4DRG1= _4drg1 _4DRG2= _4drg2 _4DRG3= _4drg3 _4DRG4= _4drg4 _4DRG5= _4drg5
 _4DRG6= _4drg6 _4DRG7= _4drg7 _4DRG8= _4drg8 _4DRG9= _4drg9 _4DRG10= _4drg10
 _4DRG11= _4drg11 _4DRG12= _4drg12 DRG4_HAA= drg4_haart DRG4_PRO= drg4_profile LOWEST_8= lowest_drg5
 HIGHEST8= highest_drg5 LOWEST_9= lowest_drg5_var HIGHEST9= highest_drg5_var VAL5_5= val5_5 VAL6_5= val6_5
 VAL7_5= val7_5 VAL55= val55 VAL65= val65 VAL75= val75 AZT5= azt5
 D5T5= d5t5 NVP5= nvp5 EFV5= efv5 _3TC5= _3tc5 FTC5= ftc5
 TDF5= tdf5 NFV5= nfv5 ABC5= abc5 DDI5= ddi5 KALETRA5= kaletra5
 OTHER5= other5 _5DRG1= _5drg1 D4T5= d4t5 _5DRG2= _5drg2 _5DRG3= _5drg3
 _5DRG4= _5drg4 _5DRG5= _5drg5 _5DRG6= _5drg6 _5DRG7= _5drg7 _5DRG8= _5drg8
 _5DRG9= _5drg9 _5DRG10= _5drg10 _5DRG11= _5drg11 _5DRG12= _5drg12 DRG5_HAA= drg5_haart
 DRG5_PRO= drg5_profile LOWEST10= lowest_drg6 HIGHES10= highest_drg6 LOWEST11= lowest_drg6_var HIGHES11= highest_drg6_var
 VAL5_6= val5_6 VAL6_6= val6_6 VAL7_6= val7_6 VAL56= val56 VAL66= val66
 VAL76= val76 AZT6= azt6 D6T6= d6t6 NVP6= nvp6 EFV6= efv6
 _3TC6= _3tc6 FTC6= ftc6 TDF6= tdf6 NFV6= nfv6 ABC6= abc6
 DDI6= ddi6 KALETRA6= kaletra6 OTHER6= other6 _6DRG1= _6drg1 D4T6= d4t6
 _6DRG2= _6drg2 _6DRG3= _6drg3 _6DRG4= _6drg4 _6DRG5= _6drg5 _6DRG6= _6drg6
 _6DRG7= _6drg7 _6DRG8= _6drg8 _6DRG9= _6drg9 _6DRG10= _6drg10 _6DRG11= _6drg11
 _6DRG12= _6drg12 DRG6_HAA= drg6_haart DRG6_PRO= drg6_profile DRG1= drg1 DRG2= drg2
 DRG3= drg3 DRG4= drg4 DRG5= drg5 DRG6= drg6 DRGSCAN1= drgscan1
 DRGSCAN2= drgscan2 DRGSCAN3= drgscan3 SAMPLE_D= sample_date DATEINI6= dateinit_1 DATEINI7= dateinit_2
 DATEINI8= dateinit_3 DATEINI9= dateinit_4 DATEIN10= dateinit_5 DATEIN11= dateinit_6 DATEIN12= dateinit_1_1
 DATEIN13= dateinit_2_1 DATEIN14= dateinit_3_1 DATEIN15= dateinit_4_1 DATEIN16= dateinit_5_1 DATEIN17= dateinit_6_1
 LOWEST_I= lowest_init HIGHES12= highest_init LOWEST12= lowest_init_var HIGHES13= highest_init_var SEX_INDI= sex_indicator
 CD4NANDE= cd4nandesponse ADULTS_2= adults_clinic_immun_vl PEDS_RE2= peds_regimen_ind ADULT_R1= adult_regimen_ind DISCO_IN= disco_ind
 FAIL_AD1= fail_adult_optmize_ind PLASMA_2= plasma_collected M_DBSPRE= m_dbsprepared D_DBSPRE= d_dbsprepared V_DBSPRE= v_dbsprepared

 ));
 length  FORM9FOR 4 STUDY_ID $6 PATIENTI $10 FORM9FAC $10 FORM9ABB 3 ABBOTT_P 6 ABBOTT_1 8 ABBOTT_2 8
 FORM9PLA 8 FORM9AB1 3 M_DBSVLO 6 M_DBSVL1 8 M_DBSVL2 8 FORM9RES 3 FORM9M_D 6 FORM9AB2 3
 D_DBSVLO 6 D_DBSVL1 8 D_DBSVL2 8 FORM9RE1 3 FORM9D_D 8 V_DBSVLO 6 V_DBSVL1 8 V_DBSVL2 8
 FORM9RE2 3 FORM9AB3 3 FORM9RE3 3 FORM9V_D 8 FORM9DAT 8 FORM9SIT $2 M_DBS_VA 3 D_DBS_VA 3
 V_DBS_VA 3 ABBOTT_3 3 FORM4FOR 4 FORM4FAC $10 FORM4FA1 $5 DATEVBCO 6 TIMEVBCO $5 AMPMCOLL $2
 COLLECTO $3 DATEVBC1 6 TIMEVBC1 $5 AMPMCOL1 $2 COLLECT1 $3 CAPILLAR 3 M_DBSSPO 3 D_DBSSPO 3
 V_DBSSPO 3 DATERECI 6 TIMERECE $5 AMPMRECE $2 DATEREC1 6 TIMEREC1 $5 AMPMREC1 $2 ACCEPTRE 3
 ACCEPTR1 3 REASONRE $17 REASON_R $70 ACCEPTR2 3 ACCEPTR3 3 REASON_1 $17 REASON_2 $30 ACCEPTR4 3
 ACCEPTR5 3 REASON_3 $1 REASON_4 $22 ROCHE_VD 6 ROCHE_V1 8 ROCHE_V2 8 ROCHE_V_ 6 FORM4SIT $2
 D_DBS_CO 3 M_DBS_CO 3 V_DBS_CO 3 ROCHE_V3 3 FORM3FOR 4 FORM3DAT 6 FORM3ACC 3 FORM3REA $1
 FORM3DA1 6 FORM3RE1 $1 FORM3RE2 $1 ROCHE_PL 6 ROCHE_P1 8 ROCHE_P2 8 FORM3DA2 6 FORM3RES 3
 ROCHE_P3 3 FORM1FOR 4 FORM1FAC $10 FORM1STU $2 FACILITY $5 FORM1DAT 6 FORM1CHI $1 FORM1ADU 3
 FORM1PAR 3 FORM1CON 3 FORM1PED 3 FORM1AGR 3 FORM1AG1 3 FORM1CHE $3 FORM1DA1 6 FORM1DA2 6
 FORM1REV $3 FORM1FO1 6 FORM1TIM $22 FORM1VER $15 FORM2FOR 6 PROVINCE $7 DISTRICT $10 FORM2FAC $13
 FORM2FA1 3 FORM2FIR $10 FORM2SUR $10 BIRTHDAT 6 SEX 3 DATECOLL 6 CLINICAL $14 RECURREN 3
 RECURRE1 3 ADDITION $18 DECLINEG 3 FAILUREN 3 RECURRE2 3 IMMUNIND $50 CD4NORES 3 PERSISTL 3
 CD4FALL 3 CD4FALLP 3 OTHERREA $10 ASSESSME 3 OPTIMIZI 3 REPEATVL 3 PATIENTO 3 OISPECIF $11
 PATIENTR 3 OISPECI1 $12 PATIENTT 3 PHASESTB 3 TOXICITY $14 ARVTOXIC 3 TOXICIT1 $14 PATIENTP $1
 BASELINE $5 PEAKDATE $5 CURRENTD $5 BASELIN1 4 PEAKCD4 4 CURRENTC 4 BASELIN2 8 PEAKCHIL 8
 CURRENT1 8 PREVIOUS 3 DATERECE $5 DRUG1A 3 DRUG1B 3 DRUG1C 3 DATEINIT $5 DATEDISC $5
 DISCONTI 3 INDICATI 3 DRUG2A 3 DRUG2B 3 DRUG2C 3 DATEINI1 $5 DATEDIS1 $5 DISCONT1 3
 INDICAT1 3 DRUG3A 3 DRUG3B 3 DRUG3C 3 DATEINI2 $5 DATEDIS2 $5 DISCONT2 3 INDICAT2 3
 DRUG4A 3 DRUG4B 3 DRUG4C 3 DATEINI3 $5 DATEDIS3 $5 DISCONT3 3 INDICAT3 3 DRUG5A 3
 DRUG5B 3 DRUG5C 3 DATEINI4 $5 DATEDIS4 $5 DISCONT4 3 INDICAT4 3 DRUG6A 3 DRUG6B 3
 DRUG6C 3 DATEINI5 $5 DATEDIS5 $3 DISCONT5 3 INDICAT5 3 OTHEREAS $12 OTHEREA1 $12 OTHEREGI $10
 MISSEDAR 3 DAYSMISS 3 MISSED_A 3 PERCEPTA $1 OTHERDRU $38 RIFAMPIC 3 FLUCONAZ 3 KETOCONA 3
 DAPSONE 3 COTRIMOX 3 CONTRACE 3 MULTIVIT 3 OTHERARV $8 OTHERAR1 $10 OTHER 3 FACILIT1 3
 FORM3PAT $10 INFORM1 3 INFORM2 3 INFORM3 3 INFORM4 3 INFORM9 3 PROV_COD 3 LOG_DIFF 8
 LOG_DIF1 8 LOG_DIF2 8 LOG_DIF3 8 LOG_DIF4 8 LOG_DIF5 8 LOG_DIF6 8 LOG_DIF7 8 LOG_DIF8 8
 LOG_DIF9 8 LAB_COL_ $3 LAB_COL1 $3 OLD_AGE 3 AGE 8 DOB 4 M_DBS_AC 3 D_DBS_AC 3
 V_DBS_AC 3 VB_COLLE 3 ABBOTT_D 3 AGEGRP4 3 AGE_PEDS 3 AGE_ADUL 3 AGEGROUP 3 GT_1_ARV 3
 AZT_REGI 3 TDF_REGI 3 D4T_REGI 3 ADULT_OT 3 ADULT_RE 3 NVP_REGI 3 EFV_REGI 3 KALETRA_ 3
 PEDS_OTH 3 PEDS_REG 3 PEDS_RE1 3 DISCO_RE 3 DISCO_R1 3 DISCO_R2 3 DISCO_R3 3 REASON_D 3
 FAIL_PED 3 FAIL_ADU 3 TARGET_A 3 ROUTINE_ 3 VL_INDIC 3 ADULT_CL 3 PEDS_ASS 3 PEDS_CLI 3
 PEDS_CL1 3 PEDS_CL2 3 GENDER 3 ADULT_AG 3 SAMPLE_L 8 ART_ADUL 3 ART_PEDS 3 ART_PED1 3
 ADULT_VL 3 PEDS_VL_ 3 PLASMA_A 3 REASON_P $1 REASON_M $70 REASON_5 $30 REASON_V $22 DATE_SAM 4
 DATE_PLA 4 DATE_PL1 4 DATE_PL2 4 DATE_DBS 4 DATE_DB1 4 DATE_DB2 4 DATE_DB3 4 PLASMA_C 3
 PLASMA_L 4 DBS_CRC_ 4 DBS_LAB_ 4 AGEGRP3 3 SITECODE $2 AZT_3TC_ 3 ABC_3TC_ 3 D4T_3TC_ 3
 ADULT_C1 3 PEDS_CL3 3 IMMUNOLO 3 OPTIMIZE 3 VALID_RO 3 VALID_R1 3 VALID_AB 3 VALID_MD 3
 VALID_DD 3 VALID_VD 3 ADULTS_C 3 ADULTS_1 3 ABBOTT_4 3 ROCHE_P4 3 ABBOTT_5 3 ROCHE_P5 3
 ROCHE_V4 3 VDBS_IND 3 MDBS_IND 3 DDBS_IND 3 ATLEAST_ 3 ABBOTT_A 3 ROCHE_AT 3 PLASMA_1 3
 ABBOTT_6 3 ABBOTT_7 3 ABBOTT_8 3 ABBOTT_9 3 V_DBSVL3 3 V_DBSVL4 3 V_DBSVL5 3 V_DBSVL6 3
 M_DBSVL3 3 M_DBSVL4 3 M_DBSVL5 3 M_DBSVL6 3 D_DBSVL3 3 D_DBSVL4 3 D_DBSVL5 3 D_DBSVL6 3
 ROCHE_P6 3 ROCHE_P7 3 ROCHE_P8 3 ROCHE_P9 3 ROCHE_V5 3 ROCHE_V6 3 ROCHE_V7 3 ROCHE_V8 3
 ABBOTT10 3 ABBOTT11 3 ABBOTT12 3 ABBOTT13 3 V_DBSVL7 3 V_DBSVL8 3 V_DBSVL9 3 V_DBSV10 3
 M_DBSVL7 3 M_DBSVL8 3 M_DBSVL9 3 M_DBSV10 3 D_DBSVL7 3 D_DBSVL8 3 D_DBSVL9 3 D_DBSV10 3
 ROCHE_10 3 ROCHE_11 3 ROCHE_12 3 ROCHE_13 3 ROCHE_V9 3 ROCHE_14 3 ROCHE_15 3 ROCHE_16 3
 V_DBSV11 3 M_DBSV11 3 D_DBSV11 3 ROCHE_17 3 AGE_LT_5 3 AGE_5_10 3 AGE_10_1 3 AGE_GE_1 3
 DOM_ALL 3 DOM_ALL_ 3 DOM_ALL1 3 DOM_ALL2 3 DOM_ALL3 3 DOM_ADUL 3 DOM_PEDS 3 DOM_ADU1 3
 DOM_PED1 3 VALID_RE 3 LOWEST_D 3 HIGHEST_ 3 I 3 LOWEST_1 $6 HIGHEST1 $6 VAL5_1 3
 VAL6_1 3 VAL7_1 3 VAL51 $2 VAL61 $2 VAL71 $2 AZT1 3 D4T1 3 NVP1 3
 EFV1 3 _3TC1 3 FTC1 3 TDF1 3 NFV1 3 ABC1 3 DDI1 3 KALETRA1 3
 OTHER1 3 _1DRG1 $3 _1DRG2 $3 _1DRG3 $3 _1DRG4 $3 _1DRG5 $3 _1DRG6 $3 _1DRG7 $3
 _1DRG8 $3 _1DRG9 $3 _1DRG10 $1 _1DRG11 $7 _1DRG12 $5 DRG1_HAA $8 DRG1_PRO $15 LOWEST_2 3
 HIGHEST2 3 LOWEST_3 $6 HIGHEST3 $6 VAL5_2 3 VAL6_2 3 VAL7_2 3 VAL52 $2 VAL62 $2
 VAL72 $2 AZT2 3 D4T2 3 NVP2 3 EFV2 3 _3TC2 3 FTC2 3 TDF2 3
 NFV2 3 ABC2 3 DDI2 3 KALETRA2 3 OTHER2 3 _2DRG1 $3 _2DRG2 $3 _2DRG3 $3
 _2DRG4 $3 _2DRG5 $3 _2DRG6 $1 _2DRG7 $3 _2DRG8 $1 _2DRG9 $3 _2DRG10 $3 _2DRG11 $7
 _2DRG12 $1 DRG2_HAA $8 DRG2_PRO $15 LOWEST_4 3 HIGHEST4 3 LOWEST_5 $6 HIGHEST5 $6 VAL5_3 3
 VAL6_3 3 VAL7_3 3 VAL53 $3 VAL63 $3 VAL73 $3 AZT3 3 D4T3 3 NVP3 3
 EFV3 3 _3TC3 3 FTC3 3 TDF3 3 NFV3 3 ABC3 3 DDI3 3 KALETRA3 3
 OTHER3 3 _3DRG1 $1 _3DRG2 $1 _3DRG3 $1 _3DRG4 $1 _3DRG5 $1 _3DRG6 $1 _3DRG7 $1
 _3DRG8 $1 _3DRG9 $1 _3DRG10 $1 _3DRG11 $1 _3DRG12 $1 DRG3_HAA $11 DRG3_PRO $1 LOWEST_6 3
 HIGHEST6 3 LOWEST_7 $1 HIGHEST7 $1 VAL5_4 3 VAL6_4 3 VAL7_4 3 VAL54 $4 VAL64 $4
 VAL74 $4 AZT4 3 D4T4 3 NVP4 3 EFV4 3 _3TC4 3 FTC4 3 TDF4 3
 NFV4 3 ABC4 3 DDI4 3 KALETRA4 3 OTHER4 3 _4DRG1 $1 _4DRG2 $1 _4DRG3 $1
 _4DRG4 $1 _4DRG5 $1 _4DRG6 $1 _4DRG7 $1 _4DRG8 $1 _4DRG9 $1 _4DRG10 $1 _4DRG11 $1
 _4DRG12 $1 DRG4_HAA $14 DRG4_PRO $1 LOWEST_8 3 HIGHEST8 3 LOWEST_9 $1 HIGHEST9 $1 VAL5_5 3
 VAL6_5 3 VAL7_5 3 VAL55 $5 VAL65 $5 VAL75 $5 AZT5 3 D5T5 3 NVP5 3
 EFV5 3 _3TC5 3 FTC5 3 TDF5 3 NFV5 3 ABC5 3 DDI5 3 KALETRA5 3
 OTHER5 3 _5DRG1 $1 D4T5 3 _5DRG2 $1 _5DRG3 $1 _5DRG4 $1 _5DRG5 $1 _5DRG6 $1
 _5DRG7 $1 _5DRG8 $1 _5DRG9 $1 _5DRG10 $1 _5DRG11 $1 _5DRG12 $1 DRG5_HAA $17 DRG5_PRO $1
 LOWEST10 3 HIGHES10 3 LOWEST11 $1 HIGHES11 $1 VAL5_6 3 VAL6_6 3 VAL7_6 3 VAL56 $1
 VAL66 $1 VAL76 $1 AZT6 3 D6T6 3 NVP6 3 EFV6 3 _3TC6 3 FTC6 3
 TDF6 3 NFV6 3 ABC6 3 DDI6 3 KALETRA6 3 OTHER6 3 _6DRG1 $1 D4T6 3
 _6DRG2 $1 _6DRG3 $1 _6DRG4 $1 _6DRG5 $1 _6DRG6 $1 _6DRG7 $1 _6DRG8 $1 _6DRG9 $1
 _6DRG10 $1 _6DRG11 $1 _6DRG12 $1 DRG6_HAA $1 DRG6_PRO $1 DRG1 3 DRG2 3 DRG3 3
 DRG4 3 DRG5 3 DRG6 3 DRGSCAN1 $3 DRGSCAN2 $3 DRGSCAN3 $7 SAMPLE_D 4 DATEINI6 $8
 DATEINI7 $8 DATEINI8 $8 DATEINI9 $8 DATEIN10 $8 DATEIN11 $8 DATEIN12 4 DATEIN13 4 DATEIN14 4
 DATEIN15 4 DATEIN16 4 DATEIN17 3 LOWEST_I 4 HIGHES12 4 LOWEST12 $12 HIGHES13 $12 SEX_INDI 3
 CD4NANDE 3 ADULTS_2 3 PEDS_RE2 3 ADULT_R1 3 DISCO_IN 3 FAIL_AD1 3 PLASMA_2 3 M_DBSPRE 3
 D_DBSPRE 3 V_DBSPRE 3
  ;;;
 set raw.clean_; 


 LABEL 
  FORM9FOR='Form9 FormNum' 
  STUDY_ID='Study ID' 
  PATIENTI='Patient ID' 
  FORM9ABB='Plasma available for testing on Abbott' 
  ABBOTT_P='Abbott Plasma VL copies/ml' 
  ABBOTT_1='Abbott Plasma VL copies/ml (log10)' 
  ABBOTT_2='Computed Abbott Plasma VL copies/ml (log10)' 
  FORM9PLA='Plasma_DateResults' 
  FORM9AB1='Microcapillary DBS Available for testing on Abbott' 
  M_DBSVLO='M-DBS VL copies/ml' 
  M_DBSVL1='M-DBS VL copies/ml (log10)' 
  M_DBSVL2='Computed M-DBS VL copies/ml (log10)' 
  FORM9M_D='M_DBSDateResults' 
  FORM9AB2='Direct DBS Available for testing on Abbott' 
  D_DBSVLO='D-DBS VL copies/ml' 
  D_DBSVL1='D-DBS VL copies/ml (log10)' 
  D_DBSVL2='Computed D-DBS VL copies/ml (log10)' 
  FORM9D_D='D_DBSDateResults' 
  V_DBSVLO='V-DBS VL copies/ml' 
  V_DBSVL1='V-DBS VL copies/ml (log10)' 
  V_DBSVL2='Computed V-DBS VL copies/ml (log10)' 
  FORM9AB3='Venous DBS Available for testing Abbott' 
  FORM9RE3='ResultEqual_V' 
  FORM9V_D='V_DBSDateResults' 
  FORM9DAT='DateReview' 
  M_DBS_VA='M_DBS_Valid' 
  D_DBS_VA='D_DBS_Valid' 
  V_DBS_VA='V_DBS_Valid' 
  ABBOTT_3='Abbott_Plasma_Valid' 
  FORM4FOR='Form 4 FormNum' 
  FORM4FAC='Facility Name' 
  FORM4FA1='Facility code' 
  DATEVBCO='Date of venous blood collection' 
  TIMEVBCO='Time of venous blood collection' 
  COLLECTO='Plasma collector initials/code' 
  DATEVBC1='Date of capillary blood collection and DBS preparation' 
  COLLECT1='DBS collector initials/code' 
  CAPILLAR='Capillary puncture type' 
  M_DBSSPO='No. of spots on the card (M-DBS)' 
  D_DBSSPO='No.of spots on the card (D-DBS)' 
  V_DBSSPO='No. of spots on the card (V-DBS)' 
  DATERECI='Date sample received at CRC' 
  TIMERECE='Time sample received at cRC' 
  DATEREC1='Date sample received at Kisian/NHRL' 
  TIMEREC1='Time sample received at Kisian/NHRL' 
  AMPMREC1='AMPMReceived_KisianNHRL' 
  ACCEPTR2='AcceptReject_CRC2' 
  ACCEPTR5='AcceptReject_KisianNHRL3' 
  ROCHE_VD='CAP/CTM V-DBS VL copies/ml' 
  ROCHE_V1='CAP/CTM V-DBS VL copies/ml (log 10)' 
  ROCHE_V2='Computed CAP/CTM V-DBS VL copies/ml (log 10)' 
  ROCHE_V3='Roche_VDBS_Valid' 
  FORM3FOR='Form 3 FormNum' 
  FORM3DAT='DateRecieved_CRC' 
  FORM3ACC='AcceptReject_CRC' 
  FORM3REA='Reason_RejectionCRC' 
  FORM3DA1='DateRecieved' 
  FORM3RE1='Reason_RejectionKisian' 
  FORM3RE2='Reason_RejectionNHRL' 
  ROCHE_PL='CAP/CTM Plasma VL copies/ml' 
  ROCHE_P1='CAP/CTM Plasma VL copies/ml (log 10)' 
  ROCHE_P2='Computed CAP/CTM Plasma VL copies/ml (log 10)' 
  FORM3DA2='DateAnalysis' 
  FORM3RES='ResultEqual' 
  ROCHE_P3='Roche_Plasma_Valid' 
  FORM1FOR='Form1 FormNum' 
  FORM1FAC='Facility Name' 
  FORM1STU='Study Site ID' 
  FACILITY='Facility Code' 
  FORM1DAT='Date enrolled' 
  FORM1CHI='Child assent form signed' 
  FORM1ADU='Adult consent form signed?' 
  FORM1PAR='Parent/Guardian consent form signed?' 
  FORM1CON='Consent for sample storage signed?' 
  FORM1PED='Pediatric(<18yrs) or Adult potential participant?' 
  FORM1AGR='Agreed to give Venous blood sample?' 
  FORM1AG1='Agreed to give Capillary blood sample?' 
  FORM1CHE='Checked by' 
  FORM1DA1='Date checked' 
  FORM1DA2='Date reviewed' 
  FORM1REV='Reviewed by' 
  FORM2FOR='Form2 FormNum' 
  PROVINCE='Province_name' 
  DISTRICT='District_name' 
  FORM2FAC='FacilityName' 
  FORM2FA1='Facility_type' 
  FORM2FIR='FirstName' 
  FORM2SUR='SurName' 
  BIRTHDAT='Date of Birth' 
  SEX='Sex' 
  CLINICAL='ClinicalIndication' 
  RECURREN='New or recurrent WHO Stage 3/4 conditions after >= 6 months on ART' 
  RECURRE1='New or recurrent PPE after >= 6 months on ART' 
  ADDITION='AdditionalChild' 
  DECLINEG='Poor or decline in growth despite ART >= 6 months' 
  FAILUREN='Failure to meet neuro-developmental milestones after >= 6 months of ART' 
  RECURRE2='Recurrence of infections that are severe, persistent or refractory to treatment' 
  IMMUNIND='ImmunIndication' 
  CD4NORES='Failure of CD4 count to rise to >100 cells/mm3 after at least 12 months after in' 
  PERSISTL='Persistent CD4 levels below 100 cells/mm3 12 months after initiating ART' 
  CD4FALL='CD4 (count or percent) fall to baseline or below >=6 months after initiating ART' 
  CD4FALLP='CD4 (CD4 count or percent) fall by > 30% of peak value >= 6 months after initiat' 
  OTHERREA='OtherReasons' 
  ASSESSME='Assessment of patients prior to single drug substitution to a second line ARV dr' 
  OPTIMIZI='Optimizing ART in women falling pregnant after >= 6 months of ART' 
  REPEATVL='RepeatVL' 
  PATIENTO='PatientOI' 
  OISPECIF='OIspecify_1' 
  PATIENTR='PatientrecurrentOI' 
  OISPECI1='OIspecify_2' 
  PATIENTT='PatientTB' 
  PHASESTB='PhasesTB' 
  TOXICITY='Toxicityspecify_1' 
  ARVTOXIC='ARVToxicity' 
  TOXICIT1='Toxicityspecify_2' 
  PATIENTP='PatientPreg' 
  BASELINE='BaselineDate' 
  PEAKDATE='PeakDate' 
  CURRENTD='CurrentDate' 
  BASELIN1='BaselineCD4' 
  PEAKCD4='PeakCD4' 
  CURRENTC='CurrentCD4' 
  BASELIN2='BaselineChildCD4' 
  PEAKCHIL='PeakChildCD4' 
  CURRENT1='CurrentChildCD4' 
  PREVIOUS='PreviousVLTest' 
  DATERECE='DateRecentTest' 
  DRUG1A='Drug1a' 
  DRUG1B='Drug1b' 
  DRUG1C='Drug1c' 
  DATEINIT='Dateinit1' 
  DATEDISC='Datedisc1' 
  DISCONTI='Discontinued1' 
  INDICATI='IndicationARV1' 
  DRUG2A='Drug2a' 
  DRUG2B='Drug2b' 
  DRUG2C='Drug2c' 
  DATEINI1='Dateinit2' 
  DATEDIS1='Datedisc2' 
  DISCONT1='Discontinued2' 
  INDICAT1='IndicationARV2' 
  DRUG3A='Drug3a' 
  DRUG3B='Drug3b' 
  DRUG3C='Drug3c' 
  DATEINI2='Dateinit3' 
  DATEDIS2='Datedisc3' 
  DISCONT2='Discontinued3' 
  INDICAT2='IndicationARV3' 
  DRUG4A='Drug4a' 
  DRUG4B='Drug4b' 
  DRUG4C='Drug4c' 
  DATEINI3='Dateinit4' 
  DATEDIS3='Datedisc4' 
  DISCONT3='Discontinued4' 
  INDICAT3='IndicationARV4' 
  DRUG5A='Drug5a' 
  DRUG5B='Drug5b' 
  DRUG5C='Drug5c' 
  DATEINI4='Dateinit5' 
  DATEDIS4='Datedisc5' 
  DISCONT4='Discontinued5' 
  INDICAT4='IndicationARV5' 
  DRUG6A='Drug6a' 
  DRUG6B='Drug6b' 
  DRUG6C='Drug6c' 
  DATEINI5='Dateinit6' 
  DATEDIS5='Datedisc6' 
  DISCONT5='Discontinued6' 
  INDICAT5='IndicationARV6' 
  OTHEREAS='OthereasonSpecify1' 
  OTHEREA1='OthereasonSpecify2' 
  OTHEREGI='OtheregimenSpecify' 
  MISSEDAR='MissedARV_lst2wks' 
  DAYSMISS='DaysMissed_Pills' 
  MISSED_A='Missed_ARVClinic' 
  PERCEPTA='PerceptAdhere' 
  OTHERDRU='OtherDrugs' 
  RIFAMPIC='Rifampicin' 
  FLUCONAZ='Fluconazole' 
  KETOCONA='Ketoconazole' 
  DAPSONE='Dapsone' 
  COTRIMOX='Cotrimox' 
  CONTRACE='Contraceptives' 
  MULTIVIT='Multivitamin' 
  OTHERARV='OtherARVSpecify' 
  OTHERAR1='OtherARVSpecify_2' 
  OTHER='Other' 
  FACILIT1='Study site' 
  PROV_COD='Province' 
  LAB_COL_='Plasma collector initials/code' 
  LAB_COL1='DBS collector initials/code' 
  AGE='Age' 
  DOB='Date of birth' 
  M_DBS_AC='M-DBS sample accepted' 
  D_DBS_AC='D-DBS sample accepted' 
  V_DBS_AC='V-DBS sample accepted' 
  VB_COLLE='Venous Blood Collected' 
  ABBOTT_D='Abbott DBS Collected' 
  AGEGRP4='Age category' 
  AGE_PEDS='Peds' 
  AGE_ADUL='Adults' 
  AGEGROUP='Age group' 
  GT_1_ARV='Have been on > 1 ART regimen' 
  AZT_REGI='AZT-based regimen' 
  TDF_REGI='TDF-based regimen' 
  D4T_REGI='d4T-based regimen' 
  ADULT_OT='Other regimen' 
  ADULT_RE='Current ART regimen' 
  NVP_REGI='NVP-based regimen' 
  EFV_REGI='EFV-based regimen' 
  KALETRA_='PI/Kaletra-based regimen' 
  PEDS_OTH='Other regimen' 
  PEDS_REG='Current ART regimen' 
  PEDS_RE1='Current ART regimen' 
  DISCO_RE='Toxicity' 
  DISCO_R1='Treatment failure' 
  DISCO_R2='Other drug use' 
  DISCO_R3='Other' 
  REASON_D='Reason for change/switch/discontinuation' 
  FAIL_PED='Had 1 or more indication for viral load' 
  FAIL_ADU='Had 1 or more indication for viral load' 
  TARGET_A='VL indication due to clinical or immunological failure' 
  ROUTINE_='VL indication with optimizing ART in pregnant women and with single drug substit' 
  VL_INDIC='Indication for Viral Load test' 
  ADULT_CL='VF by VL indication among adults' 
  PEDS_ASS='VF among patients with VL indication of single-drug substition or no VL indicati' 
  PEDS_CLI='VF by VL indication among peds' 
  PEDS_CL1='VF among peds with VL clinical or immunological indication' 
  PEDS_CL2='VF among peds with VL clinical or immunological indication' 
  GENDER='Gender' 
  ADULT_AG='Adult age categories' 
  SAMPLE_L='Duration of ART (Months)' 
  ART_ADUL='Duration on ART (Months)' 
  ART_PEDS='Duration on ART (Months)' 
  ART_PED1='Duration on ART (Months)' 
  ADULT_VL='Had 1 or more indication for viral load' 
  PEDS_VL_='Had 1 or more indication for viral load' 
  PLASMA_A='Plasma sample accepted' 
  REASON_P='Reason plasma sample rejected' 
  REASON_M='Reason M-DBS sample rejected' 
  REASON_5='Reason D-DBS sample rejected' 
  REASON_V='Reason V-DBS sample rejected' 
  DATE_SAM='Date of sample collection' 
  DATE_PLA='Date of Plasma sample collection' 
  DATE_PL1='Date Plasma sample received at CRC' 
  DATE_PL2='Date Plasma sample received at Kisian/NHRL' 
  DATE_DBS='Date of venous blood collection' 
  DATE_DB1='Date of capilary blood collection and DBS preparation' 
  DATE_DB2='Date DBS sample received at CRC' 
  DATE_DB3='Data DBS sample received at Kisian/NHRL' 
  PLASMA_C='Date difference between plasma collection and receipt at CRC' 
  PLASMA_L='Date difference between plasma collection and receipt at Kisian/NHRL' 
  DBS_CRC_='Date difference between DBS collection and receipt at CRC' 
  DBS_LAB_='Date difference between DBS collection and receipt at Kisian/NHRL' 
  ABBOTT_4='Abbott Plasma VL copies/ml categories' 
  ROCHE_P4='CAP/CTM Plasma VL copies/ml categories' 
  ABBOTT_6='VL failure (> 550 copies/ml)' 
  ABBOTT_7='VL failure (> 1000 copies/ml)' 
  ABBOTT_8='VL failure (> 3000 copies/ml)' 
  ABBOTT_9='VL failure (> 5000 copies/ml)' 
  V_DBSVL3='VL failure (> 550 copies/ml)' 
  V_DBSVL4='VL failure (> 1000 copies/ml)' 
  V_DBSVL5='VL failure (> 3000 copies/ml)' 
  V_DBSVL6='VL failure (> 5000 copies/ml)' 
  M_DBSVL3='VL failure (> 550 copies/ml)' 
  M_DBSVL4='VL failure (> 1000 copies/ml)' 
  M_DBSVL5='VL failure (> 3000 copies/ml)' 
  M_DBSVL6='VL failure (> 5000 copies/ml)' 
  D_DBSVL3='VL failure (> 550 copies/ml)' 
  D_DBSVL4='VL failure (> 1000 copies/ml)' 
  D_DBSVL5='VL failure (> 3000 copies/ml)' 
  D_DBSVL6='VL failure (> 5000 copies/ml)' 
  ROCHE_P6='VL failure (> 550 copies/ml)' 
  ROCHE_P7='VL failure (> 1000 copies/ml)' 
  ROCHE_P8='VL failure (> 3000 copies/ml)' 
  ROCHE_P9='VL failure (> 5000 copies/ml)' 
  ROCHE_V5='VL failure (> 550 copies/ml)' 
  ROCHE_V6='VL failure (> 1000 copies/ml)' 
  ROCHE_V7='VL failure (> 3000 copies/ml)' 
  ROCHE_V8='VL failure (> 5000 copies/ml)' 
  ABBOTT10='Abbott Plasma VL copies/ml (< 1,000) copies/ml' 
  ABBOTT11='Abbott Plasma VL copies/ml (1,000 to < 10,000) copies/ml' 
  ABBOTT12='Abbott Plasma VL copies/ml (10,000 to < 100,000) copies/ml' 
  ABBOTT13='Abbott Plasma VL copies/ml (>= 100,000) copies/ml' 
  V_DBSVL7='V-DBS VL copies/ml (< 1,000) copies/ml' 
  V_DBSVL8='V-DBS VL copies/ml (1,000 to < 10,000) copies/ml' 
  V_DBSVL9='V-DBS VL copies/ml (10,000 to < 100,000) copies/ml' 
  V_DBSV10='V-DBS VL copies/ml (>= 100,000) copies/ml' 
  M_DBSVL7='M-DBS VL copies/ml (< 1,000) copies/ml' 
  M_DBSVL8='M-DBS VL copies/ml (1,000 to < 10,000) copies/ml' 
  M_DBSVL9='M-DBS VL copies/ml (10,000 to < 100,000) copies/ml' 
  M_DBSV10='M-DBS VL copies/ml (>= 100,000) copies/ml' 
  D_DBSVL7='D-DBS VL copies/ml (< 1,000) copies/ml' 
  D_DBSVL8='D-DBS VL copies/ml (1,000 to < 10,000) copies/ml' 
  D_DBSVL9='D-DBS VL copies/ml (10,000 to < 100,000) copies/ml' 
  D_DBSV10='D-DBS VL copies/ml (>= 100,000) copies/ml' 
  ROCHE_10='CAP/CTM Plasma VL copies/ml (< 1,000) copies/ml' 
  ROCHE_11='CAP/CTM Plasma VL copies/ml (1,000 to < 10,000) copies/ml' 
  ROCHE_12='CAP/CTM Plasma VL copies/ml (10,000 to < 100,000) copies/ml' 
  ROCHE_13='CAP/CTM Plasma VL copies/ml (>= 100,000) copies/ml' 
  ROCHE_V9='CAP/CTM V-DBS VL copies/ml (< 1,000) copies/ml' 
  ROCHE_14='CAP/CTM V-DBS VL copies/ml (1,000 to < 10,000) copies/ml' 
  ROCHE_15='CAP/CTM V-DBS VL copies/ml (10,000 to < 100,000) copies/ml' 
  ROCHE_16='CAP/CTM V-DBS VL copies/ml (>= 100,000) copies/ml' 
  V_DBSV11='V-DBS VL copies/ml categories' 
  M_DBSV11='M-DBS VL copies/ml categories' 
  D_DBSV11='D-DBS VL copies/ml categories' 
  ROCHE_17='CAP/CTM V-DBS VL copies/ml categories' 
 ;;;

format  SEX sexf. RECURREN yesnof. RECURRE1 yesnof. DECLINEG yesnof. FAILUREN yesnof.
 RECURRE2 yesnof. CD4NORES yesnof. PERSISTL yesnof. CD4FALL yesnof. CD4FALLP yesnof.
 ASSESSME yesnof. OPTIMIZI yesnof. FACILIT1 codef. PROV_COD prov_codef. M_DBS_AC yesnof.
 D_DBS_AC yesnof. V_DBS_AC yesnof. VB_COLLE yesnof. ABBOTT_D yesnof. AGEGRP4 agegrp4f.
 AGEGROUP agegroupf. GT_1_ARV yesnof. AZT_REGI yesnof. TDF_REGI yesnof. D4T_REGI yesnof.
 ADULT_OT yesnof. ADULT_RE adult_regimen_catf. PEDS_OTH yesnof. PEDS_REG peds_regimen_catf. PEDS_RE1 peds_regimen_cat2f.
 DISCO_RE yesnof. DISCO_R1 yesnof. DISCO_R2 yesnof. DISCO_R3 yesnof. REASON_D reason_discontinuef.
 FAIL_PED yesnof. FAIL_ADU yesnof. TARGET_A yesnof. VL_INDIC vl_indicatorf. ADULT_CL vl_indicator_adultf.
 PEDS_ASS yesnof. PEDS_CLI vl_indicator_pedsf. PEDS_CL1 yesnof. PEDS_CL2 yesnof. GENDER sexf.
 ADULT_AG adult_age_catf. ART_ADUL art_adult_time_catf. ART_PEDS art_peds_time_catf. ART_PED1 art_peds_time_cat2f. ADULT_VL yesnof.
 PEDS_VL_ yesnof. PLASMA_A yesnof. AGEGRP3 agegrp3f. AZT_3TC_ yesnof. ABC_3TC_ yesnof.
 D4T_3TC_ yesnof. ADULT_C1 yesnof. PEDS_CL3 yesnof. IMMUNOLO yesnof. OPTIMIZE yesnof.
 VALID_RO yesnof. VALID_R1 yesnof. VALID_AB yesnof. VALID_MD yesnof. VALID_DD yesnof.
 VALID_VD yesnof. ADULTS_C yesnof. ADULTS_1 yesnof. ABBOTT_4 vlnumf. ROCHE_P4 vlnumf.
 ABBOTT_6 yesnof. ABBOTT_7 yesnof. ABBOTT_8 yesnof. ABBOTT_9 yesnof. V_DBSVL3 yesnof.
 V_DBSVL4 yesnof. V_DBSVL5 yesnof. V_DBSVL6 yesnof. M_DBSVL3 yesnof. M_DBSVL4 yesnof.
 M_DBSVL5 yesnof. M_DBSVL6 yesnof. D_DBSVL3 yesnof. D_DBSVL4 yesnof. D_DBSVL5 yesnof.
 D_DBSVL6 yesnof. ROCHE_P6 yesnof. ROCHE_P7 yesnof. ROCHE_P8 yesnof. ROCHE_P9 yesnof.
 ROCHE_V5 yesnof. ROCHE_V6 yesnof. ROCHE_V7 yesnof. ROCHE_V8 yesnof. V_DBSV11 vlnumf.
 M_DBSV11 vlnumf. D_DBSV11 vlnumf. ROCHE_17 vlnumf.
 ;;;

format  FORM9FOR 11.0 FORM9ABB 6.0 ABBOTT_P BEST12. ABBOTT_1 BEST10. ABBOTT_2 BEST10.
 FORM9PLA BEST10. FORM9AB1 6.0 M_DBSVLO BEST12. M_DBSVL1 BEST10. M_DBSVL2 BEST10.
 FORM9RES 11.0 FORM9M_D BEST12. FORM9AB2 6.0 D_DBSVLO BEST12. D_DBSVL1 BEST10.
 D_DBSVL2 BEST10. FORM9RE1 11.0 FORM9D_D BEST10. V_DBSVLO BEST12. V_DBSVL1 BEST10.
 V_DBSVL2 BEST10. FORM9RE2 11.0 FORM9AB3 6.0 FORM9RE3 11.0 FORM9V_D BEST10.
 FORM9DAT BEST10. M_DBS_VA BEST8. D_DBS_VA BEST8. V_DBS_VA BEST8. ABBOTT_3 BEST8.
 FORM4FOR 11.0 DATEVBCO BEST12. DATEVBC1 BEST12. CAPILLAR 6.0 M_DBSSPO 6.0
 D_DBSSPO 6.0 V_DBSSPO 6.0 DATERECI BEST12. DATEREC1 BEST12. ACCEPTRE 6.0
 ACCEPTR1 6.0 ACCEPTR2 6.0 ACCEPTR3 6.0 ACCEPTR4 6.0 ACCEPTR5 6.0
 ROCHE_VD BEST12. ROCHE_V1 BEST10. ROCHE_V2 BEST10. ROCHE_V_ BEST12. D_DBS_CO BEST8.
 M_DBS_CO BEST8. V_DBS_CO BEST8. ROCHE_V3 BEST8. FORM3FOR 11.0 FORM3DAT BEST12.
 FORM3ACC 6.0 FORM3DA1 BEST12. ROCHE_PL BEST12. ROCHE_P1 BEST10. ROCHE_P2 BEST10.
 FORM3DA2 BEST12. FORM3RES 6.0 ROCHE_P3 BEST8. FORM1FOR 11.0 FORM1DAT BEST12.
 FORM1ADU 6.0 FORM1PAR 6.0 FORM1CON 6.0 FORM1PED BEST8. FORM1AGR 6.0
 FORM1AG1 6.0 FORM1DA1 BEST12. FORM1DA2 BEST12. FORM1FO1 BEST12. FORM2FOR 11.0
 FORM2FA1 6.0 BIRTHDAT BEST12. DATECOLL BEST12. REPEATVL 6.0 PATIENTO 6.0
 PATIENTR 6.0 PATIENTT 6.0 PHASESTB 6.0 ARVTOXIC 6.0 BASELIN1 6.0
 PEAKCD4 6.0 CURRENTC 6.0 BASELIN2 BEST10. PEAKCHIL BEST10. CURRENT1 BEST10.
 PREVIOUS 6.0 DRUG1A 6.0 DRUG1B 6.0 DRUG1C 6.0 DISCONTI 6.0
 INDICATI 6.0 DRUG2A 6.0 DRUG2B 6.0 DRUG2C 6.0 DISCONT1 6.0
 INDICAT1 6.0 DRUG3A 6.0 DRUG3B 6.0 DRUG3C 6.0 DISCONT2 6.0
 INDICAT2 6.0 DRUG4A 6.0 DRUG4B 6.0 DRUG4C 6.0 DISCONT3 6.0
 INDICAT3 6.0 DRUG5A 6.0 DRUG5B 6.0 DRUG5C 6.0 DISCONT4 6.0
 INDICAT4 6.0 DRUG6A 6.0 DRUG6B 6.0 DRUG6C 6.0 DISCONT5 6.0
 INDICAT5 6.0 MISSEDAR 6.0 DAYSMISS 6.0 MISSED_A 6.0 RIFAMPIC 6.0
 FLUCONAZ 6.0 KETOCONA 6.0 DAPSONE 6.0 COTRIMOX 6.0 CONTRACE 6.0
 MULTIVIT 6.0 OTHER 6.0 INFORM1 BEST8. INFORM2 BEST8. INFORM3 BEST8.
 INFORM4 BEST8. INFORM9 BEST8. LOG_DIFF BEST10. LOG_DIF1 BEST10. LOG_DIF2 BEST10.
 LOG_DIF3 BEST10. LOG_DIF4 BEST10. LOG_DIF5 BEST10. LOG_DIF6 BEST10. LOG_DIF7 BEST10.
 LOG_DIF8 BEST10. LOG_DIF9 BEST10. OLD_AGE BEST8. AGE BEST10. DOB DDMMYY10.
 AGE_PEDS BEST8. AGE_ADUL BEST8. NVP_REGI BEST8. EFV_REGI BEST8. KALETRA_ BEST8.
 ROUTINE_ BEST8. SAMPLE_L BEST10. DATE_SAM DDMMYY10. DATE_PLA DDMMYY10. DATE_PL1 DDMMYY10.
 DATE_PL2 DDMMYY10. DATE_DBS DDMMYY10. DATE_DB1 DDMMYY10. DATE_DB2 DDMMYY10. DATE_DB3 DDMMYY10.
 PLASMA_C BEST8. PLASMA_L BEST8. DBS_CRC_ BEST8. DBS_LAB_ BEST8. ABBOTT_5 BEST8.
 ROCHE_P5 BEST8. ROCHE_V4 BEST8. VDBS_IND BEST8. MDBS_IND BEST8. DDBS_IND BEST8.
 ATLEAST_ BEST8. ABBOTT_A BEST8. ROCHE_AT BEST8. PLASMA_1 BEST8. ABBOTT10 BEST8.
 ABBOTT11 BEST8. ABBOTT12 BEST8. ABBOTT13 BEST8. V_DBSVL7 BEST8. V_DBSVL8 BEST8.
 V_DBSVL9 BEST8. V_DBSV10 BEST8. M_DBSVL7 BEST8. M_DBSVL8 BEST8. M_DBSVL9 BEST8.
 M_DBSV10 BEST8. D_DBSVL7 BEST8. D_DBSVL8 BEST8. D_DBSVL9 BEST8. D_DBSV10 BEST8.
 ROCHE_10 BEST8. ROCHE_11 BEST8. ROCHE_12 BEST8. ROCHE_13 BEST8. ROCHE_V9 BEST8.
 ROCHE_14 BEST8. ROCHE_15 BEST8. ROCHE_16 BEST8. AGE_LT_5 BEST8. AGE_5_10 BEST8.
 AGE_10_1 BEST8. AGE_GE_1 BEST8. DOM_ALL BEST8. DOM_ALL_ BEST8. DOM_ALL1 BEST8.
 DOM_ALL2 BEST8. DOM_ALL3 BEST8. DOM_ADUL BEST8. DOM_PEDS BEST8. DOM_ADU1 BEST8.
 DOM_PED1 BEST8. VALID_RE BEST8. LOWEST_D BEST8. HIGHEST_ BEST8. I BEST8.
 VAL5_1 BEST8. VAL6_1 BEST8. VAL7_1 BEST8. AZT1 BEST8. D4T1 BEST8.
 NVP1 BEST8. EFV1 BEST8. _3TC1 BEST8. FTC1 BEST8. TDF1 BEST8.
 NFV1 BEST8. ABC1 BEST8. DDI1 BEST8. KALETRA1 BEST8. OTHER1 BEST8.
 LOWEST_2 BEST8. HIGHEST2 BEST8. VAL5_2 BEST8. VAL6_2 BEST8. VAL7_2 BEST8.
 AZT2 BEST8. D4T2 BEST8. NVP2 BEST8. EFV2 BEST8. _3TC2 BEST8.
 FTC2 BEST8. TDF2 BEST8. NFV2 BEST8. ABC2 BEST8. DDI2 BEST8.
 KALETRA2 BEST8. OTHER2 BEST8. LOWEST_4 BEST8. HIGHEST4 BEST8. VAL5_3 BEST8.
 VAL6_3 BEST8. VAL7_3 BEST8. AZT3 BEST8. D4T3 BEST8. NVP3 BEST8.
 EFV3 BEST8. _3TC3 BEST8. FTC3 BEST8. TDF3 BEST8. NFV3 BEST8.
 ABC3 BEST8. DDI3 BEST8. KALETRA3 BEST8. OTHER3 BEST8. LOWEST_6 BEST8.
 HIGHEST6 BEST8. VAL5_4 BEST8. VAL6_4 BEST8. VAL7_4 BEST8. AZT4 BEST8.
 D4T4 BEST8. NVP4 BEST8. EFV4 BEST8. _3TC4 BEST8. FTC4 BEST8.
 TDF4 BEST8. NFV4 BEST8. ABC4 BEST8. DDI4 BEST8. KALETRA4 BEST8.
 OTHER4 BEST8. LOWEST_8 BEST8. HIGHEST8 BEST8. VAL5_5 BEST8. VAL6_5 BEST8.
 VAL7_5 BEST8. AZT5 BEST8. D5T5 BEST8. NVP5 BEST8. EFV5 BEST8.
 _3TC5 BEST8. FTC5 BEST8. TDF5 BEST8. NFV5 BEST8. ABC5 BEST8.
 DDI5 BEST8. KALETRA5 BEST8. OTHER5 BEST8. D4T5 BEST8. LOWEST10 BEST8.
 HIGHES10 BEST8. VAL5_6 BEST8. VAL6_6 BEST8. VAL7_6 BEST8. AZT6 BEST8.
 D6T6 BEST8. NVP6 BEST8. EFV6 BEST8. _3TC6 BEST8. FTC6 BEST8.
 TDF6 BEST8. NFV6 BEST8. ABC6 BEST8. DDI6 BEST8. KALETRA6 BEST8.
 OTHER6 BEST8. D4T6 BEST8. DRG1 BEST8. DRG2 BEST8. DRG3 BEST8.
 DRG4 BEST8. DRG5 BEST8. DRG6 BEST8. SAMPLE_D DDMMYY10. DATEIN12 DDMMYY10.
 DATEIN13 DDMMYY10. DATEIN14 DDMMYY10. DATEIN15 DDMMYY10. DATEIN16 DDMMYY10. DATEIN17 DDMMYY10.
 LOWEST_I DDMMYY10. HIGHES12 BEST8. SEX_INDI BEST8. CD4NANDE BEST8. ADULTS_2 BEST8.
 PEDS_RE2 BEST8. ADULT_R1 BEST8. DISCO_IN BEST8. FAIL_AD1 BEST8. PLASMA_2 BEST8.
 M_DBSPRE BEST8. D_DBSPRE BEST8. V_DBSPRE BEST8.
  ;;; 
run;
 %let lib_error=&syserr.; 


proc printto print= "C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS\data\xpt\clean_vldbs_SAScheck.lst" new; 

 title "data= C:\Users\mwj6\OneDrive - CDC\+My_Documents\Muthusi\PhD\Diagnostic testing\SAS\data\xpt\clean_vldbs: Compare results with Stata output."; 

 proc means    data= out.clean_vldbs; run;

 proc contents data= out.clean_vldbs; run;

 proc print    data= out.clean_vldbs (obs=5); run; 

 proc printto; run; 
