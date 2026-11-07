USE EmployeeAttendanceManagementDB;
GO
-- -------------------------------------------------------------------------------
-- CATEGORY 1: CLUSTERED INDEXES
-- Note: In SQL Server, defining a PRIMARY KEY automatically creates a Clustered Index 
-- on that column, which physically orders the table data on disk.
-- -------------------------------------------------------------------------------

-- 1.1 Clustered Index on Organization.Employees (Implicitly created via Primary Key 'ID')
-- Why it exists: Primary key identifier for unique employee record access and physical data storage.
-- Benefits: Direct key lookups, join operations with foreign keys across all modules.
-- Column Order: ID (Unique primary key).

-- 1.2 Clustered Index on Attendance.EmployeeAttendances (Implicitly created via Primary Key 'AttendanceId' / 'ID')
-- Why it exists: Primary identifier for attendance records.
-- Benefits: Optimizes range scans and direct record updates for daily attendance logs.


-- -------------------------------------------------------------------------------
-- CATEGORY 2: NONCLUSTERED INDEXES & UNIQUE INDEXES
-- -------------------------------------------------------------------------------

-- 2.1 Unique Nonclustered Index on Employee Number
-- Why it exists: Employee Number must be unique and is frequently used for search/authentication.
-- Benefits: Speeds up lookup queries filtering by EMPLOYEENUMPUER (e.g., SELECT * FROM Employees WHERE EMPLOYEENUMPUER = 1001).
-- Column Order: EMPLOYEENUMPUER (Highest selectivity).
CREATE UNIQUE NONCLUSTERED INDEX IX_Employees_EmployeeNumber
ON Organization.Employees (EMPLOYEENUMPUER);
GO

-- 2.2 Unique Nonclustered Index on National ID
-- Why it exists: National ID is a unique government identifier used for HR verification and lookup.
-- Benefits: Accelerates queries searching for an employee by National ID.
-- Column Order: NationalId.
CREATE UNIQUE NONCLUSTERED INDEX IX_Employees_NationalId
ON Organization.Employees (NationalId);
GO

-- 2.3 Unique Nonclustered Index on Email Address
-- Why it exists: Email is used as login credentials and communication lookup.
-- Benefits: Fast authentication lookups (e.g., SELECT * FROM Employees WHERE EmailAddress = '...').
-- Column Order: EmailAddress.
CREATE UNIQUE NONCLUSTERED INDEX IX_Employees_EmailAddress
ON Organization.Employees (EmailAddress);
GO


-- -------------------------------------------------------------------------------
-- CATEGORY 3: COMPOSITE INDEXES (At least 5 composite indexes)
-- -------------------------------------------------------------------------------

-- 3.1 Composite Index on Employee ID and Attendance Date
-- Why it exists: Attendance records are almost always queried for a specific employee within a date range.
-- Benefits: Eliminates full table scans when fetching employee monthly timesheets or daily records.
-- Column Order: EmployeeId first (higher equality selectivity), followed by AttendanceDate (range scanning).
CREATE NONCLUSTERED INDEX IX_EmployeeAttendances_Employee_Date
ON Attendance.EmployeeAttendances (ID, AttendanceDate);
GO

-- 3.2 Composite Index on Attendance Transaction Date and Time
-- Why it exists: Attendance raw biometric logs are queried by employee and transaction timestamp.
-- Benefits: Speeds up calculation of daily first entry and last exit times for a given employee.
-- Column Order: EmployeeId first, followed by TransactionDateTime.
CREATE NONCLUSTERED INDEX IX_AttendanceTransactions_Employee_DateTime
ON Attendance.AttendanceTransactions (EmployeeId, TransactionDateTime);
GO

-- 3.3 Composite Index on Department ID and Job Title ID
-- Why it exists: HR reporting frequently groups or filters employees by department and job title simultaneously.
-- Benefits: Optimizes organizational chart queries, salary range checks, and department breakdown reports.
-- Column Order: DepartmentId first (fewer distinct departments), then JobTitleId.
CREATE NONCLUSTERED INDEX IX_Employees_Department_JobTitle
ON Organization.Employees (DepartmentId, JobTitleId);
GO

-- 3.4 Composite Index on Leave Request Status and Date Range
-- Why it exists: Leave managers query leave requests by status (e.g., Pending) within specific date windows.
-- Benefits: Speeds up overlap checks and leave calendar generation queries.
-- Column Order: RequestStatus first (equality condition), followed by StartDate and EndDate (range conditions).
CREATE NONCLUSTERED INDEX IX_EmployeeLeaveRequests_Status_Dates
ON LeaveManagement.EmployeeLeaveRequests (RequestStatus, StartDate, EndDate);
GO

-- 3.5 Composite Index on Payroll Year, Month, and Employee ID
-- Why it exists: Payroll processing and payslip generation always query records by year, month, and employee.
-- Benefits: Speeds up monthly salary slip retrieval and payroll audit reports.
-- Column Order: PayrollYear, PayrollMonth (broad hierarchy filtering), then EmployeeId.
CREATE NONCLUSTERED INDEX IX_MonthlyPayrolls_Year_Month_Employee
ON Payroll.MonthlyPayrolls (PayrollYear, PayrollMonth, EmployeeId);
GO

