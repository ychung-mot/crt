/*** Script to retrieve data from legacy tables 
	and map that data to the new CRT code lookup
	tables.

  -- retrieve values from Legacy table
SELECT ID, [RCNumber], [RCDescription] FROM tblRC
WHERE Active = 1
ORDER BY [RCDescription] ASC

--retrieve values from CRT Code Table
SELECT CODE_LOOKUP_ID, CODE_VALUE_TEXT, CODE_NAME FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'RC'
AND END_DATE IS NULL

***/

BEGIN TRANSACTION
GO
IF OBJECT_ID('dbo.MAP_RC', 'U') IS NOT NULL
	DROP TABLE dbo.MAP_RC;
COMMIT

BEGIN TRANSACTION
GO
CREATE TABLE dbo.MAP_RC
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

DECLARE rc_cursor CURSOR FOR
	SELECT rc.ID, rc.[RCDescription], cl.CODE_LOOKUP_ID, cl.CODE_NAME
	FROM CRT_CODE_LOOKUP cl
	JOIN tblRC rc
	ON rc.[RCNumber] = cl.CODE_VALUE_TEXT
	WHERE cl.CODE_SET = 'RC'
	AND cl.END_DATE IS NULL
	AND Active = 1
	ORDER BY cl.CODE_NAME, rc.RCDescription

OPEN rc_cursor

WHILE 1 = 1
BEGIN
	FETCH NEXT FROM rc_cursor into @legacyId, @legacyName, @codeId, @codeName;

	IF @@FETCH_STATUS <> 0
	BEGIN
		BREAK;
	END;
	
	--e.g. INSERT INTO MAP_RC VALUES (28, 34); --Active Transportation
	SET @cmd = N'INSERT INTO MAP_RC VALUES (' + CAST(@legacyId AS varchar) + ', ' + CAST(@codeId AS varchar) + '); --' + @codeName;

	PRINT @cmd;
	EXEC sp_executesql @cmd;
END;

CLOSE rc_cursor
DEALLOCATE rc_cursor

COMMIT
GO

DECLARE @legacyCnt int, @crtCnt int, @mappedCnt int;

-- retrieve values from Legacy table
SELECT @legacyCnt = COUNT(*) FROM tblRC
WHERE Active = 1

--retrieve values from CRT Code Table
SELECT @crtCnt = COUNT(*) 
FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'RC'
AND END_DATE IS NULL

SELECT @mappedCnt = COUNT(*) 
FROM MAP_RC

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy Items and ' + CONVERT(varchar, @crtCnt) + ' CRT CodeLookup Items'
PRINT 'Mapped ' + CONVERT(varchar, @mappedCnt) + ' Total Items'

--SELECT * FROM MAP_RC

BEGIN
	DECLARE @missing int;

	SELECT @missing = COUNT(*) 
	FROM tblProjects
	WHERE DefaultRC IN (SELECT ID FROM 
		(SELECT * FROM MAP_RC mrc
		RIGHT JOIN tblRC trc
		ON trc.ID = mrc.LEGACY_ID
		WHERE trc.Active = 1) AS RC
		WHERE LEGACY_ID IS NULL)

	PRINT 'Found ' + CONVERT(varchar, @missing) + ' Projects linked to un-mapped RC'
END

/*
-- Should find Zero!

SELECT *
FROM tblProjects
WHERE DefaultRC IN (SELECT ID FROM 
	(SELECT * FROM MAP_RC mrc
	RIGHT JOIN tblRC trc
	ON trc.ID = mrc.LEGACY_ID
	WHERE trc.Active = 1) AS RC
	WHERE LEGACY_ID IS NULL)
*/