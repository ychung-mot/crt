/*** Script to retrieve data from legacy tables 
	and map that data to the new CRT code lookup
	tables.

-- retrieve values from Legacy table
SELECT ID, [Index Description] FROM tblCaptialIndexes
WHERE Active = 1
ORDER BY [Index Number] DESC

--retrieve values from CRT Code Table
SELECT CODE_LOOKUP_ID, CODE_NAME FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'CAP_INDX'
AND END_DATE IS NULL

***/

BEGIN TRANSACTION

IF OBJECT_ID('dbo.MAP_CAP_INDX', 'U') IS NOT NULL
	DROP TABLE dbo.MAP_CAP_INDX;
COMMIT
GO

BEGIN TRANSACTION

CREATE TABLE dbo.MAP_CAP_INDX
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

DECLARE ci_cursor CURSOR FOR
	SELECT ci.ID, ci.[Index Description], cl.CODE_LOOKUP_ID, cl.CODE_NAME
	FROM CRT_CODE_LOOKUP cl
	JOIN tblCaptialIndexes ci
	ON ci.[Index Number] = cl.CODE_VALUE_TEXT
	WHERE cl.CODE_SET = 'CAP_INDX'
	AND cl.END_DATE IS NULL
	ORDER BY cl.CODE_VALUE_TEXT, ci.[Index Number]

OPEN ci_cursor

WHILE 1 = 1
BEGIN
	FETCH NEXT FROM ci_cursor into @legacyId, @legacyName, @codeId, @codeName;

	IF @@FETCH_STATUS <> 0
	BEGIN
		BREAK;
	END;
	
	--INSERT INTO MAP_CAP_INDX VALUES (6, 6);  --Capitalizable/Expense-Some components<15yrs

	SET @cmd = N'INSERT INTO MAP_CAP_INDX VALUES (' + CAST(@legacyId AS varchar) + ', ' + CAST(@codeId AS varchar) + '); --' + @codeName;

	PRINT @cmd;
	EXEC sp_executesql @cmd;
END;

CLOSE ci_cursor
DEALLOCATE ci_cursor

COMMIT
GO

DECLARE @legacyCnt int, @crtCnt int, @mappedCnt int;

-- retrieve values from Legacy table
SELECT @legacyCnt = COUNT(*) 
FROM tblCaptialIndexes
WHERE Active = 1

--retrieve values from CRT Code Table
SELECT @crtCnt = COUNT(*) 
FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'CAP_INDX'
AND END_DATE IS NULL

SELECT @mappedCnt = COUNT(*) 
FROM MAP_CAP_INDX

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy Items and ' + CONVERT(varchar, @crtCnt) + ' CRT CodeLookup Items'
PRINT 'Mapped ' + CONVERT(varchar, @mappedCnt) + ' Total Items'

--SELECT * FROM MAP_CAP_INDX

BEGIN
	DECLARE @missing int;

	SELECT @missing = COUNT(*) 
	FROM tblProjects
	WHERE [Capital Index] IN (SELECT ID FROM 
		(SELECT * FROM MAP_CAP_INDX mci
		RIGHT JOIN tblCaptialIndexes tci
		ON tci.ID = mci.LEGACY_ID
		WHERE tci.Active = 1) AS CapIndex
		WHERE LEGACY_ID IS NULL)

	PRINT 'Found ' + CONVERT(varchar, @missing) + ' Project Capital Indexes linked to un-mapped Capital Indexes'
END

/*
-- Should be zero unmaps found!

SELECT *
FROM tblProjects
WHERE [Capital Index] IN (SELECT ID FROM 
	(SELECT * FROM MAP_CAP_INDX mci
	RIGHT JOIN tblCaptialIndexes tci
	ON tci.ID = mci.LEGACY_ID
	WHERE tci.Active = 1) AS CapIndex
	WHERE LEGACY_ID IS NULL)
*/
