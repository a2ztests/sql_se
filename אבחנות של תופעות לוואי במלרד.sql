select year(CONVERT(date, convert(char(8),f_diag.Visit_Start_Date))) as year, 
d_diag.diagnose_code, d_diag.diagnose_desc,
count (distinct d_diag.diagnose_code) as cnt_diag,
--Count(d_diag.diagnose_code)
--/*
100 * (Count(d_diag.diagnose_code) /

(Select Count(*) 
From dwh.Fact_Med_Visit_Patient_Visit_Diagnostics f_diag1
inner join dwh.Dim_Med_Visit_Diagnostics d_diag1 on f_diag1.ICD9_First_Diagnostic_code = d_diag1.diagnose_code
or f_diag1.ICD9_Secondary_Diagnostic_code = d_diag1.diagnose_code
left join dwh.Dim_institute_Department d1 on f_diag1.department_code = d1.dept_code_level_5
where 
d1.institute_type_desc = 'אשפוז כללי'
and (ltrim(rtrim(d1.dept_long_desc_level_5)) = 'רפואה דחופה'
or ltrim(rtrim(d1.dept_long_desc_level_5))  = 'רפואה דחופה ילדים'
or ltrim(rtrim(d1.dept_long_desc_level_5))  = 'רפואה דחופה כירורגיה'
or ltrim(rtrim(d1.dept_long_desc_level_5)) = 'רפואה דחופה מהלכים'
or ltrim(rtrim(d1.dept_long_desc_level_5)) = 'רפואה דחופה פנימית')

and CONVERT(date, convert(char(8),f_diag1.Visit_Start_Date)) between '2016-01-01' AND '2016-01-02' --'2016-01-01' AND '2016-12-31'
) 

) as Percent_Of_Total_Cases
--*/
from dwh.Fact_Med_Visit_Patient_Visit_Diagnostics f_diag
inner join dwh.Dim_Med_Visit_Diagnostics d_diag on f_diag.ICD9_First_Diagnostic_code = d_diag.diagnose_code
or f_diag.ICD9_Secondary_Diagnostic_code = d_diag.diagnose_code
left join dwh.Dim_institute_Department d on f_diag.department_code = d.dept_code_level_5
where 
d.institute_type_desc = 'אשפוז כללי'
and (ltrim(rtrim(d.dept_long_desc_level_5)) = 'רפואה דחופה'
or ltrim(rtrim(d.dept_long_desc_level_5))  = 'רפואה דחופה ילדים'
or ltrim(rtrim(d.dept_long_desc_level_5))  = 'רפואה דחופה כירורגיה'
or ltrim(rtrim(d.dept_long_desc_level_5)) = 'רפואה דחופה מהלכים'
or ltrim(rtrim(d.dept_long_desc_level_5)) = 'רפואה דחופה פנימית')
and CONVERT(date, convert(char(8),f_diag.Visit_Start_Date)) between '2015-01-01' AND '2016-12-31' --'2016-01-01' AND '2016-12-31'
 and d_diag.diagnose_code in (
 '99529',
'29281',
'30483',
'9756',
'29282',
'3049',
'6483',
'30490',
'29283',
'304',
'9095',
'64830',
'35924',
'29284',
'30491',
'19.2',
'29285',
'30492',
'29289',
'30493',
'E945',
'64833',
'2929',
'E9504',
'64834',
'6930',
'E9505',
'E8558',
'V098',
'E8559',
'E8588',
'6555',
'E8589',
'E947',
'E858',
'65551',
'292',
'65552',
'33385',
'2920',
'65553',
'65554',
'E946',
'28803',
'974',
'3046',
'30462',
'E941',
'30463',
'3047',
'3059',
'9952',
'30590',
'3576')
group by year(CONVERT(date, convert(char(8),f_diag.Visit_Start_Date))),d_diag.diagnose_code, d_diag.diagnose_desc
order by count (distinct d_diag.diagnose_code) desc