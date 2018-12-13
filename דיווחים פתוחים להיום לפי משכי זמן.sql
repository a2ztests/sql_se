select  

CASE WHEN a.Inner_Dur_Group between 0 and 7 THEN '0-7'
     WHEN a.Inner_Dur_Group between 8 and 30 THEN '8-30'
     WHEN a.Inner_Dur_Group between 31 and 365 THEN '31-365'
     WHEN a.Inner_Dur_Group >365 THEN '+365'
     --ELSE  'אחר'
END AS Duration_Group,
 count( distinct a.report_id) as cnt_rep

from(
select
r.instant , r.report_id, st.report_status_code, st.create_date,  r.first_receive_date, r.report_date, r.duplicate, 
DATEDIFF(day, isnull(r.first_receive_date, r.report_date), GETDATE()) as Inner_Dur_Group,
--DATEDIFF(day, isnull(r.first_receive_date, r.report_date), st.create_date) as Inner_Dur_Group,

Rank() over (partition by st.report_id order by st.create_date desc ) As Rnk
FROM mrr.Side_Effects_Report_Status st
inner join mrr.Side_Effects_Reports r on st.report_id = r.report_id
) a

where a.Rnk=1 and a.report_status_code<>7 

and a.duplicate is null --must be in the query
and isnull(a.first_receive_date, a.report_date) between Convert(datetime, '2016-01-01' ) and Convert(datetime, '2017-11-30' ) --?
--and isnull(a.first_receive_date, a.report_date) between Convert(datetime, '2017-11-01' ) and Convert(datetime, '2017-11-30' ) --?

--and rac.reporting_agent_desc = 'חברה מסחרית' --?

--and atc.atc3_text = 'ANESTHETICS, GENERAL' --? חומרים מערכת גוף logical since we use complex logic  - more  then just the connection table of drug to atc 
--and atc.atc4_text = 'OPIOID ANESTHETICS' --? קבוצה פרמקולוגית logical since we use complex logic  - more  then just the connection table of drug to atc 
--and (atc.atc5_text_europe = 'Fentanyl' or atc.atc5_text_usa = 'Fentanyl')--? חמר פעיל logical since we use complex logic  - more  then just the connection table of drug to atc 


--and dr.dr_name_e = 'ACAMOL' -- 'ABBOSYNAGIS'  --? שם מוצר
--and drc.drug_role_code=0 -- Main suspect --? סוג תרומה של המוצר

--and med.soc_name = 'Gastrointestinal disorders' -- ? מדרה מערכת גוף
--and med.hlt_name = 'Acute and chronic pancreatitis' -- ? קבוצת תופעות לוואי
--and med.pt_name = 'Pancreatitis' -- ?  תופעת לוואי

group by
CASE WHEN a.Inner_Dur_Group between 0 and 7 THEN '0-7'
     WHEN a.Inner_Dur_Group between 8 and 30 THEN '8-30'
     WHEN a.Inner_Dur_Group between 31 and 365 THEN '31-365'
     WHEN a.Inner_Dur_Group >365 THEN '+365'
     --ELSE  'אחר'
END
order by Duration_Group
--
