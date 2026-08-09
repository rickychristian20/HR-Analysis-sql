-- ============================================
-- Data Cleaning
-- ============================================

1. Cek Duplicate
SELECT
	empid,
	COUNT(*)
FROM hr.employee
GROUP BY 1
HAVING COUNT(*) > 1;

-- Result: Found 10 duplicate records.

2. Remove Duplicate Records

WITH dup AS (
    SELECT
        ctid,
        ROW_NUMBER() OVER (
            PARTITION BY empid
            ORDER BY ctid
        ) AS rn
    FROM hr.employee
)
DELETE FROM hr.employee
WHERE ctid IN (
    SELECT ctid
    FROM dup
    WHERE rn > 1
);
(Note : ctid is a PostgreSQL system column that uniquely)

3. Verify Duplicate Records Have Been Removed

SELECT
    empid,
    COUNT(*) AS total_duplicate
FROM hr.employee
GROUP BY empid
HAVING COUNT(*) > 1;
--Result : 0   

4. Check Missing Value
SELECT
    COUNT(*) AS total_data,
    COUNT(empid) AS empid,
    COUNT(department) AS department,
    COUNT(job_role) AS job_role,
    COUNT(monthly_income) AS monthly_income
FROM hr.employee;
--Result : 0

5. Check Unique Values
SELECT DISTINCT attrition
FROM hr.employee;

SELECT DISTINCT gender
FROM hr.employee;

SELECT DISTINCT department
FROM hr.employee;

SELECT DISTINCT education_field
FROM hr.employee;

SELECT DISTINCT job_role
FROM hr.employee;

SELECT DISTINCT marital_status
FROM hr.employee;

SELECT DISTINCT business_travel
FROM hr.employee;

--Result : 0