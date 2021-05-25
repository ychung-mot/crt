/*** Script to retrieve data from legacy tables 
	and map that data to the new CRT code lookup
	tables.

  -- retrieve values from Legacy table
SELECT ID, [Type] FROM tblForecastTypes
WHERE Active = 1
ORDER BY [Type] ASC

--retrieve values from CRT Code Table
SELECT CODE_LOOKUP_ID, CODE_NAME FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'FUNDING_TYPE'
AND END_DATE IS NULL

***/

BEGIN TRANSACTION
GO
IF OBJECT_ID('dbo.MAP_FUNDING_TYPE', 'U') IS NOT NULL
	DROP TABLE dbo.MAP_FUNDING_TYPE;
COMMIT

BEGIN TRANSACTION
GO
CREATE TABLE dbo.MAP_FUNDING_TYPE
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

DECLARE ft_cursor CURSOR FOR
	SELECT ft.ID, ft.Type, cl.CODE_LOOKUP_ID, cl.CODE_NAME
	FROM CRT_CODE_LOOKUP cl
	JOIN tblForecastTypes ft
	ON ft.Type = cl.CODE_NAME
	WHERE cl.CODE_SET = 'FUNDING_TYPE'
	AND cl.END_DATE IS NULL
	AND Active = 1
	ORDER BY cl.CODE_NAME, ft.Type

OPEN ft_cursor

WHILE 1 = 1
BEGIN
	FETCH NEXT FROM ft_cursor into @legacyId, @legacyName, @codeId, @codeName;

	IF @@FETCH_STATUS <> 0
	BEGIN
		BREAK;
	END;
	
	--e.g. INSERT INTO MAP_FUNDING_TYPE VALUES (1, 509); --Allocation
	SET @cmd = N'INSERT INTO MAP_FUNDING_TYPE VALUES (' + CAST(@legacyId AS varchar) + ', ' + CAST(@codeId AS varchar) + '); --' + @codeName;

	PRINT @cmd;
	EXEC sp_executesql @cmd;
END;

CLOSE ft_cursor
DEALLOCATE ft_cursor

COMMIT
GO

DECLARE @legacyCnt int, @crtCnt int, @mappedCnt int;

-- retrieve values from Legacy table
SELECT @legacyCnt = COUNT(*) FROM tblForecastTypes
WHERE Active = 1

--retrieve values from CRT Code Table
SELECT @crtCnt = COUNT(*) 
FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'FUNDING_TYPE'
AND END_DATE IS NULL

SELECT @mappedCnt = COUNT(*) 
FROM MAP_FUNDING_TYPE

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy Items and ' + CONVERT(varchar, @crtCnt) + ' CRT CodeLookup Items'
PRINT 'Mapped ' + CONVERT(varchar, @mappedCnt) + ' Total Items'

--SELECT * FROM MAP_FUNDING_TYPE

BEGIN
	DECLARE @missing int;

	SELECT @missing = COUNT(*) 
	FROM tblFinancialForecast
	WHERE [Forecast Type] IN (SELECT ID FROM 
		(SELECT * FROM MAP_FUNDING_TYPE mft
		RIGHT JOIN tblForecastTypes tft
		ON tft.ID = mft.LEGACY_ID
		WHERE tft.Active = 1) AS FundingType
		WHERE LEGACY_ID IS NULL)

	PRINT 'Found ' + CONVERT(varchar, @missing) + ' Financial Forecasts linked to un-mapped Funding Types'
END

/*
-- Should find zero

SELECT *
FROM tblFinancialForecast
WHERE [Forecast Type] IN (SELECT ID FROM 
	(SELECT * FROM MAP_FUNDING_TYPE mft
	RIGHT JOIN tblForecastTypes tft
	ON tft.ID = mft.LEGACY_ID
	WHERE tft.Active = 1) AS FundingType
	WHERE LEGACY_ID IS NULL)
*/