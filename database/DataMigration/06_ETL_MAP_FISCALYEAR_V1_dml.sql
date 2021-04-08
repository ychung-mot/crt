/*** Script to retrieve data from legacy tables 
	and map that data to the new CRT code lookup
	tables.

  -- retrieve values from Legacy table
SELECT ID, [FiscalYear] FROM tblFiscalYears
WHERE Active = 1
AND [Use For Selection] = 1
ORDER BY [FiscalYear] DESC

--retrieve values from CRT Code Table
SELECT CODE_LOOKUP_ID, CODE_NAME FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'FISCAL_YEAR'
AND END_DATE IS NULL

***/

BEGIN TRANSACTION
GO
IF OBJECT_ID('dbo.MAP_FISCAL_YEAR', 'U') IS NOT NULL
	DROP TABLE dbo.MAP_FISCAL_YEAR;
COMMIT

BEGIN TRANSACTION
GO
CREATE TABLE dbo.MAP_FISCAL_YEAR
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

DECLARE fy_cursor CURSOR FOR
	SELECT fy.ID, fy.[FiscalYear], cl.CODE_LOOKUP_ID, cl.CODE_NAME
	FROM CRT_CODE_LOOKUP cl
	JOIN tblFiscalYears fy
	ON fy.[FiscalYear] = cl.CODE_NAME
	WHERE cl.CODE_SET = 'FISCAL_YEAR'
	AND cl.END_DATE IS NULL
	AND Active = 1
	AND [Use For Selection] = 1
	ORDER BY cl.CODE_NAME, fy.[FiscalYear]

OPEN fy_cursor

WHILE 1 = 1
BEGIN
	FETCH NEXT FROM fy_cursor into @legacyId, @legacyName, @codeId, @codeName;

	IF @@FETCH_STATUS <> 0
	BEGIN
		BREAK;
	END;
	
	--e.g. INSERT INTO MAP_FISCAL_YEAR VALUES (13, 358); --2016/2017
	SET @cmd = N'INSERT INTO MAP_FISCAL_YEAR VALUES (' + CAST(@legacyId AS varchar) + ', ' + CAST(@codeId AS varchar) + '); --' + @codeName;

	PRINT @cmd;
	EXEC sp_executesql @cmd;
END;

--manually map the legacy FY value of Shelf Ready to new value TBD
INSERT INTO MAP_FISCAL_YEAR VALUES (32, (SELECT CODE_LOOKUP_ID FROM CRT_CODE_LOOKUP WHERE CODE_SET = 'FISCAL_YEAR' AND CODE_NAME = 'TBD'));

CLOSE fy_cursor
DEALLOCATE fy_cursor

COMMIT
GO

DECLARE @legacyCnt int, @crtCnt int, @mappedCnt int;

-- retrieve values from Legacy table
SELECT @legacyCnt = COUNT(*) FROM tblFiscalYears
WHERE Active = 1
AND [Use For Selection] = 1

--retrieve values from CRT Code Table
SELECT @crtCnt = COUNT(*) 
FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'FISCAL_YEAR'
AND END_DATE IS NULL

SELECT @mappedCnt = COUNT(*) 
FROM MAP_FISCAL_YEAR

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy Items and ' + CONVERT(varchar, @crtCnt) + ' CRT CodeLookup Items'
PRINT 'Mapped ' + CONVERT(varchar, @mappedCnt) + ' Total Items'

--SELECT * FROM MAP_FISCAL_YEAR

BEGIN
	DECLARE @missing int;

	SELECT @missing = COUNT(*) 
	FROM tblFinancialForecast
	WHERE [Fiscal Year] IN (SELECT ID FROM 
		(SELECT * FROM MAP_FISCAL_YEAR mfy
		RIGHT JOIN tblFiscalYears tfy
		ON tfy.ID = mfy.LEGACY_ID
		WHERE tfy.Active = 1) AS FiscalYear
		WHERE LEGACY_ID IS NULL)

	PRINT 'Found ' + CONVERT(varchar, @missing) + ' Financial Forecasts linked to un-mapped Fiscal Years'
END

/*
-- Should find zero

SELECT *
FROM tblFinancialForecast
WHERE [Fiscal Year] IN (SELECT ID FROM 
	(SELECT * FROM MAP_FISCAL_YEAR mfy
	RIGHT JOIN tblFiscalYears tfy
	ON tfy.ID = mfy.LEGACY_ID
	WHERE tfy.Active = 1) AS FiscalYear
	WHERE LEGACY_ID IS NULL)
*/