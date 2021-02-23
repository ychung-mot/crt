/* ---------------------------------------------------------------------- */
/* Script generated with: DeZign for Databases 12.1.0                     */
/* Target DBMS:           MS SQL Server 2017                              */
/* Project file:          S04_01_APP_CRT_V2.dez                           */
/* Project name:          Capital Rehabilitation Tracking Reporting       */
/* Author:                Ayodeji Kuponiyi                                */
/* Script type:           Alter database script                           */
/* Created on:            2021-02-23 10:02                                */
/* ---------------------------------------------------------------------- */

USE CRT_DEVDB;
GO

/* ---------------------------------------------------------------------- */
/* Add sequences                                                          */
/* ---------------------------------------------------------------------- */

CREATE SEQUENCE [dbo].[CRT_SEGMENT_H_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  99999999999 
  NO CYCLE
  CACHE 50
GO


CREATE SEQUENCE [dbo].[CRT_SEGMENT_ID_SEQ]
  AS BIGINT 
  START WITH 1
  INCREMENT BY 1 
  MINVALUE  1
  MAXVALUE  99999999999 
  NO CYCLE
  CACHE 50
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_SEGMENT"                                            */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_SEGMENT] (
    [SEGMENT_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_SEGMENT_ID_SEQ] NOT NULL,
    [PROJECT_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_PROJECT_ID_SEQ] NOT NULL,
    [START_LATITUDE] NUMERIC(16,8),
    [START_LONGITUDE] NUMERIC(16,8),
    [END_LATITUDE] NUMERIC(16,8),
    [END_LONGITUDE] NUMERIC(16,8),
    [GEOMETRY] GEOMETRY,
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
    CONSTRAINT [CRT_SEGMENT_PK] PRIMARY KEY CLUSTERED ([SEGMENT_ID])
)
GO


CREATE NONCLUSTERED INDEX [CRT_SEGMENT_ELEM_FK_I] ON [dbo].[CRT_SEGMENT] ([SEGMENT_ID] ASC,[PROJECT_ID] ASC)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines CRT project elements', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'SEGMENT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'PROJECT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Spatial Coordinates denoting the starting Latitude for the project/project segment', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'START_LATITUDE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Spatial Coordinates denoting the starting Longitude for the project/project segment	', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'START_LONGITUDE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Spatial Coordinates denoting the End Latitude for the project/project segment', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'END_LATITUDE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Spatial Coordinates denoting the end Longitude for the project/project segment', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'END_LONGITUDE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Line or point depicting the underlying geometry  	', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'GEOMETRY'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the project is completed. This shows is proxy for project status, either active or complete', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add table "dbo.CRT_SEGMENT_HIST"                                       */
/* ---------------------------------------------------------------------- */

CREATE TABLE [dbo].[CRT_SEGMENT_HIST] (
    [SEGMENT_HIST_ID] NUMERIC(9) DEFAULT NEXT VALUE FOR [CRT_SEGMENT_H_ID_SEQ] NOT NULL,
    [SEGMENT_ID] NUMERIC(9) NOT NULL,
    [PROJECT_ID] NUMERIC(9) NOT NULL,
    [START_LATITUDE] NUMERIC(16,8),
    [START_LONGITUDE] NUMERIC(16,8),
    [END_LATITUDE] NUMERIC(16,8),
    [END_LONGITUDE] NUMERIC(16,8),
    [GEOMETRY] GEOMETRY,
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
    CONSTRAINT [CRT_SEGMENT_HIST_PK] PRIMARY KEY CLUSTERED ([SEGMENT_HIST_ID])
)
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Defines CRT project elements', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', NULL, NULL
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'SEGMENT_HIST_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'SEGMENT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'A system generated unique identifier.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'PROJECT_ID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Spatial Coordinates denoting the starting Latitude for the project/project segment', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'START_LATITUDE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Spatial Coordinates denoting the starting Longitude for the project/project segment	', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'START_LONGITUDE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Spatial Coordinates denoting the End Latitude for the project/project segment', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'END_LATITUDE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Spatial Coordinates denoting the end Longitude for the project/project segment', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'END_LONGITUDE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Line or point depicting the underlying geometry  	', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'GEOMETRY'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date the project is completed. This shows is proxy for project status, either active or complete', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'END_DATE'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Record under edit indicator used for optomisitc record contention management.  If number differs from start of edit, then user will be prompted to that record has been updated by someone else.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'CONCURRENCY_CONTROL_NUMBER'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'APP_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of record creation', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'APP_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'APP_CREATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'APP_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time of last record update', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'APP_LAST_UPDATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Unique idenifier of user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'APP_LAST_UPDATE_USER_GUID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who created record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'DB_AUDIT_CREATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record created in the database', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'DB_AUDIT_CREATE_TIMESTAMP'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Named database user who last updated record', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_USERID'
GO


