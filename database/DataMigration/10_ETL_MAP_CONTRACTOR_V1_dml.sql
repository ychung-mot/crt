/*** Script to retrieve data from legacy tables 
	and map that data to the new CRT code lookup
	tables.
	
-- retrieve values from Legacy table
SELECT ID, [Contractor Name] 
FROM tblContractors
ORDER BY [Contractor Name]

--retrieve values from CRT Code Table
SELECT CODE_LOOKUP_ID, CODE_NAME 
FROM CRT_CODE_LOOKUP 
WHERE CODE_SET = 'CONTRACTOR'

***/

BEGIN TRANSACTION
IF OBJECT_ID('dbo.MAP_CONTRACTOR', 'U') IS NOT NULL
	DROP TABLE dbo.MAP_CONTRACTOR;
COMMIT
GO

BEGIN TRANSACTION

CREATE TABLE dbo.MAP_CONTRACTOR
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

DECLARE ct_cursor CURSOR FOR
	SELECT LegacyCntr.id, LegacyCntr.[Contractor Name], CRT_Cntr.CODE_LOOKUP_ID, CRT_Cntr.CODE_NAME
	FROM
		(SELECT ROW_NUMBER() OVER(ORDER BY [Contractor Name]) AS Row, ID, [Contractor Name] 
		FROM tblContractors) AS LegacyCntr
	JOIN
		(SELECT ROW_NUMBER() OVER(ORDER BY CODE_NAME) AS Row, CODE_LOOKUP_ID, CODE_NAME 
		FROM CRT_CODE_LOOKUP 
		WHERE CODE_SET = 'CONTRACTOR') CRT_Cntr
	ON LegacyCntr.Row = CRT_Cntr.Row

OPEN ct_cursor

WHILE 1 = 1
BEGIN
	FETCH NEXT FROM ct_cursor into @legacyId, @legacyName, @codeId, @codeName;

	IF @@FETCH_STATUS <> 0
	BEGIN
		BREAK;
	END;
	
	--e.g. INSERT INTO MAP_CONTRACTOR VALUES (1, 408); --647354 BC Ltd > 647354 BC Ltd
	SET @cmd = N'INSERT INTO MAP_CONTRACTOR VALUES (' + CAST(@legacyId AS varchar) + ', ' + CAST(@codeId AS varchar) + '); --' + @legacyName + ' > '  + @codeName;

	PRINT @cmd;
	EXEC sp_executesql @cmd;
END;

CLOSE ct_cursor
DEALLOCATE ct_cursor

COMMIT
GO

DECLARE @legacyCnt int, @crtCnt int, @mappedCnt int;

-- retrieve values from Legacy table
SELECT @legacyCnt = COUNT(*) FROM tblContractors

--retrieve values from CRT Code Table
SELECT @crtCnt = COUNT(*) 
FROM CRT_CODE_LOOKUP
WHERE CODE_SET = 'CONTRACTOR'
AND END_DATE IS NULL

SELECT @mappedCnt = COUNT(*) 
FROM MAP_CONTRACTOR

PRINT CHAR(10) + 'Found ' + CONVERT(varchar, @legacyCnt) + ' Legacy Items and ' + CONVERT(varchar, @crtCnt) + ' CRT CodeLookup Items'
PRINT 'Mapped ' + CONVERT(varchar, @mappedCnt) + ' Total Items'

--SELECT * FROM MAP_CONTRACTOR

BEGIN
	DECLARE @missing int;

	SELECT @missing = COUNT(*) 
	FROM tblProjectTenderBids
	WHERE ContractorId IN (SELECT ID FROM 
		(SELECT * FROM MAP_CONTRACTOR mc
		RIGHT JOIN tblContractors tc
		ON tc.ID = mc.LEGACY_ID) AS Contractor
		WHERE LEGACY_ID IS NULL)

	PRINT 'Found ' + CONVERT(varchar, @missing) + ' Project Tender Bids linked to un-mapped Contractors'
END

/*
-- Should find zero

SELECT *
FROM tblProjectTenderBids
WHERE ContractorId IN (SELECT ID FROM 
	(SELECT * FROM MAP_CONTRACTOR mc
	RIGHT JOIN tblContractors tc
	ON tc.ID = mc.LEGACY_ID) AS Contractor
	WHERE LEGACY_ID IS NULL)
*/

