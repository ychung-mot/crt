/* ---------------------------------------------------------------------- */
/* Script generated with: DeZign for Databases 12.1.0                     */
/* Target DBMS:           MS SQL Server 2017                              */
/* Project file:          S03_01_APP_CRT_V1.dez                           */
/* Project name:          Capital Rehabilitation Tracking Reporting       */
/* Author:                Ayodeji Kuponiyi                                */
/* Script type:           Alter database script                           */
/* Created on:            2021-02-04 16:55                                */
/* ---------------------------------------------------------------------- */

USE [CRT_DEV];
GO

/* ---------------------------------------------------------------------- */
/* Drop triggers                                                          */
/* ---------------------------------------------------------------------- */

DROP TRIGGER [dbo].[CRT_PERM_A_S_IUD_TR]
GO


DROP TRIGGER [dbo].[CRT_PROJECT_A_S_IUD_TR]
GO


DROP TRIGGER [dbo].[CRT_PROJECT_I_S_U_TR]
GO


DROP TRIGGER [dbo].[CRT_PROJECTI_S_I_TR]
GO


/* ---------------------------------------------------------------------- */
/* Drop foreign key constraints                                           */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_PROJECT] DROP CONSTRAINT [CRT_CODE_LOOKUP_PROJECT_CAP_INDX_FK]
GO


ALTER TABLE [dbo].[CRT_PROJECT] DROP CONSTRAINT [CRT_CODE_LOOKUP_PROJECT_NRST_TWN_FK]
GO


ALTER TABLE [dbo].[CRT_PROJECT] DROP CONSTRAINT [CRT_CODE_LOOKUP_PROJECT_RC_NUM_FK]
GO


ALTER TABLE [dbo].[CRT_PROJECT] DROP CONSTRAINT [SYSTEM_USER_PROJECT_FK]
GO


ALTER TABLE [dbo].[CRT_PROJECT] DROP CONSTRAINT [CRT_REGION_CRT_PROJECT]
GO


ALTER TABLE [dbo].[CRT_NOTE] DROP CONSTRAINT [CRT_PROJECT_CRT_NOTE]
GO


ALTER TABLE [dbo].[CRT_ROLE_PERMISSION] DROP CONSTRAINT [CRT_PERMISSION_CRT_ROLE_PERMISSION]
GO


/* ---------------------------------------------------------------------- */
/* Add sequences                                                          */
/* ---------------------------------------------------------------------- */

CREATE SEQUENCE [dbo].[CRT_FIN_TARGET_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  99999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_ELEMENT_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  99999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_FIN_TARGET_H_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  99999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_QTY_ACCMP_H_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  99999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_QTY_ACCMP_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  999999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_TENDER_H_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  999999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_TENDER_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  9999999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_ELEMENT_H_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  9999999999 
  NO CYCLE
  CACHE 50
GO


/* ---------------------------------------------------------------------- */
/* Drop and recreate table "dbo.CRT_PROJECT"                              */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_PROJECT] DROP CONSTRAINT [CRT_PROJECT_PK]
GO


CREATE TABLE [dbo].[CRT_PROJECT_TMP]
(
  [PROJECT_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_PROJECT_ID_SEQ] NOT NULL,
  [PROJECT_NUMBER] VARCHAR(50) NOT NULL,
  [PROJECT_NAME] VARCHAR(255) NOT NULL,
  [DESCRIPTION] VARCHAR(2000),
  [SCOPE] VARCHAR(2000),
  [REGION_ID] NUMERIC(9) NOT NULL,
  [CAP_INDX_LKUP_ID] NUMERIC(9),
  [NEARST_TWN_LKUP_ID] NUMERIC(9),
  [RC_LKUP_ID] NUMERIC(9),
  [PROJECT_MGR_ID] NUMERIC(9),
  [ANNCMENT_VALUE] NUMERIC(10,2),
  [C035_VALUE] NUMERIC(10,2),
  [ANNCMENT_COMMENT] VARCHAR(2000),
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
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL
)
GO


INSERT INTO [dbo].[CRT_PROJECT_TMP]
  ([PROJECT_ID],[PROJECT_NUMBER],[PROJECT_NAME],[DESCRIPTION],[SCOPE],[REGION_ID],[CAP_INDX_LKUP_ID],[NEARST_TWN_LKUP_ID],[RC_LKUP_ID],[PROJECT_MGR_ID],[END_DATE],[CONCURRENCY_CONTROL_NUMBER],[APP_CREATE_USERID],[APP_CREATE_TIMESTAMP],[APP_CREATE_USER_GUID],[APP_LAST_UPDATE_USERID],[APP_LAST_UPDATE_TIMESTAMP],[APP_LAST_UPDATE_USER_GUID],[DB_AUDIT_CREATE_USERID],[DB_AUDIT_CREATE_TIMESTAMP],[DB_AUDIT_LAST_UPDATE_USERID],[DB_AUDIT_LAST_UPDATE_TIMESTAMP])
