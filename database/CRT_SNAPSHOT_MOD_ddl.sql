-- =============================================
-- Author:		Young-Jin Chung
-- Create date: 2020-12-01
-- Updates: 
-- 
-- =============================================

USE master;
GO

ALTER DATABASE CRT_DEV SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO

ALTER DATABASE CRT_DEV  
SET ALLOW_SNAPSHOT_ISOLATION ON;
GO

ALTER DATABASE CRT_DEV  
SET READ_COMMITTED_SNAPSHOT ON;
GO

ALTER DATABASE CRT_DEV SET MULTI_USER
GO