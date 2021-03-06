--סיגנלים פתוחים להיום לפי שלב טפול


select d_step.treatment_step_desc,
--month(s.signal_date) as month, 
    CASE WHEN (CAST(signal_urgency_desc AS nvarchar) = 'גבוהה') THEN 1 ELSE 2 END AS Urgency,
count (distinct s.signal_id) as cnt_signals  
FROM mrr.Side_Effects_Signal s
left join mrr.Side_Effects_Atc atc on CAST(s.atc1_code  AS nvarchar) = atc.atc1_code
left join mrr.drugs dr on CAST(s.drug_name_e  AS nvarchar) = dr.dr_name_e
left join mrr.Side_Effects_Meddra_Hierarchy med on cast(s.meddra_SOC_code  AS nvarchar) = med.soc_name

left join dwh.Dim_Side_Effects_Treatment_Steps d_step on cast(s.signal_step_desc AS nvarchar) = d_step.treatment_step_desc --למציאת תאור שלב פעילות

where
--cast(s.signal_status_desc AS nvarchar) <> 'סגור'  and
 s.signal_date between Convert(datetime, '2016-01-01' ) and Convert(datetime, '2017-09-30' ) --GOOD
--and atc.atc3_text = 'לא ידוע' --BAD חומרים מערכת גוף logical since we use complex logic  - more  then just the connection table of drug to atc 
--and dr.dr_name_e = 'Empagliflozin' -- 'ABBOSYNAGIS'  --GOOD - not taken from mrr.drugs since all the drugs in the Excel enrich only dim_products שם מוצר
--and med.soc_name = 'Hepatobiliary disorders' -- BAD מדרה מערכת גוף

group by --month, Urgency
d_step.treatment_step_desc,
 --month(s.signal_date),
 CASE WHEN (CAST(signal_urgency_desc AS nvarchar) = 'גבוהה') THEN 1 ELSE 2 END

order by d_step.treatment_step_desc, Urgency




--isnull(s.signal_date, r.report_date) between Convert(datetime, '2017-01-01' ) and Convert(datetime, '2017-09-30' ) --GOOD
--and rac.reporting_agent_desc = 'חברה מסחרית' --GOOD

--and atc.atc4_text = 'OPIOID ANESTHETICS' --BAD קבוצה פרמקולוגית logical since we use complex logic  - more  then just the connection table of drug to atc 
--and (atc.atc5_text_europe = 'Fentanyl' or atc.atc5_text_usa = 'Fentanyl')--BAD חמר פעיל logical since we use complex logic  - more  then just the connection table of drug to atc 


--
--and drc.drug_role_code=0 -- Main suspect --GOOD סוג תרומה של המוצר

--and med.soc_name = 'Gastrointestinal disorders' -- BAD מדרה מערכת גוף
--and med.hlt_name = 'Acute and chronic pancreatitis' -- BAD קבוצת תופעות לוואי
--and med.pt_name = 'Pancreatitis' -- BAD  תופעת לוואי


