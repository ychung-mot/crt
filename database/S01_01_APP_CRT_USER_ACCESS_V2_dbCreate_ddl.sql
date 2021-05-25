/* ---------------------------------------------------------------------- */
/* Script generated with: DeZign for Databases 12.1.0                     */
/* Target DBMS:           MS SQL Server 2017                              */
/* Project file:          1_APP_CRT_USER_ACCESS_S1_V2.dez                 */
/* Project name:          Capital Rehabilitation Tracking Reporting       */
/* Author:                Ayodeji Kuponiyi                                */
/* Script type:           Database creation script                        */
/* Created on:            2021-01-14 03:03                                */
/* ---------------------------------------------------------------------- */

USE [CRT_DEV];
GO


/* ---------------------------------------------------------------------- */
/* Add sequences                                                          */
/* ---------------------------------------------------------------------- */

CREATE SEQUENCE [dbo].[CRT_DIST_ID_SEQ]
  AS bigint 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_PERMISSION_H_ID_SEQ]
  AS bigint 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  2147483647 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_ROLE_H_ID_SEQ]
  AS bigint 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  2147483647 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_ROLE_PERMISSION_H_ID_SEQ]
  AS bigint 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  2147483647 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[SYS_USR_ID_SEQ]
  AS bigint 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_USR_RL_ID_SEQ]
  AS bigint 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_PERM_ID_SEQ]
  AS bigint 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_REG_ID_SEQ]
  AS bigint 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_SYSTEM_USER_H_ID_SEQ]
  AS bigint 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  2147483647 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_USER_ROLE_H_ID_SEQ]
  AS bigint 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  2147483647 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_RL_ID_SEQ]
  AS bigint 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_RL_PERM_ID_SEQ]
  AS bigint 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_REGION_USR_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_SRV_ARA_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  9999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_REGION_USER_H_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  999999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_REG_DIST_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  9999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_REG_DIST_H_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  9999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_CODE_LKUP_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_CODE_LOOKUP_H_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  9999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_SERVICE_AREA_H_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  9999999999 
  NO CYCLE
  CACHE 50
GO


/* ---------------------------------------------------------------------- */
/* Add tables                                                             */
/* ---------------------------------------------------------------------- */

