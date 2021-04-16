/* ---------------------------------------------------------------------- */
/* Script generated with: DeZign for Databases 12.1.0                     */
/* Target DBMS:           MS SQL Server 2017                              */
/* Project file:          S07_01_APP_CRT_V1.dez                           */
/* Project name:          Capital Rehabilitation Tracking Reporting       */
/* Author:                Ayodeji Kuponiyi                                */
/* Script type:           Alter database script                           */
/* Created on:            2021-04-15 10:54                                */
/* ---------------------------------------------------------------------- */

USE CRT_DEV;
GO

/*
1. Drops segment record view and recreates following the DA naming standards
2. Drops CRT_ELEMENT_TMP table sequence previously created as a staging table
3. updates description on the previously created CRT_ELEMENT table
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


/* ---------------------------------------------------------------------- */
/* Drop views                                                             */
/* ---------------------------------------------------------------------- */

DROP VIEW [dbo].[SEGMENT_RECORD]
GO


/* ---------------------------------------------------------------------- */
/* Drop sequences                                                         */
/* ---------------------------------------------------------------------- */

DROP SEQUENCE [dbo].[CRT_ELEMENT_TMP_ID_SEQ]
GO


/* ---------------------------------------------------------------------- */
/* Drop foreign key constraints                                           */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_ELEMENT] DROP CONSTRAINT [CRT_CODE_LOOKUP_CRT_ELEMENT_PROG_PROG_FK]
GO


ALTER TABLE [dbo].[CRT_ELEMENT] DROP CONSTRAINT [CRT_CODE_LOOKUP_CRT_ELEMENT_PROG_CAT_PROG_CAT_FK]
GO


ALTER TABLE [dbo].[CRT_ELEMENT] DROP CONSTRAINT [CRT_CODE_LOOKUP_CRT_ELEMENT_SRV_LINE_SRV_LINE_FK]
GO


ALTER TABLE [dbo].[CRT_SEGMENT] DROP CONSTRAINT [CRT_PROJECT_CRT_SEGMENT]
GO


ALTER TABLE [dbo].[CRT_FIN_TARGET] DROP CONSTRAINT [CRT_ELEMENT_CRT_FIN_TARGET]
GO


/* ---------------------------------------------------------------------- */
/* Add foreign key constraints                                            */
/* ---------------------------------------------------------------------- */

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


ALTER TABLE [dbo].[CRT_FIN_TARGET] ADD CONSTRAINT [CRT_ELEMENT_CRT_FIN_TARGET] 
    FOREIGN KEY ([ELEMENT_ID]) REFERENCES [dbo].[CRT_ELEMENT] ([ELEMENT_ID])
GO


/* ---------------------------------------------------------------------- */
/* Repair/add views                                                       */
/* ---------------------------------------------------------------------- */

CREATE   VIEW [DBO].[CRT_SEGMENT_RECORD_VW] AS
SELECT
		cs.segment_id,
		cp.project_name,
		cs.project_id,
		cs.description,
		cs.geometry

FROM
	[DBO].[CRT_SEGMENT]	cs,
	[DBO].[CRT_PROJECT]	cp

WHERE cs.PROJECT_ID = cp.PROJECT_ID
GO


/* ---------------------------------------------------------------------- */
/* Repair/add triggers                                                    */
/* ---------------------------------------------------------------------- */

CREATE TRIGGER [dbo].[CRT_ELEMENT_I_S_I_TR] ON CRT_ELEMENT INSTEAD OF INSERT AS
SET NOCOUNT ON
BEGIN TRY
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;

  insert into CRT_ELEMENT ("ELEMENT_ID",
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
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.ELEMENT_ID = deleted.ELEMENT_ID)
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
  IF NOT EXISTS(SELECT * FROM inserted)
    RETURN;

  insert into CRT_SEGMENT ("SEGMENT_ID",
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
  IF NOT EXISTS(SELECT * FROM deleted)
    RETURN;


  if exists (select 1 from inserted, deleted where inserted.CONCURRENCY_CONTROL_NUMBER != deleted.CONCURRENCY_CONTROL_NUMBER+1 AND inserted.SEGMENT_ID = deleted.SEGMENT_ID)
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

