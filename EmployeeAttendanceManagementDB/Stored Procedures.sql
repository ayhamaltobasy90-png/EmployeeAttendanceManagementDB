USE EmployeeAttendanceManagementDB;
GO
select * from Organization.Employees
select * from Organization.Departments
select * from Payroll.MonthlyPayrolls
select * from Payroll.EmployeeSalaries
 select * from LeaveManagement.LeaveTypes
  select * from LeaveManagement.EmployeeLeaveRequests
  select * from Attendance.EmployeeAttendances;
GO
-- 1. Procedure: Organization.CreateEmployee
CREATE PROCEDURE Organization.CreateEmployee
    @EmployeeNumber NVARCHAR(50),
    @NationalId NVARCHAR(50),
    @FirstName NVARCHAR(50),
    @MiddleName NVARCHAR(50) = NULL,
    @LastName NVARCHAR(50),
    @EmailAddress NVARCHAR(100),
    @MobileNumber NVARCHAR(20) = NULL,
    @BirthDate DATE,
    @HireDate DATE,
    @Gender CHAR(1),
    @DepartmentId INT,
    @JobTitleId INT,
    @ManagerId INT = NULL,
    @BasicSalary DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;

    IF (SELECT COUNT(1) FROM Organization.Departments WHERE Organization.Departments.DepartmentId = @DepartmentId AND Organization.Departments.IsDeleted = 0) = 0
    BEGIN
        RAISERROR(N'القسم غير موجود أو محذوف.', 16, 1);
        RETURN;
    END

    DECLARE @MinSalary DECIMAL(18,2), @MaxSalary DECIMAL(18,2);
    SELECT @MinSalary = Organization.JobTitles.MinimumSalary, @MaxSalary = Organization.JobTitles.MaximumSalary 
    FROM Organization.JobTitles WHERE Organization.JobTitles.Id = @JobTitleId AND Organization.JobTitles.IsActive = 1;

    IF @MinSalary IS NULL
    BEGIN
        RAISERROR(N'المسمى الوظيفي غير موجود أو غير نشط.', 16, 1);
        RETURN;
    END

    IF @BasicSalary < @MinSalary OR @BasicSalary > @MaxSalary
    BEGIN
        RAISERROR(N'الراتب الأساسي خارج النطاق المسموح به للمسمى الوظيفي.', 16, 1);
        RETURN;
    END

    IF @ManagerId IS NOT NULL AND (SELECT COUNT(1) FROM Organization.Employees WHERE Organization.Employees.Id = @ManagerId AND Organization.Employees.IsDeleted = 0) = 0
    BEGIN
        RAISERROR(N'المدير المباشر غير موجود.', 16, 1);
        RETURN;
    END

    IF (SELECT COUNT(1) FROM Organization.Employees WHERE Organization.Employees.EMPLOYEENUMPUER = @EmployeeNumber OR Organization.Employees.NationalId = @NationalId OR Organization.Employees.EmailAddress = @EmailAddress) > 0
    BEGIN
        RAISERROR(N'الرقم الوظيفي أو الرقم الوطني أو البريد الإلكتروني مكرر.', 16, 1);
        RETURN;
    END

    INSERT INTO Organization.Employees (
       EMPLOYEENUMPUER, NationalId, FirstName, MiddleName, LastName, EmailAddress, MobileNumber,
        BirthDate, HireDate, Gender, DepartmentId, JobTitleId, ManagerId, EmploymentStatus,
        BasicSalary, IsActive, CreationTime, IsDeleted
    )
    VALUES (
        @EmployeeNumber, @NationalId, @FirstName, @MiddleName, @LastName, @EmailAddress, @MobileNumber,
        @BirthDate, @HireDate, @Gender, @DepartmentId, @JobTitleId, @ManagerId, 'Active',
        @BasicSalary, 1, SYSDATETIME(), 0
    );

    SELECT SCOPE_IDENTITY() AS NewEmployeeId;
END;
GO

