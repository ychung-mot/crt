BEGIN TRANSACTION

DECLARE @utcdate DATETIME = (SELECT getutcdate() AS utcdate)
DECLARE @app_guid UNIQUEIDENTIFIER = (SELECT CASE WHEN SUSER_SID() IS NOT NULL THEN SUSER_SID() ELSE (SELECT CONVERT(uniqueidentifier,STUFF(STUFF(STUFF(STUFF('B00D00A0AC0A0D0C00DD00F0D0C00000',9,0,'-'),14,0,'-'),19,0,'-'),24,0,'-'))) END AS  app_guid)
DECLARE @app_user VARCHAR(30) = (SELECT CASE WHEN SUBSTRING(SUSER_NAME(),CHARINDEX('\',SUSER_NAME())+1,LEN(SUSER_NAME())) IS NOT NULL THEN SUBSTRING(SUSER_NAME(),CHARINDEX('\',SUSER_NAME())+1,LEN(SUSER_NAME())) ELSE CURRENT_USER END AS app_user)
DECLARE @app_user_dir VARCHAR(12) = (SELECT CASE WHEN LEN(SUBSTRING(SUSER_NAME(),0,CHARINDEX('\',SUSER_NAME(),0)))>1 THEN SUBSTRING(SUSER_NAME(),0,CHARINDEX('\',SUSER_NAME(),0)) ELSE 'WIN AUTH' END AS app_user_dir)

DECLARE @projectId int, @bidId int, @isWinningBid int;
DECLARE @bidSeq int = 1;

DECLARE proj_cursor CURSOR FOR
SELECT DISTINCT(ProjectId) FROM tblProjectTenderBids

OPEN proj_cursor

WHILE 1 = 1
BEGIN
	FETCH NEXT FROM proj_cursor INTO @projectId

	IF @@FETCH_STATUS <> 0
	BEGIN
		BREAK;
	END;

	DECLARE bid_cursor CURSOR FOR
		SELECT ID, [Winning Bid]
		FROM 
			(SELECT ROW_NUMBER() OVER(ORDER BY SharePointModifiedDate DESC) AS Row, ID, [Winning Bid] 
			FROM tblProjectTenderBids 
			WHERE ProjectId = @projectId AND [Winning Bid] = 1) AS LegacyBids
		WHERE Row = 1;
	
	OPEN bid_cursor

	WHILE 1 = 1
	BEGIN
		FETCH NEXT FROM bid_cursor INTO @bidId, @isWinningBid;

		IF @@FETCH_STATUS <> 0
		BEGIN
			BREAK;
		END;
		
		IF @isWinningBid = 1
		BEGIN

			INSERT INTO CRT_TENDER
				(PROJECT_ID
				,TENDER_NUMBER
				,PLANNED_DATE
				,ACTUAL_DATE
				,TENDER_VALUE
				,WINNING_CNTRCTR_LKUP_ID
				,BID_VALUE
				,COMMENT
				,APP_CREATE_USERID
				,APP_CREATE_TIMESTAMP
				,APP_CREATE_USER_GUID
				,APP_LAST_UPDATE_USERID
				,APP_LAST_UPDATE_TIMESTAMP
				,APP_LAST_UPDATE_USER_GUID)
			SELECT mp.CRT_ID AS PROJECT_ID
				 , CONVERT(varchar, prj.ProjectNumber) + '-TEMP-' + CONVERT(varchar, @bidSeq) AS TENDER_NUMBER
				 , prj.[Forecast Tender Date] AS PLANNED_DATE
				 , prj.[Actual Tender Date] AS ACTUAL_DATE
				 , (prj.[Tender Estimate] * 1000) AS TENDER_VALUE
				 , CASE 
					WHEN ptb.[Winning Bid] = 1 
					THEN mc.CRT_ID 
					ELSE NULL 
				   END AS WINNING_CTRCTR_ID
				 , ptb.[Bid Value] AS BID_VALUE
				 , 'Temporary tender# assigned for records from Access DB. ' + CHAR(10) + ptb.Comments AS COMMENT
				 , @app_user
				 , @utcdate
				 , @app_guid
				 , @app_user
				 , @utcdate
				 , @app_guid
			FROM tblProjectTenderBids ptb
			JOIN tblProjects prj
			ON prj.ID = ptb.ProjectId
			JOIN MAP_PROJECT mp
			ON mp.LEGACY_ID = prj.ID
			LEFT JOIN MAP_CONTRACTOR mc
			ON mc.LEGACY_ID = ContractorId
			WHERE ptb.ID = @bidId

			SET @bidSeq = @bidSeq + 1;

			PRINT 'Project ' + CONVERT(varchar, @projectId) + ' - Bid ' + CONVERT(varchar, @bidId) + ' IsWinningBid: ' + CONVERT(varchar, @isWinningBid) + ' Seq: ' + CONVERT(varchar, @bidSeq) ;
		END		
	END;

	CLOSE bid_cursor;
	DEALLOCATE bid_cursor;
END;

CLOSE proj_cursor;
DEALLOCATE proj_cursor;

COMMIT
GO

DECLARE @legacyCnt int, @crtCnt int, @mappedCnt int;

SELECT @legacyCnt = COUNT(*) FROM tblProjectTenderBids WHERE [Winning Bid] = 1
SELECT @crtCnt = COUNT(*) FROM CRT_TENDER

/*NOTE: one project as 3 tenders marked as winning bid, but we only import one of them
adjusting the count to accomodate for this*/
PRINT CHAR(10) + 'Found ' + CONVERT(varchar, (@legacyCnt - 2)) + ' Legacy Tender and ' + CONVERT(varchar, @crtCnt) + ' CRT Tender'
