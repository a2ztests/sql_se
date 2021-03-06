--דוח עליון:
--כמות סיגנלים שנפתחו
select 

year(CONVERT (datetime,convert(char(8),adr.first_receive_date ))) as year,

DATEPART(qq,
concat(
substring (convert(char(8),adr.first_receive_date ),1,4),  '/' ,
substring (convert(char(8),adr.first_receive_date ),5,2),  '/' ,
substring (convert(char(8),adr.first_receive_date ),7,2)
)
)AS qrt,

--month(CONVERT (datetime,convert(char(8),adr.first_receive_date ))) as month,
--urg.Inquiry_Urgency_desc as Urgency,
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
r.reporting_method_code = 2 
--and urg.Inquiry_Urgency_desc = 'לא ידוע' --GOOD
--and adr.update_type_code not in (3,41) --irrellevant for signal
 
and CONVERT (datetime,convert(char(8),adr.first_receive_date )) between Convert(datetime, '2017-01-01' ) and Convert(datetime, '2017-09-30' ) --GOOD
--and rat.reporting_agent_type_desc = 'חברה מסחרית' --GOOD

--and atc.atc3_text = 'ANESTHETICS, GENERAL' --Bad חומרים מערכת גוף logical since we use complex logic  - more  then just the connection table of drug to atc 
--and atc.atc4_text = 'OPIOID ANESTHETICS' --? קבוצה פרמקולוגית logical since we use complex logic  - more  then just the connection table of drug to atc 
--and (atc.atc5_text_europe = 'Fentanyl' or atc.atc5_text_usa = 'Fentanyl')--? חמר פעיל logical since we use complex logic  - more  then just the connection table of drug to atc 


--and pr.product_name_eng = 'ALLORIL' -- 'ABBOSYNAGIS'  --? שם מוצר
--and drc.drug_role_desc = 'חשודה'

--and med.soc_name = 'Gastrointestinal disorders' -- ? מדרה מערכת גוף
--and med.hlt_name = 'Acute and chronic pancreatitis' -- ? קבוצת תופעות לוואי
--and med.pt_name = 'Pancreatitis' -- ?  תופעת לוואי


group by 
year(CONVERT (datetime,convert(char(8),adr.first_receive_date ))),
DATEPART(qq,
concat(
substring (convert(char(8),adr.first_receive_date ),1,4),  '/' ,
substring (convert(char(8),adr.first_receive_date ),5,2),  '/' ,
substring (convert(char(8),adr.first_receive_date ),7,2)
)
)

--month(CONVERT (datetime,convert(char(8),adr.first_receive_date )))
--urg.Inquiry_Urgency_desc

order by year,qrt --, Urgency
--order by month --, Urgency

------------------------------
--דוח תחתון:
--כמות סיגנלים לפי מקורות הדיווח
select 
year(CONVERT (datetime,convert(char(8),adr.first_receive_date ))) as year,

DATEPART(qq,
concat(
substring (convert(char(8),adr.first_receive_date ),1,4),  '/' ,
substring (convert(char(8),adr.first_receive_date ),5,2),  '/' ,
substring (convert(char(8),adr.first_receive_date ),7,2)
)
)AS qrt,
--month(CONVERT (datetime,convert(char(8),adr.first_receive_date ))) as month,
rat.reporting_agent_type_desc,
--urg.Inquiry_Urgency_desc as Urgency,
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
r.reporting_method_code = 2 
--and urg.Inquiry_Urgency_desc = 'לא ידוע' --GOOD
--and adr.update_type_code not in (3,41) --irrellevant for signal
 
and CONVERT (datetime,convert(char(8),adr.first_receive_date )) between Convert(datetime, '2017-01-01' ) and Convert(datetime, '2017-09-30' ) --GOOD
--and rat.reporting_agent_type_desc = 'חברה מסחרית' --GOOD

--and atc.atc3_text = 'OTHER ANTINEOPLASTIC AGENTS' --GOOD חומרים מערכת גוף logical since we use complex logic  - more  then just the connection table of drug to atc 
/* Irellevant to this report
and atc.atc4_text = 'OPIOID ANESTHETICS' --? קבוצה פרמקולוגית logical since we use complex logic  - more  then just the connection table of drug to atc 
and (atc.atc5_text_europe = 'Fentanyl' or atc.atc5_text_usa = 'Fentanyl')--? חמר פעיל logical since we use complex logic  - more  then just the connection table of drug to atc 
*/

--and pr.product_name_eng = 'ALLORIL' -- 'ABBOSYNAGIS'  --GOOD שם מוצר
--and drc.drug_role_desc = 'חשודה'

--and med.soc_name = 'Gastrointestinal disorders' -- ? מדרה מערכת גוף
/* Irellevant to this report
and med.hlt_name = 'Acute and chronic pancreatitis' -- ? קבוצת תופעות לוואי
and med.pt_name = 'Pancreatitis' -- ?  תופעת לוואי
*/


group by 

year(CONVERT (datetime,convert(char(8),adr.first_receive_date ))),

DATEPART(qq,
concat(
substring (convert(char(8),adr.first_receive_date ),1,4),  '/' ,
substring (convert(char(8),adr.first_receive_date ),5,2),  '/' ,
substring (convert(char(8),adr.first_receive_date ),7,2)
)
),



--month(CONVERT (datetime,convert(char(8),adr.first_receive_date ))),
rat.reporting_agent_type_desc
--urg.Inquiry_Urgency_desc
order by year, qrt, rat.reporting_agent_type_desc --Urgency
--order by month, rat.reporting_agent_type_desc --Urgency