-- 2. Procedure: Organization.UpdateEmployee
CREATE PROCEDURE Organization.UpdateEmployee
    @Id INT,
    @FirstName NVARCHAR(50),
    @MiddleName NVARCHAR(50) = NULL,
    @LastName NVARCHAR(50),
    @EmailAddress NVARCHAR(100),
    @MobileNumber NVARCHAR(20) = NULL,
    @DepartmentId INT,
    @JobTitleId INT,
    @BasicSalary DECIMAL(18,2)
AS
BEGIN
    SET NOCOUNT ON;

    IF (SELECT COUNT(1) FROM Organization.Employees WHERE Organization.Employees.Id = @Id AND Organization.Employees.IsDeleted = 0) = 0
    BEGIN
        RAISERROR(N'الموظف غير موجود.', 16, 1);
        RETURN;
    END

    IF (SELECT COUNT(1) FROM Organization.Employees WHERE Organization.Employees.EmailAddress = @EmailAddress AND Organization.Employees.Id <> @Id) > 0
    BEGIN
        RAISERROR(N'البريد الإلكتروني مستخدم من قبل موظف آخر.', 16, 1);
        RETURN;
    END

    UPDATE Organization.Employees
    SET FirstName = @FirstName,
        MiddleName = @MiddleName,
        LastName = @LastName,
        EmailAddress = @EmailAddress,
        MobileNumber = @MobileNumber,
        DepartmentId = @DepartmentId,
        JobTitleId = @JobTitleId,
        BasicSalary = @BasicSalary,
        LastModificationTime = SYSDATETIME()
    WHERE Organization.Employees.Id = @Id;

    SELECT * FROM Organization.Employees WHERE Organization.Employees.Id = @Id;
END;
GO

-- 3. Procedure: Organization.DeleteEmployee
CREATE PROCEDURE Organization.DeleteEmployee
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    IF (SELECT COUNT(1) FROM LeaveManagement.EmployeeLeaveRequests WHERE LeaveManagement.EmployeeLeaveRequests.EmployeeId = @Id AND LeaveManagement.EmployeeLeaveRequests.RequestStatus = 'Pending') > 0
    BEGIN
        RAISERROR(N'لا يمكن حذف الموظف لوجود طلبات إجازة معلقة.', 16, 1);
        RETURN;
    END

    IF (SELECT COUNT(1) FROM Organization.Employees WHERE Organization.Employees.ManagerId = @Id AND Organization.Employees.IsDeleted = 0 AND Organization.Employees.IsActive = 1) > 0
    BEGIN
        RAISERROR(N'لا يمكن حذف الموظف لأنه يدير موظفين نشطين حالياً.', 16, 1);
        RETURN;
    END

    UPDATE Organization.Employees
    SET IsDeleted = 1,
        IsActive = 0,
        EmploymentStatus = 'Terminated',
        TerminationDate = CAST(GETDATE() AS DATE),
        LastModificationTime = SYSDATETIME()
    WHERE Organization.Employees.Id = @Id;
END;
GO

-- 4. Procedure: Attendance.AddAttendanceTransaction
CREATE PROCEDURE Attendance.AddAttendanceTransaction
    @EmployeeId INT,
    @TransactionDateTime DATETIME2,
    @TransactionType NVARCHAR(10),
    @DeviceCode NVARCHAR(50) = NULL,
    @LocationName NVARCHAR(100) = NULL,
    @SourceType NVARCHAR(20) = 'Device',
    @CreatedByUserId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF (SELECT COUNT(1) FROM Organization.Employees WHERE Organization.Employees.Id = @EmployeeId AND Organization.Employees.IsDeleted = 0) = 0
    BEGIN
        RAISERROR(N'الموظف غير موجود.', 16, 1);
        RETURN;
    END

    IF @TransactionType NOT IN ('Entry', 'Exit')
    BEGIN
        RAISERROR(N'نوع الحركة يجب أن يكون Entry أو Exit.', 16, 1);
        RETURN;
    END

    IF (SELECT COUNT(1) FROM Attendance.AttendanceTransactions WHERE Attendance.AttendanceTransactions.EmployeeId = @EmployeeId AND Attendance.AttendanceTransactions.TransactionDateTime = @TransactionDateTime) > 0
    BEGIN
        RAISERROR(N'الحركة مكررة لنفس الموظف والتاريخ والوقت.', 16, 1);
        RETURN;
    END

    INSERT INTO Attendance.AttendanceTransactions (
        EmployeeId, TransactionDateTime, TransactionType, DeviceCode, LocationName, SourceType, CreatedByUserId, CreationTime
    )
    VALUES (
        @EmployeeId, @TransactionDateTime, @TransactionType, @DeviceCode, @LocationName, @SourceType, @CreatedByUserId, SYSDATETIME()
    );

    DECLARE @AttendanceDate DATE = CAST(@TransactionDateTime AS DATE);
    EXEC Attendance.CalculateDailyAttendance @EmployeeId = @EmployeeId, @AttendanceDate = @AttendanceDate;
