select * from Organization.Employees
select * from Organization.Departments
select * from Payroll.MonthlyPayrolls
select * from Payroll.EmployeeSalaries
 select * from LeaveManagement.LeaveTypes
  select * from LeaveManagement.EmployeeLeaveRequests
  select * from Attendance.EmployeeAttendances
SELECT Organization.Departments.DepartmentName ,
COUNT(Organization.Employees.ID)AS  CULOMNCOUNT
FROM Organization.Departments
INNER JOIN Organization.Employees ON Organization.Employees.DepartmentId=Organization.Departments.DepartmentId
GROUP BY (Organization.Departments.DepartmentName);
--========================================================2
SELECT
COUNT(Organization.Employees.ID)AS  CULOMNCOUNT
FROM  Organization.Employees
where IsActive=1
--========================================================3
SELECT 
    Organization.Departments.DepartmentName,
    avg(Organization.Employees.BasicSalary) AS TotalavgBasicSalaryBudget
FROM Organization.Departments
INNER JOIN Organization.Employees 
    ON Organization.Departments.DepartmentId = Organization.Employees.DepartmentId
GROUP BY  Organization.Departments.DepartmentName;
--============================================================4
SELECT 
    Organization.Departments.DepartmentName,
    AVG(Organization.Employees.BasicSalary) AS AverageSalary,
    MIN(Organization.Employees.BasicSalary) AS MinimumSalary,
    MAX(Organization.Employees.BasicSalary) AS MaximumSalary
FROM Organization.Departments
INNER JOIN Organization.Employees 
    ON Organization.Departments.DepartmentId = Organization.Employees.DepartmentId
GROUP BY  Organization.Departments.DepartmentName;
--==============================================================5
SELECT 
    Organization.Departments.DepartmentName,
    AVG(Organization.Employees.BasicSalary) AS AverageSalary
FROM Organization.Departments
INNER JOIN Organization.Employees 
    ON Organization.Departments.DepartmentId = Organization.Employees.DepartmentId
GROUP BY Organization.Departments.DepartmentId, Organization.Departments.DepartmentName
HAVING AVG(Organization.Employees.BasicSalary) > 3000.00;
GO
--=================================================================6
SELECT 
    Organization.Employees.EMPLOYEENUMPUER,
    Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName,
    SUM(Attendance.EmployeeAttendances.LateMinutes) AS TotalLateMinutes
FROM Organization.Employees
INNER JOIN Attendance.EmployeeAttendances 
    ON Organization.Employees.ID = Attendance.EmployeeAttendances.ID

GROUP BY 
    Organization.Employees.EMPLOYEENUMPUER, 
    Organization.Employees.FirstName, 
    Organization.Employees.LastName;
GO
--======================================================================7
SELECT 
    LeaveManagement.LeaveTypes.LeaveTypeName,
    COUNT(LeaveManagement.EmployeeLeaveRequests.IDDD) AS TotalApprovedRequests
FROM LeaveManagement.LeaveTypes
INNER JOIN LeaveManagement.EmployeeLeaveRequests 
    ON LeaveManagement.LeaveTypes.Id = LeaveManagement.EmployeeLeaveRequests.LeaveTypeId
WHERE LeaveManagement.EmployeeLeaveRequests.RequestStatus = 'Approved'
GROUP BY LeaveManagement.LeaveTypes.Id, LeaveManagement.LeaveTypes.LeaveTypeName;
GO

select * from LeaveManagement.LeaveTypes
  select * from LeaveManagement.EmployeeLeaveRequests
  --================================================================================8
  SELECT 
    LeaveManagement.EmployeeLeaveRequests.RequestStatus,
    COUNT(LeaveManagement.EmployeeLeaveRequests.LeaveTypeId) AS TotalRequestsCount
FROM LeaveManagement.EmployeeLeaveRequests
GROUP BY LeaveManagement.EmployeeLeaveRequests.RequestStatus
HAVING COUNT(LeaveManagement.EmployeeLeaveRequests.LeaveTypeId) > 0;
GO
-----------------------------------------------------------------------------------9
SELECT 
    Organization.Employees.EMPLOYEENUMPUER,
    Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName,
    SUM(DATEDIFF(DAY, LeaveManagement.EmployeeLeaveRequests.StartDate, LeaveManagement.EmployeeLeaveRequests.EndDate) + 1) AS TotalApprovedLeaveDays
FROM LeaveManagement.EmployeeLeaveRequests
INNER JOIN Organization.Employees 
    ON LeaveManagement.EmployeeLeaveRequests.EmployeeId = Organization.Employees.ID
WHERE LeaveManagement.EmployeeLeaveRequests.RequestStatus = 'Approved'
GROUP BY 
    Organization.Employees.ID, 
    Organization.Employees.EMPLOYEENUMPUER, 
    Organization.Employees.FirstName, 
    Organization.Employees.LastName
HAVING SUM(DATEDIFF(DAY, LeaveManagement.EmployeeLeaveRequests.StartDate, LeaveManagement.EmployeeLeaveRequests.EndDate) + 1) >= 1;
GO
--=========================================================================================10
SELECT 
    Payroll.MonthlyPayrolls.PayrollYear,
    Payroll.MonthlyPayrolls.PayrollMonth,
    SUM(Payroll.MonthlyPayrolls.BasicSalary) AS TotalBasicSalary,
    SUM(Payroll.MonthlyPayrolls.TotalAllowances) AS TotalAllowances,
    SUM(Payroll.MonthlyPayrolls.DeductionAmount) AS TotalDeductions,
    SUM(Payroll.MonthlyPayrolls.NetSalary) AS TotalMonthlyPayroll
FROM Payroll.MonthlyPayrolls
WHERE Payroll.MonthlyPayrolls.PayrollStatus = 'Paid'
GROUP BY 
    Payroll.MonthlyPayrolls.PayrollYear, 
    Payroll.MonthlyPayrolls.PayrollMonth
ORDER BY 
    Payroll.MonthlyPayrolls.PayrollYear DESC, 
    Payroll.MonthlyPayrolls.PayrollMonth DESC;
GO
select  max(Payroll.MonthlyPayrolls.BasicSalary )from Payroll.MonthlyPayrolls
select  Payroll.MonthlyPayrolls.BasicSalary from Payroll.MonthlyPayrolls
--==================================================================================11
SELECT TOP 1
 Organization.Departments.DepartmentName,
 COUNT(Organization.Employees.ID) AS TotalEmployeesCount
FROM Organization.Departments
INNER JOIN Organization.Employees ON Organization.Departments.DepartmentId = Organization.Employees.DepartmentId
GROUP BY Organization.Departments.DepartmentName
HAVING COUNT(Organization.Employees.ID) >= ALL (SELECT COUNT(Organization.Employees.ID) FROM Organization.Employees
 GROUP BY Organization.Employees.DepartmentId)
ORDER BY TotalEmployeesCount DESC;
GO
--===================================================================================12
SELECT TOP 1
    Organization.Employees.EMPLOYEENUMPUER,
    Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName,
    SUM(Attendance.EmployeeAttendances.OvertimeMinutes) AS TotalOvertimeHours
FROM Attendance.EmployeeAttendances
INNER JOIN Organization.Employees 
    ON Attendance.EmployeeAttendances.ID = Organization.Employees.ID
GROUP BY 
    Organization.Employees.ID, 
    Organization.Employees.EMPLOYEENUMPUER, 
    Organization.Employees.FirstName, 
    Organization.Employees.LastName
ORDER BY TotalOvertimeHours DESC;
GO
  select * from Attendance.EmployeeAttendances