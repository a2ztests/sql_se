--Test for tableua cube
select count (distinct r.report_id) as cnt --, a.reported_adr_id, p.product_id, ass.assessment_source
FROM mrr.Side_Effects_Reports r 
left join mrr.Side_Effects_Reported_Adr a on r.report_id= a.report_id
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join mrr.Side_Effects_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Drugs dr on p.dr_reg_num = CAST(dr.dr_objid AS nvarchar(50)) and lower(p.product_name_eng)=lower(dr.dr_name_e)
left join mrr.Side_Effects_Drug_Atc_Codes conn on dr.dr_objid = conn.dr_objid  and  dr.dr_rq_objid = conn.dr_rq_objid
left join mrr.Side_Effects_Atc atc on conn.atc5_code= atc.atc5_code and conn.atc4_code= atc.atc4_code
left join mrr.Side_Effects_Meddra_Hierarchy med on a.meddra_pt = cast( med.pt_code as nvarchar(250))
left join mrr.Side_Effects_Reporting_Agent ra on r.report_id = ra.report_id
left join mrr.Side_Effects_Reporting_Agent_Types_Code rac on ra.reporting_agent_type_code = rac.reporting_agent_type_code
left join mrr.Side_Effects_Reporting_Agent_Types_Groups ratg on rac.reporting_agent_type_code = ratg.reporting_agent_type_code 
      and r.report_xml_format = ratg.report_format_code and (ratg.reporting_agent_group_code = ra.Sender_type_code or ra.Sender_type_code is null)
left join mrr.Side_Effects_Reporting_Agent_Groups_Code rag on ratg.reporting_agent_group_code =rag.reporting_agent_groups_code 
left join mrr.Side_Effects_Drug_Role_Code drc on p.drug_role_code= drc.drug_role_code

where 
isnull(r.first_receive_date, r.report_date) between Convert(datetime, '2016-01-01' ) and Convert(datetime, '2016-12-31' ) --GOOD

--atc.atc5_text_usa ='Combinations' -- BAD  atc.atc5_text_europe, atc.atc4_text,  atc.atc3_text, 
--med.soc_name = 'Gastrointestinal disorders'  --BAD -- med.hlt_name = 'Gastrointestinal neoplasms NEC'  med.pt_name = 'Abdominal wall neoplasm'-- a.meddra_pt= '10003988' = Back pain
--r.instant = 0 or r.instant is null --BAD
--dr.dr_name_e = 'SIMPONI'  -- p.dr_reg_num = '3321300' --BAD ----'PEN-RAFA VK FORTE' --BAD
--drc.drug_role_code=0 -- Main suspect --GOOD
--rac.reporting_agent_desc = 'חברה מסחרית' --GOOD --rac.reporting_agent_type_code =5 --חברה מסחרית and rac.product_type_code= 1 and rac.report_format_code = 1 
--rag.reporting_agent_groups_desc = 'רפואה' --BAD -  currently can not slice against this dim --rag.reporting_agent_groups_code= 1   
--r.first_receive_date between Convert(datetime, '2014-01-01' ) and Convert(datetime, '2014-12-31' ) --BAD
isnull(r.first_receive_date, r.report_date) between Convert(datetime, '2017-01-01' ) and Convert(datetime, '2017-10-16' ) 




/*
 SELECT  ratg.ID, count(1) as cnt --rag.reporting_agent_groups_code, rag.reporting_agent_groups_desc
      FROM mrr.Side_Effects_Reporting_Agent  ra  
      join mrr.side_effects_Reports r on r.report_id = ra.report_id
      join mrr.Side_Effects_Reporting_Agent_Types_Code rat on  rat.reporting_agent_type_code = ra.reporting_agent_type_code and r.report_xml_format = rat.report_format_code
      --join dwh.conn_Side_Effects_Agent_types_Groups ratg on rat.reporting_agent_type_code = ratg.reporting_agent_type_code 
      --join dwh.Conn_Side_Effects_Reporting_Agent_Types_Groups ratg on rat.reporting_agent_type_code = ratg.reporting_agent_type_code 
      join mrr.Side_Effects_Reporting_Agent_Types_Groups ratg on rat.reporting_agent_type_code = ratg.reporting_agent_type_code 

      and r.report_xml_format = ratg.report_format_code and (ratg.reporting_agent_group_code = ra.Sender_type_code or ra.Sender_type_code is null)
      join mrr.Side_Effects_Reporting_Agent_Groups_Code rag on ratg.reporting_agent_group_code =rag.reporting_agent_groups_code 
*/