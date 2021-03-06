select   distinct
  DATENAME(MM, CONVERT(date, convert(char(8),r.report_close_date ))) + '-' +
  DATENAME(YY, CONVERT(date, convert(char(8),r.report_close_date ))) as 'חדש סגירת הדווח',
  pr.product_name_eng as 'שם מוצר',
r.reporting_agent_company_name as 'חברה', 
 
 urg.Inquiry_Urgency_desc as 'דחיפות',
rat.reporting_agent_type_desc as 'מקור הדווח',
 adr.Report_id  as 'מספר פניה',
d_sev.event_severity_desc as 'חומרה',
d_upd_type.update_Type_desc as 'עדכניות הדווח',
d_usr.usr_name as 'שם משתמש מטפל',
 
   DATENAME(MM, CONVERT(date, convert(char(8),r.report_start_date ))) + '-' +
  DATENAME(YY, CONVERT(date, convert(char(8),r.report_start_date ))) as 'חדש ביצוע הדווח',
  
  --DATENAME(MM, CONVERT(date, convert(char(8),r.report_start_date ))) + '-' +
  --DATENAME(YY, CONVERT(date, convert(char(8),r.report_start_date ))) as 'חדש ביצוע הדווח',
 CASE   
      WHEN r.report_status_code= 1 THEN 'פתוח'   
      ELSE  'סגור' 
   END as 'סטטוס'
   
   ,adr.Report_gk

from dwh.vw_Fact_Side_Effects_Report_Product_Adr adr -- must perform this in an outer select since there will multiple records coming from adr table against the last step in treatment steps table (included in "inner_sql" table below 
 
left join dwh.vw_fact_Side_Effects_Report r on  adr.report_GK =  r.report_gk 
left join dwh.vw_Dim_Side_Effects_Reporting_Agent_Type rat on r.reporting_agent_type_GK = rat.reporting_agent_type_GK
left join dwh.vw_Dim_Side_Effects_Inquiry_Urgency urg on r.inquiry_urgency_GK = urg.Inquiry_Urgency_GK
left join dwh.vw_Dim_Side_Effects_Severity  d_sev on r.event_severity_GK = d_sev.event_severity_GK
left join dwh.vw_Dim_side_Effects_Update_Type d_upd_type on r.update_type_GK = d_upd_type.update_type_GK
left join dwh.vw_Dim_Side_Effects_User d_usr on r.user_GK = d_usr.usr_GK

left join dwh.vw_Dim_Product pr on adr.product_name_eng = pr.product_name_eng
left join dwh.vw_Dim_Atc atc on adr.atc_GK = atc.atc_GK
left join dwh.vw_Dim_Side_Effects_Meddra med on adr.meddra_GK = med.meddra_GK
--left join dwh.vw_Dim_Side_Effects_Reporting_Agent_Type rat on inner_sql.reporting_agent_type_GK = rat.reporting_agent_type_GK
left join dwh.vw_Dim_Side_Effects_Drug_Role drc on adr.drug_role_GK = drc.drug_role_GK


where 
r.reporting_method_code = 1 and r.update_type_code not in (3,41)
--2 different dates selections
--and CONVERT(date, convert(char(8),r.report_start_date ))  between '2017-02-01' AND '2017-02-28'
--and CONVERT(date, convert(char(8),r.first_receive_date ))  between '2017-02-01' AND '2017-02-28'
and CONVERT(date, convert(char(8),r.report_close_date ))  between '2017-03-01' AND '2017-03-31'
--and CONVERT(date, convert(char(8),r.step_close_date ))  between '2017-03-01' AND '2017-03-31'
and r.report_id = 14761


--and atc.atc3_text = 'ANTACIDS' --? חומרים מערכת גוף logical since we use complex logic  - more  then just the connection table of drug to atc 
--and atc.atc4_text = 'AMIDES' --? קבוצה פרמקולוגית logical since we use complex logic  - more  then just the connection table of drug to atc 
--and (atc.atc5_text_europe = 'Albumin' or atc.atc5_text_usa = 'Albumin')--? חמר פעיל logical since we use complex logic  - more  then just the connection table of drug to atc 


 --and pr.product_name_eng = 'ADVIL' -- 'ABBOSYNAGIS'  --? שם מוצר
-- drc.drug_role_code=0 -- Main suspect --? סוג תרומה של המוצר

--and med.soc_name = 'Gastrointestinal disorders' -- ? מדרה מערכת גוף
--and med.hlt_name = 'Acute and chronic pancreatitis' -- ? קבוצת תופעות לוואי
--and med.pt_name = 'Pancreatitis' -- ?  תופעת לוואי


/*
group by
inner_sql.Inquiry_Urgency_desc, inner_sql.treatment_day_group_desc

order by Duration_Group, Urgency
*/
order by adr.Report_id