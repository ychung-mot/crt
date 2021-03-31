/* ---------------------------------------------------------------------- */
/* Script generated with: DeZign for Databases 12.1.0                     */
/* Target DBMS:           MS SQL Server 2017                              */
/* Project file:          S06_01_APP_CRT_V4.dez                           */
/* Project name:          Capital Rehabilitation Tracking Reporting       */
/* Author:                Ayodeji Kuponiyi                                */
/* Script type:           Alter database script                           */
/* Created on:            2021-03-30 09:45                                */
/* ---------------------------------------------------------------------- */

USE CRT_DEV;
GO


/*
Major changes:

CRT_NOTE
CRT_NOTE_HIST

*/



/* ---------------------------------------------------------------------- */
/* Drop triggers                                                          */
/* ---------------------------------------------------------------------- */

DROP TRIGGER [dbo].[CRT_ELEMENT_I_S_I_TR]
GO


DROP TRIGGER [dbo].[CRT_ELEMENT_I_S_U_TR]
GO


DROP TRIGGER [dbo].[CRT_SEGMENT_I_S_I_TR]
GO


DROP TRIGGER [dbo].[CRT_SEGMENT_I_S_U_TR]
GO


DROP TRIGGER [dbo].[CRT_SYS_USR_A_S_IUD_TR]
GO


/* ---------------------------------------------------------------------- */
/* Drop foreign key constraints                                           */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_NOTE] DROP CONSTRAINT [CRT_PROJECT_CRT_NOTE]
GO


ALTER TABLE [dbo].[CRT_SEGMENT] DROP CONSTRAINT [CRT_PROJECT_CRT_SEGMENT]
GO


ALTER TABLE [dbo].[CRT_FIN_TARGET] DROP CONSTRAINT [CRT_ELEMENT_CRT_FIN_TARGET]
GO


ALTER TABLE [dbo].[CRT_REGION_USER] DROP CONSTRAINT [CRT_SYSTEM_USER_CRT_REGION_USER]
GO


ALTER TABLE [dbo].[CRT_USER_ROLE] DROP CONSTRAINT [CRT_USR_RL_SYS_USR_FK]
GO


/* ---------------------------------------------------------------------- */
/* Add sequences                                                          */
/* ---------------------------------------------------------------------- */

