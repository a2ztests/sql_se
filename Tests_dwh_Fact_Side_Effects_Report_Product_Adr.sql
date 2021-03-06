--Test dwh.Fact_Side_Effects_Report_Product_Adr DIMS

--Test Product_dim - Good although Total number of rows is different, since ETL found more than 1 record matching product_name_heb in dim_products
--while in source there is only 1 record for this drug (קלקסן) in source against dim_product 
select a.report_id, a.reported_adr_id, p.product_name_eng
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 

except

select report_id, reported_adr_id, product_name_eng
--FROM dwh.Dim_Side_Effects_Reports
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1 

--Detail exploration
select --distinct
p.product_name_eng, p.product_name_heb,reported_adr_id,  d_p.dr_objid as dr_reg_num, product_id, p.product_name_eng, 
lot,
/*
expiration_date,
manufacturing_date,
usage_start_date,
usage_end_date,
*/
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
and product_id = 15739


--except


select --distinct
product_name_eng,product_name_heb, reported_adr_id, dr_reg_num, product_id, product_name_eng,
lot,
/*expiration_date,
manufacturing_date,
usage_start_date,
usage_end_date,*/
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
and product_id = 15739

select * from dwh.dim_product
where product_name_heb = 'קלקסן'

select * from mrr.Drugs
where dr_name_h= 'קלקסן'
---------------------------------
--Test dim_Product - Not good - found non corrolation between reports.first_receive_date 
--and Fact_Side_Effects_Report_Product_Adr.first_receive_date
select distinct a.report_id, a.reported_adr_id, 

isnull(cast (convert( nvarchar(10),r.first_receive_date,112) as int),19000101) AS first_receive_date 
--,r.first_receive_date
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id

except

select report_id, reported_adr_id, first_receive_date
--FROM dwh.Dim_Side_Effects_Reports
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1 

--Detail investigation
select distinct  first_receive_date
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where report_id = 14668 and reported_adr_id = 43029


select distinct first_receive_date
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
--left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id
left join mrr.Side_Effects_Reports r on a.report_id = r.report_id 
where a.report_id = 21728 and a.reported_adr_id = 72086

select distinct first_receive_date 
from mrr.Side_Effects_Reports r
where report_id = 14668

select distinct first_receive_date 
from dwh.dim_Side_Effects_Reports r
where report_id = 14668

select distinct r.first_receive_date, a.reported_adr_id
FROM dwh.Fact_Side_Effects_Report_Product_Adr a
left join dwh.dim_Side_Effects_Reports r on a.report_id = r.report_id 
------------------------------------
--Test dim_meddra - Good
select distinct a.report_id, a.reported_adr_id, 
Case When isnumeric (a.meddra_pt)=1
               Then  cast(a.meddra_pt as nvarchar) Else '-999' End meddra_pt_calc
 
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id

except

select report_id, reported_adr_id, CAST(meddra_pt_calc AS nvarchar) as meddra_pt_calc
--meddra_pt_calc as meddra_pt
--FROM dwh.Dim_Side_Effects_Reports
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1 

------------------------------------
--Test product_id - Good
select distinct a.report_id, a.reported_adr_id, p.product_id

FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id

except

select report_id, reported_adr_id, product_id
--meddra_pt_calc as meddra_pt
--FROM dwh.Dim_Side_Effects_Reports
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1 

------------------------------------
--Test dr_objid - Problem with product_gk
select distinct a.report_id, a.reported_adr_id, p.product_id,
isnull(p.dr_reg_num, -999) as dr_reg_num

FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id
left join mrr.drugs dr on p.dr_reg_num=dr.dr_objid
except

select report_id, reported_adr_id, product_id, dr_reg_num --dr_objid
--meddra_pt_calc as meddra_pt
--FROM dwh.Dim_Side_Effects_Reports
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1 

--Going into details - test the drug establishment
select distinct a.report_id, a.reported_adr_id, p.product_id,p.dr_reg_num, p.product_name_eng, p.product_name_heb
--isnull(p.dr_reg_num, -999) as dr_reg_num
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id
left join mrr.drugs dr on p.dr_reg_num=dr.dr_objid
where r.report_id = 11233  and a.reported_adr_id = 37860 and p.product_id =31731

select distinct  dr.dr_reg_num  --151-53-33970-00, 151-53-33970-01, 151-53-33970-02
from mrr.drugs dr where dr.dr_name_e ='Xofigo'

--Match the drug against dim_product
select distinct product_GK --7434
FROM dwh.dim_product 
where dr_reg_num = '151-53-33970-00'

select distinct product_gk --946
FROM dwh.Fact_Side_Effects_Report_Product_Adr
where report_id = 11233  and reported_adr_id = 37860 and product_id =31731

------------------
--Test report_id status when moved back to open after being closed - GOOD
select r.report_id,st.report_status_code, assigned_to, r.report_date, st.create_date, r.first_receive_date, r.internal_report_status_code
from mrr.Side_Effects_Reports r
left join  mrr.Side_Effects_Report_Status st on  r.report_id = st.report_id
where r.report_id=68
order by st.create_date

 --Find reports open and closed
  select r.report_id, r.report_status_code, count(r.create_date)
 from  mrr.Side_Effects_Report_Status r
 where r.report_status_code =7
 group by  r.report_id ,r.report_status_code
 having count(r.create_date)>1
 -- where r.report_id = 28209

select r.report_status_code
from dwh.Fact_Side_Effects_Report r
--left join  mrr.Side_Effects_Report_Status st on  r.report_id = st.report_id
where r.report_id=68 and r.reporting_method_code=1

