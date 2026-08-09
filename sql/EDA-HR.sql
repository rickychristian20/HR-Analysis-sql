-- ============================================
-- Exploratory Data Analysis
-- ============================================

1. KPI 

WITH kpi AS (
	SELECT
		COUNT(empid) AS total_employee,
		COUNT(*) FILTER (WHERE attrition = 'No') AS employee_active,
		COUNT(*) FILTER (WHERE attrition = 'Yes') AS employee_non_active
	FROM hr.employee
)
SELECT
	total_employee,
	employee_active,
	ROUND((employee_active*100.0) /total_employee,2) active_rate,
	employee_non_active AS attrition,
	ROUND((employee_non_active *100.0) /total_employee,2) attrition_rate
FROM kpi;

2. Department Analysis

--Total Employee by Department
SELECT
	department,
	COUNT(empid)
FROM hr.employee
GROUP BY department;

--Department by Attrion
SELECT
	department,
	COUNT(*) FILTER(WHERE attrition = 'No') employee_active,
	COUNT(*) FILTER(WHERE attrition = 'Yes') employee_non_active
FROM hr.employee
GROUP BY department;

--Active Employees by Department and Gender
SELECT
	department,
	COUNT(*) AS employee_active,
	COUNT(*) FILTER(WHERE gender = 'Female') AS female,
	COUNT(*) FILTER(WHERE gender = 'Male') AS Male
FROM hr.employee
WHERE attrition = 'No'
GROUP BY department;

--Average Salary by Department
SELECT
	department,
	ROUND(AVG(monthly_income)) avg_income
FROM hr.employee
GROUP BY department;

3.Job Role Analysis

-- Total Empolyee Active by Job Role
SELECT
	job_role,
	COUNT(*) total_employee
FROM hr.employee
WHERE attrition = 'No'
GROUP BY job_role
ORDER BY total_employee DESC;

--Average Salary by Job Role
SELECT
	job_role,
	ROUND(AVG(monthly_income)) AS average_salary 
FROM hr.employee
GROUP BY job_role;

--Dominant Age Group by Job Role
WITH job AS (
	SELECT
		job_role,
		age_group,
		COUNT(*) AS total_employees,
		ROW_NUMBER() OVER (
			PARTITION BY job_role ORDER BY COUNT(*) DESC) rn
	FROM hr.employee
	GROUP BY job_role, age_group
)
SELECT
	job_role,
	age_group,
	total_employees
FROM job
WHERE rn = 1
ORDER BY total_employees DESC;

4. Education Analysis

-- Total Employee Active by Education
SELECT
	education_field,
	COUNT(*) FILTER(WHERE attrition = 'No') total_employees
FROM hr.employee
GROUP BY 1;


--Average Salary & Attrition by Education Field
SELECT
    education_field,
    COUNT(*) AS total_employee,
    ROUND(AVG(monthly_income)) AS average_salary,
    COUNT(*) FILTER (WHERE attrition = 'No') AS attrition
FROM hr.employee
GROUP BY education_field
ORDER BY total_employee DESC;

5. Over TIme Analysis

--Over Time by Employees
SELECT
	over_time
	COUNT(*) total_employees,
FROM hr.employee
group by over_time;

-- Employee Status by Overtime
SELECT
    CASE
        WHEN attrition = 'No' THEN 'Active'
        ELSE 'Non Active'
    END AS employee_status,
    over_time,
    COUNT(*) AS total_employees
FROM hr.employee
GROUP BY attrition,over_time
ORDER BY attrition,over_time;

--Total Overtime Employees by Department
SELECT
    department,
    COUNT(*) FILTER (WHERE over_time = 'Yes') AS overtime_yes,
    COUNT(*) FILTER (WHERE over_time = 'No') AS overtime_no
FROM hr.employee
GROUP BY department
ORDER BY overtime_yes DESC;

--Total Overtime Employees by Job Role
SELECT
    job_role,
    COUNT(*) FILTER (WHERE over_time = 'Yes') AS overtime_yes,
    COUNT(*) FILTER (WHERE over_time = 'No') AS overtime_no
FROM hr.employee
GROUP BY job_role
ORDER BY overtime_yes DESC;

--Total Overtime Employee by gender
SELECT
    gender,
    COUNT(*) FILTER (WHERE over_time = 'Yes') AS overtime_yes,
    COUNT(*) FILTER (WHERE over_time = 'No') AS overtime_no
FROM hr.employee
GROUP BY gender
ORDER BY overtime_yes DESC;

5. Experience Analysis

-- Average Years at Company by Job Role
SELECT
    COUNT(*) employees_active,
    job_role,
    ROUND(AVG(years_at_company),1)AS avg_years
FROM hr.employee
WHERE attrition = 'No'
GROUP BY job_role
ORDER BY avg_years DESC;