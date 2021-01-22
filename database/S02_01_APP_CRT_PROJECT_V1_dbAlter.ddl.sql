/* ---------------------------------------------------------------------- */
/* Script generated with: DeZign for Databases 12.1.0                     */
/* Target DBMS:           MS SQL Server 2017                              */
/* Project file:          S02_01_APP_CRT_V1.dez                           */
/* Project name:          Capital Rehabilitation Tracking Reporting       */
/* Author:                Ayodeji Kuponiyi                                */
/* Script type:           Alter database script                           */
/* Created on:            2021-01-22 08:49                                */
/* ---------------------------------------------------------------------- */


/* ---------------------------------------------------------------------- */
/* Drop triggers                                                          */
/* ---------------------------------------------------------------------- */

DROP TRIGGER [dbo].[CRT_PERM_A_S_IUD_TR]
GO


DROP TRIGGER [dbo].[CRT_REGION_USR_A_S_IUD_TR]
GO


DROP TRIGGER [dbo].[CRT_REGION_USR_I_S_I_TR]
GO


DROP TRIGGER [dbo].[CRT_RL_A_S_IUD_TR]
GO


DROP TRIGGER [dbo].[CRT_RL_I_S_I_TR]
GO


DROP TRIGGER [dbo].[CRT_RL_I_S_U_TR]
GO


DROP TRIGGER [dbo].[CRT_SYS_USR_A_S_IUD_TR]
GO


DROP TRIGGER [dbo].[CRT_SYS_USR_I_S_I_TR]
GO


DROP TRIGGER [dbo].[CRT_SYS_USR_I_S_U_TR]
GO


DROP TRIGGER [dbo].[CRT_USR_RL_A_S_IUD_TR]
GO


DROP TRIGGER [dbo].[CRT_USR_RL_I_S_I_TR]
GO


DROP TRIGGER [dbo].[CRT_USR_RL_I_S_U_TR]
GO


/* ---------------------------------------------------------------------- */
/* Drop foreign key constraints                                           */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_REGION_USER] DROP CONSTRAINT [CRT_SYSTEM_USER_CRT_REGION_USER]
GO


ALTER TABLE [dbo].[CRT_REGION_USER] DROP CONSTRAINT [CRT_REGION_CRT_REGION_USER]
GO


ALTER TABLE [dbo].[CRT_USER_ROLE] DROP CONSTRAINT [CRT_USR_RL_SYS_USR_FK]
GO


ALTER TABLE [dbo].[CRT_USER_ROLE] DROP CONSTRAINT [CRT_USR_RL_RL_FK]
GO


ALTER TABLE [dbo].[CRT_REGION_DISTRICT] DROP CONSTRAINT [CRT_REGION_CRT_REGION_DISTRICT]
GO


ALTER TABLE [dbo].[CRT_ROLE_PERMISSION] DROP CONSTRAINT [CRT_PERMISSION_CRT_ROLE_PERMISSION]
GO


ALTER TABLE [dbo].[CRT_ROLE_PERMISSION] DROP CONSTRAINT [CRT_ROLE_CRT_ROLE_PERMISSION]
GO


/* ---------------------------------------------------------------------- */
/* Add sequences                                                          */
/* ---------------------------------------------------------------------- */

CREATE SEQUENCE [dbo].[PROJECT_ID_SEQ]
  AS bigint 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  9999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_NOTE_ID_SEQ]
  AS bigint 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  99999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[PROJECT_ID_HIST_SEQ]
  AS bigint 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  999999999 
  NO CYCLE
  CACHE 50
GO


/* ---------------------------------------------------------------------- */
/* Alter table "dbo.CRT_REGION"                                           */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_REGION] DROP CONSTRAINT [CRT_REGION_PK]
GO


ALTER TABLE [dbo].[CRT_REGION] DROP CONSTRAINT [CRT_REG_NO_NAME_UK]
GO


ALTER TABLE [dbo].[CRT_REGION] ADD CONSTRAINT [CRT_REGION_PK] 
    PRIMARY KEY CLUSTERED ([REGION_ID])
GO


ALTER TABLE [dbo].[CRT_REGION] ADD CONSTRAINT [CRT_REG_NO_NAME_UK] 
    UNIQUE ([REGION_NUMBER], [REGION_NAME], [END_DATE], [REGION_ID])