END;
GO

-- 5. Procedure: Attendance.CalculateDailyAttendance
CREATE PROCEDURE Attendance.CalculateDailyAttendance
    @EmployeeId INT,
    @AttendanceDate DATE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @FirstEntry DATETIME2, @LastExit DATETIME2, @TotalWorked INT = 0, @Late INT = 0, @EarlyLeave INT = 0, @Overtime INT = 0;
    DECLARE @Status NVARCHAR(20) = 'Absent';

    SELECT @FirstEntry = MIN(CASE WHEN Attendance.AttendanceTransactions.TransactionType = 'Entry' THEN Attendance.AttendanceTransactions.TransactionDateTime END),
           @LastExit = MAX(CASE WHEN Attendance.AttendanceTransactions.TransactionType = 'Exit' THEN Attendance.AttendanceTransactions.TransactionDateTime END)
    FROM Attendance.AttendanceTransactions
    WHERE Attendance.AttendanceTransactions.EmployeeId = @EmployeeId AND CAST(Attendance.AttendanceTransactions.TransactionDateTime AS DATE) = @AttendanceDate;

    IF @FirstEntry IS NOT NULL OR @LastExit IS NOT NULL
    BEGIN
        SET @Status = 'Present';
        IF @FirstEntry IS NOT NULL AND @LastExit IS NOT NULL
        BEGIN
            SET @TotalWorked = DATEDIFF(MINUTE, @FirstEntry, @LastExit);
            IF @TotalWorked > 480 
                SET @Overtime = @TotalWorked - 480;
        END
        ELSE
        BEGIN
            SET @Status = 'Incomplete';
        END
    END

    IF (SELECT COUNT(1) FROM Attendance.EmployeeAttendances WHERE Attendance.EmployeeAttendances.ID = @EmployeeId AND Attendance.EmployeeAttendances.AttendanceDate = @AttendanceDate) > 0
    BEGIN
        UPDATE Attendance.EmployeeAttendances
        SET FirstEntryTime = @FirstEntry,
            LastExitTime = @LastExit,
            TotalWorkedMinutes = @TotalWorked,
            LateMinutes = @Late,
            EarlyLeaveMinutes = @EarlyLeave,
            OvertimeMinutes = @Overtime,
            AttendanceStatus = @Status,
            LastModificationTime = SYSDATETIME()
        WHERE Attendance.EmployeeAttendances.ID = @EmployeeId AND Attendance.EmployeeAttendances.AttendanceDate = @AttendanceDate;
    END
    ELSE
    BEGIN
        INSERT INTO Attendance.EmployeeAttendances (
           ID, AttendanceDate, FirstEntryTime, LastExitTime, TotalWorkedMinutes,
            LateMinutes, EarlyLeaveMinutes, OvertimeMinutes, AttendanceStatus, IsManualUpdate, CreationTime
        )
        VALUES (
            @EmployeeId, @AttendanceDate, @FirstEntry, @LastExit, @TotalWorked,
            @Late, @EarlyLeave, @Overtime, @Status, 0, SYSDATETIME()
        );
    END
END;
GO
USE EmployeeAttendanceManagementDB;
GO

