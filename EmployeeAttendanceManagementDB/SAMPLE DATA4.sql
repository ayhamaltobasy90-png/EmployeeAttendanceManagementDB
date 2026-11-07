USE EmployeeAttendanceManagementDB;
GO
--================================================DONE1
INSERT INTO Organization.Departments (DepartmentCode, DepartmentName, ParentDepartmentId, IsActive)
VALUES (101, N'الإدارة التنفيذية', NULL, 1);

INSERT INTO Organization.Departments (DepartmentCode, DepartmentName, ParentDepartmentId, IsActive)
VALUES 
(102, N'الموارد البشرية', 1, 1),
(103, N'تكنولوجيا المعلومات', 1, 1),
(104, N'المالية والمحاسبة', 1, 1);

INSERT INTO Organization.Departments (DepartmentCode, DepartmentName, ParentDepartmentId, IsActive)
VALUES (105, N'تطوير البرمجيات', 3, 1);
SELECT * FROM Organization.Departments
--=====================================================DONE2
INSERT INTO Organization.JobTitles (id, JobTitleCode, JobTitleName, MinimumSalary, maximumSalary, IsActive)
VALUES 
(1, 1, N'الرئيس التنفيذي', 5000.000, 10000.000, 1),
(2, 2, N'مدير الموارد البشرية', 2000.000, 4000.000, 1),
(3, 3, N'مدير تكنولوجيا المعلومات', 2500.000, 4500.000, 1),
(4, 4, N'المدير المالي', 2500.000, 4500.000, 1),
(5, 5, N'مطور برمجيات أول', 1500.000, 3000.000, 1),
(6, 6, N'مطور برمجيات مبتدئ', 700.000, 1400.000, 1),
(7, 7, N'أخصائي موارد بشرية', 800.000, 1500.000, 1),
(8, 8, N'محاسب', 800.000, 1600.000, 1);
SELECT * FROM Organization.JobTitles
--===================================================================================EMPLOO ERROR3
-- 1. تصفير وإعادة ضبط جدول الموظفين
UPDATE Organization.Departments SET ManagerId = NULL;
DELETE FROM Organization.Employees;
DBCC CHECKIDENT ('Organization.Employees', RESEED, 0);
GO  
INSERT INTO Organization.Employees (EMPLOYEENUMPUER, NationalId, FirstName, MiddleName, LastName, EmailAddress, MobileNumber, BirthDate, HireDate, TerminationDate, Gender, DepartmentId, JobTitleId, ManagerId, EmploymentStatus, BasicSalary, IsActive)
VALUES 
(1001, 'NAT1001', N'أحمد', N'محمود', N'الخالد', 'ahmed.khaled@company.com', '0790000001', '1980-05-15', '2015-01-01', NULL, 'M', 1, 1, NULL, 'Active', 7000.000, 1);
-- 3. إدخال مدراء الإدارات (مديرهم هو أحمد ID = 1)
INSERT INTO Organization.Employees (EMPLOYEENUMPUER, NationalId, FirstName, MiddleName, LastName, EmailAddress, MobileNumber, BirthDate, HireDate, TerminationDate, Gender, DepartmentId, JobTitleId, ManagerId, EmploymentStatus, BasicSalary, IsActive)
VALUES 
(1002, 'NAT1002', N'سارة', N'علي', N'العمر', 'sara.omar@company.com', '0790000002', '1985-08-20', '2016-03-01', NULL, 'F', 2, 2, 1, 'Active', 3000.000, 1),
(1003, 'NAT1003', N'عمر', N'خالد', N'المصري', 'omar.masri@company.com', '0790000003', '1983-11-10', '2016-05-15', NULL, 'M', 3, 3, 1, 'Active', 3500.000, 1),
(1004, 'NAT1004', N'خالد', N'حسن', N'النجار', 'khaled.najjar@company.com', '0790000004', '1982-02-25', '2017-01-10', NULL, 'M', 4, 4, 1, 'Active', 3200.000, 1);
-- 4. إدخال رؤوس الأقسام الفرعية (مديرهم هو عمر ID = 3)
INSERT INTO Organization.Employees (EMPLOYEENUMPUER, NationalId, FirstName, MiddleName, LastName, EmailAddress, MobileNumber, BirthDate, HireDate, TerminationDate, Gender, DepartmentId, JobTitleId, ManagerId, EmploymentStatus, BasicSalary, IsActive)
VALUES 
(1005, 'NAT1005', N'محمد', N'يوسف', N'السيد', 'mohamed.sayed@company.com', '0790000005', '1990-01-01', '2018-02-01', NULL, 'M', 5, 5, 3, 'Active', 2200.000, 1),
(1006, 'NAT1006', N'منى', N'إبراهيم', N'الشهري', 'mona.shehri@company.com', '0790000006', '1992-04-12', '2019-06-01', NULL, 'F', 5, 5, 3, 'Active', 2000.000, 1);
-- 5. إدخال باقي الموظفين (بعد إتاحة كافة أرقام المدراء 1, 2, 3, 4, 5)
INSERT INTO Organization.Employees (EMPLOYEENUMPUER, NationalId, FirstName, MiddleName, LastName, EmailAddress, MobileNumber, BirthDate, HireDate, TerminationDate, Gender, DepartmentId, JobTitleId, ManagerId, EmploymentStatus, BasicSalary, IsActive)
VALUES 
(1007, 'NAT1007', N'علي', N'حسين', N'القحطاني', 'ali.qahtani@company.com', '0790000007', '1995-09-18', '2021-01-15', NULL, 'M', 5, 6, 5, 'Active', 1000.000, 1),
(1008, 'NAT1008', N'رانيا', N'طارق', N'العمري', 'rania.omari@company.com', '0790000008', '1996-12-05', '2021-08-01', NULL, 'F', 5, 6, 5, 'Active', 950.000, 1),
(1009, 'NAT1009', N'حمزة', N'عبدالله', N'العتيبي', 'hamza.otaibi@company.com', '0790000009', '1993-03-30', '2020-03-01', NULL, 'M', 2, 7, 2, 'Active', 1100.000, 1),
(1010, 'NAT1010', N'فاطمة', N'سليمان', N'الزهراني', 'fatima.zahrani@company.com', '0790000010', '1994-07-22', '2020-09-15', NULL, 'F', 4, 8, 4, 'Active', 1200.000, 1),
(1011, 'NAT1011', N'ياسر', N'نواف', N'الحربي', 'yasser.harbi@company.com', '0790000011', '1991-05-10', '2019-01-10', NULL, 'M', 5, 5, 3, 'Active', 2100.000, 1),
(1012, 'NAT1012', N'ريم', N'سعود', N'الدوسري', 'reem.dosari@company.com', '0790000012', '1997-02-14', '2022-02-01', NULL, 'F', 5, 6, 5, 'Active', 900.000, 1),
(1013, 'NAT1013', N'طارق', N'زياد', N'الغامدي', 'tariq.ghamdi@company.com', '0790000013', '1988-10-08', '2017-11-01', NULL, 'M', 4, 8, 4, 'Active', 1300.000, 1),
(1014, 'NAT1014', N'ندى', N'فيصل', N'الاسمري', 'nada.asmari@company.com', '0790000014', '1995-06-25', '2021-04-15', NULL, 'F', 2, 7, 2, 'Active', 1050.000, 1),
(1015, 'NAT1015', N'بدر', N'ماجد', N'الشراري', 'bader.sharari@company.com', '0790000015', '1993-01-19', '2020-05-01', NULL, 'M', 3, 5, 3, 'Active', 2300.000, 1),
(1016, 'NAT1016', N'هالة', N'فهد', N'المطيري', 'hala.mutairi@company.com', '0790000016', '1998-08-30', '2022-06-01', NULL, 'F', 5, 6, 5, 'Active', 850.000, 1),
(1017, 'NAT1017', N'وليد', N'صالح', N'الشامسي', 'waleed.shamsi@company.com', '0790000017', '1989-04-17', '2018-09-01', NULL, 'M', 5, 5, 3, 'Active', 2400.000, 1),
(1018, 'NAT1018', N'عبير', N'ناصر', N'السبيعي', 'abeer.subaie@company.com', '0790000018', '1994-11-11', '2020-10-01', NULL, 'F', 4, 8, 4, 'Active', 1150.000, 1),
(1019, 'NAT1019', N'سامي', N'منصور', N'التميمي', 'sami.tamimi@company.com', '0790000019', '1992-09-09', '2019-04-01', NULL, 'M', 2, 7, 2, 'Active', 1150.000, 1),
(1020, 'NAT1020', N'دلال', N'راشد', N'الخالدي', 'dalal.khaldi@company.com', '0790000020', '1996-03-21', '2021-09-01', NULL, 'F', 5, 6, 5, 'Active', 920.000, 1),
(1021, 'NAT1021', N'فراس', N'وليد', N'القرني', 'firas.qarni@company.com', '0790000021', '1987-12-12', '2017-05-01', '2023-12-31', 'M', 5, 5, 3, 'Terminated', 2000.000, 0),
(1022, 'NAT1022', N'إيمان', N'حاتم', N'المالكي', 'iman.malki@company.com', '0790000022', '1991-07-07', '2019-07-01', '2024-02-28', 'F', 2, 7, 2, 'Terminated', 1000.000, 0),
(1023, 'NAT1023', N'هشام', N'كمال', N'الجهني', 'hesham.juhani@company.com', '0790000023', '1994-05-18', '2020-11-01', NULL, 'M', 5, 6, 5, 'Suspended', 900.000, 1),
(1024, 'NAT1024', N'حسام', N'جمال', N'الراشد', 'hussam.rashid@company.com', '0790000024', '1993-10-10', '2020-01-15', NULL, 'M', 5, 5, 3, 'Active', 1900.000, 1),
(1025, 'NAT1025', N'لينا', N'شريف', N'الزايد', 'lina.zayed@company.com', '0790000025', '1997-12-01', '2022-01-10', NULL, 'F', 5, 6, 5, 'Active', 880.000, 1),
(1026, 'NAT1026', N'زياد', N'أنور', N'الحسن', 'ziad.hassan@company.com', '0790000026', '1990-06-06', '2018-08-01', NULL, 'M', 4, 8, 4, 'Active', 1250.000, 1),
(1027, 'NAT1027', N'مها', N'عادل', N'الشريف', 'maha.shereef@company.com', '0790000027', '1995-02-28', '2021-03-01', NULL, 'F', 2, 7, 2, 'Active', 1100.000, 1),
(1028, 'NAT1028', N'عادل', N'نعيم', N'النجار', 'adel.najjar@company.com', '0790000028', '1992-01-15', '2019-10-01', NULL, 'M', 3, 5, 3, 'Active', 2250.000, 1),
(1029, 'NAT1029', N'نهى', N'سامر', N'البكري', 'noha.bakri@company.com', '0790000029', '1998-04-04', '2022-08-01', NULL, 'F', 5, 6, 5, 'Active', 800.000, 1),
(1030, 'NAT1030', N'ماجد', N'باسم', N'الخطيب', 'majed.khateeb@company.com', '0790000030', '1991-08-19', '2019-05-15', NULL, 'M', 5, 5, 3, 'Active', 2050.000, 1);
-- 6. تحديث مدراء الأقسام الآن بعد التأكد من وجود الموظفين 1, 2, 3, 4, 5
UPDATE Organization.Departments SET ManagerId = 1 WHERE DepartmentId = 1;
UPDATE Organization.Departments SET ManagerId = 2 WHERE DepartmentId = 2;
UPDATE Organization.Departments SET ManagerId = 3 WHERE DepartmentId = 3;
UPDATE Organization.Departments SET ManagerId = 4 WHERE DepartmentId = 4;
UPDATE Organization.Departments SET ManagerId = 5 WHERE DepartmentId = 5;
SELECT * FROM Organization.Employees;
--=====================================================================================DONE4
IF NOT EXISTS (SELECT 1 FROM Attendance.WorkSchedules WHERE WorkScheduleid = 1)
BEGIN
INSERT INTO Attendance.WorkSchedules (WorkScheduleid, ScheduleName, StartTime, EndTime, GracePeriodMinutes, RequiredWorkingMinutes, IsActive)
VALUES 
(1, N'الوردية الصباحية المعتادة', '08:00:00', '16:00:00', 15, 480, 1),
(2, N'الوردية المبكرة', '07:00:00', '15:00:00', 10, 480, 1),
(3, N'الوردية المسائية', '15:00:00', '23:00:00', 15, 480, 1);
END
SELECT * FROM Attendance.WorkSchedules 
--==================================================================================== EMPLOO ERRO5 تم
IF NOT EXISTS (SELECT 1 FROM Attendance.EmployeeWorkSchedules)
BEGIN
INSERT INTO Attendance.EmployeeWorkSchedules (EmployeeId, WorkScheduleId, EffectiveFrom, EffectiveTo, IsActive)
SELECT ID, 1, '2023-01-01', '2029-12-31', 1 FROM Organization.Employees WHERE ID <= 20;
INSERT INTO Attendance.EmployeeWorkSchedules (EmployeeId, WorkScheduleId, EffectiveFrom, EffectiveTo, IsActive)
SELECT ID, 2, '2023-01-01', '2029-12-31', 1 FROM Organization.Employees WHERE ID BETWEEN 21 AND 25;
INSERT INTO Attendance.EmployeeWorkSchedules (EmployeeId, WorkScheduleId, EffectiveFrom, EffectiveTo, IsActive)
SELECT ID, 3, '2023-01-01', '2029-12-31', 1 FROM Organization.Employees WHERE ID BETWEEN 26 AND 30;
END
SELECT * FROM Attendance.EmployeeWorkSchedules 
--================================================================================DONE6
INSERT INTO LeaveManagement.LeaveTypes (LeaveTypeCode, LeaveTypeName, MaximumDaysPerYear, IsPaid, RequiresAttachment, IsActive)
VALUES 
(101, N'إجازة سنوية', 21, 1, 0, 1),
(102, N'إجازة مرضية', 14, 1, 1, 1),
(103, N'إجازة أمومة', 90, 1, 1, 1),
(104, N'إجازة بدون راتب', 30, 0, 0, 1),
(105, N'إجازة طارئة', 5, 1, 0, 1);
SELECT * FROM LeaveManagement.LeaveTypes 
--=============================================================================== DONE7
IF NOT EXISTS (SELECT 1 FROM Attendance.PublicHolidays WHERE HolidayName = N'رأس السنة الميلادية')
BEGIN
INSERT INTO Attendance.PublicHolidays (HolidayName, HolidayDate, IsRecurringYearly, IsActive)
VALUES 
(N'رأس السنة الميلادية', '2024-01-01', 'Yes', 1),
(N'عيد الفطر المبارك 1', '2024-04-10', 'No', 1),
(N'عيد الفطر المبارك 2', '2024-04-11', 'No', 1),
(N'عيد الفطر المبارك 3', '2024-04-12', 'No', 1),
(N'عيد العمال', '2024-05-01', 'Yes', 1),
(N'وقفة عرفة', '2024-06-15', 'No', 1),
(N'عيد الأضحى المبارك 1', '2024-06-16', 'No', 1),
(N'عيد الأضحى المبارك 2', '2024-06-17', 'No', 1),
(N'اليوم الوطني', '2024-09-23', 'Yes', 1),
(N'رأس السنة الهجرية', '2024-07-07', 'No', 1);
END
SELECT * FROM Attendance.PublicHolidays
--=============================================================================EMPLOO ERROR8 تم
IF NOT EXISTS (SELECT 1 FROM Payroll.EmployeeSalaries)
BEGIN
INSERT INTO Payroll.EmployeeSalaries (EmployeeId, BasicSalary, HousingAllowance, TransportationAllowance, OtherAllowance, EffectiveFrom, EffectiveTo, IsCurrent)
SELECT ID, BasicSalary, ROUND(BasicSalary * 0.25, 2),ROUND(BasicSalary * 0.10, 2),100.00,'2023-01-01', '2029-12-31', 1
FROM Organization.Employees;
END
SELECT * FROM Payroll.EmployeeSalaries
--==============================================================================ERROR9
IF NOT EXISTS (SELECT 1 FROM Security.Users WHERE Username = 'sysadmin')
BEGIN
INSERT INTO Security.Users (Username, PasswordHash, EmailAddress, EmployeeId, IsActive)
VALUES 
('sysadmin', 'HASHED_PWD_ADMIN_123', 'admin@company.com', NULL, 1),
('ahmed.khaled', 'HASHED_PWD_EMP001', 'ahmed.khaled@company.com', 1, 1),
('sara.omar', 'HASHED_PWD_EMP002', 'sara.omar@company.com', 2, 1),
('omar.masri', 'HASHED_PWD_EMP003', 'omar.masri@company.com', 3, 1),
('khaled.najjar', 'HASHED_PWD_EMP004', 'khaled.najjar@company.com', 4, 1);
END
SELECT * FROM Security.Users
--=============================================================================== ERROR10
IF NOT EXISTS (SELECT 1 FROM LeaveManagement.EmployeeLeaveRequests)
BEGIN
INSERT INTO LeaveManagement.EmployeeLeaveRequests
(EMPLOYEEID, LeaveTypeId, StartDate, EndDate, NumberOfDays, RequestStatus, RequestReason, RejectionReason, ApprovedByEmployeeId, ApprovalDate, AttachmentPath)
VALUES 
(5, (SELECT ID FROM LeaveManagement.LeaveTypes WHERE LeaveTypeCode = 101), '2024-01-10', '2024-01-12', 2, 'Approved', N'إجازة سنوية للاستجمام', N'لا يوجد', 3, '2024-01-08', N'N/A'),
(6, (SELECT ID FROM LeaveManagement.LeaveTypes WHERE LeaveTypeCode = 102), '2024-02-01', '2024-02-03', 2, 'Approved', N'وعكة صحية طارئة', N'لا يوجد', 3, '2024-02-01', N'/uploads/sick_001.pdf'),
(8, (SELECT ID FROM LeaveManagement.LeaveTypes WHERE LeaveTypeCode = 104), '2024-03-10', '2024-03-12', 2, 'Rejected', N'سفر خاص', N'عدم توفر بديل في القسم حالياً', 5, '2024-03-08', N'N/A'),
(9, (SELECT ID FROM LeaveManagement.LeaveTypes WHERE LeaveTypeCode = 101), '2024-01-15', '2024-01-18', 3, 'Approved', N'إجازة عائلية', N'لا يوجد', 2, '2024-01-12', N'/uploads/sick_021.pdf');
END
GO
SELECT * FROM LeaveManagement.EmployeeLeaveRequests
--================================================================================ERROR11
IF NOT EXISTS (SELECT 1 FROM Attendance.EmployeeAttendances)
BEGIN
DECLARE @EmpLoop INT = 1;
DECLARE @CurrentDate DATE = '2024-01-01';
DECLARE @EntryTime DATETIME2;
DECLARE @ExitTime DATETIME2;
WHILE @CurrentDate <= '2024-01-05'
BEGIN
IF DATEPART(WEEKDAY, @CurrentDate) NOT IN (6, 7)
BEGIN
SET @EmpLoop = 1;
WHILE @EmpLoop <= 30