EXECUTE sp_addextendedproperty N'MS_Description', N'Date and time record was last updated in the database.', 'SCHEMA', N'dbo', 'TABLE', N'CRT_SEGMENT_HIST', 'COLUMN', N'DB_AUDIT_LAST_UPDATE_TIMESTAMP'
GO


/* ---------------------------------------------------------------------- */
/* Add foreign key constraints                                            */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_SEGMENT] ADD CONSTRAINT [CRT_PROJECT_CRT_SEGMENT] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [dbo].[CRT_PROJECT] ([PROJECT_ID])
GO


/* ---------------------------------------------------------------------- */
/* Repair/add triggers                                                    */
/* ---------------------------------------------------------------------- */

CREATE TRIGGER [dbo].[CRT_SEGMENT_A_S_IUD_TR] ON CRT_SEGMENT FOR INSERT, UPDATE, DELETE AS
SET NOCOUNT ON
BEGIN TRY
DECLARE @curr_date datetime;
SET @curr_date = getutcdate();
  IF NOT EXISTS(SELECT * FROM inserted) AND NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  IF EXISTS(SELECT * FROM deleted)
    update CRT_SEGMENT_HIST set END_DATE_HIST = @curr_date where SEGMENT_ID in (select SEGMENT_ID from deleted) and END_DATE_HIST is null;


  IF EXISTS(SELECT * FROM inserted)
    insert into CRT_SEGMENT_HIST ([SEGMENT_ID], [PROJECT_ID], [START_LATITUDE], [START_LONGITUDE], [END_LATITUDE], [END_LONGITUDE], [GEOMETRY], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], SEGMENT_HIST_ID, END_DATE_HIST, EFFECTIVE_DATE_HIST)
      select [SEGMENT_ID], [PROJECT_ID], [START_LATITUDE], [START_LONGITUDE], [END_LATITUDE], [END_LONGITUDE], [GEOMETRY], [END_DATE], [CONCURRENCY_CONTROL_NUMBER], [APP_CREATE_USERID], [APP_CREATE_TIMESTAMP], [APP_CREATE_USER_GUID], [APP_LAST_UPDATE_USERID], [APP_LAST_UPDATE_TIMESTAMP], [APP_LAST_UPDATE_USER_GUID], [DB_AUDIT_CREATE_USERID], [DB_AUDIT_CREATE_TIMESTAMP], [DB_AUDIT_LAST_UPDATE_USERID], [DB_AUDIT_LAST_UPDATE_TIMESTAMP], (next value for [dbo].[CRT_SEGMENT_H_ID_SEQ]) as [SEGMENT_HIST_ID], null as [END_DATE_HIST], @curr_date as [EFFECTIVE_DATE_HIST] from inserted;

END TRY
BEGIN CATCH
   IF @@trancount > 0 ROLLBACK TRANSACTION
   EXEC crt_error_handling
END CATCH
GO


CREATE TRIGGER [dbo].[CRT_SEGMENT_I_S_I_TR] ON CRT_SEGMENT INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;

  insert into CRT_SEGMENT ("SEGMENT_ID",
	  "PROJECT_ID", 
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
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.SEGMENT_ID = deleted.SEGMENT_ID)
    raiserror('CONCURRENCY FAILURE.',16,1)



  update CRT_SEGMENT
    set "SEGMENT_ID" = inserted."SEGMENT_ID", 
	  "PROJECT_ID" = inserted."PROJECT_ID", 
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