-- 6. Procedure: LeaveManagement.SubmitLeaveRequest
CREATE PROCEDURE LeaveManagement.SubmitLeaveRequest
    @EmployeeId INT,
    @LeaveTypeId INT,
    @StartDate DATE,
    @EndDate DATE,
    @RequestReason NVARCHAR(500) = NULL,
    @AttachmentPath NVARCHAR(255) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @EndDate < @StartDate
    BEGIN
        RAISERROR(N'تاريخ النهاية لا يمكن أن يكون قبل تاريخ البداية.', 16, 1);
        RETURN;
    END

    DECLARE @RequiresAttachment BIT, @MaxDays INT;
    SELECT @RequiresAttachment = LeaveManagement.LeaveTypes.RequiresAttachment, @MaxDays = LeaveManagement.LeaveTypes.MaximumDaysPerYear 
    FROM LeaveManagement.LeaveTypes WHERE LeaveManagement.LeaveTypes.Id = @LeaveTypeId;

    IF @RequiresAttachment = 1 AND (@AttachmentPath IS NULL OR LTRIM(RTRIM(@AttachmentPath)) = '')
    BEGIN
        RAISERROR(N'هذا النوع من الإجازات يتطلب إرفاق ملف.', 16, 1);
        RETURN;
    END

    DECLARE @DaysCount INT = DATEDIFF(DAY, @StartDate, @EndDate) + 1;

    IF @DaysCount > @MaxDays
    BEGIN
        RAISERROR(N'عدد أيام الطلب يتجاوز الحد الأقصى المسموح به لهذا النوع من الإجازات.', 16, 1);
        RETURN;
    END

    IF (SELECT COUNT(1) FROM LeaveManagement.EmployeeLeaveRequests WHERE LeaveManagement.EmployeeLeaveRequests.EmployeeId = @EmployeeId AND LeaveManagement.EmployeeLeaveRequests.RequestStatus IN ('Pending', 'Approved') AND (@StartDate <= LeaveManagement.EmployeeLeaveRequests.EndDate AND @EndDate >= LeaveManagement.EmployeeLeaveRequests.StartDate)) > 0
    BEGIN
        RAISERROR(N'يوجد طلب إجازة متداخل لنفس الموظف خلال هذه الفترة.', 16, 1);
        RETURN;
    END

    INSERT INTO LeaveManagement.EmployeeLeaveRequests (
        EmployeeId, LeaveTypeId, StartDate, EndDate, NumberOfDays, RequestStatus, RequestReason, AttachmentPath, CreationTime
    )
    VALUES (
        @EmployeeId, @LeaveTypeId, @StartDate, @EndDate, @DaysCount, 'Pending', @RequestReason, @AttachmentPath, SYSDATETIME()
    );
END;
GO
-- 7. Procedure: LeaveManagement.ApproveLeaveRequest
CREATE PROCEDURE LeaveManagement.ApproveLeaveRequest
    @RequestId INT,
    @ApprovedByEmployeeId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @EmployeeId INT, @Status NVARCHAR(20), @StartDate DATE, @EndDate DATE;
    SELECT @EmployeeId = LeaveManagement.EmployeeLeaveRequests.EmployeeId, @Status = LeaveManagement.EmployeeLeaveRequests.RequestStatus, @StartDate = LeaveManagement.EmployeeLeaveRequests.StartDate, @EndDate = LeaveManagement.EmployeeLeaveRequests.EndDate
    FROM LeaveManagement.EmployeeLeaveRequests WHERE LeaveManagement.EmployeeLeaveRequests.IDDD = @RequestId;

    IF @Status <> 'Pending'
    BEGIN
        RAISERROR(N'يمكن موافقة الطلبات المعلقة (Pending) فقط.', 16, 1);
        RETURN;
    END

    IF @EmployeeId = @ApprovedByEmployeeId
    BEGIN
        RAISERROR(N'لا يمكن للموظف الموافقة على طلب الإجازة الخاص به.', 16, 1);
        RETURN;
    END

    UPDATE LeaveManagement.EmployeeLeaveRequests
    SET RequestStatus = 'Approved',
        ApprovedByEmployeeId = @ApprovedByEmployeeId,
        ApprovalDate = SYSDATETIME(),
        LastModificationTime = SYSDATETIME()
    WHERE LeaveManagement.EmployeeLeaveRequests.IDDD= @RequestId;

    DECLARE @CurrDate DATE = @StartDate;
    WHILE @CurrDate <= @EndDate
    BEGIN
        EXEC Attendance.CalculateDailyAttendance @EmployeeId = @EmployeeId, @AttendanceDate = @CurrDate;
        SET @CurrDate = DATEADD(DAY, 1, @CurrDate);
    END;
