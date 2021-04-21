/* ---------------------------------------------------------------------- */
/* Script generated with: DeZign for Databases 12.1.0                     */
/* Target DBMS:           MS SQL Server 2017                              */
/* Project file:          S08_02_APP_CRT_V1.dez                           */
/* Project name:          Capital Rehabilitation Tracking Reporting       */
/* Author:                Ayodeji Kuponiyi                                */
/* Script type:           Alter database script                           */
/* Created on:            2021-04-20 10:40                                */
/* ---------------------------------------------------------------------- */



USE CRT_DEV;
GO

EXECUTE sp_updateextendedproperty N'MS_Description', N'Dollar value of tender. This field is captured on the screen as  "Ministry Estimate"', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER', 'COLUMN', N'TENDER_VALUE'
GO

EXECUTE sp_updateextendedproperty N'MS_Description', N'Dollar value of tender. This field is captured on the screen as  "Ministry Estimate"', 'SCHEMA', N'dbo', 'TABLE', N'CRT_TENDER_HIST', 'COLUMN', N'TENDER_VALUE'
GO

