DECLARE @utcdate DATETIME = (SELECT getutcdate() AS utcdate)
DECLARE @app_guid UNIQUEIDENTIFIER = (SELECT CASE WHEN SUSER_SID() IS NOT NULL THEN SUSER_SID() ELSE (SELECT CONVERT(uniqueidentifier,STUFF(STUFF(STUFF(STUFF('B00D00A0AC0A0D0C00DD00F0D0C00000',9,0,'-'),14,0,'-'),19,0,'-'),24,0,'-'))) END AS  app_guid)
DECLARE @app_user VARCHAR(30) = (SELECT CASE WHEN SUBSTRING(SUSER_NAME(),CHARINDEX('\',SUSER_NAME())+1,LEN(SUSER_NAME())) IS NOT NULL THEN SUBSTRING(SUSER_NAME(),CHARINDEX('\',SUSER_NAME())+1,LEN(SUSER_NAME())) ELSE CURRENT_USER END AS app_user)
DECLARE @app_user_dir VARCHAR(12) = (SELECT CASE WHEN LEN(SUBSTRING(SUSER_NAME(),0,CHARINDEX('\',SUSER_NAME(),0)))>1 THEN SUBSTRING(SUSER_NAME(),0,CHARINDEX('\',SUSER_NAME(),0)) ELSE 'WIN AUTH' END AS app_user_dir)

INSERT INTO CRT_QTY_ACCMP
	(PROJECT_ID
	,FISCAL_YEAR_LKUP_ID
	,QTY_ACCMP_LKUP_ID
	,FORECAST
	,SCHEDULE7
	,ACTUAL
	,COMMENT
	,APP_CREATE_USERID
	,APP_CREATE_TIMESTAMP
	,APP_CREATE_USER_GUID
	,APP_LAST_UPDATE_USERID
	,APP_LAST_UPDATE_TIMESTAMP
	,APP_LAST_UPDATE_USER_GUID)
SELECT mp.CRT_ID AS PROJECT_ID
    , mfy.CRT_ID AS FISCAL_YEAR_ID
    , ma.CRT_ID AS ACCOMPLISHMENT_ID
    , tpa.[Forecast Quantity]
    , tpa.Schedule7
    , tpa.[Actual Quantity]
    , tpa.Comments
    , @app_user
    , @utcdate
    
    , @app_guid
    , @app_user
    , @utcdate
    , @app_guid
FROM tblProjectAccomplishments tpa
JOIN MAP_FISCAL_YEAR mfy
ON mfy.LEGACY_ID = tpa.[Fiscal Year]
JOIN MAP_ACCOMPLISHMENT ma
ON ma.LEGACY_ID = tpa.Accomplishment
JOIN MAP_PROJECT mp
ON mp.LEGACY_ID = tpa.Project

DECLARE @legacyCnt int, @crtCnt int, @mappedCnt int;

SELECT @legacyCnt = COUNT(*) FROM tblProjectAccomplishments
SELECT @crtCnt = COUNT(*) FROM CRT_QTY_ACCMP

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy QtyAccmp and ' + CONVERT(varchar, @crtCnt) + ' CRT QtyAccmp'

--NOTE there is one project 8509 that has 3 accomplishments but the project NO longer exists in the DB