BEGIN
SET @EntryTime = CAST(@CurrentDate AS DATETIME2);
INSERT INTO Attendance.EmployeeAttendances
(ID, AttendanceDate, FirstEntryTime, LastExitTime, TotalWorkedMinutes, LateMinutes, EarlyLeaveMinutes, OvertimeMinutes, AttendanceStatus)
VALUES
(@EmpLoop, @CurrentDate, '08:00:00', '16:00:00', 480, 0, 0, 0, 'Present');
INSERT INTO Attendance.AttendanceTransactions (EmployeeId, TransactionDateTime, TransactionType, DeviceCode, LocationName, SourceType, CreatedByUserId)
VALUES 
(@EmpLoop, DATEADD(HOUR, 8, @EntryTime), 'Entry', 'DEV-MAIN-01', N'البوابة الرئيسية', 'Device', 1),
(@EmpLoop, DATEADD(HOUR, 16, @EntryTime), 'Exit', 'DEV-MAIN-01', N'البوابة الرئيسية', 'Device', 1);
SET @EmpLoop = @EmpLoop + 1;
END
END
SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
END
END
SELECT * FROM Attendance.EmployeeAttendances
--============================================================== ERROR MAYPE12
IF NOT EXISTS (SELECT 1 FROM Payroll.MonthlyPayrolls)
BEGIN
    DECLARE @MonthLoop INT = 1;

    WHILE @MonthLoop <= 3
    BEGIN
        INSERT INTO Payroll.MonthlyPayrolls 
        (EmployeeId, PayrollYear, PayrollMonth, BasicSalary, TotalAllowances, OvertimeAmount, DeductionAmount, PayrollStatus, ProcessedDate)
        SELECT 
            E.ID, 
            2024, 
            @MonthLoop, 
            S.BasicSalary, 
            (S.HousingAllowance + S.TransportationAllowance + S.OtherAllowance), 
            0.00, 
            0.00, 
            'Paid', 
            GETDATE()
        FROM Payroll.EmployeeSalaries S
        INNER JOIN Organization.Employees E ON S.EmployeeId = E.ID
        WHERE S.IsCurrent = 1;

        SET @MonthLoop = @MonthLoop + 1;
    END
