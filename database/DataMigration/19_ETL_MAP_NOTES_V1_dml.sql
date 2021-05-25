BEGIN TRANSACTION

DECLARE @utcdate DATETIME = (SELECT getutcdate() AS utcdate)
DECLARE @app_guid UNIQUEIDENTIFIER = (SELECT CASE WHEN SUSER_SID() IS NOT NULL THEN SUSER_SID() ELSE (SELECT CONVERT(uniqueidentifier,STUFF(STUFF(STUFF(STUFF('B00D00A0AC0A0D0C00DD00F0D0C00000',9,0,'-'),14,0,'-'),19,0,'-'),24,0,'-'))) END AS  app_guid)
DECLARE @app_user VARCHAR(30) = (SELECT CASE WHEN SUBSTRING(SUSER_NAME(),CHARINDEX('\',SUSER_NAME())+1,LEN(SUSER_NAME())) IS NOT NULL THEN SUBSTRING(SUSER_NAME(),CHARINDEX('\',SUSER_NAME())+1,LEN(SUSER_NAME())) ELSE CURRENT_USER END AS app_user)
DECLARE @app_user_dir VARCHAR(12) = (SELECT CASE WHEN LEN(SUBSTRING(SUSER_NAME(),0,CHARINDEX('\',SUSER_NAME(),0)))>1 THEN SUBSTRING(SUSER_NAME(),0,CHARINDEX('\',SUSER_NAME(),0)) ELSE 'WIN AUTH' END AS app_user_dir)

INSERT INTO CRT_NOTE
	(NOTE_TYPE
	,COMMENT
	,PROJECT_ID
	,APP_CREATE_USERID
	,APP_CREATE_TIMESTAMP
	,APP_CREATE_USER_GUID
	,APP_LAST_UPDATE_USERID
	,APP_LAST_UPDATE_TIMESTAMP
	,APP_LAST_UPDATE_USER_GUID)
SELECT 'STATUS'
	 , tp.[Status Comments] 
	 , mp.CRT_ID AS PROJECT_ID
	 , @app_user
	 , @utcdate
	 , @app_guid
	 , @app_user
	 , @utcdate
	 , @app_guid
FROM tblProjects tp
JOIN MAP_PROJECT mp
ON mp.LEGACY_ID = tp.ID
WHERE [Status Comments] IS NOT NULL

INSERT INTO CRT_NOTE
	(NOTE_TYPE
	,COMMENT
	,PROJECT_ID
	,APP_CREATE_USERID
	,APP_CREATE_TIMESTAMP
	,APP_CREATE_USER_GUID
	,APP_LAST_UPDATE_USERID
	,APP_LAST_UPDATE_TIMESTAMP
	,APP_LAST_UPDATE_USER_GUID)
SELECT 'EMR'
	 , tp.[EMR Comments] 
	 , mp.CRT_ID AS PROJECT_ID
	 , @app_user
	 , @utcdate
	 , @app_guid
	 , @app_user
	 , @utcdate
	 , @app_guid
FROM tblProjects tp
JOIN MAP_PROJECT mp
ON mp.LEGACY_ID = tp.ID
WHERE [EMR Comments] IS NOT NULL

COMMIT
GO

DECLARE @legacyCnt int, @crtCnt int, @mappedCnt int;

SELECT @legacyCnt = COUNT(*) FROM tblProjects WHERE [EMR Comments] IS NOT NULL
SELECT @crtCnt = COUNT(*) FROM CRT_NOTE WHERE NOTE_TYPE = 'EMR'

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy EMR Notes and ' + CONVERT(varchar, @crtCnt) + ' CRT EMR Note Items'

SELECT @legacyCnt = COUNT(*) FROM tblProjects WHERE [Status Comments] IS NOT NULL
SELECT @crtCnt = COUNT(*) FROM CRT_NOTE WHERE NOTE_TYPE = 'STATUS'

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy STATUS Notes and ' + CONVERT(varchar, @crtCnt) + ' CRT STATUS Note Items'