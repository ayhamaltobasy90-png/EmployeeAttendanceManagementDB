USE EmployeeAttendanceManagementDB;

-- 1. Rank employees by salary
SELECT Organization.Employees.EMPLOYEENUMPUER, Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName, 
Payroll.EmployeeSalaries.BasicSalary, DENSE_RANK() OVER (ORDER BY Payroll.EmployeeSalaries.BasicSalary DESC) AS SalaryRank 
FROM Organization.Employees INNER JOIN Payroll.EmployeeSalaries ON Organization.Employees.ID = Payroll.EmployeeSalaries.ID;

-- 2. Rank employees by salary within each department
SELECT Organization.Departments.DepartmentName, Organization.Employees.EMPLOYEENUMPUER, Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName, 
Payroll.EmployeeSalaries.BasicSalary, DENSE_RANK() OVER (PARTITION BY Organization.Employees.DepartmentId ORDER BY Payroll.EmployeeSalaries.BasicSalary DESC) AS DeptSalaryRank 
FROM Organization.Employees INNER JOIN Payroll.EmployeeSalaries ON Organization.Employees.ID = Payroll.EmployeeSalaries.ID 
INNER JOIN Organization.Departments ON Organization.Employees.DepartmentId = Organization.Departments.DepartmentId;

-- 3. Return the highest-paid employee in each department
WITH RankedDepartmentSalariesCTE AS (
SELECT Organization.Departments.DepartmentName, Organization.Employees.EMPLOYEENUMPUER, Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName, 
Payroll.EmployeeSalaries.BasicSalary, ROW_NUMBER() OVER (PARTITION BY Organization.Employees.DepartmentId ORDER BY Payroll.EmployeeSalaries.BasicSalary DESC) AS RowNum 
FROM Organization.Employees INNER JOIN Payroll.EmployeeSalaries ON Organization.Employees.ID = Payroll.EmployeeSalaries.ID 
INNER JOIN Organization.Departments ON Organization.Employees.DepartmentId = Organization.Departments.DepartmentId) 
SELECT RankedDepartmentSalariesCTE.DepartmentName, RankedDepartmentSalariesCTE.EMPLOYEENUMPUER, RankedDepartmentSalariesCTE.EmployeeName, RankedDepartmentSalariesCTE.BasicSalary 
FROM RankedDepartmentSalariesCTE WHERE RankedDepartmentSalariesCTE.RowNum = 1;

-- 4. Return the latest salary row for each employee
WITH LatestSalariesCTE AS (
SELECT Organization.Employees.EMPLOYEENUMPUER, Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName, 
Payroll.EmployeeSalaries.BasicSalary, Payroll.EmployeeSalaries.EffectiveFrom, Payroll.EmployeeSalaries.EffectiveTo, 
ROW_NUMBER() OVER (PARTITION BY Payroll.EmployeeSalaries.ID ORDER BY Payroll.EmployeeSalaries.EffectiveFrom DESC) AS RowNum 
FROM Organization.Employees INNER JOIN Payroll.EmployeeSalaries ON Organization.Employees.ID = Payroll.EmployeeSalaries.ID) 
SELECT LatestSalariesCTE.EMPLOYEENUMPUER, LatestSalariesCTE.EmployeeName, LatestSalariesCTE.BasicSalary, LatestSalariesCTE.EffectiveFrom, LatestSalariesCTE.EffectiveTo 
FROM LatestSalariesCTE WHERE LatestSalariesCTE.RowNum = 1;

-- 5. Compare current salary with previous salary
SELECT Organization.Employees.EMPLOYEENUMPUER, Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName, 
Payroll.EmployeeSalaries.EffectiveFrom, Payroll.EmployeeSalaries.EffectiveTo, Payroll.EmployeeSalaries.BasicSalary AS CurrentSalary, 
ISNULL((SELECT TOP 1 PrevSalary.BasicSalary FROM Payroll.EmployeeSalaries AS PrevSalary WHERE PrevSalary.ID = Payroll.EmployeeSalaries.ID AND PrevSalary.EffectiveFrom < Payroll.EmployeeSalaries.EffectiveFrom ORDER BY PrevSalary.EffectiveFrom DESC), 0) AS PreviousSalary 
FROM Organization.Employees INNER JOIN Payroll.EmployeeSalaries ON Organization.Employees.ID = Payroll.EmployeeSalaries.ID;

-- 6. Calculate salary increase amount
SELECT Organization.Employees.EMPLOYEENUMPUER, Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName, 
Payroll.EmployeeSalaries.EffectiveFrom, Payroll.EmployeeSalaries.EffectiveTo, Payroll.EmployeeSalaries.BasicSalary AS CurrentSalary, 
ISNULL((SELECT TOP 1 PrevSalary.BasicSalary FROM Payroll.EmployeeSalaries AS PrevSalary WHERE PrevSalary.ID = Payroll.EmployeeSalaries.ID AND PrevSalary.EffectiveFrom < Payroll.EmployeeSalaries.EffectiveFrom ORDER BY PrevSalary.EffectiveFrom DESC), Payroll.EmployeeSalaries.BasicSalary) AS PreviousSalary, 
Payroll.EmployeeSalaries.BasicSalary - ISNULL((SELECT TOP 1 PrevSalary.BasicSalary FROM Payroll.EmployeeSalaries AS PrevSalary WHERE PrevSalary.ID = Payroll.EmployeeSalaries.ID AND PrevSalary.EffectiveFrom < Payroll.EmployeeSalaries.EffectiveFrom ORDER BY PrevSalary.EffectiveFrom DESC), Payroll.EmployeeSalaries.BasicSalary) AS SalaryIncreaseAmount 
FROM Organization.Employees INNER JOIN Payroll.EmployeeSalaries ON Organization.Employees.ID = Payroll.EmployeeSalaries.ID;

