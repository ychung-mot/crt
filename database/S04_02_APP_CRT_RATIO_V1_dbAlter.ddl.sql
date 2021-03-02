/* ---------------------------------------------------------------------- */
/* Script generated with: DeZign for Databases 12.1.0                     */
/* Target DBMS:           MS SQL Server 2017                              */
/* Project file:          S04_01_APP_CRT_V2.dez                           */
/* Project name:          Capital Rehabilitation Tracking Reporting       */
/* Author:                Ayodeji Kuponiyi                                */
/* Script type:           Alter database script                           */
/* Created on:            2021-03-02 11:03                                */
/* ---------------------------------------------------------------------- */

USE CRT_DEVDB;
GO

/* ---------------------------------------------------------------------- */
/* Add sequences                                                          */
/* ---------------------------------------------------------------------- */

CREATE SEQUENCE [dbo].[CRT_RATIO_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  99999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_RATIO_H_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  99999999999 
  NO CYCLE
  CACHE 50
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_RATIO"                                              */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_RATIO] (
    [RATIO_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_RATIO_ID_SEQ] NOT NULL,
    [PROJECT_ID] NUMERIC(9) NOT NULL,
    [RATIO] NUMERIC(9,5),
    [RATIO_RECORD_LKUP_ID] NUMERIC(9),
    [RATIO_RECORD_TYPE_LKUP_ID] NUMERIC(9) NOT NULL,
    [SERVICE_AREA_ID] NUMERIC(9),
    [DISTRICT_ID] NUMERIC(9),
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
    CONSTRAINT [CRT_RATIO_PK] PRIMARY KEY CLUSTERED ([RATIO_ID])
)
GO


CREATE NONCLUSTERED INDEX [CRT_RATIO_FK_I] ON [dbo].[CRT_RATIO] ([RATIO_ID] ASC,[SERVICE_AREA_ID] ASC,[DISTRICT_ID] ASC,[RATIO_RECORD_LKUP_ID] ASC)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines CRT financial targets', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'RATIO_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'PROJECT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Proportion of the project that falls within a ratio object e.g. electoral district,economic region, highway', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'RATIO'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Link to code lookup table ratio record values for electoral district, economic region, highway', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'RATIO_RECORD_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Link to code lookup table for type of record i.e. service area, electoral district, economic region, highway, district', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'RATIO_RECORD_TYPE_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier for service area', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'SERVICE_AREA_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier for districts', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'DISTRICT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the project is completed. This shows is proxy for project status, either active or complete', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_RATIO_HIST"                                         */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_RATIO_HIST] (
    [RATIO_HIST_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_RATIO_H_ID_SEQ]  NOT NULL,
    [RATIO_ID] NUMERIC(9) NOT NULL,
    [PROJECT_ID] NUMERIC(9) NOT NULL,
    [RATIO] NUMERIC(9,5),
    [RATIO_RECORD_LKUP_ID] NUMERIC(9),
    [RATIO_RECORD_TYPE_LKUP_ID] NUMERIC(9) NOT NULL,
    [SERVICE_AREA_ID] NUMERIC(9),
    [DISTRICT_ID] NUMERIC(9),
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
    CONSTRAINT [CRT_RATIO_HIST_PK] PRIMARY KEY CLUSTERED ([RATIO_HIST_ID])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines CRT financial targets', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'RATIO_HIST_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'RATIO_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'PROJECT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Proportion of the project that falls within a ratio object e.g. electoral district,economic region, highway', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'RATIO'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Link to code lookup table ratio record values for electoral district, economic region, highway', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'RATIO_RECORD_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Link to code lookup table for type of record i.e. service area, electoral district, economic region, highway, district', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'RATIO_RECORD_TYPE_LKUP_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier for service area', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'SERVICE_AREA_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique identifier for district records', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'DISTRICT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the project is completed. This shows is proxy for project status, either active or complete', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_RATIO_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add foreign key constraints                                            */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_RATIO] ADD CONSTRAINT [CRT_PROJECT_CRT_RATIO] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [dbo].[CRT_PROJECT] ([PROJECT_ID])
GO


ALTER TABLE [dbo].[CRT_RATIO] ADD CONSTRAINT [CRT_CODE_LOOKUP_RATIO_RECORD] 
    FOREIGN KEY ([RATIO_RECORD_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
GO


ALTER TABLE [dbo].[CRT_RATIO] ADD CONSTRAINT [CRT_CODE_LOOKUP_RATIO_RECORD_TYPE] 
    FOREIGN KEY ([RATIO_RECORD_TYPE_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
GO


/* ---------------------------------------------------------------------- */
/* Repair/add triggers                                                    */
/* ---------------------------------------------------------------------- */

CREATE TRIGGER [dbo].[CRT_RATIO_A_S_IUD_TR] ON CRT_RATIO FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  IF EXISTS(SELECT * FROM deleted)
    update CRT_RATIO_HIST set END_DATE_HIST = @curr_date where RATIO_ID in (select RATIO_ID from deleted) and END_DATE_HIST is null;

  IF EXISTS(SELECT * FROM inserted)
    insert into CRT_RATIO_HIST ([RATIO_ID], [PROJECT_ID], [RATIO], [RATIO_RECORD_LKUP_ID], [RATIO_RECORD_TYPE_LKUP_ID], [SERVICE_AREA_ID], [DISTRICT_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], [RATIO_HIST_ID], [END_DATE_HIST], [EFFECTIVE_DATE_HIST])
 
	select [RATIO_ID], [PROJECT_ID], [RATIO], [RATIO_RECORD_LKUP_ID], [RATIO_RECORD_TYPE_LKUP_ID], [SERVICE_AREA_ID], [DISTRICT_ID], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_RATIO_H_ID_SEQ]) as [RATIO_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_RATIO_I_S_I_TR] ON CRT_RATIO INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;

  insert into CRT_RATIO ("RATIO_ID",
	  "PROJECT_ID", 
	  "RATIO",
	  "RATIO_RECORD_LKUP_ID", 
	  "RATIO_RECORD_TYPE_LKUP_ID", 
	  "SERVICE_AREA_ID",
	  "DISTRICT_ID",
	  "END_DATE",
      "CONCURRENCY_CONTROL_NUMBER",
      "APP_CREATE_USERID",
      "APP_CREATE_TIMESTAMP",
      "APP_CREATE_USER_GUID",
      "APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID")
    select "RATIO_ID",
      "PROJECT_ID",
	  "RATIO",
	  "RATIO_RECORD_LKUP_ID", 
	  "RATIO_RECORD_TYPE_LKUP_ID", 
	  "SERVICE_AREA_ID",
	  "DISTRICT_ID",
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


CREATE TRIGGER [dbo].[CRT_RATIO_I_S_U_TR] ON CRT_RATIO INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.RATIO_ID = deleted.RATIO_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)

  update CRT_RATIO
    set "RATIO_ID" = inserted."RATIO_ID",
      "PROJECT_ID" = inserted."PROJECT_ID", 
	  "RATIO" = inserted."RATIO",
	  "RATIO_RECORD_LKUP_ID" = inserted."RATIO_RECORD_LKUP_ID", 
	  "RATIO_RECORD_TYPE_LKUP_ID" = inserted."RATIO_RECORD_TYPE_LKUP_ID", 
	  "SERVICE_AREA_ID" = inserted."SERVICE_AREA_ID",
	  "DISTRICT_ID" = inserted."DISTRICT_ID",	  
      "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_RATIO
    inner join inserted
    on (CRT_RATIO.RATIO_ID = inserted.RATIO_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO

