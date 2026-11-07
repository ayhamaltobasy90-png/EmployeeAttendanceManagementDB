SELECT 
Organization.Employees.EMPLOYEENUMPUER,
Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName,
Payroll.EmployeeSalaries.BasicSalary
FROM Organization.Employees
INNER JOIN Payroll.EmployeeSalaries 
ON Organization.Employees.ID = Payroll.EmployeeSalaries.EmployeeId
WHERE Payroll.EmployeeSalaries.BasicSalary > (
SELECT AVG(Payroll.EmployeeSalaries.BasicSalary)FROM Payroll.EmployeeSalaries
);
--======================================================
SELECT e.EMPLOYEENUMPUER,e.FirstName + N' ' + e.LastName AS EmployeeName,s.BasicSalary
FROM Organization.Employees e
INNER JOIN Payroll.EmployeeSalaries s 
ON e.ID = s.EmployeeId
WHERE s.BasicSalary > (
SELECT AVG(s2.BasicSalary)
FROM Organization.Employees e2
INNER JOIN Payroll.EmployeeSalaries s2 
ON e2.ID = s2.EmployeeId
WHERE e2.DepartmentId = e.DepartmentId
);
--======================================================
select * from Organization.Employees
select * from Organization.Departments
select * from Payroll.MonthlyPayrolls
select * from Payroll.EmployeeSalaries
 select * from LeaveManagement.LeaveTypes
  select * from LeaveManagement.EmployeeLeaveRequests
  select * from Attendance.EmployeeAttendances
  --=======================================================
SELECT 
Organization.Departments.DepartmentId,
Organization.Departments.DepartmentName
FROM Organization.Departments
WHERE Organization.Departments.DepartmentId IN (
SELECT DISTINCT Organization.Employees.DepartmentId
FROM Organization.Employees
INNER JOIN Attendance.EmployeeAttendances ON
Organization.Employees.ID = Attendance.EmployeeAttendances.ID
WHERE Attendance.EmployeeAttendances.LateMinutes > 0
);
--=======================================================
SELECT Organization.Employees.EMPLOYEENUMPUER,Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName
FROM Organization.Employees
WHERE NOT EXISTS (SELECT 1 FROM LeaveManagement.EmployeeLeaveRequests
WHERE LeaveManagement.EmployeeLeaveRequests.EmployeeId = Organization.Employees.ID
);
--===========================================================
WITH DepartmentHierarchyCTE AS (SELECT 
Organization.Departments.DepartmentId,
Organization.Departments.DepartmentName,
Organization.Departments.ParentDepartmentId,1 AS HierarchyLevel,
CAST(Organization.Departments.DepartmentName AS NVARCHAR(MAX)) AS FullPath
FROM Organization.Departments
WHERE Organization.Departments.ParentDepartmentId IS NULL
UNION ALL SELECT ChildDept.DepartmentId,ChildDept.DepartmentName,ChildDept.ParentDepartmentId,
ParentDept.HierarchyLevel + 1 AS HierarchyLevel,
CAST(ParentDept.FullPath + N' -> ' + ChildDept.DepartmentName AS NVARCHAR(MAX)) AS FullPath
FROM Organization.Departments AS ChildDept
INNER JOIN DepartmentHierarchyCTE AS ParentDept 
ON ChildDept.ParentDepartmentId = ParentDept.DepartmentId
)SELECT DepartmentHierarchyCTE.DepartmentId,DepartmentHierarchyCTE.DepartmentName,DepartmentHierarchyCTE.ParentDepartmentId,
  DepartmentHierarchyCTE.HierarchyLevel, DepartmentHierarchyCTE.FullPath
  FROM DepartmentHierarchyCTE
ORDER BY DepartmentHierarchyCTE.HierarchyLevel, DepartmentHierarchyCTE.DepartmentId;