/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_PERMISSION"                                         */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_PERMISSION]
(
  [PERMISSION_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_PERM_ID_SEQ] NOT NULL,
  [NAME] VARCHAR(30) NOT NULL,
  [DESCRIPTION] VARCHAR(150),
  [END_DATE] DATE,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT DEFAULT 1 NOT NULL,
  [APP_CREATE_USERID] VARCHAR(30) NOT NULL,
  [APP_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_CREATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [APP_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [APP_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_LAST_UPDATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  CONSTRAINT [CRT_PERMISSION_PK] PRIMARY KEY CLUSTERED ([PERMISSION_ID])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Permission definition table for assignment to individual system users.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for a record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', 'COLUMN', N'PERMISSION_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Business name for a permission', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', 'COLUMN', N'NAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Description of a permission.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', 'COLUMN', N'DESCRIPTION'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date permission was deactivated', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_ROLE"                                               */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_ROLE]
(
  [ROLE_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_RL_ID_SEQ] NOT NULL,
  [NAME] VARCHAR(30) NOT NULL,
  [DESCRIPTION] VARCHAR(150),
  [END_DATE] DATE,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT DEFAULT 1 NOT NULL,
  [APP_CREATE_USERID] VARCHAR(30) NOT NULL,
  [APP_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_CREATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [APP_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [APP_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_LAST_UPDATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  CONSTRAINT [CRT_ROLE_PK] PRIMARY KEY CLUSTERED ([ROLE_ID])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Role description table for groups of permissions.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for a record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', 'COLUMN', N'ROLE_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Business name for a permission', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', 'COLUMN', N'NAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Description of a permission.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', 'COLUMN', N'DESCRIPTION'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date permission was deactivated', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_SYSTEM_USER"                                        */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_SYSTEM_USER]
(
  [SYSTEM_USER_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [SYS_USR_ID_SEQ] NOT NULL,
  [API_CLIENT_ID] VARCHAR(40),
  [USER_GUID] UNIQUEIDENTIFIER,
  [USERNAME] VARCHAR(32) NOT NULL,
  [FIRST_NAME] VARCHAR(150),
  [LAST_NAME] VARCHAR(150),
  [EMAIL] VARCHAR(100),
  [END_DATE] DATETIME,
  [IS_PROJECT_MGR] BIT,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT DEFAULT 1 NOT NULL,
  [APP_CREATE_USERID] VARCHAR(30) NOT NULL,
  [APP_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_CREATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [APP_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [APP_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_LAST_UPDATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  CONSTRAINT [CRT_SYSTEM_USER_PK] PRIMARY KEY CLUSTERED ([SYSTEM_USER_ID])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines users and their attributes as found in IDIR', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'SYSTEM_USER_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'This ID is used to track Keycloak client ID created for the users', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'API_CLIENT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.  Reflects the active directory unique idenifier for the user.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'IDIR or BCeID Active Directory defined universal identifier (SM_UNIVERSALID or userID) attributed to a user.  This value can change over time, while USER_GUID will remain consistant.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'USERNAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'First Name of the user', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'FIRST_NAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Last Name of the user', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'LAST_NAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Contact email address within Active Directory (Email = SMGOV_EMAIL)', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'EMAIL'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date a user can no longer access the system or invoke data submissions.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Identifies whether or not an individual is a project manager', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'IS_PROJECT_MGR'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_USER_ROLE"                                          */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_USER_ROLE]
(
  [USER_ROLE_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_USR_RL_ID_SEQ] NOT NULL,
  [ROLE_ID] NUMERIC(9) NOT NULL,
  [SYSTEM_USER_ID] NUMERIC(9) NOT NULL,
  [END_DATE] DATETIME,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT DEFAULT 1 NOT NULL,
  [APP_CREATE_USERID] VARCHAR(30) NOT NULL,
  [APP_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_CREATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [APP_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [APP_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_LAST_UPDATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  CONSTRAINT [CRT_USR_RL_PK] PRIMARY KEY CLUSTERED ([USER_ROLE_ID]),
  CONSTRAINT [CRT_USR_RL_UQ_CH] UNIQUE ([END_DATE], [SYSTEM_USER_ID], [ROLE_ID])
)
GO


CREATE NONCLUSTERED INDEX [CRT_USR_RL_RL_FK_I] ON [dbo].[CRT_USER_ROLE] ([ROLE_ID] ASC)
GO


CREATE NONCLUSTERED INDEX [CRT_USR_RL_USR_FK_I] ON [dbo].[CRT_USER_ROLE] ([SYSTEM_USER_ID] ASC)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Associative table for assignment of roles to individual system users.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for a record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', 'COLUMN', N'USER_ROLE_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for related ROLE', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', 'COLUMN', N'ROLE_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for related SYSTEM USER', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', 'COLUMN', N'SYSTEM_USER_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date a user is no longer assigned the role.  The APP_CREATED_TIMESTAMP and the END_DATE can be used to determine which roles were assigned to a user at a given point in time.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_REGION"                                             */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_REGION]
(
  [REGION_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_REG_ID_SEQ] NOT NULL,
  [REGION_NUMBER] NUMERIC(2) NOT NULL,
  [REGION_NAME] VARCHAR(40) NOT NULL,
  [END_DATE] DATE,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT DEFAULT 1 NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  CONSTRAINT [CRT_REGION_PK] PRIMARY KEY CLUSTERED ([REGION_ID]),
  CONSTRAINT [CRT_REG_NO_NAME_UK] UNIQUE ([REGION_NUMBER], [REGION_NAME], [END_DATE])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Ministry Region lookup values', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for Ministry region', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION', 'COLUMN', N'REGION_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Number assigned to the Ministry region', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION', 'COLUMN', N'REGION_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Name of the Ministry region', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION', 'COLUMN', N'REGION_NAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the entity ends or changes', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_DISTRICT"                                           */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_DISTRICT]
(
  [DISTRICT_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_DIST_ID_SEQ] NOT NULL,
  [DISTRICT_NUMBER] NUMERIC(2) NOT NULL,
  [DISTRICT_NAME] VARCHAR(40) NOT NULL,
  [END_DATE] DATE,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT DEFAULT 1 NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  CONSTRAINT [CRT_DISTRICT_PK] PRIMARY KEY CLUSTERED ([DISTRICT_ID]),
  CONSTRAINT [CRT_DIST_NO_NAME_UK] UNIQUE ([DISTRICT_NUMBER], [DISTRICT_NAME], [END_DATE])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Ministry Districts lookup values.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_DISTRICT', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for district records', 'SCHEMA', N'dbo', 'TABLE', N'CRT_DISTRICT', 'COLUMN', N'DISTRICT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Number assigned to represent the District', 'SCHEMA', N'dbo', 'TABLE', N'CRT_DISTRICT', 'COLUMN', N'DISTRICT_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'The name of the District', 'SCHEMA', N'dbo', 'TABLE', N'CRT_DISTRICT', 'COLUMN', N'DISTRICT_NAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the entity ends or changes', 'SCHEMA', N'dbo', 'TABLE', N'CRT_DISTRICT', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_DISTRICT', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_DISTRICT', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_DISTRICT', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_DISTRICT', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_DISTRICT', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "CRT_SYSTEM_USER_HIST"                                       */
/* ---------------------------------------------------------------------- */

CREATE TABLE [CRT_SYSTEM_USER_HIST]
(
  [SYSTEM_USER_HIST_ID] BIGINT DEFAULT NEXT VALUE FOR [CRT_SYSTEM_USER_H_ID_SEQ] NOT NULL,
  [EFFECTIVE_DATE_HIST] DATETIME DEFAULT getutcdate() NOT NULL,
  [END_DATE_HIST] DATETIME,
  [USERNAME] VARCHAR(32) NOT NULL,
  [API_CLIENT_ID] VARCHAR(40),
  [SYSTEM_USER_ID] NUMERIC(9) NOT NULL,
  [FIRST_NAME] VARCHAR(150),
  [LAST_NAME] VARCHAR(150),
  [EMAIL] VARCHAR(100),
  [END_DATE] DATETIME,
  [IS_PROJECT_MGR] BIT,
  [USER_GUID] UNIQUEIDENTIFIER,
  [APP_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_CREATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [APP_CREATE_USERID] VARCHAR(30) NOT NULL,
  [APP_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_LAST_UPDATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [APP_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  CONSTRAINT [CRT_SYS_U_H_PK] PRIMARY KEY ([SYSTEM_USER_HIST_ID]),
  CONSTRAINT [CRT_SYS_U_H_UK] UNIQUE ([SYSTEM_USER_HIST_ID], [END_DATE_HIST])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'IDIR Active Directory defined universal identifier (SM_UNIVERSALID or userID) attributed to a user.  This value can change over time, while USER_GUID will remain consistant.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'USERNAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'This ID is used to track Keycloak client ID created for the users', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'API_CLIENT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'SYSTEM_USER_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'First Name of the user', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'FIRST_NAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Last Name of the user', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'LAST_NAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Contact email address within Active Directory (Email = SMGOV_EMAIL)', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'EMAIL'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date a user can no longer access the system or invoke data submissions.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Identifies whether or not an individual is a project manager', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'IS_PROJECT_MGR'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.  Reflects the active directory unique idenifier for the user.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SYSTEM_USER_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_PERMISSION_HIST"                                    */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_PERMISSION_HIST]
(
  [PERMISSION_HIST_ID] BIGINT DEFAULT NEXT VALUE FOR [CRT_PERMISSION_H_ID_SEQ] NOT NULL,
  [PERMISSION_ID] NUMERIC(9) NOT NULL,
  [NAME] VARCHAR(30) NOT NULL,
  [DESCRIPTION] VARCHAR(150),
  [EFFECTIVE_DATE_HIST] DATETIME DEFAULT getutcdate() NOT NULL,
  [END_DATE] DATE,
  [END_DATE_HIST] DATETIME,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT NOT NULL,
  [APP_CREATE_USERID] VARCHAR(30) NOT NULL,
  [APP_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_CREATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [APP_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [APP_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_LAST_UPDATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  CONSTRAINT [CRT_PERMISSION_H_PK] PRIMARY KEY CLUSTERED ([PERMISSION_HIST_ID]),
  CONSTRAINT [CRT_PERM_H_UK] UNIQUE ([END_DATE_HIST], [PERMISSION_HIST_ID])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Permission definition table for assignment to individual system users.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for a record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', 'COLUMN', N'PERMISSION_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Business name for a permission', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', 'COLUMN', N'NAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Description of a permission.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', 'COLUMN', N'DESCRIPTION'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date permission was deactivated', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PERMISSION_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_USER_ROLE_HIST"                                     */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_USER_ROLE_HIST]
(
  [USER_ROLE_HIST_ID] BIGINT DEFAULT NEXT VALUE FOR [CRT_USER_ROLE_H_ID_SEQ] NOT NULL,
  [USER_ROLE_ID] NUMERIC(9) NOT NULL,
  [ROLE_ID] NUMERIC(9) NOT NULL,
  [SYSTEM_USER_ID] NUMERIC(9) NOT NULL,
  [EFFECTIVE_DATE_HIST] DATETIME DEFAULT getutcdate() NOT NULL,
  [END_DATE] DATETIME,
  [END_DATE_HIST] DATETIME,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT NOT NULL,
  [APP_CREATE_USERID] VARCHAR(30) NOT NULL,
  [APP_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_CREATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [APP_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [APP_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_LAST_UPDATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  CONSTRAINT [CRT_USR_R_H_PK] PRIMARY KEY CLUSTERED ([USER_ROLE_HIST_ID]),
  CONSTRAINT [CRT_USR_R_H_UK] UNIQUE ([USER_ROLE_HIST_ID], [END_DATE_HIST])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Associative table for assignment of roles to individual system users.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for a record history', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'USER_ROLE_HIST_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for a record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'USER_ROLE_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for related ROLE', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'ROLE_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for related SYSTEM USER', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'SYSTEM_USER_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date a user is no longer assigned the role.  The APP_CREATED_TIMESTAMP and the END_DATE can be used to determine which roles were assigned to a user at a given point in time.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_USER_ROLE_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_ROLE_HIST"                                          */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_ROLE_HIST]
(
  [ROLE_HIST_ID] BIGINT DEFAULT NEXT VALUE FOR [CRT_ROLE_H_ID_SEQ] NOT NULL,
  [ROLE_ID] NUMERIC(9) NOT NULL,
  [NAME] VARCHAR(30) NOT NULL,
  [DESCRIPTION] VARCHAR(150),
  [EFFECTIVE_DATE_HIST] DATETIME DEFAULT getutcdate() NOT NULL,
  [END_DATE] DATE,
  [END_DATE_HIST] DATETIME,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT DEFAULT 1 NOT NULL,
  [APP_CREATE_USERID] VARCHAR(30) NOT NULL,
  [APP_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_CREATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [APP_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [APP_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_LAST_UPDATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  CONSTRAINT [CRT_RL_H_PK] PRIMARY KEY CLUSTERED ([ROLE_HIST_ID]),
  CONSTRAINT [CRT_RL_H_UK] UNIQUE ([ROLE_HIST_ID], [END_DATE_HIST])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Role History description table for groups of permissions.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for a record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', 'COLUMN', N'ROLE_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Business name for a permission', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', 'COLUMN', N'NAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Description of a permission.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', 'COLUMN', N'DESCRIPTION'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date permission was deactivated', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_REGION_USER_HIST"                                   */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_REGION_USER_HIST]
(
  [REGION_USER_HIST_ID] BIGINT DEFAULT NEXT VALUE FOR [CRT_REGION_USER_H_ID_SEQ] NOT NULL,
  [REGION_USER_ID] NUMERIC(9) NOT NULL,
  [REGION_ID] NUMERIC(9) NOT NULL,
  [SYSTEM_USER_ID] NUMERIC(9) NOT NULL,
  [EFFECTIVE_DATE_HIST] DATETIME DEFAULT getutcdate() NOT NULL,
  [END_DATE] DATETIME,
  [END_DATE_HIST] DATETIME,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT NOT NULL,
  [APP_CREATE_USERID] VARCHAR(30) NOT NULL,
  [APP_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_CREATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [APP_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [APP_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_LAST_UPDATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  CONSTRAINT [CRT_REGION_U_H_PK] PRIMARY KEY CLUSTERED ([REGION_USER_HIST_ID]),
  CONSTRAINT [CRT_REGION_U_H_UK] UNIQUE ([REGION_USER_HIST_ID], [END_DATE_HIST])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'History of association between USER and REGION defining which users can submit or access data.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for REGION History', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'REGION_USER_HIST_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for REGION', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'REGION_USER_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'identifier for REGION', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'REGION_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier of related user', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'SYSTEM_USER_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date reflecting when a user can no longer transmit submissions.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_ROLE_PERMISSION_HIST"                               */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_ROLE_PERMISSION_HIST]
(
  [ROLE_PERMISSION_HIST_ID] BIGINT DEFAULT NEXT VALUE FOR [CRT_ROLE_PERMISSION_H_ID_SEQ] NOT NULL,
  [ROLE_PERMISSION_ID] NUMERIC(9) NOT NULL,
  [ROLE_ID] NUMERIC(9) NOT NULL,
  [PERMISSION_ID] NUMERIC(9) NOT NULL,
  [EFFECTIVE_DATE_HIST] DATETIME DEFAULT getutcdate() NOT NULL,
  [END_DATE] DATE,
  [END_DATE_HIST] DATETIME,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT NOT NULL,
  [APP_CREATE_USERID] VARCHAR(30) NOT NULL,
  [APP_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_CREATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [APP_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [APP_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_LAST_UPDATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  CONSTRAINT [CRT_RL_PE_H_PK] PRIMARY KEY CLUSTERED ([ROLE_PERMISSION_HIST_ID]),
  CONSTRAINT [CRT_RL_PE_H_UK] UNIQUE ([END_DATE_HIST], [ROLE_PERMISSION_HIST_ID])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'History of Role to Permission associative table for assignment of permissions to parent roles.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for a record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'ROLE_PERMISSION_HIST_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for a record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'ROLE_PERMISSION_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier for related role', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'ROLE_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier for related permission', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'PERMISSION_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date record was deactivated', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date record was deactivated', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'END_DATE_HIST'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_ROLE_PERMISSION"                                    */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_ROLE_PERMISSION]
(
  [ROLE_PERMISSION_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_RL_PERM_ID_SEQ] NOT NULL,
  [ROLE_ID] NUMERIC(9) NOT NULL,
  [PERMISSION_ID] NUMERIC(9) NOT NULL,
  [END_DATE] DATE,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT DEFAULT 1 NOT NULL,
  [APP_CREATE_USERID] VARCHAR(30) NOT NULL,
  [APP_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_CREATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [APP_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [APP_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_LAST_UPDATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  CONSTRAINT [CRT_RL_PERM_PK] PRIMARY KEY CLUSTERED ([ROLE_PERMISSION_ID]),
  CONSTRAINT [CRT_RL_PERM_UN_CH] UNIQUE ([ROLE_ID], [PERMISSION_ID], [END_DATE])
)
GO


CREATE NONCLUSTERED INDEX [CRT_RL_PERM_PERM_FK_I] ON [dbo].[CRT_ROLE_PERMISSION] ([PERMISSION_ID] ASC)
GO


CREATE NONCLUSTERED INDEX [CRT_RL_PERM_RL_FK_I] ON [dbo].[CRT_ROLE_PERMISSION] ([ROLE_ID] ASC)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Role to Permission associative table for assignment of permissions to parent roles.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for a record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', 'COLUMN', N'ROLE_PERMISSION_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier for related role', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', 'COLUMN', N'ROLE_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier for related permission', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', 'COLUMN', N'PERMISSION_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date record was deactivated', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ROLE_PERMISSION', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_SERVICE_AREA_HIST"                                  */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_SERVICE_AREA_HIST]
(
  [SERVICE_AREA_HIST_ID] BIGINT DEFAULT NEXT VALUE FOR [CRT_SRV_ARA_ID_SEQ] NOT NULL,
  [SERVICE_AREA_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_SRV_ARA_ID_SEQ] NOT NULL,
  [SERVICE_AREA_NUMBER] NUMERIC(9) NOT NULL,
  [SERVICE_AREA_NAME] VARCHAR(60) NOT NULL,
  [DISTRICT_ID] NUMERIC(9) NOT NULL,
  [EFFECTIVE_DATE_HIST] DATETIME DEFAULT getutcdate() NOT NULL,
  [END_DATE] DATE,
  [END_DATE_HIST] DATETIME,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT DEFAULT 1 NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  CONSTRAINT [CRT_SRV_A_H_PK] PRIMARY KEY CLUSTERED ([SERVICE_AREA_HIST_ID]),
  CONSTRAINT [CRT_SRV_A_H_UK] UNIQUE ([SERVICE_AREA_HIST_ID], [END_DATE_HIST])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Service Area lookup values', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA_HIST', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier for history table records ', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA_HIST', 'COLUMN', N'SERVICE_AREA_HIST_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier for table records', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA_HIST', 'COLUMN', N'SERVICE_AREA_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Assigned number of the Service Area', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA_HIST', 'COLUMN', N'SERVICE_AREA_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Name of the service area', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA_HIST', 'COLUMN', N'SERVICE_AREA_NAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for DISTRICT.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA_HIST', 'COLUMN', N'DISTRICT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the entity ends or changes', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA_HIST', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_REGION_DISTRICT"                                    */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_REGION_DISTRICT]
(
  [REGION_DISTRICT_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_REG_DIST_ID_SEQ] NOT NULL,
  [REGION_ID] NUMERIC(9) NOT NULL,
  [DISTRICT_ID] NUMERIC(9) NOT NULL,
  [END_DATE] DATE,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT DEFAULT 1 NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  CONSTRAINT [CRT_REGION_DISTR_PK] PRIMARY KEY CLUSTERED ([REGION_DISTRICT_ID]),
  CONSTRAINT [CRT_REG_DIS_NO_NAME_UK] UNIQUE ([END_DATE], [REGION_ID], [DISTRICT_ID])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Ministry Region District lookup values', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT', 'COLUMN', N'REGION_DISTRICT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'unique identifier for Ministry region', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT', 'COLUMN', N'REGION_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'unique identifier for Ministry district', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT', 'COLUMN', N'DISTRICT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the entity ends or changes', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_REGION_DISTRICT_HIST"                               */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_REGION_DISTRICT_HIST]
(
  [REGION_DISTRICT_HIST_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_REG_DIST_H_ID_SEQ] NOT NULL,
  [REGION_DISTRICT_ID] NUMERIC(9) NOT NULL,
  [REGION_ID] NUMERIC(2) NOT NULL,
  [DISTRICT_ID] NUMERIC(2) NOT NULL,
  [EFFECTIVE_DATE_HIST] DATETIME DEFAULT getutcdate() NOT NULL,
  [END_DATE] DATE,
  [END_DATE_HIST] DATETIME,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  CONSTRAINT [CRT_REGION_DISTR_H_PK] PRIMARY KEY CLUSTERED ([REGION_DISTRICT_HIST_ID]),
  CONSTRAINT [CRT_REG_DIS_H_NO_NAME_UK] UNIQUE ([REGION_DISTRICT_HIST_ID], [END_DATE_HIST])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Ministry Region lookup values', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT_HIST', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT_HIST', 'COLUMN', N'REGION_DISTRICT_HIST_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT_HIST', 'COLUMN', N'REGION_DISTRICT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'unique identifier for Ministry region', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT_HIST', 'COLUMN', N'REGION_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'unique identifier for Ministry district', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT_HIST', 'COLUMN', N'DISTRICT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the entity ends or changes', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT_HIST', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_DISTRICT_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_CODE_LOOKUP"                                        */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_CODE_LOOKUP]
(
  [CODE_LOOKUP_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_CODE_LKUP_ID_SEQ] NOT NULL,
  [CODE_SET] VARCHAR(20),
  [CODE_NAME] VARCHAR(255),
  [CODE_VALUE_TEXT] VARCHAR(20),
  [CODE_VALUE_NUM] NUMERIC(9),
  [CODE_VALUE_FORMAT] VARCHAR(12),
  [DISPLAY_ORDER] NUMERIC(3),
  [END_DATE] DATETIME,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT DEFAULT 1 NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  CONSTRAINT [CRT_CODE_LKUP_PK] PRIMARY KEY CLUSTERED ([CODE_LOOKUP_ID]),
  CONSTRAINT [CRT_CODE_LKUP_VAL_NUM_UC] UNIQUE ([CODE_SET], [CODE_VALUE_NUM], [CODE_NAME]),
  CONSTRAINT [CRT_CODE_LKUP_VAL_TXT_UC] UNIQUE ([CODE_SET], [CODE_VALUE_TEXT], [CODE_NAME])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A range of lookup values used to decipher codes used in submissions to business legible values for reporting purposes.  As many code lookups share this table, views are available to join for reporting purposes.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_CODE_LOOKUP', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for a record.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_CODE_LOOKUP', 'COLUMN', N'CODE_LOOKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for a group of lookup codes.  A database view is available for each group for use in analytics.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_CODE_LOOKUP', 'COLUMN', N'CODE_SET'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Display name or business name for a submission value.  These values are for display in analytical reporting.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_CODE_LOOKUP', 'COLUMN', N'CODE_NAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Look up code values provided in submissions.   These values are used for validating submissions and for display of CODE NAMES in analytical reporting.  Values must be unique per CODE SET.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_CODE_LOOKUP', 'COLUMN', N'CODE_VALUE_TEXT'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N' Numeric enumeration values provided in submissions.   These values are used for validating submissions and for display of CODE NAMES in analytical reporting.  Values must be unique per CODE SET.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_CODE_LOOKUP', 'COLUMN', N'CODE_VALUE_NUM'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Specifies if the code value is text or numeric.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_CODE_LOOKUP', 'COLUMN', N'CODE_VALUE_FORMAT'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'When displaying list of values, value can be used to present list in desired order.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_CODE_LOOKUP', 'COLUMN', N'DISPLAY_ORDER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'The latest date submissions will be accepted.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_CODE_LOOKUP', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_CODE_LOOKUP', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_CODE_LOOKUP', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_CODE_LOOKUP', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_CODE_LOOKUP', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_CODE_LOOKUP', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_CODE_LOOKUP_HIST"                                   */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_CODE_LOOKUP_HIST]
(
  [CODE_LOOKUP_HIST_ID] BIGINT DEFAULT NEXT VALUE FOR [CRT_CODE_LOOKUP_H_ID_SEQ] NOT NULL,
  [EFFECTIVE_DATE_HIST] DATETIME DEFAULT getutcdate() NOT NULL,
  [END_DATE_HIST] DATETIME,
  [CODE_LOOKUP_ID] NUMERIC(18) NOT NULL,
  [CODE_SET] VARCHAR(20),
  [CODE_NAME] VARCHAR(255),
  [CODE_VALUE_TEXT] VARCHAR(20),
  [CODE_VALUE_NUM] NUMERIC(18),
  [CODE_VALUE_FORMAT] VARCHAR(12),
  [DISPLAY_ORDER] NUMERIC(18),
  [END_DATE] DATETIME,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  CONSTRAINT [CRT_CODE__H_PK] PRIMARY KEY CLUSTERED ([CODE_LOOKUP_HIST_ID]),
  CONSTRAINT [CRT_CODE__H_UK] UNIQUE ([CODE_LOOKUP_HIST_ID], [END_DATE_HIST])
)
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_REGION_USER"                                        */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_REGION_USER]
(
  [REGION_USER_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_REGION_USR_ID_SEQ] NOT NULL,
  [REGION_ID] NUMERIC(9) NOT NULL,
  [SYSTEM_USER_ID] NUMERIC(9) NOT NULL,
  [END_DATE] DATETIME,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT DEFAULT 1 NOT NULL,
  [APP_CREATE_USERID] VARCHAR(30) NOT NULL,
  [APP_CREATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_CREATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [APP_LAST_UPDATE_USERID] VARCHAR(30) NOT NULL,
  [APP_LAST_UPDATE_TIMESTAMP] DATETIME NOT NULL,
  [APP_LAST_UPDATE_USER_GUID] UNIQUEIDENTIFIER NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  CONSTRAINT [CRT_REGION_USR_PK] PRIMARY KEY CLUSTERED ([REGION_USER_ID])
)
GO


CREATE NONCLUSTERED INDEX [CRT_REGION_USER_FK_I] ON [dbo].[CRT_REGION_USER] ([SYSTEM_USER_ID] ASC)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Association between USER and REGION defining which users can submit or access data.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for REGION User', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', 'COLUMN', N'REGION_USER_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'identifier for REGION', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', 'COLUMN', N'REGION_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier of related user', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', 'COLUMN', N'SYSTEM_USER_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date reflecting when a user can no longer transmit submissions.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION_USER', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_SERVICE_AREA"                                       */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_SERVICE_AREA]
(
  [SERVICE_AREA_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_SRV_ARA_ID_SEQ] NOT NULL,
  [SERVICE_AREA_NUMBER] NUMERIC(9) NOT NULL,
  [SERVICE_AREA_NAME] VARCHAR(60) NOT NULL,
  [DISTRICT_ID] NUMERIC(9) NOT NULL,
  [END_DATE] DATE,
  [CONCURRENCY_CONTROL_NUMBER] BIGINT DEFAULT 1 NOT NULL,
  [DB_AUDIT_CREATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_CREATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_USERID] VARCHAR(30) DEFAULT user_name() NOT NULL,
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL,
  CONSTRAINT [CRT_SERVICE_AREA_PK] PRIMARY KEY CLUSTERED ([SERVICE_AREA_ID]),
  CONSTRAINT [CRT_SRV_ARA_UK] UNIQUE ([SERVICE_AREA_NUMBER], [SERVICE_AREA_NAME], [END_DATE])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Service Area lookup values', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier for table records', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA', 'COLUMN', N'SERVICE_AREA_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Assigned number of the Service Area', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA', 'COLUMN', N'SERVICE_AREA_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Name of the service area', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA', 'COLUMN', N'SERVICE_AREA_NAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for DISTRICT.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA', 'COLUMN', N'DISTRICT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the entity ends or changes', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SERVICE_AREA', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add foreign key constraints                                            */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_USER_ROLE] ADD CONSTRAINT [CRT_USR_RL_RL_FK] 
    FOREIGN KEY ([ROLE_ID]) REFERENCES [dbo].[CRT_ROLE] ([ROLE_ID])
GO


ALTER TABLE [dbo].[CRT_USER_ROLE] ADD CONSTRAINT [CRT_USR_RL_SYS_USR_FK] 
    FOREIGN KEY ([SYSTEM_USER_ID]) REFERENCES [dbo].[CRT_SYSTEM_USER] ([SYSTEM_USER_ID])
GO


ALTER TABLE [dbo].[CRT_REGION_USER] ADD CONSTRAINT [CRT_SYSTEM_USER_CRT_REGION_USER] 
    FOREIGN KEY ([SYSTEM_USER_ID]) REFERENCES [dbo].[CRT_SYSTEM_USER] ([SYSTEM_USER_ID])
GO


ALTER TABLE [dbo].[CRT_REGION_USER] ADD CONSTRAINT [CRT_REGION_CRT_REGION_USER] 
    FOREIGN KEY ([REGION_ID]) REFERENCES [dbo].[CRT_REGION] ([REGION_ID])
GO


ALTER TABLE [dbo].[CRT_SERVICE_AREA] ADD CONSTRAINT [CRT_DISTRICT_CRT_SERVICE_AREA] 
    FOREIGN KEY ([DISTRICT_ID]) REFERENCES [dbo].[CRT_DISTRICT] ([DISTRICT_ID])
GO


ALTER TABLE [dbo].[CRT_ROLE_PERMISSION] ADD CONSTRAINT [CRT_ROLE_CRT_ROLE_PERMISSION] 
    FOREIGN KEY ([ROLE_ID]) REFERENCES [dbo].[CRT_ROLE] ([ROLE_ID])
GO


ALTER TABLE [dbo].[CRT_ROLE_PERMISSION] ADD CONSTRAINT [CRT_PERMISSION_CRT_ROLE_PERMISSION] 
    FOREIGN KEY ([PERMISSION_ID]) REFERENCES [dbo].[CRT_PERMISSION] ([PERMISSION_ID])
GO


ALTER TABLE [dbo].[CRT_REGION_DISTRICT] ADD CONSTRAINT [CRT_REGION_CRT_REGION_DISTRICT] 
    FOREIGN KEY ([REGION_ID]) REFERENCES [dbo].[CRT_REGION] ([REGION_ID])
GO


ALTER TABLE [dbo].[CRT_REGION_DISTRICT] ADD CONSTRAINT [CRT_DISTRICT_CRT_REGION_DISTRICT] 
    FOREIGN KEY ([DISTRICT_ID]) REFERENCES [dbo].[CRT_DISTRICT] ([DISTRICT_ID])
GO


/* ---------------------------------------------------------------------- */
/* Add procedures                                                         */
/* ---------------------------------------------------------------------- */

CREATE PROCEDURE [dbo].[crt_error_handling]
AS

begin
  DECLARE @errmsg   nvarchar(2048),
      @severity tinyint,
      @state    tinyint,
      @errno    int,
      @proc     sysname,
      @lineno   int

  SELECT @errmsg = error_message(), @severity = error_severity(),
    @state  = error_state(), @errno = error_number(),
    @proc   = error_procedure(), @lineno = error_line()

  IF @errmsg NOT LIKE '***%'
      BEGIN
    SELECT @errmsg = '*** ' + coalesce(quotename(@proc), '<dynamic SQL>') +
          ', Line ' + ltrim(str(@lineno)) + '. Errno ' +
          ltrim(str(@errno)) + ': ' + @errmsg
  END

  RAISERROR('%s', @severity, @state, @errmsg)
end
GO


/* ---------------------------------------------------------------------- */
/* Add triggers                                                           */
/* ---------------------------------------------------------------------- */

CREATE TRIGGER [dbo].[CRT_PERM_A_S_IUD_TR] ON CRT_PERMISSION FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT *
  FROM inserted) AND NOT EXISTS(SELECT *
  FROM deleted)
    RETURN;


  IF EXISTS(SELECT *
FROM deleted)
    update CRT_PERMISSION_HIST set END_DATE_HIST = @curr_date where PERMISSION_ID in (select PERMISSION_ID
  from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT *
FROM inserted)
    insert into CRT_PERMISSION_HIST
  ([PERMISSION_ID], [NAME], [DESCRIPTION], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], PERMISSION_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
select [PERMISSION_ID], [NAME], [DESCRIPTION], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_PERMISSION_H_ID_SEQ]) as [PERMISSION_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_PERM_I_S_I_TR] ON CRT_PERMISSION INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;


  insert into CRT_PERMISSION
  ("PERMISSION_ID",
  "NAME",
  "DESCRIPTION",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID")
select "PERMISSION_ID",
  "NAME",
  "DESCRIPTION",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID"
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_PERM_I_S_U_TR] ON CRT_PERMISSION INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;


  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.PERMISSION_ID = deleted.PERMISSION_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)



  update CRT_PERMISSION
    set "PERMISSION_ID" = inserted."PERMISSION_ID",
      "NAME" = inserted."NAME",
      "DESCRIPTION" = inserted."DESCRIPTION",
      "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_PERMISSION
  inner join inserted
  on (CRT_PERMISSION.PERMISSION_ID = inserted.PERMISSION_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_RL_A_S_IUD_TR] ON CRT_ROLE FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT *
  FROM inserted) AND NOT EXISTS(SELECT *
  FROM deleted)
    RETURN;


  IF EXISTS(SELECT *
FROM deleted)
    update CRT_ROLE_HIST set END_DATE_HIST = @curr_date where ROLE_ID in (select ROLE_ID
  from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT *
FROM inserted)
    insert into CRT_ROLE_HIST
  ([ROLE_ID], [NAME], [DESCRIPTION], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], ROLE_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
select [ROLE_ID], [NAME], [DESCRIPTION], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_ROLE_H_ID_SEQ]) as [ROLE_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_RL_I_S_I_TR] ON CRT_ROLE INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;


  insert into CRT_ROLE
  ("ROLE_ID",
  "NAME",
  "DESCRIPTION",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID")
select "ROLE_ID",
  "NAME",
  "DESCRIPTION",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID"
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_RL_I_S_U_TR] ON CRT_ROLE INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;


  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.ROLE_ID = deleted.ROLE_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)



  update CRT_ROLE
    set "ROLE_ID" = inserted."ROLE_ID",
      "NAME" = inserted."NAME",
      "DESCRIPTION" = inserted."DESCRIPTION",
      "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID"
	, DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_ROLE
  inner join inserted
  on (CRT_ROLE.ROLE_ID = inserted.ROLE_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_SYS_USR_A_S_IUD_TR] ON CRT_SYSTEM_USER FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT *
  FROM inserted) AND NOT EXISTS(SELECT *
  FROM deleted)
    RETURN;


  IF EXISTS(SELECT *
FROM deleted)
    update CRT_SYSTEM_USER_HIST set END_DATE_HIST = @curr_date where SYSTEM_USER_ID in (select SYSTEM_USER_ID
  from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT *
FROM inserted)
    insert into CRT_SYSTEM_USER_HIST
  ([SYSTEM_USER_ID], [API_CLIENT_ID], [USER_GUID], [USERNAME], [FIRST_NAME], [LAST_NAME], [EMAIL], [END_DATE], [IS_PROJECT_MGR], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], SYSTEM_USER_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
select [SYSTEM_USER_ID], [API_CLIENT_ID], [USER_GUID], [USERNAME], [FIRST_NAME], [LAST_NAME], [EMAIL], [END_DATE], [IS_PROJECT_MGR], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_SYSTEM_USER_H_ID_SEQ]) as [SYSTEM_USER_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_SYS_USR_I_S_I_TR] ON CRT_SYSTEM_USER INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;


  insert into CRT_SYSTEM_USER
  ("SYSTEM_USER_ID",
  "API_CLIENT_ID",
  "USER_GUID",
  "USERNAME",
  "FIRST_NAME",
  "LAST_NAME",
  "EMAIL",
  "END_DATE",
  "IS_PROJECT_MGR",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID")
select "SYSTEM_USER_ID",
  "API_CLIENT_ID",
  "USER_GUID",
  "USERNAME",
  "FIRST_NAME",
  "LAST_NAME",
  "EMAIL",
  "END_DATE",
  "IS_PROJECT_MGR",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID"
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_SYS_USR_I_S_U_TR] ON CRT_SYSTEM_USER INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;


  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.SYSTEM_USER_ID = deleted.SYSTEM_USER_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)



  update CRT_SYSTEM_USER
    set "SYSTEM_USER_ID" = inserted."SYSTEM_USER_ID",
      "API_CLIENT_ID" = inserted."API_CLIENT_ID",
      "USER_GUID" = inserted."USER_GUID",
      "USERNAME" = inserted."USERNAME",
      "FIRST_NAME" = inserted."FIRST_NAME",
      "LAST_NAME" = inserted."LAST_NAME",
      "EMAIL" = inserted."EMAIL",
      "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "IS_PROJECT_MGR" = inserted."IS_PROJECT_MGR",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_SYSTEM_USER
  inner join inserted
  on (CRT_SYSTEM_USER.SYSTEM_USER_ID = inserted.SYSTEM_USER_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_USR_RL_A_S_IUD_TR] ON CRT_USER_ROLE FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT *
  FROM inserted) AND NOT EXISTS(SELECT *
  FROM deleted)
    RETURN;


  IF EXISTS(SELECT *
FROM deleted)
    update CRT_USER_ROLE_HIST set END_DATE_HIST = @curr_date where USER_ROLE_ID in (select USER_ROLE_ID
  from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT *
FROM inserted)
    insert into CRT_USER_ROLE_HIST
  ([USER_ROLE_ID], [ROLE_ID], [SYSTEM_USER_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], USER_ROLE_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
select [USER_ROLE_ID], [ROLE_ID], [SYSTEM_USER_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_USER_ROLE_H_ID_SEQ]) as [USER_ROLE_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_USR_RL_I_S_I_TR] ON CRT_USER_ROLE INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;


  insert into CRT_USER_ROLE
  ("USER_ROLE_ID",
  "ROLE_ID",
  "SYSTEM_USER_ID",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID")
select "USER_ROLE_ID",
  "ROLE_ID",
  "SYSTEM_USER_ID",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID"
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_USR_RL_I_S_U_TR] ON CRT_USER_ROLE INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;


  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.USER_ROLE_ID = deleted.USER_ROLE_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)



  update CRT_USER_ROLE
    set "USER_ROLE_ID" = inserted."USER_ROLE_ID",
      "ROLE_ID" = inserted."ROLE_ID",
      "SYSTEM_USER_ID" = inserted."SYSTEM_USER_ID",
      "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID"    
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_USER_ROLE
  inner join inserted
  on (CRT_USER_ROLE.USER_ROLE_ID = inserted.USER_ROLE_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_REGION_USR_A_S_IUD_TR] ON CRT_REGION_USER FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT *
  FROM inserted) AND NOT EXISTS(SELECT *
  FROM deleted)
    RETURN;

  -- historical
  IF EXISTS(SELECT *
FROM deleted)
    update CRT_REGION_USER_HIST set END_DATE_HIST = @curr_date where REGION_USER_ID in (select REGION_USER_ID
  from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT *
FROM inserted)
    insert into CRT_REGION_USER_HIST
  ([REGION_USER_ID], [REGION_ID], [SYSTEM_USER_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], REGION_USER_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
select [REGION_USER_ID], [REGION_ID], [SYSTEM_USER_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_REGION_USER_H_ID_SEQ]) as [REGION_USER_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_REGION_USR_I_S_I_TR] ON CRT_REGION_USER INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;


  insert into CRT_REGION_USER
  ("REGION_USER_ID",
  "REGION_ID",
  "SYSTEM_USER_ID",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID")
select "REGION_USER_ID",
  "REGION_ID",
  "SYSTEM_USER_ID",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID"
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_REGION_USR_I_S_U_TR] ON CRT_REGION_USER INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.REGION_USER_ID = deleted.REGION_USER_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)


  -- update statement
  update CRT_REGION_USER
    set "REGION_USER_ID" = inserted."REGION_USER_ID",
      "REGION_ID" = inserted."REGION_ID",
      "SYSTEM_USER_ID" = inserted."SYSTEM_USER_ID",
      "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_REGION_USER
  inner join inserted
  on (CRT_REGION_USER.REGION_USER_ID = inserted.REGION_USER_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_RGN_I_S_I_TR] ON CRT_REGION INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;


  insert into CRT_REGION
  ("REGION_ID",
  "REGION_NUMBER",
  "REGION_NAME",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER")
select "REGION_ID",
  "REGION_NUMBER",
  "REGION_NAME",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER"
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_RGN_I_S_U_TR] ON CRT_REGION INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.REGION_ID = deleted.REGION_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)


  -- update statement
  update CRT_REGION
    set "REGION_ID" = inserted."REGION_ID",
      "REGION_NUMBER" = inserted."REGION_NUMBER",
      "REGION_NAME" = inserted."REGION_NAME",  
      "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_REGION
  inner join inserted
  on (CRT_REGION.REGION_ID = inserted.REGION_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_SRV_ARA_A_S_IUD_TR] ON CRT_SERVICE_AREA FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT *
  FROM inserted) AND NOT EXISTS(SELECT *
  FROM deleted)
    RETURN;

  -- historical
  IF EXISTS(SELECT *
FROM deleted)
    update CRT_SERVICE_AREA_HIST set END_DATE_HIST = @curr_date where SERVICE_AREA_ID in (select SERVICE_AREA_ID
  from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT *
FROM inserted)
    insert into CRT_SERVICE_AREA_HIST
  ([SERVICE_AREA_ID], [SERVICE_AREA_NUMBER], [SERVICE_AREA_NAME], [DISTRICT_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], SERVICE_AREA_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
select [SERVICE_AREA_ID], [SERVICE_AREA_NUMBER], [SERVICE_AREA_NAME], [DISTRICT_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_SERVICE_AREA_H_ID_SEQ]) as [SERVICE_AREA_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_SRV_ARA_I_S_I_TR] ON CRT_SERVICE_AREA INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;


  insert into CRT_SERVICE_AREA
  ("SERVICE_AREA_ID",
  "SERVICE_AREA_NUMBER",
  "SERVICE_AREA_NAME",
  "DISTRICT_ID",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER")
select "SERVICE_AREA_ID",
  "SERVICE_AREA_NUMBER",
  "SERVICE_AREA_NAME",
  "DISTRICT_ID",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER"
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_SRV_ARA_I_S_U_TR] ON CRT_SERVICE_AREA INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.SERVICE_AREA_ID = deleted.SERVICE_AREA_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)


  -- update statement
  update CRT_SERVICE_AREA
    set "SERVICE_AREA_ID" = inserted."SERVICE_AREA_ID",
      "SERVICE_AREA_NUMBER" = inserted."SERVICE_AREA_NUMBER",
      "SERVICE_AREA_NAME" = inserted."SERVICE_AREA_NAME",
      "DISTRICT_ID" = inserted."DISTRICT_ID",    
      "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_SERVICE_AREA
  inner join inserted
  on (CRT_SERVICE_AREA.SERVICE_AREA_ID = inserted.SERVICE_AREA_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_DIST_I_S_I_TR] ON CRT_DISTRICT INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;


  insert into CRT_DISTRICT
  ("DISTRICT_ID",
  "DISTRICT_NUMBER",
  "DISTRICT_NAME",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER")
select "DISTRICT_ID",
  "DISTRICT_NUMBER",
  "DISTRICT_NAME",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER"
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_DIST_I_S_U_TR] ON CRT_DISTRICT INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.DISTRICT_ID = deleted.DISTRICT_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)


  -- update statement
  update CRT_DISTRICT
    set "DISTRICT_ID" = inserted."DISTRICT_ID",
      "DISTRICT_NUMBER" = inserted."DISTRICT_NUMBER",
      "DISTRICT_NAME" = inserted."DISTRICT_NAME",
      "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_DISTRICT
  inner join inserted
  on (CRT_DISTRICT.DISTRICT_ID = inserted.DISTRICT_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_RL_PERM_A_S_IUD_TR] ON CRT_ROLE_PERMISSION FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT *
  FROM inserted) AND NOT EXISTS(SELECT *
  FROM deleted)
    RETURN;

  -- historical
  IF EXISTS(SELECT *
FROM deleted)
    update CRT_ROLE_PERMISSION_HIST set END_DATE_HIST = @curr_date where ROLE_PERMISSION_ID in (select ROLE_PERMISSION_ID
  from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT *
FROM inserted)
    insert into CRT_ROLE_PERMISSION_HIST
  ([ROLE_PERMISSION_ID], [ROLE_ID], [PERMISSION_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], ROLE_PERMISSION_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
select [ROLE_PERMISSION_ID], [ROLE_ID], [PERMISSION_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_ROLE_PERMISSION_H_ID_SEQ]) as [ROLE_PERMISSION_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_RL_PERM_I_S_I_TR] ON CRT_ROLE_PERMISSION INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;


  insert into CRT_ROLE_PERMISSION
  ("ROLE_PERMISSION_ID",
  "ROLE_ID",
  "PERMISSION_ID",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID")
select "ROLE_PERMISSION_ID",
  "ROLE_ID",
  "PERMISSION_ID",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID"
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_RL_PERM_I_S_U_TR] ON CRT_ROLE_PERMISSION INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.ROLE_PERMISSION_ID = deleted.ROLE_PERMISSION_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)


  -- update statement
  update CRT_ROLE_PERMISSION
    set "ROLE_PERMISSION_ID" = inserted."ROLE_PERMISSION_ID",
      "ROLE_ID" = inserted."ROLE_ID",
      "PERMISSION_ID" = inserted."PERMISSION_ID",
      "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_ROLE_PERMISSION
  inner join inserted
  on (CRT_ROLE_PERMISSION.ROLE_PERMISSION_ID = inserted.ROLE_PERMISSION_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_RGN_D_I_S_I_TR] ON CRT_REGION_DISTRICT INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;


  insert into CRT_REGION_DISTRICT
  ("REGION_DISTRICT_ID",
  "REGION_ID",
  "DISTRICT_ID",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER")
select "REGION_DISTRICT_ID",
  "REGION_ID",
  "DISTRICT_ID",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER"
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_RGN_D_I_S_U_TR] ON CRT_REGION_DISTRICT INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.REGION_DISTRICT_ID = deleted.REGION_DISTRICT_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)


  -- update statement
  update CRT_REGION_DISTRICT
    set "REGION_DISTRICT_ID" = inserted."REGION_DISTRICT_ID",
      "REGION_ID" = inserted."REGION_ID",
      "DISTRICT_ID" = inserted."DISTRICT_ID",
      "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_REGION_DISTRICT
  inner join inserted
  on (CRT_REGION_DISTRICT.REGION_DISTRICT_ID = inserted.REGION_DISTRICT_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_RGN_DIST_A_S_IUD_TR] ON CRT_REGION_DISTRICT FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT *
  FROM inserted) AND NOT EXISTS(SELECT *
  FROM deleted)
    RETURN;

  -- historical
  IF EXISTS(SELECT *
FROM deleted)
    update CRT_REGION_DISTRICT_HIST set END_DATE_HIST = @curr_date where REGION_DISTRICT_ID in (select REGION_DISTRICT_ID
  from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT *
FROM inserted)
    insert into CRT_REGION_DISTRICT_HIST
  ([REGION_DISTRICT_ID], [REGION_ID], [DISTRICT_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], REGION_DISTRICT_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
select [REGION_DISTRICT_ID], [REGION_ID], [DISTRICT_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_REG_DIST_ID_SEQ]) as [REGION_DISTRICT_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;
                                                                   
END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_CODE_LKUP_A_S_IUD_TR] ON CRT_CODE_LOOKUP FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT *
  FROM inserted) AND NOT EXISTS(SELECT *
  FROM deleted)
    RETURN;

  -- historical
  IF EXISTS(SELECT *
FROM deleted)
    update CRT_CODE_LOOKUP_HIST set END_DATE_HIST = @curr_date where CODE_LOOKUP_ID in (select CODE_LOOKUP_ID
  from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT *
FROM inserted)
    insert into CRT_CODE_LOOKUP_HIST
  ([CODE_LOOKUP_ID], [CODE_SET], [CODE_NAME], [CODE_VALUE_TEXT], [CODE_VALUE_NUM], [CODE_VALUE_FORMAT], [DISPLAY_ORDER], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], CODE_LOOKUP_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
select [CODE_LOOKUP_ID], [CODE_SET], [CODE_NAME], [CODE_VALUE_TEXT], [CODE_VALUE_NUM], [CODE_VALUE_FORMAT], [DISPLAY_ORDER], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_CODE_LOOKUP_H_ID_SEQ]) as [CODE_LOOKUP_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_CODE_LKUP_I_S_I_TR] ON CRT_CODE_LOOKUP INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;


  insert into CRT_CODE_LOOKUP
  ("CODE_LOOKUP_ID",
  "CODE_SET",
  "CODE_NAME",
  "CODE_VALUE_TEXT",
  "CODE_VALUE_NUM",
  "CODE_VALUE_FORMAT",
  "DISPLAY_ORDER",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER")
select "CODE_LOOKUP_ID",
  "CODE_SET",
  "CODE_NAME",
  "CODE_VALUE_TEXT",
  "CODE_VALUE_NUM",
  "CODE_VALUE_FORMAT",
  "DISPLAY_ORDER",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER"
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_CODE_LKUP_I_S_U_TR] ON CRT_CODE_LOOKUP INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.CODE_LOOKUP_ID = deleted.CODE_LOOKUP_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)


  -- update statement
  update CRT_CODE_LOOKUP
    set "CODE_LOOKUP_ID" = inserted."CODE_LOOKUP_ID",
      "CODE_SET" = inserted."CODE_SET",
      "CODE_NAME" = inserted."CODE_NAME",
      "CODE_VALUE_TEXT" = inserted."CODE_VALUE_TEXT",
      "CODE_VALUE_NUM" = inserted."CODE_VALUE_NUM",
      "CODE_VALUE_FORMAT" = inserted."CODE_VALUE_FORMAT",
      "DISPLAY_ORDER" = inserted."DISPLAY_ORDER",
      "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_CODE_LOOKUP
  inner join inserted
  on (CRT_CODE_LOOKUP.CODE_LOOKUP_ID = inserted.CODE_LOOKUP_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO

