/* ---------------------------------------------------------------------- */
/* Script generated with: DeZign for Databases 12.1.0                     */
/* Target DBMS:           MS SQL Server 2017                              */
/* Project file:          S03_05_APP_CRT_V2.dez                           */
/* Project name:          Capital Rehabilitation Tracking Reporting       */
/* Author:                Ayodeji Kuponiyi                                */
/* Script type:           Alter database script                           */
/* Created on:            2021-02-19 13:17                                */
/* ---------------------------------------------------------------------- */



USE CRT_DEVDB;
GO

/*
Changes:
 CRT_TENDER and CRT_TENDER_HIST
	- updated the description from omment to comment
	
 CRT_PROJECT and CRT_PROJECT_HIST
	- reloaded column description from model to DB
	- Announcement Comment from varchar(2000) to varchar(max)
	- changed CAP_INDX_LKUP_ID to nullable on CRT_PROJECT_HIST table

 CRT_FIN_TARGET and CRT_FIN_TARGET_HIST
	- changed FORECAST_TYPE_LKUP_ID to FUNDING_TYPE_LKUP_ID
	
 CRT_QTY_ACCMP
	- changed FORECAST AND ACTUAL to nullable
 
*/


/* ---------------------------------------------------------------------- */
/* Drop triggers                                                          */
/* ---------------------------------------------------------------------- */

DROP TRIGGER [dbo].[CRT_FIN_TRGT_A_S_IUD_TR]
GO


DROP TRIGGER [dbo].[CRT_FIN_TRGT_I_S_I_TR]
GO


DROP TRIGGER [dbo].[CRT_FIN_TRGT_I_S_U_TR]
GO


DROP TRIGGER [dbo].[CRT_PROJECT_I_S_U_TR]
GO


DROP TRIGGER [dbo].[CRT_PROJECTI_S_I_TR]
GO


DROP TRIGGER [dbo].[CRT_QTY_ACCMP_A_S_IUD_TR]
GO


DROP TRIGGER [dbo].[CRT_QTY_ACCMP_I_S_I_TR]
GO


DROP TRIGGER [dbo].[CRT_TENDER_A_S_IUD_TR]
GO


DROP TRIGGER [dbo].[CRT_TENDER_I_S_I_TR]
GO


DROP TRIGGER [dbo].[CRT_TENDER_I_S_U_TR]
GO


/* ---------------------------------------------------------------------- */
/* Drop foreign key constraints                                           */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_FIN_TARGET] DROP CONSTRAINT [CRT_CODE_LOOKUP_CRT_FIN_TARGET_FSCL_YR]
GO


ALTER TABLE [dbo].[CRT_FIN_TARGET] DROP CONSTRAINT [CRT_CODE_LOOKUP_CRT_FIN_TARGET_PHS]
GO


ALTER TABLE [dbo].[CRT_FIN_TARGET] DROP CONSTRAINT [CRT_CODE_LOOKUP_CRT_FIN_TARGET_FCST_TYP]
GO


ALTER TABLE [dbo].[CRT_FIN_TARGET] DROP CONSTRAINT [CRT_PROJECT_CRT_FIN_TARGET]
GO


ALTER TABLE [dbo].[CRT_FIN_TARGET] DROP CONSTRAINT [CRT_ELEMENT_CRT_FIN_TARGET]
GO


ALTER TABLE [dbo].[CRT_PROJECT] DROP CONSTRAINT [SYSTEM_USER_PROJECT_FK]
GO


ALTER TABLE [dbo].[CRT_PROJECT] DROP CONSTRAINT [CRT_CODE_LOOKUP_PROJECT_CAP_INDX_FK]
GO


ALTER TABLE [dbo].[CRT_PROJECT] DROP CONSTRAINT [CRT_CODE_LOOKUP_PROJECT_NRST_TWN_FK]
GO


ALTER TABLE [dbo].[CRT_PROJECT] DROP CONSTRAINT [CRT_CODE_LOOKUP_PROJECT_RC_NUM_FK]
GO


ALTER TABLE [dbo].[CRT_PROJECT] DROP CONSTRAINT [CRT_REGION_CRT_PROJECT]
GO


ALTER TABLE [dbo].[CRT_QTY_ACCMP] DROP CONSTRAINT [CRT_PROJECT_CRT_QTY_ACCMP]
GO


ALTER TABLE [dbo].[CRT_QTY_ACCMP] DROP CONSTRAINT [CRT_CODE_LOOKUP_CRT_QTY_ACCMP_FSCL_YR]
GO


