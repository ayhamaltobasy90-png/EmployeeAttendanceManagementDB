/*1*/
create table Organization.Departments(
DepartmentId int IDENTITY(1,1) PRIMARY KEY,
DepartmentCode INT UNIQUE,
DepartmentName NVARCHAR(50) NOT NULL,
CONSTRAINT CHK_DepartmentName_NotEmpty CHECK (LEN(LTRIM(RTRIM(DepartmentName))) > 0),--------------
ParentDepartmentId INT NULL  
CONSTRAINT FK_DEP
FOREIGN KEY(ParentDepartmentId)
REFERENCES Organization.Departments(DepartmentId),-------------
ManagerId INT NULL,
IsActive BIT NOT NULL DEFAULT 1,-----------------
CreationTime DATETIME2 NOT NULL DEFAULT GETDATE(),-----
LastModificationTime DATETIME2 NULL,------
IsDeleted BIT NOT NULL DEFAULT 0-----
);
/*2*/
CREATE TABLE Organization.JobTitles(
id int  primary key,
JobTitleCode int unique,
JobTitleName NVARCHAR(50) NOT NULL,
MinimumSalary DECIMAL(20,3) NOT NULL
CONSTRAINT CH_MINI CHECK (MinimumSalary>0),
maximumSalary DECIMAL(20,3) NOT NULL,
IsActive BIT NOT NULL DEFAULT 1,
CREATIONTIME DATETIME2 NOT NULL DEFAULT GETDATE(),
CONSTRAINT CH_MAX CHECK (MAXimumSalary>=MinimumSalary)
);
/*3*/
CREATE TABLE Organization.Employees(
ID INT IDENTITY(1,1) PRIMARY KEY,
EMPLOYEENUMPUER INT UNIQUE,
NationalId VARCHAR(20) UNIQUE,
FirstName NVARCHAR(50),
MiddleName NVARCHAR(50) NOT NULL,
LastName NVARCHAR(50) NOT NULL,
EmailAddress VARCHAR(255)  UNIQUE ,
MobileNumber VARCHAR(20) ,
BirthDate DATE ,
HireDate DATE,
TerminationDate DATE NULL ,
Gender CHAR(1) NOT NULL  
CONSTRAINT CH_GENDER CHECK (Gender IN ('M','F')),
DepartmentId INT NOT NULL,
CONSTRAINT CH_FKe FOREIGN KEY (DepartmentId)REFERENCES  Organization.Departments(DepartmentId),
JobTitleId INT NOT NULL,
CONSTRAINT CH_FK FOREIGN KEY (JobTitleId)REFERENCES  Organization.JobTitles(ID),
ManagerId INT NULL,
CONSTRAINT FKK_Employees_Manager 
 FOREIGN KEY (ManagerId) REFERENCES Organization.Employees(Id),
 EmploymentStatus VARCHAR(20) NOT NULL DEFAULT 'Active',
 CONSTRAINT CH_STATUS CHECK ( EmploymentStatus IN ('Active','Suspended','Terminated')),
 BasicSalary DECIMAL(20,3) NOT NULL,
 CONSTRAINT CH_BASICSAL CHECK ( BasicSalary>0),
 IsActive BIT NOT NULL DEFAULT 1,
 CreationTime DATETIME NOT NULL DEFAULT GETDATE(),
 LastModificationTime DATETIME NOT NULL DEFAULT GETDATE(), 
 IsDeleted BIT NOT NULL DEFAULT 0,-----------
 CONSTRAINT CH_Emp_AgeHir CHECK (HireDate >= DATEADD(YEAR, 18, BirthDate)),
 CONSTRAINT CH_LASTMOTIME CHECK (  LastModificationTime>= CreationTime),
 CONSTRAINT CH_TERMINADATE CHECK ( TerminationDate IS NULL OR TerminationDate>=HireDate)
 
);
/*4*/


CREATE TABLE Attendance.WorkSchedules(
WorkScheduleid int Primary key,
ScheduleName NVARCHAR(50) UNIQUE,
StartTime TIME(0) NOT NULL ,
EndTime TIME(0) NOT NULL,
GracePeriodMinutes INT NOT NULL DEFAULT 0,
RequiredWorkingMinutes INT NOT NULL,
IsActive BIT NOT NULL DEFAULT 1,
CONSTRAINT CH_TIMEEE CHECK (EndTime >StartTime),
CONSTRAINT CH_GPM CHECK (GracePeriodMinutes>=0),
CONSTRAINT CH_RWM CHECK (RequiredWorkingMinutes >=0)
);
--------------------------------------------------------------------------------
ALTER TABLE Organization.Departments
ADD CONSTRAINT FK_Departments_Employees_Manager
 FOREIGN KEY (ManagerId) REFERENCES Organization.Employees(ID);
 -------------------------------------------------------------------------------
