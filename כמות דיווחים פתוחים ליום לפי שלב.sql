select  inner_sql.treatment_step_desc as step,  inner_sql.Inquiry_Urgency_desc as urgency,
count( distinct inner_sql.report_gk) as cnt_rep_emp

from dwh.vw_Fact_Side_Effects_Report_Product_Adr adr -- must perform this in an outer select since there will multiple records coming from adr table against the last step in treatment steps table (included in "inner_sql" table below 


left join 
(
select
r.report_gk, usr.usr_name, usr.usr_GK, r.reporting_agent_type_GK, stp.duration_group_GK, urg.Inquiry_Urgency_desc, d_stp.treatment_step_desc, stp.treatment_step_code 
from dwh.vw_fact_Side_Effects_Report r
left join dwh.vw_Fact_Side_Effects_Treatment_Steps_By_Day stp on r.report_GK = stp.report_GK
left join dwh.vw_Dim_Side_Effects_Inquiry_Urgency urg on r.inquiry_urgency_GK = urg.Inquiry_Urgency_GK
left join dwh.vw_Dim_Side_Effects_User usr on stp.assigned_to_user_GK = usr.usr_GK
left join dwh.vw_Dim_Side_Effects_Treatment_Steps d_stp on stp.treatment_step_GK = d_stp.treatment_step_GK

where
r.reporting_method_code = 1 and r.update_type_code not in (3,41)
and CONVERT(date, convert(char(8),stp.date_day_key )) = '2017-11-28' --GETDATE() -- GOOD?
--and CONVERT(date, convert(char(8),r.first_receive_date )) between '2017-01-01' AND '2017-02-15' 
--and stp.status_per_date=2 --for closed reports
and stp.status_per_date=1 --for opened reports
) inner_sql
on  adr.report_GK =  inner_sql.report_gk 


left join dwh.vw_Dim_Product pr on adr.product_name_eng = pr.product_name_eng
left join dwh.vw_Dim_Atc atc on adr.atc_GK = atc.atc_GK
left join dwh.vw_Dim_Side_Effects_Meddra med on adr.meddra_GK = med.meddra_GK
left join dwh.vw_Dim_Side_Effects_Reporting_Agent_Type rat on inner_sql.reporting_agent_type_GK = rat.reporting_agent_type_GK
left join dwh.vw_Dim_Side_Effects_Drug_Role drc on adr.drug_role_GK = drc.drug_role_GK
left join dwh.vw_Dim_Treatment_Day_Group  dur_grp on inner_sql.duration_group_GK = dur_grp.treatment_day_group_GK

where 
inner_sql.treatment_step_code not in(2)
--dur_grp.treatment_day_group_type = 'Side_effect' and dur_grp.treatment_day_group_desc = '0-7'
-- inner_sql.usr_name = 'עינת גורליק' and  opened_sql.usr_username = 'עינת גורליק'
--inner_sql.Inquiry_Urgency_desc = 'גבוהה' and openeded_sql.Inquiry_Urgency_desc = 'גבוהה'
--inner_sql.Rnk=1 and inner_sql.treatment_step_code=7 -- catch the last step for CLOSED reports

 --rat.reporting_agent_type_desc = 'חברה מסחרית' --GOOD

-- atc.atc3_text = 'ANTACIDS' --GOOD חומרים מערכת גוף logical since we use complex logic  - more  then just the connection table of drug to atc 
 --atc.atc4_text = 'AMIDES' --GOOD קבוצה פרמקולוגית logical since we use complex logic  - more  then just the connection table of drug to atc 
 --(atc.atc5_text_europe = 'Albumin' or atc.atc5_text_usa = 'Albumin')--GOOD חמר פעיל logical since we use complex logic  - more  then just the connection table of drug to atc 


 --pr.product_name_eng = 'ADVIL' -- 'ABBOSYNAGIS'  --GOOD שם מוצר
 --drc.drug_role_code=0 -- Main suspect --GOOD סוג תרומה של המוצר

-- med.soc_name = 'Gastrointestinal disorders' -- GOOD מדרה מערכת גוף
-- med.hlt_name = 'Acute and chronic pancreatitis' --GOOD ? קבוצת תופעות לוואי
 --med.pt_name = 'Pancreatitis' -- GOOD  תופעת לוואי

group by inner_sql.treatment_step_desc , inner_sql.Inquiry_Urgency_desc 

order by step, urgency


