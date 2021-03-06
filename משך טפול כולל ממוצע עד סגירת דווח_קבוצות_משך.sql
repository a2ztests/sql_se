--מתאריך סגירה עד תאריך סגירה
select inner_sql.year1 as year,
inner_sql.month1 as month,
inner_sql.treatment_day_group_desc as dur_group, 
inner_sql.Inquiry_Urgency_desc as urgency ,
--count (distinct inner_sql.report_gk) as close_rep
count( distinct(concat(inner_sql.report_gk, '*' ,inner_sql.step_end_date_active))) as close_rep -- Concating in order to get rid of duplications of records exploded even when the report is closed
from dwh.vw_Fact_Side_Effects_Report_Product_Adr adr -- must perform this in an outer select since there will multiple records coming from adr table against the last step in treatment steps table (included in "inner_sql" table below 

--Closed \ opned reports  join
--left join 
join
(
select
year(CONVERT(date, convert(char(8),stp.step_end_date_active ))) as year1,
month(CONVERT(date, convert(char(8),stp.step_end_date_active ))) as month1, stp.num_days_to_report_close , stp.step_end_date_active,
r.report_gk, usr.usr_name, usr.usr_GK, r.reporting_agent_type_GK, 
stp.report_close_duration_group_GK, 
--stp.duration_group_GK, 
urg.Inquiry_Urgency_desc, dur_grp.treatment_day_group_desc
from dwh.vw_fact_Side_Effects_Report r
left join dwh.vw_Fact_Side_Effects_Treatment_Steps_By_Day stp on r.report_GK = stp.report_GK
left join dwh.vw_Dim_Side_Effects_Inquiry_Urgency urg on r.inquiry_urgency_GK = urg.Inquiry_Urgency_GK
left join dwh.vw_Dim_Side_Effects_User usr on stp.assigned_to_user_GK = usr.usr_GK
left join dwh.Dim_Treatment_Day_Group dur_grp on stp.report_close_duration_group_GK = dur_grp.treatment_day_group_GK
--left join dwh.Dim_Treatment_Day_Group dur_grp on stp.duration_group_GK = dur_grp.treatment_day_group_GK


where
r.reporting_method_code = 1 and r.update_type_code not in (3,41)
--and CONVERT(date, convert(char(8),stp.step_end_date_active )) = '2017-01-01' --GETDATE() -- GOOD?
and CONVERT(date, convert(char(8),stp.step_end_date_active )) between '2016-12-01' AND '2017-12-31' 
and stp.status_per_date=2 --for closed reports
) inner_sql
on  adr.report_GK =  inner_sql.report_gk 


left join dwh.vw_Dim_Product pr on adr.product_name_eng = pr.product_name_eng
left join dwh.vw_Dim_Atc atc on adr.atc_GK = atc.atc_GK
left join dwh.vw_Dim_Side_Effects_Meddra med on adr.meddra_GK = med.meddra_GK
left join dwh.vw_Dim_Side_Effects_Reporting_Agent_Type rat on inner_sql.reporting_agent_type_GK = rat.reporting_agent_type_GK
left join dwh.vw_Dim_Side_Effects_Drug_Role drc on adr.drug_role_GK = drc.drug_role_GK

--left join dwh.vw_Dim_Treatment_Day_Group dur_grp on inner_sql.duration_group_GK = dur_grp.treatment_day_group_GK
left join dwh.vw_Dim_Treatment_Day_Group dur_grp on inner_sql.report_close_duration_group_GK = dur_grp.treatment_day_group_GK

where 
--dur_grp.treatment_day_group_type = 'Side_effect' and dur_grp.treatment_day_group_desc <> '31-365' -- '0-7'
-- inner_sql.usr_name = 'עינת גורליק' 
--inner_sql.Inquiry_Urgency_desc = 'גבוהה' 

 --rat.reporting_agent_type_desc = 'חברה מסחרית' --?

 --atc.atc3_text = 'ANTACIDS' --? חומרים מערכת גוף logical since we use complex logic  - more  then just the connection table of drug to atc 
 --atc.atc4_text = 'AMIDES' --? קבוצה פרמקולוגית logical since we use complex logic  - more  then just the connection table of drug to atc 
 --(atc.atc5_text_europe = 'CALCIUM' or atc.atc5_text_usa = 'CALCIUM')--? חמר פעיל logical since we use complex logic  - more  then just the connection table of drug to atc 


--pr.product_name_eng = 'ADVIL'  -- 'ABBOSYNAGIS'  --? שם מוצר
drc.drug_role_code=0 -- Main suspect --? סוג תרומה של המוצר

--med.soc_name = 'Eye disorders' -- ? מדרה מערכת גוף
-- med.hlt_name = 'Acnes' -- ? קבוצת תופעות לוואי
 --med.pt_name = 'Abasia' -- ?  תופעת לוואי

group by inner_sql.year1,inner_sql.month1, 
inner_sql.treatment_day_group_desc , 
inner_sql.Inquiry_Urgency_desc 

order by year, month ,
dur_group, 
urgency 