SELECT
  [PROJECT_ID], [PROJECT_NUMBER], [PROJECT_NAME], [DESCRIPTION], [SCOPE], [REGION_ID], [CAP_INDX_LKUP_ID], [NEARST_TWN_LKUP_ID], [RC_LKUP_ID], [PROJECT_MGR_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP]
FROM [dbo].[CRT_PROJECT]
GO


DROP INDEX [dbo].[CRT_PROJECT].[CRT_PROJECT_FK_I]
GO


DROP TABLE [dbo].[CRT_PROJECT]
GO


EXEC sp_rename '[dbo].[CRT_PROJECT_TMP]', 'CRT_PROJECT', 'OBJECT'
GO


ALTER TABLE [dbo].[CRT_PROJECT] ADD CONSTRAINT [CRT_PROJECT_PK] 
    PRIMARY KEY CLUSTERED ([PROJECT_ID])
GO


CREATE NONCLUSTERED INDEX [CRT_PROJECT_FK_I] ON [dbo].[CRT_PROJECT] ([PROJECT_NUMBER] ASC,[CAP_INDX_LKUP_ID] ASC,[NEARST_TWN_LKUP_ID] ASC,[RC_LKUP_ID] ASC,[PROJECT_MGR_ID] ASC)
GO


/* ---------------------------------------------------------------------- */
/* Drop and recreate table "dbo.CRT_PROJECT_HIST"                         */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_PROJECT_HIST] DROP CONSTRAINT [CRT_PROJECT_HIST_PK]
GO


ALTER TABLE [dbo].[CRT_PROJECT_HIST] DROP CONSTRAINT [CRT_PROJECT_H_UK]
GO


CREATE TABLE [dbo].[CRT_PROJECT_HIST_TMP]
(
  [PROJECT_HIST_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_PROJECT_H_ID_SEQ] NOT NULL,
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
  [ANNCMENT_VALUE] NUMERIC(10,2),
  [C035_VALUE] NUMERIC(10,2),
  [ANNCMENT_COMMENT] VARCHAR(2000),
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
  [DB_AUDIT_LAST_UPDATE_TIMESTAMP] DATETIME DEFAULT getutcdate() NOT NULL
)
GO


INSERT INTO [dbo].[CRT_PROJECT_HIST_TMP]
  ([PROJECT_HIST_ID],[PROJECT_ID],[PROJECT_NUMBER],[PROJECT_NAME],[DESCRIPTION],[SCOPE],[REGION_ID],[CAP_INDX_LKUP_ID],[NEARST_TWN_LKUP_ID],[RC_LKUP_ID],[PROJECT_MGR_ID],[END_DATE],[END_DATE_HIST],[EFFECTIVE_DATE_HIST],[CONCURRENCY_CONTROL_NUMBER],[APP_CREATE_USERID],[APP_CREATE_TIMESTAMP],[APP_CREATE_USER_GUID],[APP_LAST_UPDATE_USERID],[APP_LAST_UPDATE_TIMESTAMP],[APP_LAST_UPDATE_USER_GUID],[DB_AUDIT_CREATE_USERID],[DB_AUDIT_CREATE_TIMESTAMP],[DB_AUDIT_LAST_UPDATE_USERID],[DB_AUDIT_LAST_UPDATE_TIMESTAMP])
SELECT
  [PROJECT_HIST_ID], [PROJECT_ID], [PROJECT_NUMBER], [PROJECT_NAME], [DESCRIPTION], [SCOPE], [REGION_ID], [CAP_INDX_LKUP_ID], [NEARST_TWN_LKUP_ID], [RC_LKUP_ID], [PROJECT_MGR_ID], [END_DATE], [END_DATE_HIST], [EFFECTIVE_DATE_HIST], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP]
FROM [dbo].[CRT_PROJECT_HIST]
GO


DROP TABLE [dbo].[CRT_PROJECT_HIST]
GO


EXEC sp_rename '[dbo].[CRT_PROJECT_HIST_TMP]', 'CRT_PROJECT_HIST', 'OBJECT'
GO


ALTER TABLE [dbo].[CRT_PROJECT_HIST] ADD CONSTRAINT [CRT_PROJECT_HIST_PK] 
    PRIMARY KEY CLUSTERED ([PROJECT_HIST_ID])
GO