CREATE SEQUENCE [dbo].[CRT_NOTE_H_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  99999999999 
  NO CYCLE
  CACHE 50
GO


/* ---------------------------------------------------------------------- */
/* Alter table "dbo.CRT_NOTE"                                             */
/* ---------------------------------------------------------------------- */

DROP INDEX [dbo].[CRT_NOTE].[CRT_NOTE_FK_I]
GO


ALTER TABLE [dbo].[CRT_NOTE] DROP CONSTRAINT [CRT_NOTE_PK]
GO


ALTER TABLE [dbo].[CRT_NOTE] ADD CONSTRAINT [CRT_NOTE_PK] 
    PRIMARY KEY CLUSTERED ([NOTE_ID])
GO


CREATE NONCLUSTERED INDEX [CRT_NOTE_FK_I] ON [dbo].[CRT_NOTE] ([PROJECT_ID] ASC,[NOTE_ID] ASC)
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
/* Add table "dbo.CRT_NOTE_HIST"                                          */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_NOTE_HIST]
(
  [NOTE_HIST_ID] NUMERIC(9) NOT NULL,
  [NOTE_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_NOTE_H_ID_SEQ] NOT NULL,
  [NOTE_TYPE] VARCHAR(9) NOT NULL,
  [COMMENT] VARCHAR(max) NOT NULL,
  [PROJECT_ID] NUMERIC(9) NOT NULL,
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
  CONSTRAINT [CRT_NOTE_HIST_PK] PRIMARY KEY CLUSTERED ([NOTE_HIST_ID])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'History of CRT project notes', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Identifier for the note history attached to the project.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', 'COLUMN', N'NOTE_HIST_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Identifier for the notes attached to the project.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', 'COLUMN', N'NOTE_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier that specifies the note type: as either STATUS or EMR', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', 'COLUMN', N'NOTE_TYPE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Comments on the project', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', 'COLUMN', N'COMMENT'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_NOTE_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add foreign key constraints                                            */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_NOTE] ADD CONSTRAINT [CRT_PROJECT_CRT_NOTE] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [dbo].[CRT_PROJECT] ([PROJECT_ID])
GO


ALTER TABLE [dbo].[CRT_ELEMENT] ADD CONSTRAINT [CRT_CODE_LOOKUP_CRT_ELEMENT_PROG_PROG_FK] 
    FOREIGN KEY ([PROGRAM_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
GO


ALTER TABLE [dbo].[CRT_ELEMENT] ADD CONSTRAINT [CRT_CODE_LOOKUP_CRT_ELEMENT_PROG_CAT_PROG_CAT_FK] 
    FOREIGN KEY ([PROGRAM_CATEGORY_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
GO


ALTER TABLE [dbo].[CRT_ELEMENT] ADD CONSTRAINT [CRT_CODE_LOOKUP_CRT_ELEMENT_SRV_LINE_SRV_LINE_FK] 
    FOREIGN KEY ([SERVICE_LINE_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
GO


ALTER TABLE [dbo].[CRT_SEGMENT] ADD CONSTRAINT [CRT_PROJECT_CRT_SEGMENT] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [dbo].[CRT_PROJECT] ([PROJECT_ID])
GO


ALTER TABLE [dbo].[CRT_USER_ROLE] ADD CONSTRAINT [CRT_USR_RL_SYS_USR_FK] 
    FOREIGN KEY ([SYSTEM_USER_ID]) REFERENCES [dbo].[CRT_SYSTEM_USER] ([SYSTEM_USER_ID])
GO


ALTER TABLE [dbo].[CRT_REGION_USER] ADD CONSTRAINT [CRT_SYSTEM_USER_CRT_REGION_USER] 
    FOREIGN KEY ([SYSTEM_USER_ID]) REFERENCES [dbo].[CRT_SYSTEM_USER] ([SYSTEM_USER_ID])
GO


ALTER TABLE [dbo].[CRT_FIN_TARGET] ADD CONSTRAINT [CRT_ELEMENT_CRT_FIN_TARGET] 
    FOREIGN KEY ([ELEMENT_ID]) REFERENCES [dbo].[CRT_ELEMENT] ([ELEMENT_ID])
GO


/* ---------------------------------------------------------------------- */
/* Repair/add triggers                                                    */
/* ---------------------------------------------------------------------- */

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
  ([SYSTEM_USER_ID], [API_CLIENT_ID], [USER_GUID], [USERNAME], [FIRST_NAME], [LAST_NAME], [EMAIL], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], SYSTEM_USER_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
select [SYSTEM_USER_ID], [API_CLIENT_ID], [USER_GUID], [USERNAME], [FIRST_NAME], [LAST_NAME], [EMAIL], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_SYSTEM_USER_H_ID_SEQ]) as [SYSTEM_USER_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC CRT_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_NOTE_A_S_IUD_TR] ON CRT_NOTE FOR INSERT, UPDATE, DELETE AS
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
    update CRT_NOTE_HIST set END_DATE_HIST = @curr_date where NOTE_ID in (select NOTE_ID
  from deleted) and END_DATE_HIST is null;




  IF EXISTS(SELECT *
FROM inserted)
    insert into CRT_NOTE_HIST
  ([NOTE_ID], [NOTE_TYPE], [PROJECT_ID], [COMMENT], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], NOTE_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
select [NOTE_ID], [NOTE_TYPE], [PROJECT_ID], [COMMENT], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_NOTE_H_ID_SEQ]) as [NOTE_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST]
from inserted;

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
  "PROGRAM_LKUP_ID",
  "PROGRAM_CATEGORY_LKUP_ID",
  "SERVICE_LINE_LKUP_ID",
  "IS_ACTIVE",
  "DISPLAY_ORDER",
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
  "PROGRAM_LKUP_ID",
  "PROGRAM_CATEGORY_LKUP_ID",
  "SERVICE_LINE_LKUP_ID",
  "IS_ACTIVE",
  "DISPLAY_ORDER",
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
	  "PROGRAM_LKUP_ID" = inserted."PROGRAM_LKUP_ID",
	  "PROGRAM_CATEGORY_LKUP_ID" = inserted."PROGRAM_CATEGORY_LKUP_ID",
	  "SERVICE_LINE_LKUP_ID" = inserted."SERVICE_LINE_LKUP_ID",   
	  "IS_ACTIVE" = inserted."IS_ACTIVE",
	  "DISPLAY_ORDER" = inserted."DISPLAY_ORDER",
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


CREATE TRIGGER [dbo].[CRT_SEGMENT_I_S_I_TR] ON CRT_SEGMENT INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM inserted)
    RETURN;

  insert into CRT_SEGMENT
  ("SEGMENT_ID",
  "PROJECT_ID",
  "DESCRIPTION",
  "START_LATITUDE",
  "START_LONGITUDE",
  "END_LATITUDE",
  "END_LONGITUDE",
  "GEOMETRY",
  "END_DATE",
  "CONCURRENCY_CONTROL_NUMBER",
  "APP_CREATE_USERID",
  "APP_CREATE_TIMESTAMP",
  "APP_CREATE_USER_GUID",
  "APP_LAST_UPDATE_USERID",
  "APP_LAST_UPDATE_TIMESTAMP",
  "APP_LAST_UPDATE_USER_GUID")
select "SEGMENT_ID",
  "PROJECT_ID",
  "DESCRIPTION",
  "START_LATITUDE",
  "START_LONGITUDE",
  "END_LATITUDE",
  "END_LONGITUDE",
  "GEOMETRY",
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


CREATE TRIGGER [dbo].[CRT_SEGMENT_I_S_U_TR] ON CRT_SEGMENT INSTEAD OF UPDATE AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT *
FROM deleted)
    RETURN;


  if exists (select 1
from inserted, deleted
where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.SEGMENT_ID = deleted.SEGMENT_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)



  update CRT_SEGMENT
    set "SEGMENT_ID" = inserted."SEGMENT_ID", 
	  "PROJECT_ID" = inserted."PROJECT_ID", 
	  "DESCRIPTION" = inserted."DESCRIPTION",
	  "START_LATITUDE" = inserted."START_LATITUDE", 
	  "START_LONGITUDE" = inserted."START_LONGITUDE", 
	  "END_LATITUDE" = inserted."END_LATITUDE", 
	  "END_LONGITUDE" = inserted."END_LONGITUDE", 
	  "GEOMETRY" = inserted."GEOMETRY",
	  "END_DATE" = inserted."END_DATE",
      "CONCURRENCY_CONTROL_NUMBER" = inserted."CONCURRENCY_CONTROL_NUMBER",
      "APP_LAST_UPDATE_USERID" = inserted."APP_LAST_UPDATE_USERID",
      "APP_LAST_UPDATE_TIMESTAMP" = inserted."APP_LAST_UPDATE_TIMESTAMP",
      "APP_LAST_UPDATE_USER_GUID" = inserted."APP_LAST_UPDATE_USER_GUID"
    , DB_AUDIT_LAST_UPDATE_TIMESTAMP = getutcdate()
    , DB_AUDIT_LAST_UPDATE_USERID = user_name()
    from CRT_SEGMENT
  inner join inserted
  on (CRT_SEGMENT.SEGMENT_ID = inserted.SEGMENT_ID);

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO

