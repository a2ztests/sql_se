select top 10
pr.product_GK, pr.product_name_eng as product_name,
--, month(CONVERT (datetime,convert(char(8),r.report_start_date ))) as month,

count(distinct adr.report_GK) as cnt_reports 
--(count(distinct adr.report_GK) / 6) as avg_reports 
--need to calculate by hand the average for the six months before the last month in the select and pefrom the division

FROM 
dwh.vw_Fact_Side_Effects_Report_Product_Adr adr
inner join dwh.vw_Fact_Side_Effects_Report r on adr.report_id = r.report_id
left join dwh.vw_Dim_Side_Effects_Inquiry_Urgency urg on urg.Inquiry_Urgency_GK = r.inquiry_urgency_GK
left join dwh.vw_Dim_Product pr on adr.product_name_eng = pr.product_name_eng
left join dwh.vw_Dim_Atc atc on adr.atc_GK = atc.atc_GK
left join dwh.vw_Dim_Side_Effects_Meddra med on adr.meddra_GK = med.meddra_GK
left join dwh.vw_Dim_Side_Effects_Reporting_Agent_Type rat on r.reporting_agent_type_GK = rat.reporting_agent_type_GK
left join dwh.vw_Dim_Side_Effects_Drug_Role drc on adr.drug_role_GK = drc.drug_role_GK


where 
r.reporting_method_code = 1 and adr.update_type_code not in (3,41)

--Always select one month data in inner_sql
and CONVERT (datetime,convert(char(8),r.report_start_date  )) between Convert(datetime, '2017-07-01' ) and Convert(datetime, '2017-07-31' ) --

--Copy the previous data to excel and then SELECT DATE RANGE FOR COMPLETE PRIOR SIX MONTHS + cut against: 
--and CONVERT (datetime,convert(char(8),r.report_start_date  )) between Convert(datetime, '2017-01-01' ) and Convert(datetime, '2017-06-30' ) --

--and rat.reporting_agent_type_desc = 'חברה מסחרית' --Bad

--and atc.atc3_text = 'ANESTHETICS, GENERAL' --Bad חומרים מערכת גוף logical since we use complex logic  - more  then just the connection table of drug to atc 
--and atc.atc4_text = 'OPIOID ANESTHETICS' --? קבוצה פרמקולוגית logical since we use complex logic  - more  then just the connection table of drug to atc 
--and (atc.atc5_text_europe = 'Fentanyl' or atc.atc5_text_usa = 'Fentanyl')--? חמר פעיל logical since we use complex logic  - more  then just the connection table of drug to atc 


--and pr.product_name_eng = 'ACAMOL' -- 'ABBOSYNAGIS'  --? שם מוצר
--and drc.drug_role_desc = 'חשודה'

--and med.soc_name = 'Gastrointestinal disorders' -- ? מדרה מערכת גוף
--and med.hlt_name = 'Acute and chronic pancreatitis' -- ? קבוצת תופעות לוואי
--and med.pt_name = 'Pancreatitis' -- ?  תופעת לוואי
group by
pr.product_GK, pr.product_name_eng 
--, month(CONVERT (datetime,convert(char(8),r.report_start_date  )))
order by cnt_reports desc 
--order by avg_reports desc 
---


--Second select - for the average calculations: Take the product_gk from the first sql to the in statement
 --After both sqls have ran, combine them in excel to find the annomality KPI value
 select 
pr.product_GK, pr.product_name_eng as product_name,
--, month(CONVERT (datetime,convert(char(8),r.report_start_date ))) as month,

--count(distinct adr.report_GK) as cnt_reports 
(count(distinct adr.report_GK) / 6) as avg_reports 

FROM 
dwh.vw_Fact_Side_Effects_Report_Product_Adr adr
inner join dwh.vw_Fact_Side_Effects_Report r on adr.report_id = r.report_id
left join dwh.vw_Dim_Side_Effects_Inquiry_Urgency urg on urg.Inquiry_Urgency_GK = r.inquiry_urgency_GK
left join dwh.vw_Dim_Product pr on adr.product_name_eng = pr.product_name_eng
left join dwh.vw_Dim_Atc atc on adr.atc_GK = atc.atc_GK
left join dwh.vw_Dim_Side_Effects_Meddra med on adr.meddra_GK = med.meddra_GK
left join dwh.vw_Dim_Side_Effects_Reporting_Agent_Type rat on r.reporting_agent_type_GK = rat.reporting_agent_type_GK
left join dwh.vw_Dim_Side_Effects_Drug_Role drc on adr.drug_role_GK = drc.drug_role_GK


where 
r.reporting_method_code = 1 and adr.update_type_code not in (3,41)
--Copy the product_GK's from sql 1 to the below in part
/*
and adr.product_GK in (
28945,
28946,
31845,
8894,
28943,
31285,
3109,
29366,
27766,
27039
)
*/
--Always select 6 PRIOR months data in this query
and CONVERT (datetime,convert(char(8),r.report_start_date  )) between Convert(datetime, '2017-01-01' ) and Convert(datetime, '2017-06-30' ) --

--Copy the previous data to excel and then SELECT DATE RANGE FOR COMPLETE PRIOR SIX MONTHS + cut against: 
--and CONVERT (datetime,convert(char(8),r.report_start_date  )) between Convert(datetime, '2017-01-01' ) and Convert(datetime, '2017-06-30' ) --

--and rat.reporting_agent_type_desc = 'חברה מסחרית' --Bad

--and atc.atc3_text = 'ANESTHETICS, GENERAL' --Bad חומרים מערכת גוף logical since we use complex logic  - more  then just the connection table of drug to atc 
--and atc.atc4_text = 'OPIOID ANESTHETICS' --? קבוצה פרמקולוגית logical since we use complex logic  - more  then just the connection table of drug to atc 
--and (atc.atc5_text_europe = 'Fentanyl' or atc.atc5_text_usa = 'Fentanyl')--? חמר פעיל logical since we use complex logic  - more  then just the connection table of drug to atc 


--and pr.product_name_eng = 'ACAMOL' -- 'ABBOSYNAGIS'  --? שם מוצר
--and drc.drug_role_desc = 'חשודה'

--and med.soc_name = 'Gastrointestinal disorders' -- ? מדרה מערכת גוף
--and med.hlt_name = 'Acute and chronic pancreatitis' -- ? קבוצת תופעות לוואי
--and med.pt_name = 'Pancreatitis' -- ?  תופעת לוואי
group by
pr.product_GK, pr.product_name_eng 
--, month(CONVERT (datetime,convert(char(8),r.report_start_date  )))

--order by avg_reports desc