END
GO

SELECT * FROM Payroll.MonthlyPayrolls;
SELECT * FROM Payroll.MonthlyPayrolls
--================================DONE13
IF NOT EXISTS (SELECT 1 FROM Audit.AuditLogs)
BEGIN
INSERT INTO Audit.AuditLogs (TableName, RecordId, ActionType, OldValues, NewValues, ModifiedByUserId)
VALUES 
('Organization.Employees', 101, 'INSERT', NULL, N'{"EMPLOYEENUMPUER":1001,"Status":"Active"}', 101),
('Organization.Employees', 102, 'UPDATE', N'{"EmploymentStatus":"Active"}', N'{"EmploymentStatus":"Terminated"}', 102);
END

SELECT * FROM Audit.AuditLogs
--================================================================DONE14
INSERT INTO Attendance.AttendanceTransactions (EmployeeId, TransactionDateTime, TransactionType, DeviceCode, LocationName, SourceType, CreatedByUserId)
VALUES 
(1, '2024-01-01 07:55:00', 'Entry', 'DEV-MAIN-01', N'البوابة الرئيسية', 'Device', 1),
(1, '2024-01-01 16:05:00', 'Exit', 'DEV-MAIN-01', N'البوابة الرئيسية', 'Device', 1),
(2, '2024-01-01 08:02:00', 'Entry', 'DEV-MAIN-01', N'البوابة الرئيسية', 'Device', 1),
(2, '2024-01-01 16:00:00', 'Exit', 'DEV-MAIN-01', N'البوابة الرئيسية', 'Device', 1),
(3, '2024-01-01 07:50:00', 'Entry', 'DEV-MAIN-01', N'البوابة الرئيسية', 'Device', 1),
(3, '2024-01-01 16:10:00', 'Exit', 'DEV-MAIN-01', N'البوابة الرئيسية', 'Device', 1);
SELECT * FROM Attendance.AttendanceTransactions;
--================================================
