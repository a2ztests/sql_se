select  inner_sql.Inquiry_Urgency_desc as urgency,
inner_sql.treatment_day_group_desc as Duration_Group,


 count( distinct inner_sql.report_gk) as cnt_rep

from dwh.vw_Fact_Side_Effects_Report_Product_Adr adr -- mustperform this in an outer select since there will multiple records coming from adr table against the last step in treatment steps table (included in "inner_sql" table below 
 
left join (
select
r.report_gk, stp.treatment_step_code , urg.Inquiry_Urgency_desc, dur_grp.treatment_day_group_desc, r.reporting_agent_type_GK, r.first_receive_date, 
Rank() over (partition by r.report_id order by stp.step_start_date desc ) As Rnk
from dwh.vw_fact_Side_Effects_Report r
left join dwh.vw_Fact_Side_Effects_Treatment_Steps_By_Day stp on r.report_GK = stp.report_GK

left join dwh.vw_Dim_Side_Effects_Inquiry_Urgency urg on r.inquiry_urgency_GK = urg.Inquiry_Urgency_GK
--left join dwh.vw_Dim_Treatment_Day_Group  dur_grp on stp.duration_group_GK = dur_grp.treatment_day_group_GK
left join dwh.vw_Dim_Treatment_Day_Group  dur_grp on stp.report_close_duration_group_GK = dur_grp.treatment_day_group_GK

 
where
r.reporting_method_code = 1 and r.update_type_code not in (3,41)
and CONVERT(date, convert(char(8),stp.date_day_key )) = '2017-11-28' --GETDATE() -- GOOD
--and CONVERT(date, convert(char(8),r.first_receive_date )) between '2017-01-01' AND '2017-02-15' 
and stp.treatment_step_code<>7
) inner_sql
on  adr.report_GK =  inner_sql.report_gk 


left join dwh.vw_Dim_Product pr on adr.product_name_eng = pr.product_name_eng
left join dwh.vw_Dim_Atc atc on adr.atc_GK = atc.atc_GK
left join dwh.vw_Dim_Side_Effects_Meddra med on adr.meddra_GK = med.meddra_GK
left join dwh.vw_Dim_Side_Effects_Reporting_Agent_Type rat on inner_sql.reporting_agent_type_GK = rat.reporting_agent_type_GK
left join dwh.vw_Dim_Side_Effects_Drug_Role drc on adr.drug_role_GK = drc.drug_role_GK


where 
inner_sql.Rnk=1 
--and inner_sql.treatment_step_code<>7 -- catch the last step for OPENED reports
and inner_sql.treatment_step_code not in(2)
--and rat.reporting_agent_type_desc = 'חברה מסחרית' --GOOD

--and atc.atc3_text = 'ANTACIDS' --GOOD חומרים מערכת גוף logical since we use complex logic  - more  then just the connection table of drug to atc 
--and atc.atc4_text = 'AMIDES' --GOOD קבוצה פרמקולוגית logical since we use complex logic  - more  then just the connection table of drug to atc 
--and (atc.atc5_text_europe = 'Albumin' or atc.atc5_text_usa = 'Albumin')--GOOD חמר פעיל logical since we use complex logic  - more  then just the connection table of drug to atc 


 --and pr.product_name_eng = 'ADVIL' -- 'ABBOSYNAGIS'  --GOOD שם מוצר
-- drc.drug_role_code=0 -- Main suspect --GOOD סוג תרומה של המוצר

--and med.soc_name = 'Gastrointestinal disorders' -- GOOD מדרה מערכת גוף
--and med.hlt_name = 'Acute and chronic pancreatitis' -- GOOD קבוצת תופעות לוואי
--and med.pt_name = 'Pancreatitis' -- ?  תופעת לוואי

group by
inner_sql.Inquiry_Urgency_desc, inner_sql.treatment_day_group_desc

order by Duration_Group, Urgency
--
