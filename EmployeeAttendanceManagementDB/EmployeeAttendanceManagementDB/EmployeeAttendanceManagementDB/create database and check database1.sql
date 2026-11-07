go
if not EXISTS( select name from sysdatabases where name='EmployeeAttendanceManagementDB')
begin
create database EmployeeAttendanceManagementDB
end;
