-- =============================================
-- Author:		
-- Create date: 
-- Updates: 
-- 	2020-12-04: Initial script (YC)
-- Description:	DML to set initial lookup values.
-- =============================================


USE CRT_DEV; -- uncomment appropriate instance
--USE CRT_TST;
--USE CRT_UAT;
--USE CRT_PRD;
GO

CREATE SEQUENCE CRT_CODE_LKUP_ID_SEQ START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999 CACHE 50 
GO

CREATE TABLE CRT_CODE_LOOKUP
(
    CODE_LOOKUP_ID NUMERIC (9) NOT NULL DEFAULT NEXT VALUE FOR CRT_CODE_LKUP_ID_SEQ ,
    CODE_SET VARCHAR (20) ,
    CODE_NAME VARCHAR (20) ,
    CODE_VALUE_TEXT VARCHAR (20) ,
    CODE_VALUE_NUM NUMERIC (9) ,
    CODE_VALUE_FORMAT VARCHAR (12) ,
    DISPLAY_ORDER NUMERIC (3) ,
    END_DATE DATETIME ,
    CONCURRENCY_CONTROL_NUMBER BIGINT NOT NULL DEFAULT 1 ,
    DB_AUDIT_CREATE_USERID VARCHAR (30) NOT NULL DEFAULT user_name() ,
    DB_AUDIT_CREATE_TIMESTAMP DATETIME NOT NULL DEFAULT getutcdate() ,
    DB_AUDIT_LAST_UPDATE_USERID VARCHAR (30) NOT NULL DEFAULT user_name() ,
    DB_AUDIT_LAST_UPDATE_TIMESTAMP DATETIME NOT NULL DEFAULT getutcdate()
)
GO



EXEC sp_addextendedproperty 'MS_Description' , 'A range of lookup values used to decipher codes used in submissions to business legible values for reporting purposes.  As many code lookups share this table, views are available to join for reporting purposes.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_CODE_LOOKUP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique identifier for a record.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_CODE_LOOKUP' , 'COLUMN' , 'CODE_LOOKUP_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique identifier for a group of lookup codes.  A database view is available for each group for use in analytics.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_CODE_LOOKUP' , 'COLUMN' , 'CODE_SET' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Display name or business name for a submission value.  These values are for display in analytical reporting.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_CODE_LOOKUP' , 'COLUMN' , 'CODE_NAME' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Look up code values provided in submissions.   These values are used for validating submissions and for display of CODE NAMES in analytical reporting.  Values must be unique per CODE SET.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_CODE_LOOKUP' , 'COLUMN' , 'CODE_VALUE_TEXT' 
GO



EXEC sp_addextendedproperty 'MS_Description' , ' Numeric enumeration values provided in submissions.   These values are used for validating submissions and for display of CODE NAMES in analytical reporting.  Values must be unique per CODE SET.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_CODE_LOOKUP' , 'COLUMN' , 'CODE_VALUE_NUM' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Specifies if the code value is text or numeric.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_CODE_LOOKUP' , 'COLUMN' , 'CODE_VALUE_FORMAT' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'When displaying list of values, value can be used to present list in desired order.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_CODE_LOOKUP' , 'COLUMN' , 'DISPLAY_ORDER' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'The latest date submissions will be accepted.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_CODE_LOOKUP' , 'COLUMN' , 'END_DATE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_CODE_LOOKUP' , 'COLUMN' , 'CONCURRENCY_CONTROL_NUMBER' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Named database user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_CODE_LOOKUP' , 'COLUMN' , 'DB_AUDIT_CREATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time record created in the database' , 'USER' , 'dbo' , 'TABLE' , 'CRT_CODE_LOOKUP' , 'COLUMN' , 'DB_AUDIT_CREATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Named database user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_CODE_LOOKUP' , 'COLUMN' , 'DB_AUDIT_LAST_UPDATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time record was last updated in the database.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_CODE_LOOKUP' , 'COLUMN' , 'DB_AUDIT_LAST_UPDATE_TIMESTAMP'

GO