GO


EXECUTE sp_updateextendedproperty N'MS_Description', N'Unique ID for a ministry organizational unit (Region) responsible for an exclusive geographic area within the province.  ', 'SCHEMA', N'dbo', 'TABLE', N'CRT_REGION', 'COLUMN', N'REGION_ID'
GO


/* ---------------------------------------------------------------------- */
/* Alter table "dbo.CRT_CODE_LOOKUP"                                      */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_CODE_LOOKUP] DROP CONSTRAINT [CRT_CODE_LKUP_PK]
GO


ALTER TABLE [dbo].[CRT_CODE_LOOKUP] DROP CONSTRAINT [CRT_CODE_LKUP_VAL_NUM_UC]
GO


ALTER TABLE [dbo].[CRT_CODE_LOOKUP] DROP CONSTRAINT [CRT_CODE_LKUP_VAL_TXT_UC]
GO


ALTER TABLE [dbo].[CRT_CODE_LOOKUP] ADD CONSTRAINT [CRT_CODE_LKUP_PK] 
    PRIMARY KEY CLUSTERED ([CODE_LOOKUP_ID])
GO


ALTER TABLE [dbo].[CRT_CODE_LOOKUP] ADD CONSTRAINT [CRT_CODE_LKUP_VAL_NUM_UC] 
    UNIQUE ([CODE_SET], [CODE_VALUE_NUM], [CODE_NAME], [DISPLAY_ORDER])
GO


ALTER TABLE [dbo].[CRT_CODE_LOOKUP] ADD CONSTRAINT [CRT_CODE_LKUP_VAL_TXT_UC] 
    UNIQUE ([CODE_SET], [CODE_VALUE_TEXT], [CODE_NAME], [DISPLAY_ORDER])
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_PROJECT"                                            */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_PROJECT] (
    [PROJECT_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [PROJECT_ID_SEQ] NOT NULL,
    [PROJECT_NUMBER] VARCHAR(50) NOT NULL,
    [PROJECT_NAME] VARCHAR(255) NOT NULL,
    [DESCRIPTION] VARCHAR(2000),
    [SCOPE] VARCHAR(2000),
    [REGION_ID] NUMERIC(9) NOT NULL,
    [CAP_INDX_LKUP_ID] NUMERIC(9),
    [NEARST_TWN_LKUP_ID] NUMERIC(9),
    [RC_LKUP_ID] NUMERIC(9),
    [PROJECT_MGR_ID] NUMERIC(9),
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
    CONSTRAINT [CRT_PROJECT_PK] PRIMARY KEY CLUSTERED ([PROJECT_ID])
)
GO


CREATE NONCLUSTERED INDEX [CRT_PROJECT_FK_I] ON [dbo].[CRT_PROJECT] ([PROJECT_NUMBER] ASC,[CAP_INDX_LKUP_ID] ASC,[NEARST_TWN_LKUP_ID] ASC,[RC_LKUP_ID] ASC,[PROJECT_MGR_ID] ASC)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines CRT projects', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'PROJECT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Number assigned to the project', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'PROJECT_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Name of project', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'PROJECT_NAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Description of the selected project', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'DESCRIPTION'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Scope of the project ', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'SCOPE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Region ID associated with the Ministry regions', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'REGION_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Capital index lookup ID associated with capital indices in the lookup table', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'CAP_INDX_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Nearest town lookup ID is associated with nearest town to the project location. The ID maps to the lookup table', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'NEARST_TWN_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'RC lookup IDs associated with RC numbers', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'RC_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Project manager mapped to system user ID', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'PROJECT_MGR_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the project is completed. This shows is proxy for project status, either active or complete', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_NOTE"                                               */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_NOTE] (
    [NOTE_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_NOTE_ID_SEQ] NOT NULL,
    [NOTE_TYPE] VARCHAR(9) NOT NULL,
    [COMMENT] VARCHAR(max) NOT NULL,
    [PROJECT_ID] NUMERIC(9) NOT NULL,
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
    CONSTRAINT [CRT_NOTE_PK] PRIMARY KEY CLUSTERED ([NOTE_ID])
)
GO


