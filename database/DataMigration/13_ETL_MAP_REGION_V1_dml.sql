/*** Scripts to retrieve data, inject into appropriate worksheet of excel workbook ./Mapping.xslx

-- retrieve values from Legacy table
SELECT ID, RegionShort FROM tblMOTIRegions
WHERE Active = 1
ORDER BY RegionShort

--retrieve values from CRT Code Table
SELECT REGION_ID, REGION_NAME FROM CRT_REGION
WHERE END_DATE IS NULL
ORDER BY REGION_NAME

***/

BEGIN TRANSACTION

IF OBJECT_ID('dbo.MAP_REGION', 'U') IS NOT NULL
	DROP TABLE dbo.MAP_REGION;
COMMIT
GO

BEGIN TRANSACTION

CREATE TABLE dbo.MAP_REGION
(
	LEGACY_ID numeric(9, 0) NOT NULL,
	CRT_ID numeric(9, 0) NOT NULL
)  ON [PRIMARY]

COMMIT
GO

BEGIN TRANSACTION
SET NOCOUNT ON

INSERT INTO MAP_REGION VALUES (6, 1);  --Headquarters > ENG
INSERT INTO MAP_REGION VALUES (4, 1);  --Headquarters > HQ
INSERT INTO MAP_REGION VALUES (3, 4);  --Northern > NR
INSERT INTO MAP_REGION VALUES (1, 2);  --South Coast > SCR
INSERT INTO MAP_REGION VALUES (2, 3);  --Southern Interior > SIR

COMMIT
GO


DECLARE @legacyCnt int, @crtCnt int, @mappedCnt int;

-- retrieve values from Legacy table
SELECT @legacyCnt = COUNT(*) 
FROM tblMOTIRegions
WHERE Active = 1

--retrieve values from CRT Code Table
SELECT @crtCnt = COUNT(*) 
FROM CRT_REGION
WHERE END_DATE IS NULL

SELECT @mappedCnt = COUNT(*) 
FROM MAP_REGION

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy Items and ' + CONVERT(varchar, @crtCnt) + ' CRT Region Items'
PRINT 'Mapped ' + CONVERT(varchar, @mappedCnt) + ' Total Items'

--SELECT * FROM MAP_REGION

BEGIN
	DECLARE @missing int;

	SELECT @missing = COUNT(*) 
	FROM tblProjects
	WHERE [MOTI Region] IN (SELECT ID FROM 
		(SELECT * FROM MAP_REGION mr
		RIGHT JOIN tblMOTIRegions tmr
		ON tmr.ID = mr.LEGACY_ID
		WHERE tmr.Active = 1) AS Region
		WHERE LEGACY_ID IS NULL)

	PRINT 'Found ' + CONVERT(varchar, @missing) + ' Projects linked to un-mapped Regions'
END

/*
-- Should find zero!

SELECT [MOTI Region], *
FROM tblProjects
	WHERE [MOTI Region] IN (SELECT ID FROM 
		(SELECT * FROM MAP_REGION mr
		RIGHT JOIN tblMOTIRegions tmr
		ON tmr.ID = mr.LEGACY_ID
		WHERE tmr.Active = 1) AS Region
		WHERE LEGACY_ID IS NULL)
*/
