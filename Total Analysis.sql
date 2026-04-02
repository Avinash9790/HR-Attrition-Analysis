-- ================================================
-- HR Attrition Analysis - All Queries
-- Dataset: HR_Attrition.csv (11,991 rows)
-- Tool: MySQL
-- ================================================


-- ================================================
-- 00. Clean Salary Column
-- ================================================
UPDATE hr_attrition
SET Salary = REPLACE(Salary, '\r', '');


-- ================================================
-- 01. Overall Attrition Rate
-- ================================================
SELECT  
    ROUND(AVG(Employee_Left) * 100, 2) AS Attrition_Rate
FROM hr_attrition;
-- Result: 16.60%


-- ================================================
-- 02. Attrition by Department
-- ================================================
SELECT 
    Department,
    COUNT(*) AS Total_Employees,
    SUM(Employee_Left) AS Employees_Left,
    ROUND(AVG(Employee_Left) * 100, 2) AS Attrition_Rate
FROM hr_attrition
GROUP BY Department
ORDER BY Attrition_Rate DESC;
-- Result: HR highest (18.80%), Management lowest (11.93%)


-- ================================================
-- 03. Attrition by Salary Band
-- ================================================
SELECT 
    Salary,
    COUNT(*) AS Total_Employees,
    SUM(Employee_Left) AS Employees_Left,
    ROUND(AVG(Employee_Left) * 100, 2) AS Attrition_Rate
FROM hr_attrition
GROUP BY Salary
ORDER BY Attrition_Rate DESC;
-- Result: Low (20.45%), Medium (14.62%), High (4.85%)


-- ================================================
-- 04. Avg Satisfaction: Left vs Stayed
-- ================================================
SELECT 
    Employee_Left,
    ROUND(AVG(Satisfaction_Level), 2) AS Avg_Satisfaction,
    ROUND(AVG(Last_Evaluation), 2) AS Avg_Evaluation,
    ROUND(AVG(Average_Monthly_Hours), 2) AS Avg_Monthly_Hours
FROM hr_attrition
GROUP BY Employee_Left;
-- Result: Left = 0.44 satisfaction, Stayed = 0.67


-- ================================================
-- 05. Workload vs Performance Analysis
-- ================================================
SELECT 
    Employee_Left,
    CASE 
        WHEN Average_Monthly_Hours > 210 THEN 'High Hours'
        ELSE 'Normal Hours'
    END AS Hours_Category,
    ROUND(AVG(Last_Evaluation), 2) AS Avg_Evaluation,
    ROUND(AVG(Satisfaction_Level), 2) AS Avg_Satisfaction,
    COUNT(*) AS Total_Employees
FROM hr_attrition
GROUP BY Employee_Left, Hours_Category
ORDER BY Employee_Left DESC, Hours_Category;
-- Result: High hours leavers rated 0.88 but still left due to burnout

-- ================================================
-- 06. Overworked Employees
-- ================================================

SELECT 
    COUNT(*) AS Overworked_Attrition
FROM hr_attrition
WHERE Average_Monthly_Hours > 250 
AND Number_of_Projects > 5 
AND Employee_Left = 1;