ALTER TABLE [dbo].[CRT_QTY_ACCMP] DROP CONSTRAINT [CRT_CODE_LOOKUP_CRT_QTY_ACCMP_QTY_ACCMP]
GO


ALTER TABLE [dbo].[CRT_TENDER] DROP CONSTRAINT [CRT_PROJECT_CRT_TENDER]
GO


ALTER TABLE [dbo].[CRT_TENDER] DROP CONSTRAINT [CRT_CODE_LOOKUP_CRT_TENDER]
GO


ALTER TABLE [dbo].[CRT_NOTE] DROP CONSTRAINT [CRT_PROJECT_CRT_NOTE]
GO


/* ---------------------------------------------------------------------- */
/* Alter table "dbo.CRT_PROJECT"                                          */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_PROJECT] DROP CONSTRAINT [CRT_PROJECT_PK]
GO


ALTER TABLE [dbo].[CRT_PROJECT] ALTER COLUMN [ANNCMENT_COMMENT] VARCHAR(max)
GO


ALTER TABLE [dbo].[CRT_PROJECT] ADD CONSTRAINT [CRT_PROJECT_PK] 
    PRIMARY KEY CLUSTERED ([PROJECT_ID])
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


EXECUTE sp_addextendedproperty N'MS_Description', N'Capital index lookup ID associated with capital indices in the lookup table. A value assigned to indicate whether expenditures related to a project are capitalizable (contributes to extending the life of an asset) or expensable (does not materially contribute to extending the life of an asset)	', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'CAP_INDX_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Nearest town lookup ID is associated with nearest town to the project location. The ID maps to the lookup table', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'NEARST_TWN_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'RC lookup IDs associated with RC numbers', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'RC_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Project manager mapped to system user ID', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'PROJECT_MGR_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Project value as communicated through announcement done by GCPE', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'ANNCMENT_VALUE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Value on the road side signs for the project value', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'C035_VALUE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Comments on project announcements', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT', 'COLUMN', N'ANNCMENT_COMMENT'
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
/* Alter table "dbo.CRT_PROJECT_HIST"                                     */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_PROJECT_HIST] DROP CONSTRAINT [CRT_PROJECT_HIST_PK]
GO


ALTER TABLE [dbo].[CRT_PROJECT_HIST] ALTER COLUMN [CAP_INDX_LKUP_ID] NUMERIC(9)
GO


ALTER TABLE [dbo].[CRT_PROJECT_HIST] ALTER COLUMN [ANNCMENT_COMMENT] VARCHAR(max)
GO


ALTER TABLE [dbo].[CRT_PROJECT_HIST] ADD CONSTRAINT [CRT_PROJECT_HIST_PK] 
    PRIMARY KEY CLUSTERED ([PROJECT_HIST_ID])
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


EXECUTE sp_addextendedproperty N'MS_Description', N'Project value as communicated through announcement done by GCPE', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'ANNCMENT_VALUE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Value on the road side signs for the project value', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'C035_VALUE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Comments on project announcements', 'SCHEMA', N'dbo', 'TABLE', N'CRT_PROJECT_HIST', 'COLUMN', N'ANNCMENT_COMMENT'
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
/* Alter table "dbo.CRT_FIN_TARGET"                                       */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_FIN_TARGET] DROP CONSTRAINT [CRT_FIN_TARGET_PK]
GO


EXEC sp_rename '[dbo].[CRT_FIN_TARGET].[FORECAST_TYPE_LKUP_ID]', 'FUNDING_TYPE_LKUP_ID', 'COLUMN'
GO


ALTER TABLE [dbo].[CRT_FIN_TARGET] ALTER COLUMN [FIN_TARGET_ID] NUMERIC(9) NOT NULL
GO


ALTER TABLE [dbo].[CRT_FIN_TARGET] ADD CONSTRAINT [CRT_FIN_TARGET_PK] 
    PRIMARY KEY CLUSTERED ([FIN_TARGET_ID])
GO


EXECUTE sp_updateextendedproperty N'MS_Description', N'Funding type allows users to plan their program outside the bounds of current fiscal/allocation	', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET', 'COLUMN', N'FUNDING_TYPE_LKUP_ID'
GO


/* ---------------------------------------------------------------------- */
/* Alter table "dbo.CRT_QTY_ACCMP"                                        */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_QTY_ACCMP] DROP CONSTRAINT [CRT_QTY_ACCMP_PK]
GO


ALTER TABLE [dbo].[CRT_QTY_ACCMP] ALTER COLUMN [QTY_ACCMP_ID] NUMERIC(9) NOT NULL
GO


ALTER TABLE [dbo].[CRT_QTY_ACCMP] ALTER COLUMN [FORECAST] NUMERIC(10,3)
GO


ALTER TABLE [dbo].[CRT_QTY_ACCMP] ALTER COLUMN [ACTUAL] NUMERIC(10,3)
GO


ALTER TABLE [dbo].[CRT_QTY_ACCMP] ADD CONSTRAINT [CRT_QTY_ACCMP_PK] 
    PRIMARY KEY CLUSTERED ([QTY_ACCMP_ID])
GO


/* ---------------------------------------------------------------------- */
/* Alter table "dbo.CRT_TENDER"                                           */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_TENDER] DROP CONSTRAINT [CRT_TENDER_PK]
GO


ALTER TABLE [dbo].[CRT_TENDER] ALTER COLUMN [TENDER_ID] NUMERIC(9) NOT NULL
GO


ALTER TABLE [dbo].[CRT_TENDER] ADD CONSTRAINT [CRT_TENDER_PK] 
    PRIMARY KEY CLUSTERED ([TENDER_ID])
GO


/* ---------------------------------------------------------------------- */
/* Alter table "dbo.CRT_FIN_TARGET_HIST"                                  */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_FIN_TARGET_HIST] DROP CONSTRAINT [CRT_FIN_TARGET_HIST_PK]
GO


EXEC sp_rename '[dbo].[CRT_FIN_TARGET_HIST].[FORECAST_TYPE_LKUP_ID]', 'FUNDING_TYPE_LKUP_ID', 'COLUMN'
GO


ALTER TABLE [dbo].[CRT_FIN_TARGET_HIST] ADD CONSTRAINT [CRT_FIN_TARGET_HIST_PK] 
    PRIMARY KEY CLUSTERED ([FIN_TARGET_HIST_ID])
GO


EXECUTE sp_updateextendedproperty N'MS_Description', N'Funding type allows users to plan their program outside the bounds of current fiscal/allocation	', 'SCHEMA', N'dbo', 'TABLE', N'CRT_FIN_TARGET_HIST', 'COLUMN', N'FUNDING_TYPE_LKUP_ID'
GO


/* ---------------------------------------------------------------------- */
/* Alter table "dbo.CRT_QTY_ACCMP_HIST"                                   */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_QTY_ACCMP_HIST] DROP CONSTRAINT [CRT_QTY_ACCMP_HIST_PK]
GO


ALTER TABLE [dbo].[CRT_QTY_ACCMP_HIST] ALTER COLUMN [QTY_ACCMP_HIST_ID] NUMERIC(9) NOT NULL
GO


ALTER TABLE [dbo].[CRT_QTY_ACCMP_HIST] ADD CONSTRAINT [CRT_QTY_ACCMP_HIST_PK] 
    PRIMARY KEY CLUSTERED ([QTY_ACCMP_HIST_ID])
GO


/* ---------------------------------------------------------------------- */
/* Alter table "dbo.CRT_TENDER_HIST"                                      */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_TENDER_HIST] DROP CONSTRAINT [CRT_TENDER_HIST_PK]
GO


ALTER TABLE [dbo].[CRT_TENDER_HIST] ALTER COLUMN [TENDER_HIST_ID] NUMERIC(9) NOT NULL
GO


ALTER TABLE [dbo].[CRT_TENDER_HIST] ADD CONSTRAINT [CRT_TENDER_HIST_PK] 
    PRIMARY KEY CLUSTERED ([TENDER_HIST_ID])
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