ALTER TABLE CRT_CODE_LOOKUP ADD CONSTRAINT CRT_CODE_LKUP_PK PRIMARY KEY CLUSTERED (CODE_LOOKUP_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO
ALTER TABLE CRT_CODE_LOOKUP ADD CONSTRAINT CRT_CODE_LKUP_VAL_TXT_UC UNIQUE NONCLUSTERED (CODE_SET, CODE_VALUE_TEXT, CODE_NAME)
GO
ALTER TABLE CRT_CODE_LOOKUP ADD CONSTRAINT CRT_CODE_LKUP_VAL_NUM_UC UNIQUE NONCLUSTERED (CODE_SET, CODE_VALUE_NUM, CODE_NAME)
GO


CREATE SEQUENCE CRT_PERM_ID_SEQ START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999 CACHE 50 
GO


CREATE TABLE CRT_PERMISSION
(
    PERMISSION_ID NUMERIC (9) NOT NULL DEFAULT NEXT VALUE FOR CRT_PERM_ID_SEQ ,
    NAME VARCHAR (30) NOT NULL ,
    DESCRIPTION VARCHAR (150) ,
    END_DATE DATE ,
    CONCURRENCY_CONTROL_NUMBER BIGINT NOT NULL DEFAULT 1 ,
    APP_CREATE_USERID VARCHAR (30) NOT NULL ,
    APP_CREATE_TIMESTAMP DATETIME NOT NULL ,
    APP_CREATE_USER_GUID UNIQUEIDENTIFIER NOT NULL ,
    APP_CREATE_USER_DIRECTORY VARCHAR (12) NOT NULL ,
    APP_LAST_UPDATE_USERID VARCHAR (30) NOT NULL ,
    APP_LAST_UPDATE_TIMESTAMP DATETIME NOT NULL ,
    APP_LAST_UPDATE_USER_GUID UNIQUEIDENTIFIER NOT NULL ,
    APP_LAST_UPDATE_USER_DIRECTORY VARCHAR (12) NOT NULL ,
    DB_AUDIT_CREATE_USERID VARCHAR (30) NOT NULL DEFAULT user_name() ,
    DB_AUDIT_CREATE_TIMESTAMP DATETIME NOT NULL DEFAULT getutcdate() ,
    DB_AUDIT_LAST_UPDATE_USERID VARCHAR (30) NOT NULL DEFAULT user_name() ,
    DB_AUDIT_LAST_UPDATE_TIMESTAMP DATETIME NOT NULL DEFAULT getutcdate()
)
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Permission definition table for assignment to individual system users.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique identifier for a record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'PERMISSION_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Business name for a permission' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'NAME' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Description of a permission.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'DESCRIPTION' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date permission was deactivated' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'END_DATE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'CONCURRENCY_CONTROL_NUMBER' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'APP_CREATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time of record creation' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'APP_CREATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'APP_CREATE_USER_GUID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Active Directory which retains source of truth for user idenifiers.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'APP_CREATE_USER_DIRECTORY' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'APP_LAST_UPDATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time of last record update' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'APP_LAST_UPDATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'APP_LAST_UPDATE_USER_GUID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Active Directory which retains source of truth for user idenifiers.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'APP_LAST_UPDATE_USER_DIRECTORY' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Named database user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'DB_AUDIT_CREATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time record created in the database' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'DB_AUDIT_CREATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Named database user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'DB_AUDIT_LAST_UPDATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time record was last updated in the database.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_PERMISSION' , 'COLUMN' , 'DB_AUDIT_LAST_UPDATE_TIMESTAMP'

GO

ALTER TABLE CRT_PERMISSION ADD CONSTRAINT CRT_PERMISSION_PK PRIMARY KEY CLUSTERED (PERMISSION_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )

GO

CREATE SEQUENCE CRT_RL_ID_SEQ START WITH 1 INCREMENT BY 1 MINVALUE 1 MAXVALUE 999999999 CACHE 50 
GO



CREATE TABLE CRT_ROLE
(
    ROLE_ID NUMERIC (9) NOT NULL DEFAULT NEXT VALUE FOR CRT_RL_ID_SEQ ,
    NAME VARCHAR (30) NOT NULL ,
    DESCRIPTION VARCHAR (150) ,
    END_DATE DATE ,
    CONCURRENCY_CONTROL_NUMBER BIGINT NOT NULL DEFAULT 1 ,
    APP_CREATE_USERID VARCHAR (30) NOT NULL ,
    APP_CREATE_TIMESTAMP DATETIME NOT NULL ,
    APP_CREATE_USER_GUID UNIQUEIDENTIFIER NOT NULL ,
    APP_CREATE_USER_DIRECTORY VARCHAR (12) NOT NULL ,
    APP_LAST_UPDATE_USERID VARCHAR (30) NOT NULL ,
    APP_LAST_UPDATE_TIMESTAMP DATETIME NOT NULL ,
    APP_LAST_UPDATE_USER_GUID UNIQUEIDENTIFIER NOT NULL ,
    APP_LAST_UPDATE_USER_DIRECTORY VARCHAR (12) NOT NULL ,
    DB_AUDIT_CREATE_USERID VARCHAR (30) NOT NULL DEFAULT user_name() ,
    DB_AUDIT_CREATE_TIMESTAMP DATETIME NOT NULL DEFAULT getutcdate() ,
    DB_AUDIT_LAST_UPDATE_USERID VARCHAR (30) NOT NULL DEFAULT user_name() ,
    DB_AUDIT_LAST_UPDATE_TIMESTAMP DATETIME NOT NULL DEFAULT getutcdate()
)
GO


EXEC sp_addextendedproperty 'MS_Description' , 'Role description table for groups of permissions.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique identifier for a record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'ROLE_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Business name for a permission' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'NAME' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Description of a permission.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'DESCRIPTION' 
GO




EXEC sp_addextendedproperty 'MS_Description' , 'Date permission was deactivated' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'END_DATE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'CONCURRENCY_CONTROL_NUMBER' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'APP_CREATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time of record creation' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'APP_CREATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'APP_CREATE_USER_GUID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Active Directory which retains source of truth for user idenifiers.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'APP_CREATE_USER_DIRECTORY' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'APP_LAST_UPDATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time of last record update' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'APP_LAST_UPDATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'APP_LAST_UPDATE_USER_GUID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Active Directory which retains source of truth for user idenifiers.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'APP_LAST_UPDATE_USER_DIRECTORY' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Named database user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'DB_AUDIT_CREATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time record created in the database' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'DB_AUDIT_CREATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Named database user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'DB_AUDIT_LAST_UPDATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time record was last updated in the database.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE' , 'COLUMN' , 'DB_AUDIT_LAST_UPDATE_TIMESTAMP'

GO

ALTER TABLE CRT_ROLE ADD CONSTRAINT CRT_ROLE_PK PRIMARY KEY CLUSTERED (ROLE_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )

GO

CREATE SEQUENCE CRT_RL_PERM_ID_SEQ 
START WITH 1 
    INCREMENT BY 1 
    MINVALUE 1 
    MAXVALUE 999999999 
    CACHE 50 
GO



CREATE TABLE CRT_ROLE_PERMISSION
(
    ROLE_PERMISSION_ID NUMERIC (9) NOT NULL DEFAULT NEXT VALUE FOR CRT_RL_PERM_ID_SEQ ,
    ROLE_ID NUMERIC (9) NOT NULL ,
    PERMISSION_ID NUMERIC (9) NOT NULL ,
    END_DATE DATE ,
    CONCURRENCY_CONTROL_NUMBER BIGINT NOT NULL DEFAULT 1 ,
    APP_CREATE_USERID VARCHAR (30) NOT NULL ,
    APP_CREATE_TIMESTAMP DATETIME NOT NULL ,
    APP_CREATE_USER_GUID UNIQUEIDENTIFIER NOT NULL ,
    APP_CREATE_USER_DIRECTORY VARCHAR (12) NOT NULL ,
    APP_LAST_UPDATE_USERID VARCHAR (30) NOT NULL ,
    APP_LAST_UPDATE_TIMESTAMP DATETIME NOT NULL ,
    APP_LAST_UPDATE_USER_GUID UNIQUEIDENTIFIER NOT NULL ,
    APP_LAST_UPDATE_USER_DIRECTORY VARCHAR (12) NOT NULL ,
    DB_AUDIT_CREATE_USERID VARCHAR (30) NOT NULL DEFAULT user_name() ,
    DB_AUDIT_CREATE_TIMESTAMP DATETIME NOT NULL DEFAULT getutcdate() ,
    DB_AUDIT_LAST_UPDATE_USERID VARCHAR (30) NOT NULL DEFAULT user_name() ,
    DB_AUDIT_LAST_UPDATE_TIMESTAMP DATETIME NOT NULL DEFAULT getutcdate()
)
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Role to Permission associative table for assignment of permissions to parent roles.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique identifier for a record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'ROLE_PERMISSION_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier for related role' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'ROLE_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier for related permission' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'PERMISSION_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date record was deactivated' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'END_DATE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'CONCURRENCY_CONTROL_NUMBER' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'APP_CREATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time of record creation' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'APP_CREATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'APP_CREATE_USER_GUID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Active Directory which retains source of truth for user idenifiers.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'APP_CREATE_USER_DIRECTORY' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'APP_LAST_UPDATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time of last record update' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'APP_LAST_UPDATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'APP_LAST_UPDATE_USER_GUID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Active Directory which retains source of truth for user idenifiers.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'APP_LAST_UPDATE_USER_DIRECTORY' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Named database user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'DB_AUDIT_CREATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time record created in the database' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'DB_AUDIT_CREATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Named database user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'DB_AUDIT_LAST_UPDATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time record was last updated in the database.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_ROLE_PERMISSION' , 'COLUMN' , 'DB_AUDIT_LAST_UPDATE_TIMESTAMP' 
GO




CREATE NONCLUSTERED INDEX 
    CRT_RL_PERM_PERM_FK_I ON CRT_ROLE_PERMISSION 
    ( 
     PERMISSION_ID 
    ) 
GO


CREATE NONCLUSTERED INDEX 
    CRT_RL_PERM_RL_FK_I ON CRT_ROLE_PERMISSION 
    ( 
     ROLE_ID 
    ) 
GO

ALTER TABLE CRT_ROLE_PERMISSION ADD CONSTRAINT CRT_RL_PERM_PK PRIMARY KEY CLUSTERED (ROLE_PERMISSION_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO
ALTER TABLE CRT_ROLE_PERMISSION ADD CONSTRAINT CRT_RL_PERM_UN_CH UNIQUE NONCLUSTERED (ROLE_ID, PERMISSION_ID, END_DATE)
GO

CREATE SEQUENCE SYS_USR_ID_SEQ 
START WITH 1 
    INCREMENT BY 1 
    MINVALUE 1 
    MAXVALUE 999999999 
    CACHE 50 
GO

CREATE TABLE CRT_SYSTEM_USER
(
    SYSTEM_USER_ID NUMERIC (9) NOT NULL DEFAULT NEXT VALUE FOR SYS_USR_ID_SEQ ,
    API_CLIENT_ID varchar(40) NULL,
    USER_GUID UNIQUEIDENTIFIER ,
    USERNAME VARCHAR (32) NOT NULL ,
    FIRST_NAME VARCHAR (150) ,
    LAST_NAME VARCHAR (150) ,
    EMAIL VARCHAR (100) ,
    END_DATE DATETIME ,
    CONCURRENCY_CONTROL_NUMBER BIGINT NOT NULL DEFAULT 1 ,
    APP_CREATE_USERID VARCHAR (30) NOT NULL ,
    APP_CREATE_TIMESTAMP DATETIME NOT NULL ,
    APP_CREATE_USER_GUID UNIQUEIDENTIFIER NOT NULL ,
    APP_CREATE_USER_DIRECTORY VARCHAR (12) NOT NULL ,
    APP_LAST_UPDATE_USERID VARCHAR (30) NOT NULL ,
    APP_LAST_UPDATE_TIMESTAMP DATETIME NOT NULL ,
    APP_LAST_UPDATE_USER_GUID UNIQUEIDENTIFIER NOT NULL ,
    APP_LAST_UPDATE_USER_DIRECTORY VARCHAR (12) NOT NULL ,
    DB_AUDIT_CREATE_USERID VARCHAR (30) NOT NULL DEFAULT user_name() ,
    DB_AUDIT_CREATE_TIMESTAMP DATETIME NOT NULL DEFAULT getutcdate() ,
    DB_AUDIT_LAST_UPDATE_USERID VARCHAR (30) NOT NULL DEFAULT user_name() ,
    DB_AUDIT_LAST_UPDATE_TIMESTAMP DATETIME NOT NULL DEFAULT getutcdate()
)
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Defines users and their attributes as found in IDIR.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'A system generated unique identifier.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'SYSTEM_USER_ID' 
GO





EXEC sp_addextendedproperty 'MS_Description' , 'A system generated unique identifier.  Reflects the active directory unique idenifier for the user.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'USER_GUID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'IDIR Active Directory defined universal identifier (SM_UNIVERSALID or userID) attributed to a user.  This value can change over time, while USER_GUID will remain consistant.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'USERNAME' 
GO






EXEC sp_addextendedproperty 'MS_Description' , 'Last Name of the user' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'LAST_NAME' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Contact email address within Active Directory (Email = SMGOV_EMAIL)' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'EMAIL' 
GO





EXEC sp_addextendedproperty 'MS_Description' , 'Date a user can no longer access the system or invoke data submissions.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'END_DATE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'CONCURRENCY_CONTROL_NUMBER' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'APP_CREATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time of record creation' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'APP_CREATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'APP_CREATE_USER_GUID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Active Directory which retains source of truth for user idenifiers.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'APP_CREATE_USER_DIRECTORY' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'APP_LAST_UPDATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time of last record update' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'APP_LAST_UPDATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'APP_LAST_UPDATE_USER_GUID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Active Directory which retains source of truth for user idenifiers.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'APP_LAST_UPDATE_USER_DIRECTORY' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Named database user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'DB_AUDIT_CREATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time record created in the database' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'DB_AUDIT_CREATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Named database user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'DB_AUDIT_LAST_UPDATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time record was last updated in the database.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_SYSTEM_USER' , 'COLUMN' , 'DB_AUDIT_LAST_UPDATE_TIMESTAMP' 
GO





ALTER TABLE CRT_SYSTEM_USER ADD CONSTRAINT CRT_SYSTEM_USER_PK PRIMARY KEY CLUSTERED (SYSTEM_USER_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )

GO

CREATE SEQUENCE CRT_USR_RL_ID_SEQ 
START WITH 1 
    INCREMENT BY 1 
    MINVALUE 1 
    MAXVALUE 999999999 
    CACHE 50 
GO



CREATE TABLE CRT_USER_ROLE
(
    USER_ROLE_ID NUMERIC (9) NOT NULL DEFAULT NEXT VALUE FOR CRT_USR_RL_ID_SEQ ,
    ROLE_ID NUMERIC (9) NOT NULL ,
    SYSTEM_USER_ID NUMERIC (9) NOT NULL ,
    END_DATE DATETIME ,
    CONCURRENCY_CONTROL_NUMBER BIGINT NOT NULL DEFAULT 1 ,
    APP_CREATE_USERID VARCHAR (30) NOT NULL ,
    APP_CREATE_TIMESTAMP DATETIME NOT NULL ,
    APP_CREATE_USER_GUID UNIQUEIDENTIFIER NOT NULL ,
    APP_CREATE_USER_DIRECTORY VARCHAR (12) NOT NULL ,
    APP_LAST_UPDATE_USERID VARCHAR (30) NOT NULL ,
    APP_LAST_UPDATE_TIMESTAMP DATETIME NOT NULL ,
    APP_LAST_UPDATE_USER_GUID UNIQUEIDENTIFIER NOT NULL ,
    APP_LAST_UPDATE_USER_DIRECTORY VARCHAR (12) NOT NULL ,
    DB_AUDIT_CREATE_USERID VARCHAR (30) NOT NULL DEFAULT user_name() ,
    DB_AUDIT_CREATE_TIMESTAMP DATETIME NOT NULL DEFAULT getutcdate() ,
    DB_AUDIT_LAST_UPDATE_USERID VARCHAR (30) NOT NULL DEFAULT user_name() ,
    DB_AUDIT_LAST_UPDATE_TIMESTAMP DATETIME NOT NULL DEFAULT getutcdate()
)
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Associative table for assignment of roles to individual system users.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique identifier for a record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'USER_ROLE_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique identifier for related ROLE' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'ROLE_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique identifier for related SYSTEM USER' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'SYSTEM_USER_ID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date a user is no longer assigned the role.  The APP_CREATED_TIMESTAMP and the END_DATE can be used to determine which roles were assigned to a user at a given point in time.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'END_DATE' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'CONCURRENCY_CONTROL_NUMBER' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'APP_CREATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time of record creation' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'APP_CREATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'APP_CREATE_USER_GUID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Active Directory which retains source of truth for user idenifiers.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'APP_CREATE_USER_DIRECTORY' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'APP_LAST_UPDATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time of last record update' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'APP_LAST_UPDATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Unique idenifier of user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'APP_LAST_UPDATE_USER_GUID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Active Directory which retains source of truth for user idenifiers.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'APP_LAST_UPDATE_USER_DIRECTORY' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Named database user who created record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'DB_AUDIT_CREATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time record created in the database' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'DB_AUDIT_CREATE_TIMESTAMP' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Named database user who last updated record' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'DB_AUDIT_LAST_UPDATE_USERID' 
GO



EXEC sp_addextendedproperty 'MS_Description' , 'Date and time record was last updated in the database.' , 'USER' , 'dbo' , 'TABLE' , 'CRT_USER_ROLE' , 'COLUMN' , 'DB_AUDIT_LAST_UPDATE_TIMESTAMP' 
GO




CREATE NONCLUSTERED INDEX 
    CRT_USR_RL_RL_FK_I ON CRT_USER_ROLE 
    ( 
     ROLE_ID 
    ) 
GO


CREATE NONCLUSTERED INDEX 
    CRT_USR_RL_USR_FK_I ON CRT_USER_ROLE 
    ( 
     SYSTEM_USER_ID 
    ) 
GO

ALTER TABLE CRT_USER_ROLE ADD CONSTRAINT CRT_USR_RL_PK PRIMARY KEY CLUSTERED (USER_ROLE_ID)
     WITH (
     ALLOW_PAGE_LOCKS = ON , 
     ALLOW_ROW_LOCKS = ON )
GO
ALTER TABLE CRT_USER_ROLE ADD CONSTRAINT CRT_USR_RL_UQ_CH UNIQUE NONCLUSTERED (END_DATE, SYSTEM_USER_ID, ROLE_ID)
GO


ALTER TABLE CRT_ROLE_PERMISSION
    ADD CONSTRAINT CRT_RL_PERM_PERM_FK FOREIGN KEY ( PERMISSION_ID )
        REFERENCES CRT_PERMISSION ( PERMISSION_ID )
ON DELETE NO ACTION 
    ON UPDATE NO ACTION

GO

ALTER TABLE CRT_ROLE_PERMISSION
    ADD CONSTRAINT CRT_RL_PERM_RL_FK FOREIGN KEY ( ROLE_ID )
        REFERENCES CRT_ROLE ( ROLE_ID )
ON DELETE NO ACTION 
    ON UPDATE NO ACTION

GO



ALTER TABLE CRT_USER_ROLE
    ADD CONSTRAINT CRT_USR_RL_RL_FK FOREIGN KEY ( ROLE_ID )
        REFERENCES CRT_ROLE ( ROLE_ID )
ON DELETE NO ACTION 
    ON UPDATE NO ACTION

GO

ALTER TABLE CRT_USER_ROLE
    ADD CONSTRAINT CRT_USR_RL_SYS_USR_FK FOREIGN KEY ( SYSTEM_USER_ID )
        REFERENCES CRT_SYSTEM_USER ( SYSTEM_USER_ID )
ON DELETE NO ACTION 
    ON UPDATE NO ACTION

GO

