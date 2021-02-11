/* ---------------------------------------------------------------------- */
/* Script generated with: DeZign for Databases 12.1.0                     */
/* Target DBMS:           MS SQL Server 2017                              */
/* Project file:          S03_03_APP_CRT_V1.dez                           */
/* Project name:          Capital Rehabilitation Tracking Reporting       */
/* Author:                Ayodeji Kuponiyi                                */
/* Script type:           Alter database script                           */
/* Created on:            2021-02-11 14:39                                */
/* ---------------------------------------------------------------------- */


/* ---------------------------------------------------------------------- */
/* Drop triggers                                                          */
/* ---------------------------------------------------------------------- */

DROP TRIGGER [dbo].[CRT_TENDER_A_S_IUD_TR]
GO


DROP TRIGGER [dbo].[CRT_TENDER_I_S_I_TR]
GO


DROP TRIGGER [dbo].[CRT_TENDER_I_S_U_TR]
GO


/* ---------------------------------------------------------------------- */
/* Drop foreign key constraints                                           */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_TENDER] DROP CONSTRAINT [CRT_CODE_LOOKUP_CRT_TENDER]
GO


ALTER TABLE [dbo].[CRT_TENDER] DROP CONSTRAINT [CRT_PROJECT_CRT_TENDER]
GO


/* ---------------------------------------------------------------------- */
/* Alter table "dbo.CRT_TENDER"                                           */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_TENDER] DROP CONSTRAINT [CRT_TENDER_PK]
GO


ALTER TABLE [dbo].[CRT_TENDER] ALTER COLUMN [TENDER_ID] NUMERIC(9) NOT NULL
GO


ALTER TABLE [dbo].[CRT_TENDER] ALTER COLUMN [TENDER_VALUE] NUMERIC(10,3)
GO


ALTER TABLE [dbo].[CRT_TENDER] ALTER COLUMN [WINNING_CNTRCTR_LKUP_ID] NUMERIC(9)
GO


ALTER TABLE [dbo].[CRT_TENDER] ADD CONSTRAINT [CRT_TENDER_PK] 
    PRIMARY KEY CLUSTERED ([TENDER_ID])
GO


/* ---------------------------------------------------------------------- */
/* Add foreign key constraints                                            */
/* ---------------------------------------------------------------------- */

ALTER TABLE [dbo].[CRT_TENDER] ADD CONSTRAINT [CRT_PROJECT_CRT_TENDER] 
    FOREIGN KEY ([PROJECT_ID]) REFERENCES [dbo].[CRT_PROJECT] ([PROJECT_ID])
GO


ALTER TABLE [dbo].[CRT_TENDER] ADD CONSTRAINT [CRT_CODE_LOOKUP_CRT_TENDER] 
    FOREIGN KEY ([WINNING_CNTRCTR_LKUP_ID]) REFERENCES [dbo].[CRT_CODE_LOOKUP] ([CODE_LOOKUP_ID])
GO


/* ---------------------------------------------------------------------- */
/* Repair/add triggers                                                    */
/* ---------------------------------------------------------------------- */

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

