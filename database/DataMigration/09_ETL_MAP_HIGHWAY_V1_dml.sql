/*** Script to retrieve data from legacy tables 
	and map that data to the new CRT code lookup
	tables.
	
  -- retrieve values from Legacy table
SELECT COUNT(*) FROM tblHighways
WHERE Active = 1
ORDER BY [MSNumber] ASC

--retrieve values from CRT Code Table
SELECT COUNT(*) FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'HIGHWAY'
AND END_DATE IS NULL

***/

BEGIN TRANSACTION
GO
IF OBJECT_ID('dbo.MAP_HIGHWAY', 'U') IS NOT NULL
	DROP TABLE dbo.MAP_HIGHWAY;
COMMIT

BEGIN TRANSACTION
GO
CREATE TABLE dbo.MAP_HIGHWAY
(
	LEGACY_ID numeric(9, 0) NOT NULL,
	CRT_ID numeric(9, 0) NOT NULL
)  ON [PRIMARY]
GO
COMMIT

BEGIN TRANSACTION

SET NOCOUNT ON;

DECLARE @legacyId int, @codeId int;
DECLARE @legacyName nvarchar(255), @codeName varchar(255);
DECLARE @cmd nvarchar(max);

DECLARE hw_cursor CURSOR FOR
	SELECT hw.ID, hw.Highway, cl.CODE_LOOKUP_ID, cl.CODE_NAME
	FROM CRT_CODE_LOOKUP cl
	JOIN tblHighways hw
	ON hw.[MSNumber] = cl.CODE_VALUE_TEXT
	WHERE cl.CODE_SET = 'HIGHWAY'
	AND cl.END_DATE IS NULL
	AND Active = 1
	ORDER BY cl.CODE_NAME, hw.Highway

OPEN hw_cursor

WHILE 1 = 1
BEGIN
	FETCH NEXT FROM hw_cursor into @legacyId, @legacyName, @codeId, @codeName;

	IF @@FETCH_STATUS <> 0
	BEGIN
		BREAK;
	END;
	
	--e.g. INSERT INTO MAP_HIGHWAY VALUES (50, 748); --All Hwys
	SET @cmd = N'INSERT INTO MAP_HIGHWAY VALUES (' + CAST(@legacyId AS varchar) + ', ' + CAST(@codeId AS varchar) + '); --' + @codeName;

	PRINT @cmd;
	EXEC sp_executesql @cmd;
END;

CLOSE hw_cursor
DEALLOCATE hw_cursor

COMMIT
GO

DECLARE @legacyCnt int, @crtCnt int, @mappedCnt int;

-- retrieve values from Legacy table
SELECT @legacyCnt = COUNT(*) FROM tblHighways
WHERE Active = 1

--retrieve values from CRT Code Table
SELECT @crtCnt = COUNT(*) 
FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'HIGHWAY'
AND END_DATE IS NULL

SELECT @mappedCnt = COUNT(*) 
FROM MAP_HIGHWAY

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy Items and ' + CONVERT(varchar, @crtCnt) + ' CRT CodeLookup Items'
PRINT 'Mapped ' + CONVERT(varchar, @mappedCnt) + ' Total Items'

--SELECT * FROM MAP_HIGHWAY

BEGIN
	DECLARE @missing int;

	SELECT @missing = COUNT(*) 
	FROM tblHighwayRatios 
	WHERE Highway IN (SELECT ID FROM 
		(SELECT * FROM MAP_HIGHWAY mh
		RIGHT JOIN tblHighways th
		ON th.ID = mh.LEGACY_ID
		WHERE th.Active = 1) AS Highway
		WHERE LEGACY_ID IS NULL)

	PRINT 'Found ' + CONVERT(varchar, @missing) + ' Highway Ratios linked to un-mapped Highways'
END

/*
-- Should find zero!

SELECT *
FROM tblHighwayRatios 
WHERE Highway IN (SELECT ID FROM 
	(SELECT * FROM MAP_HIGHWAY mh
	RIGHT JOIN tblHighways th
	ON th.ID = mh.LEGACY_ID
	WHERE th.Active = 1) AS Highway
	WHERE LEGACY_ID IS NULL)
*/
