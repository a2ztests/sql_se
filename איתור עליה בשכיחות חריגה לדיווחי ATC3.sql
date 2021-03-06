--first select
select --top 10
atc.atc_gk, atc.atc3_text,
count(distinct adr.report_GK) as cnt_reports 
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
--Always select one month data 
and CONVERT (datetime,convert(char(8),adr.report_start_date  )) between Convert(datetime, '2017-12-01' ) and Convert(datetime, '2017-12-31' ) --

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
atc.atc_gk, atc.atc3_text
---


--Second select
select --top 10
atc.atc_gk, atc.atc3_text,
count(distinct adr.report_GK) as sum_six_month_reports

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

--Always select 6 months data 
and CONVERT (datetime,convert(char(8),adr.report_start_date)) between Convert(datetime, '2017-05-01' ) and Convert(datetime, '2017-11-30' ) --

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
atc.atc_gk, atc.atc3_text
