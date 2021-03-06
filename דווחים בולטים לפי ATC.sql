select top 10
--concat('Text_Europe: ', atc.atc5_text_europe, ' Text_USA: ', atc.atc5_text_usa) as atc5_text, --top right
--med.pt_name as pt_name, --top left
--atc.atc3_text as atc3_text, --bottom right
atc.atc4_text as atc4_text, --bottom left

count(distinct adr.report_GK) as cnt_reports 

FROM 
dwh.vw_Fact_Side_Effects_Report_Product_Adr adr
--inner join dwh.vw_Fact_Side_Effects_Report r on adr.report_id = r.report_id
left join dwh.vw_Fact_Side_Effects_Report r on adr.report_gk = r.report_gk

left join dwh.vw_Dim_Side_Effects_Inquiry_Urgency urg on urg.Inquiry_Urgency_GK = r.inquiry_urgency_GK
left join dwh.vw_Dim_Product pr on adr.product_name_eng = pr.product_name_eng
left join dwh.vw_Dim_Atc atc on adr.atc_GK = atc.atc_GK
left join dwh.vw_Dim_Side_Effects_Meddra med on adr.meddra_GK = med.meddra_GK
left join dwh.vw_Dim_Side_Effects_Reporting_Agent_Type rat on r.reporting_agent_type_GK = rat.reporting_agent_type_GK
left join dwh.vw_Dim_Side_Effects_Drug_Role drc on adr.drug_role_GK = drc.drug_role_GK


where 
r.reporting_method_code = 1 and adr.update_type_code not in (3,41)
--and CONVERT (datetime,convert(char(8),adr.initial_report_first_step_date )) between Convert(datetime, '2017-01-01' ) and Convert(datetime, '2017-09-30' ) 



--and atc.atc3_text = 'ANESTHETICS, GENERAL' --Bad חומרים מערכת גוף logical since we use complex logic  - more  then just the connection table of drug to atc 
--and atc.atc4_text = 'OPIOID ANESTHETICS' --? קבוצה פרמקולוגית logical since we use complex logic  - more  then just the connection table of drug to atc 
--and (atc.atc5_text_europe = 'Fentanyl' or atc.atc5_text_usa = 'Fentanyl')--? חמר פעיל logical since we use complex logic  - more  then just the connection table of drug to atc 


--and pr.product_name_eng = 'ACAMOL' -- 'ABBOSYNAGIS'  --? שם מוצר
--and drc.drug_role_desc = 'חשודה'

--and med.soc_name = 'Gastrointestinal disorders' -- ? מדרה מערכת גוף
--and med.hlt_name = 'Acute and chronic pancreatitis' -- ? קבוצת תופעות לוואי
and med.pt_name = 'Multiple sclerosis relapse' -- ?  תופעת לוואי
--and atc.atc5_text_europe = 'Glatiramer acetate' and  atc.atc5_text_usa = 'Glatiramer acetate'
group by

--concat('Text_Europe: ', atc.atc5_text_europe, ' Text_USA: ', atc.atc5_text_usa) --top right
--med.pt_name --top left
--atc.atc3_text --bottom right
atc.atc4_text --bottom left
order by cnt_reports desc 
