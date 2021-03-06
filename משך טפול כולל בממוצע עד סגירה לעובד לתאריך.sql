select usr.usr_name,
convert(float,sum(stp.num_days_to_report_close))/convert(float,count( distinct stp.report_gk)) avg_close_rep_emp

from dwh.vw_Fact_Side_Effects_Treatment_Steps stp
--from dwh.vw_fact_Side_Effects_Report r 
--left join dwh.vw_Fact_Side_Effects_Treatment_Steps stp on  stp.report_GK = r.report_GK
left join dwh.vw_fact_Side_Effects_Report r on  stp.report_GK = r.report_GK
left join dwh.vw_Dim_Side_Effects_User usr on stp.assigned_to_user_GK = usr.usr_GK
left join dwh.vw_Dim_Side_Effects_Inquiry_Urgency urg on r.inquiry_urgency_GK = urg.Inquiry_Urgency_GK
left join dwh.vw_Dim_Side_Effects_Reporting_Agent_Type rat on r.reporting_agent_type_GK = rat.reporting_agent_type_GK

 join
(
select distinct adr.report_GK
from dwh.vw_Fact_Side_Effects_Report_Product_Adr adr
left join dwh.vw_Dim_Product pr on adr.product_name_eng = pr.product_name_eng
left join dwh.vw_Dim_Atc atc on adr.atc_GK = atc.atc_GK
left join dwh.vw_Dim_Side_Effects_Meddra med on adr.meddra_GK = med.meddra_GK
left join dwh.vw_Dim_Side_Effects_Drug_Role drc on adr.drug_role_GK = drc.drug_role_GK

--where 


 --atc.atc3_text =  'לא ידוע' -- 'ANTI-DEMENTIA DRUGS' GOOD חומרים מערכת גוף logical since we use complex logic  - more  then just the connection table of drug to atc 
--and atc.atc4_text = 'OPIOID ANESTHETICS' --? קבוצה פרמקולוגית logical since we use complex logic  - more  then just the connection table of drug to atc 
--and (atc.atc5_text_europe = 'Fentanyl' or atc.atc5_text_usa = 'Fentanyl')--? חמר פעיל logical since we use complex logic  - more  then just the connection table of drug to atc 

--pr.product_name_eng = 'ADVIL' -- 'ABBOSYNAGIS'  --? שם מוצר

 --med.soc_name = 'לא ידוע' -- 'Gastrointestinal disorders' GOOD מדרה מערכת גוף
--and med.hlt_name = 'Acute and chronic pancreatitis' -- ? קבוצת תופעות לוואי
--and med.pt_name = 'Pancreatitis' -- ?  תופעת לוואי

) adr_sql
on stp.report_gk = adr_sql.report_gk


where
stp.reporting_method_code = 1 and stp.update_type_code not in (3,41)
and CONVERT(date, convert(char(8),stp.step_end_date_active )) = '2017-01-01' --GETDATE() -- GOOD?
--and CONVERT(date, convert(char(8),r.first_receive_date )) between '2017-01-01' AND '2017-02-15' 
and stp.status_per_date=2 --for closed reports

--and urg.Inquiry_Urgency_desc = 'גבוהה' 

--and rat.reporting_agent_type_desc = 'חברה מסחרית' --?

group by usr.usr_name
order by avg_close_rep_emp





