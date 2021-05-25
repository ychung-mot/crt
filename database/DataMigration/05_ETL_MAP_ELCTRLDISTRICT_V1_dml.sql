/*** Script to retrieve data from legacy tables 
	and map that data to the new CRT code lookup
	tables.

	This script maps all legacy electoral districts
	regardless of activity, as there are a few 
	inactive ED's that are still referenced. The 
	script will remap them.

***/

BEGIN TRANSACTION

IF OBJECT_ID('dbo.MAP_ELECTORAL_DISTRICT', 'U') IS NOT NULL
	DROP TABLE dbo.MAP_ELECTORAL_DISTRICT;

COMMIT
GO

BEGIN TRANSACTION

CREATE TABLE dbo.MAP_ELECTORAL_DISTRICT
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

DECLARE ed_cursor CURSOR FOR
    SELECT ed.ID, ed.[ED Name], ccl.CODE_LOOKUP_ID, ccl.CODE_NAME 
		FROM CRT_CODE_LOOKUP ccl
		JOIN tblElectoralDistricts ed
		ON REPLACE(ed.[ED Abreviation], '?', '') = ccl.CODE_VALUE_TEXT
		WHERE ccl.CODE_SET = 'ELECTORAL_DISTRICT'
		AND ccl.END_DATE IS NULL
    --AND ed.Active = 1
    --ORDER BY ccl.CODE_NAME
	UNION	--the union will handle the exceptions where the DISTRICT CODE has changed
	SELECT LegacyED.ID, LegacyED.[ED Name], CRT_ED.CODE_LOOKUP_ID, CRT_ED.CODE_NAME FROM 
		(SELECT ROW_NUMBER() OVER(ORDER BY [ED Name] ASC) AS Row, ID, [ED Name]
		FROM tblElectoralDistricts 
		WHERE ID IN (190, 199, 206, 241, 242, 260, 261)) AS LegacyED
	JOIN 
		(SELECT ROW_NUMBER() OVER(ORDER BY CODE_NAME ASC) AS Row, CODE_LOOKUP_ID, CODE_NAME 
		FROM CRT_CODE_LOOKUP 
		WHERE CODE_SET = 'ELECTORAL_DISTRICT'
		AND CODE_VALUE_TEXT IN ('CRC', 'KLM', 'MAM', 'SUN', 'SUP', 'WVC', 'WVS')) AS CRT_ED
	ON LegacyED.Row = CRT_ED.Row

OPEN ed_cursor

WHILE 1 = 1
BEGIN
	FETCH NEXT FROM ed_cursor into @legacyId, @legacyName, @codeId, @codeName;

	IF @@FETCH_STATUS <> 0
	BEGIN
		BREAK;
	END;
	
	--e.g. INSERT INTO MAP_ELECTORAL_DISTRICT VALUES (175, 818); --Abbotsford - Mission

	SET @cmd = N'INSERT INTO MAP_ELECTORAL_DISTRICT VALUES (' + CAST(@legacyId AS varchar) + ', ' + CAST(@codeId AS varchar) + '); --' + @codeName;

	PRINT @cmd;
	EXEC sp_executesql @cmd;
END;

CLOSE ed_cursor
DEALLOCATE ed_cursor


COMMIT
GO

DECLARE @legacyCnt int, @legacyInactiveCnt int, @crtCnt int, @mappedCnt int;

-- retrieve values from Legacy table
SELECT @legacyCnt = COUNT(*) FROM tblElectoralDistricts
WHERE Active = 1

SELECT @legacyInactiveCnt = COUNT(*) FROM tblElectoralDistricts
WHERE Active = 0

--retrieve values from CRT Code Table
SELECT @crtCnt = COUNT(*) 
FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'ELECTORAL_DISTRICT'
AND END_DATE IS NULL

SELECT @mappedCnt = COUNT(*) 
FROM MAP_ELECTORAL_DISTRICT

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Active Legacy Items and ' 
	+ CONVERT(varchar, @legacyInactiveCnt) + ' Inactive Legacy Items. A total of ' + CONVERT(varchar, @legacyInactiveCnt + @legacyCnt)
PRINT 'Found ' + CONVERT(varchar, @crtCnt) + ' CRT CodeLookup Items'
PRINT 'Mapped ' + CONVERT(varchar, @mappedCnt) + ' Total Items'

BEGIN
	DECLARE @missing int;

	SELECT @missing = COUNT(*) 
	FROM tblEDRatios
	WHERE [Electoral District] IN (SELECT ID FROM 
		(SELECT * FROM MAP_ELECTORAL_DISTRICT med
		RIGHT JOIN tblElectoralDistricts ted
		ON ted.ID = med.LEGACY_ID) AS ED
		WHERE LEGACY_ID IS NULL)

	PRINT 'Found ' + CONVERT(varchar, @missing) + ' Electoral District Ratios linked to un-mapped Electoral Districts'
END

/*
 -- there should be 11 that didn't map!
 -- we can validate the ones that didn't map aren't
 -- linked using the below query

SELECT *
FROM tblEDRatios
	WHERE [Electoral District] IN (SELECT ID FROM 
	(SELECT * FROM MAP_ELECTORAL_DISTRICT med
	RIGHT JOIN tblElectoralDistricts ted
	ON ted.ID = med.LEGACY_ID) AS ED
	WHERE LEGACY_ID IS NULL)
*/