/*5*/
CREATE TABLE Attendance.EmployeeWorkSchedules (
    EmployeeWorkScheduleId INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeId INT NOT NULL,
    WorkScheduleId INT NOT NULL,
    EffectiveFrom DATETIME2 NOT NULL DEFAULT GETDATE(),
    EffectiveTo DATETIME2 NULL, 
    IsActive BIT NOT NULL DEFAULT 1,
    CreationTime DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_EmployeeWorkSchedules_Employees 
        FOREIGN KEY (EmployeeId) REFERENCES Organization.Employees(ID),
    CONSTRAINT FK_EmployeeWorkSchedules_WorkSchedules 
        FOREIGN KEY (WorkScheduleId) REFERENCES Attendance.WorkSchedules(WorkScheduleId),
    CONSTRAINT CHK_EmployeeWorkSchedules_Dates 
        CHECK (EffectiveTo IS NULL OR EffectiveTo > EffectiveFrom),
    CONSTRAINT UQ_Employee_Schedule_EffectiveFrom 
        UNIQUE (EmployeeId, WorkScheduleId, EffectiveFrom)
);
------------------------------------------------------------------------------------
GO
CREATE UNIQUE NONCLUSTERED INDEX UX_EmployeeWorkSchedules_OneActivePerEmployee
ON Attendance.EmployeeWorkSchedules (EmployeeId)
WHERE IsActive = 1;
GO
/*6*/
CREATE TABLE Attendance.AttendanceTransactions (
    Id INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeId INT NOT NULL,
    TransactionDateTime DATETIME2 NOT NULL,
    TransactionType VARCHAR(10) NOT NULL,
    DeviceCode NVARCHAR(50) NULL,
    LocationName NVARCHAR(100) NULL,
    SourceType VARCHAR(10) NOT NULL,
    CreatedByUserId INT NULL,
    CreationTime DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_AttTrs_Employees 
        FOREIGN KEY (EmployeeId) REFERENCES Organization.Employees(ID),
    CONSTRAINT CHK_AttTr_TranTy
    CHECK (TransactionType IN ('Entry', 'Exit')),
    CONSTRAINT CHK_AttTra_SouTyp
    CHECK (SourceType IN ('Device', 'Manual', 'Mobile')),
    CONSTRAINT UQ_AttTra_Empl_DaTi
        UNIQUE (EmployeeId, TransactionDateTime)
);
GO
/*7*/
CREATE TABLE Attendance.EmployeeAttendances (
    Idd INT IDENTITY(1,1) PRIMARY KEY,
    ID INT NOT NULL,
    AttendanceDate DATE NOT NULL,
    FirstEntryTime TIME(0) NULL,
    LastExitTime TIME(0) NULL,
    TotalWorkedMinutes INT NOT NULL DEFAULT 0,
    LateMinutes INT NOT NULL DEFAULT 0,
    EarlyLeaveMinutes INT NOT NULL DEFAULT 0,
    OvertimeMinutes INT NOT NULL DEFAULT 0,
    AttendanceStatus VARCHAR(15) NOT NULL,
    IsManualUpdate BIT NOT NULL DEFAULT 0,
    Notes NVARCHAR(250) NULL,
    CreationTime DATETIME2 NOT NULL DEFAULT GETDATE(),
    LastModificationTime DATETIME2 NULL,
    CONSTRAINT FK_EmpAtt_Emp
    FOREIGN KEY (ID) REFERENCES Organization.Employees(ID),
    CONSTRAINT UQ_EmpAttenes_Emp_Da 
     UNIQUE (ID, AttendanceDate),
    CONSTRAINT CHK_EmpAtt_St 
    CHECK (AttendanceStatus IN ('Present', 'Absent', 'Late', 'Incomplete', 'OnLeave', 'Holiday', 'Weekend')),
    CONSTRAINT CHK_EmpAtt_TotalWorMi CHECK (TotalWorkedMinutes >= 0),
    CONSTRAINT CHK_EmpAtt_LateMis CHECK (LateMinutes >= 0),
    CONSTRAINT CHK_EmpAtt_EarlyLeaveMi CHECK (EarlyLeaveMinutes >= 0),
    CONSTRAINT CHK_EmpAtts_OvimeMi CHECK (OvertimeMinutes >= 0),
    CONSTRAINT CHK_EmpAtt_EntryExTi
    CHECK (FirstEntryTime IS NULL OR LastExitTime IS NULL OR LastExitTime > FirstEntryTime)
);
GO
-----------------------------------------------------------------------
/*8*/
Create table LeaveManagement.LeaveTypes(
Id int identity(1,1) primary key,
LeaveTypeCode int unique,
LeaveTypeName nvarchar(50) not null,
MaximumDaysPerYear int ,
constraint ch_maxdayes check (MaximumDaysPerYear>=0),
IsPaid BIT NOT NULL DEFAULT 0,
RequiresAttachment BIT NOT NULL DEFAULT 0,
IsActive BIT NOT NULL DEFAULT 1,
CreationTime DATETIME2 NOT NULL DEFAULT GETDATE()

);
-----------------------------------------------------------------------------
/*9*/
Create table LeaveManagement.EmployeeLeaveRequests(
IDDD int identity(1,1) primary key ,
EMPLOYEEID int NOT NULL, 
CONSTRAINT FK_EMPLOYEEID_EmployeeLeaveRequests
FOREIGN KEY (EMPLOYEEID) REFERENCES Organization.Employees(ID),--EMPLOYEEID
LeaveTypeId INT NOT NULL ,
CONSTRAINT FK_LeaveTypeId_EmployeeLeaveRequests
FOREIGN KEY (LeaveTypeId) REFERENCES LeaveManagement.LeaveTypes(ID),
StartDate DATE  NOT NULL DEFAULT GETDATE(),
EndDate DATE   NOT NULL DEFAULT GETDATE(),
NumberOfDays INT ,
RequestStatus VARCHAR(10) NOT NULL DEFAULT 'Pending',
CONSTRAINT CH_RequestStatus CHECK (RequestStatus IN( 'Pending','Approved', 'Rejected' ,' Cancelled')),
RequestReason NVARCHAR(100) NOT NULL,
RejectionReason NVARCHAR(100) NOT NULL,
ApprovedByEmployeeId INT  NOT NULL ,
CONSTRAINT FK_ApprovedByEmployeeId_ApprovedByEmployee 
FOREIGN KEY (ApprovedByEmployeeId) REFERENCES Organization.Employees(ID),
ApprovalDate DATE  NOT NULL DEFAULT GETDATE(),
AttachmentPath VARCHAR(300) NOT NULL,
CreationTime DATETIME2 NOT NULL DEFAULT GETDATE(),
LastModificationTime DATETIME2 NOT NULL DEFAULT GETDATE(),
CONSTRAINT CH_StartDate_EndDate CHECK (EndDate>StartDate),
CONSTRAINT CH_NumberOfDays_Date CHECK (NumberOfDays >0),
CONSTRAINT CHK_LeaveRequests_PreveAppro
    CHECK (ApprovedByEmployeeId <> EmployeeId)
);
--------------------------------------------------------
/*10*/
Create table Attendance.PublicHolidays(
Id int identity (1,1) primary key,
HolidayName nvarchar(20)  not null unique,
HolidayDate date not null unique default getdate(),
IsRecurringYearly VARCHAR(3) NOT NULL,
IsActive BIT NOT NULL DEFAULT 1

);
--------------------------------------------------------
/*11*/
Create table  Payroll.EmployeeSalaries(
Id int identity(1,1) primary key ,
EmployeeId int ,
constraint fk_EmployId foreign key (EmployeeId) references Organization.Employees(ID),
BasicSalary DECIMAL(18,2) NOT NULL DEFAULT 0.01,
CONSTRAINT CH_BasicSalary  CHECK (BasicSalary >0.00),
HousingAllowance DECIMAL(18,2) NOT NULL DEFAULT 0.001,
CONSTRAINT CH_HousingAllowance CHECK (HousingAllowance>0.00),
TransportationAllowance DECIMAL(18,2) NOT NULL DEFAULT 0.01,
CONSTRAINT CH_TransportationAllowance CHECK (TransportationAllowance>0.00),
OtherAllowance DECIMAL(18,2) NOT NULL DEFAULT 0.01,
CONSTRAINT CH_OtherAllowance CHECK (OtherAllowance>0.00),
EffectiveFrom DATE NOT NULL ,
EffectiveTo DATE NOT NULL ,
IsCurrent BIT NOT NULL DEFAULT 1,
CreationTime DATETIME2 NOT NULL DEFAULT GETDATE(),
CONSTRAINT CH_EffectiveFrom_EffectiveTo CHECK (EffectiveTo>EffectiveFrom),

);
GO
CREATE UNIQUE NONCLUSTERED INDEX UX_EmployeeSalaries_OneCurrentPerEmployee
ON Payroll.EmployeeSalaries (EmployeeId)
WHERE IsCurrent = 1;
GO
--------------------------------------------------------
/*12*/
CREATE TABLE Payroll.MonthlyPayrolls (
 Id INT IDENTITY(1,1) PRIMARY KEY,
 EmployeeId INT NOT NULL,
 CONSTRAINT FK_MonthlyPayrolls_Employees
    FOREIGN KEY (EmployeeId) REFERENCES Organization.Employees(ID),
 PayrollYear INT NOT NULL,
 PayrollMonth INT NOT NULL,
 BasicSalary DECIMAL(18, 2) NOT NULL DEFAULT 0.00,
 TotalAllowances DECIMAL(18, 2) NOT NULL DEFAULT 0.00,
 OvertimeAmount DECIMAL(18, 2) NOT NULL DEFAULT 0.00,
 DeductionAmount DECIMAL(18, 2) NOT NULL DEFAULT 0.00,
 NetSalary AS (BasicSalary + TotalAllowances + OvertimeAmount - DeductionAmount) PERSISTED,
 PayrollStatus VARCHAR(15) NOT NULL DEFAULT 'Draft',
 ProcessedDate DATETIME2 NULL,
 CreationTime DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT UQ_MonthlyPayrolls_EmployeeMonthYear 
     UNIQUE (EmployeeId, PayrollYear, PayrollMonth),
    CONSTRAINT CHK_MonthlyPayrolls_PayrollMonth 
    CHECK (PayrollMonth BETWEEN 1 AND 12),   
    CONSTRAINT CHK_MonthlyPayrolls_PayrollYear 
    CHECK (PayrollYear >= 2000),
    CONSTRAINT CHK_MonthlyPayrolls_BasicSalary 
    CHECK (BasicSalary >= 0),
    CONSTRAINT CHK_MonthlyPayrolls_TotalAllowances 
  CHECK (TotalAllowances >= 0),
  CONSTRAINT CHK_MonthlyPayrolls_OvertimeAmount 
   CHECK (OvertimeAmount >= 0),
    CONSTRAINT CHK_MonthlyPayrolls_DeductionAmount 
     CHECK (DeductionAmount >= 0),
    CONSTRAINT CHK_MonthlyPayrolls_Status 
        CHECK (PayrollStatus IN ('Draft', 'Processed', 'Paid', 'Cancelled'))
);
--------------------------------------------------------
/*13*/
Create TABLE Security.Users(
Id INT IDENTITY(1,1) PRIMary KEY ,
Username NVARCHAR(50)  NOT NULL UNIQUE,
PasswordHash NVARCHAR(MAX) NOT NULL,
EmailAddress VARCHAR(100) NOT NULL UNIQUE,
EmployeeId INT NULL ,
IsActive BIT NOT NULL DEFAULT 1,
LastLoginTime DATETIME2  NULL ,
CreationTime DATETIME2 NOT NULL DEFAULT GETDATE(),
CONSTRAINT FK_EmployeeIDD FOREIGN KEY (EmployeeId) REFERENCES Organization.Employees(ID),  

);
CREATE UNIQUE NONCLUSTERED INDEX UX_Users_OneUserPerEmployee
ON Security.Users (EmployeeId)
WHERE EmployeeId IS NOT NULL;
GO
--------------------------------------------------------
/*14*/
 Create TABLE Audit.AuditLogs(
Id INT IDENTITY (1,1) PRIMARY KEY,
TableName VARCHAR(50) NOT NULL,
RecordId INT UNIQUE,
ActionType NVARCHAR(10),
CONSTRAINT CH_ActionType CHECK(ActionType IN ('INSERT', 'UPDATE','DELETE')),
OldValues  NVARCHAR(MAX) ,
NewValues NVARCHAR(MAX) ,
ModifiedByUserId INT UNIQUE,
ModificationTime DATETIME2 NOT NULL DEFAULT GETDATE()

 );