--No of expected records does not match what we have in Panther (even with  no signals placed in dwh.Dim_Side_Effects_Report:
--No of records 31211 in Panther
select distinct count(r.report_id) from dbo.Reports r 
where r.report_id is not null
and r.create_date <= Convert(datetime, '2017-10-29' )


--  run against dwh
select count(r.report_id) from stg.fact_Side_Effects_Report r 
where r.reporting_method_code =1 -- Report

--  From dwh
select *from stg.fact_Side_Effects_Report r 
where r.report_id =20 and reporting_method_code =1 -- Report



--  From Pantehr
select * from ReportingAgent where report_id=20

--event_duration = ReportedAdr.adr_duration
select radr.adr_duration  from dbo.Reports r
join dbo.ReportedAdr radr on r.report_id=radr.report_id where r.report_id=20

--report_status_code = ReportStatus.report_status_code
select rs.report_status_code, rs.*  from dbo.Reports r
join dbo.ReportStatusHistory rs on r.report_id=rs.report_id where r.report_id=20

-----ReportingAgentGroupsCode.ID
 SELECT ra.report_id , rag.reporting_agent_groups_code, rag.reporting_agent_groups_desc, ratg.ID
      FROM dbo.ReportingAgent ra  
      join dbo.Reports r on r.report_id = ra.report_id
      join dbo.ReportingAgentTypesCode rat on  rat.reporting_agent_type_code = ra.reporting_agent_type_code and r.report_xml_format = rat.report_format_code
      join ReportingAgentTypesGroups ratg on rat.reporting_agent_type_code = ratg.reporting_agent_type_code 
      and r.report_xml_format = ratg.report_format_code and (ratg.reporting_agent_group_code = ra.Sender_type_code or ra.Sender_type_code is null)
      join dbo.ReportingAgentGroupsCode rag on ratg.reporting_agent_group_code =rag.reporting_agent_groups_code 
      and r.report_id = 20

----- reporting_agent_company_name = ReportingAgent.reporting_agent_name
select ra.reporting_agent_name from ReportingAgent ra where ra.report_id=20 

-------------
select  'na' as report_gk, r.report_id, '1' as Reporting_Method_code, r.first_receive_date, 'na' as reporting_method_GK,
r.report_date, r.patient_id, 'na' as patient_gk, '1' as product_type_code, 'na' as product_type_gk, r.event_date, r.report_e2b_type_code, '-44' as reporting_channel_code,
'na' as reporting_channel_gk, r.report_xml_format, ra.reporting_agent_type_code, 'na' as reporting_Agent_Type_gk, '35' as Agent_Types_Groups_ID, 'na' as Agent_Types_Groups_gk,
'5' as reporting_Agent_sector_code, 'na' as reporting_agent_sector_gk,'na' as 'reporting_agent_company_name', 'na' as 'reporting_agent_company_code', 'na' as reporting_agent_company_gk, r.duplicate, r.report_sys_num, report_type_code as Update_type_code,
'na' as Update_type_gk, '0' as event_duration, r.event_severity_code, 'na' as event_severity_gk, internal_closing_reason_code, 'na' as closing_reason_gk, instant as inquiry_Urgency_code,
'na' inquiry_Urgency_gk, '2' as report_status_code, r.primary_source_country_code as original_primary_source_country_code, 'na' as converted_primary_source_country_code, 'na' as primary_source_country_gk,
r.occur_country_code,'na' as converted_occur_country_code, 'na' as occur_country_gk, radr.outcome_of_reaction_code
from dbo.Reports r
join ReportingAgent ra on r.report_id=ra.report_id
join dbo.ReportedAdr radr on r.report_id=radr.report_id
where r.report_id =20

--Test dwh.Dim_Side_Effects_Patient.patient_age_group_GK for Side_Effects_Time_Units_Code.time_units_code = 804 = day  - GOOD
select p.patient_id, p.onset_age, p.onset_age_unit, a.time_units_desc
from mrr.Side_Effects_patient  p
join mrr.Side_Effects_Time_Units_Code a on p.onset_age_unit = a.time_units_code
where a.time_units_code = 804 -- יום
order by onset_age desc
and patient_id = 20914 -- 1009 months = 84 years --> group= Elderly 65-120 years

select ag.age_GK
from dwh.Dim_Age_Group ag
where ag.age_group_type = 'Side_Effects'
and ag.age_group_code = 1009

select * from mrr.Side_Effects_Time_Units_Code

select  p.internal_patient_id, p.patient_onset_age, p.patient_age_group_GK
from dwh.Dim_Side_Effects_Patient p
where p.internal_patient_id = 20914 

--Test dwh.Dim_Side_Effects_Patient.patient_age_group_GK for Side_Effects_Time_Units_Code.time_units_code = 801 = year  - GOOD
select p.patient_id, p.onset_age, p.onset_age_unit, a.time_units_desc
from mrr.Side_Effects_patient  p
join mrr.Side_Effects_Time_Units_Code a on p.onset_age_unit = a.time_units_code
where a.time_units_code = 801 -- יום
and p.onset_age <30
order by onset_age desc
and patient_id = 827 -- 29 years = 348 months --> group= Adult 18-64 years

select ag.age_GK
from dwh.Dim_Age_Group ag
where ag.age_group_type = 'Side_Effects'
and ag.age_group_code = 348

select * from mrr.Side_Effects_Time_Units_Code

select  p.internal_patient_id, p.patient_onset_age, p.patient_age_group_GK
from dwh.Dim_Side_Effects_Patient p
where p.internal_patient_id = 827 

----Test dims against dwh.Fact_Side_Effects_Report

--Test dim Reporting_Method_code - GOOD (31317 records)
select count(r.report_id) as cnt
from dbo.Reports r
where r.report_id is not null
and r.report_date <= Convert(datetime, '2017-10-29' )

--Match against mrr (31217) -> the source (Panther) changes daily even retro --> must test against the mrr
select count(r.report_id) as cnt
from  mrr.Side_Effects_Reports r
where r.report_id is not null
--and r.report_date <= Convert(datetime, '2017-10-29' )


--Match against dwh (31217)
select count(r.report_id) as cnt
from dwh.fact_Side_Effects_Report  r 
where r.reporting_method_code =1 -- Report
--and r.internal_patient_id not in (31327, 31326, 31325, 31324, 31323, 31322)

--Test dim internal_patient_id - GOOD 
select r.patient_id , count(1) as cnt
from mrr.Side_Effects_Reports r
where r.report_id is not null
--and r.create_date <= Convert(datetime, '2017-10-29' )
group by r.patient_id
order by r.patient_id desc

--Match against dwh
select r.internal_patient_id,  count(1) as cnt
from dwh.fact_Side_Effects_Report  r 
where r.reporting_method_code =1 -- Report
group by r.internal_patient_id
order by r.internal_patient_id desc

--Yehudit ran data 2017-10-29
--Test dim time = Reporting_date - GOOD
/* select r.report_date , count(1) as cnt
from dbo.Reports r
where r.report_id is not null
and r.create_date <= Convert(datetime, '2017-10-29' )
group by r.report_date
order by r.report_date desc

--new
select Case When (r.create_date < r.first_receive_date and r.first_receive_date is not null)
               Then r.create_date Else r.first_receive_date End Reporting_Date , count(1) as cnt
from mrr.Side_Effects_Reports r
--where r.report_id is not null
--and r.report_date <= Convert(datetime, '2017-10-29' )
group by Case When (r.create_date < r.first_receive_date and r.first_receive_date is not null)
               Then r.create_date Else r.first_receive_date End
order by Case When (r.create_date < r.first_receive_date and r.first_receive_date is not null)
               Then r.create_date Else r.first_receive_date End desc

--Match against dwh
select r.reporting_date,  count(1) as cnt
from dwh.fact_Side_Effects_Report  r 
where r.reporting_method_code =1 -- Report
group by r.reporting_date
order by r.reporting_date desc
*/
select  r.first_receive_date , count(1) as cnt
from mrr.Side_Effects_Reports r
--where r.report_id is not null
--and r.report_date <= Convert(datetime, '2017-10-29' )
group by r.first_receive_date 
order by r.first_receive_date desc

--Match against dwh
select r.first_receive_date,  count(1) as cnt
from dwh.fact_Side_Effects_Report  r 
where r.reporting_method_code =1 -- Report
group by r.first_receive_date 
order by r.first_receive_date  desc

--Test dim product_type_code - GOOD 
select  r.product_type_code , count(1) as cnt
from mrr.Side_Effects_Reports r
--where r.report_id is not null
--and r.report_date <= Convert(datetime, '2017-10-29' )
group by r.product_type_code 
order by r.product_type_code desc

--Match against dwh
select r.product_type_code,  count(1) as cnt
from dwh.fact_Side_Effects_Report  r 
where r.reporting_method_code =1 -- Report
group by r.product_type_code 
order by r.product_type_code  desc

--Test dim report_e2b_type_code - GOOD - סוג דיווח מקוון
select  r.report_e2b_type_code , count(1) as cnt
from mrr.Side_Effects_Reports r
group by r.report_e2b_type_code 
order by r.report_e2b_type_code desc

--Match against dwh
select r.report_e2b_type_code,  count(1) as cnt
from dwh.fact_Side_Effects_Report  r 
--where r.reporting_method_code =1 -- Report
group by r.report_e2b_type_code 
order by r.report_e2b_type_code  desc

--Test dim report_e2b_type_code - GOOD - סוג דיווח מקוון
select  r.report_e2b_type_code , count(1) as cnt
from mrr.Side_Effects_Reports r
group by r.report_e2b_type_code 
order by r.report_e2b_type_code desc

--Test dim reporting_channel_code - GOOD - קוד ערוץ דיווח
--In mrr
select r.report_e2b_type_code,  count(1) as cnt
from mrr.Side_Effects_Reports  r 
--where r.reporting_method_code =1 -- Report
group by r.report_e2b_type_code 
order by r.report_e2b_type_code  desc

--Match against dwh
select r.reporting_channel_code,  count(1) as cnt
from dwh.fact_Side_Effects_Report  r 
--where r.reporting_method_code =1 -- Report
group by r.reporting_channel_code 
order by r.reporting_channel_code  desc

--Test dim reporting_Agent_Type_code -  GOOD - for Signals + Report  - קוד סוג הארגון אליו שייך הגורם המדווח
--In mrr
select ra.reporting_Agent_Type_code,  count(1) as cnt
from mrr.Side_Effects_Reporting_Agent ra
left join mrr.Side_Effects_Reports  r on ra.report_id = r.report_id
--and r.reporting_method_code =1 -- Report
group by ra.reporting_Agent_Type_code 
order by ra.reporting_Agent_Type_code  desc

--Match against dwh
select r.reporting_Agent_Type_code,  count(1) as cnt
from dwh.fact_Side_Effects_Report  r 
--where r.reporting_method_code =1 -- Report
where r.reporting_method_code =2 -- Signal
group by r.reporting_Agent_Type_code 
order by r.reporting_Agent_Type_code  desc

--Test dim Agent_Types_Groups_ID -  GOOD but not according the required logic ??  - הקשר בין סוג הארגון אליו שייך הגורם מדווח לסקטור אליו שייך הגורם המדווח
--In mrr
--Can't test yet: need to change the table name from Conn_Side_Effects_Reporting_Agent_Types_Groups TO dwh.conn_Side_Effects_Agent_types_Groups
--on 31.10.17 no data in Conn_Side_Effects_Reporting_Agent_Types_Groups OR dwh.conn_Side_Effects_Agent_types_Groups
 SELECT  ratg.ID, count(1) as cnt --rag.reporting_agent_groups_code, rag.reporting_agent_groups_desc
      FROM mrr.Side_Effects_Reporting_Agent  ra  
      join mrr.side_effects_Reports r on r.report_id = ra.report_id
      join mrr.Side_Effects_Reporting_Agent_Types_Code rat on  rat.reporting_agent_type_code = ra.reporting_agent_type_code and r.report_xml_format = rat.report_format_code
      --join dwh.conn_Side_Effects_Agent_types_Groups ratg on rat.reporting_agent_type_code = ratg.reporting_agent_type_code 
      --join dwh.Conn_Side_Effects_Reporting_Agent_Types_Groups ratg on rat.reporting_agent_type_code = ratg.reporting_agent_type_code 
      join mrr.Side_Effects_Reporting_Agent_Types_Groups ratg on rat.reporting_agent_type_code = ratg.reporting_agent_type_code 

      and r.report_xml_format = ratg.report_format_code and (ratg.reporting_agent_group_code = ra.Sender_type_code or ra.Sender_type_code is null)
      join mrr.Side_Effects_Reporting_Agent_Groups_Code rag on ratg.reporting_agent_group_code =rag.reporting_agent_groups_code 
group by ratg.ID       
order by ratg.ID  desc

--Match against dwh
select r.Agent_Types_Groups_ID,  count(1) as cnt
from dwh.fact_Side_Effects_Report  r 
where r.reporting_method_code =1 -- Report
--where r.reporting_method_code =2 -- Signal
group by r.Agent_Types_Groups_ID 
order by r.Agent_Types_Groups_ID  desc

/* Test reporting_agent_company_name -  GOOD
א.  יש למצוא את mrr_Side_Effects_Reporting_Agent.reporting_agent_id שמתאים ל - mrr_Side_Effects_Reports לפי report_id
ב.  להביא את המלל הקיים  ברשומה המתאימה ב - mrr_Side_Effects_Reporting_Agent.reporting_agent_name , להוריד פסיק או נקודה בתחילת מילה + להפוך אותו ל - Lower (זה יגדיל את הסכוי למציאת הצלבה בשלב הבא)
ג.  להשתמש ב -   CNV_Side_Effects : table = mrr_Side_Effects_Reporting_Agent, Field =reporting_agent company_name
*/



--Aggregates logic
--in Mrr
select  ra.reporting_agent_name,  count(1) as cnt
from mrr.Side_Effects_Reporting_Agent ra
join mrr.Side_Effects_Reports r on ra.report_id = r.report_id
where ra.reporting_agent_name in('תרימה' , 'תריהמ','trima' )
group by ra.reporting_agent_name 
order by ra.reporting_agent_name  desc

--Match against dwh
select r.reporting_agent_company_name,  count(1) as cnt
from dwh.fact_Side_Effects_Report  r 
where r.reporting_method_code =1 -- Report
and r.reporting_agent_company_name = 'TRIMA'
--where r.reporting_method_code =2 -- Signal
group by r.reporting_agent_company_name 
order by r.reporting_agent_company_name  desc

--Single logic
--in mrr
select r.report_id, ra.reporting_agent_name
from mrr.Side_Effects_Reporting_Agent ra
join mrr.Side_Effects_Reports r on ra.report_id = r.report_id
where ra.reporting_agent_name in('תרימה' , 'תריהמ','trima' )
order by r.report_id
--in dwh
select  r.report_id, r.reporting_agent_company_name
from dwh.fact_Side_Effects_Report  r 
where r.reporting_agent_company_name = 'TRIMA'
order by r.report_id


-- Test Fact_Side_Effects_Report_Product_Adr
select a.report_id, count(1) as cnt
from mrr.Side_Effects_Reports r
join mrr.Side_Effects_Reported_Adr  a on r.report_id = a.report_id
group by a.report_id
having count(1)>2
order by count(1)

--3 adrs reported on this report_Id
select a.reported_adr_id, a.meddra_pt
from mrr.Side_Effects_Reports r
join mrr.Side_Effects_Reported_Adr a on r.report_id = a.report_id
where r.report_id = 6356

--4 drugs reported on this report_Id
select *
FROM mrr.Side_Effects_Reported_Product  a
where a.report_id= 6356

--15 Assessments on this report_Id
select *
FROM mrr.Side_Effects_Drug_Adr_Assessment ass
where ass.report_id= 6356

-- connect Side_Effects_Reported_Adr & Side_Effects_Drug_Adr_Assessment 
select a.reported_adr_id, ass.reported_adr_id as id_from_ass , ass.drug_id, *
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.report_id = ass.report_id
where a.report_id= 6356

-- connect Side_Effects_Drug_Adr_Assessment & Side_Effects_Reported_Product
select p.product_name_eng, ass.drug_id as ass_drug, ass.adr_assessment_id 
FROM mrr.Side_Effects_Reported_Product p
left join mrr.Side_Effects_Drug_Adr_Assessment ass on p.report_id = ass.report_id
where p.report_id= 6356

--60 records: connect Side_Effects_Reported_Adr & Side_Effects_Drug_Adr_Assessment & Side_Effects_Reported_Product
select p.product_name_eng
,ass.drug_id as ass_drug
,ass.adr_assessment_id 
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.report_id = ass.report_id and a.reported_adr_id = ass.reported_adr_id
left join mrr.Side_Effects_Reported_Product p on a.report_id = p.report_id
where p.report_id= 6356


select 
reported_adr_id,
adr_code,
internal_adr_is_known,
report_to_doctor,
report_to_patient,
report_to_literature
medical_treatment,
improvement_after_treatment,
internal_adr_known_internationally,
adr_start_date,
adr_end_date,
meddra_pt,
adr_duration,
adr_duration_unit,
adr_first_time as start_using_to_adr_duration,
adr_first_time_unit as start_using_to_adr_duration_unit,
--calc_start_using_to_adr_duration_in_hours,
adr_last_time as end_using_to_adr_duration,
adr_last_time_unit as end_using_to_adr_duration_unit,
adr_appeared_in_past, 
p.dr_reg_num

FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
where a.report_id=  6356

except

-- 60 records in the combined tbl
select distinct
reported_adr_id,
adr_code,
internal_adr_is_known,
report_to_doctor,
report_to_patient,
report_to_literature
medical_treatment,
improvement_after_treatment,
internal_adr_known_internationally,
adr_start_date,
adr_end_date,
meddra_pt,
--meddra_pt_calc,
--meddra_gk
adr_duration,
adr_duration_unit,
start_using_to_adr_duration,
start_using_to_adr_duration_unit,
--calc_start_using_to_adr_duration_in_hours
end_using_to_adr_duration,
end_using_to_adr_duration_unit,
--calc_end_using_to_adr_duration_in_hours
adr_appeared_in_past

FROM dwh.Fact_Side_Effects_Report_Product_Adr a
where a.report_id=6356

select distinct a.meddra_gk 
FROM dwh.Fact_Side_Effects_Report_Product_Adr a
where a.report_id= 6356
--except
select m.meddra_gk
from mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_low_level_term t on a.adr_code = t.llt_code
left join dwh.Dim_Side_Effects_Meddra m on t.pt_code =  m.pt_code
and t.llt_currency ='Y'
and len(a.adr_code)=8
and left(a.adr_code,1)=1
and m.primary_soc_fg ='Y' 
where a.report_id= 6356

select distinct
report_id,
reported_adr_id,
dr_reg_num

FROM dwh.Fact_Side_Effects_Report_Product_Adr a
where  dr_reg_num is not null

reported_adr_id = 1062 or reported_adr_id = 26442
--calc_end_using_to_adr_duration_in_hours is not null or  calc_end_using_to_adr_duration_in_hours =-999

--calc_start_using_to_adr_duration_in_hours is not null or calc_end_using_to_adr_duration_in_hours is not null
a.report_id= 15199 and reported_adr_id = 54839

select * from mrr.Side_Effects_Time_Units_Code
--calc_start_using_to_adr_duration_in_hours  = 600 (start_using_to_adr_duration = 513 & start_using_to_adr_duration_unit = day). Result in dwh is -999

--Test dwh.Fact_Side_Effects_Report_Product_Adr for Signal
select * 
FROM dwh.Fact_Side_Effects_Report_Product_Adr a
where a.Reporting_Method_code=2

 --Test against ReportedProduct
select distinct reported_adr_id,  d_p.dr_objid
--select reported_adr_id, p.dr_reg_num, p.product_name_eng, d_p.dr_objid
FROM mrr.Side_Effects_Reported_Adr a

left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
where a.report_id= 13692 and a.reported_adr_id = 40803 


except

-- 60 records in the combined tbl
select distinct
reported_adr_id,
dr_reg_num
FROM dwh.Fact_Side_Effects_Report_Product_Adr a
where a.report_id= 13692 and a.reported_adr_id = 40803 

 select report_id, product_id, usage_duration, usage_duration_unit_code, usage_period_calc_days
FROM dwh.Fact_Side_Effects_Report_Product_Adr a
where report_id = 10508 and product_id= 24175
--a.usage_period_calc_days is not null and a.usage_duration_unit_code <> 804 and a.usage_period_calc_days<>-999

--Test against ReportedProduct - records match in Panther & dwh 
select distinct reported_adr_id,  d_p.dr_objid as dr_reg_num, product_id, p.product_name_eng, 
lot,
--expiration_date,
--manufacturing_date,
--usage_start_date,
--usage_end_date,
usage_stopped,
renew_usage,
p.drug_role_code,
p.usage_period,
usage_period_unit_code,
incidence,
improvement_after_stop,
obtain_drug_country_code
--Daily_dosage

FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
--left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
where a.report_id= 6711 and a.reported_adr_id = 17907 


except


select distinct
reported_adr_id, dr_reg_num, product_id, product_name_eng,
lot,
--expiration_date,
--manufacturing_date,
--usage_start_date,
--usage_end_date,
usage_stopped,
renew_usage,
drug_role_code,
usage_duration,
usage_duration_unit_code,
incidence,
improvement_after_stop,
original_obtain_drug_country_code
--Daily_dosage

FROM dwh.Fact_Side_Effects_Report_Product_Adr a
where a.report_id= 6711 and a.reported_adr_id = 17907

--Test vw_Fact_Side_Effects_Treatment_Steps_By_Day -- not good - opend problems 103,104

select r.report_id,st.report_status_code, assigned_to, r.report_date, st.create_date, 
r.first_receive_date, st.report_status_code,ds.treatment_int_ext_code,ds.treatment_int_ext_desc, ds.step_source_code, ds.step_source_desc,
internal_closing_reason_code, report_type_code
from mrr.Side_Effects_Reports r
left join  mrr.Side_Effects_Report_Status st on  r.report_id = st.report_id
left join dwh.Dim_Side_Effects_treatment_steps ds on st.report_status_code = ds.treatment_step_code
where r.report_id=68
order by st.create_date


  select   distinct r.report_GK, r.report_id, r.reporting_method_code, r.reporting_method_GK, r.first_receive_date, 
  r.treatment_step_code, r.treatment_step_GK, r.assigned_to_user, r.assigned_to_user_GK, r.closing_reason_code, r.closing_reason_GK, 
  r.step_start_date, r.step_end_date ,r.status_per_date,   r.step_duraion_per_date, r.duration_group_GK, r.num_days_to_report_close 
  from dwh.vw_Fact_Side_Effects_Treatment_Steps_By_Day r
  where r.report_id=68 and r.reporting_method_code =1
  order by   step_start_date
  
  --Test on closed report - GOOD
      select   distinct r.report_GK, r.report_id, r.reporting_method_code, r.reporting_method_GK, r.first_receive_date, 
  r.treatment_step_code, r.treatment_step_GK, r.assigned_to_user, r.assigned_to_user_GK, r.closing_reason_code, r.closing_reason_GK, 
  r.step_start_date, r.step_end_date ,r.status_per_date,   r.step_duraion_per_date, r.duration_group_GK, r.num_days_to_report_close 
  from dwh.vw_Fact_Side_Effects_Treatment_Steps_By_Day r
  where r.report_id=2917 and r.reporting_method_code =1
  order by   step_start_date
  
   --Test assigned_to_user  changes - No such cases for signals \ reports -- GOOD
   select r.report_id,  count(distinct r.assigned_to_user)
   from dwh.vw_Fact_Side_Effects_Treatment_Steps_By_Day r
 where r.reporting_method_code=1
 group by  r.report_id
 having count(distinct r.assigned_to_user)>1
 order by count(distinct r.assigned_to_user) desc
 


