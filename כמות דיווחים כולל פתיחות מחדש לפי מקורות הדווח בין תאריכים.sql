--דוח כמות דיווחים לפי מקורות הדווח

select 
year(CONVERT (datetime,convert(char(8),r.report_start_date ))) as year, month(CONVERT (datetime,convert(char(8),r.report_start_date ))) as month,
rat.reporting_agent_type_desc,
--urg.Inquiry_Urgency_desc as Urgency,
count(distinct r.report_GK) as cnt_reports 

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
and adr.reporting_method_code = 1 -- in order to combine only reports & not signals
--and CONVERT (datetime,convert(char(8),adr.first_receive_date )) between Convert(datetime, '2017-01-01' ) and Convert(datetime, '2017-09-30' ) --Bad
and CONVERT (datetime,convert(char(8),r.report_start_date )) between '2016-12-01' AND '2017-12-31' 

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
year(CONVERT (datetime,convert(char(8),r.report_start_date ))),  month(CONVERT (datetime,convert(char(8),r.report_start_date ))),
rat.reporting_agent_type_desc
--urg.Inquiry_Urgency_desc

order by year,month, rat.reporting_agent_type_desc --Urgency