ALTER TABLE [dbo].[CRT_PROJECT_HIST] ADD CONSTRAINT [CRT_PROJECT_H_UK] 
    UNIQUE ([PROJECT_HIST_ID], [END_DATE_HIST])
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_FIN_TARGET"                                         */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_FIN_TARGET]
(
  [FIN_TARGET_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_FIN_TARGET_ID_SEQ] NOT NULL,
  [PROJECT_ID] NUMERIC(9) NOT NULL,
  [DESCRIPTION] VARCHAR(2000),
  [AMOUNT] NUMERIC(10,2) DEFAULT 0,
  [FISCAL_YEAR_LKUP_ID] NUMERIC(9) NOT NULL,
  [ELEMENT_ID] NUMERIC(9) NOT NULL,
  [PHASE_LKUP_ID] NUMERIC(9) NOT NULL,
  [FORECAST_TYPE_LKUP_ID] NUMERIC(9) NOT NULL,
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
  CONSTRAINT [CRT_FIN_TARGET_PK] PRIMARY KEY CLUSTERED ([FIN_TARGET_ID])
)
GO


CREATE NONCLUSTERED INDEX [CRT_FIN_TARGET_FK_I] ON [dbo].[CRT_FIN_TARGET] ([FISCAL_YEAR_LKUP_ID] ASC,[PHASE_LKUP_ID] ASC)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines CRT financial targets', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'FIN_TARGET_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Description of the selected financial target - planning to be completed in the next fiscal year', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'DESCRIPTION'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Dollar value associated with financial target', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'AMOUNT'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Fiscal Year lookup ID associated with Financial Target ', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'FISCAL_YEAR_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Project Element ID FK', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'ELEMENT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Project phase identifier on the lookup table', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'PHASE_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Forecast type allows users to plan their program outside the bounds of current fiscal/allocation	', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'FORECAST_TYPE_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the project is completed. This shows is proxy for project status, either active or complete', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_ELEMENT"                                            */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_ELEMENT]
(
  [ELEMENT_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_ELEMENT_ID_SEQ] NOT NULL,
  [CODE] VARCHAR(40) NOT NULL,
  [DESCRIPTION] VARCHAR(255) NOT NULL,
  [COMMENT] VARCHAR(2000),
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
  CONSTRAINT [CRT_ELMNT_PK] PRIMARY KEY CLUSTERED ([ELEMENT_ID])
)
GO


CREATE NONCLUSTERED INDEX [CRT_PROJECT_ELEM_FK_I] ON [dbo].[CRT_ELEMENT] ([ELEMENT_ID],[CODE])
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines CRT project elements', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'ELEMENT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for element code', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'CODE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Description of project element', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'DESCRIPTION'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Comment on project element', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'COMMENT'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the project is completed. This shows is proxy for project status, either active or complete', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_QTY_ACCMP"                                          */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_QTY_ACCMP]
(
  [QTY_ACCMP_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_QTY_ACCMP_ID_SEQ] NOT NULL,
  [PROJECT_ID] NUMERIC(9) NOT NULL,
  [FISCAL_YEAR_LKUP_ID] NUMERIC(9) NOT NULL,
  [QTY_ACCMP_LKUP_ID] NUMERIC(9) NOT NULL,
  [FORECAST] NUMERIC(10,3) DEFAULT 0 NOT NULL,
  [SCHEDULE7] NUMERIC(10,3),
  [ACTUAL] NUMERIC(10,3) NOT NULL,
  [COMMENT] VARCHAR(2000),
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
  CONSTRAINT [CRT_QTY_ACCMP_PK] PRIMARY KEY CLUSTERED ([QTY_ACCMP_ID])
)
GO


CREATE NONCLUSTERED INDEX [CRT_QTY_ACCMP_FK_I] ON [dbo].[CRT_QTY_ACCMP] ([PROJECT_ID] ASC,[QTY_ACCMP_LKUP_ID] ASC)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines CRT project quantity and accomplishment', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'QTY_ACCMP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'ID linked with the project', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'PROJECT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier linked with fiscal year on the look up table', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'FISCAL_YEAR_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier linked with the look up table offering extra attributes', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'QTY_ACCMP_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'forecast value associated with quantity or accomplishment', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'FORECAST'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'determined value of quantity before the actual. Can only apply to quantity', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'SCHEDULE7'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'actual value of quantity or accomplishment.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'ACTUAL'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'comments on entries associated with either quantity or accomplishment', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'COMMENT'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Marks the status of quantity and/or accomplishment item', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_TENDER"                                             */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_TENDER]
(
  [TENDER_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_TENDER_ID_SEQ] NOT NULL,
  [PROJECT_ID] NUMERIC(9) NOT NULL,
  [TENDER_NUMBER] VARCHAR(40) NOT NULL,
  [PLANNED_DATE] DATE DEFAULT '0',
  [ACTUAL_DATE] DATE,
  [TENDER_VALUE] NUMERIC(10,3) NOT NULL,
  [WINNING_CNTRCTR_LKUP_ID] NUMERIC(9) NOT NULL,
  [BID_VALUE] NUMERIC(10,3),
  [COMMENT] VARCHAR(2000),
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
  CONSTRAINT [CRT_TENDER_PK] PRIMARY KEY CLUSTERED ([TENDER_ID])
)
GO


