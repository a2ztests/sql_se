Select 
a.treatment_step_desc,
Case When (a.instant) =1 
              Then 1
              Else 2 End Urgency, 

 count( distinct a.report_id) as cnt_rep
 
 
from(
select
r.instant , r.report_id, st.report_status_code, st.create_date, d_step.treatment_step_desc, r.first_receive_date, r.report_date, r.duplicate,
Rank() over (partition by st.report_id order by st.create_date desc ) As Rnk
FROM mrr.Side_Effects_Report_Status st
left join dwh.Dim_Side_Effects_Treatment_Steps d_step on st.report_status_code = d_step.treatment_step_code  --למציאת תאור שלב פעילות
inner join mrr.Side_Effects_Reports r on st.report_id = r.report_id
) a

where a.Rnk=1 and a.report_status_code<>7
and a.duplicate is null --must be in the query
and isnull(a.first_receive_date, a.report_date) between Convert(datetime, '2017-01-01' ) and Convert(datetime, '2017-09-30' ) --?


----and rac.reporting_agent_desc = 'חברה מסחרית' --?

--and atc.atc3_text = 'ANESTHETICS, GENERAL' --? חומרים מערכת גוף logical since we use complex logic  - more  then just the connection table of drug to atc 
--and atc.atc4_text = 'OPIOID ANESTHETICS' --? קבוצה פרמקולוגית logical since we use complex logic  - more  then just the connection table of drug to atc 
--and (atc.atc5_text_europe = 'Fentanyl' or atc.atc5_text_usa = 'Fentanyl')--? חמר פעיל logical since we use complex logic  - more  then just the connection table of drug to atc 


--and dr.dr_name_e = 'ACAMOL' -- 'ABBOSYNAGIS'  --? שם מוצר
--and drc.drug_role_code=0 -- Main suspect --? סוג תרומה של המוצר

--and med.soc_name = 'Gastrointestinal disorders' -- ? מדרה מערכת גוף
--and med.hlt_name = 'Acute and chronic pancreatitis' -- ? קבוצת תופעות לוואי
--and med.pt_name = 'Pancreatitis' -- ?  תופעת לוואי

group by 
a.treatment_step_desc ,
Case When (a.instant) =1 
              Then 1
              Else 2 End 


order by a.treatment_step_desc , Urgency