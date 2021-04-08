/*** Script to retrieve data from legacy tables 
	and map that data to the new CRT code lookup
	tables.

-- retrieve values from Legacy table
SELECT ID, [Geo Region Name] FROM tblRegions
ORDER BY [Geo Region Name]

--retrieve values from CRT Code Table
SELECT CODE_LOOKUP_ID, CODE_NAME FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'ECONOMIC_REGION'
AND END_DATE IS NULL
ORDER BY CODE_NAME

***/

BEGIN TRANSACTION

IF OBJECT_ID('dbo.MAP_ECONOMIC_REGION', 'U') IS NOT NULL
	DROP TABLE dbo.MAP_ECONOMIC_REGION;
COMMIT
GO

BEGIN TRANSACTION

CREATE TABLE dbo.MAP_ECONOMIC_REGION
(
	LEGACY_ID numeric(9, 0) NOT NULL,
	CRT_ID numeric(9, 0) NOT NULL
)  ON [PRIMARY]

COMMIT
GO

BEGIN TRANSACTION

SET NOCOUNT ON;

DECLARE @legacyId int, @codeId int;
DECLARE @legacyName nvarchar(255), @codeName varchar(255);
DECLARE @cmd nvarchar(max);

DECLARE er_cursor CURSOR FOR
	SELECT r.ID, r.[Geo Region Name], cl.CODE_LOOKUP_ID, cl.CODE_NAME
	FROM CRT_CODE_LOOKUP cl
	JOIN tblRegions r
	ON r.[Geo Region Name] = cl.CODE_NAME
	WHERE cl.CODE_SET = 'ECONOMIC_REGION'
	AND cl.END_DATE IS NULL
	ORDER BY cl.CODE_NAME, r.[Geo Region Name]

OPEN er_cursor

WHILE 1 = 1
BEGIN
	FETCH NEXT FROM er_cursor into @legacyId, @legacyName, @codeId, @codeName;

	IF @@FETCH_STATUS <> 0
	BEGIN
		BREAK;
	END;
	
	--INSERT INTO MAP_ECONOMIC_REGION VALUES (5, 520);  --Cariboo

	SET @cmd = N'INSERT INTO MAP_ECONOMIC_REGION VALUES (' + CAST(@legacyId AS varchar) + ', ' + CAST(@codeId AS varchar) + '); --' + @codeName;

	PRINT @cmd;
	EXEC sp_executesql @cmd;
END;

CLOSE er_cursor
DEALLOCATE er_cursor

COMMIT
GO

DECLARE @legacyCnt int, @crtCnt int, @mappedCnt int;

-- retrieve values from Legacy table
SELECT @legacyCnt = COUNT(*) 
FROM tblRegions

--retrieve values from CRT Code Table
SELECT @crtCnt = COUNT(*) 
FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'ECONOMIC_REGION'
AND END_DATE IS NULL

SELECT @mappedCnt = COUNT(*) 
FROM MAP_ECONOMIC_REGION

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy Items and ' + CONVERT(varchar, @crtCnt) + ' CRT CodeLookup Items'
PRINT 'Mapped ' + CONVERT(varchar, @mappedCnt) + ' Total Items'

--SELECT * FROM MAP_ECONOMIC_REGION

BEGIN
	DECLARE @missing int;

	SELECT @missing = COUNT(*) 
	FROM tblEconRegionRatio
	WHERE EconRegion IN (SELECT ID FROM 
		(SELECT * FROM MAP_ECONOMIC_REGION mer
		RIGHT JOIN tblRegions tr
		ON tr.ID = mer.LEGACY_ID) AS Regions
		WHERE LEGACY_ID IS NULL)

	PRINT 'Found ' + CONVERT(varchar, @missing) + ' Project Accomplishments linked to un-mapped QtyAccomp'
END

/*
-- Should be zero

SELECT *
FROM tblEconRegionRatio
WHERE EconRegion IN (SELECT ID FROM 
	(SELECT * FROM MAP_ECONOMIC_REGION mer
	RIGHT JOIN tblRegions tr
	ON tr.ID = mer.LEGACY_ID) AS Regions
	WHERE LEGACY_ID IS NULL)
*/