END;
GO

USE EmployeeAttendanceManagementDB;
GO

-- 8. Procedure: LeaveManagement.RejectLeaveRequest
CREATE PROCEDURE LeaveManagement.RejectLeaveRequest
    @RequestId INT,
    @RejectionReason NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;

    IF @RejectionReason IS NULL OR LTRIM(RTRIM(@RejectionReason)) = ''
    BEGIN
        RAISERROR(N'يجب ذكر سبب الرفض.', 16, 1);
        RETURN;
    END

    IF (SELECT COUNT(1) FROM LeaveManagement.EmployeeLeaveRequests WHERE LeaveManagement.EmployeeLeaveRequests.EMPLOYEEID = @RequestId AND LeaveManagement.EmployeeLeaveRequests.RequestStatus = 'Pending') = 0
    BEGIN
        RAISERROR(N'الطلب غير موجود أو غير معلق.', 16, 1);
        RETURN;
    END

    UPDATE LeaveManagement.EmployeeLeaveRequests
    SET RequestStatus = 'Rejected',
        RejectionReason = @RejectionReason,
        LastModificationTime = SYSDATETIME()
    WHERE LeaveManagement.EmployeeLeaveRequests.EMPLOYEEID = @RequestId;
END;
GO
USE EmployeeAttendanceManagementDB;
GO

-- 9. Procedure: Organization.GetEmployees
CREATE PROCEDURE Organization.GetEmployees
    @DepartmentId INT = NULL,
    @SearchTerm NVARCHAR(50) = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    WITH EmployeesPaged AS
    (
        SELECT Organization.Employees.Id, 
               Organization.Employees.EMPLOYEENUMPUER, 
               Organization.Employees.FirstName, 
               Organization.Employees.LastName, 
               Organization.Employees.EmailAddress, 
               Organization.Departments.DepartmentName,
               COUNT(*) OVER() AS TotalRecords,
               ROW_NUMBER() OVER (ORDER BY Organization.Employees.Id DESC) AS RowNum
        FROM Organization.Employees
        INNER JOIN Organization.Departments ON Organization.Employees.DepartmentId = Organization.Departments.DepartmentId
        WHERE Organization.Employees.IsDeleted = 0
          AND (@DepartmentId IS NULL OR Organization.Employees.DepartmentId = @DepartmentId)
          AND (@SearchTerm IS NULL OR Organization.Employees.FirstName LIKE '%' + @SearchTerm + '%' OR Organization.Employees.LastName LIKE '%' + @SearchTerm + '%' OR Organization.Employees.EMPLOYEENUMPUER LIKE '%' + @SearchTerm + '%')
    )
    SELECT EmployeesPaged.Id, 
           EmployeesPaged.EMPLOYEENUMPUER, 
           EmployeesPaged.FirstName, 
           EmployeesPaged.LastName, 
           EmployeesPaged.EmailAddress, 
           EmployeesPaged.DepartmentName, 
           EmployeesPaged.TotalRecords
    FROM EmployeesPaged
    WHERE EmployeesPaged.RowNum BETWEEN ((@PageNumber - 1) * @PageSize + 1) AND (@PageNumber * @PageSize)
    ORDER BY EmployeesPaged.Id DESC;
END;
GO
-- 10. Procedure: Attendance.GetAttendanceReport
CREATE PROCEDURE Attendance.GetAttendanceReport
    @EmployeeId INT = NULL,
    @StartDate DATE = NULL,
    @EndDate DATE = NULL,
    @PageNumber INT = 1,
    @PageSize INT = 10
