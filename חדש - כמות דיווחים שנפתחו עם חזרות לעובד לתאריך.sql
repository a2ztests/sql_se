select  inner_sql.usr_name as emp,
count( distinct inner_sql.report_gk) as cnt_rep_emp

from dwh.vw_Fact_Side_Effects_Report_Product_Adr adr -- must perform this in an outer select since there will multiple records coming from adr table against the last step in treatment steps table (included in "inner_sql" table below 

--Closed \ opned reports 
inner join 
(
select
r.report_gk, r.report_id, r.report_start_date, usr.usr_name, usr.usr_GK, r.reporting_agent_type_GK, stp.duration_group_GK
--Rank() over (partition by stp.report_gk order by stp.date_day_key asc ) As Rnk
from dwh.vw_fact_Side_Effects_Report r
left join dwh.vw_Fact_Side_Effects_Treatment_Steps_By_Day stp on r.report_GK = stp.report_GK --Necessary for duration_group_GK
left join dwh.vw_Dim_Side_Effects_Inquiry_Urgency urg on r.inquiry_urgency_GK = urg.Inquiry_Urgency_GK
--left join dwh.vw_Dim_Side_Effects_User usr on stp.assigned_to_user_GK = usr.usr_GK
left join dwh.vw_Dim_Side_Effects_User usr on r.user_GK = usr.usr_GK
where  r.reporting_method_code = 1 and r.update_type_code not in (3,41)
--and Is_record_first_in_report_open =1 -- No need for this because there is only ONE record for each open cycle in fact_report --used to be: instead of stp.is_step_first=1 
--  and stp.status_per_date=1 --for opened reports --Not necessary due to using Is_record_first_in_report_open =1
--and CONVERT(date, convert(char(8),stp.first_receive_date )) = '2017-01-01' --GETDATE() -- GOOD?
--and CONVERT(date, convert(char(8),r.first_receive_date )) between '2017-01-01' AND '2017-02-15' 
 --for closed reports
--and stp.status_per_date=1 --for opened reports
) inner_sql
--on  adr.report_GK =  inner_sql.report_gk 
on  adr.report_id =  inner_sql.report_id --change the previos row because in fact_reports there are 2 different report_gk for reopened report_id, but only ONE report_gk for that record in Fact_Side_Effects_Report_Product_Adr
and adr.reporting_method_code = 1 -- in order to combine only reports & not signals

left join dwh.vw_Dim_Product pr on adr.product_name_eng = pr.product_name_eng
left join dwh.vw_Dim_Atc atc on adr.atc_GK = atc.atc_GK
left join dwh.vw_Dim_Side_Effects_Meddra med on adr.meddra_GK = med.meddra_GK
left join dwh.vw_Dim_Side_Effects_Reporting_Agent_Type rat on inner_sql.reporting_agent_type_GK = rat.reporting_agent_type_GK
left join dwh.vw_Dim_Side_Effects_Drug_Role drc on adr.drug_role_GK = drc.drug_role_GK
left join dwh.vw_Dim_Treatment_Day_Group  dur_grp on inner_sql.duration_group_GK = dur_grp.treatment_day_group_GK

where 
--inner_sql.Rnk=1 and
 --CONVERT(date, convert(char(8),inner_sql.date_day_key )) = '2017-01-01' --GETDATE() -- GOOD?
 CONVERT(date, convert(char(8),inner_sql.report_start_date )) = '2017-01-01' --GETDATE() -- GOOD?

--dur_grp.treatment_day_group_type = 'Side_effect' and dur_grp.treatment_day_group_desc = '0-7'
-- inner_sql.usr_name = 'עינת גורליק' and  opened_sql.usr_username = 'עינת גורליק'
--inner_sql.Inquiry_Urgency_desc = 'גבוהה' and openeded_sql.Inquiry_Urgency_desc = 'גבוהה'
--inner_sql.Rnk=1 and inner_sql.treatment_step_code=7 -- catch the last step for CLOSED reports

--and rac.reporting_agent_desc = 'חברה מסחרית' --?

--and atc.atc3_text = 'ANESTHETICS, GENERAL' --? חומרים מערכת גוף logical since we use complex logic  - more  then just the connection table of drug to atc 
--and atc.atc4_text = 'OPIOID ANESTHETICS' --? קבוצה פרמקולוגית logical since we use complex logic  - more  then just the connection table of drug to atc 
--and (atc.atc5_text_europe = 'Fentanyl' or atc.atc5_text_usa = 'Fentanyl')--? חמר פעיל logical since we use complex logic  - more  then just the connection table of drug to atc 


--and dr.dr_name_e = 'ACAMOL' -- 'ABBOSYNAGIS'  --? שם מוצר
--and drc.drug_role_code=0 -- Main suspect --? סוג תרומה של המוצר

--and med.soc_name = 'Gastrointestinal disorders' -- ? מדרה מערכת גוף
--and med.hlt_name = 'Acute and chronic pancreatitis' -- ? קבוצת תופעות לוואי
--and med.pt_name = 'Pancreatitis' -- ?  תופעת לוואי

group by inner_sql.usr_name

order by emp 