------------------------------------
--Test drug_role_code - Good
select distinct a.report_id, a.reported_adr_id, p.product_id, p.drug_role_code
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id

except

select report_id, reported_adr_id, product_id,drug_role_code
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1   

-----Going to details
select report_id, reported_adr_id, product_id,drug_role_code
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1  
and report_id = 14179 and (reported_adr_id = 41215 or reported_adr_id = 41217 or reported_adr_id = 41216)
and product_id = 33877

------------------------------------
--Test usage_duration_unit_code (usage_period_unit_code in the source) for report - NOT GOOD - takala 86
select distinct a.report_id, a.reported_adr_id, p.product_id, isnull(p.usage_period_unit_code, -999)
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id


except

select report_id, reported_adr_id, product_id,usage_duration_unit_code
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1  

-----Going to details
select  a.report_id, a.reported_adr_id, p.product_id, p.usage_period_unit_code
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id
where (r.report_id = 19219 and a.reported_adr_id = 60949  and p.product_id = 48232)

select report_id, reported_adr_id, product_id,usage_duration_unit_code
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1  
and (report_id = 19219 and reported_adr_id = 60949  and product_id = 48232)
/*(
(report_id = 19219 and reported_adr_id = 60949  and product_id = 48232)
or (report_id = 14179 and reported_adr_id = 41215  and product_id = 41216)
or (report_id = 14179 and reported_adr_id = 41215  and product_id = 41216)
)*/

------------------------------------
--Test usage_duration_unit_code (usage_period_unit_code in the souce) for signal - GOOD
select distinct usage_duration_unit_code
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=2

------------------------------------
--Test original_obtain_drug_country_code (obtain_drug_country_code in the source) - GOOD
select distinct a.report_id, a.reported_adr_id, p.product_id, --p.obtain_drug_country_code
isnull(p.obtain_drug_country_code, '-999') as obtain_drug_country_code
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id


except

select distinct report_id, reported_adr_id, product_id,original_obtain_drug_country_code
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1  

-----Going to details
select  a.report_id, a.reported_adr_id, p.product_id, p.obtain_drug_country_code
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id
where (r.report_id = 1157 and a.reported_adr_id = 6180  and p.product_id = 6009)

select report_id, reported_adr_id, product_id,original_obtain_drug_country_code
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1  and  (report_id = 1157 and reported_adr_id = 6180  and product_id = 6009)

------------------------------------
--Test converted_obtain_drug_country_code_code (usage_period_unit_code in the souce) relevant only for report - GOOD
select distinct original_obtain_drug_country_code, converted_obtain_drug_country_code
FROM stg.Fact_Side_Effects_Report_Product_Adr 

------------------------------------
--Test administration_way_code - NOT GOOD - problem 87
select distinct a.report_id, a.reported_adr_id,p.product_id, --dd.administration_way_code
isnull(dd.administration_way_code, '-999') as administration_way_code
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id


except

select distinct report_id, reported_adr_id, product_id,administration_way_code
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1  

-----Going to details
select  a.report_id, a.reported_adr_id, p.product_id, dd.administration_way_code
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id
where (r.report_id = 17263 and a.reported_adr_id = 88419  and p.product_id = 67350)

select report_id, reported_adr_id, product_id,administration_way_code
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1  and  (report_id = 17263 and reported_adr_id = 88419  and product_id = 67350)

------------------------------------
--Test administration_way_code (usage_period_unit_code in the souce) for signal - GOOD
select distinct administration_way_code
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=2

------------------------------------
--Test action_taken_code  - NOT GOOD - problem 88
select distinct a.report_id, a.reported_adr_id,p.product_id, --dd.action_taken_code
isnull(dd.action_taken_code, '-999') as action_taken_code
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id


except

select distinct report_id, reported_adr_id, product_id,action_taken_code
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1  

-----Going to details
select  a.report_id, a.reported_adr_id, p.product_id, dd.action_taken_code
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id
where (r.report_id = 6126 and a.reported_adr_id = 16139  and p.product_id = 14353)

select report_id, reported_adr_id, product_id,action_taken_code
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1  and  (report_id = 6126 and reported_adr_id = 16139  and product_id = 14353)

------------------------------------
--Test assessment_source_code (assessment_source int he source) - NOT GOOD - problem ??
select distinct a.report_id, a.reported_adr_id,p.product_id, ass.assessment_source
--isnull(ass.assessment_source, '-999') as assessment_source
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id


except

select distinct report_id, reported_adr_id, product_id,assessment_source_desc
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1  

-----Going to details
select  a.report_id, a.reported_adr_id, p.product_id, ass.assessment_source
FROM mrr.Side_Effects_Reported_Adr a
left join mrr.Side_Effects_Reported_Product p on a.report_id=p.report_id
left join dwh.dim_product d_p on  lower(p.product_name_eng)=lower(d_p.product_name_eng) 
left join mrr.Side_Drug_Detail dd on p.product_id = dd.product_id
left join mrr.Side_Effects_Drug_Adr_Assessment ass on a.reported_adr_id = ass.reported_adr_id 
left join mrr.Side_Effects_Reports r on a.report_id=r.report_id
where (r.report_id = 424 and a.reported_adr_id = 540  and p.product_id = 839)

select report_id, reported_adr_id, product_id,assessment_source_desc, assessment_source_code
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1  and  (report_id = 424 and reported_adr_id = 540  and product_id = 839)

--General conversion - match against zmani3.txt
select distinct assessment_source_desc, assessment_source_code
FROM dwh.Fact_Side_Effects_Report_Product_Adr 
where  reporting_method_code=1  