-- 7. Calculate cumulative payroll totals
SELECT Payroll.MonthlyPayrolls.PayrollYear, Payroll.MonthlyPayrolls.PayrollMonth, Payroll.MonthlyPayrolls.NetSalary, 
(SELECT SUM(P2.NetSalary) FROM Payroll.MonthlyPayrolls AS P2 WHERE P2.PayrollYear < Payroll.MonthlyPayrolls.PayrollYear OR (P2.PayrollYear = Payroll.MonthlyPayrolls.PayrollYear AND P2.PayrollMonth <= Payroll.MonthlyPayrolls.PayrollMonth)) AS CumulativePayrollTotal 
FROM Payroll.MonthlyPayrolls;

-- 8. Calculate running attendance count
SELECT Organization.Employees.EMPLOYEENUMPUER, Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName, 
Attendance.EmployeeAttendances.AttendanceDate, 
(SELECT COUNT(A2.Idd) FROM Attendance.EmployeeAttendances AS A2 WHERE A2.ID = Attendance.EmployeeAttendances.ID AND A2.AttendanceDate <= Attendance.EmployeeAttendances.AttendanceDate) AS RunningAttendanceCount 
FROM Organization.Employees INNER JOIN Attendance.EmployeeAttendances ON Organization.Employees.ID = Attendance.EmployeeAttendances.ID;

-- 9. Divide employees into four salary groups using NTILE
SELECT Organization.Employees.EMPLOYEENUMPUER, Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName, 
Payroll.EmployeeSalaries.BasicSalary, NTILE(4) OVER (ORDER BY Payroll.EmployeeSalaries.BasicSalary DESC) AS SalaryQuartileGroup 
FROM Organization.Employees INNER JOIN Payroll.EmployeeSalaries ON Organization.Employees.ID = Payroll.EmployeeSalaries.ID;

-- 10. Show previous and next attendance date
SELECT Organization.Employees.EMPLOYEENUMPUER, Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName, 
(SELECT TOP 1 A1.AttendanceDate FROM Attendance.EmployeeAttendances AS A1 WHERE A1.ID = Attendance.EmployeeAttendances.ID AND A1.AttendanceDate < Attendance.EmployeeAttendances.AttendanceDate ORDER BY A1.AttendanceDate DESC) AS PreviousAttendanceDate, 
Attendance.EmployeeAttendances.AttendanceDate AS CurrentAttendanceDate, 
(SELECT TOP 1 A2.AttendanceDate FROM Attendance.EmployeeAttendances AS A2 WHERE A2.ID = Attendance.EmployeeAttendances.ID AND A2.AttendanceDate > Attendance.EmployeeAttendances.AttendanceDate ORDER BY A2.AttendanceDate ASC) AS NextAttendanceDate 
FROM Organization.Employees INNER JOIN Attendance.EmployeeAttendances ON Organization.Employees.ID = Attendance.EmployeeAttendances.ID;

-- 11. Display department average beside each employee
SELECT Organization.Departments.DepartmentName, Organization.Employees.EMPLOYEENUMPUER, Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName, 
Payroll.EmployeeSalaries.BasicSalary, AVG(Payroll.EmployeeSalaries.BasicSalary) OVER (PARTITION BY Organization.Employees.DepartmentId) AS DepartmentAverageSalary 
FROM Organization.Employees INNER JOIN Payroll.EmployeeSalaries ON Organization.Employees.ID = Payroll.EmployeeSalaries.ID 
INNER JOIN Organization.Departments ON Organization.Employees.DepartmentId = Organization.Departments.DepartmentId;

-- 12. Calculate each salary as a percentage of department total
SELECT Organization.Departments.DepartmentName, Organization.Employees.EMPLOYEENUMPUER, Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName, 
Payroll.EmployeeSalaries.BasicSalary, SUM(Payroll.EmployeeSalaries.BasicSalary) OVER (PARTITION BY Organization.Employees.DepartmentId) AS TotalDepartmentSalary, 
CAST((Payroll.EmployeeSalaries.BasicSalary * 100.0) / SUM(Payroll.EmployeeSalaries.BasicSalary) OVER (PARTITION BY Organization.Employees.DepartmentId) AS DECIMAL(5,2)) AS SalaryPercentageOfDeptTotal 
FROM Organization.Employees INNER JOIN Payroll.EmployeeSalaries ON Organization.Employees.ID = Payroll.EmployeeSalaries.ID 
INNER JOIN Organization.Departments ON Organization.Employees.DepartmentId = Organization.Departments.DepartmentId;