AS
BEGIN
    SET NOCOUNT ON;

    WITH AttendancePaged AS
    (
        SELECT Attendance.EmployeeAttendances.Id, 
               Organization.Employees.EMPLOYEENUMPUER, 
               Organization.Employees.FirstName + N' ' + Organization.Employees.LastName AS EmployeeName,
               Attendance.EmployeeAttendances.AttendanceDate, 
               Attendance.EmployeeAttendances.AttendanceStatus, 
               Attendance.EmployeeAttendances.TotalWorkedMinutes, 
               Attendance.EmployeeAttendances.LateMinutes,
               COUNT(*) OVER() AS TotalRecords,
               ROW_NUMBER() OVER (ORDER BY Attendance.EmployeeAttendances.AttendanceDate DESC, Attendance.EmployeeAttendances.Id ASC) AS RowNum
        FROM Attendance.EmployeeAttendances
        INNER JOIN Organization.Employees ON Attendance.EmployeeAttendances.ID = Organization.Employees.Id
        WHERE (@EmployeeId IS NULL OR Attendance.EmployeeAttendances.ID = @EmployeeId)
          AND (@StartDate IS NULL OR Attendance.EmployeeAttendances.AttendanceDate >= @StartDate)
          AND (@EndDate IS NULL OR Attendance.EmployeeAttendances.AttendanceDate <= @EndDate)
    )
    SELECT AttendancePaged.Id, 
           AttendancePaged.EMPLOYEENUMPUER, 
           AttendancePaged.EmployeeName, 
           AttendancePaged.AttendanceDate, 
           AttendancePaged.AttendanceStatus, 
           AttendancePaged.TotalWorkedMinutes, 
           AttendancePaged.LateMinutes, 
           AttendancePaged.TotalRecords
    FROM AttendancePaged
    WHERE AttendancePaged.RowNum BETWEEN ((@PageNumber - 1) * @PageSize + 1) AND (@PageNumber * @PageSize)
    ORDER BY AttendancePaged.AttendanceDate DESC, AttendancePaged.Id ASC;
END;
GO
-- 11. Procedure: Payroll.ProcessMonthlyPayroll
CREATE PROCEDURE Payroll.ProcessMonthlyPayroll
    @PayrollYear INT,
    @PayrollMonth INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @PayrollMonth < 1 OR @PayrollMonth > 12
    BEGIN
        RAISERROR(N'الشهر يجب أن يكون بين 1 و 12.', 16, 1);
        RETURN;
    END

    IF (SELECT COUNT(1) FROM Payroll.MonthlyPayrolls WHERE Payroll.MonthlyPayrolls.PayrollYear = @PayrollYear AND Payroll.MonthlyPayrolls.PayrollMonth = @PayrollMonth) > 0
    BEGIN
        RAISERROR(N'تم معالجة رواتب هذا الشهر والسنة سابقاً.', 16, 1);
        RETURN;
    END

    INSERT INTO Payroll.MonthlyPayrolls (
        EmployeeId, PayrollYear, PayrollMonth, BasicSalary, TotalAllowances, OvertimeAmount, DeductionAmount, NetSalary, PayrollStatus, ProcessedDate, CreationTime
    )
    SELECT 
        Organization.Employees.Id,
        @PayrollYear,
        @PayrollMonth,
        Organization.Employees.BasicSalary,
        0.00 AS TotalAllowances,
        0.00 AS OvertimeAmount,
        0.00 AS DeductionAmount,
        Organization.Employees.BasicSalary AS NetSalary,
        'Processed',
        SYSDATETIME(),
        SYSDATETIME()
    FROM Organization.Employees
    WHERE Organization.Employees.IsActive = 1 AND Organization.Employees.IsDeleted = 0;

    SELECT Payroll.MonthlyPayrolls.PayrollYear, Payroll.MonthlyPayrolls.PayrollMonth, COUNT(*) AS TotalEmployeesProcessed, SUM(Payroll.MonthlyPayrolls.NetSalary) AS TotalNetPayroll
    FROM Payroll.MonthlyPayrolls
    WHERE Payroll.MonthlyPayrolls.PayrollYear = @PayrollYear AND Payroll.MonthlyPayrolls.PayrollMonth = @PayrollMonth
    GROUP BY Payroll.MonthlyPayrolls.PayrollYear, Payroll.MonthlyPayrolls.PayrollMonth;
END;
GO