ALTER TABLE [dbo].[CRT_FIN_TARGET] ADD CONSTRAINT [CRT_CODE_LOOKUP_CRT_FIN_TARGET_FUND_TYP] 
    FOREIGN KEY ([FUNDING_TYPE_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
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


ALTER TABLE [dbo].[CRT_NOTE] ADD CONSTRAINT [CRT_PROJECT_CRT_NOTE] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [dbo].[CRT_PROJECT] ([PROJECT_ID])
GO


/* ---------------------------------------------------------------------- */
/* Repair/add triggers                                                    */
/* ---------------------------------------------------------------------- */

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
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  IF EXISTS(SELECT * FROM deleted)
    update CRT_FIN_TARGET_HIST set END_DATE_HIST = @curr_date where FIN_TARGET_ID in (select FIN_TARGET_ID from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT * FROM inserted)
    insert into CRT_FIN_TARGET_HIST ([FIN_TARGET_ID], [PROJECT_ID], [DESCRIPTION], [AMOUNT], [FISCAL_YEAR_LKUP_ID], [ELEMENT_ID], [PHASE_LKUP_ID], [FUNDING_TYPE_LKUP_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], [FIN_TARGET_HIST_ID], [END_DATE_HIST], [EFFECTIVE_DATE_HIST])
 
	select [FIN_TARGET_ID], [PROJECT_ID], [DESCRIPTION], [AMOUNT], [FISCAL_YEAR_LKUP_ID], [ELEMENT_ID], [PHASE_LKUP_ID], [FUNDING_TYPE_LKUP_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_FIN_TARGET_H_ID_SEQ]) as [FIN_TARGET_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_FIN_TRGT_I_S_I_TR] ON CRT_FIN_TARGET INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;

  insert into CRT_FIN_TARGET ("FIN_TARGET_ID",
	  "PROJECT_ID",
	  "DESCRIPTION",
	  "AMOUNT",
	  "FISCAL_YEAR_LKUP_ID",
	  "ELEMENT_ID",
	  "PHASE_LKUP_ID",
	  "FUNDING_TYPE_LKUP_ID",
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
	  "FUNDING_TYPE_LKUP_ID",
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


CREATE TRIGGER [dbo].[CRT_FIN_TRGT_I_S_U_TR] ON CRT_FIN_TARGET INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.FIN_TARGET_ID = deleted.FIN_TARGET_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)

  update CRT_FIN_TARGET
    set "FIN_TARGET_ID" = inserted."FIN_TARGET_ID",
	  "PROJECT_ID" = inserted."PROJECT_ID",
	  "DESCRIPTION" = inserted."DESCRIPTION",
	  "AMOUNT" = inserted."AMOUNT",
	  "FISCAL_YEAR_LKUP_ID" = inserted."FISCAL_YEAR_LKUP_ID",
	  "ELEMENT_ID" = inserted."ELEMENT_ID",
	  "PHASE_LKUP_ID" = inserted."PHASE_LKUP_ID",
	  "FUNDING_TYPE_LKUP_ID" = inserted."FUNDING_TYPE_LKUP_ID",
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


CREATE TRIGGER [dbo].[CRT_QTY_ACCMP_A_S_IUD_TR] ON CRT_QTY_ACCMP FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  IF EXISTS(SELECT * FROM deleted)
    update CRT_QTY_ACCMP_HIST set END_DATE_HIST = @curr_date where QTY_ACCMP_ID in (select QTY_ACCMP_ID from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT * FROM inserted)
    insert into CRT_QTY_ACCMP_HIST ([QTY_ACCMP_ID], [PROJECT_ID], [FISCAL_YEAR_LKUP_ID], [QTY_ACCMP_LKUP_ID], [FORECAST], [SCHEDULE7], [ACTUAL], [COMMENT], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], [QTY_ACCMP_HIST_ID], [END_DATE_HIST], [EFFECTIVE_DATE_HIST])
 
	select [QTY_ACCMP_ID], [PROJECT_ID], [FISCAL_YEAR_LKUP_ID], [QTY_ACCMP_LKUP_ID], [FORECAST], [SCHEDULE7], [ACTUAL], [COMMENT], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_QTY_ACCMP_H_ID_SEQ]) as [QTY_ACCMP_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_QTY_ACCMP_I_S_I_TR] ON CRT_QTY_ACCMP INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;

  insert into CRT_QTY_ACCMP ("QTY_ACCMP_ID",
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
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  IF EXISTS(SELECT * FROM deleted)
    update CRT_TENDER_HIST set END_DATE_HIST = @curr_date where TENDER_ID in (select TENDER_ID from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT * FROM inserted)
    insert into CRT_TENDER_HIST ([TENDER_ID], [PROJECT_ID], [TENDER_NUMBER], [PLANNED_DATE], [ACTUAL_DATE], [TENDER_VALUE], [WINNING_CNTRCTR_LKUP_ID], [BID_VALUE], [COMMENT], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], [TENDER_HIST_ID], [END_DATE_HIST], [EFFECTIVE_DATE_HIST])
 
	select [TENDER_ID], [PROJECT_ID], [TENDER_NUMBER], [PLANNED_DATE], [ACTUAL_DATE], [TENDER_VALUE], [WINNING_CNTRCTR_LKUP_ID], [BID_VALUE], [COMMENT], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_TENDER_H_ID_SEQ]) as [TENDER_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_TENDER_I_S_I_TR] ON CRT_TENDER INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;

  insert into CRT_TENDER ("TENDER_ID",
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


CREATE TRIGGER [dbo].[CRT_TENDER_I_S_U_TR] ON CRT_TENDER INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;

  -- validate concurrency control
  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.TENDER_ID = deleted.TENDER_ID)
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

