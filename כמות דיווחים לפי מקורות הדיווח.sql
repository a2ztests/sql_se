--Test the Dashboard opened reports
--כמות דיווחים לפי מקורות הדיווח 

select month(isnull(r.first_receive_date, r.report_date)) as month, rac.reporting_agent_desc as report_source,
/*
Case When (r.instant) =1 
              Then 1
              Else 2 End Urgency, 
 */
count (distinct r.report_id) as cnt_reports --, a.reported_adr_id, p.product_id, ass.assessment_source
FROM mrr.Side_Effects_Reports r 
left join mrr.Side_Effects_Reported_Adr a on r.report_id= a.report_id
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join mrr.Side_Effects_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Drugs dr on p.dr_reg_num = CAST(dr.dr_objid AS nvarchar(50)) or lower(p.product_name_eng)=lower(dr.dr_name_e)
left join mrr.Side_Effects_Drug_Atc_Codes conn on dr.dr_objid = conn.dr_objid  and  dr.dr_rq_objid = conn.dr_rq_objid

left join mrr.Side_Effects_Drug_Active_Substance das on p.report_id = das.report_id  and  p.product_id = das.product_id

left join mrr.Side_Effects_Atc atc on (conn.atc5_code= atc.atc5_code and conn.atc4_code= atc.atc4_code)

or UPPER(das.active_substance_name) = UPPER(atc.atc5_text_europe)
or UPPER(das.active_substance_name) = UPPER(atc.atc5_text_usa)


--left join mrr.Side_Effects_Atc atc on conn.atc5_code= atc.atc5_code and conn.atc4_code= atc.atc4_code


left join mrr.Side_Effects_Meddra_Hierarchy med on a.meddra_pt = cast( med.pt_code as nvarchar(250))
left join mrr.Side_Effects_Reporting_Agent ra on r.report_id = ra.report_id
left join mrr.Side_Effects_Reporting_Agent_Types_Code rac on ra.reporting_agent_type_code = rac.reporting_agent_type_code
left join mrr.Side_Effects_Reporting_Agent_Types_Groups ratg on rac.reporting_agent_type_code = ratg.reporting_agent_type_code 
      and r.report_xml_format = ratg.report_format_code and (ratg.reporting_agent_group_code = ra.Sender_type_code or ra.Sender_type_code is null)
left join mrr.Side_Effects_Reporting_Agent_Groups_Code rag on ratg.reporting_agent_group_code =rag.reporting_agent_groups_code 
left join mrr.Side_Effects_Drug_Role_Code drc on p.drug_role_code= drc.drug_role_code

where 
r.duplicate is null
and isnull(r.first_receive_date, r.report_date) between Convert(datetime, '2017-01-01' ) and Convert(datetime, '2017-09-30' ) --GOOD
--and rac.reporting_agent_desc = 'חברה מסחרית' --GOOD

--and atc.atc3_text = 'ANESTHETICS, GENERAL' --BAD חומרים מערכת גוף logical since we use complex logic  - more  then just the connection table of drug to atc 
--and atc.atc4_text = 'OPIOID ANESTHETICS' --BAD קבוצה פרמקולוגית logical since we use complex logic  - more  then just the connection table of drug to atc 
--and (atc.atc5_text_europe = 'Fentanyl' or atc.atc5_text_usa = 'Fentanyl')--BAD חמר פעיל logical since we use complex logic  - more  then just the connection table of drug to atc 


--and dr.dr_name_e = 'ACAMOL' -- 'ABBOSYNAGIS'  --GOOD שם מוצר
--and drc.drug_role_code=0 -- Main suspect --GOOD סוג תרומה של המוצר

--and med.soc_name = 'Gastrointestinal disorders' -- BAD מדרה מערכת גוף
--and med.hlt_name = 'Acute and chronic pancreatitis' -- BAD קבוצת תופעות לוואי
--and med.pt_name = 'Pancreatitis' -- BAD  תופעת לוואי

group by --month, Urgency
month(isnull(r.first_receive_date, r.report_date)), rac.reporting_agent_desc
/*Case When (r.instant) =1 
              Then 1
              Else 2 End 
*/
order by month, report_source