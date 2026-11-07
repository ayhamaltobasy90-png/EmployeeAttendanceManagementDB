USE [EmployeeAttendanceManagementDB]
GO
/****** Object:  Table [Attendance].[AttendanceTransactions]    Script Date: 11/3/2026 4:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Attendance].[AttendanceTransactions](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[TransactionDateTime] [datetime2](7) NOT NULL,
	[TransactionType] [varchar](10) NOT NULL,
	[DeviceCode] [nvarchar](50) NULL,
	[LocationName] [nvarchar](100) NULL,
	[SourceType] [varchar](10) NOT NULL,
	[CreatedByUserId] [int] NULL,
	[CreationTime] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_AttTra_Empl_DaTi] UNIQUE NONCLUSTERED 
(
	[EmployeeId] ASC,
	[TransactionDateTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Attendance].[EmployeeAttendances]    Script Date: 11/3/2026 4:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Attendance].[EmployeeAttendances](
	[Idd] [int] IDENTITY(1,1) NOT NULL,
	[ID] [int] NOT NULL,
	[AttendanceDate] [date] NOT NULL,
	[FirstEntryTime] [time](0) NULL,
	[LastExitTime] [time](0) NULL,
	[TotalWorkedMinutes] [int] NOT NULL,
	[LateMinutes] [int] NOT NULL,
	[EarlyLeaveMinutes] [int] NOT NULL,
	[OvertimeMinutes] [int] NOT NULL,
	[AttendanceStatus] [varchar](15) NOT NULL,
	[IsManualUpdate] [bit] NOT NULL,
	[Notes] [nvarchar](250) NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[LastModificationTime] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[Idd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_EmpAttenes_Emp_Da] UNIQUE NONCLUSTERED 
(
	[ID] ASC,
	[AttendanceDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Attendance].[EmployeeWorkSchedules]    Script Date: 11/3/2026 4:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Attendance].[EmployeeWorkSchedules](
	[EmployeeWorkScheduleId] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[WorkScheduleId] [int] NOT NULL,
	[EffectiveFrom] [datetime2](7) NOT NULL,
	[EffectiveTo] [datetime2](7) NULL,
	[IsActive] [bit] NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeWorkScheduleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_Employee_Schedule_EffectiveFrom] UNIQUE NONCLUSTERED 
(
	[EmployeeId] ASC,
	[WorkScheduleId] ASC,
	[EffectiveFrom] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Attendance].[PublicHolidays]    Script Date: 11/3/2026 4:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Attendance].[PublicHolidays](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[HolidayName] [nvarchar](20) NOT NULL,
	[HolidayDate] [date] NOT NULL,
	[IsRecurringYearly] [varchar](3) NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[HolidayName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[HolidayDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Attendance].[WorkSchedules]    Script Date: 11/3/2026 4:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Attendance].[WorkSchedules](
	[WorkScheduleid] [int] NOT NULL,
	[ScheduleName] [nvarchar](50) NULL,
	[StartTime] [time](0) NOT NULL,
	[EndTime] [time](0) NOT NULL,
	[GracePeriodMinutes] [int] NOT NULL,
	[RequiredWorkingMinutes] [int] NOT NULL,
	[IsActive] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[WorkScheduleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ScheduleName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Audit].[AuditLogs]    Script Date: 11/3/2026 4:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Audit].[AuditLogs](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [varchar](50) NOT NULL,
	[RecordId] [int] NULL,
	[ActionType] [nvarchar](10) NULL,
	[OldValues] [nvarchar](max) NULL,
	[NewValues] [nvarchar](max) NULL,
	[ModifiedByUserId] [int] NULL,
	[ModificationTime] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[ModifiedByUserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[RecordId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [LeaveManagement].[EmployeeLeaveRequests]    Script Date: 11/3/2026 4:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LeaveManagement].[EmployeeLeaveRequests](
	[IDDD] [int] IDENTITY(1,1) NOT NULL,
	[EMPLOYEEID] [int] NOT NULL,
	[LeaveTypeId] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NOT NULL,
	[NumberOfDays] [int] NULL,
	[RequestStatus] [varchar](10) NOT NULL,
	[RequestReason] [nvarchar](100) NOT NULL,
	[RejectionReason] [nvarchar](100) NOT NULL,
	[ApprovedByEmployeeId] [int] NOT NULL,
	[ApprovalDate] [date] NOT NULL,
	[AttachmentPath] [varchar](300) NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[LastModificationTime] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[IDDD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [LeaveManagement].[LeaveTypes]    Script Date: 11/3/2026 4:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LeaveManagement].[LeaveTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[LeaveTypeCode] [int] NULL,
	[LeaveTypeName] [nvarchar](50) NOT NULL,
	[MaximumDaysPerYear] [int] NULL,
	[IsPaid] [bit] NOT NULL,
	[RequiresAttachment] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[LeaveTypeCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Organization].[Departments]    Script Date: 11/3/2026 4:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Organization].[Departments](
	[DepartmentId] [int] IDENTITY(1,1) NOT NULL,
	[DepartmentCode] [int] NULL,
	[DepartmentName] [nvarchar](50) NOT NULL,
	[ParentDepartmentId] [int] NULL,
	[ManagerId] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[LastModificationTime] [datetime2](7) NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DepartmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[DepartmentCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Organization].[Employees]    Script Date: 11/3/2026 4:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Organization].[Employees](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EMPLOYEENUMPUER] [int] NULL,
	[NationalId] [varchar](20) NULL,
	[FirstName] [nvarchar](50) NULL,
	[MiddleName] [nvarchar](50) NOT NULL,
	[LastName] [nvarchar](50) NOT NULL,
	[EmailAddress] [varchar](255) NULL,
	[MobileNumber] [varchar](20) NULL,
	[BirthDate] [date] NULL,
	[HireDate] [date] NULL,
	[TerminationDate] [date] NULL,
	[Gender] [char](1) NOT NULL,
	[DepartmentId] [int] NOT NULL,
	[JobTitleId] [int] NOT NULL,
	[ManagerId] [int] NULL,
	[EmploymentStatus] [varchar](20) NOT NULL,
	[BasicSalary] [decimal](20, 3) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CreationTime] [datetime] NOT NULL,
	[LastModificationTime] [datetime] NOT NULL,
	[IsDeleted] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[EMPLOYEENUMPUER] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[EmailAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[NationalId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Organization].[JobTitles]    Script Date: 11/3/2026 4:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Organization].[JobTitles](
	[id] [int] NOT NULL,
	[JobTitleCode] [int] NULL,
	[JobTitleName] [nvarchar](50) NOT NULL,
	[MinimumSalary] [decimal](20, 3) NOT NULL,
	[maximumSalary] [decimal](20, 3) NOT NULL,
	[IsActive] [bit] NOT NULL,
	[CREATIONTIME] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[JobTitleCode] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[EmployeeSalaries]    Script Date: 11/3/2026 4:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[EmployeeSalaries](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [int] NULL,
	[BasicSalary] [decimal](18, 2) NOT NULL,
	[HousingAllowance] [decimal](18, 2) NOT NULL,
	[TransportationAllowance] [decimal](18, 2) NOT NULL,
	[OtherAllowance] [decimal](18, 2) NOT NULL,
	[EffectiveFrom] [date] NOT NULL,
	[EffectiveTo] [date] NOT NULL,
	[IsCurrent] [bit] NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Payroll].[MonthlyPayrolls]    Script Date: 11/3/2026 4:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Payroll].[MonthlyPayrolls](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeId] [int] NOT NULL,
	[PayrollYear] [int] NOT NULL,
	[PayrollMonth] [int] NOT NULL,
	[BasicSalary] [decimal](18, 2) NOT NULL,
	[TotalAllowances] [decimal](18, 2) NOT NULL,
	[OvertimeAmount] [decimal](18, 2) NOT NULL,
	[DeductionAmount] [decimal](18, 2) NOT NULL,
	[NetSalary]  AS ((([BasicSalary]+[TotalAllowances])+[OvertimeAmount])-[DeductionAmount]) PERSISTED,
	[PayrollStatus] [varchar](15) NOT NULL,
	[ProcessedDate] [datetime2](7) NULL,
	[CreationTime] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [UQ_MonthlyPayrolls_EmployeeMonthYear] UNIQUE NONCLUSTERED 
(
	[EmployeeId] ASC,
	[PayrollYear] ASC,
	[PayrollMonth] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [Security].[Users]    Script Date: 11/3/2026 4:22:24 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Security].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[PasswordHash] [nvarchar](max) NOT NULL,
	[EmailAddress] [varchar](100) NOT NULL,
	[EmployeeId] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[LastLoginTime] [datetime2](7) NULL,
	[CreationTime] [datetime2](7) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[EmailAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [Attendance].[AttendanceTransactions] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [Attendance].[EmployeeAttendances] ADD  DEFAULT ((0)) FOR [TotalWorkedMinutes]
GO
ALTER TABLE [Attendance].[EmployeeAttendances] ADD  DEFAULT ((0)) FOR [LateMinutes]
GO
ALTER TABLE [Attendance].[EmployeeAttendances] ADD  DEFAULT ((0)) FOR [EarlyLeaveMinutes]
GO
ALTER TABLE [Attendance].[EmployeeAttendances] ADD  DEFAULT ((0)) FOR [OvertimeMinutes]
GO
ALTER TABLE [Attendance].[EmployeeAttendances] ADD  DEFAULT ((0)) FOR [IsManualUpdate]
GO
ALTER TABLE [Attendance].[EmployeeAttendances] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [Attendance].[EmployeeWorkSchedules] ADD  DEFAULT (getdate()) FOR [EffectiveFrom]
GO
ALTER TABLE [Attendance].[EmployeeWorkSchedules] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [Attendance].[EmployeeWorkSchedules] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [Attendance].[PublicHolidays] ADD  DEFAULT (getdate()) FOR [HolidayDate]
GO
ALTER TABLE [Attendance].[PublicHolidays] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [Attendance].[WorkSchedules] ADD  DEFAULT ((0)) FOR [GracePeriodMinutes]
GO
ALTER TABLE [Attendance].[WorkSchedules] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [Audit].[AuditLogs] ADD  DEFAULT (getdate()) FOR [ModificationTime]
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests] ADD  DEFAULT (getdate()) FOR [StartDate]
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests] ADD  DEFAULT (getdate()) FOR [EndDate]
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests] ADD  DEFAULT ('Pending') FOR [RequestStatus]
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests] ADD  DEFAULT (getdate()) FOR [ApprovalDate]
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests] ADD  DEFAULT (getdate()) FOR [LastModificationTime]
GO
ALTER TABLE [LeaveManagement].[LeaveTypes] ADD  DEFAULT ((0)) FOR [IsPaid]
GO
ALTER TABLE [LeaveManagement].[LeaveTypes] ADD  DEFAULT ((0)) FOR [RequiresAttachment]
GO
ALTER TABLE [LeaveManagement].[LeaveTypes] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [LeaveManagement].[LeaveTypes] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [Organization].[Departments] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [Organization].[Departments] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [Organization].[Departments] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [Organization].[Employees] ADD  DEFAULT ('Active') FOR [EmploymentStatus]
GO
ALTER TABLE [Organization].[Employees] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [Organization].[Employees] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [Organization].[Employees] ADD  DEFAULT (getdate()) FOR [LastModificationTime]
GO
ALTER TABLE [Organization].[Employees] ADD  DEFAULT ((0)) FOR [IsDeleted]
GO
ALTER TABLE [Organization].[JobTitles] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [Organization].[JobTitles] ADD  DEFAULT (getdate()) FOR [CREATIONTIME]
GO
ALTER TABLE [Payroll].[EmployeeSalaries] ADD  DEFAULT ((0.01)) FOR [BasicSalary]
GO
ALTER TABLE [Payroll].[EmployeeSalaries] ADD  DEFAULT ((0.001)) FOR [HousingAllowance]
GO
ALTER TABLE [Payroll].[EmployeeSalaries] ADD  DEFAULT ((0.01)) FOR [TransportationAllowance]
GO
ALTER TABLE [Payroll].[EmployeeSalaries] ADD  DEFAULT ((0.01)) FOR [OtherAllowance]
GO
ALTER TABLE [Payroll].[EmployeeSalaries] ADD  DEFAULT ((1)) FOR [IsCurrent]
GO
ALTER TABLE [Payroll].[EmployeeSalaries] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [Payroll].[MonthlyPayrolls] ADD  DEFAULT ((0.00)) FOR [BasicSalary]
GO
ALTER TABLE [Payroll].[MonthlyPayrolls] ADD  DEFAULT ((0.00)) FOR [TotalAllowances]
GO
ALTER TABLE [Payroll].[MonthlyPayrolls] ADD  DEFAULT ((0.00)) FOR [OvertimeAmount]
GO
ALTER TABLE [Payroll].[MonthlyPayrolls] ADD  DEFAULT ((0.00)) FOR [DeductionAmount]
GO
ALTER TABLE [Payroll].[MonthlyPayrolls] ADD  DEFAULT ('Draft') FOR [PayrollStatus]
GO
ALTER TABLE [Payroll].[MonthlyPayrolls] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [Security].[Users] ADD  DEFAULT ((1)) FOR [IsActive]
GO
ALTER TABLE [Security].[Users] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [Attendance].[AttendanceTransactions]  WITH CHECK ADD  CONSTRAINT [FK_AttTrs_Employees] FOREIGN KEY([EmployeeId])
REFERENCES [Organization].[Employees] ([ID])
GO
ALTER TABLE [Attendance].[AttendanceTransactions] CHECK CONSTRAINT [FK_AttTrs_Employees]
GO
ALTER TABLE [Attendance].[EmployeeAttendances]  WITH CHECK ADD  CONSTRAINT [FK_EmpAtt_Emp] FOREIGN KEY([ID])
REFERENCES [Organization].[Employees] ([ID])
GO
ALTER TABLE [Attendance].[EmployeeAttendances] CHECK CONSTRAINT [FK_EmpAtt_Emp]
GO
ALTER TABLE [Attendance].[EmployeeWorkSchedules]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeWorkSchedules_Employees] FOREIGN KEY([EmployeeId])
REFERENCES [Organization].[Employees] ([ID])
GO
ALTER TABLE [Attendance].[EmployeeWorkSchedules] CHECK CONSTRAINT [FK_EmployeeWorkSchedules_Employees]
GO
ALTER TABLE [Attendance].[EmployeeWorkSchedules]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeWorkSchedules_WorkSchedules] FOREIGN KEY([WorkScheduleId])
REFERENCES [Attendance].[WorkSchedules] ([WorkScheduleid])
GO
ALTER TABLE [Attendance].[EmployeeWorkSchedules] CHECK CONSTRAINT [FK_EmployeeWorkSchedules_WorkSchedules]
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests]  WITH CHECK ADD  CONSTRAINT [FK_ApprovedByEmployeeId_ApprovedByEmployee] FOREIGN KEY([ApprovedByEmployeeId])
REFERENCES [Organization].[Employees] ([ID])
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests] CHECK CONSTRAINT [FK_ApprovedByEmployeeId_ApprovedByEmployee]
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests]  WITH CHECK ADD  CONSTRAINT [FK_EMPLOYEEID_EmployeeLeaveRequests] FOREIGN KEY([EMPLOYEEID])
REFERENCES [Organization].[Employees] ([ID])
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests] CHECK CONSTRAINT [FK_EMPLOYEEID_EmployeeLeaveRequests]
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests]  WITH CHECK ADD  CONSTRAINT [FK_LeaveTypeId_EmployeeLeaveRequests] FOREIGN KEY([LeaveTypeId])
REFERENCES [LeaveManagement].[LeaveTypes] ([Id])
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests] CHECK CONSTRAINT [FK_LeaveTypeId_EmployeeLeaveRequests]
GO
ALTER TABLE [Organization].[Departments]  WITH CHECK ADD  CONSTRAINT [FK_DEP] FOREIGN KEY([ParentDepartmentId])
REFERENCES [Organization].[Departments] ([DepartmentId])
GO
ALTER TABLE [Organization].[Departments] CHECK CONSTRAINT [FK_DEP]
GO
ALTER TABLE [Organization].[Departments]  WITH CHECK ADD  CONSTRAINT [FK_Departments_Employees_Manager] FOREIGN KEY([ManagerId])
REFERENCES [Organization].[Employees] ([ID])
GO
ALTER TABLE [Organization].[Departments] CHECK CONSTRAINT [FK_Departments_Employees_Manager]
GO
ALTER TABLE [Organization].[Employees]  WITH CHECK ADD  CONSTRAINT [CH_FK] FOREIGN KEY([JobTitleId])
REFERENCES [Organization].[JobTitles] ([id])
GO
ALTER TABLE [Organization].[Employees] CHECK CONSTRAINT [CH_FK]
GO
ALTER TABLE [Organization].[Employees]  WITH CHECK ADD  CONSTRAINT [CH_FKe] FOREIGN KEY([DepartmentId])
REFERENCES [Organization].[Departments] ([DepartmentId])
GO
ALTER TABLE [Organization].[Employees] CHECK CONSTRAINT [CH_FKe]
GO
ALTER TABLE [Organization].[Employees]  WITH CHECK ADD  CONSTRAINT [FKK_Employees_Manager] FOREIGN KEY([ManagerId])
REFERENCES [Organization].[Employees] ([ID])
GO
ALTER TABLE [Organization].[Employees] CHECK CONSTRAINT [FKK_Employees_Manager]
GO
ALTER TABLE [Payroll].[EmployeeSalaries]  WITH CHECK ADD  CONSTRAINT [fk_EmployId] FOREIGN KEY([EmployeeId])
REFERENCES [Organization].[Employees] ([ID])
GO
ALTER TABLE [Payroll].[EmployeeSalaries] CHECK CONSTRAINT [fk_EmployId]
GO
ALTER TABLE [Payroll].[MonthlyPayrolls]  WITH CHECK ADD  CONSTRAINT [FK_MonthlyPayrolls_Employees] FOREIGN KEY([EmployeeId])
REFERENCES [Organization].[Employees] ([ID])
GO
ALTER TABLE [Payroll].[MonthlyPayrolls] CHECK CONSTRAINT [FK_MonthlyPayrolls_Employees]
GO
ALTER TABLE [Security].[Users]  WITH CHECK ADD  CONSTRAINT [FK_EmployeeIDD] FOREIGN KEY([EmployeeId])
REFERENCES [Organization].[Employees] ([ID])
GO
ALTER TABLE [Security].[Users] CHECK CONSTRAINT [FK_EmployeeIDD]
GO
ALTER TABLE [Attendance].[AttendanceTransactions]  WITH CHECK ADD  CONSTRAINT [CHK_AttTr_TranTy] CHECK  (([TransactionType]='Exit' OR [TransactionType]='Entry'))
GO
ALTER TABLE [Attendance].[AttendanceTransactions] CHECK CONSTRAINT [CHK_AttTr_TranTy]
GO
ALTER TABLE [Attendance].[AttendanceTransactions]  WITH CHECK ADD  CONSTRAINT [CHK_AttTra_SouTyp] CHECK  (([SourceType]='Mobile' OR [SourceType]='Manual' OR [SourceType]='Device'))
GO
ALTER TABLE [Attendance].[AttendanceTransactions] CHECK CONSTRAINT [CHK_AttTra_SouTyp]
GO
ALTER TABLE [Attendance].[EmployeeAttendances]  WITH CHECK ADD  CONSTRAINT [CHK_EmpAtt_EarlyLeaveMi] CHECK  (([EarlyLeaveMinutes]>=(0)))
GO
ALTER TABLE [Attendance].[EmployeeAttendances] CHECK CONSTRAINT [CHK_EmpAtt_EarlyLeaveMi]
GO
ALTER TABLE [Attendance].[EmployeeAttendances]  WITH CHECK ADD  CONSTRAINT [CHK_EmpAtt_EntryExTi] CHECK  (([FirstEntryTime] IS NULL OR [LastExitTime] IS NULL OR [LastExitTime]>[FirstEntryTime]))
GO
ALTER TABLE [Attendance].[EmployeeAttendances] CHECK CONSTRAINT [CHK_EmpAtt_EntryExTi]
GO
ALTER TABLE [Attendance].[EmployeeAttendances]  WITH CHECK ADD  CONSTRAINT [CHK_EmpAtt_LateMis] CHECK  (([LateMinutes]>=(0)))
GO
ALTER TABLE [Attendance].[EmployeeAttendances] CHECK CONSTRAINT [CHK_EmpAtt_LateMis]
GO
ALTER TABLE [Attendance].[EmployeeAttendances]  WITH CHECK ADD  CONSTRAINT [CHK_EmpAtt_St] CHECK  (([AttendanceStatus]='Weekend' OR [AttendanceStatus]='Holiday' OR [AttendanceStatus]='OnLeave' OR [AttendanceStatus]='Incomplete' OR [AttendanceStatus]='Late' OR [AttendanceStatus]='Absent' OR [AttendanceStatus]='Present'))
GO
ALTER TABLE [Attendance].[EmployeeAttendances] CHECK CONSTRAINT [CHK_EmpAtt_St]
GO
ALTER TABLE [Attendance].[EmployeeAttendances]  WITH CHECK ADD  CONSTRAINT [CHK_EmpAtt_TotalWorMi] CHECK  (([TotalWorkedMinutes]>=(0)))
GO
ALTER TABLE [Attendance].[EmployeeAttendances] CHECK CONSTRAINT [CHK_EmpAtt_TotalWorMi]
GO
ALTER TABLE [Attendance].[EmployeeAttendances]  WITH CHECK ADD  CONSTRAINT [CHK_EmpAtts_OvimeMi] CHECK  (([OvertimeMinutes]>=(0)))
GO
ALTER TABLE [Attendance].[EmployeeAttendances] CHECK CONSTRAINT [CHK_EmpAtts_OvimeMi]
GO
ALTER TABLE [Attendance].[EmployeeWorkSchedules]  WITH CHECK ADD  CONSTRAINT [CHK_EmployeeWorkSchedules_Dates] CHECK  (([EffectiveTo] IS NULL OR [EffectiveTo]>[EffectiveFrom]))
GO
ALTER TABLE [Attendance].[EmployeeWorkSchedules] CHECK CONSTRAINT [CHK_EmployeeWorkSchedules_Dates]
GO
ALTER TABLE [Attendance].[WorkSchedules]  WITH CHECK ADD  CONSTRAINT [CH_GPM] CHECK  (([GracePeriodMinutes]>=(0)))
GO
ALTER TABLE [Attendance].[WorkSchedules] CHECK CONSTRAINT [CH_GPM]
GO
ALTER TABLE [Attendance].[WorkSchedules]  WITH CHECK ADD  CONSTRAINT [CH_RWM] CHECK  (([RequiredWorkingMinutes]>=(0)))
GO
ALTER TABLE [Attendance].[WorkSchedules] CHECK CONSTRAINT [CH_RWM]
GO
ALTER TABLE [Attendance].[WorkSchedules]  WITH CHECK ADD  CONSTRAINT [CH_TIMEEE] CHECK  (([EndTime]>[StartTime]))
GO
ALTER TABLE [Attendance].[WorkSchedules] CHECK CONSTRAINT [CH_TIMEEE]
GO
ALTER TABLE [Audit].[AuditLogs]  WITH CHECK ADD  CONSTRAINT [CH_ActionType] CHECK  (([ActionType]='DELETE' OR [ActionType]='UPDATE' OR [ActionType]='INSERT'))
GO
ALTER TABLE [Audit].[AuditLogs] CHECK CONSTRAINT [CH_ActionType]
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests]  WITH CHECK ADD  CONSTRAINT [CH_NumberOfDays_Date] CHECK  (([NumberOfDays]>(0)))
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests] CHECK CONSTRAINT [CH_NumberOfDays_Date]
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests]  WITH CHECK ADD  CONSTRAINT [CH_RequestStatus] CHECK  (([RequestStatus]=' Cancelled' OR [RequestStatus]='Rejected' OR [RequestStatus]='Approved' OR [RequestStatus]='Pending'))
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests] CHECK CONSTRAINT [CH_RequestStatus]
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests]  WITH CHECK ADD  CONSTRAINT [CH_StartDate_EndDate] CHECK  (([EndDate]>[StartDate]))
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests] CHECK CONSTRAINT [CH_StartDate_EndDate]
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests]  WITH CHECK ADD  CONSTRAINT [CHK_LeaveRequests_PreveAppro] CHECK  (([ApprovedByEmployeeId]<>[EmployeeId]))
GO
ALTER TABLE [LeaveManagement].[EmployeeLeaveRequests] CHECK CONSTRAINT [CHK_LeaveRequests_PreveAppro]
GO
ALTER TABLE [LeaveManagement].[LeaveTypes]  WITH CHECK ADD  CONSTRAINT [ch_maxdayes] CHECK  (([MaximumDaysPerYear]>=(0)))
GO
ALTER TABLE [LeaveManagement].[LeaveTypes] CHECK CONSTRAINT [ch_maxdayes]
GO
ALTER TABLE [Organization].[Departments]  WITH CHECK ADD  CONSTRAINT [CHK_DepartmentName_NotEmpty] CHECK  ((len(ltrim(rtrim([DepartmentName])))>(0)))
GO
ALTER TABLE [Organization].[Departments] CHECK CONSTRAINT [CHK_DepartmentName_NotEmpty]
GO
ALTER TABLE [Organization].[Employees]  WITH CHECK ADD  CONSTRAINT [CH_BASICSAL] CHECK  (([BasicSalary]>(0)))
GO
ALTER TABLE [Organization].[Employees] CHECK CONSTRAINT [CH_BASICSAL]
GO
ALTER TABLE [Organization].[Employees]  WITH CHECK ADD  CONSTRAINT [CH_Emp_AgeHir] CHECK  (([HireDate]>=dateadd(year,(18),[BirthDate])))
GO
ALTER TABLE [Organization].[Employees] CHECK CONSTRAINT [CH_Emp_AgeHir]
GO
ALTER TABLE [Organization].[Employees]  WITH CHECK ADD  CONSTRAINT [CH_GENDER] CHECK  (([Gender]='F' OR [Gender]='M'))
GO
ALTER TABLE [Organization].[Employees] CHECK CONSTRAINT [CH_GENDER]
GO
ALTER TABLE [Organization].[Employees]  WITH CHECK ADD  CONSTRAINT [CH_LASTMOTIME] CHECK  (([LastModificationTime]>=[CreationTime]))
GO
ALTER TABLE [Organization].[Employees] CHECK CONSTRAINT [CH_LASTMOTIME]
GO
ALTER TABLE [Organization].[Employees]  WITH CHECK ADD  CONSTRAINT [CH_STATUS] CHECK  (([EmploymentStatus]='Terminated' OR [EmploymentStatus]='Suspended' OR [EmploymentStatus]='Active'))
GO
ALTER TABLE [Organization].[Employees] CHECK CONSTRAINT [CH_STATUS]
GO
ALTER TABLE [Organization].[Employees]  WITH CHECK ADD  CONSTRAINT [CH_TERMINADATE] CHECK  (([TerminationDate] IS NULL OR [TerminationDate]>=[HireDate]))
GO
ALTER TABLE [Organization].[Employees] CHECK CONSTRAINT [CH_TERMINADATE]
GO
ALTER TABLE [Organization].[JobTitles]  WITH CHECK ADD  CONSTRAINT [CH_MAX] CHECK  (([MAXimumSalary]>=[MinimumSalary]))
GO
ALTER TABLE [Organization].[JobTitles] CHECK CONSTRAINT [CH_MAX]
GO
ALTER TABLE [Organization].[JobTitles]  WITH CHECK ADD  CONSTRAINT [CH_MINI] CHECK  (([MinimumSalary]>(0)))
GO
ALTER TABLE [Organization].[JobTitles] CHECK CONSTRAINT [CH_MINI]
GO
ALTER TABLE [Payroll].[EmployeeSalaries]  WITH CHECK ADD  CONSTRAINT [CH_BasicSalary] CHECK  (([BasicSalary]>(0.00)))
GO
ALTER TABLE [Payroll].[EmployeeSalaries] CHECK CONSTRAINT [CH_BasicSalary]
GO
ALTER TABLE [Payroll].[EmployeeSalaries]  WITH CHECK ADD  CONSTRAINT [CH_EffectiveFrom_EffectiveTo] CHECK  (([EffectiveTo]>[EffectiveFrom]))
GO
ALTER TABLE [Payroll].[EmployeeSalaries] CHECK CONSTRAINT [CH_EffectiveFrom_EffectiveTo]
GO
ALTER TABLE [Payroll].[EmployeeSalaries]  WITH CHECK ADD  CONSTRAINT [CH_HousingAllowance] CHECK  (([HousingAllowance]>(0.00)))
GO
ALTER TABLE [Payroll].[EmployeeSalaries] CHECK CONSTRAINT [CH_HousingAllowance]
GO
ALTER TABLE [Payroll].[EmployeeSalaries]  WITH CHECK ADD  CONSTRAINT [CH_OtherAllowance] CHECK  (([OtherAllowance]>(0.00)))
GO
ALTER TABLE [Payroll].[EmployeeSalaries] CHECK CONSTRAINT [CH_OtherAllowance]
GO
ALTER TABLE [Payroll].[EmployeeSalaries]  WITH CHECK ADD  CONSTRAINT [CH_TransportationAllowance] CHECK  (([TransportationAllowance]>(0.00)))
GO
ALTER TABLE [Payroll].[EmployeeSalaries] CHECK CONSTRAINT [CH_TransportationAllowance]
GO
ALTER TABLE [Payroll].[MonthlyPayrolls]  WITH CHECK ADD  CONSTRAINT [CHK_MonthlyPayrolls_BasicSalary] CHECK  (([BasicSalary]>=(0)))
GO
ALTER TABLE [Payroll].[MonthlyPayrolls] CHECK CONSTRAINT [CHK_MonthlyPayrolls_BasicSalary]
GO
ALTER TABLE [Payroll].[MonthlyPayrolls]  WITH CHECK ADD  CONSTRAINT [CHK_MonthlyPayrolls_DeductionAmount] CHECK  (([DeductionAmount]>=(0)))
GO
ALTER TABLE [Payroll].[MonthlyPayrolls] CHECK CONSTRAINT [CHK_MonthlyPayrolls_DeductionAmount]
GO
ALTER TABLE [Payroll].[MonthlyPayrolls]  WITH CHECK ADD  CONSTRAINT [CHK_MonthlyPayrolls_OvertimeAmount] CHECK  (([OvertimeAmount]>=(0)))
GO
ALTER TABLE [Payroll].[MonthlyPayrolls] CHECK CONSTRAINT [CHK_MonthlyPayrolls_OvertimeAmount]
GO
ALTER TABLE [Payroll].[MonthlyPayrolls]  WITH CHECK ADD  CONSTRAINT [CHK_MonthlyPayrolls_PayrollMonth] CHECK  (([PayrollMonth]>=(1) AND [PayrollMonth]<=(12)))
GO
ALTER TABLE [Payroll].[MonthlyPayrolls] CHECK CONSTRAINT [CHK_MonthlyPayrolls_PayrollMonth]
GO
ALTER TABLE [Payroll].[MonthlyPayrolls]  WITH CHECK ADD  CONSTRAINT [CHK_MonthlyPayrolls_PayrollYear] CHECK  (([PayrollYear]>=(2000)))
GO
ALTER TABLE [Payroll].[MonthlyPayrolls] CHECK CONSTRAINT [CHK_MonthlyPayrolls_PayrollYear]
GO
ALTER TABLE [Payroll].[MonthlyPayrolls]  WITH CHECK ADD  CONSTRAINT [CHK_MonthlyPayrolls_Status] CHECK  (([PayrollStatus]='Cancelled' OR [PayrollStatus]='Paid' OR [PayrollStatus]='Processed' OR [PayrollStatus]='Draft'))
GO
ALTER TABLE [Payroll].[MonthlyPayrolls] CHECK CONSTRAINT [CHK_MonthlyPayrolls_Status]
GO
ALTER TABLE [Payroll].[MonthlyPayrolls]  WITH CHECK ADD  CONSTRAINT [CHK_MonthlyPayrolls_TotalAllowances] CHECK  (([TotalAllowances]>=(0)))
GO
ALTER TABLE [Payroll].[MonthlyPayrolls] CHECK CONSTRAINT [CHK_MonthlyPayrolls_TotalAllowances]
GO