CREATE NONCLUSTERED INDEX [CRT_TENDER_FK_I] ON [dbo].[CRT_TENDER] ([PROJECT_ID] ASC,[TENDER_NUMBER] ASC)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines CRT tender for the project', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'TENDER_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'ID linked with the project', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'PROJECT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Number associated with a tender', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'TENDER_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the tender is planned for', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'PLANNED_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date that tender actually takes place', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'ACTUAL_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Dollar value of tender', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'TENDER_VALUE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for the winning contractor of the tender', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'WINNING_CNTRCTR_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Bid amount in response to tender', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'BID_VALUE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Comments on the tender item', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'COMMENT'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the project is completed. This shows is proxy for project status, either active or complete', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_FIN_TARGET_HIST"                                    */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_FIN_TARGET_HIST]
(
  [FIN_TARGET_HIST_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_FIN_TARGET_H_ID_SEQ] NOT NULL,
  [FIN_TARGET_ID] NUMERIC(9) NOT NULL,
  [PROJECT_ID] NUMERIC(9) NOT NULL,
  [DESCRIPTION] VARCHAR(2000),
  [AMOUNT] NUMERIC(10,2) DEFAULT 0,
  [FISCAL_YEAR_LKUP_ID] NUMERIC(9),
  [ELEMENT_ID] NUMERIC(9),
  [PHASE_LKUP_ID] NUMERIC(9),
  [FORECAST_TYPE_LKUP_ID] NUMERIC(9),
  [EFFECTIVE_DATE_HIST] DATETIME DEFAULT getutcdate() NOT NULL,
  [END_DATE] DATETIME,
  [END_DATE_HIST] DATETIME,
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
  CONSTRAINT [CRT_FIN_TARGET_HIST_PK] PRIMARY KEY CLUSTERED ([FIN_TARGET_HIST_ID])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines CRT financial targets', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'FIN_TARGET_HIST_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'FIN_TARGET_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'ID linked with the project', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'PROJECT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Description of the selected financial target - planning to be completed in the next fiscal year', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'DESCRIPTION'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Dollar value associated with financial target', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'AMOUNT'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Fiscal Year lookup ID associated with Financial Target ', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'FISCAL_YEAR_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Project Element ID FK', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'ELEMENT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Project phase identifier on the lookup table', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'PHASE_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Forecast type allows users to plan their program outside the bounds of current fiscal/allocation	', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'FORECAST_TYPE_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the project is completed. This shows is proxy for project status, either active or complete', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_QTY_ACCMP_HIST"                                     */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_QTY_ACCMP_HIST]
(
  [QTY_ACCMP_HIST_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_QTY_ACCMP_H_ID_SEQ] NOT NULL,
  [QTY_ACCMP_ID] NUMERIC(9) NOT NULL,
  [PROJECT_ID] NUMERIC(9) NOT NULL,
  [FISCAL_YEAR_LKUP_ID] NUMERIC(9),
  [QTY_ACCMP_LKUP_ID] NUMERIC(9),
  [FORECAST] NUMERIC(10,3) DEFAULT 0,
  [SCHEDULE7] NUMERIC(10,3),
  [ACTUAL] NUMERIC(10,3),
  [COMMENT] VARCHAR(2000),
  [EFFECTIVE_DATE_HIST] DATETIME DEFAULT getutcdate() NOT NULL,
  [END_DATE] DATETIME,
  [END_DATE_HIST] DATETIME,
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
  CONSTRAINT [CRT_QTY_ACCMP_HIST_PK] PRIMARY KEY CLUSTERED ([QTY_ACCMP_HIST_ID])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines CRT project quantity and accomplishment', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'QTY_ACCMP_HIST_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'QTY_ACCMP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'ID linked with the project', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'PROJECT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier linked with fiscal year on the look up table', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'FISCAL_YEAR_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Fiscal Year lookup ID associated with Financial Target ', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'QTY_ACCMP_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Dollar value associated with financial target', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'FORECAST'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Forecast type allows users to plan their program outside the bounds of current fiscal/allocation	', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'SCHEDULE7'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Project Element ID FK', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'ACTUAL'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Description of the selected financial target - planning to be completed in the next fiscal year', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'COMMENT'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the project is completed. This shows is proxy for project status, either active or complete', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_QTY_ACCMP_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_TENDER_HIST"                                        */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_TENDER_HIST]
(
  [TENDER_HIST_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_TENDER_H_ID_SEQ] NOT NULL,
  [TENDER_ID] NUMERIC(9) NOT NULL,
  [PROJECT_ID] NUMERIC(9) NOT NULL,
  [TENDER_NUMBER] VARCHAR(40),
  [PLANNED_DATE] DATE DEFAULT '0',
  [ACTUAL_DATE] DATE,
  [TENDER_VALUE] NUMERIC(10,3),
  [WINNING_CNTRCTR_LKUP_ID] NUMERIC(9) NOT NULL,
  [BID_VALUE] NUMERIC(10,3),
  [COMMENT] VARCHAR(2000),
  [EFFECTIVE_DATE_HIST] DATETIME DEFAULT getutcdate(),
  [END_DATE] DATETIME,
  [END_DATE_HIST] DATETIME,
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
  CONSTRAINT [CRT_TENDER_HIST_PK] PRIMARY KEY CLUSTERED ([TENDER_HIST_ID])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines CRT tender for the project', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'TENDER_HIST_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'TENDER_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'ID linked with the project', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'PROJECT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Number associated with a tender', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'TENDER_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the tender is planned for', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'PLANNED_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date that tender actually takes place', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'ACTUAL_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Dollar value of tender', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'TENDER_VALUE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for the winning contractor of the tender', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'WINNING_CNTRCTR_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Bid amount in response to tender', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'BID_VALUE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Comments on the tender item', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'COMMENT'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the project is completed. This shows is proxy for project status, either active or complete', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_ELEMENT_HIST"                                       */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_ELEMENT_HIST]
(
  [ELEMENT_HIST_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_ELEMENT_H_ID_SEQ] NOT NULL,
  [ELEMENT_ID] NUMERIC(9) NOT NULL,
  [CODE] VARCHAR(40) NOT NULL,
  [DESCRIPTION] VARCHAR(255) NOT NULL,
  [COMMENT] VARCHAR(2000),
  [EFFECTIVE_DATE_HIST] DATETIME DEFAULT getutcdate() NOT NULL,
  [END_DATE] DATETIME,
  [END_DATE_HIST] DATETIME,
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
  CONSTRAINT [CRT_ELEMENT_HIST_PK] PRIMARY KEY CLUSTERED ([ELEMENT_HIST_ID])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines CRT project element history', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'ELEMENT_HIST_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'ELEMENT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for element code', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'CODE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Description of project element', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'DESCRIPTION'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Comment on project element', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'COMMENT'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the project is completed. This shows is proxy for project status, either active or complete', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_ELEMENT_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add foreign key constraints                                            */
/* ---------------------------------------------------------------------- */

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


ALTER TABLE [dbo].[CRT_FIN_TARGET] ADD CONSTRAINT [CRT_ELEMENT_CRT_FIN_TARGET] 
    FOREIGN KEY ([ELEMENT_ID]) REFERENCES [dbo].[CRT_ELEMENT] ([ELEMENT_ID])
GO


ALTER TABLE [dbo].[CRT_FIN_TARGET] ADD CONSTRAINT [CRT_PROJECT_CRT_FIN_TARGET] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [dbo].[CRT_PROJECT] ([PROJECT_ID])
GO


ALTER TABLE [dbo].[CRT_FIN_TARGET] ADD CONSTRAINT [CRT_CODE_LOOKUP_CRT_FIN_TARGET_FSCL_YR] 
    FOREIGN KEY ([FISCAL_YEAR_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
GO


ALTER TABLE [dbo].[CRT_FIN_TARGET] ADD CONSTRAINT [CRT_CODE_LOOKUP_CRT_FIN_TARGET_PHS] 
    FOREIGN KEY ([PHASE_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
GO


ALTER TABLE [dbo].[CRT_FIN_TARGET] ADD CONSTRAINT [CRT_CODE_LOOKUP_CRT_FIN_TARGET_FCST_TYP] 
    FOREIGN KEY ([FORECAST_TYPE_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
GO


ALTER TABLE [dbo].[CRT_QTY_ACCMP] ADD CONSTRAINT [CRT_PROJECT_CRT_QTY_ACCMP] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [dbo].[CRT_PROJECT] ([PROJECT_ID])
GO


ALTER TABLE [dbo].[CRT_QTY_ACCMP] ADD CONSTRAINT [CRT_CODE_LOOKUP_CRT_QTY_ACCMP_FSCL_YR] 
    FOREIGN KEY ([FISCAL_YEAR_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
GO


ALTER TABLE [dbo].[CRT_QTY_ACCMP] ADD CONSTRAINT [CRT_CODE_LOOKUP_CRT_QTY_ACCMP_QTY_ACCMP] 
    FOREIGN KEY ([QTY_ACCMP_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
GO


ALTER TABLE [dbo].[CRT_TENDER] ADD CONSTRAINT [CRT_PROJECT_CRT_TENDER] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [dbo].[CRT_PROJECT] ([PROJECT_ID])
GO


ALTER TABLE [dbo].[CRT_TENDER] ADD CONSTRAINT [CRT_CODE_LOOKUP_CRT_TENDER] 
    FOREIGN KEY ([WINNING_CNTRCTR_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
GO


ALTER TABLE [dbo].[CRT_ROLE_PERMISSION] ADD CONSTRAINT [CRT_PERMISSION_CRT_ROLE_PERMISSION] 
    FOREIGN KEY ([PERMISSION_ID]) REFERENCES [dbo].[CRT_PERMISSION] ([PERMISSION_ID])
GO


ALTER TABLE [dbo].[CRT_NOTE] ADD CONSTRAINT [CRT_PROJECT_CRT_NOTE] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [dbo].[CRT_PROJECT] ([PROJECT_ID])
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
   EXEC crt_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_PROJECT_A_S_IUD_TR] ON CRT_PROJECT FOR INSERT, UPDATE, DELETE AS
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
    update CRT_PROJECT_HIST set END_DATE_HIST = @curr_date where PROJECT_ID in (select PROJECT_ID
  from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT *
FROM inserted)
    insert into CRT_PROJECT_HIST
  ([PROJECT_ID], [PROJECT_NUMBER], [PROJECT_NAME], [DESCRIPTION], [SCOPE], [REGION_ID], [CAP_INDX_LKUP_ID], [NEARST_TWN_LKUP_ID], [RC_LKUP_ID], [PROJECT_MGR_ID], [ANNCMENT_VALUE], [C035_VALUE], [ANNCMENT_COMMENT], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], PROJECT_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
select [PROJECT_ID], [PROJECT_NUMBER], [PROJECT_NAME], [DESCRIPTION], [SCOPE], [REGION_ID], [CAP_INDX_LKUP_ID], [NEARST_TWN_LKUP_ID], [RC_LKUP_ID], [PROJECT_MGR_ID], [ANNCMENT_VALUE], [C035_VALUE], [ANNCMENT_COMMENT], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_PROJECT_H_ID_SEQ]) as [PROJECT_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_PROJECT_I_S_U_TR] ON CRT_PROJECT INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;


  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.PROJECT_ID = deleted.PROJECT_ID)
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
	  "ANNCMENT_VALUE " = inserted."ANNCMENT_VALUE ",
	  "C035_VALUE" = inserted."C035_VALUE",
	  "ANNCMENT_COMMENT" = inserted."ANNCMENT_COMMENT",
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
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;

  insert into CRT_PROJECT
  ("PROJECT_ID",
  "PROJECT_NUMBER",
  "PROJECT_NAME",
  "DESCRIPTION",
  "SCOPE",
  "REGION_ID",
  "CAP_INDX_LKUP_ID",
  "NEARST_TWN_LKUP_ID",
  "RC_LKUP_ID",
  "PROJECT_MGR_ID",
  "ANNCMENT_VALUE",
  "C035_VALUE",
  "ANNCMENT_COMMENT",
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
  "ANNCMENT_VALUE",
  "C035_VALUE",
  "ANNCMENT_COMMENT",
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


CREATE TRIGGER [dbo].[CRT_FIN_TRGT_A_S_IUD_TR] ON CRT_FIN_TARGET FOR INSERT, UPDATE, DELETE AS
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
    update CRT_FIN_TARGET_HIST set END_DATE_HIST = @curr_date where FIN_TARGET_ID in (select FIN_TARGET_ID
  from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT *
FROM inserted)
    insert into CRT_FIN_TARGET_HIST
  ([FIN_TARGET_ID], [PROJECT_ID], [DESCRIPTION], [AMOUNT], [FISCAL_YEAR_LKUP_ID], [ELEMENT_ID], [PHASE_LKUP_ID], [FORECAST_TYPE_LKUP_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], [FIN_TARGET_HIST_ID], [END_DATE_HIST], [EFFECTIVE_DATE_HIST])

select [FIN_TARGET_ID], [PROJECT_ID], [DESCRIPTION], [AMOUNT], [FISCAL_YEAR_LKUP_ID], [ELEMENT_ID], [PHASE_LKUP_ID], [FORECAST_TYPE_LKUP_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_FIN_TARGET_H_ID_SEQ]) as [FIN_TARGET_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_FIN_TRGT_I_S_U_TR] ON CRT_FIN_TARGET INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;


  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.FIN_TARGET_ID = deleted.FIN_TARGET_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)

  update CRT_FIN_TARGET
    set "FIN_TARGET_ID" = inserted."FIN_TARGET_ID",
	  "PROJECT_ID" = inserted."PROJECT_ID",
	  "DESCRIPTION" = inserted."DESCRIPTION",
	  "AMOUNT" = inserted."AMOUNT",
	  "FISCAL_YEAR_LKUP_ID" = inserted."FISCAL_YEAR_LKUP_ID",
	  "ELEMENT_ID" = inserted."ELEMENT_ID",
	  "PHASE_LKUP_ID" = inserted."PHASE_LKUP_ID",
	  "FORECAST_TYPE_LKUP_ID" = inserted."FORECAST_TYPE_LKUP_ID",
	  "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_FIN_TARGET
  inner join inserted
  on (CRT_FIN_TARGET.FIN_TARGET_ID = inserted.FIN_TARGET_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_FIN_TRGT_I_S_I_TR] ON CRT_FIN_TARGET INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;

  insert into CRT_FIN_TARGET
  ("FIN_TARGET_ID",
  "PROJECT_ID",
  "DESCRIPTION",
  "AMOUNT",
  "FISCAL_YEAR_LKUP_ID",
  "ELEMENT_ID",
  "PHASE_LKUP_ID",
  "FORECAST_TYPE_LKUP_ID",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID")
select "FIN_TARGET_ID",
  "PROJECT_ID",
  "DESCRIPTION",
  "AMOUNT",
  "FISCAL_YEAR_LKUP_ID",
  "ELEMENT_ID",
  "PHASE_LKUP_ID",
  "FORECAST_TYPE_LKUP_ID",
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


CREATE TRIGGER [dbo].[CRT_ELEMENT_A_S_IUD_TR] ON CRT_ELEMENT FOR INSERT, UPDATE, DELETE AS
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
    update CRT_ELEMENT_HIST set END_DATE_HIST = @curr_date where ELEMENT_ID in (select ELEMENT_ID
  from deleted) and END_DATE_HIST is null;


  IF EXISTS(SELECT *
FROM inserted)
    insert into CRT_ELEMENT_HIST
  ([ELEMENT_ID], [DESCRIPTION], [CODE], [COMMENT], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], ELEMENT_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
select [ELEMENT_ID], [DESCRIPTION], [CODE], [COMMENT], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_ELEMENT_H_ID_SEQ]) as [ELEMENT_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_ELEMENT_I_S_U_TR] ON CRT_ELEMENT INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;


  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.ELEMENT_ID = deleted.ELEMENT_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)



  update CRT_ELEMENT
    set "ELEMENT_ID" = inserted."ELEMENT_ID", 
	  "DESCRIPTION" = inserted."DESCRIPTION", 
	  "CODE" = inserted."CODE", 
	  "COMMENT" = inserted."COMMENT",
	  "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_ELEMENT
  inner join inserted
  on (CRT_ELEMENT.ELEMENT_ID = inserted.ELEMENT_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_ELEMENT_I_S_I_TR] ON CRT_ELEMENT INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;

  insert into CRT_ELEMENT
  ("ELEMENT_ID",
  "DESCRIPTION",
  "CODE",
  "COMMENT",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID")
select "ELEMENT_ID",
  "DESCRIPTION",
  "CODE",
  "COMMENT",
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


CREATE TRIGGER [dbo].[CRT_QTY_ACCMP_A_S_IUD_TR] ON CRT_QTY_ACCMP FOR INSERT, UPDATE, DELETE AS
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
    update CRT_QTY_ACCMP_HIST set END_DATE_HIST = @curr_date where QTY_ACCMP_ID in (select QTY_ACCMP_ID
  from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT *
FROM inserted)
    insert into CRT_QTY_ACCMP_HIST
  ([QTY_ACCMP_ID], [PROJECT_ID], [FISCAL_YEAR_LKUP_ID], [QTY_ACCMP_LKUP_ID], [FORECAST], [SCHEDULE7], [ACTUAL], [COMMENT], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], [QTY_ACCMP_HIST_ID], [END_DATE_HIST], [EFFECTIVE_DATE_HIST])

select [QTY_ACCMP_ID], [PROJECT_ID], [FISCAL_YEAR_LKUP_ID], [QTY_ACCMP_LKUP_ID], [FORECAST], [SCHEDULE7], [ACTUAL], [COMMENT], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_QTY_ACCMP_H_ID_SEQ]) as [QTY_ACCMP_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_QTY_ACCMP_I_S_U_TR] ON CRT_QTY_ACCMP INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.QTY_ACCMP_ID = deleted.QTY_ACCMP_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)


  -- update statement
  update CRT_QTY_ACCMP
    set "QTY_ACCMP_ID" = inserted."QTY_ACCMP_ID",
	  "PROJECT_ID" = inserted."PROJECT_ID",
	  "FISCAL_YEAR_LKUP_ID" = inserted."FISCAL_YEAR_LKUP_ID",
	  "QTY_ACCMP_LKUP_ID" = inserted."QTY_ACCMP_LKUP_ID",
	  "FORECAST" = inserted."FORECAST",
  	  "SCHEDULE7" = inserted."SCHEDULE7",
	  "ACTUAL" = inserted."ACTUAL",
	  "COMMENT" = inserted."COMMENT",
	  "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_QTY_ACCMP
  inner join inserted
  on (CRT_QTY_ACCMP.QTY_ACCMP_ID = inserted.QTY_ACCMP_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_QTY_ACCMP_I_S_I_TR] ON CRT_QTY_ACCMP INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;

  insert into CRT_QTY_ACCMP
  ("QTY_ACCMP_ID",
  "PROJECT_ID",
  "FISCAL_YEAR_LKUP_ID",
  "QTY_ACCMP_LKUP_ID",
  "FORECAST",
  "SCHEDULE7",
  "ACTUAL",
  "COMMENT",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID")
select "QTY_ACCMP_ID",
  "PROJECT_ID",
  "FISCAL_YEAR_LKUP_ID",
  "QTY_ACCMP_LKUP_ID",
  "FORECAST",
  "SCHEDULE7",
  "ACTUAL",
  "COMMENT",
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


CREATE TRIGGER [dbo].[CRT_TENDER_A_S_IUD_TR] ON CRT_TENDER FOR INSERT, UPDATE, DELETE AS
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
    update CRT_TENDER_HIST set END_DATE_HIST = @curr_date where TENDER_ID in (select TENDER_ID
  from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT *
FROM inserted)
    insert into CRT_TENDER_HIST
  ([TENDER_ID], [PROJECT_ID], [TENDER_NUMBER], [PLANNED_DATE], [ACTUAL_DATE], [TENDER_VALUE], [WINNING_CNTRCTR_LKUP_ID], [BID_VALUE], [COMMENT], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], [TENDER_HIST_ID], [END_DATE_HIST], [EFFECTIVE_DATE_HIST])

select [TENDER_ID], [PROJECT_ID], [TENDER_NUMBER], [PLANNED_DATE], [ACTUAL_DATE], [TENDER_VALUE], [WINNING_CNTRCTR_LKUP_ID], [BID_VALUE], [COMMENT], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_TENDER_H_ID_SEQ]) as [TENDER_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_TENDER_I_S_U_TR] ON CRT_TENDER INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.TENDER_ID = deleted.TENDER_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)


  -- update statement
  update CRT_TENDER
    set "TENDER_ID" = inserted."TENDER_ID",
	  "PROJECT_ID" = inserted."PROJECT_ID",
	  "TENDER_NUMBER" = inserted."TENDER_NUMBER",  
	  "PLANNED_DATE" = inserted."PLANNED_DATE",
	  "ACTUAL_DATE" = inserted."ACTUAL_DATE",
	  "TENDER_VALUE" = inserted."TENDER_VALUE",
	  "WINNING_CNTRCTR_LKUP_ID" = inserted."WINNING_CNTRCTR_LKUP_ID",
	  "BID_VALUE" = inserted."BID_VALUE",
	  "COMMENT" = inserted."COMMENT",
	  "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_TENDER
  inner join inserted
  on (CRT_TENDER.TENDER_ID = inserted.TENDER_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH;
GO


CREATE TRIGGER [dbo].[CRT_TENDER_I_S_I_TR] ON CRT_TENDER INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;

  insert into CRT_TENDER
  ("TENDER_ID",
  "PROJECT_ID",
  "TENDER_NUMBER",
  "PLANNED_DATE",
  "ACTUAL_DATE",
  "TENDER_VALUE",
  "WINNING_CNTRCTR_LKUP_ID",
  "BID_VALUE",
  "COMMENT",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID")
select "TENDER_ID",
  "PROJECT_ID",
  "TENDER_NUMBER",
  "PLANNED_DATE",
  "ACTUAL_DATE",
  "TENDER_VALUE",
  "WINNING_CNTRCTR_LKUP_ID",
  "BID_VALUE",
  "COMMENT",
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

