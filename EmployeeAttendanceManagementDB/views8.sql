USE EmployeeAttendanceManagementDB;
GO

-- 1. View: Organization.vw_ActiveEmployees
USE EmployeeAttendanceManagementDB;
GO
GO

CREATE VIEW Organization.vw_ActiveEmployees
WITH SCHEMABINDING
AS
SELECT 
    Organization.Employees.EMPLOYEENUMPUER, 
    Organization.Employees.FirstName + N' ' + ISNULL(Organization.Employees.MiddleName + N' ', N'') + Organization.Employees.LastName AS EmployeeName, 
    Organization.Employees.HireDate, 
    Organization.Departments.DepartmentName 
FROM Organization.Employees 
INNER JOIN Organization.Departments 
    ON Organization.Employees.DepartmentId = Organization.Departments.DepartmentId
WHERE Organization.Employees.IsActive = 1 AND Organization.Employees.IsDeleted = 0;
GO
-- 2. View: Attendance.vw_DailyAttendanceDetails
CREATE VIEW Attendance.vw_DailyAttendanceDetails AS
SELECT Organization.Employees.EMPLOYEENUMPUER, 
       Organization.Employees.FirstName + N' ' + ISNULL(Organization.Employees.MiddleName + N' ', N'') + Organization.Employees.LastName AS EmployeeName, 
       Organization.Departments.DepartmentName, 
       Attendance.EmployeeAttendances.AttendanceDate, 
       Attendance.EmployeeAttendances.FirstEntryTime, 
       Attendance.EmployeeAttendances.LastExitTime, 
       Attendance.EmployeeAttendances.LateMinutes, 
       Attendance.EmployeeAttendances.EarlyLeaveMinutes, 
       Attendance.EmployeeAttendances.OvertimeMinutes, 
       Attendance.EmployeeAttendances.AttendanceStatus 
FROM Attendance.EmployeeAttendances 
INNER JOIN Organization.Employees ON Attendance.EmployeeAttendances.Id = Organization.Employees.Id 
INNER JOIN Organization.Departments ON Organization.Employees.DepartmentId = Organization.Departments.DepartmentId;
GO

-- 3. View: LeaveManagement.vw_EmployeeLeaveBalances
CREATE VIEW LeaveManagement.vw_EmployeeLeaveBalances AS
SELECT Organization.Employees.EMPLOYEENUMPUER, 
       Organization.Employees.FirstName + N' ' + ISNULL(Organization.Employees.MiddleName + N' ', N'') + Organization.Employees.LastName AS EmployeeName, 
       LeaveManagement.LeaveTypes.LeaveTypeName, 
       ISNULL(SUM(LeaveManagement.EmployeeLeaveRequests.NumberOfDays), 0) AS TotalApprovedLeaveDays 
FROM LeaveManagement.EmployeeLeaveRequests 
INNER JOIN Organization.Employees ON LeaveManagement.EmployeeLeaveRequests.EmployeeId = Organization.Employees.Id 
INNER JOIN LeaveManagement.LeaveTypes ON LeaveManagement.EmployeeLeaveRequests.LeaveTypeId = LeaveManagement.LeaveTypes.Id 
WHERE LeaveManagement.EmployeeLeaveRequests.RequestStatus = 'Approved'
GROUP BY Organization.Employees.EMPLOYEENUMPUER, Organization.Employees.FirstName, Organization.Employees.MiddleName, Organization.Employees.LastName, LeaveManagement.LeaveTypes.LeaveTypeName;
GO

-- 4. View: Payroll.vw_MonthlyPayrollSummary
CREATE VIEW Payroll.vw_MonthlyPayrollSummary AS
SELECT Organization.Employees.EMPLOYEENUMPUER, 
       Organization.Employees.FirstName + N' ' + ISNULL(Organization.Employees.MiddleName + N' ', N'') + Organization.Employees.LastName AS EmployeeName, 
       Organization.Departments.DepartmentName, 
       Payroll.MonthlyPayrolls.PayrollYear, 
       Payroll.MonthlyPayrolls.PayrollMonth, 
       Payroll.MonthlyPayrolls.BasicSalary, 
       Payroll.MonthlyPayrolls.TotalAllowances, 
       Payroll.MonthlyPayrolls.DeductionAmount, 
       Payroll.MonthlyPayrolls.NetSalary 
FROM Payroll.MonthlyPayrolls 
INNER JOIN Organization.Employees ON Payroll.MonthlyPayrolls.EmployeeId = Organization.Employees.Id 
INNER JOIN Organization.Departments ON Organization.Employees.DepartmentId = Organization.Departments.DepartmentId;
GO

-- 5. View: Organization.vw_DepartmentStatistics
CREATE VIEW Organization.vw_DepartmentStatistics AS
SELECT Organization.Departments.DepartmentId AS DepartmentId, 
       Organization.Departments.DepartmentName, 
       COUNT(Organization.Employees.Id) AS TotalEmployees, 
       ISNULL(AVG(Payroll.EmployeeSalaries.BasicSalary), 0) AS AverageSalary, 
       ISNULL(SUM(Payroll.EmployeeSalaries.BasicSalary), 0) AS TotalSalaryBudget 
FROM Organization.Departments 
LEFT JOIN Organization.Employees ON Organization.Departments.DepartmentId = Organization.Employees.DepartmentId AND Organization.Employees.IsDeleted = 0
LEFT JOIN Payroll.EmployeeSalaries ON Organization.Employees.Id = Payroll.EmployeeSalaries.EmployeeId 
GROUP BY Organization.Departments.DepartmentId, Organization.Departments.DepartmentName;
GO

GO
SELECT * FROM Organization.vw_ActiveEmployees;
GO

SELECT * FROM Attendance.vw_DailyAttendanceDetails;
GO

SELECT * FROM LeaveManagement.vw_EmployeeLeaveBalances;
GO

SELECT * FROM Payroll.vw_MonthlyPayrollSummary;
GO

SELECT * FROM Organization.vw_DepartmentStatistics ;
GO