-- 3.6 Composite Index on Audit Table Name and Record ID
-- Why it exists: System administrators search audit logs for actions performed on a specific table and record.
-- Benefits: Optimizes security audit trail queries (e.g., SELECT * FROM AuditLogs WHERE TableName = 'Employees' AND RecordId = 10).
-- Column Order: TableName first, followed by RecordId.
CREATE NONCLUSTERED INDEX IX_AuditLogs_TableName_RecordId
ON Audit.AuditLogs (TableName, RecordId);
GO


-- -------------------------------------------------------------------------------
-- CATEGORY 4: INDEXES USING INCLUDE (At least 2 indexes)
-- -------------------------------------------------------------------------------

-- 4.1 Index on Employee Work Schedules with Included Columns
-- Why it exists: Work schedule lookups filter by EmployeeId and Active status, while needing schedule details.
-- Benefits: Prevents key lookups to the main table when determining an employee's working hours.
-- Column Order: EmployeeId and IsActive in index key; WorkScheduleId, EffectiveFrom, EffectiveTo in INCLUDE.
CREATE NONCLUSTERED INDEX IX_EmployeeWorkSchedules_Employee_Active_Inc
ON Attendance.EmployeeWorkSchedules (EmployeeId, IsActive)
INCLUDE (WorkScheduleId, EffectiveFrom, EffectiveTo);
GO

-- 4.2 Index on Leave Requests with Included Approval Metadata
-- Why it exists: Manager dashboards query leave requests for approval while displaying leave type and reason.
-- Benefits: Avoids table bookmark lookups for manager approval screens.
-- Column Order: ApprovedByEmployeeId and RequestStatus in key; LeaveTypeId, RequestReason, ApprovalDate in INCLUDE.
CREATE NONCLUSTERED INDEX IX_LeaveRequests_ApprovedBy_Inc
ON LeaveManagement.EmployeeLeaveRequests (ApprovedByEmployeeId, RequestStatus)
INCLUDE (LeaveTypeId, RequestReason, ApprovalDate);
GO


-- -------------------------------------------------------------------------------
-- CATEGORY 5: FILTERED INDEXES (At least 2 filtered indexes)
-- -------------------------------------------------------------------------------

-- 5.1 Filtered Index on Active Employees Only
-- Why it exists: The vast majority of daily operational queries (attendance, payroll) target active employees only.
-- Benefits: Reduces index size significantly and speeds up searches on active staff.
-- Column Order: ID, DepartmentId with WHERE IsActive = 1.
CREATE NONCLUSTERED INDEX IX_Employees_ActiveOnly
ON Organization.Employees (ID, DepartmentId)
WHERE IsActive = 1;
GO

-- 5.2 Filtered Index on Pending Leave Requests Only
-- Why it exists: Approvers care primarily about 'Pending' requests waiting for action, which is a small subset.
-- Benefits: Small, fast index dedicated exclusively to pending leave approval queues.
-- Column Order: EMPLOYEEID, LeaveTypeId with WHERE RequestStatus = 'Pending'.
CREATE NONCLUSTERED INDEX IX_EmployeeLeaveRequests_PendingOnly
ON LeaveManagement.EmployeeLeaveRequests (EMPLOYEEID, LeaveTypeId)
WHERE RequestStatus = 'Pending';
GO

-- 5.3 Filtered Index on Current Salary Records Only
-- Why it exists: Payroll queries almost always calculate payroll using current active salary structures.
-- Benefits: Filters out historical salary changes, keeping current salary lookups lightning fast.
-- Column Order: EmployeeId, BasicSalary with WHERE IsCurrent = 1.
CREATE NONCLUSTERED INDEX IX_EmployeeSalaries_CurrentOnly
ON Payroll.EmployeeSalaries (EmployeeId, BasicSalary)
WHERE IsCurrent = 1;
GO


-- -------------------------------------------------------------------------------
-- CATEGORY 6: COVERING INDEX (At least 1 full covering index)
-- -------------------------------------------------------------------------------

-- 6.1 Covering Index for Attendance Summary Reporting
-- Why it exists: Attendance reports retrieve entry/exit times and total worked minutes for employees on specific dates.
-- Benefits: Fully covers attendance summary queries without touching the main clustered index table (Index-Only Scan).
-- Column Order: Key columns (ID, AttendanceDate) + INCLUDE (FirstEntryTime, LastExitTime, TotalWorkedMinutes, AttendanceStatus).
CREATE NONCLUSTERED INDEX IX_EmployeeAttendances_CoveringReport
ON Attendance.EmployeeAttendances (ID, AttendanceDate)
INCL+UDE (FirstEntryTime, LastExitTime, TotalWorkedMinutes, AttendanceStatus);
GO

PRINT N'تم إنشاء ملف الفهارس المتقدمة CreateIndexes.sql بنجاح وتلبية جميع الشروط!';