
/*** Script to retrieve data from legacy tables 
	and map that data to the new CRT code lookup
	tables.

-- retrieve values from Legacy table
SELECT  ID, [Service Area Name] FROM tblServiceAreas
WHERE Active = 1

--retrieve values from CRT Code Table
SELECT SERVICE_AREA_ID, SERVICE_AREA_NAME FROM CRT_SERVICE_AREA
WHERE END_DATE IS NULL

***/

BEGIN TRANSACTION

IF OBJECT_ID('dbo.MAP_SERVICE_AREA', 'U') IS NOT NULL
	DROP TABLE dbo.MAP_SERVICE_AREA;
COMMIT
GO

BEGIN TRANSACTION

CREATE TABLE dbo.MAP_SERVICE_AREA
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

DECLARE srv_cursor CURSOR FOR
	SELECT tsa.ID, tsa.[Service Area Name], sa.SERVICE_AREA_ID, sa.SERVICE_AREA_NAME
	FROM CRT_SERVICE_AREA sa
	JOIN tblServiceAreas tsa
	ON tsa.[Service Area Number] = sa.SERVICE_AREA_NUMBER
	AND sa.END_DATE IS NULL
	ORDER BY sa.SERVICE_AREA_NUMBER, tsa.[Service Area Number]

OPEN srv_cursor

WHILE 1 = 1
BEGIN
	FETCH NEXT FROM srv_cursor into @legacyId, @legacyName, @codeId, @codeName;

	IF @@FETCH_STATUS <> 0
	BEGIN
		BREAK;
	END;
	
	--INSERT INTO MAP_SERVICE_AREA VALUES (6, 6);  --Capitalizable/Expense-Some components<15yrs

	SET @cmd = N'INSERT INTO MAP_SERVICE_AREA VALUES (' + CAST(@legacyId AS varchar) + ', ' + CAST(@codeId AS varchar) + '); --' + @codeName;

	PRINT @cmd;
	EXEC sp_executesql @cmd;
END;

CLOSE srv_cursor
DEALLOCATE srv_cursor

COMMIT
GO

DECLARE @legacyCnt int, @crtCnt int, @mappedCnt int;

-- retrieve values from Legacy table
SELECT @legacyCnt = COUNT(*) 
FROM tblServiceAreas
WHERE Active = 1

--retrieve values from CRT Code Table
SELECT @crtCnt = COUNT(*) 
FROM CRT_SERVICE_AREA
WHERE END_DATE IS NULL

SELECT @mappedCnt = COUNT(*) 
FROM MAP_SERVICE_AREA

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy Items and ' + CONVERT(varchar, @crtCnt) + ' CRT Service Areas'
PRINT 'Mapped ' + CONVERT(varchar, @mappedCnt) + ' Total Items'

--SELECT * FROM MAP_SERVICE_AREA

BEGIN
	DECLARE @missing int;

	SELECT @missing = COUNT(*) 
	FROM tblServiceAreaRatios
	WHERE [Service Area] IN (SELECT ID FROM 
		(SELECT * FROM MAP_SERVICE_AREA md
		RIGHT JOIN tblServiceAreas td
		ON td.ID = md.LEGACY_ID
		WHERE td.Active = 1) AS ServiceArea
		WHERE LEGACY_ID IS NULL)

	PRINT 'Found ' + CONVERT(varchar, @missing) + ' Project Ratios linked to un-mapped Ratio Service Area'
END

/*
-- Should be unmapped, the discrepancy in legacy to CRT numbers is due to bad service area data in the access DB

SELECT *
FROM tblServiceAreaRatios
	WHERE [Service Area] IN (SELECT ID FROM 
	(SELECT * FROM MAP_SERVICE_AREA md
	RIGHT JOIN tblServiceAreas td
	ON td.ID = md.LEGACY_ID
	WHERE td.Active = 1) AS ServiceArea
	WHERE LEGACY_ID IS NULL)
*/

