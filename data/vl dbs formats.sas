* Create formats for VL DBS database;
%let root=C:\PhD\SAS\data\DBS_analysis\data_a;

* Create a working library;
libname data "&root";

proc format cntlout=data.fmtcntl;
proc format ;
value sexf					1='Male'
							2='Female';

value immunindicf			1='CD4 No Response'
							2='Persist Low CD4'
							3='CD4 Fall'
							4='CD4 Fall Peak';

value vload_catf			1='Lower limit of detection'
							2='40-999 copies/mL'
							3='1000-2999 copies/mL'
							4='3000-9999 copies/mL'
							5='> 10,000 copies/mL';	
 
value substitutionf			1='Yes'
							0='No';

value comparison1_plasf		1='<=1,000 copies/ml'
							2='=>1,000 copies/ml';

value comparison2_plasf		1='<=10,000 copies/ml'
							2='=>10,000 copies/ml';

value comparison3_plasf		1='<=100,000 copies/ml'
							2='=>100,000 copies/ml';

value comparison1_rocf		1='<=500 copies/ml'
							2='=>500 copies/ml';

value comparison2_rocf		1='<=1000 copies/ml'
							2='=>1000 copies/ml';

value comparison3_rocf		1='<=5000 copies/ml'
							2='=>5000 copies/ml';

value vlnumf				1="<1,000 copies/ml"
							2="1,000-9,999 copies/ml"
							3="10,000-99,999 copies/ml"
							4=">=100,000 copies/ml"
							.="Total";

value agegrpf				1='ped<5 years'
							2='ped>=5to<5 years'
							3='>=15 years';

value plasma_grpf			1='<1000 IU/mL'
							2='>=1000 IU/mL';

value regionf				1='Nairobi'
							2='Nyanza North'
							3='Nyanza South'; 

value yesnof 				1='Yes'
							0='No';

value agegrp5f				1='Ped <5 years'
							2='Ped >= 5 to <10'
							3='Ped >= 10 to <15'
							4='Total Peds'
							5='Adults >= 15';

value plasma_catf			1='>=550 copies/mL'
							2='<550 copies/mL';

value vload_catf			1='>=550 copies/mL'
							2='<550 copies/mL';

value agegrp1f				1='Ped <12 years'
							2='Ped >= 12 to <18'
							3='Adults >= 18';

value agegroupf				1='Peds < 15'
							2='Adults >= 15';							;

value agegroup2f			1='Peds < 15'
							2='Adults(>= 15)'
							199='Total';

value agegrp2f				1='Ped <5 years'
							2='Ped >= 5 to <10'
							3='Ped >= 10 to <15'
							4='Adults >= 15';

value agegrp3f				1='Ped <12 years'
							2='Ped >= 12 to <18'
							3='Adults >= 18';

value agegrp4f				1='Ped <5 years'
							2='Ped >= 5 to <10'
							3='Ped >= 10 to <15'
							4='Adults >= 15';

value codef
							1='LVCT'
							2='NAZARETH'
							3='BARAKA'
							4='LUMUMBA'
							5='KISUMU EAST'
							6='NYANZA JOOTRH'
							7='SIAYA DH'
							8='MIGORI DH'
							9='RONGO DH'
							10='SUBA DH'
							11='ST CAMILLUS'
							12='HOMA BAY DH'
							99='Total';
value $sitecodef
							'01'='LVCT'
							'02'='NAZARETH'
							'03'='BARAKA'
							'04'='LUMUMBA'
							'05'='KISUMU EAST'
							'06'='NYANZA JOOTRH'
							'07'='SIAYA DH'
							'08'='MIGORI DH'
							'09'='RONGO DH'
							'10'='SUBA DH'
							'11'='ST CAMILLUS'
							'12'='HOMA BAY DH';

value prov_codef
							1="Nairobi"
							2="Nyanza";

value adult_age_catf		1="15-20"
							2="21-30"
							3="31-40"
							4=">40";

value art_adult_time_catf	1="< 12 months"
							2="12-36 months"
							3="37-60 months"
							4="> 60 months";

value art_peds_time_catf	1="< 12 months"
							2="12-25 months"
							3="26-36 months"
							4="37-48 months"
							5="49-60 months"
							6="> 60 months";

value art_peds_time_cat2f	1="< 24 months"
							2="25-48 months"
							3="> 48 months";

value adult_regimen_catf	1="NVP based"
							2="EFV based"
							3="PI/Kaletra based"
							4="Other regimen";

value peds_regimen_catf		1="NVP based"
							2="EFV based"
							3="PI/Kaletra based"
							4="Other regimen";

value peds_regimen_cat2f	1="NNRTI based"
							2="PI/Kaletra based"
							3="Other regimen";

value vl_indicatorf
							1="New or recurrent WHO Stage 3/4 conditions after >= 6 months on ART" 
							2="New or recurrent PPE after >= 6 months on ART" 
							3="Poor or decline in growth despite ART >= 6 months"
							4="Failure to meet neuro-developmental milestones after >= 6 months of ART"
							5="Recurrence of infections that are severe, persistent or refractory to treatment after >= 6 months of ART"
							6="Failure of CD4 count to rise to >100 cells/mm3 after at least 12 months after initiating ART"
							7="Persistent CD4 levels below 100 cells/mm3 12 months after initiating ART"
							8="CD4 (count or percent) fall to baseline or below >=6 months after initiating ART"
							9="CD4 (CD4 count or percent) fall by > 30% of peak value >= 6 months after initiating ART"
							10="Assessment of patients prior to single drug substitution to a second line ARV drug after >= 6 months of ART"
							11="Optimizing ART in women falling pregnant after >= 6 months of ART"
							;

value reason_discontinuef
							1='Toxicity'
							2='Treatment failure'
							3='Other drug use'
							4='Other'
							;

value vl_indicator_adultf	1="VF among adults with VL clinical or immunological indication"
							2="VF among adults with VL indication of optimizing ART in women pregnant or single drug substitution"
							;

value vl_indicator_pedsf	1="VF among peds with VL clinical or immunological indication"
							2="VF among peds with VL indication of single-drug substition or no VL indication"
							;

value Reason_Plasma_Reject_a_f	1="S - 04"
								;

value Reason_MDBS_Reject_a_f	1="S - 02 S - 03 S - 04 S - 05 S - 07 S - 08 S - 09 S - 10 S - 11"
								2="S - 09 S - 10"
								3="S - 10"
								4="S - 11"
								;

value Reason_DDBS_Reject_a_f	1="S - 01 S - 02"
								2="S - 09"
								3="S - 10"
								4="S - 10 S - 11"
								;

value Reason_VDBS_Reject_a_f	1="S - 01 S - 02 S - 08"
								2="S - 09"
								3="S - 09 S - 10 S - 11"
								4="S - 10"
								5="S - 10 S - 11"
								6="S - 11"
								;

value reason_reject_f	1="S - 01"
						2="S - 02"
						3="S - 03"
						4="S - 04"
						5="S - 05"
						6="S - 06"
						7="S - 07"
						8="S - 08"
						9="S - 09"
						10="S - 10"
						11="S - 11"
						;
run;

