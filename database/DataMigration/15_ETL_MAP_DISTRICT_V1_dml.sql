
/*** Script to retrieve data from legacy tables 
	and map that data to the new CRT code lookup
	tables.

-- retrieve values from Legacy table
SELECT  ID, [Disctrict Description] FROM tblDistricts
WHERE Active = 1

--retrieve values from CRT Code Table
SELECT DISTRICT_ID, DISTRICT_NAME FROM CRT_DISTRICT
WHERE END_DATE IS NULL

***/

BEGIN TRANSACTION

IF OBJECT_ID('dbo.MAP_DISTRICT', 'U') IS NOT NULL
	DROP TABLE dbo.MAP_DISTRICT;
COMMIT
GO

BEGIN TRANSACTION

CREATE TABLE dbo.MAP_DISTRICT
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

DECLARE dis_cursor CURSOR FOR
	SELECT td.ID, td.[Disctrict Description], cd.DISTRICT_ID, cd.DISTRICT_NAME
	FROM CRT_DISTRICT cd
	JOIN tblDistricts td
	ON td.[District Number] = cd.DISTRICT_NUMBER
	AND cd.END_DATE IS NULL
	ORDER BY cd.DISTRICT_NUMBER, td.[District Number]

OPEN dis_cursor

WHILE 1 = 1
BEGIN
	FETCH NEXT FROM dis_cursor into @legacyId, @legacyName, @codeId, @codeName;

	IF @@FETCH_STATUS <> 0
	BEGIN
		BREAK;
	END;
	
	--INSERT INTO MAP_DISTRICT VALUES (6, 6);  --Capitalizable/Expense-Some components<15yrs

	SET @cmd = N'INSERT INTO MAP_DISTRICT VALUES (' + CAST(@legacyId AS varchar) + ', ' + CAST(@codeId AS varchar) + '); --' + @codeName;

	PRINT @cmd;
	EXEC sp_executesql @cmd;
END;

CLOSE dis_cursor
DEALLOCATE dis_cursor

COMMIT
GO

DECLARE @legacyCnt int, @crtCnt int, @mappedCnt int;

-- retrieve values from Legacy table
SELECT @legacyCnt = COUNT(*) 
FROM tblDistricts
WHERE Active = 1

--retrieve values from CRT Code Table
SELECT @crtCnt = COUNT(*) 
FROM CRT_DISTRICT
WHERE END_DATE IS NULL

SELECT @mappedCnt = COUNT(*) 
FROM MAP_DISTRICT

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy Items and ' + CONVERT(varchar, @crtCnt) + ' CRT District Items'
PRINT 'Mapped ' + CONVERT(varchar, @mappedCnt) + ' Total Items'

--SELECT * FROM MAP_DISTRICT

BEGIN
	DECLARE @missing int;

	SELECT @missing = COUNT(*) 
	FROM tblDistrictRatios
	WHERE District IN (SELECT ID FROM 
		(SELECT * FROM MAP_DISTRICT md
		RIGHT JOIN tblDistricts td
		ON td.ID = md.LEGACY_ID
		WHERE td.Active = 1) AS District
		WHERE LEGACY_ID IS NULL)

	PRINT 'Found ' + CONVERT(varchar, @missing) + ' Project Ratios linked to un-mapped Ratio District'
END

/*
-- Should be zero unmaps found!

SELECT *
FROM tblDistrictRatios
WHERE District IN (SELECT ID FROM 
	(SELECT * FROM MAP_DISTRICT md
	RIGHT JOIN tblDistricts td
	ON td.ID = md.LEGACY_ID
	WHERE td.Active = 1) AS District
	WHERE LEGACY_ID IS NULL)
*/