CREATE NONCLUSTERED INDEX [CRT_NOTE_FK_I] ON [dbo].[CRT_NOTE] ([PROJECT_ID] ASC)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines CRT projects', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Identifier for the notes attached to the project.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE', 'COLUMN', N'NOTE_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier that specifies the note type: as either STATUS or EMR', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE', 'COLUMN', N'NOTE_TYPE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Comments on the project', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE', 'COLUMN', N'COMMENT'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_PROJECT_HIST"                                       */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_PROJECT_HIST] (
    [PROJECT_HIST_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [PROJECT_ID_HIST_SEQ] NOT NULL,
    [PROJECT_ID] NUMERIC(9) NOT NULL,
    [PROJECT_NUMBER] VARCHAR(50) NOT NULL,
    [PROJECT_NAME] VARCHAR(255) NOT NULL,
    [DESCRIPTION] VARCHAR(2000),
    [SCOPE] VARCHAR(2000),
    [REGION_ID] NUMERIC(9) NOT NULL,
    [CAP_INDX_LKUP_ID] NUMERIC(9) NOT NULL,
    [NEARST_TWN_LKUP_ID] VARCHAR(9),
    [RC_LKUP_ID] NUMERIC(9),
    [PROJECT_MGR_ID] NUMERIC(9),
    [END_DATE] DATETIME,
    [END_DATE_HIST] DATETIME,
    [EFFECTIVE_DATE_HIST] DATETIME DEFAULT getutcdate() NOT NULL,
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
    CONSTRAINT [CRT_PROJECT_HIST_PK] PRIMARY KEY CLUSTERED ([PROJECT_HIST_ID]),
    CONSTRAINT [CRT_PROJECT_H_UK] UNIQUE ([PROJECT_HIST_ID], [END_DATE_HIST])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines CRT projects', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier tracking Project history', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'PROJECT_HIST_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'PROJECT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Number assigned to the project', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'PROJECT_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Name of project', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'PROJECT_NAME'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Description of the selected project', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'DESCRIPTION'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Scope of the project ', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'SCOPE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Region ID associated with the Ministry regions', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'REGION_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Capital index lookup ID associated with capital indices in the lookup table', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'CAP_INDX_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Nearest town lookup ID is associated with nearest town to the project location. The ID maps to the lookup table', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'NEARST_TWN_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'RC lookup IDs associated with RC numbers', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'RC_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Project manager mapped to system user ID', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'PROJECT_MGR_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the project is completed. This shows is proxy for project status, either active or complete', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'History of projects'' end date', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'END_DATE_HIST'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the history record was logged and finalized', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'EFFECTIVE_DATE_HIST'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
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


ALTER TABLE [dbo].[CRT_PROJECT] ADD CONSTRAINT [CRT_REGION_CRT_PROJECT] 
    FOREIGN KEY ([REGION_ID]) REFERENCES [dbo].[CRT_REGION] ([REGION_ID])
GO


ALTER TABLE [dbo].[CRT_PROJECT] ADD CONSTRAINT [SYSTEM_USER_PROJECT_FK] 
    FOREIGN KEY ([PROJECT_MGR_ID]) REFERENCES [dbo].[CRT_SYSTEM_USER] ([SYSTEM_USER_ID])
GO


ALTER TABLE [dbo].[CRT_PROJECT] ADD CONSTRAINT [CRT_CODE_LOOKUP_PROJECT_CAP_INDX_FK] 
    FOREIGN KEY ([CAP_INDX_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
GO


ALTER TABLE [dbo].[CRT_PROJECT] ADD CONSTRAINT [CRT_CODE_LOOKUP_PROJECT_NRST_TWN_FK] 
    FOREIGN KEY ([NEARST_TWN_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
GO


ALTER TABLE [dbo].[CRT_PROJECT] ADD CONSTRAINT [CRT_CODE_LOOKUP_PROJECT_RC_NUM_FK] 
    FOREIGN KEY ([RC_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
GO


ALTER TABLE [dbo].[CRT_NOTE] ADD CONSTRAINT [CRT_PROJECT_CRT_NOTE] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [dbo].[CRT_PROJECT] ([PROJECT_ID])
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


/* ---------------------------------------------------------------------- */
/* Repair/add triggers                                                    */
/* ---------------------------------------------------------------------- */

/* ---------------------------------------------------------------------- */
/* Repair/add triggers                                                    */
/* ---------------------------------------------------------------------- */

/* ---------------------------------------------------------------------- */
/* Add triggers                                                           */
/* ---------------------------------------------------------------------- */

CREATE TRIGGER [dbo].[CRT_PERM_A_S_IUD_TR] ON CRT_PERMISSION FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  IF EXISTS(SELECT * FROM deleted)
    update CRT_PERMISSION_HIST set END_DATE_HIST = @curr_date where PERMISSION_ID in (select PERMISSION_ID from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT * FROM inserted)
    insert into CRT_PERMISSION_HIST ([PERMISSION_ID], [NAME], [DESCRIPTION], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], PERMISSION_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
      select [PERMISSION_ID], [NAME], [DESCRIPTION], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_PERMISSION_H_ID_SEQ]) as [PERMISSION_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

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
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  IF EXISTS(SELECT * FROM deleted)
    update CRT_ROLE_HIST set END_DATE_HIST = @curr_date where ROLE_ID in (select ROLE_ID from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT * FROM inserted)
    insert into CRT_ROLE_HIST ([ROLE_ID], [NAME], [DESCRIPTION], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], ROLE_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
      select [ROLE_ID], [NAME], [DESCRIPTION], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_ROLE_H_ID_SEQ]) as [ROLE_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_RL_I_S_I_TR] ON CRT_ROLE INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;


  insert into CRT_ROLE ("ROLE_ID",
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
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.ROLE_ID = deleted.ROLE_ID)
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
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  IF EXISTS(SELECT * FROM deleted)
    update CRT_SYSTEM_USER_HIST set END_DATE_HIST = @curr_date where SYSTEM_USER_ID in (select SYSTEM_USER_ID from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT * FROM inserted)
    insert into CRT_SYSTEM_USER_HIST ([SYSTEM_USER_ID], [API_CLIENT_ID], [USER_GUID], [USERNAME], [FIRST_NAME], [LAST_NAME], [EMAIL], [END_DATE], [IS_PROJECT_MGR], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], SYSTEM_USER_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
      select [SYSTEM_USER_ID], [API_CLIENT_ID],[USER_GUID], [USERNAME], [FIRST_NAME], [LAST_NAME], [EMAIL], [END_DATE], [IS_PROJECT_MGR], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_SYSTEM_USER_H_ID_SEQ]) as [SYSTEM_USER_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_SYS_USR_I_S_I_TR] ON CRT_SYSTEM_USER INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;


  insert into CRT_SYSTEM_USER ("SYSTEM_USER_ID",
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
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.SYSTEM_USER_ID = deleted.SYSTEM_USER_ID)
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
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  IF EXISTS(SELECT * FROM deleted)
    update CRT_USER_ROLE_HIST set END_DATE_HIST = @curr_date where USER_ROLE_ID in (select USER_ROLE_ID from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT * FROM inserted)
    insert into CRT_USER_ROLE_HIST ([USER_ROLE_ID], [ROLE_ID], [SYSTEM_USER_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], USER_ROLE_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
      select [USER_ROLE_ID], [ROLE_ID], [SYSTEM_USER_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_USER_ROLE_H_ID_SEQ]) as [USER_ROLE_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_USR_RL_I_S_I_TR] ON CRT_USER_ROLE INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;


  insert into CRT_USER_ROLE ("USER_ROLE_ID",
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
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.USER_ROLE_ID = deleted.USER_ROLE_ID)
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
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;

  -- historical
  IF EXISTS(SELECT * FROM deleted)
    update CRT_REGION_USER_HIST set END_DATE_HIST = @curr_date where REGION_USER_ID in (select REGION_USER_ID from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT * FROM inserted)
    insert into CRT_REGION_USER_HIST ([REGION_USER_ID], [REGION_ID], [SYSTEM_USER_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], REGION_USER_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
      select [REGION_USER_ID], [REGION_ID], [SYSTEM_USER_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_REGION_USER_H_ID_SEQ]) as [REGION_USER_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_REGION_USR_I_S_I_TR] ON CRT_REGION_USER INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;


  insert into CRT_REGION_USER ("REGION_USER_ID",
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


CREATE TRIGGER [dbo].[CRT_PROJECT_A_S_IUD_TR] ON CRT_PROJECT FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  IF EXISTS(SELECT * FROM deleted)
    update CRT_PROJECT_HIST set END_DATE_HIST = @curr_date where PROJECT_ID in (select PROJECT_ID from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT * FROM inserted)
    insert into CRT_PROJECT_HIST ([PROJECT_ID], [PROJECT_NUMBER], [PROJECT_NAME], [DESCRIPTION], [SCOPE], [REGION_ID], [CAP_INDX_LKUP_ID], [NEARST_TWN_LKUP_ID], [RC_LKUP_ID], [PROJECT_MGR_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], PROJECT_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
      select [PROJECT_ID], [PROJECT_NUMBER], [PROJECT_NAME], [DESCRIPTION], [SCOPE], [REGION_ID], [CAP_INDX_LKUP_ID], [NEARST_TWN_LKUP_ID], [RC_LKUP_ID], [PROJECT_MGR_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_PROJECT_H_ID_SEQ]) as [PROJECT_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_PROJECT_I_S_U_TR] ON CRT_PROJECT INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.PROJECT_ID = deleted.PROJECT_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)



  update CRT_PROJECT
    set "PROJECT_ID" = inserted."PROJECT_ID",
	  "PROJECT_NUMBER" = inserted."PROJECT_NUMBER",
	  "PROJECT_NAME" = inserted."PROJECT_NAME",
	  "DESCRIPTION" = inserted."DESCRIPTION",
	  "SCOPE" = inserted."SCOPE",
	  "REGION_ID" = inserted."REGION_ID",
	  "CAP_INDX_LKUP_ID" = inserted."CAP_INDX_LKUP_ID",
	  "NEARST_TWN_LKUP_ID" = inserted."NEARST_TWN_LKUP_ID",
	  "RC_LKUP_ID" = inserted."RC_LKUP_ID",
	  "PROJECT_MGR_ID" = inserted."PROJECT_MGR_ID",
	  "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_PROJECT
    inner join inserted
    on (CRT_PROJECT.PROJECT_ID = inserted.PROJECT_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_PROJECTI_S_I_TR] ON CRT_PROJECT INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;

  insert into CRT_PROJECT ("PROJECT_ID",
	  "PROJECT_NUMBER",
	  "PROJECT_NAME",
	  "DESCRIPTION",
	  "SCOPE",
	  "REGION_ID",
	  "CAP_INDX_LKUP_ID",
	  "NEARST_TWN_LKUP_ID",
	  "RC_LKUP_ID",
	  "PROJECT_MGR_ID",
	  "END_DATE",
      "CONCURRENCY_CONTROL_NUMBER",
      "APP_CREATE_USERID",
      "APP_CREATE_TIMESTAMP",
      "APP_CREATE_USER_GUID",
      "APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID")
    select "PROJECT_ID",
	  "PROJECT_NUMBER",
	  "PROJECT_NAME",
	  "DESCRIPTION",
	  "SCOPE",
	  "REGION_ID",
	  "CAP_INDX_LKUP_ID",
	  "NEARST_TWN_LKUP_ID",
	  "RC_LKUP_ID",
	  "PROJECT_MGR_ID",
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


CREATE TRIGGER [dbo].[CRT_NOTE_I_S_I_TR] ON CRT_NOTE INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;


  insert into NOTE_ID ("NOTE_ID",
  	  "NOTE_TYPE",
  	  "PROJECT_ID",
  	  "COMMENT",
      "CONCURRENCY_CONTROL_NUMBER",
      "APP_CREATE_USERID",
      "APP_CREATE_TIMESTAMP",
      "APP_CREATE_USER_GUID",
      "APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID")
    select "NOTE_ID",
  	  "NOTE_TYPE",
  	  "PROJECT_ID",
  	  "COMMENT",
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


CREATE TRIGGER [dbo].[CRT_NOTE_I_S_U_TR] ON CRT_NOTE INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.NOTE_ID = deleted.NOTE_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)



  update CRT_NOTE
    set "NOTE_ID" = inserted."NOTE_ID",
  	  "NOTE_TYPE" = inserted."NOTE_TYPE",
  	  "PROJECT_ID" = inserted."PROJECT_ID",
  	  "COMMENT" = inserted."COMMENT",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_CREATE_USER_GUID" = inserted."APP_CREATE_USER_GUID",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_NOTE
    inner join inserted
    on (CRT_NOTE.NOTE_ID = inserted.NOTE_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO

