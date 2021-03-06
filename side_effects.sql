--run in sideEffects
SELECT distinct t.name as table_name, s.[name] as schema_name
FROM sys.tables t
join sys.schemas s on t.[schema_id]= s.[schema_id]
where
  [object_id] in (
  SELECT c.object_id
  FROM sys.columns c
  where c.name like lower('%country%'))  --reporting_agent
  and t.name like '%Dim%'
  and s.[name] = 'dwh'
  
select datediff(week, '2013-04-10', '2014-05-10')

select datediff(month, '2013-04-10', '2014-05-10')  
  
--add number of days to int date format - instead of cast  
select CONVERT(datetime, convert(varchar(10), Fact_Visit_Events.department_entry_date)),
DATEADD(day, 7, CONVERT(datetime, convert(varchar(10), Fact_Visit_Events.department_entry_date)))
from dwh.Fact_Med_Visit_Patient_Visit_Events Fact_Visit_Events;
  
  select distinct  len(dr_reg_num) from dbo.drugs a
  
  --rename table
  EXEC sp_rename 'dbo.Amir_Toad_Ptirot_Year+Revised_Age+Revised_Region_Gender', 'Amir_Toad_Ptirot_Year+Revised_Age+Revised_Region+Gender';
  
  select distinct a.report_id, a.reported_adr_id, r.first_receive_date ,
isnull(cast (convert( nvarchar(10),r.first_receive_date,112) as int),19000101) AS first_receive_date_converted 
--,r.first_receive_date
FROM mrr.Side_Effects_Reported_Adr a
inner join mrr.Side_Effects_Reports r on a.report_id = r.report_id

  --Hebrew search
select *
from Products p
where Cast( p.product_name_heb AS Nvarchar(max)) like N'%ליום%'

 
  --Replace example
  replace(lower(p.product_name_eng,';',''))=lower(d.dr_name_e)
  Select replace(substring (a.dr_reg_num,8,8),'-','') from dbo.drugs a
  
  --like dynamic example
   select distinct d1.dr_objid, d1.dr_name_e, p1.product_name_eng
from pharma.dbo.drugs d1 
join SideEffects.dbo.Products p1 on  d1.dr_name_e like  '%'+p1.product_name_eng+'%'
where 
 d1.dr_name_e like '%OPTALGIN%'
 )

SELECT *   FROM sys.tables
where [object_id] in (
  SELECT object_id
  FROM sys.columns
  where name like lower('%user%'))
  
  select * from dbo.DrugDetail
   select * from dbo.DrugActiveSubstance
   select * from dbo.DrugAdrAssessment
   select * from dbo.DrugAdrReccurrence
   
   ++++++++++++++++++ Meddra and ReportedAdr
   --Meddra codes in "fact" table - don't exist in visits
   select distinct(Adr.meddra_pt) 
   from dbo.ReportedAdr Adr
  
  --Minimum between 2 dates example 
   select r.report_id, r.report_date, r.create_date, r.first_receive_date, 
Case When (r.create_date < r.first_receive_date and r.first_receive_date is not null)
               Then r.create_date Else r.first_receive_date End EarlyDate
--min(r.create_date, r.first_receive_date)
from dbo.Reports r 
where r.report_id is not null
--and r.create_date <= 29/10/2017
and cast(r.create_date as date) <= Convert(datetime, '2017-10-29' )
order by r.report_id
   
   --Find the meaning of ReportedAdr.adr_code: Prpbably the one not found in pt level in Meddra are llt level (found for 27K according PT, the rest = 30K, probably llt
select a.report_id, a.reported_adr_id, a.meddra_pt, a.adr_code, m.hlt_code, m.pt_code
from dbo.ReportedAdr a
left join Meddra.[1_md_hierarchy] m on a.adr_code = m.pt_code
--left join Meddra.[1_md_hierarchy] m on a.adr_code = m.pt_code
-- where a.meddra_pt is not null
where a.adr_code is not null



   
   --run in DWH
   --ICD9 codes in \\fsmtt\users\amir.shaked\Amir\MRI\ICD9.xlsx
   --Side effects reported in visits - NAUSEA  example
select Dim_Diag.diagnose_desc, count(*) as cnt
FROM [Health_DWH].[dwh].[Fact_Med_Visit_Patient_Visit_Operations] F
inner join [Health_DWH].[dwh].[Fact_Med_Visit_Patient_Visit_Diagnostics] P_Diag on  F.Visit_GK = P_Diag.Visit_GK
inner join [Health_DWH].[dwh].[Dim_Med_Visit_Diagnostics] Dim_Diag on P_Diag.ICD9_First_Diagnostic_code =Dim_Diag.diagnose_code
--inner join [Health_DWH].[dwh].[Dim_Med_Visit_Diagnostics] Dim_Diag_1 on P_Diag.ICD9_Secondary_Diagnostic_code = Dim_Diag_1.diagnose_code
where P_Diag.ICD9_First_Diagnostic_code = '78701'  or P_Diag.ICD9_First_Diagnostic_code = '78702'
--or P_Diag.ICD9_Secondary_Diagnostic_code = '78701'
group by Dim_Diag.diagnose_desc

-- For how many records exist meddra_pt in ADR - a lot of nulls (more then half)
select Adr.meddra_pt, count(1) as cnt
   from dbo.ReportedAdr Adr
   group by Adr.meddra_pt
   order by cnt desc
   
select  count(*)  from dbo.ReportedAdr Adr

--Run both sqls to Compare code meddra_pt in ADR to Meddra.[1_md_hierarchy) - less then 1500 matches out of 50000 records in dbo / 225000 in history
 select count(1) from dbo.ReportedAdr Adr 

--Find against meddra according to CODE numbers in ADR - less then 1500 matches out of 50000 records in dbo / 225000 in history
  select CONVERT(nvarchar(250),Adr.meddra_pt),count(1) as cnt
   from dbo.ReportedAdr Adr
    join Meddra.[1_md_hierarchy] m on Adr.meddra_pt = CONVERT(nvarchar(250),m.pt_code)
    group by Adr.meddra_pt
   order by cnt desc

   --Find agains meddra according to TEXT in ADR - about 14000 matches out of 50000 records in dbo / 225000 in history
 select Adr.meddra_pt,count(1) as cnt
   from dbo.ReportedAdr Adr
    join Meddra.[1_md_hierarchy] m on Adr.meddra_pt =  m.pt_name
    group by Adr.meddra_pt
   order by cnt desc   
   
--First choice to find meddra_pt ( --> meddra_gk):
select m.pt_code, 
from dbo.ReportedAdr a
left join  Meddra.[1_low_level_term] t on a.adr_code = t.llt_code
left join Meddra.[1_md_hierarchy] m on t.pt_code =  m.pt_code
and t.llt_currency ='Y'
and len(a.adr_code)=8
and left(a.adr_code,1)=1
and m.primary_soc_fg ='Y' 
--++++++++++++++++++End Meddra

--No empty drug_role_codes in Products
select count(*) 
   from dbo.Products p
   where p.drug_role_code is  null
   
--No drug_role_codes in ReportedAdr - all is null
select count(*) 
   from dbo.ReportedAdr a
   where a.drug_role_code is null
   
   --More than one main suspect drug_role_code in Products - but it seems like the same record
   select p.report_id,p.product_id,  count(p.drug_role_code) as cnt
   from History.Products p
   where p.drug_role_code = 0
   group by p.report_id,p.product_id
   order by p.product_id, cnt desc
   
   --Ellaboration of such a multi record
    select *
   from History.Products p
   where p.drug_role_code = 0 
   and p.report_id = 16 and p.product_id = 17
   
   
   
-- More than one  drug_role_code (NOT necessarily main) per report & product in History (report_id=900  for example) - - but it seems like the same record
select p.report_id,p.product_id, count(p.drug_role_code) as cnt
   from dbo.Products p
   --where p.drug_role_code = 0
   group by p.report_id,p.product_id
   order by p.report_id,p.product_id,  cnt --desc
   
   --Ellaboration of such a multi record
   select *
   from History.Products p
   --where p.drug_role_code = 0
   where p.report_id = 12 and p.product_id =13
  
   

--Example for one report with more than one product - No problem to match the atc_code  since ATC code in reports is always null   
   select p.report_id,  count(p.product_id) as cnt
   FROM dbo.Products p
   group by p.report_id
   order by cnt desc

--Same example using reports table --> sometimes even with one product per report, there is no atc_code (at all in reports)
  select p.report_id,  count(p.product_id) as cnt
   FROM dbo.Products p
   join dbo.Reports r on p.report_id = r.report_id 
   and r.atc_code is not null
   group by p.report_id
   order by cnt desc
   
     
   --And the details of 1 of the above multi product per 1 report records - in ordr to learn how to connect atc_code to product
  select p.usage_start_date, p.* from dbo.Products p where p.report_id=1150 order by p.usage_start_date
  -- RITUXIMAB                                                                                           
  select * from dbo.DrugActiveSubstance a where a.report_id=1150
   
   -- Are there reports not on tachshirim - תכשירים? NO!
   select t.product_type_desc, count(1) as cnt
   from dbo.Products p
   join  dbo.ProductTypeCode t on p.product_type_code = t.product_type_code 
   group by t.product_type_desc
   order by cnt desc
   
   --All report_id's in products exist in reports
   select p.report_id    FROM dbo.Products p
   where p.report_id not in 
   (select r.report_id FROM dbo.Reports r)
 
--More than one adr per report - it DOESN'T seem like the same adr record
select report_id , count (reported_adr_id) as cnt 
from dbo.ReportedAdr ad
group by report_id
order by cnt desc

--Ellboratre on such a multi record
select *
from dbo.ReportedAdr ad
where  report_id = 8207

--++++++ ADR assessment
--SOME ADR_codes are empty in ReportedAdr - empty is coming from  O\L form (same count) as in next sql - out of  records

select count(*) 
   from dbo.ReportedAdr a
   where a.adr_code is  null
 
--Identify report by e2b
select count(*) 
   from dbo.Reports r
   where r.report_e2b_type_code is  null
   
   --Identify distribution
   select a.adr_code, count(1)  as cnt
   from dbo.ReportedAdr a
   --where a.adr_code is  null
   group by a.adr_code
   order by cnt desc
   
   --Total record number - 51000
   select count(*) 
   from dbo.ReportedAdr a
   
   
   
   --+++++++End ADR assessment
   
 --No atc_codes in reports
select count(*) 
   from dbo.Reports r
   where r.atc_code is not null
   
--atc5_code with more then one atc4_code - there is a double key in atc_codes
--There is only 1 such atc5!!! but with entry_date = null -->looks like a mistakes
select a.atc5_code,  count(1) as cnt
from pharma.dbo.atc_codes a
group by a.atc5_code
order by cnt desc

select a.atc5_code, a.atc4_code
from pharma.dbo.atc_codes a
where a.atc5_code = 'L01XC08'
   
--More than one reporting agent per report - in History
select a.report_id , count (a.reporting_agent_id) as cnt
from History.ReportingAgent a
group by report_id
order by cnt desc

--Ellaboration  of one such report
select a.*
from History.ReportingAgent a
where report_id = 4455

  
   --Users table
   select * from pharma.dbo.users u 
   --where u.usr_lname like '%shaked%' 
   --where u.usr_lname = N'גורליק'
   where u.usr_lname like N'%וישקאוצן%' 
   
   --Run in DWH - Gorlik doesn't exist + the code related to reports.assign_to doesn't exist
select * from dwh.Dim_Employee e
where e.employee_last_name like N'%גורליק%'
   
   --Assignments exist to some users
   select  * from History.Reports r where r.assigned_to = 339
select  * from dbo.Reports r where r.assigned_to = 406


   --Rozet: Some report_Id 's are written in history & some not - what is the logic?
   select report_id from dbo.Reports
   where report_id  not in (
   select distinct report_id from History.Reports)
   
   --And the other way around produces null - All reports_id in history exist in dbo
     select report_id from History.Reports
   where report_id  not in (
   select distinct report_id from dbo.Reports)
   
   
   -- Some report_id 's are written in Hisory once & some not at all
select r.report_id, count(r.report_id) as cnt
from History.Reports r
group by r.report_id
having count(r.report_id)>1
order by cnt desc

--And take examples from the above sql:
select r.update_date from History.Reports r where r.report_id=4455

 --compare history to dbo for Reports
--MINUS Doesn't work in sql server - Some report_id exist in dbo.Reports but not in History.Reports
select distinct Cur.report_id from dbo.Reports Cur
EXCEPT 
select distinct His.report_id from History.Reports His

--But no extra report_id exist in History.Reports compared to dbo.Reports but not in 
select distinct His.report_id from History.Reports His
EXCEPT
select distinct Cur.report_id from dbo.Reports Cur
 
 --compare history to dbo for ReportedAdr
--MINUS Doesn't work in sql server - Some reported_adr_id exist in dbo.ReportedAdr but not in History.ReportedAdr
select distinct Cur.reported_adr_id from dbo.ReportedAdr Cur
EXCEPT 
select distinct His.reported_adr_id from History.ReportedAdr His

--And there EXIST extra reported_adr_id in History.ReportedAdr compared to dbo.ReportedAdr 
select distinct His.reported_adr_id from History.ReportedAdr His
EXCEPT
select distinct Cur.reported_adr_id from dbo.ReportedAdr Cur

 --compare history to dbo for Products
select distinct Cur.report_id, Cur.product_id from dbo.Products Cur
EXCEPT
select distinct His.report_id, His.product_id from History.Products His

--And there EXIST extra product_id in History.Products compared to dbo.Products  
select distinct His.report_id, His.product_id from History.Products His
EXCEPT
select distinct Cur.report_id, Cur.product_id from dbo.Products Cur

 --compare history to dbo for ReportedAdr
select distinct Cur.report_id, Cur.reported_adr_id from dbo.ReportedAdr Cur
EXCEPT
select distinct His.report_id, His.reported_adr_id from History.ReportedAdr His

--And there EXIST extra product_id in History.ReportedAdr compared to dbo.Products  
select distinct His.report_id, His.reported_adr_id from History.ReportedAdr His
EXCEPT
select distinct Cur.report_id, Cur.reported_adr_id from dbo.ReportedAdr Cur

--Can there be more then 1 product per report - looks like YES from the data
select report_id, product_id , count(1) as cnt
from History.Products 
group by report_id, product_id
order by report_id, product_id desc

 --compare history to dbo for ReportingAgent
--MINUS Doesn't work in sql server - Some ReportingAgent exist in dbo.ReportingAgent but not in History.ReportingAgent
select distinct Cur.reporting_agent_id from dbo.ReportingAgent Cur
EXCEPT 
select distinct His.reporting_agent_id from History.ReportingAgent His

--And there is NO extra reporting_agent_id in History.ReportingAgent compared to dbo.ReportingAgent  
select distinct His.reporting_agent_id from History.ReportingAgent His
EXCEPT
select distinct Cur.reporting_agent_id from dbo.ReportingAgent Cur




   
 --Continue on the same issue of writing to history: 
 --writing to History with report_version = null for several different update_report_version
 select r.report_id ,h.report_version, h.update_report_version  
 from dbo.Reports r
 left join History.Reports h on h.report_id = r.report_id 
 --inner join History.Reports h on h.report_id = r.report_id 
 order by r.report_id , h.report_version desc
 

--Allocation of versions to reports 
select   report_id,update_report_version, report_version
from History.Reports 
order by  report_id, update_report_version

-- No records in History.ReportStatusHistory
select count (distinct h.report_id) as cnt
--from dbo.ReportStatusHistory h
from History.ReportStatusHistory h

select count (h.report_id) as cnt
--from dbo.ReportStatusHistory h
from History.ReportStatusHistory h

--Take status from ReportStatusHistory
select sh.report_id ,sh.report_status_code, sh.create_date, sh.end_date, 
hr.internal_report_status_code, hr.create_date, hr.update_date
from  dbo.Reports hr -- History.Reports hr
left join dbo.ReportStatusHistory sh on hr.report_id = sh.report_id
order by hr.report_id, hr.internal_report_status_code

--For Haim Meddra
--1 hlgt level
select distinct top 2 md_hlgt.hlgt_code
from  Meddra.[1_md_hierarchy] md_hlgt

--2 hlt level
select  md.hlgt_code,md.hlt_code, count (md.hlt_code) as cnt
from Meddra.[1_md_hierarchy] md
where md.hlgt_code in (
10017990,
10018008
)
group by  md.hlgt_code,md.hlt_code
order by md.hlgt_code

--3 pt level - take 4 pt numbers for each hlt level
select  md.hlgt_code, md.hlt_code, md.pt_code, count (md.pt_code) as cnt
from Meddra.[1_md_hierarchy] md
where md.hlt_code in (
10010040, --10017990 = hlgt
10017812,
10017993,
10002117, --10018008 = hlgt
10013811,
10017752
)
group by  md.hlgt_code, md.hlt_code, md.pt_code
order by md.hlgt_code, md.hlt_code

--4 - check class aggregate
select  distinct md.hlgt_code, md.hlt_code
from Meddra.[1_md_hierarchy] md
where md.hlt_code in(10002117,10010040, 10013811, 10017752)

--For Haim ATC - run in Pharma
--1 atc3_code level
select distinct top 2 atc.atc3_code
from  dbo.atc_codes atc

--2 atc4_code level
select  atc.atc3_code, atc.atc4_code, count (atc.atc4_code) as cnt
from  dbo.atc_codes atc
where atc.atc3_code in (
'A01A',                
'A02A'                
)
group by  atc.atc3_code,atc.atc4_code
order by atc.atc3_code

--3 atc5_code level - take 3 pt numbers for each atc3 level
select  atc.atc3_code, atc.atc4_code, atc.atc5_code, count (atc.atc5_code) as cnt
from  dbo.atc_codes atc
where atc.atc4_code in (
'A01AA',  --A01A = atc3
'A01AB',
'A01AC',
'A02AB', --A02A = atc3
'A02AC',
'A02AD'
)
group by  atc.atc3_code,atc.atc4_code, atc.atc5_code
order by  atc.atc3_code, atc.atc4_code

--Tachshirim? start
--Run in pharma
--Name of tachshir - found the hebrew one in the O\L form 
select d.dr_reg_num, d.dr_name_h, d.dr_name_e, d.dr_name_e_change from dbo.drugs d
--where d.dr_name_h like '%אבוסינאגיס%'
where d.dr_name_e like '%BETAFERON%'  

--FIND Drugs with no matching records in drug_atc --> !!!!!THERE ARE NO such records = good
select d.dr_objid, d.dr_rq_objid, datc.dr_objid ,datc.dr_rq_objid, datc.dr_atc_code, datc.atc4_code, datc.atc5_code 
from dbo.drug_atc_codes datc
left join dbo.drugs d on  d.dr_objid = datc.dr_objid
and d.dr_rq_objid = datc.dr_rq_objid  -- d.dr_rq_objid is a foreign key from requests
--where datc.dr_objid is null or  datc.dr_rq_objid is null  
order by datc.atc4_code, datc.atc5_code

--FIND Drugs with no atc code --> !!!!!THERE ARE such records = need to replace such values with -999
select d.dr_objid, d.dr_rq_objid, datc.dr_objid ,datc.dr_rq_objid, datc.dr_atc_code, datc.atc4_code, datc.atc5_code 
from dbo.drug_atc_codes datc
left join dbo.drugs d on  d.dr_objid = datc.dr_objid
and d.dr_rq_objid = datc.dr_rq_objid  -- d.dr_rq_objid is a foreign key from requests
--where datc.dr_objid is null or  datc.dr_rq_objid is null  
order by datc.atc4_code, datc.atc5_code



--find in the drug to ATC connection table, the drugs which have more than one atc5 code
select datc.dr_objid,datc.dr_rq_objid, datc.atc4_code, datc.atc5_code, count(1) cnt --count(*) cnt
from pharma.dbo.drug_atc_codes datc
group by datc.dr_objid, datc.dr_rq_objid, datc.atc4_code, datc.atc5_code
having  count(1) >1
order by cnt desc

--See a detailed example of such a drug connected to the drugs table
--FIND the drug (a combination of dr_objid + dr_rq_objid) doesn't have more then one atc5 code  - there are such one to many cases - need seperate dimsL: Drugs + drug_to_atc
select d.dr_name_e, d.dr_name_h,datc.dr_objid ,datc.dr_rq_objid, datc.dr_atc_code, datc.atc4_code, datc.atc5_code 
from pharma.dbo.drug_atc_codes datc
inner join pharma.dbo.drugs d on datc.dr_objid  = d.dr_objid
and datc.dr_rq_objid = d.dr_rq_objid -- d.dr_rq_objid is a foreign key from requests
where datc.dr_objid = 2768000 and datc.dr_rq_objid=83411

select d.dr_name_e, d.dr_name_h,datc.dr_objid ,datc.dr_rq_objid, count(datc.atc5_code) cnt --datc.dr_atc_code,
from dbo.drug_atc_codes datc
inner join dbo.drugs d on datc.dr_objid  = d.dr_objid
and datc.dr_rq_objid = d.dr_rq_objid -- d.dr_rq_objid is a foreign key from requests
where datc.dr_objid = 3099000
group by d.dr_name_e, d.dr_name_h,datc.dr_objid ,datc.dr_rq_objid
order by cnt desc

--+++++Atc 5 related to more thn one atc4 -->MISTAKE?? - only one ( atc.atc5_code = 'L01XC08')
select atc.atc5_code, count (1) as cnt
from pharma.dbo.atc_codes atc
--where atc.atc_text like '%blood forming%'
group by  atc.atc5_code
order by count (1) desc
;
select atc.atc5_code, atc.atc4_code
from pharma.dbo.atc_codes atc
--where atc.atc_text like '%blood forming%'
where atc.atc5_code = 'L01XC08'
--+++++

--How many records are in drugs tsble - count distinct on more than 1 field 
select count(*)
 from (select distinct d.dr_objid, d.dr_rq_objid from dbo.drugs d) as InternalQuery

--run the next 2 q's together --> dr_objid field appears more than once in drug table (only part of the key)

select count (d.dr_objid)
from dbo.drugs d

select count (distinct d.dr_objid)
from dbo.drugs d
--Tachshirim? End

--Find for a drug in SideEffects its ATC5 codes in Pharma
--The connection is through the SideEffects.products.dbo.dr_reg_num is SIMILAIR (not equal) to pharma.dbo.drugs dr_reg_num
--see example on product_name_eng=BETAFERON in products and dr_name_e = BETAFERON (dr_reg_num= 2835900 in products, dr_reg_num = 069-34-28359-00

--Example for Einat on atc finding - using Optalgin
--a. Compare according reg_num
--a1. find reg_num for product names that include Optalgin in the name
select d.dr_objid, d.dr_rq_objid, d.dr_reg_num, d.dr_name_e, d.dr_name_h from pharma.dbo.drugs d where d.dr_name_e like '%OPTALGIN%'
select d.dr_objid, d.dr_rq_objid, d.dr_reg_num, d.dr_name_e, d.dr_name_h from pharma.dbo.drugs d where d.dr_name_h like N'%אופטלגין%' --nothing found -->need to convert Hebrew_CI_AS? 

select p.product_id, p.dr_reg_num, p.product_name_eng, p.product_name_eng,p.product_name_heb  from SideEffects.dbo.Products p where p.product_name_eng like '%OPTALGIN%'
select p.product_id, p.dr_reg_num, p.product_name_eng, p.product_name_eng,p.product_name_heb from SideEffects.dbo.Products p where p.product_name_heb like N'%אופטלגין%' --nothing found -->need to convert Hebrew_CI_AS? 


--a2. Find atc5 according to reg_num:   2048700 = OPTALGIN,   2776706  = OPTALGIN CAPLETS
select p.product_id, p.dr_reg_num, p.product_name_eng, p.product_name_heb, d.dr_name_e, d.dr_objid, d.dr_rq_objid, atc.atc5_code as atc5 , atc.atc4_code as atc4 
from SideEffects.dbo.Products p
left join pharma.dbo.drugs d on p.dr_reg_num = d.dr_objid 
left join pharma.dbo.drug_atc_codes atc on d.dr_objid = atc.dr_objid and d.dr_rq_objid =  atc.dr_rq_objid
where   d.dr_objid in 
  (2048700,2776706 )
  --(select distinct d1.dr_objid from pharma.dbo.drugs d1 where d1.dr_name_e like '%OPTALGIN%') 
order by atc5 desc

--b. Find by comparison according to English name or to Hebrew name -->All atc5 are the same 
select p.product_id, p.dr_reg_num, p.product_name_eng, p.product_name_heb, d.dr_name_e, d.dr_objid, d.dr_rq_objid, atc.atc5_code as atc5 , atc.atc4_code as atc4 
from SideEffects.dbo.Products p
left join pharma.dbo.drugs d on p.dr_reg_num = d.dr_objid 
left join pharma.dbo.drug_atc_codes atc on d.dr_objid = atc.dr_objid and d.dr_rq_objid =  atc.dr_rq_objid
where   
 d.dr_objid in 
 --(select distinct d1.dr_objid from pharma.dbo.drugs d1 where d1.dr_name_e like '%OPTALGIN%') 
 (select distinct d1.dr_objid from pharma.dbo.drugs d1 where d1.dr_name_h like N'%אופטלגין%')
order by atc5 desc

--++++++++++++++Test to find atc against product by name - dynamic
select p.product_id, p.dr_reg_num, p.product_name_eng, p.product_name_heb, d.dr_name_e, d.dr_objid, d.dr_rq_objid, atc.atc5_code as atc5 , atc.atc4_code as atc4 
from SideEffects.dbo.Products p
--left join pharma.dbo.drugs d on p.dr_reg_num = d.dr_objid 
left join  pharma.dbo.drugs d on lower(p.product_name_eng)=lower(d.dr_name_e)
left join pharma.dbo.drug_atc_codes atc on d.dr_objid = atc.dr_objid and d.dr_rq_objid =  atc.dr_rq_objid
where p.product_name_eng is not null and d.dr_rq_objid is not null

 ) 
 --(select distinct d1.dr_objid from pharma.dbo.drugs d1 where d1.dr_name_h like N'%אופטלגין%')
order by atc5 desc


select distinct d1.dr_objid from pharma.dbo.drugs d1 where d1.dr_name_e like 
    (select p1.product_name_eng from SideEffects.dbo.Products p1)
 --++++++++++++++

select distinct d.dr_objid, d.dr_reg_num, d.dr_name_e from pharma.dbo.drugs d where d.dr_name_e like '%Tagrisso%'
select top 1 d.dr_objid  from pharma.dbo.drugs d where d.dr_name_e like '%Tagrisso%'


--Product to drugs connection!!!Always the same ATC5 even for different dr_reg_num or dr_name_e
select p.product_id, p.dr_reg_num, p.product_name_eng, p.product_name_heb, d.dr_name_e, atc.atc5_code as atc5 , atc.atc4_code as atc4 
from SideEffects.dbo.Products p
left join pharma.dbo.drugs d on p.dr_reg_num = d.dr_objid --replace(substring (d.dr_reg_num,8,8),'-','')
left join pharma.dbo.drug_atc_codes atc on d.dr_objid = atc.dr_objid and d.dr_rq_objid =  atc.dr_rq_objid
where   d.dr_objid in 
  (select distinct d1.dr_objid from pharma.dbo.drugs d1 where d1.dr_name_e like '%SANDOSTATIN%') 
order by atc5 desc
 
 --Run the above sql 1 by 1 for the below sql results for reports
  select top 10 p1.product_name_eng , p1.product_name_heb , p1.dr_reg_num  , count(1) as cnt
from SideEffects.dbo.Products p1
group by p1.product_name_eng , p1.product_name_heb , p1.dr_reg_num
order by count(1) desc
  
--For signals run:
select distinct d1.dr_objid, d1.dr_rq_objid from pharma.dbo.drugs d1 where d1.dr_name_e like '%Aranesp%'
  
  select distinct p.dr_reg_num, p.product_name_eng ,atc.atc5_code as atc5 , atc.atc4_code as atc4 , count(1) as cnt
from SideEffects.dbo.Products p
left join pharma.dbo.drugs d on p.dr_reg_num = d.dr_objid --replace(substring (d.dr_reg_num,8,8),'-','')
left join pharma.dbo.drug_atc_codes atc on d.dr_objid = atc.dr_objid and d.dr_rq_objid =  atc.dr_rq_objid
--where   d.dr_objid in 
  --(select p1.dr_reg_num  from SideEffects.dbo.Products p1)
group by p.dr_reg_num,p.product_name_eng ,atc.atc5_code  , atc.atc4_code
order by atc5 desc

--Compare drug atc connection - Rozet to Amir
--Rozet:
select p.dr_reg_num, p.product_name_eng, p.product_name_heb, p.report_id, p.product_id, atc.atc5_code
from dbo.Products p
right join dbo.DrugActiveSubstance das on das.report_id = p.report_id and das.product_id = p.product_id 
join [pharma].[dbo].[atc_codes] atc 
on UPPER(das.active_substance_name) = UPPER(atc.atc5_text_europe)
or UPPER(das.active_substance_name) = UPPER(atc.atc5_text_usa)

--Amir:
select p.product_id, p.dr_reg_num, p.product_name_eng, p.product_name_heb, d.dr_name_e, atc.atc5_code as atc5 , atc.atc4_code as atc4 
from SideEffects.dbo.Products p
left join pharma.dbo.drugs d on p.dr_reg_num = d.dr_objid --replace(substring (d.dr_reg_num,8,8),'-','')
left join pharma.dbo.drug_atc_codes atc on d.dr_objid = atc.dr_objid and d.dr_rq_objid =  atc.dr_rq_objid
where   d.dr_objid in 
  (select distinct d1.dr_objid from pharma.dbo.drugs d1 where d1.dr_name_e like '%BYDUREON%') 
    order by atc5 desc


--drug_atc_codes connection - more then one atc5 per drug key
select d.dr_objid, d.dr_rq_objid, count(atc.atc5_code) as atc5 from pharma.dbo.drugs d
left join pharma.dbo.drug_atc_codes atc on d.dr_objid = atc.dr_objid and d.dr_rq_objid =  atc.dr_rq_objid
group by d.dr_objid, d.dr_rq_objid
order by atc5 desc

-- Ellaborate on one above multi value record = has more than one atc
select d.dr_objid, d.dr_rq_objid, atc.atc5_code as atc5, atc.* from pharma.dbo.drugs d
join pharma.dbo.drug_atc_codes atc on d.dr_objid = atc.dr_objid and d.dr_rq_objid =  atc.dr_rq_objid
and d.dr_objid = 3048900 and d.dr_rq_objid =88048
order by atc5 desc

select  distinct count(r.dr_actc_is_active) from dbo.ref_active_components r


--Maybe this is the connection to find the Main chem in a drug
select d.dr_name_e, atc.atc5_code, active.dr_actc_is_active
from  dbo.drugs d
join dbo.drug_atc_codes atc on d.dr_objid = atc.dr_objid AND d.dr_rq_objid = atc.dr_rq_objid
join dbo.ref_atc2chem chem on atc.atc5_code = chem.atc5_code
join dbo.chemical_components comp on chem.chemic_code = comp.dr_actc_objid
join dbo.ref_active_components active on comp.dr_actc_objid = active.dr_actc_objid
and  d.dr_objid = active.dr_objid AND d.dr_rq_objid = active.dr_rq_objid
and d.dr_objid = 3048900 and d.dr_rq_objid =88048

--Even when the drug has 2 names, it has the same ATC5 code
select d.dr_name_e, c.atc5_code
from pharma.dbo.drugs d
  inner join pharma.dbo.drug_atc_codes c on c.dr_objid = d.dr_objid AND c.dr_rq_objid = d.dr_rq_objid
where d.dr_objid = 3068100

--Drugs with more than one atc
select d.dr_name_e, count(c.atc5_code) as cnt
from pharma.dbo.drugs d
  inner join pharma.dbo.drug_atc_codes c on c.dr_objid = d.dr_objid AND c.dr_rq_objid = d.dr_rq_objid
group by d.dr_name_e

--For one such drug: the atc5 is the same for all the drug names permutations
select d.dr_name_e, c.atc5_code
from pharma.dbo.drugs d
  inner join pharma.dbo.drug_atc_codes c on c.dr_objid = d.dr_objid AND c.dr_rq_objid = d.dr_rq_objid
where d.dr_name_e like '%HYCAMTIN%'

--"Assign to" test
select r.report_id, u.usr_username from SideEffects.dbo.Reports r
join pharma.dbo.Users u on r.assigned_to = u.usr_objid

--Patient attributes: age
select count(*) from History.Patients p
where p.age is not null

select count(*) from History.Patients p
where p.age is  null

select count(*) from History.Patients p
where p.age_group is not null

select count(*) from History.Patients p
where p.age_group is  null

select distinct age_group, count(age_group) as cnt
from History.Patients p
group by age_group
order by age_group
--++++++++++++++++dbo

select count(*) from dbo.Patients p
where p.age is not null

select count(*) from dbo.Patients p
where p.age is  null

select count(*) from dbo.Patients p
where p.age_group is not null

select count(*) from dbo.Patients p
where p.age_group is  null

select distinct p.gender_code
from dbo.Patients p
order by p.gender_code


--Excel comparison - products to drugs
select p.report_id, p.dr_reg_num, p.product_name_eng, p.product_name_heb
from dbo.Products p

select  d.dr_objid, d.dr_name_e, d.dr_name_h
from pharma.dbo.drugs d

--+++++++++++++++++Find product name in products not recognised in drugs
--Total records number
select REPLACE(UPPER(p.product_name_eng),';','') as e
--from History.Products p
from dbo.Products p
order by e


--Code match found / not found - All  p.dr_reg_num = -1
select  p.report_id, p.product_id ,p.dr_reg_num
from dbo.Products p
--from History.Products p
where p.dr_reg_num not in
  (select d.dr_objid
  from pharma.dbo.drugs d)
  
  --English name match found \ NOT found in dbo - No missing names
select  p.report_id, p.product_id ,p.product_name_eng
from dbo.Products p
--from History.Products p
where 
--p.dr_reg_num is null and
 REPLACE(UPPER(p.product_name_eng),';','') not in
  (select UPPER(d.dr_name_e)
  from pharma.dbo.drugs d )
  
  
   --English name match found \ NOT found in History - No missing names
select  p.report_id, p.product_id ,p.product_name_eng
from dbo.Products p
--from History.Products p
where 
--p.dr_reg_num is null and
 REPLACE(UPPER(p.product_name_eng),';','') not in
  (select UPPER(cast (d.dr_name_e as nvarchar(128)) collate SQL_Latin1_General_CP850_BIN2)
  from pharma.dbo.drugs d )
  

  

--Test if the reporting companies  usually send with drug identity - PROBLEM !!!
  select  p.report_id, p.product_id ,p.dr_reg_num
from dbo.Products p
join dbo.Reports r on p.report_id = r.report_id
--from History.Products p
where 
    r.report_e2b_type_code is  null 
   and p.dr_reg_num  in
  (select d.dr_objid
  from pharma.dbo.drugs d)
  

--++++++++++++++End Find product name in products not recognised in drugs

--Reports with more than 1 product 
select a.report_id, count(a.product_id) as cnt
from dbo.DrugActiveSubstance a 
group by a.report_id
order by cnt desc

--number of distinct active_substance_name
select distinct count(a.active_substance_name)  
from dbo.DrugActiveSubstance a 

select distinct count(*)  
from dbo.DrugActiveSubstance a 

--Reports with more than 1 Active substance
select a.report_id, a.product_id,count(a.active_substance_name)  as cnt
from dbo.DrugActiveSubstance a 
group by a.report_id,a.product_id
order by cnt desc

--Ellaborate on these records
--Reports with more than 1 Active substance
select a.report_id, a.product_id,a.active_substance_name  
from dbo.DrugActiveSubstance a 
order by a.report_id, a.product_id,a.active_substance_name

--Test names against DrugActiveSubstance
select  a.report_id, a.product_id ,a.active_substance_name
from dbo.DrugActiveSubstance a
--from History.Products p
where 
--p.dr_reg_num is null and
 --REPLACE(UPPER(a.active_substance_name),';','') not in
 UPPER(a.active_substance_name)  in
  (select UPPER(d.dr_name_e)
  from pharma.dbo.drugs d )

select  p.product_name_eng as e -- p.product_name_heb as h
from dbo.Products p
where p.product_name_eng is null --p.product_name_heb is null --= ' '
order by e--h

select  p.dr_reg_num as n
from dbo.Products p
where p.dr_reg_num is null
order by n

--Hebrew name match found \ NOT found
select  p.report_id, p.product_id ,p.product_name_heb
from dbo.Products p
--from History.Products p
where REPLACE(UPPER(p.product_name_heb),';','')  in --not in
  (select UPPER(d.dr_name_h)
  from pharma.dbo.drugs d )
  





צריך להשוות את פרודקאס לפי שם:
לפי קוד
לפי שדה שם אנגלי מול שדה אנגלית
לפי שדה שם אנגלי מול שדה עברית 
לפי שדה שם עברי מול שדה עברית 
לפי שדה שם אנגלי מול שדה אנגלית
and p.report_id=מה שהאקסל לא מצא


--++++++++++History exploration
--reports

select  r.report_id, count(1) as cnt
from History.Reports r
group by r.report_id
order by cnt desc

select *
from History.Reports r
where r.report_id = 4455
order by r.update_date,r.report_version 

select distinct r.update_date ,r.report_version , r.report_id, r.product_type_code, r.patient_id, r.report_type_code, r.event_date, r.event_place_code, r.event_severity_code,
r.internal_closing_reason_code
from History.Reports r
where r.report_id = 4455
order by r.update_date ,r.report_version 

--distinct Fact test:
report_id,
report_sys_num,
primary_type_code,
report_type_code,
create_date,
event_severity_code,
update_date,
report_date,
first_receive_date,
internal_closing_reason_code
assigned_to,
usr_username
urgency_code

--products
select  p.report_id, p.product_id, count(1) as cnt
from History.Products p
group by p.report_id, p.product_id
order by cnt desc

select *
from History.Products p
where p.report_id =20140  and p.product_id=50859
order by p.update_date  

select distinct p.report_id, p.product_id, p.product_id, p.dr_reg_num, p.product_name_eng,p.product_name_heb,p.product_type_code,p.create_date, p.drug_role_code,p.report_version, p.update_date 
from History.Products p
where p.report_id =20140  and p.product_id=50859
order by p.update_date ,p.report_version


--ReportedAdr
--null values
select  a.report_id, a.reported_adr_id, a.meddra_pt
from History.ReportedAdr a
where  (a.meddra_llt_version is not null  and a.meddra_pt is  null) or (a.meddra_llt_version is  null  and a.meddra_pt is not null)

select  a.report_id, a.reported_adr_id, count(1) as cnt
from History.ReportedAdr a
group by a.report_id, a.reported_adr_id
order by cnt desc

select *
from History.ReportedAdr a
where a.report_id =20140  and a.reported_adr_id=64779
order by a.update_date  

select distinct a.report_id,  a.reported_adr_id ,a.a.create_date, a.meddra_pt,a. a.report_version, a.update_date
--??a.drug_role_code - all is null
--p.product_id, p.product_id, p.dr_reg_num, p.product_name_eng,p.product_name_heb,p.product_type_code,p.create_date, p.drug_role_code,p.report_version, p.update_date 
from History.ReportedAdr a
where a.report_id =20140  and a.reported_adr_id=64779
order by a.update_date ,a.report_version

--+++++++++++++++Meddra heirarchy exploraion
--pt which belongs to more than one hierarchy
select m.pt_code, count (1) as cnt
from Meddra.[1_md_hierarchy] m
group by m.pt_code
having count (1) >1
order by cnt  desc


--For the above records found, compare m.soc_code TO m.pt_soc_code
select distinct m.pt_code, m.soc_code , m.pt_soc_code
from Meddra.[1_md_hierarchy] m
where  m.soc_code <> m.pt_soc_code
and m.pt_code in (
  select m1.pt_code--, count (1) as cnt
  from Meddra.[1_md_hierarchy] m1
  group by m1.pt_code
  having count (1) >1)

--  For one example from the above - is there more then ONE m.pt_soc_code per pt_code --> pt_soc_code is the primary SOC for aggraegations in the hierarchy - therefore see the next query
  select m.pt_code, m.soc_code , m.pt_soc_code, m.primary_soc_fg
from Meddra.[1_md_hierarchy] m
where 
m.pt_code =10064063

--!!!!!!!!!!!!How to extract the correct hierarchy of Meddra for aggregations:
select m.pt_code,m.hlt_code, m.hlgt_code, m.soc_code 
from Meddra.[1_md_hierarchy] m
where  m.primary_soc_fg = 'Y'--m.soc_code =  m.pt_soc_code
and m.pt_code =10064063


--Number of records for m.soc_code = pt_soc_code  - run both 2 below queries together
select distinct count(m.pt_soc_code) 
  from Meddra.[1_md_hierarchy] m

select distinct count(m.soc_code)
  from Meddra.[1_md_hierarchy] m


--Are all the m.pt_soc_code included in m.soc_code - YES
select distinct count(m.pt_soc_code)
  from Meddra.[1_md_hierarchy] m
  where m.pt_soc_code  in (
      select distinct m1.pt_soc_code 
      from Meddra.[1_md_hierarchy] m1)
      
-- llt to pt connection:  There are ptcodes in llt that don't exist in 1_md_hierarchy --> problem: 
--can't complete the hierarchy for llt level so can't use it
-- (in cases of indication fileds in different source tables)
select l.llt_code, l.pt_code ,m.pt_code 
from Meddra.[1_low_level_term]l 
left join Meddra.[1_md_hierarchy] m on l.pt_code = m.pt_code      
+++++++++++

--+++++++++++++++Reports FACT exploration
select r.report_id, count(r.report_id) as cnt
--r.report_version
from History.Reports r
where r.report_type_code >1 --Not primary
group by r.report_id
order by cnt desc
 --and len(r.report_sys_num)>5
 
  --In History there MANY records
--And an ellaboration of such report_id
select r.report_id, r.update_date, r.report_version, r.update_report_version, r.internal_report_status_code, r.internal_closing_reason_code,
r.instant, r.assigned_to, r.report_type_code, 
r.patient_id, r.event_place_code, r.event_severity_code, 
r.report_e2b_type_code, r.first_receive_date, r.report_sys_num,  r.event_date
from History.Reports r
where r.report_id =4455 -- 4455 --15271
order by r.update_date
--and r.report_type_code >1 --Not primary

 --In dbo there is only 1 record
select r.report_id, r.update_date, r.event_date, r.report_type_code, r.report_sys_num, 
r.patient_id, r.event_place_code, r.event_severity_code, r.internal_report_status_code,
r.report_e2b_type_code, r.first_receive_date, 
 r.internal_closing_reason_code, r.assigned_to,  r.instant
--r.report_version
from dbo.Reports r
where r.report_id =15271 -- 4455 --15271

--See this record only in Reports
select r.internal_report_status_code, r.assigned_to, r.update_date, *
from History.Reports his
full outer join dbo.Reports cur on cur
where r.report_id =25777 -- 15271 --4455
order by r.update_date

-- in dbo: Connetion between report, adr, product
--Run in qa
select r.report_id, r.update_date,r.report_version,a.patient_description, /*r.update_report_version, p.report_version as p_ver, r.report_version,*/ r.internal_report_status_code, r.internal_closing_reason_code,
p.product_id, p.dr_reg_num, p.product_name_eng,p.product_type_code, p.update_date, p.drug_role_code /*p.report_version,*/
from dbo.Reports r
join dbo.Products p on r.report_id = p.report_id
join dbo.ReportedAdr a on r.report_id = a.report_id
--and r.update_date = p.update_date
--and r.update_report_version = p.report_version
where r.report_id = 349 -- 15271 --4455
order by r.update_date

--Reports to product connection
--History
select r.report_id, r.update_date,r.report_version, r.update_report_version, p.report_version as p_ver, /*r.report_version,*/ r.internal_report_status_code, r.internal_closing_reason_code,
p.product_id, p.dr_reg_num, p.product_name_eng,p.product_type_code, p.update_date, p.drug_role_code /*p.report_version,*/
from History.Reports r
join History.Products p on r.report_id = p.report_id
--and r.update_date = p.update_date
and r.update_report_version = p.report_version
where r.report_id = 4455 -- 15271 --4455
order by r.update_date

--dbo
select r.report_id, r.update_date,r.report_version, /*r.update_report_version, p.report_version as p_ver, r.report_version,*/ r.internal_report_status_code, r.internal_closing_reason_code,
p.product_id, p.dr_reg_num, p.product_name_eng,p.product_type_code, p.update_date, p.drug_role_code /*p.report_version,*/
from dbo.Reports r
join dbo.Products p on r.report_id = p.report_id
--and r.update_date = p.update_date
--and r.update_report_version = p.report_version
where r.report_id = 4455 -- 15271 --4455
order by r.update_date

--See this record only in products
select *
from  History.Products p
where p.report_id =15271 --4455 

--Reports to reported ADR connection
select r.report_id, r.update_date,r.report_version, r.update_report_version, a.report_version as a_ver,  
a.adr_code, a.internal_adr_code, a.drug_role_code, a.meddra_pt
from History.Reports r
join History.ReportedAdr a on r.report_id = a.report_id
--and r.update_date = p.update_date
and r.update_report_version = a.report_version
where r.report_id =15271
order by r.update_date

--See this record only in ReportedAdr
select *
from  dbo.ReportedAdr a
where a.report_id =4455 --4455 

--+++++++++Fact reports  - can't let go of update_report_version - there maybe Products / ReportedAdr attached to it
-- Therefore, in Products/ ReportedAdr should we select distinct according report_version (=update_report_version)& other interesting FACT fields?
--History
select report_id,update_date,report_version,update_report_version, product_type_code,report_sys_num,patient_id,report_type_code,event_date,event_place_code,
event_severity_code,internal_report_status_code,create_date,update_user_code,report_date,
report_e2b_type_code,first_receive_date,internal_closing_reason_code,assigned_to,
create_user_code,receipt_date,instant
from History.Reports 
where report_id =4455 
order by update_date

--dbo
select report_id,update_date,report_version,product_type_code,report_sys_num,patient_id,report_type_code,event_date,event_place_code,
event_severity_code,internal_report_status_code,create_date,update_user_code,update_date,report_date,
report_e2b_type_code,first_receive_date,internal_closing_reason_code,assigned_to,
create_user_code,receipt_date,instant
from dbo.Reports 
where report_id =4455 

--Union select for reports
select r.report_id, r.update_date, r.report_version, /*r.update_report_version,*/ r.internal_report_status_code, r.internal_closing_reason_code,
r.instant, r.assigned_to, r.report_type_code, 
r.patient_id, r.event_place_code, r.event_severity_code, 
r.report_e2b_type_code, r.first_receive_date, r.report_sys_num,  r.event_date
from History.Reports r
where r.report_id =4455 -- 4455 --15271
union select d.report_id, d.update_date, d.report_version, /*d.update_report_version,*/ d.internal_report_status_code, d.internal_closing_reason_code,
d.instant, d.assigned_to, d.report_type_code, 
d.patient_id, d.event_place_code, d.event_severity_code, 
d.report_e2b_type_code, d.first_receive_date, d.report_sys_num,  d.event_date
from dbo.Reports d
where d.report_id =4455 -- 4455 --15271
order by r.update_date

--missing code for liver \renal_insufficiency
select renal_insufficiency, count(p.renal_insufficiency)
from dbo.Patients p
group by p.renal_insufficiency

--Identify recurring reports - NOT sure it is possible: 
--when report_type_code =1 slice by create_date
--when report_type_code =2 slice by update_date? - not sure the update_date was due to report_type_code change from 1 to 2
select r.create_date, r.update_date 
from dbo.Reports r
where r.report_type_code =1 --2

--DrugAdrReccurrence connections
select d.*, p.product_name_eng, p.product_name_heb,a.drug_role_code, a.meddra_pt
from dbo.DrugAdrReccurrence d
join dbo.Products p on d.report_id = p.report_id and d.drug_id = p.product_id
join dbo.ReportedAdr a on d.reported_adr_id = a.reported_adr_id 

--report status connection: internal_report_status_code is always as the last status in statusHistory
select distinct r.report_id, r.internal_report_status_code, s.report_status_code, s.create_date, s.end_date
from dbo.Reports r
join dbo.ReportStatusHistory s on r.report_id = s.report_id
order by r.report_id ,s.create_date

--Rozet
SELECT * FROM ReportingAgent ra
     join Reports r on r.report_id = ra.report_id
     join ReportingAgentTypesCode rat on  rat.reporting_agent_type_code = ra.reporting_agent_type_code and r.report_xml_format = rat.report_format_code
     join ReportingAgentTypesGroups ratg on rat.reporting_agent_type_code = ratg.reporting_agent_type_code and r.report_xml_format = ratg.report_format_code

--EventPlace - dim
select * from  dbo.PurchasingPlaceCode
union
select * from  dbo.EventPlaceCode

--ReportingAgentTypesGroups - connection to ReportingAgentGroupsCode
SELECT   "reporting_agent_groups_desc" =
  CASE 
     WHEN gc.reporting_agent_groups_desc is null THEN 'Does not exist'

     ELSE gc.reporting_agent_groups_desc
  END
from ReportingAgentGroupsCode gc
right join  ReportingAgentTypesGroups tg on gc.reporting_agent_groups_code = tg.reporting_agent_group_code
and gc.product_type_code = tg.product_type_code

--ReportingAgentTypesGroups - connection to ReportingAgentTypesCode
select "reporting_agent_desc"= --, tc.reporting_agent_desc_eng
  CASE 
     WHEN tc.reporting_agent_desc is null THEN 'Does not exist'

     ELSE tc.reporting_agent_desc
  END

from ReportingAgentTypesCode tc
right join ReportingAgentTypesGroups tg on tg.reporting_agent_type_code = tc.reporting_agent_type_code 
AND tg.report_format_code = tc.report_format_code
AND tg.product_type_code = tc.product_type_code

-- Connection for  DrugAdrReccurrence
select dr.*, a.adr_code, p.product_name_eng --, r.patient_id
from dbo.DrugAdrReccurrence dr
--right join dbo.Reports r on r.report_id = dr.report_id 
left join dbo.ReportedAdr a on dr.report_id= a.report_id  and  dr.reported_adr_id = a.reported_adr_id
left join dbo.Products p on dr.report_id = p.report_id  and dr.drug_id = p.product_id 
 --
 --++++++++++++++++++++++According Active sub + meddra code / name
select distinct r.report_id, r.create_date, r.report_date, tc.report_type_desc as primary_type,
"reporting_mean_code"=
  CASE 
     WHEN r.report_e2b_type_code is not null THEN 'e2b'
     Else  'Tofes'
  End, p.product_id, 
  p.product_name_eng, p.dr_reg_num,das.active_substance_name,atc.atc5_text_europe, atc.atc5_text_usa,
  atc.atc5_code,  atc.atc4_text,atc.atc4_text,atc.atc3_text,atc.atc2_text,
  atc.atc1_text, a.reported_adr_id,  a.meddra_pt, m.pt_code, m.pt_name

    
from dbo.Reports r
left join dbo.Products p on r.report_id = p.report_id
left join ReportTypeCode tc on  r.report_type_code =tc.report_type_code 
left join DrugActiveSubstance das on p.product_id = das.product_id
left join [pharma].[dbo].[atc_codes] atc 
on UPPER(das.active_substance_name) = UPPER(atc.atc5_text_europe)
or UPPER(das.active_substance_name) = UPPER(atc.atc5_text_usa)
left join dbo.ReportedAdr a on r.report_id = a.report_id
left join Meddra.[1_md_hierarchy] m on (a.meddra_pt =  CONVERT(nvarchar(250),m.pt_code) or lower(a.meddra_pt) =lower(m.pt_name))
and m.primary_soc_fg = 'Y'
where r.create_date between Convert(datetime, '05/01/2017') and Convert(datetime, '05/31/2017')
 

 --++++++++++According products.dr_reg_num = drugs.dr_obj_id 
 --or lower(p.product_name_eng/heb)=lower(d.dr_name_e/h)+ meddra code / name
select distinct r.report_id, r.create_date, r.report_date, tc.report_type_desc as primary_type,
"reporting_mean_code"=
  CASE 
     WHEN r.report_e2b_type_code is not null THEN 'e2b'
     Else  'Tofes'
  End, p.product_id, 
  p.product_name_eng,p.product_name_heb, p.dr_reg_num, d.dr_name_e, d.dr_name_h,
  atc.atc5_code,  atc.atc4_text,atc.atc4_text, a.reported_adr_id,  a.meddra_pt, m.pt_code, m.pt_name

    
from dbo.Reports r
left join dbo.Products p on r.report_id = p.report_id
left join ReportTypeCode tc on  r.report_type_code =tc.report_type_code 
left join pharma.dbo.drugs d on (p.dr_reg_num is not null and  p.dr_reg_num = d.dr_objid) 
or (p.product_name_eng is not null and replace(lower(p.product_name_eng),';','')=lower(d.dr_name_e)) 
or (p.product_name_heb is not null and REPLACE(lower(p.product_name_heb),';','')=lower(cast (d.dr_name_h as nvarchar(128)) collate SQL_Latin1_General_CP850_BIN2))
left join pharma.dbo.drug_atc_codes drug_atc on (d.dr_objid = drug_atc.dr_objid and d.dr_rq_objid = drug_atc.dr_rq_objid)
left join pharma.dbo.atc_codes atc on drug_atc.atc4_code = atc.atc4_code and drug_atc.atc5_code = atc.atc5_code
--left join DrugActiveSubstance das on p.product_id = das.product_id
--left join [pharma].[dbo].[atc_codes] atc on UPPER(das.active_substance_name) = UPPER(atc.atc5_text_europe)
--or UPPER(das.active_substance_name) = UPPER(atc.atc5_text_usa)
left join dbo.ReportedAdr a on r.report_id = a.report_id
left join Meddra.[1_md_hierarchy] m on (a.meddra_pt =  CONVERT(nvarchar(250),m.pt_code) or lower(a.meddra_pt) =lower(m.pt_name))
and m.primary_soc_fg = 'Y'
where r.create_date between Convert(datetime, '05/01/2017') and Convert(datetime, '05/31/2017')

 --++++++++++SEPERATELY without Active_substance and adr connection - According products.dr_reg_num = drugs.dr_obj_id 
  --lower(p.product_name_eng)=lower(d.dr_name_e)+ meddra code / name
select distinct r.report_id, r.create_date, r.report_date, tc.report_type_desc as primary_type,
"reporting_mean_code"=
  CASE 
     WHEN r.report_e2b_type_code is not null THEN 'e2b'
     Else  'Tofes'
  End, p.product_id, 
  p.product_name_eng,p.product_name_heb, p.dr_reg_num, d.dr_name_e, d.dr_name_h,
  atc.atc5_code,  atc.atc4_text,atc.atc4_text
  --, a.reported_adr_id,  a.meddra_pt, m.pt_code, m.pt_name

    
from dbo.Reports r
left join dbo.Products p on r.report_id = p.report_id
left join ReportTypeCode tc on  r.report_type_code =tc.report_type_code 
left join pharma.dbo.drugs d 
--on (p.dr_reg_num = d.dr_objid) 
--on (replace(lower(p.product_name_eng),';','')=lower(d.dr_name_e)) 
on (REPLACE(lower(p.product_name_heb),';','')=lower(cast (d.dr_name_h as nvarchar(128)) collate SQL_Latin1_General_CP850_BIN2))
left join pharma.dbo.drug_atc_codes drug_atc on (d.dr_objid = drug_atc.dr_objid and d.dr_rq_objid = drug_atc.dr_rq_objid)
left join pharma.dbo.atc_codes atc on drug_atc.atc4_code = atc.atc4_code and drug_atc.atc5_code = atc.atc5_code
--left join DrugActiveSubstance das on p.product_id = das.product_id
--left join [pharma].[dbo].[atc_codes] atc on UPPER(das.active_substance_name) = UPPER(atc.atc5_text_europe)
--or UPPER(das.active_substance_name) = UPPER(atc.atc5_text_usa)
--left join dbo.ReportedAdr a on r.report_id = a.report_id
--left join Meddra.[1_md_hierarchy] m on (a.meddra_pt =  CONVERT(nvarchar(250),m.pt_code) or lower(a.meddra_pt) =lower(m.pt_name))
--and m.primary_soc_fg = 'Y'
where r.create_date between Convert(datetime, '05/01/2017') and Convert(datetime, '05/31/2017')
and  d.dr_name_h is not null and p.product_name_heb is not null 
--and  d.dr_name_e is not null and p.product_name_eng is not null
--and p.dr_reg_num is not null
and p.product_id not in (
select p1.product_id
from dbo.Products p1
join DrugActiveSubstance das1 on p1.product_id = das1.product_id
)

  --++++++++++According Active sub   and without adr connection  
select distinct r.report_id, r.create_date, r.report_date, tc.report_type_desc as primary_type,
"reporting_mean_code"=
  CASE 
     WHEN r.report_e2b_type_code is not null THEN 'e2b'
     Else  'Tofes'
  End, p.product_id, 
  p.product_name_eng, p.dr_reg_num,das.active_substance_name,atc.atc5_text_europe, atc.atc5_text_usa,
  atc.atc5_code,  atc.atc4_code,atc.atc4_text,atc.atc3_text,atc.atc2_text,
  atc.atc1_text
  --, a.reported_adr_id,  a.meddra_pt, m.pt_code, m.pt_name

    
from dbo.Reports r
left join dbo.Products p on r.report_id = p.report_id
left join ReportTypeCode tc on  r.report_type_code =tc.report_type_code 
left join DrugActiveSubstance das on p.product_id = das.product_id
left join [pharma].[dbo].[atc_codes] atc 
on UPPER(das.active_substance_name) = UPPER(atc.atc5_text_europe)
or UPPER(das.active_substance_name) = UPPER(atc.atc5_text_usa)
--left join dbo.ReportedAdr a on r.report_id = a.report_id
--left join Meddra.[1_md_hierarchy] m on (a.meddra_pt =  CONVERT(nvarchar(250),m.pt_code) or lower(a.meddra_pt) =lower(m.pt_name))
--and m.primary_soc_fg = 'Y'
where r.create_date between Convert(datetime, '05/01/2017') and Convert(datetime, '05/31/2017')
--and das.active_substance_name is not null 
/*
and p.product_id in (
select p1.product_id
from dbo.Products p1
join DrugActiveSubstance das1 on p1.product_id = das1.product_id
)
*/

--+++++++++
--Counts for Excel - Genady - in \\fsmtt\users\amir.shaked\Amir\תופעות לוואי\Comparisons\Pt_Code_name..xlsx
--+++++++++



--+++++
--If we only have dr_objid it is not enough to connect to only one atc5_atc4 (desired in ordr to connect to atc_codes table) --> need also from Proucts dr_rq_objid - Rozet?
--Look at tab = dr_rq_objid in Excel: \\fsmtt\users\amir.shaked\Amir\תופעות לוואי\Comparisons\Pt_Code_name.xlsx for example on dr_objid=2061800
select dac.dr_objid, dac.atc5_code,dac.atc4_code, count(1) as cnt
from pharma.dbo.drug_atc_codes dac
where dac.atc5_code is not null
group by dac.dr_objid, dac.atc5_code, dac.atc4_code
having count(1) >1
order by dac.dr_objid

--+++++
--If we only have dr_objid it is not enough to connect to only one dr_objid
--Look at tab = dr_name_e in Excel: \\fsmtt\users\amir.shaked\Amir\תופעות לוואי\Comparisons\Pt_Code_name.xlsx for example on dr_name_e=5-FLUOROURACIL 25 MG/ML VIAL 
--(it is connected o 2 dufferent dr_objid)
select d.dr_name_e, d.dr_objid,  count(1) as cnt
from pharma.dbo.drugs d
--where d.dr_name_e ='' --is not null
group  by d.dr_name_e, d.dr_objid
order by d.dr_name_e
--++++++++++++++++++++++
--Dorit
select a.report_id, a.drug_id, count(1) 
from dbo.DrugAdrAssessment a
group by a.report_id, a.drug_id
having count(1) >1
;
select *
from dbo.DrugAdrAssessment a
where a.report_id= 16036 and a.drug_id=39483
;

select d.product_id, count(distinct d.active_substance_id)
from dbo.DrugActiveSubstance d
group by d.product_id
having count(distinct d.active_substance_id)>1
;
select  *
from dbo.DrugActiveSubstance d
where d.product_id = 7185 
;
select d.adr_code , count (distinct d.meddra_pt)
from dbo.ReportedAdr d
group by d.adr_code
having count (distinct d.meddra_pt)>1
;
select distinct  ad.adr_code, ad.meddra_pt
from dbo.ReportedAdr ad
where ad.adr_code = '10010106'
;
--The main select - Dorit
select distinct daa.report_id, isNull(daa.drug_id,p.product_id) as product_id, daa.reported_adr_id, daa.adr_code
from dbo.ReportedAdr adr 
left join dbo.DrugAdrAssessment daa on adr.report_id = daa.report_id and adr.reported_adr_id = daa.reported_adr_id
right join dbo.Products p on  daa.report_id = p.report_id and daa.drug_id= p.product_id
where adr. reported_adr_id is not null
--where adr.adr_code is not null

;
--The number of rows of the main select from Dorit should be as multiplication between the following 2 selects
select select sum ( adr.adr_cnt * prd.prd_cnt)
  (select p.report_id, count(p.product_id) as prd_cnt from Products p) prd 
    (select a.report_id, count(a.reported_adr_id) as adr_cnt from ReportedAdr) adr
where adr.report_id = prd.report_id


 -- 249 455 
 
 select * from dbo.DrugAdrAssessment daa 
 where daa.report_id = 251 and daa.drug_id=459
 --++++++++++++++++++++++example - return only those Table2 rows which are not matched in Table1 
 --https://stackoverflow.com/questions/19172577/how-do-i-merge-two-tables-with-different-column-number-while-removing-duplicates
SELECT t2.*, t1.*
FROM
    dbo.DrugAdrAssessment AS t2
    LEFT JOIN dbo.DrugAdrReccurrence AS t1
    ON 
            t2.drug_id = t1.drug_id
        AND t2.report_id = t1.report_id
        AND t2.reported_adr_id = t1.reported_adr_id
  WHERE t1.reccurrence_id Is Null;
  ++++++++++++++++
  --Create dim products 
  select distinct p.dr_reg_num, p.product_name_eng, p.product_name_heb, d.dr_name_e, d.dr_name_h
from Products p
join pharma.dbo.drugs d on p.dr_reg_num = d.dr_objid
or dr_name_e = p.product_name_eng or N'dr_name_h' =N'p.product_name_heb'
and d.dr_record_type in(1,3,5,7)
;
--country codes - run in EDM
SELECT TOP 1000 [Code]
      ,[Description]
      ,[Description_eng]
      ,[Continent_code]
      ,[Country_merkava_code]
        FROM [EDM].[dbo].[country]
  where [Country_merkava_code] in (
  'IL',
'PS', --N רשות פלסטינית
'ES',
'JP',
'DE',
'US',
'FR',
'BE',
'CA',
'IT',
'NL',
'IE',
'BR',
'CL'
  )
  -++++++++++Find drugs from PatientDrugHistory in drugs
  select h.*
from dbo.PatientDrugHistory h
where UPPER(h.drug_name) in 
  (select UPPER(cast (d.dr_name_e as nvarchar(128)) collate SQL_Latin1_General_CP850_BIN2)
  from pharma.dbo.drugs d )
  ;
  --+++++Find primary key
  SELECT  distinct dr_objid,  count(1)
FROM pharma.dbo.drugs d
group by dr_objid
having  count(1)>1

--++++is dr_registery_date the bening of each license ? = Yes
SELECT d.dr_objid, d.dr_name_e, d.dr_name_h,  d.dr_registery_date,d.dr_reg_exp_date, d.dr_reg_num, d.dr_manufacturer, d.dr_manufacturer_desc
FROM pharma.dbo.drugs d
where d.dr_objid=2698400

-- building stg_conn_drug_atc with BI_Enrich_ind=1
----Find does in enriching table - das
select atc.atc5_code, atc.atc4_code
from  SideEffects.dbo.DrugActiveSubstance das
left join pharma.dbo.atc_codes atc on UPPER(das.active_substance_name) = UPPER(atc.atc5_text_europe)
or UPPER(das.active_substance_name) = UPPER(atc.atc5_text_usa)
c.atc5_code, c.atc4_code 

EXCEPT

--That doesn't exist in the connection table - conn
select conn.atc5_code, conn.atc4_code
from pharma.dbo.drug_atc_codes conn
--------
--dim_product QA
select *
from dwh.Dim_Product p 
where p.dr_objid = 3374601    -- -888 signal?
and p.dr_rq_objid =  110850    -- -888 
--run against:
select distinct *
from dwh.Dim_Drugs d
where d.dr_objid = 3374601   
and d.dr_rq_objid =  110850    

--QA for null - should put -999: No problem sine there is no dwh.dim_drugs.dr_reg_num is null
select *
from dwh.Dim_Product p 
where p.dr_reg_num is null
-- Compare against
select *
from dwh.Dim_Drugs d
where d.dr_reg_num is null

--מופע של תרופה באותו שם כישויות שונות
 SELECT distinct d.dr_reg_num ,d.dr_objid, d.dr_rq_objid, d.dr_name_e, d.dr_name_h, d.dr_manufacturer,d.dr_registery_date , max(d.dr_reg_exp_date) as max_exp
  FROM mrr.Drugs d
  where d.dr_record_type in (1,3,5,7) and d.dr_name_e = 'acamol' 
  GROUP BY d.dr_reg_num ,d.dr_objid, d.dr_rq_objid, d.dr_name_e, d.dr_name_h, d.dr_manufacturer,d.dr_registery_date
  order by d.dr_name_e

--תרופות שמופיעות יותר מפעם אחת בטבלת הקשר drug_atc_codes  :
select  a.dr_objid , a.dr_rq_objid, a.dr_name_e,
     Rank() over (partition by a.dr_objid order by a.dr_rq_objid desc ) As Rnk
  from dbo.drug_atc_codes  con
   join
     (SELECT distinct d1.dr_objid , d1.dr_rq_objid ,d1.dr_name_e, max(d1.dr_reg_exp_date) as max_exp /* max(d1.dr_registery_date) as max_reg, */ 
  FROM dbo.drugs d1
  where d1.dr_record_type in (1,3,5,7) --and dr_objid is not null and dr_rq_objid is not null and dr_name_e is not null
  GROUP BY d1.dr_objid,d1.dr_rq_objid,d1.dr_name_e --,d1.dr_registery_date
    ) a
    on con.dr_objid = a.dr_objid and  con.dr_rq_objid = a.dr_rq_objid
    order by Rnk desc   

--פרוט לדוגמא של אחת התרופות הנ"ל בתוך טבלת הקשר:
SELECT distinct con.dr_objid, con.dr_rq_objid, con.atc5_code, con.atc4_code
  FROM dbo.drug_atc_codes  con
  left join dbo.drugs d on con.dr_objid = d.dr_objid and  con.dr_rq_objid = d.dr_rq_objid
  where d.dr_record_type in (1,3,5,7) 
  and con.dr_objid =3192200
  order by con.dr_objid, con.dr_rq_objid
  
  --Is_step_first example (=1 every time we move to a new step)
  --in the src system
  select st.*
from dbo.Reports r
left join dbo.ReportStatusHistory st on r.report_id = st.report_id
where r.report_id = 68
order by st.create_date

  --and in the DWH
  select stp.first_receive_date, stp.step_start_date, stp.step_end_date_active ,stp.date_day_key, stp.assigned_to_user ,
stp.is_step_first, stp.status_per_date
--,Rank() over (partition by stp.report_gk order by stp.date_day_key asc ) As Rnk
from dwh.vw_Fact_Side_Effects_Treatment_Steps_By_Day stp

where stp.reporting_method_code = 1 and stp.update_type_code not in (3,41) 
and stp.report_id = 68 
order by stp.date_day_key
--
--דיווחי תופעות לוואי שאינן מתחילות step_code=1  - No such thing
select inner_sql.report_id , inner_sql.report_status_code, inner_sql.create_date
from (
select st.report_id,  st.report_status_code, st.create_date, 
Rank() over (partition by st.report_id order by st.create_date asc ) As Rnk
from dbo.ReportStatusHistory st
) inner_sql
where inner_sql.report_status_code <>1 and inner_sql.Rnk=1

--Example for creating own data
declare @test table(date varchar(10),qty int,product varchar(10))

insert into @test values ('Jan',4,'Apples')
insert into @test values ('Jan',6,'Apples')
insert into @test values ('Jan',2,'Bananas')
insert into @test values ('Feb',1,'Bananas')

--select * from @test

SELECT date,qty,product,Rank() OVER(PARTITION BY product ORDER BY date desc,qty) 
FROM @test
---
--find Reports with more than one cycle
select r.report_id, count(r.report_GK) as cnt
from dwh.vw_fact_Side_Effects_Report r
group by r.report_id
having count(r.report_GK)>1
